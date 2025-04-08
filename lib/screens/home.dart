import 'package:db_sqlite/data/model/usuario.dart';
import 'package:db_sqlite/store/usuario_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    // carregar os usuários ao iniciar o aplicativo
    Future.microtask(
      () =>
          Provider.of<UsuarioStore>(context, listen: false).carregarUsuarios(),
    );
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
              subtitle: Text("Idade: ${u.idade}"),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => store.removerUsuario(u.id!),
              ),
            );
          },
        );
        break;
      default:
        corpo = SizedBox();
    }

    return Scaffold(
      appBar: AppBar(title: Text('Usuários')),
      body: corpo,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Usuario novo = Usuario(nome: "Novo", idade: 30);
          store.adicionarUsuario(novo);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
