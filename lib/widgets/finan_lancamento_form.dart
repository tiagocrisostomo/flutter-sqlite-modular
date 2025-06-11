import 'package:db_sqlite/data/model/finan_lancamento.dart';
import 'package:db_sqlite/store/finan_categoria_store.dart';
import 'package:db_sqlite/store/finan_lancamento_store.dart';
import 'package:db_sqlite/store/finan_tipo_store.dart';
import 'package:db_sqlite/store/usuario_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class FinanLancamentoForm extends StatefulWidget {
  final FinanLancamento? lancamento;

  const FinanLancamentoForm({super.key, this.lancamento});

  @override
  State<FinanLancamentoForm> createState() => _FinanLancamentoFormState();
}

class _FinanLancamentoFormState extends State<FinanLancamentoForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _descricaoController;
  late TextEditingController _valorController;
  late DateTime _dataSelecionada;

  int? _tipoId;
  int? _categoriaId;
  int? _usuarioId;

  @override
  void initState() {
    super.initState();

    final tipoStore = Provider.of<FinanTipoStore>(context, listen: false);
    final categoriaStore = Provider.of<FinanCategoriaStore>(
      context,
      listen: false,
    );
    final usuarioStore = Provider.of<UsuarioStore>(context, listen: false);

    Future.microtask(() {
      tipoStore.carregarTipos();
      categoriaStore.carregarCategorias();
      usuarioStore.carregarUsuarios();
    });

    final lancamento = widget.lancamento;
    _descricaoController = TextEditingController(
      text: lancamento?.descricao ?? '',
    );
    _valorController = TextEditingController(
      text: lancamento?.valor.toString() ?? '',
    );
    _dataSelecionada = lancamento?.data ?? DateTime.now();
    _tipoId = lancamento?.tipoId;
    _categoriaId = lancamento?.categoriaId;
    _usuarioId = lancamento?.usuarioId;
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  Future<void> _selecionarData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (data != null) {
      setState(() {
        _dataSelecionada = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lancamentoStore = Provider.of<FinanLancamentoStore>(context);
    final tipoStore = Provider.of<FinanTipoStore>(context);
    final categoriaStore = Provider.of<FinanCategoriaStore>(context);
    final usuarioStore = Provider.of<UsuarioStore>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.lancamento == null ? 'Novo Lançamento' : 'Editar Lançamento',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Informe a descrição'
                            : null,
              ),
              TextFormField(
                controller: _valorController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Valor (R\$)'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Informe o valor'
                            : null,
              ),
              const SizedBox(height: 16),
              Text(
                'Data: ${DateFormat('dd/MM/yyyy').format(_dataSelecionada)}',
              ),
              ElevatedButton(
                onPressed: _selecionarData,
                child: const Text('Selecionar Data'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _tipoId,
                items:
                    tipoStore.finanTipos.map((tipo) {
                      return DropdownMenuItem(
                        value: tipo.id,
                        child: Text(tipo.descricao!),
                      );
                    }).toList(),
                onChanged: (val) => setState(() => _tipoId = val),
                decoration: const InputDecoration(labelText: 'Tipo'),
                validator: (value) => value == null ? 'Selecione o tipo' : null,
              ),
              DropdownButtonFormField<int>(
                value: _categoriaId,
                items:
                    categoriaStore.finanCategorias.map((cat) {
                      return DropdownMenuItem(
                        value: cat.id,
                        child: Text(cat.descricao!),
                      );
                    }).toList(),
                onChanged: (val) => setState(() => _categoriaId = val),
                decoration: const InputDecoration(labelText: 'Categoria'),
                validator:
                    (value) => value == null ? 'Selecione a categoria' : null,
              ),
              DropdownButtonFormField<int>(
                value: _usuarioId,
                items:
                    usuarioStore.usuarios.map((u) {
                      return DropdownMenuItem(value: u.id, child: Text(u.nome));
                    }).toList(),
                onChanged: (val) => setState(() => _usuarioId = val),
                decoration: const InputDecoration(labelText: 'Titular'),
                validator:
                    (value) => value == null ? 'Selecione o dono da despesa/receita' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final lancamento = FinanLancamento(
                      id: widget.lancamento?.id,
                      descricao: _descricaoController.text,
                      valor: double.tryParse(_valorController.text) ?? 0,
                      data: _dataSelecionada,
                      tipoId: _tipoId!,
                      categoriaId: _categoriaId!,
                      usuarioId: _usuarioId!,
                    );
        
                    await lancamentoStore.adicionarOuEditarLancamento(
                      lancamento,
                    );
                    if (context.mounted) Navigator.pop(context);
                  }
                },
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
