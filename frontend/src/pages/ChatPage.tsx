import React, { useState, useEffect } from "react";
import { useParams, useNavigate } from "react-router-dom";
import Sidebar from "../components/Sidebar";
import ChatContainer from "../components/ChatContainer";

const ChatPage: React.FC = () => {
  const { chatId } = useParams<{ chatId: string }>();
  const navigate = useNavigate();
  const [isSidebarOpen, setIsSidebarOpen] = useState(false);
  const [activeConversation, setActiveConversation] = useState<string | null>(chatId || null);

  // Sync activeConversation with URL params
  useEffect(() => {
    if (chatId) {
      setActiveConversation(chatId);
    }
  }, [chatId]);

  const toggleSidebar = () => {
    setIsSidebarOpen((prevState) => !prevState);
  };

  const handleConversationSelect = (selectedChatId: string) => {
    setActiveConversation(selectedChatId);
    navigate(`/chat/${selectedChatId}`); // Update the URL with the selected chatId
  };

  return (
    <div className="flex h-screen">
      {/* Sidebar */}
      <div className="h-screen">
        <Sidebar
          isSidebarOpen={isSidebarOpen}
          toggleSidebar={toggleSidebar}
          onConversationSelect={handleConversationSelect}
          activeConversation={activeConversation}
        />
      </div>

      {/* Chat Container */}
      <ChatContainer
        isSidebarOpen={isSidebarOpen}
        activeConversation={activeConversation}
      />
    </div>
  );
};

export default ChatPage;
