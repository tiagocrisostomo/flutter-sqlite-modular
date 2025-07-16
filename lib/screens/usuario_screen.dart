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
            showCloseIcon: true,
            // width: Material, // Width of the SnackBar.
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0, // Inner padding for SnackBar content.
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            elevation: 10,
            dismissDirection: DismissDirection.horizontal,
            animation: CurvedAnimation(parent: const AlwaysStoppedAnimation(1.5), curve: Curves.easeIn),
          ),
        );
        store.limparErro();
      });
    }

    if (store.estado == EstadoUsuario.deletado) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Deletado'),

            backgroundColor: Colors.green,
            showCloseIcon: true,
            // width: Material, // Width of the SnackBar.
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0, // Inner padding for SnackBar content.
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            elevation: 10,
            dismissDirection: DismissDirection.horizontal,
            animation: CurvedAnimation(parent: const AlwaysStoppedAnimation(1.5), curve: Curves.easeIn),
          ),
        );
        store.limparErro();
      });
    }

    if (store.estado == EstadoUsuario.incluido) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cadastrado.'),
            backgroundColor: Colors.green,
            showCloseIcon: true,
            // width: Material, // Width of the SnackBar.
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0, // Inner padding for SnackBar content.
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            elevation: 10,
            dismissDirection: DismissDirection.horizontal,
            animation: CurvedAnimation(parent: const AlwaysStoppedAnimation(1.5), curve: Curves.easeIn),
          ),
        );
        store.limparErro();
      });
    }

    if (store.estado == EstadoUsuario.alterado) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Alterado.'),
            backgroundColor: Colors.green,
            showCloseIcon: true,
            // width: Material, // Width of the SnackBar.
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0, // Inner padding for SnackBar content.
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            elevation: 10,
            dismissDirection: DismissDirection.horizontal,
            animation: CurvedAnimation(parent: const AlwaysStoppedAnimation(1.5), curve: Curves.easeIn),
          ),
        );
        store.limparErro();
      });
    }

    Widget corpo;

    switch (store.estado) {
      case EstadoUsuario.carregando:
        corpo = Center(child: CircularProgressIndicator(semanticsLabel: 'Carregando...'));
        break;
      case EstadoUsuario.deletando:
        corpo = Center(child: CircularProgressIndicator(semanticsLabel: 'Deletando...'));
        break;
      case EstadoUsuario.incluindo:
        corpo = Center(child: CircularProgressIndicator(semanticsLabel: 'Incluindo...'));
        break;
      case EstadoUsuario.alterando:
        corpo = Center(child: CircularProgressIndicator(semanticsLabel: 'Alterando...'));
        break;
      case EstadoUsuario.carregado:
        corpo = ListView.builder(
          itemCount: store.usuarios.length,
          itemBuilder: (_, index) {
            final usuario = store.usuarios[index];
            return ListTile(
              dense: true,
              leading: CircleAvatar(child: usuario.id != null ? Text(usuario.id.toString()) : Icon(Icons.person)),
              title: Text(usuario.nome),
              trailing: SizedBox(
                width: MediaQuery.of(context).size.width * 0.25,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue, size: 18),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => FormularioUsuario(usuario: usuario)));
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_forever_outlined, color: Colors.red, size: 18),
                      onPressed: () => _confirmarExclusaoUsuario(context, usuario.id!),
                    ),
                  ],
                ),
              ),
            );
          },
        );
        break;
      default:
        corpo = Center(child: CircularProgressIndicator(semanticsLabel: 'Padrão...'));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Usuários'),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.green, applyTextScaling: true, size: 35),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => FormularioUsuario()));
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
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                  foregroundColor: WidgetStatePropertyAll(Colors.blue),
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                ),
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Provider.of<UsuarioStore>(context, listen: false).removerUsuario(id);
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.red),
                  foregroundColor: WidgetStatePropertyAll(Colors.white),
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                ),
                child: Text('Excluir'),
              ),
            ],
          ),
    );
  }
}
