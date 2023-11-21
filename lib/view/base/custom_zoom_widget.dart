library image_zoom_on_move;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';

class CustomZoomWidget extends StatefulWidget {
  final Widget child;
  final double? width;
  final double? height;
  final MouseCursor? cursor;
  final void Function()? onTap;

  const CustomZoomWidget({
    this.height,
    this.width,
    this.cursor = SystemMouseCursors.grab,
    this.onTap,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomZoomWidget> createState() => _CustomZoomWidgetState();
}

class _CustomZoomWidgetState extends State<CustomZoomWidget> {
  final _transController = TransformationController();

  void _onMove(PointerHoverEvent details) {
    final x = details.localPosition.dx;
    final y = details.localPosition.dy;

    _transController.value = Matrix4.identity()
      ..translate(-x, -y)
      ..scale(2.0);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveHelper.isDesktop(context) ? GestureDetector(
      // onTap: _onZoom,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: MouseRegion(
          cursor: widget.cursor!,
          onExit: (details) {
            _transController.value = Matrix4.identity();
          },
          onHover: _onMove,
          child: InteractiveViewer(
            transformationController: _transController,
            child: widget.child,
          ),
        ),
      ),
    ) : widget.child;
  }
}
