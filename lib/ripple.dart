import 'package:flutter/material.dart';

class Ripple extends StatefulWidget {
  final int rippleCount;
  final Color rippleColor;
  final double radius;
  final Widget child;
  final double backgroundCircleRadius;

  Ripple(
      {@required this.rippleCount,
      @required this.rippleColor,
      @required this.radius,
      this.child,
      this.backgroundCircleRadius})
      : assert(rippleCount != null && rippleColor != null && radius != null);

  @override
  _RippleState createState() => _RippleState();
}

class _RippleState extends State<Ripple> with TickerProviderStateMixin {
  List<AnimationController> _animationControllers;
  List<Widget> rippleStack;

  @override
  void initState() {
    rippleStack = [];
    initializeAnimationControllers();
    initializeRippleStack();
    super.initState();
  }

  void initializeAnimationControllers() {
    double lowerBound =
        0.5; // AnimationController resets if initial value in [value] is set to something lower than lowerBound
    _animationControllers = [];
    for (int i = 0; i < widget.rippleCount; ++i) {
      _animationControllers.add(AnimationController(
        vsync: this,
        duration: Duration(milliseconds: (widget.rippleCount) * 1000),
        lowerBound: lowerBound,
        value: lowerBound +
            (1 - lowerBound) *
                (i / widget.rippleCount), //initial Value is added with lowerBound
      )..repeat());
    }
  }

  void initializeRippleStack() {
    double radius = widget.radius;
    Color rippleColor = widget.rippleColor;
    Widget child = widget.child;
    double backgroundCircleRadius = widget.backgroundCircleRadius;
    _animationControllers.forEach((c) {
      rippleStack.add(AnimatedBuilder(
          animation: CurvedAnimation(curve: Curves.fastOutSlowIn, parent: c),
          builder: (context, widget) {
            return CustomPaint(
              painter: MyPainter(
                width: radius,
                animationWidth: (radius * c.value),
                lineColor: rippleColor.withOpacity(1 - c.value),
                backgroundCircleRadius: backgroundCircleRadius ?? 24,
              ),
              willChange: true,
              child: child,
            );
          }));
    });
  }

  @override
  void dispose() {
    disposeAnimationControllers();
    super.dispose();
  }

  void disposeAnimationControllers() {
    _animationControllers.forEach((c) => c?.dispose());
  }

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ClipCircleOverflow(
        bottom: widget.radius,
        right: widget.radius,
      ),
      child: Container(
        child: Stack(
          alignment: Alignment.center,
          children: rippleStack,
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  double width;
  double animationWidth;
  Color lineColor;
  double backgroundCircleRadius;

  MyPainter(
      {this.width, this.animationWidth, this.lineColor, this.backgroundCircleRadius});

  @override
  void paint(Canvas canvas, Size size) {
    Paint line = new Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill
      ..strokeWidth = animationWidth;

    Paint circle = new Paint()
      ..color = Colors.yellow // color of circle
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill
      ..strokeWidth = (width);

    Offset center = new Offset(0, 0);
    double radius = animationWidth;

    canvas.drawCircle(center, radius, line); //Animating Ripple

    canvas.drawCircle(center, this.backgroundCircleRadius ?? 24, circle);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class ClipCircleOverflow extends CustomClipper<Path> {
  final double left, top, right, bottom;

  ClipCircleOverflow({
    this.left = 0.0,
    this.top = 0.0,
    this.right,
    this.bottom,
  });

  @override
  Path getClip(Size size) {
    Path path = Path()
      ..moveTo(0, 0)
      ..addRect(Rect.fromLTRB(left, top, right, bottom));
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
