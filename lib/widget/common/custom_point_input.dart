import 'package:flutter/material.dart';

enum PointMode { view, edit }

class CustomPointInput extends StatefulWidget {
  final int starCount;
  final int? initialPoint;
  final ValueChanged<int?>? onPointChanged;
  final Color filledColor;
  final Color unfilledColor;
  final double size;
  final PointMode mode;

  const CustomPointInput({
    super.key,
    this.starCount = 5,
    this.initialPoint,
    this.onPointChanged,
    this.mode = PointMode.edit,
    this.filledColor = Colors.amber,
    this.unfilledColor = Colors.grey,
    this.size = 28,
  });

  @override
  State<CustomPointInput> createState() => _CustomPointInputState();
}

class _CustomPointInputState extends State<CustomPointInput> {
  int? _currentPoint;

  bool get _readOnly => widget.mode == PointMode.view;

  @override
  void initState() {
    super.initState();
    _currentPoint = widget.initialPoint;
  }

  @override
  void didUpdateWidget(covariant CustomPointInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialPoint != widget.initialPoint) {
      setState(() {
        _currentPoint = widget.initialPoint?.clamp(0, widget.starCount);
      });
    }
  }

  void _handleTap(int index) {
    if (_readOnly) return;
    setState(() => _currentPoint = index);
    widget.onPointChanged?.call(_currentPoint);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.starCount, (i) {
        final starIndex = i + 1;
        final isFilled = (_currentPoint ?? 0) >= starIndex;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _handleTap(starIndex),
          child: Icon(
            isFilled ? Icons.star : Icons.star_border,
            color: isFilled ? widget.filledColor : widget.unfilledColor,
            size: widget.size,
          ),
        );
      }),
    );
  }
}
