import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../Models/Item.dart';
import '../Models/kategori.dart';
import '../Models/User.dart';

class DbHelper {
  static DbHelper _dbHelper;
  static Database _database;
  DbHelper._createObject();
  Future<Database> initDb() async {
    //untuk menentukan nama database dan lokasi yg dibuat
   Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'item.db';

    //create, read databases
    //create, read databases
    var database = openDatabase(path,
        version: 8, onCreate: _createDb, onUpgrade: _onUpgrade);
//mengembalikan nilai object sebagai hasil dari fungsinya
    return database;
  }

// update table baru
  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    _createDb(db, newVersion);
  }

  //buat tabel baru dengan nama item
  void _createDb(Database db, int version) async {
    var batch = db.batch();
    batch.execute('DROP TABLE IF EXISTS item');
    batch.execute('DROP TABLE IF EXISTS kategori');
    batch.execute('''
    CREATE TABLE item (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    kategori TEXT,
    price INTEGER,
    stock INTEGER,
    idUser INTEGER
    )
    ''');
    batch.execute('''
    CREATE TABLE kategori (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT
  
    )
    ''');
    batch.execute('''
    CREATE TABLE user (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT,
    password TEXT,
    name TEXT
    )
    ''');
    batch.insert('kategori',{'name': 'Maknan'});
    batch.insert('kategori',{'name': 'Minuman'});
    batch.insert('kategori',{'name': 'Baju'});
    
    await batch.commit();
    
    
  }
  


//select databases
  Future<List<Map<String, dynamic>>> select() async {
    Database db = await this.initDb();
    var mapList = await db.query('item', orderBy: 'name');
    return mapList;
  }
  //select kategori
  Future<List<String>> selectKategori() async {
    Database db = await this.initDb();
    var mapList = await db.rawQuery('SELECT name from kategori');
    return mapList.map((Map<String, dynamic> row){return row["name"] as String;
    }).toList();
  }
 Future<List<Map<String, dynamic>>> selectUser(int id) async {
    Database db = await this.initDb();
    var mapList = await db.query('user',limit: 3, where: 'id = $id');
    return mapList;
  }
//create databases
  Future<int> insert(Item object) async {
    Database db = await this.initDb();
    int count = await db.insert('item', object.toMap());
    return count;
  }

//update databases
  Future<int> update(Item object) async {
    Database db = await this.initDb();
    int count = await db
        .update('item', object.toMap(), where: 'id=?', whereArgs: [object.id]);
    return count;
  }

  //delete databases
  Future<int> delete(int id) async {
    Database db = await this.initDb();
    int count = await db.delete('item', where: 'id=?', whereArgs: [id]);
    return count;
  }

  Future<List<Item>> getItemList() async {
    var itemMapList = await select();
    int count = itemMapList.length;
    List<Item> itemList = List<Item>();
    for (int i = 0; i < count; i++) {
      itemList.add(Item.fromMap(itemMapList[i]));
    }
    return itemList;
  }

  Future<List<Kategori>> getKategoriList() async {
    var kategoriMapList = await select();
    int count = kategoriMapList.length;
    List<Kategori> kategoriList = List<Kategori>();
    for (int i = 0; i < count; i++) {
      kategoriList.add(Kategori.fromMapKategori(kategoriMapList[i]));
    }
    return kategoriList;
  }

  factory DbHelper() {
    if (_dbHelper == null) {
      _dbHelper = DbHelper._createObject();
    }
    return _dbHelper;
  }
  Future<Database> get database async {
    if (_database == null) {
      _database = await initDb();
    }
    return _database;
  }
  
  Future<User> getLogin(String user, String password) async {
    var dbClient = await this.initDb();
    var res = await dbClient.rawQuery(
        "SELECT * FROM user WHERE username = '$user' and password = '$password'");

    if (res.length > 0) {
      return new User.fromMapUser(res.first);
    }
    return null;
  }

  Future<List<User>> getAllUser() async {
    var dbClient = await this.initDb();
    var res = await dbClient.query("user");

    List<User> list =
        res.isNotEmpty ? res.map((c) => User.fromMapUser(c)).toList() : null;
    return list;
  }
 Future<int> insertUser(User user) async {
    Database db = await this.initDb();
    int count = await db.insert('user', user.toMapUser());
    return count;
  }

 Future<List<User>> getUserList(int id) async {
    var itemMapList = await selectUser(id);
    int count = itemMapList.length;
    List<User> itemList = List<User>();
    for (int i = 0; i < count; i++) {
      itemList.add(User.fromMapUser(itemMapList[i]));
    }
    return itemList;
  }

}
