import 'package:db_sqlite/data/model/finan_categoria.dart';
import 'package:db_sqlite/store/finan_categoria_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class FormularioFinanCategoria extends StatefulWidget {
  final FinanCategoria? categoria;
  const FormularioFinanCategoria({super.key, this.categoria});

  @override
  State<FormularioFinanCategoria> createState() => _FormularioFinanCategoriaState();
}

class _FormularioFinanCategoriaState extends State<FormularioFinanCategoria> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descricaoController;
  String? _corSelecionada = '#FF0000'; // default

  @override
  void initState() {
    super.initState();
    _descricaoController = TextEditingController(text: widget.categoria?.descricao ?? '');
    _corSelecionada = widget.categoria?.cor ?? '#FF0000';
  }

  void _abrirSeletorDeCor() {
    Color pickerColor = Color(int.parse(_corSelecionada!.replaceAll("#", "0xFF")));

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Selecione uma cor'),
            content: SingleChildScrollView(
              child: BlockPicker(
                pickerColor: pickerColor,
                onColorChanged: (Color cor) {
                  setState(() {
                    _corSelecionada = '#${cor.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
                  });
                },
              ),
            ),
            actions: [TextButton(child: const Text('Fechar'), onPressed: () => Navigator.of(context).pop())],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<FinanCategoriaStore>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text('Cadastrar nova Categoria', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
      body: Padding(
        padding: const EdgeInsets.only(left: 32, right: 32, top: 8),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _descricaoController,
                decoration: InputDecoration(labelText: 'Descrição'),
                validator: (v) => v == null || v.isEmpty ? 'Informe a descrição' : null,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  const Text("Cor:"),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _abrirSeletorDeCor,
                    child: CircleAvatar(backgroundColor: Color(int.parse(_corSelecionada!.replaceAll("#", "0xFF"))), radius: 20),
                  ),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                icon: Icon(Icons.save),
                label: Text('Salvar'),
                onPressed: () async {
                  // Adicione a lógica para salvar a categoria aqui
                  if (_formKey.currentState!.validate()) {
                    // Adicione a lógica para salvar o tipo aqui
                    await store.adicionarCategoria(FinanCategoria(descricao: _descricaoController.text.trim(), cor: _corSelecionada.toString()));

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
