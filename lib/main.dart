import 'package:db_sqlite/screens/home.dart';
import 'package:db_sqlite/store/usuario_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UsuarioStore())],
      child: MaterialApp(home: Home()),
    ),
  );
}
