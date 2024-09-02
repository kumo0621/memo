import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'memo.dart';

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
      version: 2, // データベースバージョンを2に設定
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
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

    if (version >= 2) {
      await db.execute('''
      CREATE TABLE deleted_memos (
        id $idType,
        content $textType
      )
      ''');
    }
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2 && newVersion >= 2) {
      await db.execute('''
      CREATE TABLE deleted_memos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        content TEXT NOT NULL
      )
      ''');
    }
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

  Future<Memo> readDeletedMemo(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      'deleted_memos',
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

  Future<int> deleteFromDeleted(int id) async {
    final db = await instance.database;
    return await db.delete(
      'deleted_memos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Memo>> readAllMemos() async {
    final db = await instance.database;

    final orderBy = 'id ASC';
    final result = await db.query('memos', orderBy: orderBy);

    return result.map((json) => Memo.fromMap(json)).toList();
  }

  Future<List<Memo>> readAllDeletedMemos() async {
    final db = await instance.database;

    final orderBy = 'id ASC';
    final result = await db.query('deleted_memos', orderBy: orderBy);

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

    final memo = await readMemo(id);

    await db.insert('deleted_memos', memo.toMap());  // 削除前に削除済みメモを保存
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
