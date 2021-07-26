import 'package:flutter/material.dart';
import 'dart:math' as math;

class SpeedDialFabWidget extends StatefulWidget {
  /// [secondaryBackgroundColor] Changes the background color of the secondary FAB button.
  /// The default value is [Colors.white]
  final Color secondaryBackgroundColor;

  /// [secondaryForegroundColor] Changes the foreground color of the secondary FAB button.
  /// The default value is [Colors.black]
  final Color secondaryForegroundColor;

  /// [primaryBackgroundColor] Changes the background color of the primary FAB button.
  /// The default value is [Colors.white]
  final Color primaryBackgroundColor;

  /// [primaryForegroundColor] Changes the foreground color of the primary FAB button.
  /// The default value is [Colors.black]
  final Color primaryForegroundColor;

  /// [primaryIconCollapse] Changes primary icon when it is collapsed
  /// The default value is [Icons.expand_less]
  final IconData primaryIconCollapse;

  /// [primaryIconExpand] Change primary icon when it is expanded
  /// The default value is [Icons.expand_less]
  final IconData primaryIconExpand;

  /// [rotateAngle] Change the rotation angle to animate primary FAB when clicked
  /// The default value is [math.pi]
  final double rotateAngle;

  /// Required: [secondaryIconsList] Change the list of icons of secondary FAB, , should be the same size of @secondaryIconsText and @secondaryIconsOnPress
  /// Should have the same size of [secondaryIconsOnPress] and [secondaryIconsList]
  final List<IconData> secondaryIconsList;

  /// [secondaryIconsText] Change the list of text of secondary FAB, should be the same size of @secondaryIconsList and @secondaryIconsOnPress
  /// This will be the tooltip of the secondary FAB, by default there is no tooltip.
  /// if not null, should have the same size of [secondaryIconsOnPress] and [secondaryIconsList]
  final List<String> secondaryIconsText;

  /// Required: [secondaryIconsOnPress] Change the list of onPress action, should be the same size of @secondaryIconsList and @secondaryIconsText
  /// Should have the same size of [secondaryIconsText] and [secondaryIconsList]
  final List<Function> secondaryIconsOnPress;

  SpeedDialFabWidget({
    this.secondaryBackgroundColor,
    this.secondaryForegroundColor,
    this.primaryBackgroundColor,
    this.primaryForegroundColor,
    this.primaryIconExpand,
    this.rotateAngle,
    this.primaryIconCollapse,
    @required this.secondaryIconsList,
    @required this.secondaryIconsOnPress,
    this.secondaryIconsText,
  });

  @override
  State createState() => SpeedDialFabWidgetState();
}

class SpeedDialFabWidgetState extends State<SpeedDialFabWidget> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    if (widget.secondaryIconsList.length != widget.secondaryIconsOnPress.length) {
      throw ("secondaryIconsList should have the same length of secondaryIconsOnPress");
    }
    if (widget.secondaryIconsText != null) {
      if (widget.secondaryIconsText?.length != widget.secondaryIconsOnPress.length) {
        throw ("secondaryIconsText should have the same length of secondaryIconsOnPress");
      }
    }

    super.initState();
  }

  void toggleFAB() {
    if (_controller.isDismissed)
      _controller.forward();
    else
      _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.secondaryIconsList.length, (int index) {
        Widget secondaryFAB = Container(
          height: 56.0,
          width: 56.0,
          alignment: FractionalOffset.topCenter,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: _controller,
              curve: Interval(
                0.0,
                1.0 - index / widget.secondaryIconsList.length / 2.0,
                curve: Curves.easeOut,
              ),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                FloatingActionButton(
                    elevation: 0,
                    // tooltip: widget.secondaryIconsText[index],
                    heroTag: null,
                    mini: true,
                    backgroundColor: widget.secondaryBackgroundColor ?? Colors.white,
                    child: Icon(
                      widget.secondaryIconsList[index],
                      color: widget.secondaryForegroundColor ?? Colors.black,
                    ),
                    onPressed: () {
                      toggleFAB();

                      widget.secondaryIconsOnPress[index]();
                    }),
                Positioned(
                  right: 65,
                  top: 7,
                  child: Material(
                    clipBehavior: Clip.antiAlias,
                    borderRadius: BorderRadius.circular(4),
                    elevation: 8,
                    shadowColor: widget.secondaryForegroundColor ?? Colors.black,
                    color: Colors.grey[800].withOpacity(0.8),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 20.0),
                      child: Text(
                        (widget.secondaryIconsText != null) ? widget.secondaryIconsText[index] : "",
                        style: TextStyle(
                          color: widget.secondaryForegroundColor ?? Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );

        return secondaryFAB;
      }).toList()
        ..add(
          FloatingActionButton(
              elevation: 5,
              clipBehavior: Clip.antiAlias,
              backgroundColor: widget.primaryBackgroundColor ?? Colors.white,
              heroTag: null,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (BuildContext context, Widget child) {
                  return Transform(
                    transform: Matrix4.rotationZ(
                      _controller.value * (widget.rotateAngle ?? math.pi),
                    ),
                    alignment: FractionalOffset.center,
                    child: Icon(
                      _controller.isDismissed
                          ? widget.primaryIconExpand ?? Icons.expand_less
                          : widget.primaryIconCollapse ?? Icons.expand_less,
                      color: widget.primaryForegroundColor ?? Colors.black,
                    ),
                  );
                },
              ),
              onPressed: toggleFAB),
        ),
    );
  }
}
