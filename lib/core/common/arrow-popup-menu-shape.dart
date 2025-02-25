import 'package:flutter/material.dart';

/// شكل مخصص للقائمة المنسدلة يحتوي على نتوء صغير يشير إلى العنصر (الصورة)
class ArrowPopupMenuShape extends ShapeBorder {
  final double arrowWidth;
  final double arrowHeight;
  final double borderRadius;
  const ArrowPopupMenuShape({
    this.arrowWidth = 20,
    this.arrowHeight = 10,
    this.borderRadius = 8,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.only(top: arrowHeight);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final path = Path();
    double arrowX = rect.width / 4 - arrowWidth / 2;
    path.moveTo(rect.left + borderRadius, rect.top + arrowHeight);
    path.lineTo(rect.left + arrowX, rect.top + arrowHeight);
    path.lineTo(rect.left + arrowX + arrowWidth / 4, rect.top);
    path.lineTo(rect.left + arrowX + arrowWidth, rect.top + arrowHeight);
    path.lineTo(rect.right - borderRadius, rect.top + arrowHeight);
    path.arcToPoint(
      Offset(rect.right, rect.top + arrowHeight + borderRadius),
      radius: Radius.circular(borderRadius),
    );
    path.lineTo(rect.right, rect.bottom - borderRadius);
    path.arcToPoint(
      Offset(rect.right - borderRadius, rect.bottom),
      radius: Radius.circular(borderRadius),
    );
    path.lineTo(rect.left + borderRadius, rect.bottom);
    path.arcToPoint(
      Offset(rect.left, rect.bottom - borderRadius),
      radius: Radius.circular(borderRadius),
    );
    path.lineTo(rect.left, rect.top + arrowHeight + borderRadius);
    path.arcToPoint(
      Offset(rect.left + borderRadius, rect.top + arrowHeight),
      radius: Radius.circular(borderRadius),
    );
    path.close();
    return path;
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    // لا حاجة للرسم هنا
  }

  @override
  ShapeBorder scale(double t) {
    return ArrowPopupMenuShape(
      arrowWidth: arrowWidth * t,
      arrowHeight: arrowHeight * t,
      borderRadius: borderRadius * t,
    );
  }
}