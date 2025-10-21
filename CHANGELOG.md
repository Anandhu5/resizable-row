
## Release Notes - ResizableRow v1.0.0

### 🎉 Initial Release

**ResizableRow** is a powerful Flutter widget that provides resizable row layouts with draggable column separators, allowing users to dynamically resize columns by dragging dividers between them.

### ✨ Features

- **Draggable Column Resizing**: Users can resize columns by dragging the dividers between them
- **Customizable Dividers**: Configure divider appearance, thickness, and hover effects
- **Initial Size Control**: Set initial column sizes using fractions
- **Size Constraints**: Define minimum and maximum column sizes
- **Responsive Design**: Automatically fills the parent widget's width
- **Callbacks**: Get notified when column sizes change
- **Custom Dividers**: Build your own divider widgets
- **Synchronized Resizing**: All items in a list can resize together

### 🚀 Getting Started

Add to your `pubspec.yaml`:
```yaml
dependencies:
  resizable_row: ^1.0.0
```

### 📖 Basic Usage

```dart
import 'package:resizable_row/resizable_row.dart';

ResizableRow(
  children: const [
    Text('Column 1'),
    Text('Column 2'),
    Text('Column 3'),
  ],
  initialFractions: const [0.3, 0.4, 0.3],
  dividerThickness: 8.0,
  onFractionsChanged: (fractions) {
    print('New fractions: $fractions');
  },
)
```

### 🎯 Use Cases

- **Data Tables**: Resizable columns for better data viewing
- **Dashboard Layouts**: Flexible panel arrangements
- **Product Listings**: Customizable product information display
- **Settings Panels**: Adjustable configuration interfaces
- **File Managers**: Resizable file and folder views

### 📱 Example App

The package includes a comprehensive example app demonstrating:
- Basic resizable columns
- List of 10 items with synchronized resizing
- Custom divider styling
- Size constraints and callbacks
- Reset functionality

### 🔧 API Reference

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `children` | `List<Widget>` | **required** | The widgets that make up the columns |
| `initialFractions` | `List<double>?` | `null` | Initial width fractions for each child |
| `dividerThickness` | `double` | `8.0` | Thickness of the draggable divider |
| `dividerColor` | `Color?` | `null` | Color of the divider |
| `dividerHoverColor` | `Color?` | `null` | Color of the divider when hovered |
| `minFractionPerChild` | `double` | `0.05` | Minimum fraction any child can be resized to |
| `maxFractionPerChild` | `double` | `0.95` | Maximum fraction any child can be resized to |
| `onFractionsChanged` | `ValueChanged<List<double>>?` | `null` | Callback when fractions change |
| `cursor` | `MouseCursor` | `SystemMouseCursors.resizeLeftRight` | Mouse cursor when hovering divider |
| `dividerBuilder` | `Widget Function(BuildContext, bool)?` | `null` | Custom divider builder |

### 🛠️ Requirements

- Flutter 3.8.1+
- Dart 3.0+
- No external dependencies

### 📄 License

MIT License - see LICENSE file for details.

### 🔗 Links

- [GitHub Repository](https://github.com/Anandhu5/resizable_row)
- [pub.dev Package](https://pub.dev/packages/resizable_row)
- [Documentation](https://github.com/Anandhu5/resizable_row#readme)

### 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---

**Happy coding! 🎉**