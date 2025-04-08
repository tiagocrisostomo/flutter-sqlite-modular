import 'package:db_sqlite/data/model/usuario.dart';
import 'package:db_sqlite/store/usuario_store.dart';
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
        onPressed: () => _abrirBottomSheetCadastro(context),
        child: Icon(Icons.add),
      ),
    );
  }

  _abrirBottomSheetCadastro(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // para abrir com o teclado
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder:
          (_) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 24,
            ),
            child: _FormularioUsuario(),
          ),
    );
  }
}

class _FormularioUsuario extends StatefulWidget {
  @override
  State<_FormularioUsuario> createState() => _FormularioUsuarioState();
}

class _FormularioUsuarioState extends State<_FormularioUsuario> {
  final _formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<UsuarioStore>(context, listen: false);

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min, // tamanho automático
        children: [
          Text(
            'Cadastrar novo usuário',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: nomeController,
            decoration: InputDecoration(labelText: 'Nome'),
            validator: (v) => v == null || v.isEmpty ? 'Informe o nome' : null,
          ),
          TextFormField(
            controller: senhaController,
            decoration: InputDecoration(labelText: 'Senha'),
            obscureText: true,
            validator:
                (v) => v == null || v.length < 4 ? 'Mínimo 4 caracteres' : null,
          ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            icon: Icon(Icons.save),
            label: Text('Salvar'),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await store.adicionarUsuario(
                  Usuario(
                    nome: nomeController.text,
                    senha: senhaController.text,
                  ),
                );

                Navigator.pop(context); // fecha o BottomSheet
              }
            },
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }
}
