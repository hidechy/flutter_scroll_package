import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class ScrollToIndexPage extends StatefulWidget {
  const ScrollToIndexPage({super.key, required this.title});

  final String title;

  @override
  // ignore: library_private_types_in_public_api
  _ScrollToIndexPageState createState() => _ScrollToIndexPageState();
}

class _ScrollToIndexPageState extends State<ScrollToIndexPage> {
  static const maxCount = 100;
  static const double maxHeight = 1000;
  final random = math.Random();
  final scrollDirection = Axis.vertical;

  late AutoScrollController controller;
  late List<List<int>> randomList;

  ///
  @override
  void initState() {
    super.initState();
    controller = AutoScrollController(
        viewportBoundaryGetter: () => Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: scrollDirection);
    randomList = List.generate(maxCount, (index) => <int>[index, (maxHeight * random.nextDouble()).toInt()]);
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              setState(() => counter = 0);
              _scrollToCounter();
            },
            icon: const Text('First'),
          ),
          IconButton(
            onPressed: () {
              setState(() => counter = maxCount - 1);
              _scrollToCounter();
            },
            icon: const Text('Last'),
          )
        ],
      ),
      body: ListView(
        scrollDirection: scrollDirection,
        controller: controller,
        children: randomList.map<Widget>((data) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: _getRow(data[0], math.max(data[1].toDouble(), 50)),
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _nextCounter,
        tooltip: 'Increment',
        child: Text(counter.toString()),
      ),
    );
  }

  int counter = -1;

  ///
  Future<dynamic> _nextCounter() {
    setState(() => counter = (counter + 1) % maxCount);
    return _scrollToCounter();
  }

  ///
  Future<dynamic> _scrollToCounter() async {
    await controller.scrollToIndex(counter, preferPosition: AutoScrollPosition.begin);
    await controller.highlight(counter);
  }

  ///
  Widget _getRow(int index, double height) {
    return _wrapScrollTag(
        index: index,
        child: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.topCenter,
          height: height,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.lightBlue, width: 4), borderRadius: BorderRadius.circular(12)),
          child: Text('index: $index, height: $height'),
        ));
  }

  ///
  Widget _wrapScrollTag({required int index, required Widget child}) => AutoScrollTag(
        key: ValueKey(index),
        controller: controller,
        index: index,
        highlightColor: Colors.black.withOpacity(0.1),
        child: child,
      );
}
