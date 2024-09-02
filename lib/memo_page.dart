import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'memo_model.dart';

class MemoPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final memoModel = Provider.of<MemoModel>(context);

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'メモを入力',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    memoModel.addMemo(_controller.text);
                    _controller.clear();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<MemoModel>(
              builder: (context, memoModel, child) {
                return ListView.builder(
                  itemCount: memoModel.memos.length,
                  itemBuilder: (context, index) {
                    final memo = memoModel.memos[index];
                    return ListTile(
                      title: Text(memo.content),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          memoModel.deleteMemo(memo.id!);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
