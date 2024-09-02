import 'package:flutter/material.dart';

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
