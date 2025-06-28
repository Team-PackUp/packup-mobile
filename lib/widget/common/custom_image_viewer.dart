import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class CustomImageViewer extends StatefulWidget {
  final String imageUrl;
  const CustomImageViewer({super.key, required this.imageUrl});

  @override
  State<CustomImageViewer> createState() => _CustomImageViewerState();
}

class _CustomImageViewerState extends State<CustomImageViewer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animCtrl;

  Offset _delta = Offset.zero;
  PhotoViewScaleState _scaleState = PhotoViewScaleState.initial;

  bool get _isZoomed => _scaleState != PhotoViewScaleState.initial;
  double _screenH = 1;
  double get _progress => (_delta.dy.abs() / _screenH).clamp(0.0, 1.0);

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails d) {
    if (_isZoomed) return;
    setState(() => _delta += d.delta);
  }

  void _onPanEnd(DragEndDetails d) {
    if (_isZoomed) return;

    if (_progress > 0.2) {
      Navigator.pop(context);
    } else {
      _animCtrl.forward(from: 0).whenComplete(() {
        setState(() => _delta = Offset.zero);
        _animCtrl.reset();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _screenH = MediaQuery.of(context).size.height;

    final Offset offset = _delta * (1 - _animCtrl.value);
    final double backScale =
        (1 - _progress * 0.2) + _animCtrl.value * _progress * 0.2;
    final double backOpacity =
        (1 - _progress * 0.6) + _animCtrl.value * _progress * 0.6;

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(backOpacity),
      body: GestureDetector(
        onPanUpdate: _isZoomed ? null : _onPanUpdate,
        onPanEnd:    _isZoomed ? null : _onPanEnd,
        behavior: _isZoomed
            ? HitTestBehavior.deferToChild
            : HitTestBehavior.opaque,
        child: Center(
          child: Transform.translate(
            offset: offset,
            child: Transform.scale(
              scale: backScale,
              child: PhotoView(
                imageProvider: NetworkImage(widget.imageUrl),
                enablePanAlways: true,
                backgroundDecoration:
                const BoxDecoration(color: Colors.transparent),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 4,
                scaleStateChangedCallback: (state) {
                  setState(() => _scaleState = state);
                },
              )
            ),
          ),
        ),
      ),
    );
  }
}
