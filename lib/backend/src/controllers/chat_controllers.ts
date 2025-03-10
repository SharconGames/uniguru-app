import { Request, Response, NextFunction } from 'express';
import Groq from 'groq-sdk';
import { Chatbot } from '../models/User.js';
import { User, Chat, Message, IChatbot, IMessage } from '../models/User.js';
import { summarizeHistory } from '../utils/summary.js';
import mongoose, { ObjectId } from 'mongoose';

interface Chat {
    chatbot: IChatbot;  // Type as ObjectId or IChatbot, depending on context
    user: ObjectId;
    title:string;
    messages: IMessage[];
}

interface ChatSessionRequest extends Request {
  params: {
    chatId: string;
    userId: string;
  };
}

// Helper function to validate ObjectId
const isValidObjectId = (id: string | number | mongoose.mongo.BSON.ObjectId | Uint8Array | mongoose.mongo.BSON.ObjectIdLike) => mongoose.Types.ObjectId.isValid(id);



const generateAIResponse = async (
    context: string, 
    message: string, 
    chatbot: mongoose.Document<unknown, {}, IChatbot> & IChatbot & { _id: mongoose.Types.ObjectId }, 
    model: string
  ) => {
    const groqClient = new Groq({ apiKey: process.env.GROQ_API_KEY });
  
    // Access chatbot properties
    const { subject, description } = chatbot;
  
    const chatResponse = await groqClient.chat.completions.create({
      messages: [
        {
          role: 'system',
          content: `You are a Guru specialized in ${subject}. Assist users with questions about ${description}. Here is the context: ${context}.`,
        },
        {
          role: 'user',
          content: message,
        },
      ],
      model: model, // Pass the model string here (e.g., "llama-3.3-70b-versatile")
      max_tokens: 8000,
      temperature: 0.9,
    });
  
    return chatResponse.choices[0]?.message?.content || 'No response generated';
  };
  
  
  
  
// Function to update the title of a chat session
export const generateChatTitle = async (chatId: string, userId: string, message: string, model: string, chatbotId: string) => {
  try {
    console.log(chatId, userId, message, model, chatbotId);

    // Find the chat session based on chatId and userId, populate chatbot details
    const chat = await Chat.findOne({ _id: chatId, user: userId }).populate('chatbot');
    console.log("Chat session:", chat);

    if (!chat) {
      throw new Error('Chat session not found');
    }

    const chatbot = chat.chatbot;
    if (!chatbot) {
      throw new Error('Associated chatbot not found');
    }

    // Set up the Groq client to generate a response based on the user's message
    const groqClient = new Groq({ apiKey: process.env.GROQ_API_KEY });

    // Generate a chat title using the user's message and chatbot's subject
    const chatResponse = await groqClient.chat.completions.create({
      messages: [
        {
          role: 'system',
          content: `Based on the user's first message, generate a suitable title for the chat session. The user has asked about "${message}". The chatbot is a Guru specialized in ${chatbot.subject}. Make the title under 4-5 words and relevant.`,
        },
        {
          role: 'user',
          content: message,
        },
      ],
      model: model,
      max_tokens: 200,  // Limit the response to a short title
      temperature: 0.7, // Adjust the temperature for more controlled responses
    });

    // Extract and format the title from the response (limit to first 5 words)
    let newTitle = chatResponse.choices[0]?.message?.content.trim().split(' ').slice(0, 5).join(' ');
    console.log("Generated title:", newTitle);

    if (!newTitle) {
      throw new Error('Failed to generate a new title');
    }

    // Remove special characters from the title (allow only alphanumeric characters and spaces)
    newTitle = newTitle.replace(/[^a-zA-Z0-9 ]/g, '').trim(); // Remove special characters

    // Update the chat's title with the sanitized title
    chat.title = newTitle;
    await chat.save();

    // Return the updated chat title
    return chat.title;

  } catch (error) {
    console.error('Error updating chat title:', error);
    throw new Error(`Failed to generate title: ${error.message}`);
  }
};

  

  
  
// POST route to create a new chat session or retrieve an existing one
export const createOrGetChatSession = async ({
  userId,
  chatbotId,
  createNewSession,
}: {
  userId: string;
  chatbotId: string;
  createNewSession: boolean;
}) => {
  console.log("userId:", userId);
  if (!isValidObjectId(userId)) throw new Error("Invalid user ID provided");

  const user = await User.findById(userId);
  if (!user) throw new Error("User not found");

  let chatbot = null;
  if (!chatbotId) {
    chatbot = await Chatbot.findOne({ name: "UniGuru" });
    if (!chatbot) {
      chatbot = new Chatbot({
        name: "UniGuru",
        subject: "General Knowledge",
        description: "A versatile Guru for general queries.",
        user: userId,
      });
      await chatbot.save();
    }
  } else {
    if (!isValidObjectId(chatbotId)) throw new Error("Invalid chatbot ID provided");
    chatbot = await Chatbot.findById(chatbotId);
    if (!chatbot) throw new Error("Chatbot not found");
  }

  let chat = null;
  if (!createNewSession) {
    chat = await Chat.findOne({ user: userId, chatbot: chatbot._id }).populate("messages");
  }

  if (!chat) {
    const defaultMessage = new Message({
      sender: "guru",
      content: "How can I help you?",
      timestamp: new Date(),
    });

    chat = new Chat({
      user: userId,
      chatbot: chatbot._id,
      title: "",
      messages: [defaultMessage],
    });
    await chat.save();
  }

  return { chatId: chat._id, title: chat.title }; // Return the chatId and title
};





  
// GET route to retrieve a chat session by chatId
export const getChatSession = async (req: ChatSessionRequest, res: Response): Promise<Response> => {
  const { chatId, userId } = req.params;

  try {
    // Validate chatId and userId
    if (!isValidObjectId(chatId) || !isValidObjectId(userId)) {
      return res.status(400).json({ message: 'Invalid chat ID or user ID' });
    }

    // Fetch the chat session from the database
    const chat = await Chat.findOne({ _id: chatId, user: userId })
      .populate('messages')
      .populate('chatbot');

    // Check if the chat session exists
    if (!chat) {
      return res.status(404).json({ message: 'Chat session not found' });
    }

    // Return the chat session data
    return res.status(200).json({
      chatId: chat._id,
      title: chat.title,
      description: chat.chatbot.description,
      messages: chat.messages.map((msg) => ({
        sender: msg.sender,
        content: msg.content,
        timestamp: msg.timestamp,
      })),
    });
  } catch (error) {
    console.error('Error retrieving chat session:', error);
    return res.status(500).json({ message: 'Failed to retrieve chat session', error: error.message });
  }
};
  
  
// Controller to generate chat completions
// Controller to generate chat completions
export const generateChatCompletion = async (req: Request, res: Response) => {
  const { message, chatbotId, userId, model, activeConversation } = req.body;
  const chatId = activeConversation;

  try {
    // Check for required parameters
    if (!message || !chatbotId || !userId || !model || !chatId) {
      return res.status(400).json({ message: 'Missing required parameters' });
    }

    // Validate user, chatbot, and chat IDs
    if (!isValidObjectId(userId) || !isValidObjectId(chatbotId) || !isValidObjectId(chatId)) {
      return res.status(400).json({ message: 'Invalid IDs provided' });
    }

    // Find user and chatbot
    const user = await User.findById(userId);
    const chatbot = await Chatbot.findById(chatbotId);
    if (!chatbot) {
      return res.status(404).json({ error: 'Chatbot not found' });
    }

    if (!user || !chatbot) {
      return res.status(404).json({ message: 'User or chatbot not found' });
    }

    // Find the existing chat session by chatId
    let chat = await Chat.findById(chatId).populate('messages');
    if (!chat) {
      return res.status(404).json({ message: 'Chat session not found' });
    }

    // Ensure the chat belongs to the user and chatbot
    if (chat.user.toString() !== userId || chat.chatbot.toString() !== chatbotId) {
      return res.status(403).json({ message: 'Chat does not belong to the user or chatbot' });
    }

    // Save the user's message to the chat
    const userMessage = new Message({
      sender: 'user',
      content: message,
      timestamp: new Date(),
      model,
    });
    chat.messages.push(userMessage);

    // Summarize chat history and generate AI response
    const context = summarizeHistory(chat.messages);

    const aiResponse = await generateAIResponse(
      '', // Empty context if not needed
      message, 
      chatbot, 
      model || 'llama3-8b-8192'
    );

    // Save Guru's (chatbot) AI response to the chat
    const guruMessage = new Message({
      sender: 'guru',
      content: aiResponse,
      timestamp: new Date(),
      model,
    });
    chat.messages.push(guruMessage);

    // Check if the chat already has a title, and if not, generate a new one
    if (!chat.title) {
      const newTitle = await generateChatTitle(chatId, userId, message, model, chatbotId);
      chat.title = newTitle;
    }

    // Save the updated chat
    await chat.save();

    // Emit the updated chat title to the frontend in real-time
    const io = req.app.get('io');
    if (io) {
      io.emit('chatTitleUpdated', { chatId: chat._id, newTitle: chat.title });
    } else {
      console.error('Socket.IO instance not found');
    }

    // Return the latest guru message and updated chat title
    return res.status(200).json({
      chatId: chat._id,
      title: chat.title,
      description: chatbot.description,
      latestMessage: {
        sender: guruMessage.sender,
        content: guruMessage.content,
        timestamp: guruMessage.timestamp,
      },
    });

  } catch (error) {
    console.error('Chat Completion Error:', error);
    return res.status(500).json({ 
      error: 'Failed to generate chat completion',
      message: error.message 
    });
  }
};


// Controller to update chat title
export const updateChatTitleController = async (req: Request, res: Response): Promise<Response> => {
  const { chatId,  newTitle } = req.body;

  try {
    // Validate the incoming data
    if (!chatId  || !newTitle) {
      return res.status(400).json({ message: 'Missing required parameters' });
    }

    // Find the chat session
    const chat = await Chat.findOne({ _id: chatId });
    if (!chat) {
      return res.status(404).json({ message: 'Chat session not found' });
    }

    // Update the chat title
    chat.title = newTitle;
    await chat.save();

    // Return the updated chat data
    return res.status(200).json({
      chatId: chat._id,
      newTitle: chat.title, // Returning the updated title
    });
  } catch (error) {
    console.error('Error updating chat title:', error);
    return res.status(500).json({ message: 'Failed to update chat title', error: error.message });
  }
};


// Get all chats for a specific user
export const getUserChats = async (req: Request, res: Response) => {
    const { userId } = req.params;

    try {
        const userChats = await Chat.find({ user: userId }).populate('chatbot', 'name'); // Populate chatbot field
        // console.log(userChats);
        return res.json(userChats); // Send the response and terminate function execution
    } catch (error) {
        return res.status(500).json({ message: "Failed to fetch chats", error }); // Send error response and terminate
    }
};

// Send all chats and their messages to the user
export const sendChatsToUser = async (req: Request, res: Response, next: NextFunction) => {
    try {
        // Populate chats with messages and chatbot
        const user = await User.findById(res.locals.jwtData.id).populate({
            path: 'chats',
            populate: [
                { path: 'messages', model: 'Message' }, // Populate messages
                { path: 'chatbot', model: 'Chatbot' }  // Populate chatbot
            ]
        });

        if (!user) {
            return res.status(401).json({ message: "User not registered OR Token malfunctioned" });
        }

        // Group chats by chatbot
        const groupedChats = user.chats.reduce((acc: any, chat: any) => {
            // Check if chatbot is populated and exists
            if (!chat.chatbot || !chat.chatbot._id) return acc; // Skip if chatbot is not populated or missing _id

            const chatbotId = chat.chatbot._id.toString();
            if (!acc[chatbotId]) {
                acc[chatbotId] = {
                    chatbot: {
                        id: chat.chatbot._id,
                        name: chat.chatbot.name,
                        description: chat.chatbot.description,
                    },
                    chats: [],
                };
            }

            acc[chatbotId].chats.push({
                chatId: chat._id,
                title: chat.title,
                messages: chat.messages.map((msg: any) => ({
                    sender: msg.sender,
                    content: msg.content,
                    timestamp: msg.timestamp,
                })),
            });

            return acc;
        }, {});

        return res.status(200).json({ message: "OK", groupedChats });
    } catch (error) {
        console.error('Error fetching user chats:', error);
        return res.status(500).json({ message: "ERROR", cause: error.message });
    }
};



// Delete all chats for a user
export const deleteChats = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const user = await User.findById(res.locals.jwtData.id);
        if (!user) {
            return res.status(401).send("User not registered OR Token malfunctioned");
        }

        await Chat.deleteMany({ _id: { $in: user.chats } });
        user.chats = [];
        await user.save();

        res.send({ message: "Chats deleted successfully" });
    } catch (error) {
        res.status(500).send({ message: "Error deleting chats" });
    }
};

// Clear messages from a specific chat session
export const clearChatMessages = async (req: Request, res: Response) => {
  const { chatId, userId } = req.body;

  try {
    if (!isValidObjectId(chatId) || !isValidObjectId(userId)) {
      return res.status(400).json({ message: 'Invalid chat ID or user ID' });
    }

    const chat = await Chat.findOne({ _id: chatId, user: userId });

    if (!chat) {
      return res.status(404).json({ message: 'Chat session not found' });
    }

    // Clear messages but keep chat structure
    chat.messages = [];
    await chat.save();

    return res.status(200).json({ message: 'Chat messages cleared successfully', chatId: chat._id });
  } catch (error) {
    console.error('Error clearing chat messages:', error);
    return res.status(500).json({ message: 'Failed to clear chat messages', error: error.message });
  }
};

// Delete a specific chat session
export const deleteChatSession = async (req: Request, res: Response) => {
  const { userId } = req.body;
  const { chatId } = req.params;

  try {
    if (!isValidObjectId(chatId) || !isValidObjectId(userId)) {
      return res.status(400).json({ message: 'Invalid chat ID or user ID' });
    }

    const chat = await Chat.findOne({ _id: chatId, user: userId });

    if (!chat) {
      return res.status(404).json({ message: 'Chat session not found' });
    }

    // Delete the chat
    await chat.deleteOne();

    // Remove reference from the user's chats
    const user = await User.findById(userId);
    if (user) {
      user.chats = user.chats.filter(
        (id: mongoose.Types.ObjectId) => id.toString() !== chatId
      );
      await user.save();
    }

    return res.status(200).json({ message: 'Chat session deleted successfully' });
  } catch (error) {
    console.error('Error deleting chat session:', error);
    return res.status(500).json({ message: 'Failed to delete chat session', error: error.message });
  }
};


// Delete all chat sessions for a user
export const deleteAllChatSessions = async (req: Request, res: Response, next: NextFunction) => {
  const { userId } = req.body;

  try {
    if (!isValidObjectId(userId)) {
      return res.status(400).json({ message: 'Invalid user ID' });
    }

    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    // Delete all chats associated with the user
    await Chat.deleteMany({ _id: { $in: user.chats } });

    // Clear user's chat references
    user.chats = [];
    await user.save();

    return res.status(200).json({ message: 'All chat sessions deleted successfully' });
  } catch (error) {
    console.error('Error deleting all chat sessions:', error);
    return res.status(500).json({ message: 'Failed to delete all chat sessions', error: error.message });
  }
};

