import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = "compras.db";
  static final _databaseVersion = 1;
  static final table = 'compras';

  static final columnId = 'id';
  static final columnMonto = 'monto';
  static final columnCategoria = 'categoria';
  static final columnFecha = 'fecha';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnMonto REAL NOT NULL,
            $columnCategoria TEXT NOT NULL,
            $columnFecha TEXT NOT NULL
          )
          ''');
  }

  Future<int> insertCompra(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> fetchCompras() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<int> updateCompra(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }
}
