import 'package:crypto_tracker/constants/style.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final double width;
  final Function onChanged;
  final Function onCleared;
  final bool isToggable;

  const SearchBar({@required this.width, this.onChanged, this.onCleared, this.isToggable = true});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _controller;
  final _focusNode = FocusNode();
  final _textController = TextEditingController();
  bool isForward = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: Duration(milliseconds: 400), vsync: this);

    final curvedAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _animation = Tween<double>(begin: 0, end: widget.width).animate(curvedAnimation)
      ..addListener(() {
        setState(() {});
      });

    if (!widget.isToggable) {
      _controller.forward();
    }
  }

  void onPressed() {
    if (!isForward) {
      isForward = true;
      _focusNode.requestFocus();
      if (widget.isToggable) _controller.forward();
    } else {
      isForward = false;
      _focusNode.unfocus();
      _textController.clear();
      widget.onCleared();

      if (widget.isToggable) _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    double _size = 45;

    return Container(
      height: _size,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: _animation.value,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(_size), bottomLeft: Radius.circular(_size)),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 20, bottom: 4),
              child: TextField(
                focusNode: _focusNode,
                controller: _textController,
                onChanged: widget.onChanged,
                cursorColor: kPrimaryColor,
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Container(
            width: _size,
            height: _size,
            decoration: BoxDecoration(
              color: Colors.white,
              border: _animation.value > 0.1 ? null : Border.all(color: kLightGrayColor),
              borderRadius: _animation.value > 0.1
                  ? BorderRadius.only(
                      topLeft: Radius.circular(0),
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(_size),
                      topRight: Radius.circular(_size),
                    )
                  : BorderRadius.circular(_size),
            ),
            child: IconButton(
              splashRadius: 0.1,
              icon: Icon(_animation.value > 100 ? Icons.close : Icons.search, color: kPrimaryColor),
              onPressed: onPressed,
            ),
          )
        ],
      ),
    );
  }
}
