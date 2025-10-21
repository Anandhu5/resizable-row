library resizable_row;

import 'package:flutter/material.dart';

/// A flexible row widget where users can resize columns by dragging separators.
///
/// - Accepts a list of children widgets as columns.
/// - Fills the parent's width using [LayoutBuilder].
/// - Resizing is done via draggable dividers between columns.
/// - Initial sizes can be provided using [initialFractions]; otherwise columns
///   start with equal widths.
///
/// Example:
///
/// ```dart
/// ResizableRow(
///   children: const [
///     ColoredBox(color: Colors.red),
///     ColoredBox(color: Colors.green),
///     ColoredBox(color: Colors.blue),
///   ],
///   initialFractions: const [0.2, 0.4, 0.4],
/// )
/// ```
class ResizableRow extends StatefulWidget {
  const ResizableRow({
    super.key,
    required this.children,
    required this.initialFractions,
    this.dividerThickness = 8.0,
    this.dividerColor,
    this.dividerHoverColor,
    this.minFractionPerChild = 0.05,
    this.maxFractionPerChild = 0.95,
    this.onFractionsChanged,
    this.cursor = SystemMouseCursors.resizeLeftRight,
    this.dividerBuilder,
  }) : assert(children.length >= 2, 'ResizableRow requires at least 2 children');

  /// Widgets that make up the columns.
  final List<Widget> children;

  /// Initial width fractions for each child. Must sum to ~1.0 if provided.
  /// If null, columns are equally sized.
  final List<double> initialFractions;

  /// Thickness of the draggable divider between columns.
  final double dividerThickness;

  /// Color of the divider in its default state. If null, uses theme dividerColor.
  final Color? dividerColor;

  /// Color of the divider when hovered.
  final Color? dividerHoverColor;

  /// Minimum fraction any single child can be resized to.
  final double minFractionPerChild;

  /// Maximum fraction any single child can be resized to.
  final double maxFractionPerChild;

  /// Callback when the fractions change during a drag.
  final ValueChanged<List<double>>? onFractionsChanged;

  /// Mouse cursor while hovering the divider.
  final MouseCursor cursor;

  /// Optional custom builder for the divider.
  final Widget Function(BuildContext context, bool hovered)? dividerBuilder;

  @override
  State<ResizableRow> createState() => _ResizableRowState();
}

class _ResizableRowState extends State<ResizableRow> {
  late List<double> _fractions; // always sums to ~1.0

  @override
  void initState() {
    super.initState();
    _fractions = _normalizeInitialFractions(
      widget.initialFractions,
      widget.children.length,
    );
  }

  @override
  void didUpdateWidget(covariant ResizableRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.children.length != widget.children.length) {
      _fractions = _normalizeInitialFractions(
        widget.initialFractions,
        widget.children.length,
      );
    } else if (
        !_listEquals(widget.initialFractions, oldWidget.initialFractions)) {
      _fractions = _normalizeInitialFractions(
        widget.initialFractions,
        widget.children.length,
      );
    }
  }

  List<double> _normalizeInitialFractions(List<double>? initial, int count) {
    if (count <= 0) return const <double>[];
    if (initial == null || initial.length != count) {
      return List<double>.filled(count, 1.0 / count);
    }
    final sum = initial.fold<double>(0.0, (a, b) => a + b);
    if (sum <= 0) {
      return List<double>.filled(count, 1.0 / count);
    }
    return initial.map((e) => e / sum).toList(growable: false);
  }

  bool _listEquals(List<double> a, List<double> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if ((a[i] - b[i]).abs() > 1e-9) return false;
    }
    return true;
  }

  void _applyDeltaOnPair(int leftIndex, double deltaPx, double totalWidth) {
    if (leftIndex < 0 || leftIndex >= _fractions.length - 1) return;
    final rightIndex = leftIndex + 1;

    final minF = widget.minFractionPerChild.clamp(0.0, 1.0);
    final maxF = widget.maxFractionPerChild.clamp(0.0, 1.0);

    final deltaFraction = totalWidth == 0 ? 0.0 : deltaPx / totalWidth;

    var newLeft = (_fractions[leftIndex] + deltaFraction).clamp(minF, maxF);
    var newRight = (_fractions[rightIndex] - deltaFraction).clamp(minF, maxF);

    // Ensure sum remains constant by balancing the clamping.
    final originalPairSum = _fractions[leftIndex] + _fractions[rightIndex];
    final adjustedPairSum = newLeft + newRight;
    final correction = originalPairSum - adjustedPairSum;

    // Prefer giving correction to the side that still has room.
    if (correction != 0) {
      final canGrowLeft = newLeft < maxF;
      final canGrowRight = newRight < maxF;
      if (correction > 0) {
        // Need to add to the pair
        if (canGrowLeft) {
          newLeft = (newLeft + correction).clamp(minF, maxF);
        } else if (canGrowRight) {
          newRight = (newRight + correction).clamp(minF, maxF);
        }
      } else {
        // Need to subtract from the pair
        if (newLeft > minF) {
          newLeft = (newLeft + correction).clamp(minF, maxF);
        } else if (newRight > minF) {
          newRight = (newRight + correction).clamp(minF, maxF);
        }
      }
    }

    setState(() {
      _fractions[leftIndex] = newLeft;
      _fractions[rightIndex] = newRight;
    });
    widget.onFractionsChanged?.call(List<double>.unmodifiable(_fractions));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultDividerColor = widget.dividerColor ?? theme.dividerColor;
    final hoverDividerColor = widget.dividerHoverColor ?? theme.colorScheme.primary.withValues(alpha: 0.5);

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final children = <Widget>[];

        for (var i = 0; i < widget.children.length; i++) {
          children.add(
            Flexible(
              flex: (_fractions[i] * 1000000).round(),
              child: SizedBox.expand(child: widget.children[i]),
            ),
          );

          // Add divider between columns (not after the last one)
          if (i < widget.children.length - 1) {
            children.add(_ResizableDivider(
              thickness: widget.dividerThickness,
              cursor: widget.cursor,
              defaultColor: defaultDividerColor,
              hoverColor: hoverDividerColor,
              builder: widget.dividerBuilder,
              onDragDelta: (dx) => _applyDeltaOnPair(i, dx, totalWidth),
            ));
          }
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        );
      },
    );
  }
}

class _ResizableDivider extends StatefulWidget {
  const _ResizableDivider({
    required this.thickness,
    required this.cursor,
    required this.defaultColor,
    required this.hoverColor,
    required this.onDragDelta,
    this.builder,
  });

  final double thickness;
  final MouseCursor cursor;
  final Color defaultColor;
  final Color hoverColor;
  final void Function(double dx) onDragDelta;
  final Widget Function(BuildContext context, bool hovered)? builder;

  @override
  State<_ResizableDivider> createState() => _ResizableDividerState();
}

class _ResizableDividerState extends State<_ResizableDivider> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final divider = widget.builder?.call(context, _hovered) ?? Container(
      width: widget.thickness,
      color: _hovered ? widget.hoverColor : widget.defaultColor,
    );

    return MouseRegion(
      cursor: widget.cursor,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragUpdate: (details) {
          widget.onDragDelta(details.delta.dx);
        },
        child: SizedBox(
          width: widget.thickness,
          child: Center(child: divider),
        ),
      ),
    );
  }
}

