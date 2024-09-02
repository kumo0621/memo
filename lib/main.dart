import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'memo_model.dart';
import 'memo_page.dart';
import 'deleted_memo_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MemoModel(),
      child: MaterialApp(
        home: MemoTabPage(),
      ),
    );
  }
}

class MemoTabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(

          bottom: TabBar(
            tabs: [
              Tab(text: 'メモ'),
              Tab(text: '削除履歴'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MemoPage(),
            DeletedMemoPage(),
          ],
        ),
      ),
    );
  }
}
