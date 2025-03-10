import Groq from "groq-sdk";

export const configGroq = new Groq({ apiKey: process.env.GROQ_API_KEY });