import express from 'express';
import { Chat } from '../models/User.js'; // Adjust the import path according to your file structure
import { Message } from '../models/User.js'; // Adjust the import path according to your file structure
const historyRoutes = express.Router();
// a. Fetch Guru's Chat Histories
historyRoutes.get('/guru/:guruId', async (req, res) => {
    try {
        const chats = await Chat.find({ guru: req.params.guruId }).sort({ createdAt: -1 });
        res.json(chats);
    }
    catch (err) {
        res.status(500).json({ error: 'Failed to fetch chat histories' });
    }
});
// b. Start a New Chat
historyRoutes.post('/guru/:guruId', async (req, res) => {
    try {
        const chat = new Chat({ guru: req.params.guruId });
        await chat.save();
        res.json(chat);
    }
    catch (err) {
        res.status(500).json({ error: 'Failed to start new chat' });
    }
});
// c. Fetch Chat Messages
historyRoutes.get('/:chatId', async (req, res) => {
    try {
        const messages = await Message.find({ chat: req.params.chatId }).sort({ timestamp: 1 });
        res.json(messages);
    }
    catch (err) {
        res.status(500).json({ error: 'Failed to fetch chat messages' });
    }
});
// d. Add Message to Chat
historyRoutes.post('/:chatId/message', async (req, res) => {
    try {
        const { sender, content } = req.body;
        const message = new Message({ chat: req.params.chatId, sender, content });
        await message.save();
        res.json(message);
    }
    catch (err) {
        res.status(500).json({ error: 'Failed to send message' });
    }
});
export default historyRoutes;
//# sourceMappingURL=history.js.map