import { Router } from "express";
import { deleteChatbot, getAllGurus, getChatOfGuru, newGuru, getAllChatsOfGuru, // Import the new controller function
 } from "../controllers/gurus_controllers.js";
// Protected API
const gurusRoutes = Router();
// Route for creating a new chatbot and its associated chat session
gurusRoutes.post("/n-g/:userId", newGuru); // n-g = new-guru
// Route for getting all chatbots (gurus) associated with the authenticated user
gurusRoutes.get("/g-g/:userId", getAllGurus); // g-g = get-guru
// Route for retrieving a chat session with a specific chatbot
gurusRoutes.get("/g-c/:chatId", getChatOfGuru); // g-c = guru-chat
// Route for retrieving all chats of a particular chatbot (guru) with their titles
gurusRoutes.get("/g-chats/:chatbotid", getAllChatsOfGuru); // g-chats = get-guru-chats
// Route for deleting a chatbot and its associated chat sessions
gurusRoutes.delete('/g-d/:chatbotid', deleteChatbot, (req, res) => {
    res.status(200).json({ message: "Chatbot deleted successfully", chatbotId: req.params.chatbotid });
}); // g-d = guru-delete
export default gurusRoutes;
//# sourceMappingURL=gurus_routes.js.map