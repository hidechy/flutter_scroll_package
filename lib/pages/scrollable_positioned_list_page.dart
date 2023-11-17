import 'dart:math';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

const numberOfItems = 5001;
const minItemHeight = 20.0;
const maxItemHeight = 150.0;
const scrollDuration = Duration(seconds: 2);

const randomMax = 1 << 32;

class ScrollablePositionedListPage extends StatefulWidget {
  const ScrollablePositionedListPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ScrollablePositionedListPageState createState() => _ScrollablePositionedListPageState();
}

class _ScrollablePositionedListPageState extends State<ScrollablePositionedListPage> {
  final ItemScrollController itemScrollController = ItemScrollController();

  final ScrollOffsetController scrollOffsetController = ScrollOffsetController();

  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  late List<double> itemHeights;

  late List<Color> itemColors;

  bool reversed = false;

  double alignment = 0;

  ///
  @override
  void initState() {
    super.initState();

    final heightGenerator = Random(328902348);

    final colorGenerator = Random(42490823);

    itemHeights = List<double>.generate(
      numberOfItems,
      (int _) => heightGenerator.nextDouble() * (maxItemHeight - minItemHeight) + minItemHeight,
    );

    itemColors = List<Color>.generate(
      numberOfItems,
      (int _) => Color(colorGenerator.nextInt(randomMax)).withOpacity(1),
    );
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Material(
      child: OrientationBuilder(
        builder: (context, orientation) => Column(
          children: <Widget>[
            Expanded(
              child: list(orientation),
            ),
            positionsView,
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      scrollControlButtons,
                      scrollOffsetControlButtons,
                      const SizedBox(height: 10),
                      jumpControlButtons,
                      alignmentControl,
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  ///
  Widget get alignmentControl {
    return Row(
      children: <Widget>[
        const Text('Alignment: '),
        SizedBox(
          width: 200,
          child: SliderTheme(
            data: const SliderThemeData(showValueIndicator: ShowValueIndicator.always),
            child: Slider(
              value: alignment,
              label: alignment.toStringAsFixed(2),
              onChanged: (double value) => setState(() => alignment = value),
            ),
          ),
        ),
      ],
    );
  }

  ///
  Widget list(Orientation orientation) {
    return ScrollablePositionedList.builder(
      itemCount: numberOfItems,
      itemBuilder: (context, index) => item(index, orientation),
      itemScrollController: itemScrollController,
      itemPositionsListener: itemPositionsListener,
      scrollOffsetController: scrollOffsetController,
      reverse: reversed,
      scrollDirection: orientation == Orientation.portrait ? Axis.vertical : Axis.horizontal,
    );
  }

  ///
  Widget get positionsView {
    return ValueListenableBuilder<Iterable<ItemPosition>>(
      valueListenable: itemPositionsListener.itemPositions,
      builder: (context, positions, child) {
        int? min;
        int? max;
        if (positions.isNotEmpty) {
          min = positions
              .where((ItemPosition position) => position.itemTrailingEdge > 0)
              .reduce((ItemPosition min, ItemPosition position) {
            return position.itemTrailingEdge < min.itemTrailingEdge ? position : min;
          }).index;

          max = positions
              .where((ItemPosition position) => position.itemLeadingEdge < 1)
              .reduce((ItemPosition max, ItemPosition position) {
            return position.itemLeadingEdge > max.itemLeadingEdge ? position : max;
          }).index;
        }
        return Row(
          children: <Widget>[
            Expanded(child: Text('First Item: ${min ?? ''}')),
            Expanded(child: Text('Last Item: ${max ?? ''}')),
            const Text('Reversed: '),
            Checkbox(value: reversed, onChanged: (bool? value) => setState(() => reversed = value!))
          ],
        );
      },
    );
  }

  ///
  Widget get scrollControlButtons {
    return Row(
      children: <Widget>[
        const Text('scroll to'),
        scrollItemButton(0),
        scrollItemButton(5),
        scrollItemButton(10),
        scrollItemButton(100),
        scrollItemButton(1000),
        scrollItemButton(5000),
      ],
    );
  }

  ///
  Widget get scrollOffsetControlButtons {
    return Row(
      children: <Widget>[
        const Text('scroll by'),
        scrollOffsetButton(-1000),
        scrollOffsetButton(-100),
        scrollOffsetButton(-10),
        scrollOffsetButton(10),
        scrollOffsetButton(100),
        scrollOffsetButton(1000),
      ],
    );
  }

  ///
  Widget get jumpControlButtons {
    return Row(
      children: <Widget>[
        const Text('jump to'),
        jumpButton(0),
        jumpButton(5),
        jumpButton(10),
        jumpButton(100),
        jumpButton(1000),
        jumpButton(5000),
      ],
    );
  }

  ///
  ButtonStyle _scrollButtonStyle({required double horizonalPadding}) {
    return ButtonStyle(
      padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: horizonalPadding)),
      minimumSize: MaterialStateProperty.all(Size.zero),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  ///
  Widget scrollItemButton(int value) {
    return TextButton(
      key: ValueKey<String>('Scroll$value'),
      onPressed: () => scrollTo(value),
      style: _scrollButtonStyle(horizonalPadding: 20),
      child: Text('$value'),
    );
  }

  ///
  Widget scrollOffsetButton(int value) {
    return TextButton(
      key: ValueKey<String>('Scroll$value'),
      onPressed: () => scrollBy(value.toDouble()),
      style: _scrollButtonStyle(horizonalPadding: 10),
      child: Text('$value'),
    );
  }

  ///
  Widget scrollPixelButton(int value) {
    return TextButton(
      key: ValueKey<String>('Scroll$value'),
      onPressed: () => scrollTo(value),
      style: _scrollButtonStyle(horizonalPadding: 20),
      child: Text('$value'),
    );
  }

  ///
  Widget jumpButton(int value) {
    return TextButton(
      key: ValueKey<String>('Jump$value'),
      onPressed: () => jumpTo(value),
      style: _scrollButtonStyle(horizonalPadding: 20),
      child: Text('$value'),
    );
  }

  ///
  void scrollTo(int index) {
    itemScrollController.scrollTo(
      index: index,
      duration: scrollDuration,
      curve: Curves.easeInOutCubic,
      alignment: alignment,
    );
  }

  ///
  void scrollBy(double offset) {
    scrollOffsetController.animateScroll(offset: offset, duration: scrollDuration, curve: Curves.easeInOutCubic);
  }

  ///
  void jumpTo(int index) {
    itemScrollController.jumpTo(index: index, alignment: alignment);
  }

  ///
  Widget item(int i, Orientation orientation) {
    return SizedBox(
      height: orientation == Orientation.portrait ? itemHeights[i] : null,
      width: orientation == Orientation.landscape ? itemHeights[i] : null,
      // ignore: use_colored_box
      child: Container(color: itemColors[i], child: Center(child: Text('Item $i'))),
    );
  }
}
