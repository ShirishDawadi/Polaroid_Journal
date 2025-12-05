import 'package:flutter/material.dart';

class MovableTextField extends StatefulWidget {
  final Function(Key) onRemove;
  final BuildContext context;
  final Color textColor;

  const MovableTextField({super.key, required this.onRemove, required this.context, required this.textColor});

  @override
  State<MovableTextField> createState() => MovableTextFieldState();
}

class MovableTextFieldState extends State<MovableTextField> {
  double x = 0;
  double y = 0;
  Color? textColor;
  TextEditingController controller = TextEditingController();
  FocusNode focus = FocusNode();

  @override
  void initState() {
    super.initState();

    textColor=widget.textColor;

    x = MediaQuery.of(widget.context).size.width / 2;
    y = MediaQuery.of(widget.context).size.height / 3;
    focus.requestFocus();
    focus.addListener(() {
      if (!focus.hasFocus && controller.text.trim().isEmpty) {
        widget.onRemove(widget.key!);
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
              style: TextStyle(color:textColor),
              cursorColor: Theme.of(context).primaryColor,
              decoration: InputDecoration(border: InputBorder.none),
              maxLines: null,
              onChanged: (value) {
                if (value.trim().isEmpty && !focus.hasFocus) {
                  widget.onRemove(widget.key!);
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}