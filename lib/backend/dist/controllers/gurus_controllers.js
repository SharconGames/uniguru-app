import { Chat, Chatbot, User } from "../models/User.js";
import mongoose from "mongoose";
import { createOrGetChatSession } from "./chat_controllers.js";
export const getAllGurus = async (req, res, next) => {
    try {
        const userId = req.params.userId;
        if (!userId) {
            return res.status(401).json({ message: "User not authenticated." });
        }
        // Populate the 'chats' field and ensure it returns IChat objects
        const chatbots = await Chatbot.find({ user: userId })
            .populate('chats') // This will populate the chats field with IChat objects
            .exec();
        if (!chatbots.length) {
            return res.status(404).json({ message: "No chatbots found for this user." });
        }
        // Map over the chatbots to extract chat IDs from populated 'chats'
        const chatbotDetails = chatbots.map((chatbot) => {
            // Type assertion to ensure chats are populated and are of type IChat[]
            const chatIds = chatbot.chats.map((chat) => chat._id); // Extract _id from each populated IChat
            console.log(chatIds);
            return {
                id: chatbot._id,
                name: chatbot.name,
                description: chatbot.description,
                subject: chatbot.subject,
                userId: chatbot.user,
                chatIds: chatIds, // Return the array of chat IDs
            };
        });
        return res.status(200).json({ chatbots: chatbotDetails });
    }
    catch (error) {
        console.error("Error in getAllGurus:", error);
        return res.status(500).json({ message: "Server error.", error: error.message });
    }
};
export const newGuru = async (req, res, next) => {
    const { name, description, subject } = req.body;
    const userId = req.params.userId;
    console.log(userId);
    if (!userId) {
        return res.status(401).json({ message: "User not authenticated." });
    }
    try {
        const user = await User.findById(userId);
        if (!user) {
            return res.status(404).json({ message: "User not found." });
        }
        if (!name || !description || !subject) {
            return res.status(400).json({ message: "All fields are required." });
        }
        // Sanitize the name: remove spaces, special characters, and ensure lowercase alphabets only
        const sanitizedName = name.replace(/[^a-zA-Z]/g, "").toLowerCase();
        if (!sanitizedName) {
            return res
                .status(400)
                .json({ message: "Name must contain only alphabets." });
        }
        // Create a new chatbot (Guru)
        const newChatbot = new Chatbot({
            name: sanitizedName,
            description,
            subject,
            user: userId,
        });
        await newChatbot.save();
        // Call createOrGetChatSession with createNewSession set to true
        const { chatId, title } = await createOrGetChatSession({
            userId,
            chatbotId: newChatbot._id.toString(),
            createNewSession: true, // This will trigger the creation of a new session
        });
        // Push the chatId to the chatbot's chats array (not assign)
        newChatbot.chats.push(chatId);
        // Save the updated chatbot
        await newChatbot.save();
        // Return the response with the new chatbot and chat session
        return res.status(201).json({
            message: "Chatbot and chat session created successfully.",
            chatbot: newChatbot,
            chatId: chatId,
            title: title,
            navigateUrl: `/${newChatbot.name}/c/${chatId}`,
        });
    }
    catch (error) {
        console.error("Error in newGuru:", error);
        return res.status(500).json({ message: "Server error.", error: error.message });
    }
};
export const getAllChatsOfGuru = async (req, res, next) => {
    const chatbotid = req.params.chatbotid;
    try {
        // Validate chatbot ID
        if (!mongoose.Types.ObjectId.isValid(chatbotid)) {
            return res.status(400).json({ message: "Invalid chatbot ID." });
        }
        // Find the chatbot (guru) by ID
        const chatbot = await Chatbot.findById(chatbotid);
        if (!chatbot) {
            return res.status(404).json({ message: "Chatbot not found." });
        }
        // Find all chats associated with the chatbot
        const chats = await Chat.find({ chatbot: chatbotid })
            .populate("user", "name email") // Populate user details
            .select("title"); // Select only the title field
        if (!chats.length) {
            return res.status(404).json({ message: "No chats found for this chatbot." });
        }
        // Return the list of chats with their titles
        return res.status(200).json({
            message: "Chats retrieved successfully.",
            chats: chats.map((chat) => ({
                chatId: chat._id,
                title: chat.title,
                user: chat.user.id,
            })),
        });
    }
    catch (error) {
        console.error("Error in getAllChatsOfGuru:", error);
        return res.status(500).json({ message: "Server error.", error: error.message });
    }
};
export const getChatOfGuru = async (req, res, next) => {
    const chatId = req.params.chatId;
    try {
        // Validate the chatId
        if (!mongoose.Types.ObjectId.isValid(chatId)) {
            return res.status(400).json({ message: "Invalid chat ID." });
        }
        // Find the chat by chatId
        const chat = await Chat.findById(chatId)
            .populate("user", "name email")
            .populate("chatbot", "name description");
        if (!chat) {
            return res.status(404).json({ message: "Chat not found." });
        }
        // Return the found chat and its messages
        return res.status(200).json({ chat, messages: chat.messages });
    }
    catch (error) {
        console.error("Error in getChatOfGuru:", error);
        return res.status(500).json({ message: "Server error.", error: error.message });
    }
};
export const deleteChatSession = async (req, res, next) => {
    const { chatbotid, chatid } = req.params;
    try {
        if (!mongoose.Types.ObjectId.isValid(chatbotid) || !mongoose.Types.ObjectId.isValid(chatid)) {
            return res.status(400).json({ message: "Invalid chatbot ID or chat ID." });
        }
        const chatbot = await Chatbot.findById(chatbotid);
        if (!chatbot) {
            return res.status(404).json({ message: "Chatbot not found." });
        }
        const chat = await Chat.findById(chatid);
        if (!chat || chat.chatbot.toString() !== chatbotid) {
            return res.status(404).json({ message: "Chat session not found for this chatbot." });
        }
        await User.updateOne({ _id: chat.user }, { $pull: { chats: chat._id } });
        chatbot.chats = chatbot.chats.filter((id) => id.toString() !== chatid);
        await chatbot.save();
        await chat.deleteOne();
        return res.status(200).json({ message: "Chat session deleted successfully." });
    }
    catch (error) {
        console.error("Error in deleteChatSession:", error);
        return res.status(500).json({ message: "Server error.", error: error.message });
    }
};
export const deleteChatbot = async (req, res, _next) => {
    const chatbotid = req.params.chatbotid;
    try {
        if (!mongoose.Types.ObjectId.isValid(chatbotid)) {
            return res.status(400).json({ message: "Invalid chatbot ID." });
        }
        const chatbot = await Chatbot.findById(chatbotid);
        if (!chatbot) {
            return res.status(404).json({ message: "Chatbot not found." });
        }
        const userId = chatbot.user.toString();
        const chats = await Chat.find({ chatbot: chatbotid });
        for (const chat of chats) {
            await User.updateOne({ _id: chat.user }, { $pull: { chats: chat._id } });
        }
        await Chat.deleteMany({ chatbot: chatbotid });
        await chatbot.deleteOne();
        const remainingChatbots = await Chatbot.find({ user: userId });
        if (remainingChatbots.length === 0) {
            return res.status(200).json({
                message: "Chatbot and associated chats deleted. Default guru 'Uni' created.",
            });
        }
        return res.status(200).json({
            message: "Chatbot and associated chats deleted successfully."
        });
    }
    catch (error) {
        console.error("Error in deleteChatbot:", error);
        return res.status(500).json({ message: "Server error.", error: error.message });
    }
};
export const createDefaultGuru = async (userId) => {
    try {
        // Check if a chatbot named "UniGuru" already exists for this user
        let chatbot = await Chatbot.findOne({ user: userId, name: 'UniGuru' });
        if (!chatbot) {
            // Create a new "UniGuru" chatbot if it doesn't exist
            chatbot = new Chatbot({
                name: 'UniGuru',
                subject: 'General Knowledge',
                description: 'A versatile Guru for general queries.',
                user: userId,
            });
            await chatbot.save();
        }
        // Ensure at least one chat session exists for this chatbot
        const firstChatId = chatbot.chats.length
            ? chatbot.chats[0] // Use the first existing chat
            : (await createOrGetChatSession({
                userId,
                chatbotId: chatbot._id.toString(),
                createNewSession: true,
            })).chatId; // Create a new chat session if none exist
        // Validate the existence of the chat session
        const chatExists = await Chat.findById(firstChatId);
        if (!chatExists) {
            throw new Error(`Chat session with ID ${firstChatId} not found.`);
        }
        // Link the first chat to the chatbot if it was newly created
        if (!chatbot.chats.includes(firstChatId)) {
            chatbot.chats.push(firstChatId);
            await chatbot.save();
        }
        // Construct the navigate URL
        const navigateUrl = `/${chatbot.name}/c/${firstChatId}`;
        console.log(navigateUrl);
        // Return chatbotId, chatId, and navigateurl
        return {
            chatbotId: chatbot._id.toString(),
            chatId: firstChatId.toString(),
            navigateurl: navigateUrl,
        };
    }
    catch (error) {
        throw new Error(`Error creating or fetching UniGuru: ${error.message}`);
    }
};
//# sourceMappingURL=gurus_controllers.js.map