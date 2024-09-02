import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'memo_model.dart';

class DeletedMemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final memoModel = Provider.of<MemoModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('削除済みメモ'),
      ),
      body: Consumer<MemoModel>(
        builder: (context, memoModel, child) {
          // メモを逆順にして表示する
          final reversedMemos = memoModel.deletedMemos.reversed.toList();

          return ListView.builder(
            itemCount: reversedMemos.length,
            itemBuilder: (context, index) {
              final memo = reversedMemos[index];
              return ListTile(
                title: Text(memo.content),
                trailing: IconButton(
                  icon: Icon(Icons.restore),
                  onPressed: () {
                    memoModel.restoreMemo(memo.id!);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
