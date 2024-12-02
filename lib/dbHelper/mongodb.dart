import 'package:mongo_dart/mongo_dart.dart';
import 'package:uniguru/dbHelper/constant.dart';

class MongoDatabase {
  static late Db db;
  static late DbCollection userCollection;

  static Future<void> connect() async {
    try {
      // Create and open the database connection
      db = await Db.create(MONGO_CONN_URL);
      await db.open();

      // Check if the database is connected
      if (db.isConnected) {
        print('database is connected successfully');
      } else {
        print('Failed to connect to MongoDB.');
      }

      // Initialize the collection
      //userCollection = db.collection(USER_COLLECTION);
    } catch (e) {
      print('Error connecting to MongoDB: $e');
    }
  }
}
