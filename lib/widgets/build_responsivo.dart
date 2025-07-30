import 'package:db_sqlite/utils/dispositivo_tela_tipo.dart';
import 'package:flutter/material.dart';

class BuildResponsivo extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const BuildResponsivo({super.key, required this.mobile, required this.desktop, this.tablet});

  @override
  Widget build(BuildContext context) {
    final dispositivoTipo = getDispositivoTipo(MediaQuery.of(context));

    switch (dispositivoTipo) {
      case DispositivoTelaTipo.desktop:
        return desktop;
      case DispositivoTelaTipo.tablet:
        return tablet ?? mobile;
      case DispositivoTelaTipo.mobile:
        return mobile;
    }
  }
}
