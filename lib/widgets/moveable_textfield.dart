import 'package:flutter/material.dart';

class MovableTextField extends StatefulWidget {
  final Function() onRemove;
  final BuildContext context;

  const MovableTextField({super.key, required this.onRemove, required this.context});

  @override
  State<MovableTextField> createState() => _MovableTextFieldState();
}

class _MovableTextFieldState extends State<MovableTextField> {
  double x = 0;
  double y = 0;
  
  TextEditingController controller = TextEditingController();
  FocusNode focus = FocusNode();

  @override
  void initState() {
    super.initState();

    x = MediaQuery.of(widget.context).size.width / 2;
    y = MediaQuery.of(widget.context).size.height / 3;
    focus.requestFocus();
    focus.addListener(() {
      if (!focus.hasFocus && controller.text.trim().isEmpty) {
        widget.onRemove();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x,
      top: y,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            x += details.delta.dx;
            y += details.delta.dy;
          });
        },
        child: IntrinsicWidth(
          child: Container(
            padding: EdgeInsets.all(4),
            color: Colors.transparent,
            child: TextField(
              controller: controller,
              focusNode: focus,
              cursorColor: Theme.of(context).primaryColor,
              decoration: InputDecoration(border: InputBorder.none),
              maxLines: null,
              onChanged: (value) {
                if (value.trim().isEmpty && !focus.hasFocus) {
                  widget.onRemove();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}