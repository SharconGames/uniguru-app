"use client";

import React, { useRef, useState } from "react";
import gsap from "gsap";
import { useNavigate } from "react-router-dom"; // Import useNavigate for navigation
import { useAuth } from "../context/AuthContext"; // Import AuthContext
import BHI from "../assets/blackhole-logo.png"; // Update path as needed
import StarsCanvas from "../components/StarBackground"; // Starry background effect
import Loginbox from "../components/Loginbox"; // Login box component

interface HomePageProps {
  isWelcomeHidden: boolean;
  onChatStarted: () => void; // Callback to notify App component
}

const HomePage: React.FC<HomePageProps> = ({ isWelcomeHidden, onChatStarted }) => {
  const [isLetChatVisible, setIsLetChatVisible] = useState(true); // State for button visibility
  const loginBoxRef = useRef<HTMLDivElement | null>(null);
  const welcomeContainerRef = useRef<HTMLDivElement | null>(null);
  const navigate = useNavigate(); // Hook for navigation
  const { isLoggedIn ,gurus } = useAuth(); // Retrieve login state and user data

  const handleLoginSuccess = () => {
    console.log("Login Successful!");
  };

  const handleLetChatClick = () => {
    console.log(isLoggedIn,gurus[0])
    if (isLoggedIn && gurus[0].id) {
      // Redirect if user is logged in and uniGuru exists
      navigate(`/uniguru/chat/${gurus[0].id}`);
    } else {
      // Run animations and show login box if not logged in
      setIsLetChatVisible(false);
      onChatStarted();

      if (loginBoxRef.current && welcomeContainerRef.current) {
        const screenWidth = window.innerWidth;

        // Hide welcome container on small screens
        if (screenWidth < 640) {
          welcomeContainerRef.current.style.display = "none";
        } else {
          welcomeContainerRef.current.style.display = "block";
        }

        // Adjust login box animation based on screen width
        if (screenWidth < 640) {
          gsap.fromTo(
            loginBoxRef.current,
            { y: "98vh", opacity: 0 },
            { y: "-120%", opacity: 1, duration: 1, ease: "power2.out" }
          );
        } else if (screenWidth < 1030) {
          gsap.fromTo(
            loginBoxRef.current,
            { y: "90%", opacity: 0 },
            { y: "200%", opacity: 1, duration: 0.5, ease: "power2.out" }
          );
        } else {
          gsap.fromTo(
            loginBoxRef.current,
            { x: "-300%", opacity: 0 },
            { x: "300%", y: "20", opacity: 1, duration: 1, ease: "power2.out" }
          );
        }

        loginBoxRef.current.style.display = "block";
      }
    }
  };

  return (
    <div className="relative min-h-full z-10">
      <div className="absolute inset-0 -z-10">
        <StarsCanvas />
      </div>

      <main className="flex flex-col items-center justify-center h-screen text-center p-4 relative z-10">
        {!isWelcomeHidden && (
          <div
            ref={welcomeContainerRef}
            className="welcome-container p-5 max-w-md relative z-10"
          >
            <p
              className="text-2xl sm:text-3xl font-bold bg-clip-text text-transparent mb-[10px] bg-[linear-gradient(135deg,_#61ACEF,_#9987ED,_#B679E1,_#9791DB,_#74BDCC,_#59D2BF)]"
              style={{ fontFamily: "inknut" }}
            >
              Welcome To
            </p>

            <p className="text-white text-sm sm:text-base leading-relaxed mb-6">
              Uniguru, a wise guide offering personalized support and mentorship.
              Together, let's illuminate the path to success.
            </p>
            {isLetChatVisible && (
              <button
                className="letchat-button px-6 py-3 text-md font-bold text-black-800 rounded-full hover:opacity-90 bg-[linear-gradient(135deg,_#61ACEF,_#9987ED,_#B679E1,_#9791DB,_#74BDCC,_#59D2BF)]"
                onClick={handleLetChatClick}
                style={{ fontFamily: "inknut" }}
              >
                Let's Chat
              </button>
            )}
          </div>
        )}

        <div
          ref={loginBoxRef}
          className={`login-box ${isWelcomeHidden ? "block" : "hidden"} fixed top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 shadow-md p-4 rounded-lg`}
        >
          <Loginbox onLoginSuccess={handleLoginSuccess} />
        </div>
      </main>

      <footer className="absolute bottom-5 right-5 z-10">
        <img src={BHI} alt="BHI Logo" className="h-12" />
      </footer>
    </div>
  );
};

export default HomePage;
