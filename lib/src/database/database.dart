import 'package:sqflite/sqflite.dart';

class User {
  int? id;
  String? names;
  String? lastNames;
  String? email;
  String? password;
  String? birthday;
  String? gender;

  User({
    this.id,
    this.names,
    this.lastNames,
    this.email,
    this.password,
    this.birthday,
    this.gender
  });

  User.fromMap(Map<String, Object?> map) {
    names = (map['names'] ?? "name") as String?;
    lastNames = (map['lastNames'] ?? "lastName") as String?;
    email = (map['email'] ?? "email") as String?;
    password = (map['password'] ?? "password") as String?;
    birthday = (map['birthday'] ?? "2000-01-01") as String?;
    gender = (map['gender'] ?? "M") as String?;
  }

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      "names": names,
      "lastNames": lastNames,
      "email": email,
      "password": password,
      "birthday": birthday,
      "gender": gender
    };
    if (id != null) map["id"] = id;
    return map;
  }
}

class PersonalDatabase {
  late Database _db;

  Future initDB() async {
    String path = await getDatabasesPath();
    print(" --------------PATH DB-------------");
    print(path);
    _db = await openDatabase('meditop_go.db', version: 1,
        onCreate: (Database db, int version) {
    });
    String query = '''CREATE TABLE IF NOT EXISTS USERS (
        id INTEGER NOT NULL,
        names VARCHAR(100) NOT NULL,
        lastNames VARCHAR(100) NOT NULL,
        email VARCHAR(100) NOT NULL,
        password VARCHAR(100) NOT NULL,
        birthday DATE NOT NULL,
        gender VARCHAR(1) NOT NULL,
        PRIMARY KEY (id AUTOINCREMENT)
      );''';
    try {
      //String query = 'delete from users where id > 0';
      await _db.execute(query);
    }catch(e){
      print(e);
    }
    print("---------DB ABIERTA---------");
  }

  Future initSimpleDB() async {
    String path = await getDatabasesPath();
    print(path + " --------------PATH");
    _db = await openDatabase('meditop_go.db', version: 1);
    print("---------DB ABIERTA--------");
  }

  Future<User> insert(User user) async {
    user.id = await _db.insert("users", user.toMap());
    return user;
  }

  Future<User> getUser() async {
    List<Map<String, Object?>> results = await _db.query("users");
    if (results.length > 0) return User.fromMap(results.first);
    return User();
  }

  Future<int> delete(int id) async {
    return await _db.delete("users", where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(User user) async {
    return await _db
        .update("users", user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }

  Future close() async {
    _db.close();
    print('------------DB CERRADA--------');
  }

  Future execute(String query, [List<Object?>? arguments]) async{
    await _db.execute(query, arguments);
    print('------------QUERY EXECUTED----------');
  }

  Future<List<Map<String,Object?>>> rawQuery(String query, [List<Object?>? arguments]) async{
    List<Map<String, Object?>> ret = await _db.rawQuery(query, arguments);
    print('------------RAW QUERY EXECUTED----------');
    return ret;
  }
}
