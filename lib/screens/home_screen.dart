import 'package:flutter/material.dart';
import 'package:test_scroll_package/pages/indexed_list_view_page.dart';
import 'package:test_scroll_package/pages/scroll_to_index_page.dart';
import 'package:test_scroll_package/pages/scrollable_positioned_list_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ScrollToIndexPage(title: 'scroll_to_index'),
                  ),
                );
              },
              child: const Text('scroll_to_index'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const IndexedListViewPage(),
                  ),
                );
              },
              child: const Text('indexed_list_view'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ScrollablePositionedListPage(),
                  ),
                );
              },
              child: const Text('scrollable_positioned_list'),
            ),
          ],
        ),
      ),
    );
  }
}
