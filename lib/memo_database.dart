import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'memo_model.dart';

class MemoDatabase {
  static final MemoDatabase instance = MemoDatabase._init();

  static Database? _database;

  MemoDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('memos.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
CREATE TABLE memos (
  id $idType,
  content $textType
  )
''');
  }

  Future<Memo> create(Memo memo) async {
    final db = await instance.database;

    final id = await db.insert('memos', memo.toMap());
    return memo.copy(id: id);
  }

  Future<Memo> readMemo(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      'memos',
      columns: ['id', 'content'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Memo.fromMap(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Memo>> readAllMemos() async {
    final db = await instance.database;

    final orderBy = 'id ASC';
    final result = await db.query('memos', orderBy: orderBy);

    return result.map((json) => Memo.fromMap(json)).toList();
  }

  Future<int> update(Memo memo) async {
    final db = await instance.database;

    return db.update(
      'memos',
      memo.toMap(),
      where: 'id = ?',
      whereArgs: [memo.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      'memos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAll() async {
    final db = await instance.database;

    return await db.delete('memos');
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
