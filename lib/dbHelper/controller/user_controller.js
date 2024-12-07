const UserService = require("../services/user_services")

//This will call the userservices with data
exports.register = async(req,res,next) =>{
    try {
        //passing the data to the user_service risgter user
        const {name,email,password} = req.body;             
        const successRes = await UserService.registerUser(name,email,password);

        res.json({status:true,success:"User Registered Successfully"});


    } catch (error) {
        
    }
}