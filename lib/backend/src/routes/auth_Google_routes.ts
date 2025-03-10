import express, { Request, Response, NextFunction } from 'express';
import { User, IUser, Chat } from '../models/User.js'; // Adjust the path if necessary
import { createToken } from '../utils/token_manager.js'; // Adjust the path if necessary
import dotenv from 'dotenv';
import passport from 'passport';
import axios from 'axios';
import { COOKIE_NAME } from '../utils/constants.js';
import { createDefaultGuru } from '../controllers/gurus_controllers.js';

dotenv.config();

const router = express.Router();

// Centralized Error Handler
const handleError = (res: Response, error: any, message = "Internal Server Error") => {
  console.error(error);
  return res.status(500).json({ message, cause: error.message });
};

// Forward the request to Google's authentication server
router.get('/google', passport.authenticate('google', { scope: ['profile', 'email'] }));

// Handle the callback after Google has authenticated the user
// Handle the callback after Google has authenticated the user
router.get(
  '/google/callback',
  passport.authenticate('google', { session: false }),
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      if (req.user) {
        // Extract user information
        const user = req.user as unknown as IUser;

        // Create token and set it in a cookie
        const token = createToken(user._id.toString(), user.email, "7d");
        console.log(token);

        // Define a default navigateUrl or compute based on user context
        const navigateUrl = `${process.env.FRONTEND_Url}?token=${token}`;

        // Redirect to client with token and navigateUrl
        res.redirect(`${process.env.FRONTEND_Url}?token=${token}&navigateUrl=${encodeURIComponent(navigateUrl)}`);
      } else {
        // Authentication failed
        res.redirect(`${process.env.FRONTEND_Url}/login/failed`);
      }
    } catch (error) {
      next(error);
    }
  }
);


// Login failed
router.get('/login/failed', (req: Request, res: Response) => {
  return res.status(401).json({ message: 'Login Failed' });
});

// Logout
router.get('/logout', (req: Request, res: Response) => {
  req.logout((err: Error) => {
    if (err) {
      console.error(err);
      return handleError(res, err, "Logout Failed");
    }
    res.clearCookie(COOKIE_NAME, { path: '/', secure: true, sameSite: 'none' });
    return res.redirect('/');
  });
});

router.post('/google/token', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { token, email, name, picture } = req.body;

    // Check if the user already exists
    let user = await User.findOne({ email });
    let navigateUrl;

    if (!user) {
      // Create new user
      user = new User({
        name,
        email,
        picture,
        password: Date.now().toString(),
      });
      await user.save();

      // Create default guru for new user
      const userId = user._id;
      const guruResult = await createDefaultGuru(userId);
      navigateUrl = guruResult.navigateurl;
    } else {
      // For existing users, get their last chat URL or create a new one
      const lastChat = await Chat.findOne({ userId: user._id }).sort({ createdAt: -1 });
      if (lastChat) {
        navigateUrl = `/chat/${lastChat._id}`;
      } else {
        const guruResult = await createDefaultGuru(user._id);
        navigateUrl = guruResult.navigateurl;
      }
    }

    // Create and set token
    const userToken = createToken(user._id.toString(), user.email, '7d');
    const expires = new Date();
    expires.setDate(expires.getDate() + 7);

    res.cookie(COOKIE_NAME, userToken, {
      expires,
      httpOnly: true,
      signed: true,
      sameSite: 'none',
      secure: true
    });

    return res.status(200).json({
      message: 'OK',
      token: userToken,
      user: {
        id: user._id,
        email: user.email,
        name: user.name,
      },
      navigateUrl
    });
  } catch (error) {
    next(error);
  }
});


export default router;