import 'package:db_sqlite/data/services/finan_lancamento_service.dart';
import 'package:flutter/material.dart';

class LancamentoStore extends ChangeNotifier {
  final _service = LancamentoService();

  double receitas = 0.0;
  double despesas = 0.0;
  double tipoGeral = 0.0;
  double tipoPessoal = 0.0;
  double get saldo => receitas - despesas;

  Future<void> carregarPainel() async {
    receitas = await _service.totalAreceber();
    despesas = await _service.totalApagar();
    tipoGeral = await _service.totalTipoGeral();
    tipoPessoal = await _service.totalTipoPessoal();
    notifyListeners();
  }
}
