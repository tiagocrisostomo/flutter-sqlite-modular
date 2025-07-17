import 'package:db_sqlite/data/model/usuario.dart';
import 'package:db_sqlite/data/services/usuario_service.dart';
import 'package:flutter/material.dart';

enum EstadoUsuario { inicial, carregando, carregado, erro, deletando, deletado, incluindo, incluido, alterando, alterado }

class UsuarioStore extends ChangeNotifier {
  final UsuarioService _service = UsuarioService();

  List<Usuario> _usuarios = [];
  List<Usuario> get usuarios => _usuarios;

  List<Usuario> _usuario = [];
  List<Usuario> get usuario => _usuario;

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
    if (usuario.id == null) {
      _estado = EstadoUsuario.incluindo;
    } else {
      _estado = EstadoUsuario.alterando;
    }
    notifyListeners();
    try {
      await _service.salvarOuAtualizarUsuario(usuario);
      if (usuario.id == null) {
        _estado = EstadoUsuario.incluido;
      } else {
        _estado = EstadoUsuario.alterado;
      }
      notifyListeners();

      // Atualiza a lista de usuários após adicionar
      // await carregarUsuarios();
    } catch (e) {
      _estado = EstadoUsuario.erro;
      _mensagemErro = "Erro ao adicionar usuário: $e";
      notifyListeners();
    }
  }

  Future<void> removerUsuario(int id) async {
    _estado = EstadoUsuario.deletando;
    notifyListeners();
    try {
      await _service.deletarUsuario(id);
      _estado = EstadoUsuario.deletado;
      notifyListeners();
    } catch (e) {
      _estado = EstadoUsuario.erro;
      _mensagemErro = "Erro ao remover usuário: $e";
      notifyListeners();
    }
  }

  Future<void> buscarUsuarioId(int id) async {
    try {
      _usuario = await _service.buscarUsuarioPorId(id);
      notifyListeners();
    } catch (e) {
      _estado = EstadoUsuario.erro;
      _mensagemErro = "Erro ao consultar tipo: $e";
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
