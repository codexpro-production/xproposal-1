import 'package:mongo_dart/mongo_dart.dart';

class MongoDatabase {
  static Db? db;
  static DbCollection? usersCollection;

  static Future<void> connect() async {
    try {
      //db = await Db.create("mongodb+srv://codexpro:l1o5d4weBG6977lm@cluster0.ts0d7.mongodb.net/Cluster0?retryWrites=true&w=majority");
      db = await Db.create("mongodb+srv://codexpro:l1o5d4weBG6977lm@cluster0.ts0d7.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0");
      await db!.open();
      usersCollection = db!.collection("users");
      print("MongoDB bağlantısı kuruldu.");
    } catch (e) {
      print("MongoDB bağlantı hatası: $e");
    }
  }

  static Future<void> close() async {
    try {
      await db!.close();
      print("MongoDB bağlantısı kapatıldı.");
    } catch (e) {
      print("MongoDB bağlantısını kapatma hatası: $e");
    }
  }
}
