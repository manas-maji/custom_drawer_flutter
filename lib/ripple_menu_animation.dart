import 'package:custom_drawer/drawer_menu.dart';
import 'package:flutter/material.dart';

class RippleMenuAnimation extends StatefulWidget {
  /// The colors of ripple circle.
  final Color color;

  final double maxRadius;

  /// Duration for forward animation.
  final Duration forwardDuration;

  /// Duration for reverse animation.
  ///
  /// The value of [forwardDuration] is used if [reverseDuration] == [null]
  final Duration reverseDuration;

  final double topPadding;
  final Size screenSize;

  RippleMenuAnimation(
      {Key key,
      this.color,
      this.maxRadius,
      this.forwardDuration,
      this.reverseDuration,
      @required this.topPadding,
      @required this.screenSize})
      : assert(forwardDuration != null),
        super(key: key);

  @override
  RippleMenuAnimationState createState() => RippleMenuAnimationState();
}

class RippleMenuAnimationState extends State<RippleMenuAnimation>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  Color color;
  double maxRadius;

  @override
  void initState() {
    super.initState();
    color = widget.color;
    maxRadius = widget.maxRadius ?? 0;
    controller = AnimationController(
        vsync: this,
        duration: widget.forwardDuration,
        reverseDuration: widget.reverseDuration);
    animation = CurvedAnimation(
        parent: Tween<double>(begin: 0, end: 1).animate(controller),
        curve: Curves.easeInOut);
  }

  @override
  void didUpdateWidget(RippleMenuAnimation oldWidget) {
    color = widget.color;
    maxRadius = widget.maxRadius ?? 0;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.screenSize.height,
      width: widget.screenSize.width,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return ClipOval(
            clipper: RippleClipper(maxRadius * animation.value),
            clipBehavior: Clip.antiAlias,
            child: CustomPaint(
              willChange: true,
              isComplex: true,
              foregroundPainter: CirclePainter(
                  maxRadius: maxRadius, scale: animation.value, color: color),
              child: DrawerMenu(
                screenSize: widget.screenSize,
                topPadding: widget.topPadding,
              ),
            ),
          );
        },
      ),
    );
  }
}

class RippleClipper extends CustomClipper<Rect> {
  final double radius;

  RippleClipper(this.radius);

  // Clip the animation and retain only 4th quadrant of the animation.
  @override
  Rect getClip(Size size) {
    Rect rect = Rect.fromCircle(center: Offset(0, 0), radius: radius);
    return rect;
  }

  //As clip path is set only once for entire animation, so does not need to reclip
  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return true;
  }
}

class CirclePainter extends CustomPainter {
  final double maxRadius;
  final double scale;
  final Color color;

  CirclePainter({this.maxRadius, this.scale, this.color});

  @override
  void paint(Canvas canvas, Size size) {
    double openingCircleStrokeWidth = maxRadius * scale;
    double closingCircleStrokeWidth = maxRadius * (1 - scale);

    Paint drawOpeningCircle = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = openingCircleStrokeWidth;

    Paint drawClosingCircle = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = closingCircleStrokeWidth;

    Offset center = Offset(0, 0);

    if (scale < 0.5) {
      canvas.drawCircle(
        center,
        (openingCircleStrokeWidth / 2), //Max Radius of circle to be drawn
        drawOpeningCircle,
      );
    } else {
      canvas.drawCircle(
        center,
        (maxRadius - closingCircleStrokeWidth) / 2, //Max Radius of circle to be drawn
        drawClosingCircle,
      );
    }
  }

  @override
  bool hitTest(Offset position) {
    return false;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    if (scale > 0.0 || scale < 1.0) {
      return true;
    }
    return false;
  }
}
