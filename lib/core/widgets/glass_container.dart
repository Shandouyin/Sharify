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
  final bool isScrollable;
  
  const GlassContainer({
    Key? key,
    required this.child,
    this.blur = 5,
    this.opacity = 0.25,
    this.color = Colors.black,
    this.borderRadius,
    this.padding,
    this.margin,
    this.isScrollable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderRadiusValue = borderRadius ?? BorderRadius.circular(15);
    
    // For scrollable content, we need a different approach to prevent the blur from disappearing
    if (isScrollable) {
      return Container(
        margin: margin,
        child: ClipRRect(
          borderRadius: borderRadiusValue,
          child: Stack(
            children: [
              // Apply blur to the entire container
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                  child: Container(
                    color: color.withOpacity(opacity),
                  ),
                ),
              ),
              // Actual content
              Container(
                padding: padding,
                decoration: BoxDecoration(
                  // Color is already applied in the backdrop filter
                  borderRadius: borderRadiusValue,
                ),
                child: child,
              ),
            ],
          ),
        ),
      );
    }
    
    // For non-scrollable content, the original implementation works fine
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: borderRadiusValue,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: color.withOpacity(opacity),
              borderRadius: borderRadiusValue,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
