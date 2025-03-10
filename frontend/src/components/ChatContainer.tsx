import { useState, useEffect, useRef } from "react";
import { useAuth } from "../context/AuthContext";
import { generateChatCompletion, getChatWithGuru } from "../helpers/api-communicator";
import ChatItem from "./ChatItem";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faArrowUp } from "@fortawesome/free-solid-svg-icons";
import { useSocket } from "../context/socketProvider"; // Use the socket from context

interface ChatContainerProps {
  isSidebarOpen: boolean;
  activeConversation: string | null;
}

interface Message {
  text: string;
  sender: "user" | "guru";
}

const ChatContainer: React.FC<ChatContainerProps> = ({ isSidebarOpen, activeConversation }) => {
  const [messages, setMessages] = useState<Message[]>([]);
  const [message, setMessage] = useState<string>("");
  const [isSpeaking, setIsSpeaking] = useState(false);
  const auth = useAuth();
  const socket = useSocket(); // Access socket from context

  const messagesEndRef = useRef<HTMLDivElement | null>(null);

  const scrollToBottom = () => {
    if (messagesEndRef.current) {
      messagesEndRef.current.scrollIntoView({ behavior: "smooth" });
    }
  };

  useEffect(() => {
    scrollToBottom();
  }, [messages]);

  // Fetch chat messages whenever the activeConversation changes
  useEffect(() => {
    const fetchChatMessages = async () => {
      try {
        if (activeConversation && auth.selectedGuru?.id && auth.user?.id) {
          const initialMessages = await getChatWithGuru(activeConversation); // Fetch messages based on activeConversation
          setMessages(
            initialMessages.map((msg: any) => ({
              text: msg.content,
              sender: msg.sender === "guru" ? "guru" : "user",
            }))
          );
        }
      } catch (error) {
        console.error("Error fetching chat messages:", error);
      }
    };

    // Only fetch messages if activeConversation is not null
    if (activeConversation) {
      fetchChatMessages();
    }
  }, [activeConversation, auth.selectedGuru?.id, auth.user?.id]);

  const handleSendMessage = async () => {
    if (message.trim() && activeConversation) {
      const newMessages: Message[] = [...messages, { text: message, sender: "user" }];
      setMessages(newMessages);
      setMessage("");

      const textarea = document.querySelector("textarea");
      if (textarea) {
        textarea.style.height = "auto";
      }

      const model = "llama-3.3-70b-versatile";
      try {
        const response = await generateChatCompletion(
          message,
          auth.selectedGuru?.id as string,
          auth.user?.id as string,
          model,
          activeConversation // Pass the chatId (activeConversation) to the backend
        );

        const botMessage = response?.latestMessage?.content || "Sorry, I couldn't process that!";
        setMessages((prevMessages) => [...prevMessages, { text: botMessage, sender: "guru" }]);

        socket?.emit("sendMessage", {
          chatId: activeConversation,
          text: message,
          sender: "user",
        });
      } catch (error) {
        console.error("Error generating chat completion:", error);
        setMessages((prevMessages) => [
          ...prevMessages,
          { text: "An error occurred. Please try again later.", sender: "guru" },
        ]);
      }
    }
  };

  const handleKeyDown = (e: React.KeyboardEvent<HTMLTextAreaElement>) => {
    if (e.key === "Enter" && !e.shiftKey) {
      e.preventDefault();
      handleSendMessage();
    }
  };

  const handleInput = (event: React.ChangeEvent<HTMLTextAreaElement>) => {
    const textarea = event.target;
    textarea.style.height = "auto";
    textarea.style.height = `${Math.min(textarea.scrollHeight, 150)}px`;
  };

  const handleSpeak = (text: string) => {
    if (!text) return;

    const utterance = new SpeechSynthesisUtterance(text);
    utterance.rate = 1;

    if (isSpeaking) {
      window.speechSynthesis.cancel();
      setIsSpeaking(false);
    } else {
      window.speechSynthesis.speak(utterance);
      setIsSpeaking(true);
      utterance.onend = () => setIsSpeaking(false);
    }
  };

  const handleCopy = (text: string) => {
    navigator.clipboard.writeText(text).then(
      () => console.log("Content copied to clipboard"),
      (err) => console.error("Failed to copy: ", err)
    );
  };

  return (
    <div
      className={`flex flex-col items-center justify-between text-white transition-all duration-300 ${
        isSidebarOpen ? "ml-0 sm:ml-64" : "ml-0"
      }`}
      style={{
        width: "100%",
        marginTop: "80px",
        overflowX: "hidden",
      }}
    >
      <div
        className="flex-1 mb-4 w-full max-w-3xl flex flex-col gap-4"
        style={{
          maxHeight: "calc(100vh - 180px)",
          overflowY: "auto",
          zIndex: isSidebarOpen ? "10" : "0",
          scrollbarWidth: "none",
          msOverflowStyle: "none",
        }}
      >
        {messages.length > 0 ? (
          messages.map((msg, index) => (
            <ChatItem
              key={index}
              text={msg.text}
              sender={msg.sender}
              onSpeak={handleSpeak}
              onCopy={handleCopy}
            />
          ))
        ) : (
          <div className="flex items-center justify-center h-full">
            <p className="text-gray-400">No messages yet. Start the conversation!</p>
          </div>
        )}
        <div ref={messagesEndRef} />
      </div>

      <div className="w-full max-w-3xl px-4 flex items-center relative">
        <div className="flex items-center w-full border border-gray-700 rounded-3xl bg-transparent px-4">
          <textarea
            className="flex-1 p-3 bg-transparent text-white placeholder-gray-400 focus:outline-none resize-none"
            placeholder="Type a message..."
            value={message}
            onChange={(e) => setMessage(e.target.value)}
            onInput={handleInput}
            onKeyDown={handleKeyDown}
            rows={1}
            style={{
              maxHeight: "200px",
              overflowY: "auto",
              scrollbarWidth: "none",
              msOverflowStyle: "none",
            }}
          />
        </div>
        <button
          onClick={handleSendMessage}
          className="ml-3 py-2 px-4 border border-gray-700 bg-transparent text-white rounded-full transition duration-300 focus:outline-none focus:ring-2 focus:ring-gray-400"
        >
          <FontAwesomeIcon className="text-gray-400" icon={faArrowUp} />
        </button>
      </div>

      <div className="text-center text-gray-400 mt-2 mb-5 text-sm">
        Guru can make mistakes. Check important info.
      </div>
    </div>
  );
};

export default ChatContainer;
