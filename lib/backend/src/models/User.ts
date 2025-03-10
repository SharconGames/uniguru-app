import mongoose, { Document, Schema } from 'mongoose';

// Define the Message interface and schema
export interface IMessage {
  sender: 'user' | 'guru';
  content: string;
  timestamp: Date;
  _id: string | null;
  model: string;  // Keep model as a string for each message, not as part of the Mongoose document interface
}

const messageSchema = new Schema<IMessage>({
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

// Define the User interface and schema
export interface IUser extends Document {
  name: string;
  email: string;
  password: string | null;
  googleId?: string;
  chats: mongoose.Types.ObjectId[];
  chatbots: mongoose.Types.ObjectId[]; // References ChatHistory
}

const userSchema = new Schema<IUser>({
  name: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  password: { type: String, default: null }, // Nullable for social logins
  googleId: { type: String }, // Optional for Google login
  chats: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Chat' }],
  chatbots: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Chatbot' }],
}, { timestamps: true });



// Define the Chat interface and schema
export interface IChat extends Document {
  user: mongoose.Types.ObjectId;
  chatbot: IChatbot;  // Allow chatbot to be either ObjectId or populated Chatbot
  title:string;
  messages: IMessage[];
}

const chatSchema = new Schema<IChat>({
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


// Define the Chatbot interface and schema
export interface IChatbot extends Document {
  name: string;
  description?: string;
  subject: string;
  user: mongoose.Types.ObjectId;
  chats: mongoose.Types.ObjectId[];
}

const chatbotSchema = new Schema<IChatbot>({
  name: { type: String, required: true },
  description: { type: String },
  subject: { type: String, required: true },
  user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  chats: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Chat' }],
}, { timestamps: true });

// Create models from schemas
export const Message = mongoose.model<IMessage>('Message', messageSchema);
export const User = mongoose.model<IUser>('User', userSchema);
export const Chat = mongoose.model<IChat>('Chat', chatSchema);
export const Chatbot = mongoose.model<IChatbot>('Chatbot', chatbotSchema);
