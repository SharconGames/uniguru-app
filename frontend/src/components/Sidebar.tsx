import React, { useState, useEffect } from "react";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faBars, faTimes, faPlus } from "@fortawesome/free-solid-svg-icons";
import { useAuth } from "../context/AuthContext";
import { createChat, fetchChatFromGurus } from "../helpers/api-communicator";
import { useNavigate } from "react-router-dom";

interface SidebarProps {
  isSidebarOpen: boolean;
  toggleSidebar: () => void;
  onConversationSelect: (chatId: string) => void;
  activeConversation: string | null;
  activeConversationTitle: string; // Add activeConversationTitle prop
}

const Sidebar: React.FC<SidebarProps> = ({ isSidebarOpen, toggleSidebar, onConversationSelect, activeConversation, activeConversationTitle }) => {
  const { user, selectedGuru } = useAuth();
  const navigate = useNavigate();
  const [isSmallScreen, setIsSmallScreen] = useState(window.innerWidth <= 768);
  const [conversations, setConversations] = useState<any[]>([]);

  // Fetch chat history
  useEffect(() => {
    const fetchChatHistory = async () => {
      if (user?.id && selectedGuru?.id) {
        try {
          const chatData = await fetchChatFromGurus(selectedGuru.id as string);
          if (chatData && Array.isArray(chatData.chats)) {
            const formattedConversations = chatData.chats.map((chat: any) => ({
              id: chat.chatId,
              title: chat.title || `Conversation ${chat.chatId.slice(-4)}`,
            }));
            setConversations(formattedConversations);
          } else {
            setConversations([]);
          }
        } catch (error) {
          console.error("Error fetching chat history:", error);
          setConversations([]);
        }
      }
    };

    fetchChatHistory();
  }, [user?.id, selectedGuru?.id]);

  // Resize handler
  useEffect(() => {
    const handleResize = () => setIsSmallScreen(window.innerWidth <= 768);
    window.addEventListener("resize", handleResize);
    return () => {
      window.removeEventListener("resize", handleResize);
    };
  }, []);

  const handleCreateNewChat = async () => {
    if (user?.id) {
      try {
        // Create a new chat
        const newChat = await createChat(user.id, selectedGuru?.id as string, true);
        console.log("New Chat:", newChat); // Log the new chat object
  
        // Check if chatId is returned
        if (!newChat?.chatId) {
          throw new Error("Failed to create a new chat, no chatId returned");
        }
  
        // Update the conversations state
        setConversations((prev) => [
          ...prev,
          {
            id: newChat.chatId,
            title: newChat.title || `Conversation ${prev.length + 1}`,
          },
        ]);
  
        // Select the new conversation
        onConversationSelect(newChat.chatId);
  
        // Clear any previous chat from the URL and navigate to the new chat
        const guruName = selectedGuru?.name || "guru";
        navigate(`/${guruName}/c/${newChat.chatId}`, { replace: true }); // Use `replace` to avoid URL history overlap
      } catch (error) {
        console.error("Error creating new chat:", error);
      }
    }
  };
  
  const handleConversationClick = (chatId: string) => {
    onConversationSelect(chatId);

    const guruName = selectedGuru?.name || "guru";
    navigate(`/${guruName}/c/${chatId}`);
  };

  return (
    <>
      <button onClick={toggleSidebar} className="fixed top-20 left-5 z-50 p-3 rounded-full">
        {isSidebarOpen ? (
          <FontAwesomeIcon icon={faTimes} className="cursor-pointer text-gray-400 hover:text-white transition duration-300" size="lg" />
        ) : (
          <FontAwesomeIcon icon={faBars} className="cursor-pointer text-gray-400 hover:text-white transition duration-300" size="lg" />
        )}
      </button>

      <div
        className={`fixed top-[5rem] left-0 h-[calc(100%-5rem)] transform ${isSidebarOpen ? "translate-x-0" : "-translate-x-full"} transition-transform duration-300 z-40 w-64 flex flex-col`}
        style={{
          backgroundColor: isSmallScreen ? "rgba(50, 39, 59, 1)" : "rgba(50, 39, 59, 0.2)",
        }}
      >
        <ul className="flex flex-col gap-4 p-5 flex-grow text-white">
          <button
            onClick={handleCreateNewChat}
            className="bg-blue-800 hover:bg-blue-900 p-3 rounded cursor-pointer w-full flex items-center justify-between mt-7"
          >
            <span>New Chat</span>
            <FontAwesomeIcon icon={faPlus} className="text-white hover:text-gray-400 transition duration-300 ml-2" size="lg" />
          </button>
          {Array.isArray(conversations) && conversations.length > 0 ? (
            conversations.map((conversation) => (
              <li
                key={conversation.id}
                className={`p-2 rounded cursor-pointer ${
                  activeConversation === conversation.id ? "bg-gray-700 font-bold" : "hover:bg-gray-700"
                }`}
                onClick={() => handleConversationClick(conversation.id)}
              >
                <span>{conversation.title}</span>
              </li>
            ))
          ) : (
            <li>No conversations available</li>
          )}
        </ul>
      </div>
    </>
  );
};

export default Sidebar;
