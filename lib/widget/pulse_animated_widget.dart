import 'package:flutter/material.dart';

class PulseAnimatedWidget extends StatefulWidget {
  const PulseAnimatedWidget({super.key, required this.icon});
  final Widget icon;

  @override
  State<PulseAnimatedWidget> createState() => _PulseAnimatedWidgetState();
}

class _PulseAnimatedWidgetState extends State<PulseAnimatedWidget>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    lowerBound: 1,
    upperBound: 2,
    vsync: this,
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        child: widget.icon,
        builder: (context, child) {
          return Transform.scale(
            scale: _controller.value,
            child: child,
          );
        });
  }
}
