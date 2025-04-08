import 'package:db_sqlite/auth/auth_service.dart';
import 'package:db_sqlite/data/model/usuario.dart';
import 'package:flutter/material.dart';

enum EstadoAuth { inicial, carregando, sucesso, erro }

class AuthStore extends ChangeNotifier {
  final AuthService _authService = AuthService();

  Usuario? usuarioLogado;
  EstadoAuth estado = EstadoAuth.inicial;
  String? erro;

  Future<void> login(String nome, String senha) async {
    estado = EstadoAuth.carregando;
    notifyListeners();
    try {
      usuarioLogado = await _authService.login(nome, senha);
      if (usuarioLogado != null) {
        estado = EstadoAuth.sucesso;
      } else {
        estado = EstadoAuth.erro;
        erro = 'Usuário ou senha inválidos';
      }
    } catch (e) {
      estado = EstadoAuth.erro;
      erro = 'Erro ao realizar login: $e';
    }
    notifyListeners();
  }

  void logout() {
    usuarioLogado = null;
    estado = EstadoAuth.inicial;
    notifyListeners();
  }
}
