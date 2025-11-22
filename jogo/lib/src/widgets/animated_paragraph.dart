// lib/src/widgets/animated_paragraph.dart
import 'package:flutter/material.dart';

class AnimatedParagraph extends StatefulWidget {
  final String text;
  final Duration delay;

  const AnimatedParagraph({super.key, required this.text, this.delay = Duration.zero});

  @override
  State<AnimatedParagraph> createState() => _AnimatedParagraphState();
}

class _AnimatedParagraphState extends State<AnimatedParagraph> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;
  late final Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _opacity = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _offset = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    Future.delayed(widget.delay, () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _offset,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Text(widget.text, style: const TextStyle(fontSize: 16, height: 1.5)),
        ),
      ),
    );
  }
}
