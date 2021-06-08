import 'package:sqflite/sqflite.dart';

class User {
  int? id;
  String? name;
  String? password;

  User({this.id, this.name, this.password});

  User.fromMap(Map<String, Object?> map) {
    id = (map['id']??1) as int?;
    name = (map['name']??"name") as String?;
    password = (map['password']??"password") as String?;
  }

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      "name": name,
      "password": password,
    };
    if(id != null)
      map["id"] = id;
    return map;
  }
}

class UserDatabase {
  late Database _db;

  Future initDB() async {
    String path = await getDatabasesPath();
    print(path + " --------------PATH");
    _db = await openDatabase('meditop_go.db', version: 1,
        onCreate: (Database db, int version) {
      String usuarios = '''create table users(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name VARCHAR(100) NOT NULL,
          password VARCHAR(100) NOT NULL
          )''';
      db.execute(usuarios);
    });
    print("---------DB CREADA--------");
  }

  Future<User> insert(User user) async {
    //_db.rawInsert('''insert into users(name, password) values (
    //    $user.name, $user.password  )''');
    user.id = await _db.insert("users", user.toMap());
    return user;
  }

  Future<User> getUser() async {
    List<Map<String, Object?>> results = await _db.query("users");
    if(results.length > 0)
      return User.fromMap(results.first);
    return User();
  }

  Future<int> delete(int id) async {
    return await _db.delete("users", where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(User user) async {
    return await _db.update("users", user.toMap(),
        where: 'id = ?', whereArgs: [user.id]);
  }

  Future close() async => _db.close();
}
