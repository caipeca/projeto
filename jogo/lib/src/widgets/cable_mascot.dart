import 'dart:math';

import 'package:flutter/material.dart';

class CableMascot extends StatefulWidget {
  final double size;
  const CableMascot({super.key, this.size = 120});
  @override
  State<CableMascot> createState() => _CableMascotState();
}

class _CableMascotState extends State<CableMascot> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _sway;
  late final Animation<double> _blink;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
    _sway = Tween<double>(begin: -0.06, end: 0.06).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    _blink = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 85),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.08).chain(CurveTween(curve: Curves.easeIn)), weight: 7),
      TweenSequenceItem(tween: Tween<double>(begin: 0.08, end: 1.0).chain(CurveTween(curve: Curves.easeOut)), weight: 8),
    ]).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.size;
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        final angle = _sway.value * sin(_ctrl.value * 2 * pi);
        return Transform.rotate(
          angle: angle,
          child: SizedBox(
            width: s,
            height: s,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // cabo — usando Container com curva (simples)
                Positioned(
                  bottom: s * 0.05,
                  child: CustomPaint(
                    size: Size(s * 0.8, s * 0.6),
                    painter: _CablePainter(),
                  ),
                ),
                // conector (a "cabeça" com olhos)
                Positioned(
                  top: 4,
                  child: Column(
                    children: [
                      Container(
                        width: s * 0.56,
                        height: s * 0.4,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade800,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6, offset: const Offset(0,3))],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // olho esquerdo
                                Transform.translate(
                                  offset: Offset(0, 2 * sin(_ctrl.value * 2 * pi)),
                                  child: Opacity(
                                    opacity: _blink.value,
                                    child: Container(
                                      width: s * 0.14,
                                      height: s * 0.14,
                                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                                      child: Center(
                                        child: Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 16),

                                // olho direito
                                Transform.translate(
                                  offset: Offset(0, 2 * cos(_ctrl.value * 2 * pi)),
                                  child: Opacity(
                                    opacity: _blink.value,
                                    child: Container(
                                      width: s * 0.14,
                                      height: s * 0.14,
                                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                                      child: Center(
                                        child: Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                          ,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text('Cabo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CablePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.teal.shade400
      ..strokeWidth = size.height * 0.18
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height * 0.3);
    path.quadraticBezierTo(size.width * 0.25, size.height * -0.05, size.width * 0.5, size.height * 0.3);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.7, size.width, size.height * 0.4);

    canvas.drawPath(path, paint);

    // detalhes: linhas internas
    final inner = Paint()..color = Colors.teal.shade700..strokeWidth = size.height * 0.06..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    final path2 = Path();
    path2.moveTo(0, size.height * 0.3);
    path2.quadraticBezierTo(size.width * 0.25, size.height * 0.05, size.width * 0.5, size.height * 0.3);
    path2.quadraticBezierTo(size.width * 0.75, size.height * 0.55, size.width, size.height * 0.35);
    canvas.drawPath(path2, inner);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}