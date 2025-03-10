import React, { useState } from "react";
import { Route, Routes, useNavigate } from "react-router-dom";
import Navbar from "./components/Navbar";
import HomePage from "./pages/HomePage";
import Loginbox from "./components/Loginbox";
import Signupbox from "./components/Signupbox";
import StarsCanvas from "./components/StarBackground";
import ChatPage from "./pages/ChatPage";
import { useAuth } from "./context/AuthContext";

function App() {
  const [isLoginVisible, setIsLoginVisible] = useState(false);
  const [isSignupVisible, setIsSignupVisible] = useState(false);
  const [isWelcomeHidden, setIsWelcomeHidden] = useState(false); // New state
  const [isChatStarted, setIsChatStarted] = useState(false); // Track if Let's Chat was clicked
  const navigate = useNavigate();
  const auth = useAuth();


  const handleLoginClick = () => {
    setIsLoginVisible(true);
    setIsSignupVisible(false);
    setIsWelcomeHidden(true); // Hide Welcome Container
  };

  const handleSignupClick = () => {
    setIsSignupVisible(true);
    setIsLoginVisible(false);
    setIsWelcomeHidden(true); // Hide Welcome Container
  };

  const handleOverlayClick = (e: React.MouseEvent) => {
    if (e.target === e.currentTarget) {
      setIsLoginVisible(false);
      setIsSignupVisible(false);
      setIsWelcomeHidden(false); // Show Welcome Container
    }
  };

  const handleLoginSuccess = () => {
    localStorage.setItem("isLoggedIn", "true");
    setIsLoginVisible(false);
  };

  const handleLogout = () => {
    localStorage.removeItem("isLoggedIn");
    navigate("/");
  };

  const handleChatStarted = () => {
    setIsChatStarted(true); // Hide Login/Signup buttons when Let's Chat is clicked
  };

  return (
    <main>
      <Navbar
        onLoginClick={handleLoginClick}
        onSignupClick={handleSignupClick}
        onLogout={handleLogout}
        isChatStarted={isChatStarted} // Pass the state to Navbar
      />

      <div className="absolute inset-0 -z-10">
        <StarsCanvas />
      </div>

      <Routes>
        <Route
          path="/"
          element={
            <HomePage 
              isWelcomeHidden={isWelcomeHidden} 
              onChatStarted={handleChatStarted} // Pass callback to HomePage
            />
          }
        />
        {auth?.isLoggedIn && auth.user && (
                    <>
                        {/* <Route path="/create-guru" element={<CreateGuruPopup open={true} onClose={() => {}} />} /> */}
                        <Route path="/:Guruname/c/:chatId" element={<ChatPage />} />
                    </>
        )}
        <Route path="/chatpage" element={<ChatPage />} />
      </Routes>

      {isLoginVisible && (
        <div
          className="fixed inset-0 flex justify-center items-center z-50"
          onClick={handleOverlayClick}
        >
          <div className="login-box shadow-md p-4 rounded-lg">
            <Loginbox onLoginSuccess={handleLoginSuccess} />
          </div>
        </div>
      )}

      {isSignupVisible && (
        <div
          className="fixed inset-0 flex justify-center items-center z-50"
          onClick={handleOverlayClick}
        >
          <div className="signup-box shadow-md p-4 rounded-lg">
            <Signupbox />
          </div>
        </div>
      )}
    </main>
  );
}

export default App;
