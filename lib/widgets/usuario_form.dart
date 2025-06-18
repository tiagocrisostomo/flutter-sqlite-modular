import 'package:db_sqlite/data/model/usuario.dart';
import 'package:db_sqlite/store/usuario_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FormularioUsuario extends StatefulWidget {
  final Usuario? usuario;
  const FormularioUsuario({super.key, this.usuario});

  @override
  State<FormularioUsuario> createState() => FormularioUsuarioState();
}

class FormularioUsuarioState extends State<FormularioUsuario> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nomeController;
  late TextEditingController _senhaController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.usuario?.nome ?? '');
    _senhaController = TextEditingController(text: '');
    _emailController = TextEditingController(text: widget.usuario?.email ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<UsuarioStore>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text('Cadastrar novo usuário', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
      body: Padding(
        padding: const EdgeInsets.only(left: 32, right: 32, top: 8),
        child: Form(
          key: _formKey,
          child: ListView(
            // mainAxisSize: MainAxisSize.min, // tamanho automático
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Informe o nome' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _senhaController,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (v) => v == null || v.length < 4 ? 'Mínimo 4 caracteres' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (v) => v == null || !v.contains('@') ? 'Informe um email válido' : null,
              ),

              SizedBox(height: 16),
              ElevatedButton.icon(
                style: ButtonStyle(shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
                icon: Icon(Icons.save),
                label: Text('Salvar'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await store.adicionarUsuario(
                      Usuario(id: widget.usuario?.id, nome: _nomeController.text, email: _emailController.text, senha: _senhaController.text),
                    );

                    // ignore: use_build_context_synchronously
                    Navigator.pop(context); // fecha o BottomSheet
                  }
                },
              ),
              SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
