import 'dart:io';

import 'package:db_sqlite/data/services/auth_service.dart';
import 'package:db_sqlite/data/model/usuario.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

enum EstadoAuth { inicial, logando, logado, erro }

class AuthStore extends ChangeNotifier {
  final AuthService _authService = AuthService();

  Usuario? usuarioLogado;

  EstadoAuth _estado = EstadoAuth.inicial;
  EstadoAuth get estadoAuth => _estado;

  String? _mensagemErro;
  String? get mensagemErro => _mensagemErro;

  Future<void> login(String nome, String senha) async {
    _estado = EstadoAuth.logando;
    notifyListeners();
    try {
      usuarioLogado = await _authService.login(nome, senha);
      if (usuarioLogado != null) {
        _estado = EstadoAuth.logado;
      } else {
        _estado = EstadoAuth.erro;
        _mensagemErro = 'Usuário ou senha inválidos';
        if (Platform.isAndroid || Platform.isIOS) {
          await FirebaseCrashlytics.instance.recordError(
            Exception('Usuário ou senha inválidos'),
            StackTrace.current,
            reason: 'erro não fatal',
            information: [_mensagemErro.toString(), _estado, 'Login falhou'],
            printDetails: true,
            fatal: false,
          );
        }
      }
    } catch (e, stack) {
      _estado = EstadoAuth.erro;
      _mensagemErro = 'Erro ao realizar login: $e';
      if (Platform.isAndroid || Platform.isIOS) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
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
