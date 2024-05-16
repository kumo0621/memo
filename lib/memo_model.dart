import 'package:flutter/material.dart';
import 'memo_database.dart';

class Memo {
  final int? id;
  final String content;

  Memo({this.id, required this.content});

  Memo copy({int? id, String? content}) => Memo(
    id: id ?? this.id,
    content: content ?? this.content,
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
    };
  }

  factory Memo.fromMap(Map<String, dynamic> map) {
    return Memo(
      id: map['id'],
      content: map['content'],
    );
  }
}

class MemoModel with ChangeNotifier {
  List<Memo> _memos = [];

  List<Memo> get memos => _memos;

  MemoModel() {
    _loadMemos();
  }

  Future<void> _loadMemos() async {
    final memos = await MemoDatabase.instance.readAllMemos();
    _memos = memos;
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
  }

  Future<void> deleteAllMemos() async {
    await MemoDatabase.instance.deleteAll();
    _loadMemos();
  }
}
