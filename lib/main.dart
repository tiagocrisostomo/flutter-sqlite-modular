import 'package:db_sqlite/store/finan_lancamento_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:db_sqlite/store/auth_store.dart';
import 'package:db_sqlite/store/finan_tipo_store.dart';
import 'package:db_sqlite/store/usuario_store.dart';
import 'package:db_sqlite/store/finan_categoria_store.dart';

import 'package:db_sqlite/utils/seed.dart';
import 'package:db_sqlite/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await inicializarBancoComDadosPadrao();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthStore()),
        ChangeNotifierProvider(create: (_) => UsuarioStore()),
        ChangeNotifierProvider(create: (_) => FinanTipoStore()),
        ChangeNotifierProvider(create: (_) => FinanCategoriaStore()),
        ChangeNotifierProvider(create: (_) => FinanLancamentoStore()),
      ],
      child: MaterialApp(
        home: LoginScreen(),
        title: 'Login',
        theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), primaryColor: Colors.blue),
      ),
    ),
  );
}
