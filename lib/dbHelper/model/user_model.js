const app = require('mongoose');
const db = require('../config/db');
const bcrypt =require("bcrypt"); //to encypt the password into hash

const { default: mongoose } = require('mongoose');

const {Schema} = mongoose;

//user schema 
const test = new Schema({
    name:{
        type:String,
        lowercase:true,
        required: true,
    },
    email:{
        type:String,
        lowercase:true,
        required: true,
        unique:true
    },
    password:{
        type:String,
        required: true,
        
    },
    


});
//function to hash password which is saved in user_service
test.pre('save' ,async function () {
    try {
        var user = this;
        const salt = await(bcrypt.genSalt(10));
        const hashpass = await bcrypt.hash(user.password,salt);

        user.password = hashpass;
        
    } catch (error) {
        
        
    }
    
});

const UserModel = db.model('users',test);

module.exports = UserModel;  //export the schema



