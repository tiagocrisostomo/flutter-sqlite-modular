import 'package:db_sqlite/data/model/finan_lancamento.dart';
import 'package:db_sqlite/data/services/finan_lancamento_service.dart';
import 'package:db_sqlite/store/finan_lancamento_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FormLancamento extends StatefulWidget {
  const FormLancamento({super.key});

  @override
  State<FormLancamento> createState() => _FormLancamentoState();
}

class _FormLancamentoState extends State<FormLancamento> {
  final _formKey = GlobalKey<FormState>();

  final _descricaoController = TextEditingController();
  final _valorController = TextEditingController();
  int tipoId = 1;
  int categoriaId = 1;
  int usuarioId = 1;
  DateTime _dataSelecionada = DateTime.now();

  Future<void> _salvarLancamento() async {
    if (_formKey.currentState!.validate()) {
      final lancamento = FinanLancamento(
        descricao: _descricaoController.text,
        valor: double.parse(_valorController.text),
        data: _dataSelecionada.toString(),
        tipoId: tipoId,
        categoriaId: categoriaId,
        usuarioId: usuarioId,
      );

      await LancamentoService().salvarOuAtualizarFinanLancamento(lancamento);

      if (!mounted) return;
      await context.read<LancamentoStore>().carregarPainel();

      Navigator.pop(context); // fecha o modal

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lançamento salvo com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Lançamento')),
      body: Padding(
        padding: const EdgeInsets.all(16),
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
              const SizedBox(height: 12),
              TextFormField(
                controller: _valorController,
                decoration: const InputDecoration(labelText: 'Valor'),
                keyboardType: TextInputType.number,
                validator:
                    (value) =>
                        value == null || double.tryParse(value) == null
                            ? 'Valor inválido'
                            : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                value: tipoId,
                items: const [
                  DropdownMenuItem(value: 1, child: Text('Pessoal')),
                  DropdownMenuItem(value: 2, child: Text('Geral')),
                ],
                onChanged: (value) => setState(() => tipoId = value!),
                decoration: const InputDecoration(labelText: 'Tipo'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                value: categoriaId,
                items: const [
                  DropdownMenuItem(value: 1, child: Text('A Pagar')),
                  DropdownMenuItem(value: 2, child: Text('A Receber')),
                ],
                onChanged: (value) => setState(() => categoriaId = value!),
                decoration: const InputDecoration(labelText: 'Tipo'),
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Data: ${_formatarData(_dataSelecionada)}'),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: _selecionarData,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _salvarLancamento,
                icon: const Icon(Icons.save),
                label: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selecionarData() async {
    final dataEscolhida = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (dataEscolhida != null) {
      setState(() {
        _dataSelecionada = dataEscolhida;
      });
    }
  }

  String _formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }
}
