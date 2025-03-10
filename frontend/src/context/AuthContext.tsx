import {
  ReactNode,
  createContext,
  useContext,
  useEffect,
  useState,
} from "react";
import { useParams, NavigateFunction } from "react-router-dom";
import {
  checkAuthStatus,
  loginUser,
  logoutUser,
  signupUser,
  fetchUserGurus,
  googleOAuthCallback,
  deleteGuru,
} from "../helpers/api-communicator";

// Define the structure of a message
export interface IMessage {
  sender: "user" | "guru";
  content: string;
  timestamp: Date;
}

// Define the structure of the Chat schema
export interface IChat {
  _id: string;
  user: string;
  chatbot: string;
  title: string;
  messages: IMessage[];
  createdAt: Date;
  updatedAt: Date;
}

type User = {
  id: string;
  name: string;
  email: string;
  chatbotId: string;
};

type Guru = {
  
  name: string;
  description: string;
  subject: string;
  id: string;
  userid: string;
  chats: IChat[];
};

type UserAuth = {
  setIsLoggedIn: (arg0: boolean) => void;
  isLoggedIn: boolean;
  user: User | null;
  selectedGuru: Guru | null;
  login: (email: string, password: string) => Promise<{ navigateUrl?: string }>;
  signup: (name: string, email: string, password: string) => Promise<{ navigateUrl?: string }>;
  logout: (navigate: NavigateFunction) => Promise<void>;
  googleLogin: (token: string) => Promise<{ navigateUrl?: string }>;
  setSelectedGuru: (guru: Guru | null) => void;
  addGuru: (guru: Guru) => void;
  removeGuru: (guruId: string) => void;
  setGurus: (update: (prevGurus: Guru[]) => Guru[]) => void;
  gurus: Guru[];
  selectedModel: string;
  setSelectedModel: (model: string) => void;
  updateChatTitle: (chatId: string, userId: string, newTitle: string) => Promise<void>; // New function
};

// Create context with a default value of null
const AuthContext = createContext<UserAuth | null>(null);

// Default model
const DEFAULT_MODEL = "llama-3.3-70b-versatile";

// AuthProvider component
export const AuthProvider = ({ children }: { children: ReactNode }) => {
  const { guruName } = useParams<{ guruName: string }>();
  const [user, setUser] = useState<User | null>(null);
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const [gurus, setGurus] = useState<Guru[]>([]);
  const [selectedGuru, setSelectedGuru] = useState<Guru | null>(null);
  const [selectedModel, setSelectedModel] = useState<string>(DEFAULT_MODEL); // New model state

  useEffect(() => {
    const initializeAuth = async () => {
      try {
        const data = await checkAuthStatus();
        if (data) {
          setIsLoggedIn(true);
          setUser({ id: data.id, email: data.email, name: data.name, chatbotId: data.chatbotid });

          const userGurus = await fetchUserGurus();
          console.log(userGurus)
          setGurus(userGurus);
          
          const guruFromParams = guruName
            ? userGurus.find((guru: { name: string }) => guru.name === guruName)
            : userGurus[0];
          setSelectedGuru(guruFromParams || null);
        }
      } catch (error) {
        console.error("Error checking auth status:", error);
      }
    };
    initializeAuth();
  }, [guruName]);

  // Function to update chat title
  const updateChatTitle = async (chatId: string, userId: string | undefined, newTitle: string) => {
    try {
      // Update the chat title in the API
      await updateChatTitle(chatId, userId, newTitle as any);

      // Update the chat title in the local state (gurus)
      
      setGurus((prevGurus) => {
        return prevGurus.map((guru) => {
          if (guru.id === selectedGuru?.id) {
            guru.chats = guru.chats.map((chat: IChat) => {
              if (chat._id === chatId) {
                chat.title = newTitle; // Update title
              }
              return chat;
            });
          }
          return guru;
        });
      });
    } catch (error) {
      console.error("Error updating chat title:", error);
    }
  };

  const login = async (email: string, password: string): Promise<{ navigateUrl?: string }> => {
    try {
      const data = await loginUser(email, password);
      if (data) {
        setIsLoggedIn(true);
        setUser({ id: data.id, email: data.email, name: data.name, chatbotId: data.chatbotid });
        localStorage.setItem("token", data.token);
        const userGurus = await fetchUserGurus();
        setGurus(userGurus);
        const guruFromParams = guruName
          ? userGurus.find((guru: { name: string }) => guru.name === guruName)
          : userGurus[0];
        setSelectedGuru(guruFromParams || null);
        return { navigateUrl: data.navigateUrl || "/error" };
      }
      console.error("Login response is empty.");
      return {};
    } catch (error: any) {
      console.error("Error during login:", error);
      return {};
    }
  };

  const signup = async (name: string, email: string, password: string): Promise<{ navigateUrl?: string }> => {
    try {
      const data = await signupUser(name, email, password);
      if (data) {
        setIsLoggedIn(true);
        setUser({ id: data.id, email: data.email, name: data.name, chatbotId: data.chatbotid });
        localStorage.setItem("token", data.token);
        const userGurus = await fetchUserGurus();
        setGurus(userGurus);

        const guruFromParams = guruName
          ? userGurus.find((guru: { name: string }) => guru.name === guruName)
          : userGurus[0];
        setSelectedGuru(guruFromParams || null);

        return { navigateUrl: data.navigateUrl };
      }
      return {};
    } catch (error) {
      console.error("Error during signup:", error);
      return {};
    }
  };

  const googleLogin = async (token: string): Promise<{ navigateUrl?: string }> => {
    try {
      const data = await googleOAuthCallback(token);
      if (data) {
        setUser({
          id: data.user.id,
          email: data.user.email,
          name: data.user.name,
          chatbotId: data.chatbotid,
        });
        setIsLoggedIn(true);
        localStorage.setItem("token", data.token);

        const userGurus = await fetchUserGurus();
        setGurus(userGurus);

        const guruFromParams = guruName
          ? userGurus.find((guru: { name: string }) => guru.name === guruName)
          : userGurus[0];
        setSelectedGuru(guruFromParams || null);

        return { navigateUrl: data.navigateUrl };
      }
      return {};
    } catch (error) {
      console.error("Error during Google login:", error);
      return {};
    }
  };

  const logout = async (navigate: NavigateFunction) => {
    try {
      await logoutUser();
      setUser(null);
      setGurus([]);
      setSelectedGuru(null);
      setIsLoggedIn(false);
      navigate("/login");
    } catch (error) {
      console.error("Error during logout:", error);
    }
  };

  const addGuru = (newGuru: Guru) => {
    setGurus((prevGurus) => {
      const updatedGurus = [...prevGurus, newGuru];
      if (updatedGurus.length === 1) {
        setSelectedGuru(newGuru);
      }
      return updatedGurus;
    });
  };

  const removeGuru = async (guruId: string) => {
    try {
      await deleteGuru(guruId);
      setGurus((prevGurus) => {
        const updatedGurus = prevGurus.filter((guru) => guru.id !== guruId);
        if (selectedGuru?.id === guruId) {
          setSelectedGuru(updatedGurus[0] || null);
        }
        return updatedGurus;
      });
    } catch (error) {
      console.error("Error deleting guru:", error);
    }
  };

  return (
    <AuthContext.Provider
      value={{
        user,
        isLoggedIn,
        setIsLoggedIn,
        selectedGuru,
        setSelectedGuru,
        addGuru,
        removeGuru,
        setGurus: (update) => setGurus((prev) => update(prev)),
        login,
        logout,
        signup,
        googleLogin,
        gurus,
        selectedModel,
        setSelectedModel,
        updateChatTitle, // Provide updateChatTitle function
      }}
    >
      {children}
    </AuthContext.Provider>
  );
};

// Custom hook to use AuthContext
export const useAuth = (): UserAuth => {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error("useAuth must be used within an AuthProvider");
  }
  return context;
};
