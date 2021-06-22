import 'package:flutter/material.dart';

/// This is the stateful widget that the main application instantiates.
class Spinner extends StatefulWidget {
  final Color color;
  final double circleStrokeWidth;
  final double circlePadding;
  final double sizeWidth;
  final double sizeHeight;
  const Spinner({
    Key key,
    this.color,
    @required this.circleStrokeWidth,
    this.circlePadding,
    @required this.sizeHeight,
    @required this.sizeWidth,
  }) : super(key: key);

  @override
  _SpinnerState createState() => _SpinnerState();
}

/// This is the private State class that goes with MyStatefulWidget.
/// AnimationControllers can be created with `vsync: this` because of TickerProviderStateMixin.
class _SpinnerState extends State<Spinner> with TickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: widget.sizeHeight,
        width: widget.sizeWidth,
        child: CircularProgressIndicator(
          strokeWidth: widget.circleStrokeWidth,
          valueColor: AlwaysStoppedAnimation<Color>(widget.color),
          value: controller.value,
          semanticsLabel: 'Linear progress indicator',
        ),
      ),
    );
  }
}
