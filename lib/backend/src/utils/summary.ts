// utils/summary.ts

import { IMessage } from "../models/User.js"; // Import the IMessage interface

export const summarizeHistory = (messages: IMessage[]): string => {
  const historyLimit = 200; // Number of messages to summarize
  const relevantMessages = messages.slice(-historyLimit);
  return relevantMessages
    .map((msg) => `${msg.sender}: ${msg.content}`)
    .join("\n");
};
