import 'package:flutter/material.dart';

enum DispositivoTelaTipo { mobile, tablet, desktop }

DispositivoTelaTipo getDispositivoTipo(MediaQueryData mediaQuery) {
  final width = mediaQuery.size.width;
  if (width >= 950) return DispositivoTelaTipo.desktop;
  if (width >= 600) return DispositivoTelaTipo.tablet;
  return DispositivoTelaTipo.mobile;
}
