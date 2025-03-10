// utils/summary.ts
export const summarizeHistory = (messages) => {
    const historyLimit = 200; // Number of messages to summarize
    const relevantMessages = messages.slice(-historyLimit);
    return relevantMessages
        .map((msg) => `${msg.sender}: ${msg.content}`)
        .join("\n");
};
//# sourceMappingURL=summary.js.map