import 'package:db_sqlite/data/services/auth_service.dart';
import 'package:db_sqlite/data/model/usuario.dart';
import 'package:flutter/material.dart';

enum EstadoAuth { inicial, carregando, sucesso, erro }

class AuthStore extends ChangeNotifier {
  final AuthService _authService = AuthService();

  Usuario? usuarioLogado;

  EstadoAuth _estado = EstadoAuth.inicial;
  EstadoAuth get estadoAuth => _estado;

  String? _mensagemErro;
  String? get mensagemErro => _mensagemErro;

  Future<void> login(String nome, String senha) async {
    _estado = EstadoAuth.carregando;
    notifyListeners();
    try {
      usuarioLogado = await _authService.login(nome, senha);
      if (usuarioLogado != null) {
        _estado = EstadoAuth.sucesso;
      } else {
        _estado = EstadoAuth.erro;
        _mensagemErro = 'Usuário ou senha inválidos';
      }
    } catch (e) {
      _estado = EstadoAuth.erro;
      _mensagemErro = 'Erro ao realizar login: $e';
    }
    notifyListeners();
  }

  void logout() {
    usuarioLogado = null;
    _estado = EstadoAuth.inicial;
    notifyListeners();
  }

  void limparErro() {
    _mensagemErro = null;
    _estado = EstadoAuth.inicial;
    notifyListeners();
  }
}
