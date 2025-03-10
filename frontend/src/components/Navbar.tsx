import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faChevronDown, faTimes, faTrash } from "@fortawesome/free-solid-svg-icons";
import { clearChatMessages } from "../helpers/api-communicator";
import { useState, useRef, useEffect } from "react";
import { useLocation, useNavigate } from "react-router-dom";
import { useAuth } from "../context/AuthContext";
import uniguru from "../assets/uni-logo.png";

const Navbar: React.FC<{
  onLoginClick: () => void;
  onSignupClick: () => void;
  onLogout: () => void;
  isChatStarted: boolean;
}> = ({ onLoginClick, onSignupClick, onLogout, isChatStarted }) => {
  const { isLoggedIn, gurus, removeGuru, setSelectedGuru, logout } = useAuth();
  const location = useLocation();
  const navigate = useNavigate();
  const [uniguruDropdownOpen, setUniguruDropdownOpen] = useState(false);
  const [toolsDropdownOpen, setToolsDropdownOpen] = useState(false);
  const [customizeGuruOpen, setCustomizeGuruOpen] = useState(false);

  const uniguruRef = useRef<HTMLDivElement | null>(null);
  const toolsRef = useRef<HTMLDivElement | null>(null);
  const guruBoxRef = useRef<HTMLDivElement | null>(null);

  const toggleDropdown = (dropdownSetter: React.Dispatch<React.SetStateAction<boolean>>) => {
    dropdownSetter((prev) => !prev);
  };

  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      const target = event.target as Node;
      if (uniguruRef.current && !uniguruRef.current.contains(target)) setUniguruDropdownOpen(false);
      if (toolsRef.current && !toolsRef.current.contains(target)) setToolsDropdownOpen(false);
      if (guruBoxRef.current && !guruBoxRef.current.contains(target)) setCustomizeGuruOpen(false);
    };

    document.addEventListener("mousedown", handleClickOutside);
    return () => document.removeEventListener("mousedown", handleClickOutside);
  }, []);

  const handleLogout = async () => {
    try {
      await logout(navigate); // Pass navigate to the logout function
      onLogout(); // Optional, if you need to trigger additional logic on logout
    } catch (error) {
      console.error("Error logging out:", error);
    }
  };

  const handleGuruDelete = async (guruId: string) => {
    try {
      await clearChatMessages(guruId);
      await removeGuru(guruId);
    } catch (error) {
      console.error("Error deleting Guru or clearing chat:", error);
    }
  };

  const handleGuruSelect = (guru: { name: string; id: string }) => {
    setSelectedGuru(guru as any);
    setUniguruDropdownOpen(false);
  };

  return (
    <div className="w-full fixed top-3 z-[9999]">
      <div className="flex items-center justify-between w-full h-25 px-5 sm:px-3">
        <div className="flex items-center">
          <img src={uniguru} alt="uni-img" className="w-12 h-auto sm:w-16" />
          <div ref={uniguruRef} className="relative">
            {!isLoggedIn ? (
              <span className="text-xl ml-2 font-bold text-transparent bg-gradient-to-r from-[#896700] via-[#ffbf00] to-[#896700] bg-clip-text sm:text-2xl">
                UNIGURU
              </span>
            ) : (
              <button
                aria-haspopup="true"
                aria-expanded={uniguruDropdownOpen}
                className="text-xl ml-2 font-bold text-transparent bg-gradient-to-r from-[#896700] via-[#ffbf00] to-[#896700] bg-clip-text flex items-center group sm:text-2xl"
                onClick={() => toggleDropdown(setUniguruDropdownOpen)}
              >
                UNIGURU
                <FontAwesomeIcon
                  icon={faChevronDown}
                  className="text-gray-600 hover:text-white text-sm ml-2 sm:text-md"
                />
              </button>
            )}
            {isLoggedIn && uniguruDropdownOpen && (
              <div className="absolute top-full bg-black text-white rounded border border-white items-center mt-4 w-40 sm:bg-transparent">
                <ul>
                  {gurus?.map((guru: { name: string; id: string }, index: number) => (
                    <li
                      key={index}
                      className="hover:bg-gray-700 p-3 rounded cursor-pointer flex justify-between"
                      onClick={() => handleGuruSelect(guru)}
                    >
                      {guru.name}
                      <div className="flex space-x-2">
                        {/* Clear Chat Icon */}
                        <FontAwesomeIcon
                          icon={faTimes}
                          className="text-red-600 cursor-pointer group relative"
                          onClick={(e) => {
                            e.stopPropagation();
                            handleGuruDelete(guru.id);
                          }}
                        />
                        <span className="absolute bottom-8 left-1/2 transform -translate-x-1/2 text-xs text-white opacity-0 group-hover:opacity-100">
                          Clear Chat
                        </span>
                        {/* Delete Guru Icon */}
                        <FontAwesomeIcon
                          icon={faTrash}
                          className="text-red-600 cursor-pointer group relative"
                          onClick={(e) => {
                            e.stopPropagation();
                            handleGuruDelete(guru.id);
                          }}
                        />
                        <span className="absolute bottom-8 left-1/2 transform -translate-x-1/2 text-xs text-white opacity-0 group-hover:opacity-100">
                          Delete Guru
                        </span>
                      </div>
                    </li>
                  ))}
                </ul>
              </div>
            )}
          </div>
        </div>

        <div className="flex items-center space-x-5 relative">
          {location.pathname === "/" && !isLoggedIn && (
            <div className="flex space-x-3">
              {!isChatStarted && (
                <>
                  <button
                    type="button"
                    className="px-4 py-2 bg-transparent text-white border border-transparent rounded-lg text-sm sm:text-base hover:border-yellow-500 transition"
                    onClick={onLoginClick}
                  >
                    Login
                  </button>
                  <button
                    type="button"
                    className="px-4 py-2 bg-transparent text-white border border-transparent rounded-lg text-sm sm:text-base hover:border-yellow-500 transition"
                    onClick={onSignupClick}
                  >
                    Sign up
                  </button>
                </>
              )}
            </div>
          )}

          {location.pathname === "/chatpage" && isLoggedIn && (
            <>
              <div className="relative" ref={toolsRef}>
                <button
                  aria-haspopup="true"
                  aria-expanded={toolsDropdownOpen}
                  type="button"
                  onClick={() => toggleDropdown(setToolsDropdownOpen)}
                  className="border border-gray-700 rounded-3xl text-white text-md sm:px-4 px-3 sm:py-2 py-2 transition-all duration-300 hover:bg-white hover:text-black"
                >
                  Tools
                </button>
                {toolsDropdownOpen && (
                  <div className="absolute top-full bg-black text-white rounded border border-white mt-2 w-40">
                    <ul>
                      <li className="p-3 cursor-pointer hover:bg-gray-700">Option 1</li>
                      <li className="p-3 cursor-pointer hover:bg-gray-700">Option 2</li>
                    </ul>
                  </div>
                )}
              </div>

              <button
                className="border border-gray-700 rounded-3xl text-white text-md sm:px-4 px-3 sm:py-2 py-2 transition-all duration-300 hover:bg-white hover:text-black"
                onClick={() => toggleDropdown(setCustomizeGuruOpen)}
              >
                Guru
              </button>
              {customizeGuruOpen && (
                <div className="absolute top-full bg-black text-white rounded border border-white mt-2 w-40">
                  <ul>
                    <li className="p-3 cursor-pointer hover:bg-gray-700">Customize Option 1</li>
                    <li className="p-3 cursor-pointer hover:bg-gray-700">Customize Option 2</li>
                  </ul>
                </div>
              )}
            </>
          )}

          {isLoggedIn && (
            <button
              className="px-4 py-2 bg-transparent text-white border border-transparent rounded-lg text-sm sm:text-base hover:border-yellow-500 transition"
              onClick={handleLogout}
            >
              Logout
            </button>
          )}
        </div>
      </div>
    </div>
  );
};

export default Navbar;
