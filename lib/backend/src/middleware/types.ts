// // src/types/custom.d.ts
// import { Document } from 'mongoose';

// interface IUser extends Document {
//   _id: string;
//   name: string;
//   email: string;
//   profilePic: string;
//   googleId?: string;
//   createdAt: Date;
//   updatedAt: Date;
// }

// declare global {
//   namespace Express {
//     interface Request {
//       token?: string;
//       user?: string | IUser; // can be either user ID (string) or user document
//     }
//   }
// }