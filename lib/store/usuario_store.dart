import 'package:db_sqlite/data/model/usuario.dart';
import 'package:db_sqlite/data/services/usuario_service.dart';
import 'package:flutter/material.dart';

enum EstadoUsuario { inicial, carregando, carregado, erro }

class UsuarioStore extends ChangeNotifier {
  final UsuarioService _service = UsuarioService();

  List<Usuario> _usuarios = [];
  List<Usuario> get usuarios => _usuarios;

  EstadoUsuario _estado = EstadoUsuario.inicial;
  EstadoUsuario get estado => _estado;

  String? _mensagemErro;
  String? get mensagemErro => _mensagemErro;

  Future<void> carregarUsuarios() async {
    _estado = EstadoUsuario.carregando;
    notifyListeners();

    try {
      _usuarios = await _service.buscarUsuarios();
      _estado = EstadoUsuario.carregado;
    } catch (e) {
      _estado = EstadoUsuario.erro;
      _mensagemErro = "Erro ao carregar usuários: $e";
    }

    notifyListeners();
  }

  Future<void> adicionarUsuario(Usuario usuario) async {
    try {
      await _service.salvarOuAtualizarUsuario(usuario);

      // Atualiza a lista de usuários após adicionar
      await carregarUsuarios();
    } catch (e) {
      _estado = EstadoUsuario.erro;
      _mensagemErro = "Erro ao adicionar usuário: $e";
      notifyListeners();
    }
  }

  Future<void> removerUsuario(int id) async {
    try {
      await _service.deletarUsuario(id);
      await carregarUsuarios();
    } catch (e) {
      _estado = EstadoUsuario.erro;
      _mensagemErro = "Erro ao remover usuário: $e";
      notifyListeners();
    }
  }

  void limparErro() {
    _mensagemErro = null;
    _estado = EstadoUsuario.inicial;
    notifyListeners();
    carregarUsuarios();
  }
}
