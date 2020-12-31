import 'package:flutter/material.dart';

Color mC = Colors.grey.shade100;
Color mCL = Colors.white;
Color mCD = Colors.black.withOpacity(0.075);
Color mCC = Colors.green.withOpacity(0.65);
Color fCD = Colors.grey.shade700;
Color fCL = Colors.grey;

extension ColorUtils on Color {
  Color mix(Color another, double amount) {
    return Color.lerp(this, another, amount);
  }
}

BoxDecoration nMbox = BoxDecoration(
    borderRadius: BorderRadius.circular(15),
    color: mC,
    boxShadow: [
      BoxShadow(
        color: mCD,
        offset: Offset(10, 10),
        blurRadius: 10,
      ),
      BoxShadow(
        color: mCL,
        offset: Offset(-10, -10),
        blurRadius: 10,
      ),
    ]);
BoxDecoration createInvertBox({double radius = 15, bool isCircular = false}) {
  return BoxDecoration(
      shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
      borderRadius: isCircular ? null : BorderRadius.circular(radius),
      color: mCD,
      boxShadow: [
        BoxShadow(
            color: mCL, offset: Offset(3, 3), blurRadius: 3, spreadRadius: -3),
      ]);
}

BoxDecoration nMboxInvertActive = createInvertBox().copyWith(color: mCC);

BoxDecoration createNeuroButton(bool _isPressed) {
  return BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.grey.shade300,
          Colors.white
          /*  Colors.grey.shade200.mix(Colors.black, 0.1),
            Colors.grey.shade200.mix(Colors.black, .05),
            Colors.grey.shade200.mix(Colors.black, .05),
            Colors.grey.shade200.mix(Colors.white, .5),*/
        ],
        /* stops: [
            0.0,
            0.3,
            0.6,
            1.0
          ]*/
      ),
      color: mC,
      boxShadow: _isPressed
          ? [
              BoxShadow(
                blurRadius: 1,
                offset: Offset(-2, -2),
                color: mCC.mix(Colors.white, 0.5),
              ),
              BoxShadow(
                color: mCD,
                offset: Offset(2, 2),
                blurRadius: 1,
              )
            ]
          : [
              BoxShadow(
                blurRadius: 1,
                offset: Offset(-2, -2),
                color: mCL.withOpacity(0.5),
              ),
              BoxShadow(
                color: mCD,
                offset: Offset(2, 2),
                blurRadius: 1,
              )
            ]);
}
