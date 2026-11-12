import 'package:flutter/material.dart';

/// A reusable entrance animation: content fades in while sliding up
/// slightly. Used consistently across the whole app (Login through
/// Settings/Sign Out) so every screen feels like it "arrives" the same
/// way, rather than each screen having its own one-off animation style.
///
/// Pass an [index] when animating items in a list (cards, list tiles)
/// to get a staggered cascade effect — each item starts slightly after
/// the one before it.
class FadeSlideIn extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration baseDelay;
  final Duration staggerStep;
  final Duration duration;

  const FadeSlideIn({
    super.key,
    required this.child,
    this.index = 0,
    this.baseDelay = Duration.zero,
    this.staggerStep = const Duration(milliseconds: 45),
    this.duration = const Duration(milliseconds: 380),
  });

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    final delay = widget.baseDelay + (widget.staggerStep * widget.index);
    Future.delayed(delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}

/// A gentle scale + fade "pop in" for standalone elements that deserve
/// more emphasis than a list item — e.g. a risk result card, a hero
/// weather card just after it loads.
class PopIn extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const PopIn({super.key, required this.child, this.duration = const Duration(milliseconds: 420)});

  @override
  State<PopIn> createState() => _PopInState();
}

class _PopInState extends State<PopIn> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _scale = Tween<double>(begin: 0.92, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(scale: _scale, child: widget.child),
    );
  }
}