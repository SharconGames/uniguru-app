import express from "express";
import { Message } from "../models/User.js";
const router = express.Router();
// Update message route with edit history
router.put("/messages/:id", async (req, res) => {
    const { id } = req.params;
    const { newContent } = req.body;
    try {
        const message = await Message.findById(id);
        if (message) {
            message.editHistory.push({
                content: message.content,
                editedAt: new Date(),
            });
            message.content = newContent;
            await message.save();
            res.json({ message: "Message updated successfully!" });
        }
        else {
            res.status(404).json({ error: "Message not found!" });
        }
    }
    catch (error) {
        res.status(500).json({ error: "Internal server error" });
    }
});
export default router;
//# sourceMappingURL=edit_message_routes.js.map