import { Server } from "socket.io";
import app from "./app.js";
import { connectToDatabase } from "./controllers/db/connections.js";
import http from "http";
import authRouter from "./route/auth.js";
// Set up the HTTP server to integrate with Socket.IO
const server = http.createServer(app);
// Initialize Socket.IO with the server
const io = new Server(server, {
    cors: {
        origin: "http://localhost:5173", // Make sure this matches your frontend URL
        methods: ["GET", "POST"],
        credentials: true, // Ensure credentials are handled
    },
});
// Attach io instance to the app
app.set('io', io);
app.use(authRouter);
// Socket.IO connection handler
io.on("connection", (socket) => {
    console.log("A user connected");
    socket.on("disconnect", () => {
        console.log("A user disconnected");
    });
});
const PORT = process.env.PORT || 8010;
connectToDatabase()
    .then(() => {
    server.listen(PORT, () => console.log(`Server Open & Connected To Database 🤟 on port ${PORT}`));
})
    .catch((err) => console.log(err));
//# sourceMappingURL=index.js.map