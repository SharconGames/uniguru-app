import { Router } from "express";
import userRoutes from "./user_routes.js";
import chatRoutes from "./chat_routes.js";
import gurusRoutes from "./gurus_routes.js";
import featuresRoutes from "./features_routes.js";
const appRouter = Router();
appRouter.use("/user", userRoutes); //domain/api/v1/user
appRouter.use("/chat", chatRoutes); //domain/api/v1/chats
appRouter.use("/guru", gurusRoutes);
appRouter.use("/feature", featuresRoutes);
export default appRouter;
//# sourceMappingURL=index.js.map