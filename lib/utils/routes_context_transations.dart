import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

extension RouterContextExtension on BuildContext {
  Future pushRtL(Widget page) {
    return Navigator.push(
      this,
      PageTransition(fullscreenDialog: false, type: PageTransitionType.rightToLeft, duration: const Duration(milliseconds: 400), child: page),
    );
  }

  Future pushRtLModal(Widget page) {
    return Navigator.push(
      this,
      PageTransition(fullscreenDialog: true, type: PageTransitionType.rightToLeft, duration: const Duration(milliseconds: 400), child: page),
    );
  }

  Future pushBtTModal(Widget page) {
    return Navigator.push(
      this,
      PageTransition(fullscreenDialog: true, type: PageTransitionType.bottomToTop, duration: const Duration(milliseconds: 400), child: page),
    );
  }

  Future pushLtR(Widget page) {
    return Navigator.push(
      this,
      PageTransition(fullscreenDialog: false, type: PageTransitionType.leftToRight, duration: const Duration(milliseconds: 400), child: page),
    );
  }

  Future pushBtT(Widget page) {
    return Navigator.push(
      this,
      PageTransition(fullscreenDialog: false, type: PageTransitionType.bottomToTop, duration: const Duration(milliseconds: 400), child: page),
    );
  }

  void pop() => Navigator.pop(this);

  Future showBottomSheet(Widget page, {bool isScrollControlled = true}) {
    return showModalBottomSheet(isScrollControlled: isScrollControlled, context: this, builder: (context) => page);
  }
}
