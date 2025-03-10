import { Router } from "express";
import { verifyToken } from "../utils/token_manager.js";
import { getAllGurus, newGuru } from "../controllers/gurus_controllers.js";
//Protected API
const chatbotRoutes = Router();
chatbotRoutes.post("/new-chatbot", verifyToken, newGuru);
chatbotRoutes.get("/get-chatbot", verifyToken, getAllGurus);
export default chatbotRoutes;
//# sourceMappingURL=chatbot_routes.js.map