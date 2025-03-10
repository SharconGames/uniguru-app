import { Chatbot, User } from '../models/User.js';
export const getAllChatbots = async (req, res, next) => {
    try {
        // Assuming req.user contains the logged-in user's data
        const userId = await User.findById(res.locals.jwtData.id);
        if (!userId) {
            return res.status(401).json({ message: "User not registered OR Token malfunctioned" });
        }
        if (!userId) {
            return res.status(400).json({ message: 'User not found' });
        }
        // Find chatbots created by the logged-in user
        const chatbots = await Chatbot.find({ createdBy: userId }); // Adjust query based on your schema
        return res.status(200).json({ chatbots });
    }
    catch (error) {
        console.error(error);
        return res.status(500).json({ message: 'Something went wrong', error: error.message });
    }
};
export const newChatBot = async (req, res, next) => {
    const { name, description, subject } = req.body;
    try {
        // Create a new chatbot
        const newChatbot = new Chatbot({ name, description, subject });
        await newChatbot.save();
        console.log("Chatbot Created");
        return res.status(200).json({ message: "Chatbot created successfully", chatbot: newChatbot });
    }
    catch (error) {
        console.error(error);
        return res.status(500).json({ message: "Something went wrong", error: error.message });
    }
};
//# sourceMappingURL=chatbot_controllers.js.map