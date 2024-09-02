import 'package:flutter/material.dart';
import 'memo_database.dart';
import 'memo.dart';

class MemoModel with ChangeNotifier {
  List<Memo> _memos = [];
  List<Memo> _deletedMemos = [];

  List<Memo> get memos => _memos;
  List<Memo> get deletedMemos => _deletedMemos;

  MemoModel() {
    _loadMemos();
    _loadDeletedMemos();
  }

  Future<void> _loadMemos() async {
    final memos = await MemoDatabase.instance.readAllMemos();
    _memos = memos;
    notifyListeners();
  }

  Future<void> _loadDeletedMemos() async {
    final deletedMemos = await MemoDatabase.instance.readAllDeletedMemos();
    _deletedMemos = deletedMemos;
    notifyListeners();
  }

  Future<void> addMemo(String content) async {
    final memo = Memo(content: content);
    await MemoDatabase.instance.create(memo);
    _loadMemos();
  }

  Future<void> deleteMemo(int id) async {
    await MemoDatabase.instance.delete(id);
    _loadMemos();
    _loadDeletedMemos();
  }

  Future<void> restoreMemo(int id) async {
    final memo = await MemoDatabase.instance.readDeletedMemo(id);
    await MemoDatabase.instance.create(memo); // 元のDBに戻す
    await MemoDatabase.instance.deleteFromDeleted(id); // 削除されたメモリストから削除
    _loadMemos();
    _loadDeletedMemos();
  }

  Future<void> deleteAllMemos() async {
    await MemoDatabase.instance.deleteAll();
    _loadMemos();
  }
}
