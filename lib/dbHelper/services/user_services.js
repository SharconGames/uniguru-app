const UserModel = require('../model/user_model');
//In this the data is stored in the 
class UserService{
    static async registerUser(name,email,password){
      
        try{
            const createUser = new UserModel({name,email,password});
            return await createUser.save();

        }catch(err){
            throw err;
        }
    }

}

module.exports = UserService;