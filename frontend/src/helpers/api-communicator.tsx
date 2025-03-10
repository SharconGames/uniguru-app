import axios from "axios";

// Define the base URL for the API
const VITE_BACKEND_URL_V1 = "http://localhost:8010/api/v1";

// **User API Communicator Functions**

export const loginUser = async (email: string, password: string) => {
  const res = await axios.post(`${VITE_BACKEND_URL_V1}/user/login`, { email, password });
  if (res.status !== 200) {
    throw new Error("Unable to login");
  }
  const data = await res.data;
  console.log(data)
  console.log("Login data", data);
  return data;
};

export const signupUser = async (
  name: string,
  email: string,
  password: string
) => {
  const res = await axios.post(`${VITE_BACKEND_URL_V1}/user/signup`, { name, email, password });
  if (res.status !== 201) {
    throw new Error("Unable to Signup");
  }
  const data = await res.data;
  return data;
};

export const googleOAuthCallback = async (token: string) => {
  try {
    const response = await axios.post(
      "http://localhost:2004/auth/google/token",
      { token }
    );

    console.log("Google Url", response.data);
    return response.data;
  } catch (error) {
    console.error("Error during Google OAuth callback:", error);
    throw error;
  }
};


export const checkAuthStatus = async () => {
  const res = await axios.get(`${VITE_BACKEND_URL_V1}/user/auth-status`);
  if (res.status !== 200) {
    throw new Error("Unable to authenticate");
  }
  const data = await res.data;
  return data;
};

export const logoutUser = async () => {
  const res = await axios.get(`${VITE_BACKEND_URL_V1}/user/logout`);
  if (res.status !== 200) {
    throw new Error("Unable to logout");
  }
  const data = await res.data;
  return data;
};

// **Chat API Communicator Functions**

export const startNewChatSession = async (userId: string) => {
  const res = await axios.post(`${VITE_BACKEND_URL_V1}/chat/start`, { userId });
  if (res.status !== 200) {
    throw new Error("Unable to start new chat session");
  }
  return res.data;
};

export const updateTitleOfTheChat = async (chatId:string, userId:string , newTitle:string ) =>{
  const res = await axios.put(`${VITE_BACKEND_URL_V1}/chat/update-title` , {chatId,userId,newTitle})
  if (res.status !== 200) {
    throw new Error("Unable to start new chat session");
  }
  return res.data;
}

export const GetTitleOfTheChat = async (chatId:string, userId:string ) =>{
  const res = await axios.get(`${VITE_BACKEND_URL_V1}/chat/${chatId}/${userId}`)
  if (res.status !== 200) {
    throw new Error("Unable to start new chat session");
  }
  return res.data;
}

export const generateChatCompletion = async (message: string, chatbotId: string, userId: string, model: string, activeConversation: string) => {
  const res = await axios.post(`${VITE_BACKEND_URL_V1}/chat/new`, { message,chatbotId,userId, model , activeConversation });
  if (res.status !== 200) {
    throw new Error("Unable to generate chat completion");
  }
  console.log(res)
  return res.data;
};

export const getUserChats = async (userId: string) => {
  const res = await axios.get(`${VITE_BACKEND_URL_V1}/chat/users/${userId}`);
  if (res.status !== 200) {
    throw new Error("Unable to fetch user chats");
  }
  return res.data;
};

export const getAllChats = async () => {
  const res = await axios.get(`${VITE_BACKEND_URL_V1}/chat/all`);
  if (res.status !== 200) {
    throw new Error("Unable to fetch all chats");
  }
  return res.data;
};

export const clearChatMessages = async (chatId: string) => {
  const res = await axios.post(`${VITE_BACKEND_URL_V1}/chat/${chatId}/clear`);
  if (res.status !== 200) {
    throw new Error("Unable to clear chat messages");
  }
  return res.data;
};

export const deleteChatSession = async (chatId: string) => {
  const res = await axios.delete(`${VITE_BACKEND_URL_V1}/chat/${chatId}`);
  if (res.status !== 200) {
    throw new Error("Unable to delete chat session");
  }
  return res.data;
};

export const deleteAllChatSessions = async () => {
  const res = await axios.delete(`${VITE_BACKEND_URL_V1}/chat/all`);
  if (res.status !== 200) {
    throw new Error("Unable to delete all chat sessions");
  }
  return res.data;
};

// **Guru (Chatbot) API Communicator Functions**

export const createNewGuru = async (userId: string) => {
  const res = await axios.post(`${VITE_BACKEND_URL_V1}/guru/n-g/${userId}`);
  if (res.status !== 200) {
    throw new Error("Unable to create new Guru");
  }
  return res.data;
};

export const createChat = async (userId: string, chatbotId: string, createNewSession: boolean) => {
  try {
    const res = await axios.post(`${VITE_BACKEND_URL_V1}/chat/start`, { userId, chatbotId, createNewSession });
    console.log("Backend Response:", res.data); // Log the response to check if chatId is returned
    if (res.status === 200) {
      return res.data; // { chatId, title }
    } else {
      throw new Error("Unable to create new chat");
    }
  } catch (error) {
    console.error("Error creating new chat:", error);
    throw error;
  }
};

export const fetchChatFromGurus = async (chatbotid:string) => {
  const res = await axios.get(`${VITE_BACKEND_URL_V1}/guru/g-chats/${chatbotid}`);
  if (res.status !== 200) {
    throw new Error("Unable to create new Guru");
  }
  return res.data;
}

export const fetchUserGurus = async () => {
  const res = await axios.get(`${VITE_BACKEND_URL_V1}/guru/g-g`);
  if (res.status !== 200) {
    throw new Error("Unable to fetch user gurus");
  }
  return res.data.chatbots;
};


export const getChatWithGuru = async (chatId: string) => {
  const res = await axios.get(`${VITE_BACKEND_URL_V1}/guru/g-c/${chatId}`);
  if (res.status !== 200) {
    throw new Error("Unable to fetch chat from Guru");
  }
  const messages = res.data.messages;
  return messages.map((message: any) => ({
    sender: message.sender,
    content: message.content,
    timestamp: message.timestamp,
  }));
};


export const deleteGuru = async (chatbotId: string) => {
  const res = await axios.delete(`${VITE_BACKEND_URL_V1}/guru/g-d/${chatbotId}`);
  if (res.status !== 200) {
    throw new Error("Unable to delete chatbot");
  }
  return res.data;
};

// **Additional Features (PDF/Image)**

export const readPdf = async (file: File) => {
  const formData = new FormData();
  formData.append("pdf", file);

  const response = await axios.post(`${VITE_BACKEND_URL_V1}/feature/pdf/r`, formData, {
    headers: { "Content-Type": "multipart/form-data" },
  });

  return response.data;
};

export const talkWithPdfContent = async (extractedText: string, message: string) => {
  const response = await axios.post(`${VITE_BACKEND_URL_V1}/feature/pdf/t`, {
    extractedText,
    message,
  });

  return response.data;
};

export const createPdf = async (title: string, content: string) => {
  const response = await axios.post(`${VITE_BACKEND_URL_V1}/feature/pdf/c`, { title, content });
  return response.data;
};

// Image-related functionalities

export const scanImageText = async (file: File) => {
  const formData = new FormData();
  formData.append("image", file);

  const response = await axios.post(`${VITE_BACKEND_URL_V1}/feature/image/s`, formData, {
    headers: { "Content-Type": "multipart/form-data" },
  });

  return response.data;
};

export const editImageText = async (file: File, newText: string) => {
  const formData = new FormData();
  formData.append("image", file);
  formData.append("text", newText);

  const response = await axios.post(`${VITE_BACKEND_URL_V1}/feature/image/e`, formData, {
    headers: { "Content-Type": "multipart/form-data" },
  });

  return response.data;
};
