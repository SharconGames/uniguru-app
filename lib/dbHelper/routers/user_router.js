const router = require('express').Router();
const UserController = require("../controller/user_controller");
//User hits this api and will direct to the controller
router.post('/registration',UserController.register);             // Create the registration api

module.exports = router;