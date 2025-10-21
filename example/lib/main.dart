import 'package:flutter/material.dart';
import 'package:resizable_row/resizable_row.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ResizableRow Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
      routes: {
        '/list': (context) => const ListScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<double> _fractions = const [0.3, 0.4, 0.3,0.3];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('ResizableRow Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Drag the dividers to resize columns:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ResizableRow(
                  children: const [
                    _DemoColumn(
                      color: Colors.red,
                      title: 'Column 1',
                      content: 'This is the first column. You can resize it by dragging the divider.',
                    ),
                    _DemoColumn(
                      color: Colors.green,
                      title: 'Column 2',
                      content: 'This is the second column. It can also be resized.',
                    ),
                    _DemoColumn(
                      color: Colors.blue,
                      title: 'Column 3',
                      content: 'This is the third column. Try resizing all columns!',
                    ),
                     _DemoColumn(
                      color: Colors.amber,
                      title: 'Column 3',
                      content: 'This is the third column. Try resizing all columns!',
                    ),
                  ],
                  initialFractions: _fractions,
                  dividerThickness: 5.0,
                  dividerColor: Colors.grey.shade300,
                  dividerHoverColor: Colors.blue.shade300,
                  minFractionPerChild: 0.1,
                  maxFractionPerChild: 0.8,
                  onFractionsChanged: (fractions) {
                    setState(() {
                      _fractions = fractions;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Current fractions: ${_fractions.map((f) => f.toStringAsFixed(2)).join(', ')}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _fractions = const [0.33, 0.33, 0.34];
                    });
                  },
                  child: const Text('Reset to Equal Sizes'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/list');
                  },
                  child: const Text('View List of 10 Items'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DemoColumn extends StatelessWidget {
  const _DemoColumn({
    required this.color,
    required this.title,
    required this.content,
  });

  final Color color;
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color.withOpacity(0.1),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Text(
              content,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<double> _fractions = const [0.5, 0.3, 0.2];
  
  final List<Map<String, dynamic>> _items = List.generate(10, (index) => {
    'id': index + 1,
    'name': 'Item ${index + 1}',
    'description': 'This is item number ${index + 1} in the list',
    'color': _getColorForIndex(index),
    'price': '\$${(index + 1) * 10}.00',
    'category': _getCategoryForIndex(index),
  });

  static Color _getColorForIndex(int index) {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.amber,
      Colors.cyan,
    ];
    return colors[index % colors.length];
  }

  static String _getCategoryForIndex(int index) {
    final categories = [
      'Electronics',
      'Clothing',
      'Books',
      'Home & Garden',
      'Sports',
      'Toys',
      'Beauty',
      'Automotive',
      'Health',
      'Food',
    ];
    return categories[index % categories.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('List of 10 Items with ResizableRow'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _fractions = const [0.5, 0.3, 0.2];
              });
            },
            tooltip: 'Reset to Default Sizes',
          ),
        ],
      ),
      body: Column(
        children: [
          // Header showing current fractions
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade100,
            child: Column(
              children: [
                const Text(
                  'Drag any divider to resize all items:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Current fractions: ${_fractions.map((f) => f.toStringAsFixed(2)).join(', ')}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          // List of items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  child: Container(
                    height: 120,
                    child: ResizableRow(
                      children: [
                  // Left column - Item info
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: item['color'],
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              item['name'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['description'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['category'],
                          style: TextStyle(
                            fontSize: 12,
                            color: item['color'],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Middle column - Price and actions
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item['price'],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Added ${item['name']} to cart')),
                            );
                          },
                          icon: const Icon(Icons.shopping_cart, size: 16),
                          label: const Text('Add to Cart'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: item['color'],
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Right column - Additional info
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: List.generate(5, (starIndex) => Icon(
                            starIndex < 4 ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 16,
                          )),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'In Stock',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'ID: ${item['id']}',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                initialFractions: _fractions,
                dividerThickness: 5.0,
                dividerColor: Colors.grey.shade300,
                dividerHoverColor: Colors.blue.shade300,
                minFractionPerChild: 0.15,
                maxFractionPerChild: 0.7,
                dividerBuilder: (context, hovered) {
                  return Container(
                    width: 5,
                    color: hovered?Colors.amber:Colors.green,
                  );
                },
                onFractionsChanged: (fractions) {
                  setState(() {
                    _fractions = fractions;
                  });
                },
              ),
            ),
          );
        },
      ),
    ),
  ],
),
    );
  }
}
