import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:resizable_row/resizable_row.dart';

void main() {
  testWidgets('ResizableRow renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ResizableRow(
            initialFractions: [0.5,0.5],
            children: const [
              Text('Column 1'),
              Text('Column 2'),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Column 1'), findsOneWidget);
    expect(find.text('Column 2'), findsOneWidget);
  });
}
