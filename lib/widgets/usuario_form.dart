import 'package:db_sqlite/data/model/usuario.dart';
import 'package:db_sqlite/store/usuario_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FormularioUsuario extends StatefulWidget {
  const FormularioUsuario({super.key});

  @override
  State<FormularioUsuario> createState() => FormularioUsuarioState();
}

class FormularioUsuarioState extends State<FormularioUsuario> {
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
