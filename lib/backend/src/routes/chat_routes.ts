import { Router } from "express";
import {
    chatCompletionValidator,
    chatIdValidator,
    userIdValidator,
    validate,
} from "../utils/validators.js";
import { verifyToken } from "../utils/token_manager.js";
import {
    clearChatMessages,
    deleteChatSession,
    deleteAllChatSessions,
    generateChatCompletion,
    sendChatsToUser,
    getUserChats,
    createOrGetChatSession,
    getChatSession,
    updateChatTitleController,
    generateChatTitle,
} from "../controllers/chat_controllers.js";

const chatRoutes = Router();

// Route for starting a new chat session
chatRoutes.post(
    "/start",
    // verifyToken, // Uncomment if you need to verify the token
    validate(userIdValidator), // This will validate userId before passing to the controller
    async (req, res) => {
      const { userId, chatbotId, createNewSession } = req.body; // Extract userId, chatbotId, createNewSession from the request body
  
      console.log("Received userId:", userId); // Log the userId to ensure it's passed correctly
  
      try {
        // Call the createOrGetChatSession function with the extracted values
        const chatSession = await createOrGetChatSession({
          userId,
          chatbotId,
          createNewSession,
        });
        res.status(200).json(chatSession); // Return the chat session as a response
      } catch (error) {
        console.error("Error creating chat session:", error);
        res.status(400).json({ error: error.message }); // Return error if something goes wrong
      }
    }
  );
  

// Route for generating chat completion (getting response from chatbot)
chatRoutes.post(
    "/new",
    validate(chatCompletionValidator),
    generateChatCompletion
);


// Route for getting chat history for a specific user
chatRoutes.get(
    "/users/:userId",
    verifyToken,
    validate(userIdValidator),
    getUserChats
);

chatRoutes.get(
    "/:chatId/:userId",
    // verifyToken,
    getChatSession
)

chatRoutes.put('/u-t' , updateChatTitleController)

// Route for retrieving all chats for the authenticated user
chatRoutes.get(
    "/all",
  
    sendChatsToUser
);

// Route for clearing messages in a specific chat
chatRoutes.post(
    "/:chatId/clear",
    
    validate(chatIdValidator),
    clearChatMessages
);

chatRoutes.post('/generate-chat-title', async (req, res) => {
    const { chatId, userId, message, model, chatbotId } = req.body;
  
    // Validate the request body
    if (!chatId || !userId || !message || !model || !chatbotId) {
      return res.status(400).json({ error: 'Missing required fields' });
    }
  
    try {
      // Call the generateChatTitle function
      const updatedTitle = await generateChatTitle(chatId, userId, message, model, chatbotId);
  
      // Return the updated title as the response
      res.status(200).json({ title: updatedTitle });
    } catch (error) {
      console.error('Error generating chat title:', error);
      res.status(500).json({ error: error.message });
    }
  });

// Route for deleting a specific chat session
chatRoutes.delete(
    "/:chatId",
   
    validate(chatIdValidator),
    deleteChatSession
);

// Route for deleting all chats for the authenticated user
chatRoutes.delete(
    "/all",
    deleteAllChatSessions
);

// Error handling middleware for all routes
chatRoutes.use((err, req, res, next) => {
    console.error(err.stack);
    // Customize error handling based on known error types
    if (err.name === "ValidationError") {
        return res.status(400).json({ message: err.message });
    }
    res.status(500).json({ message: "Something went wrong", error: err.message });
});

export default chatRoutes;
