import React, { createContext, useContext, useState, ReactNode } from 'react';
import { deleteGuru } from '../helpers/api-communicator';

// Define the context type
interface GuruContextType {
    selectedGuru: Guru | null;
    setSelectedGuru: (guru: Guru | null) => void;
    clearUserChats: () => void;
    deleteGurus: (guruId: string) => void;
}

// Create the context with a default value
const GuruContext = createContext<GuruContextType | undefined>(undefined);

export const useGuru = () => {
    const context = useContext(GuruContext);
    if (!context) {
        throw new Error("useGuru must be used within a GuruProvider");
    }
    return context;
};

// Define a type for the Guru
type Guru = {
    name: string;
    description: string;
    subject: string;
    id: string;
    userid: string;
};

// Create a provider component
export const GuruProvider: React.FC<{ children: ReactNode }> = ({ children }) => {
    const [selectedGuru, setSelectedGuru] = useState<Guru | null>(null);

    const clearUserChats = async () => {
        // Call API to clear user chats
        try {
            // await deleteUserChats();
            setSelectedGuru(null);
        } catch (error) {
            console.error("Failed to clear chats:", error);
        }
    };

    const deleteGurus = async (guruId: string) => {
        // Call API to delete guru
        try {
            await deleteGuru(guruId);
            setSelectedGuru(null);
        } catch (error) {
            console.error("Failed to delete guru:", error);
        }
    };

    return (
        <GuruContext.Provider value={{ selectedGuru, setSelectedGuru, clearUserChats, deleteGurus }}>
            {children}
        </GuruContext.Provider>
    );
};