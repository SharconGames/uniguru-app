import { Chat, Chatbot, User } from "../models/User.js"; // Import the models
import { createToken } from "../utils/token_manager.js";
import { COOKIE_NAME } from "../utils/constants.js";
import { sendResetPasswordEmail } from "../utils/email_service.js";
import bcrypt from 'bcryptjs';
import { createDefaultGuru } from "./gurus_controllers.js"; // Import the updated createDefaultGuru function
import emailExistence from "email-existence"; // Import the email-existence library
import dotenv from "dotenv";
dotenv.config();
// Get all users
const getAllUsers = async (req, res, next) => {
    try {
        const users = await User.find().populate({
            path: "chats",
            populate: {
                path: "messages",
            },
        });
        return res.status(200).json({ message: "OK", users });
    }
    catch (error) {
        console.log(error);
        return res.status(500).json({ message: "ERROR", cause: error.message });
    }
};
const userSignup = async (req, res, next) => {
    try {
        const { name, email, password } = req.body;
        // Check if email exists on the internet
        const emailExists = await new Promise((resolve, reject) => {
            emailExistence.check(email, (error, response) => {
                if (error)
                    return reject(error);
                resolve(response);
            });
        });
        if (!emailExists) {
            return res.status(400).json({ message: "Invalid email address" });
        }
        // Check if the user already exists
        const existingUser = await User.findOne({ email });
        if (existingUser) {
            return res.status(400).json({ message: "User already exists" });
        }
        // Hash the password before saving
        const saltRounds = 10;
        const hashedPassword = await bcrypt.hash(password, saltRounds);
        // Create the new user with the hashed password
        const newUser = new User({ name, email, password: hashedPassword });
        await newUser.save();
        console.log("New User ID:", newUser._id);
        // Create the default "UniGuru" chatbot and chat session
        const { chatbotId, chatId } = await createDefaultGuru(newUser._id.toString());
        // Add the default chatbot and chat to the user's document
        newUser.chatbots = [chatbotId];
        newUser.chats = [chatId];
        await newUser.save();
        // Clear previous cookies and set a new token
        res.clearCookie(COOKIE_NAME, {
            httpOnly: true,
            signed: true,
            sameSite: "none",
            secure: true,
        });
        const token = createToken(newUser._id.toString(), newUser.email, "7d");
        const expires = new Date();
        expires.setDate(expires.getDate() + 7);
        res.cookie(COOKIE_NAME, token, {
            expires,
            httpOnly: true,
            signed: true,
            sameSite: "none",
            secure: true,
        });
        // Return response with user data and chat session details
        return res.status(201).json({
            message: "User created successfully",
            name: newUser.name,
            email: newUser.email,
            id: newUser._id,
            navigateUrl: `/uniguru/c/${chatId}`,
            chatbotId, // Include chatbot ID in response
            token
        });
    }
    catch (error) {
        console.log("Signup Error:", error);
        return res.status(500).json({ message: "Error", cause: error.message });
    }
};
// User login
const userLogin = async (req, res, next) => {
    try {
        const { email, password } = req.body;
        // Check if user exists
        const user = await User.findOne({ email });
        if (!user) {
            return res.status(401).send("User not registered");
        }
        // Compare password with the hashed password in the database
        const isPasswordCorrect = await bcrypt.compare(password, user.password);
        if (!isPasswordCorrect) {
            return res.status(403).send("Incorrect Password");
        }
        // Find the UniGuru chatbot associated with the user
        const uniGuru = await Chatbot.findOne({ user: user._id, name: "UniGuru" });
        if (!uniGuru) {
            return res.status(404).send("UniGuru chatbot not found");
        }
        // Find all chat sessions associated with UniGuru (sorted by creation date)
        const chatSessions = await Chat.find({ user: user._id, chatbot: uniGuru._id })
            .sort({ createdAt: 1 }) // Sort by creation date in ascending order
            .populate("messages");
        // Check if there are any chat sessions
        if (chatSessions.length === 0) {
            return res.status(404).send("No chat session found for UniGuru");
        }
        // Select the first chat session from the sorted array
        const chatSession = chatSessions[0];
        res.clearCookie(COOKIE_NAME, {
            httpOnly: true,
            signed: true,
            sameSite: "none",
            secure: true,
        });
        // Create token and store cookie
        const token = createToken(user._id.toString(), user.email, "7d");
        const expires = new Date();
        expires.setDate(expires.getDate() + 7);
        res.cookie(COOKIE_NAME, token, {
            httpOnly: true, // Ensures the cookie is only accessible via HTTP (not JavaScript)
            signed: true, // Indicates the cookie is signed
            sameSite: 'strict', // Prevents the cookie from being sent on cross-site requests
            secure: process.env.NODE_ENV === 'production', // Only sends cookies over HTTPS in production
            maxAge: 1000 * 60 * 60 * 24, // Example expiration time (1 day)
        });
        console.log(token);
        // Return the response with user data and chat session details
        return res.status(200).json({
            message: "OK",
            name: user.name,
            email: user.email,
            id: user._id,
            navigateUrl: `/uniguru/c/${chatSession.id}`, // Redirect to the chat session
            chatId: chatSession._id,
            chatbotId: uniGuru.id,
            token
        });
    }
    catch (error) {
        console.error("Login error:", error);
        return res.status(500).json({ message: "ERROR", cause: error.message });
    }
};
// Verify user
const verifyUser = async (req, res, next) => {
    try {
        const user = await User.findById(res.locals.jwtData.id);
        if (!user) {
            return res.status(401).send("User not registered OR Token malfunctioned");
        }
        if (user._id.toString() !== res.locals.jwtData.id) {
            return res.status(401).send("Permissions didn't match");
        }
        console.log(user);
        return res.status(200).json({
            message: "OK",
            name: user.name,
            email: user.email,
            id: user._id,
        });
    }
    catch (error) {
        console.log(error);
        return res.status(500).json({ message: "ERROR", cause: error.message });
    }
};
// User logout
const userLogout = async (req, res, next) => {
    try {
        // Access the decoded token data from res.locals
        const userData = res.locals.jwtData;
        console.log(userData);
        if (!userData) {
            return res.status(401).json({
                message: "No user data found",
                success: false
            });
        }
        // Clear the cookie
        res.clearCookie(COOKIE_NAME, {
            httpOnly: true,
            signed: true,
            sameSite: 'strict', // Changed from 'none'
            secure: process.env.NODE_ENV === 'production', // Conditional secure flag
        });
        return res.status(200).json({
            message: "Logout successful",
            success: true,
            redirect: "/login"
        });
    }
    catch (error) {
        console.error("Logout Error:", error);
        return res.status(500).json({
            message: "Internal server error during logout",
            success: false,
            error: error instanceof Error ? error.message : 'Unknown error'
        });
    }
};
// Forgot password
const forgotPassword = async (req, res, next) => {
    try {
        const email = req.body.email;
        // Check if the email exists on the internet
        emailExistence.check(email, async (error, response) => {
            if (error) {
                console.log("Email existence check error:", error);
                return res.status(500).json({ message: "Error checking email existence" });
            }
            if (!response) {
                return res.status(400).json({ message: "Invalid email address" });
            }
            const user = await User.findOne({ email });
            if (!user)
                return res.status(404).send("User not found");
            // Generate and send reset password token
            const resetToken = createToken(user._id.toString(), email, "1h"); // Token valid for 1 hour
            await sendResetPasswordEmail(user.email, resetToken);
            return res.status(200).json({ message: "Reset password link sent" });
        });
    }
    catch (error) {
        console.log(error);
        return res.status(500).json({ message: "ERROR", cause: error.message });
    }
};
export { userSignup, userLogin, verifyUser, userLogout, forgotPassword, getAllUsers };
//# sourceMappingURL=user_controllers.js.map