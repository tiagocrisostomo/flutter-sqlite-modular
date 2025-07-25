import 'package:db_sqlite/data/model/finan_lancamento.dart';
import 'package:db_sqlite/store/finan_categoria_store.dart';
import 'package:db_sqlite/store/finan_lancamento_store.dart';
import 'package:db_sqlite/store/finan_tipo_store.dart';
import 'package:db_sqlite/store/usuario_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class FinanLancamentoForm extends StatefulWidget {
  final FinanLancamento? lancamento;

  const FinanLancamentoForm({super.key, this.lancamento});

  @override
  State<FinanLancamentoForm> createState() => _FinanLancamentoFormState();
}

class _FinanLancamentoFormState extends State<FinanLancamentoForm> {
  final NumberFormat _formatter = NumberFormat.currency(locale: "pt_BR", symbol: "R\$", decimalDigits: 2);
  String _formattedValue = "";

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
    final categoriaStore = Provider.of<FinanCategoriaStore>(context, listen: false);
    final usuarioStore = Provider.of<UsuarioStore>(context, listen: false);

    Future.microtask(() {
      tipoStore.carregarTodosTipos();
      categoriaStore.carregarCategorias();
      usuarioStore.carregarUsuarios();
    });

    final lancamento = widget.lancamento;
    _descricaoController = TextEditingController(text: lancamento?.descricao ?? '');
    _valorController = TextEditingController(text: lancamento != null ? _formatter.format(lancamento.valor) : '');
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

  void _onChanged(String value) {
    // Remove qualquer formatação existente
    String cleanValue = value.replaceAll(RegExp(r'[^\d]'), '');

    if (cleanValue.isNotEmpty) {
      double? numericValue = double.tryParse(cleanValue);
      if (numericValue != null) {
        numericValue /= 100; // Considerando centavos
        _formattedValue = _formatter.format(numericValue);
        _valorController.value = TextEditingValue(text: _formattedValue, selection: TextSelection.collapsed(offset: _formattedValue.length));
        setState(() {});
      }
    } else {
      _formattedValue = "";
      _valorController.clear();
      setState(() {});
    }
  }

  Future<void> _selecionarData() async {
    final data = await showDatePicker(context: context, initialDate: _dataSelecionada, firstDate: DateTime(2010), lastDate: DateTime(2100));
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
      appBar: AppBar(title: Text(widget.lancamento == null ? 'Novo Lançamento' : 'Editar Lançamento')),
      body: Padding(
        padding: const EdgeInsets.only(left: 32, right: 32, top: 8),
        child: Form(
          key: _formKey,
          child: ListView(
            // mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                controller: _descricaoController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.abc),
                  hintText: 'Descrição',
                ),
                validator: (value) => value == null || value.isEmpty ? 'Informe a descrição' : null,
                inputFormatters: [LengthLimitingTextInputFormatter(30)],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _valorController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.monetization_on),
                  labelText: 'Valor',
                ),
                onChanged: _onChanged,

                validator: (value) => value == null || value.isEmpty ? 'Informe o valor' : null,
              ),
              const SizedBox(height: 8),
              Text('Data: ${DateFormat('dd/MM/yyyy').format(_dataSelecionada)}', style: TextStyle(fontSize: 22), textAlign: TextAlign.center),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _selecionarData,
                style: ButtonStyle(shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
                child: const Text('Selecionar Data'),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: _tipoId,
                items:
                    tipoStore.finanTodosTipos.map((tipo) {
                      return DropdownMenuItem(value: tipo.id, child: Text(tipo.descricao!));
                    }).toList(),
                onChanged: (val) => setState(() => _tipoId = val),
                decoration: InputDecoration(labelText: 'Tipo', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                validator: (value) => value == null ? 'Selecione o tipo' : null,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: _categoriaId,
                items:
                    categoriaStore.finanCategorias.map((cat) {
                      return DropdownMenuItem(value: cat.id, child: Text(cat.descricao!));
                    }).toList(),
                onChanged: (val) => setState(() => _categoriaId = val),
                decoration: InputDecoration(labelText: 'Categoria', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                validator: (value) => value == null ? 'Selecione a categoria' : null,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: _usuarioId,
                items:
                    usuarioStore.usuarios.map((u) {
                      return DropdownMenuItem(value: u.id, child: Text(u.nome));
                    }).toList(),
                onChanged: (val) => setState(() => _usuarioId = val),
                decoration: InputDecoration(labelText: 'Titular', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                validator: (value) => value == null ? 'Selecione o dono da despesa/receita' : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // 1. Obter o texto do controlador de valor.
                    String valorText = _valorController.text;

                    // 2. Remover o prefixo "R$" e substituir a vírgula por ponto.
                    // Isso padroniza a string para o formato aceito por double.tryParse.
                    String cleanValorText = valorText.replaceAll('R\$', '').replaceAll('.', '').replaceAll(',', '.').trim();

                    // 3. Tentar converter para double. Se falhar, usar 0.0.
                    double valorNumerico = double.tryParse(cleanValorText) ?? 0.0;

                    await lancamentoStore.adicionarOuEditarLancamento(
                      FinanLancamento(
                        id: widget.lancamento?.id,
                        descricao: _descricaoController.text,
                        valor: valorNumerico,
                        data: _dataSelecionada,
                        tipoId: _tipoId!,
                        categoriaId: _categoriaId!,
                        usuarioId: _usuarioId!,
                      ),
                    );
                    if (context.mounted) Navigator.pop(context);
                  }
                },
                style: ButtonStyle(shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
