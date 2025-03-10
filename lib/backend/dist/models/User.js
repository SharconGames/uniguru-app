import mongoose, { Schema } from 'mongoose';
const messageSchema = new Schema({
    sender: {
        type: String,
        enum: ['user', 'guru'],
        required: true,
    },
    content: {
        type: String,
        required: true,
    },
    timestamp: {
        type: Date,
        default: Date.now,
    },
    model: {
        type: String,
    }
});
const userSchema = new Schema({
    name: { type: String, required: true },
    email: { type: String, required: true, unique: true },
    password: { type: String, default: null }, // Nullable for social logins
    googleId: { type: String }, // Optional for Google login
    chats: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Chat' }],
    chatbots: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Chatbot' }],
}, { timestamps: true });
const chatSchema = new Schema({
    user: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true,
    },
    chatbot: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Chatbot',
        required: true,
    },
    title: {
        type: String,
        trim: true, // Optional: Automatically trims any extra spaces
    },
    messages: [messageSchema], // Embedding the Message schema
}, { timestamps: true });
const chatbotSchema = new Schema({
    name: { type: String, required: true },
    description: { type: String },
    subject: { type: String, required: true },
    user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    chats: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Chat' }],
}, { timestamps: true });
// Create models from schemas
export const Message = mongoose.model('Message', messageSchema);
export const User = mongoose.model('User', userSchema);
export const Chat = mongoose.model('Chat', chatSchema);
export const Chatbot = mongoose.model('Chatbot', chatbotSchema);
//# sourceMappingURL=User.js.map