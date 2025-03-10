import passport from 'passport';
import { Strategy as GoogleStrategy } from 'passport-google-oauth20';
import { User } from '../models/User.js';
import jwt from 'jsonwebtoken';
const passportUtil = (app) => {
    // Initialize Passport
    app.use(passport.initialize());
    // Configure the Google Strategy
    passport.use(new GoogleStrategy({
        clientID: process.env.GOOGLE_CLIENT_ID,
        clientSecret: process.env.GOOGLE_CLIENT_SECRET,
        callbackURL: process.env.GOOGLE_CALLBACK_URL,
        scope: ['profile', 'email'],
    }, async (accessToken, refreshToken, profile, done) => {
        try {
            // Find or create the user in the database
            let user = await User.findOne({ email: profile._json.email });
            if (!user) {
                // If no user, create one with the Google information
                user = new User({
                    name: profile.displayName,
                    email: profile._json.email,
                    googleId: profile.id, // Store Google ID for future reference
                });
                await user.save();
            }
            else if (!user.googleId) {
                // If user exists but doesn't have a Google ID, update it
                user.googleId = profile.id;
                await user.save();
            }
            // Generate JWT token
            const token = jwt.sign({ userId: user.id, email: user.email }, // Payload with user info
            process.env.JWT_SECRET, // Use your secret key
            { expiresIn: '7d' } // Expire in 1 hour or adjust as needed
            );
            // Return the token and user object for further session handling
            done(null, { user, token });
        }
        catch (error) {
            console.error('Error in Google authentication:', error);
            done(error);
        }
    }));
    // Serialize user to persist authentication (now storing just the user ID)
    passport.serializeUser((user, done) => {
        done(null, user.id);
    });
    // Deserialize user to retrieve user information from session (fetching user from DB)
    passport.deserializeUser(async (id, done) => {
        try {
            const user = await User.findById(id);
            done(null, user);
        }
        catch (error) {
            console.error('Error deserializing user:', error);
            done(error);
        }
    });
};
export default passportUtil;
//# sourceMappingURL=passportjs.js.map