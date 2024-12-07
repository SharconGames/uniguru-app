const mongoose = require('mongoose');
 //create connection to mongodb
const connection = mongoose.createConnection('mongodb+srv://elementsbyrbfvillas:FVK4qMaHePfOZSDZ@guru.1zdln6l.mongodb.net/?retryWrites=true&w=majority&appName=Guru').on('open',()=>{
    console.log("MongoDb Connected!!!");
}).on('error',()=> {
    console.log("MongoDb is not Connected ")
});

module.exports = connection;