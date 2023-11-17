import 'package:flutter/material.dart';

import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

// class SplPage extends StatefulWidget {
//   const SplPage({super.key});
//
//   @override
//   State<StatefulWidget> createState() => _SplPageState();
// }
//
// class _SplPageState extends State<SplPage> {

class SplPage extends StatelessWidget {
  SplPage({super.key});

  final items = List<String>.generate(100, (i) => 'Item$i');

  // スクロールを司るコントローラ
  final ItemScrollController _itemScrollController = ItemScrollController();

  // // リストアイテムのインデックスを司るリスナー
  // final ItemPositionsListener _itemPositionsListener = ItemPositionsListener.create();

  // @override
  // void initState() {
  //   super.initState();
  //   // 表示中のアイテムを知るためにリスナー登録
  //   _itemPositionsListener.itemPositions.addListener(_itemPositionsCallback);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///

      appBar: AppBar(title: const Text('scrollable_positioned_list example')),

      ///

      body: ScrollablePositionedList.separated(
        itemBuilder: (context, index) {
          return ListTile(title: Text(items[index]));
        },
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemCount: items.length,
        itemScrollController: _itemScrollController,
        // // コントローラ指定
        // itemPositionsListener: _itemPositionsListener, // リスナー指定
      ),

      ///

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _scroll(index: 70);
        }, // ボタンを押したらスクロールするよ
        child: const Icon(Icons.airplanemode_active),
      ),

      ///
    );
  }

  // @override
  // void dispose() {
  //   // 使い終わったら破棄
  //   _itemPositionsListener.itemPositions.removeListener(_itemPositionsCallback);
  //   super.dispose();
  // }

  void _scroll({required int index}) {
    // スムーズスクロールを実行する
    _itemScrollController.scrollTo(
      index: index,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOutCubic,
    );
  }

// void _itemPositionsCallback() {
//   // 表示中のリストアイテムのインデックス情報を取得
//   final visibleIndexes = _itemPositionsListener.itemPositions.value.toList().map(
//         (itemPosition) => itemPosition.index,
//       );
//
//   print('現在表示中アイテムのindexは $visibleIndexes');
// }
}
