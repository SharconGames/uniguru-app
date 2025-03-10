import React from "react";
import { Prism as SyntaxHighlighter } from "react-syntax-highlighter";
import { dracula } from "react-syntax-highlighter/dist/esm/styles/prism";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faCopy, faVolumeHigh } from "@fortawesome/free-solid-svg-icons";
import uniguru from "../assets/uni-logo.png";
import userimage from "../assets/userimage.png";

interface ChatItemProps {
  text: string;
  sender: "user" | "guru";
  onSpeak?: (text: string) => void;
  onCopy?: (text: string) => void;
}

function extractCodeFromString(message: string): string[] {
  if (message.includes("```")) {
    const blocks = message.split("```");
    return blocks.filter((block) => block.trim() !== ""); // Filter out empty blocks
  }
  return [message];
}

function isCodeBlock(str: string): boolean {
  const codeIndicators = ["=", ";", "[", "]", "{", "}", "#", "//"];
  return codeIndicators.some((indicator) => str.includes(indicator));
}

// Function to format text with bold, highlighted, paragraphs, numbered lists, and bullet points
function formatText(text: string) {
  const formattedText = text.split("\n").map((line, index) => {
    // Bold text (using **text** or __text__)
    line = line.replace(/\*\*(.*?)\*\*/g, "<strong>$1</strong>");
    line = line.replace(/__(.*?)__/g, "<strong>$1</strong>");

    // Highlighted text (using ==text==)
    line = line.replace(/==(.*?)==/g, "<mark>$1</mark>");

    // Bullet points (lines starting with '-')
    if (line.startsWith("-")) {
      return <li key={index} className="list-disc pl-5">{line.slice(1).trim()}</li>; // Bullet points
    }
    // Numbered list (lines starting with '1.', '2.', etc.)
    if (/^\d+\./.test(line)) {
      return <li key={index} className="list-decimal pl-5">{line.slice(line.indexOf(".") + 1).trim()}</li>; // Numbered lists
    }
    // Regular paragraph
    return <p key={index} dangerouslySetInnerHTML={{ __html: line }} />;
  });

  return formattedText;
}

const ChatItem: React.FC<ChatItemProps> = ({ text, sender, onSpeak, onCopy }) => {
  const messageBlocks = extractCodeFromString(text);

  return (
    <div
      className={`flex items-start ${
        sender === "guru" ? "justify-start" : "justify-end"
      } my-2`}
    >
      {sender === "guru" && (
        <img
          src={uniguru}
          alt="Guru"
          className="w-10 h-10 rounded-full mr-3"
        />
      )}

      <div
        className={`relative px-4 py-2 rounded-lg shadow-md ${
          sender === "user"
            ? "bg-gradient-to-r from-blue-400 to-purple-500 text-white"
            : "bg-transparent border-2 border-gray-400 text-gray-200"
        }`}
        style={{ maxWidth: "70%", wordWrap: "break-word" }}
      >
        {messageBlocks.map((block, index) =>
          isCodeBlock(block) ? (
            <SyntaxHighlighter
              key={index}
              language="typescript"
              style={dracula}
              customStyle={{
                background: sender === "guru" ? "#2B1736" : "#1a202c", // Ensure background is consistent
                borderRadius: "8px",
                padding: "10px",
                fontSize: "12px",
                overflowX: "auto",
              }}
              wrapLines
              wrapLongLines
            >
              {block}
            </SyntaxHighlighter>
          ) : (
            <div key={index}>
              {/* Render formatted paragraphs or lists */}
              {formatText(block)}
            </div>
          )
        )}
        
        {sender === "guru" && (
          <div className="absolute bottom-[-20px] right-0 flex items-center space-x-2">
            {onSpeak && (
              <FontAwesomeIcon
                icon={faVolumeHigh}
                className="text-gray-400 hover:text-gray-500 cursor-pointer"
                onClick={() => onSpeak(text)}
              />
            )}
            {onCopy && (
              <FontAwesomeIcon
                icon={faCopy}
                className="text-gray-400 hover:text-gray-500 cursor-pointer"
                onClick={() => onCopy(text)}
              />
            )}
          </div>
        )}
      </div>

      {sender === "user" && (
        <img
          src={userimage}
          alt="User"
          className="w-8 h-8 rounded-full ml-3"
        />
      )}
    </div>
  );
};

export default ChatItem;
