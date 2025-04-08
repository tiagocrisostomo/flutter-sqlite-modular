import 'package:db_sqlite/auth/auth_store.dart';
import 'package:db_sqlite/screens/login_screen.dart';

import 'package:db_sqlite/store/usuario_store.dart';
import 'package:db_sqlite/utils/seed.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await inicializarBancoComUsuarioPadrao();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthStore()),
        ChangeNotifierProvider(create: (_) => UsuarioStore()),
      ],
      child: MaterialApp(home: LoginScreen(), title: 'Login local'),
    ),
  );
}
