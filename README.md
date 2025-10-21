# ResizableRow

A Flutter widget that provides a resizable row layout with draggable column separators. Users can dynamically resize columns by dragging the dividers between them.

## Features

- **Draggable Column Resizing**: Users can resize columns by dragging the dividers between them
- **Customizable Dividers**: Configure divider appearance, thickness, and hover effects
- **Initial Size Control**: Set initial column sizes using fractions
- **Size Constraints**: Define minimum and maximum column sizes
- **Responsive Design**: Automatically fills the parent widget's width
- **Callbacks**: Get notified when column sizes change
- **Custom Dividers**: Build your own divider widgets

## Getting started

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  resizable_row: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Usage

### Basic Example

```dart
import 'package:flutter/material.dart';
import 'package:resizable_row/resizable_row.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResizableRow(
      children: const [
        ColoredBox(color: Colors.red),
        ColoredBox(color: Colors.green),
        ColoredBox(color: Colors.blue),
      ],
    );
  }
}
```

### Advanced Example

```dart
ResizableRow(
  children: const [
    Text('Column 1'),
    Text('Column 2'),
    Text('Column 3'),
  ],
  initialFractions: const [0.2, 0.4, 0.4],
  dividerThickness: 8.0,
  dividerColor: Colors.grey,
  dividerHoverColor: Colors.blue,
  minFractionPerChild: 0.1,
  maxFractionPerChild: 0.8,
  onFractionsChanged: (fractions) {
    print('New fractions: $fractions');
  },
)
```

### Custom Divider

```dart
ResizableRow(
  children: const [
    Text('Column 1'),
    Text('Column 2'),
  ],
  dividerBuilder: (context, hovered) {
    return Container(
      width: 12,
      decoration: BoxDecoration(
        color: hovered ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  },
)
```

## API Reference

### ResizableRow

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `children` | `List<Widget>` | **required** | The widgets that make up the columns |
| `initialFractions` | `List<double>?` | `null` | Initial width fractions for each child (must sum to ~1.0) |
| `dividerThickness` | `double` | `8.0` | Thickness of the draggable divider |
| `dividerColor` | `Color?` | `null` | Color of the divider (uses theme default if null) |
| `dividerHoverColor` | `Color?` | `null` | Color of the divider when hovered |
| `minFractionPerChild` | `double` | `0.05` | Minimum fraction any child can be resized to |
| `maxFractionPerChild` | `double` | `0.95` | Maximum fraction any child can be resized to |
| `onFractionsChanged` | `ValueChanged<List<double>>?` | `null` | Callback when fractions change during drag |
| `cursor` | `MouseCursor` | `SystemMouseCursors.resizeLeftRight` | Mouse cursor when hovering divider |
| `dividerBuilder` | `Widget Function(BuildContext, bool)?` | `null` | Custom divider builder |

## Example App

Run the example app to see ResizableRow in action:

```bash
cd example
flutter run
```

The example demonstrates:
- Basic resizable columns
- Custom divider styling
- Size constraints
- Fraction change callbacks
- Reset functionality

## Additional information

- **Minimum Requirements**: Flutter 3.8.1+
- **Dependencies**: None (pure Flutter widget)
- **License**: MIT

For more examples and advanced usage, see the `/example` folder in this repository.
