import 'package:flutter/material.dart';


// Widget مخصص لإضافة تأثير توهج عند hover
class HoverIconButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final String tooltip;

  const HoverIconButton({
    Key? key,
    required this.child,
    required this.onPressed,
    required this.tooltip,
  }) : super(key: key);

  @override
  _HoverIconButtonState createState() => _HoverIconButtonState();
}

class _HoverIconButtonState extends State<HoverIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Tooltip(
        message: widget.tooltip,
        child: GestureDetector(
          onTap: widget.onPressed,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            padding: EdgeInsets.all(4), // مساحة صغيرة للسماح بإظهار التوهج
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color:Colors.cyan.withOpacity(0.7),
                        spreadRadius: 2,
                        blurRadius: 10,
                      ),
                    ]
                  : [],
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
