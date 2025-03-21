const express = require("express");
const User = require("../model/User.js");
const authRouter = express.Router();
authRouter.post('/api/signup', async (req, res) => {
    try {
        const { name, email, profilePic } = req.body;
        let user = await User.findOne({ email: email });
        if (user != null) {
            user = new User({
                email: email,
                profilePic: profilePic,
                name: name,
            });
            user = await user.save();
        }
        res.json({ user: user });
    }
    catch (e) {
    }
});
module.exports = authRouter;
export {};
//# sourceMappingURL=auth.js.map