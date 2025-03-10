import express, { Request, Response } from "express";
// import User from "../models/User.js";
import jwt from "jsonwebtoken";
import auth from "../middleware/auth.js";
import { createDefaultGuru } from '../controllers/gurus_controllers.js';
import { Chatbot, Chat, Message, User } from '../models/User.js';

interface AuthenticatedRequest extends Request {
    token?: string;
    user?: any;
}

interface SignupResponse {
    user: any;
    token: string;
    chatId?: string;
    chatbotId?: string;
}

const authRouter = express.Router();

authRouter.post('/api/signup', async (req: Request, res: Response) => {
    try {
        const { name, email, profilePic } = req.body;

        let user = await User.findOne({ email: email });
        let isNewUser = false;

        if (!user) {
            user = new User({
                email: email,
                profilePic: profilePic,
                name: name,
                chats: [],
                chatbots: [],
            });

            user = await user.save();
            isNewUser = true;
        }

        const token = jwt.sign({
            id: user._id,
        }, "passwordKey");

        // Create default chatbot and chat for new users
        if (isNewUser) {
            try {
                const chatbot = new Chatbot({
                    name: 'UniGuru',
                    subject: 'General Knowledge',
                    description: 'A versatile Guru for general queries.',
                    user: user._id,
                });
                await chatbot.save();

                const defaultMessage = new Message({
                    sender: 'guru',
                    content: 'How can I help you?',
                    timestamp: new Date(),
                });

                const chat = new Chat({
                    user: user._id,
                    chatbot: chatbot._id,
                    title: 'Welcome Chat',
                    messages: [defaultMessage], // Include the default message
                });
                await chat.save();

                chatbot.chats.push(chat._id);
                await chatbot.save();

                user.chats.push(chat._id);
                user.chatbots.push(chatbot._id);
                await user.save();

                const { navigateurl } = await createDefaultGuru(user._id);

                return res.json({
                    user: user,
                    token: token,
                    chatId: chat._id.toString(),
                    chatbotId: chatbot._id.toString(),
                    navigateurl: navigateurl,
                });
            } catch (error) {
                console.error("Error creating default guru:", error);
                return res.status(500).json({ error: "Error creating default guru and chat" });
            }
        }

        // For existing users, return their first chat and chatbot if they exist
        const { navigateurl, chatId, chatbotId } = await createDefaultGuru(user._id);

        res.json({
            user: user,
            token: token,
            chatId: chatId,
            chatbotId: chatbotId,
            navigateurl: navigateurl,
        });

    } catch (e) {
        console.error("Error in signup:", e);
        res.status(500).json({ error: "Internal server error" });
    }
});

// Auth verification route
authRouter.get('/', auth, async (req: AuthenticatedRequest, res: Response) => {
    try {
        const user = await User.findById(req.user);
        if (!user) {
            return res.status(404).json({ error: "User not found" });
        }

        let chatbot = await Chatbot.findOne({ user: user._id });
        let chat = await Chat.findOne({ user: user._id });

        if (!chatbot || !chat) {
            try {
                if (!chatbot) {
                    chatbot = new Chatbot({
                        name: 'UniGuru',
                        subject: 'General Knowledge',
                        description: 'A versatile Guru for general queries.',
                        user: user._id,
                    });
                    await chatbot.save();
                    user.chatbots.push(chatbot._id);
                }

                if (!chat) {
                    const defaultMessage = new Message({
                        sender: 'guru',
                        content: 'How can I help you?', // Set default message
                        timestamp: new Date(),
                    });

                    chat = new Chat({
                        user: user._id,
                        chatbot: chatbot._id,
                        title: 'Welcome Chat',
                        messages: [defaultMessage], // Include the default message
                    });
                    await chat.save();

                    chatbot.chats.push(chat._id);
                    await chatbot.save();

                    user.chats.push(chat._id);
                }

                await user.save();
            } catch (error) {
                console.error("Error creating default guru and chat:", error);
            }
        }

        res.json({
            user: user,
            token: req.token,
            chatId: chat?._id.toString(),
            chatbotId: chatbot?._id.toString(),
        });
    } catch (error) {
        console.error("Error in auth route:", error);
        res.status(500).json({ error: "Internal server error" });
    }
});

export default authRouter;