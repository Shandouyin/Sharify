import 'dart:ui';
import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final Color color;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
    const GlassContainer({
    super.key,
    required this.child,
    this.blur = 5,
    this.opacity = 0.25,
    this.color = Colors.black,
    this.borderRadius,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadiusValue = borderRadius ?? BorderRadius.circular(15);
    
    // Simple conteneur avec effet de blur
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: borderRadiusValue,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),          child: Container(
            padding: padding,
            decoration: BoxDecoration(              color: Color.fromRGBO(
                color.r.toInt(),
                color.g.toInt(),
                color.b.toInt(),
                opacity,
              ),
              borderRadius: borderRadiusValue,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
