import 'package:db_sqlite/store/usuario_store.dart';
import 'package:db_sqlite/widgets/usuario_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsuarioScreen extends StatefulWidget {
  const UsuarioScreen({super.key});

  @override
  State<UsuarioScreen> createState() => _UsuarioScreenState();
}

class _UsuarioScreenState extends State<UsuarioScreen> {
  @override
  void initState() {
    super.initState();
    // carregar os usuários ao iniciar o aplicativo
    // Future.microtask(
    //   () =>
    //       // ignore: use_build_context_synchronously
    //       Provider.of<UsuarioStore>(context, listen: false).carregarUsuarios(),
    // );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UsuarioStore>(context, listen: false).carregarUsuarios();
    });
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<UsuarioStore>(context);

    // Exibe snackbar se houver erro
    if (store.estado == EstadoUsuario.erro && store.mensagemErro != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(store.mensagemErro!),
            backgroundColor: Colors.red,
          ),
        );
        store.limparErro();
      });
    }

    Widget corpo;

    switch (store.estado) {
      case EstadoUsuario.carregando:
        corpo = Center(child: CircularProgressIndicator());
        break;
      case EstadoUsuario.erro:
        corpo = Center(child: Text(store.mensagemErro ?? 'Erro inesperado'));
        break;
      case EstadoUsuario.carregado:
        corpo = ListView.builder(
          itemCount: store.usuarios.length,
          itemBuilder: (_, index) {
            final u = store.usuarios[index];
            return ListTile(
              leading: CircleAvatar(
                child:
                    u.id != null ? Text(u.id.toString()) : Icon(Icons.person),
              ),
              title: Text(u.nome),
              trailing: IconButton(
                icon: Icon(Icons.delete_forever_outlined, color: Colors.red),
                onPressed: () => _confirmarExclusaoUsuario(context, u.id!),
              ),
            );
          },
        );
        break;
      default:
        corpo = SizedBox();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Usuários'),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.green, applyTextScaling: true),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FormularioUsuario()),
              );
            },
          ),
        ],
      ),
      body: corpo,
    );
  }

  void _confirmarExclusaoUsuario(BuildContext context, int id) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Excluir usuário'),
            content: Text('Deseja realmente excluir o usuário?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Provider.of<UsuarioStore>(
                    context,
                    listen: false,
                  ).removerUsuario(id);
                  Navigator.of(context).pop();
                },
                child: Text('Excluir'),
              ),
            ],
          ),
    );
  }
}
