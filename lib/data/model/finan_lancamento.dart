class FinanLancamento {
  int? id;
  String? descricao;
  double valor = 0.00;
  DateTime? data;
  int? tipoId; // "Geral" ou "Pessoal"
  int? categoriaId; // "A Pagar" ou "A Receber"
  int? usuarioId; // ID do usuário associado a este lançamento

  FinanLancamento({
    required this.id,
    required this.descricao,
    required this.valor,
    required this.data,
    required this.tipoId,
    required this.categoriaId,
    required this.usuarioId,
  });

  factory FinanLancamento.fromMap(Map<String, dynamic> json) {
    return FinanLancamento(
      id: json['id'],
      descricao: json['descricao'],
      valor: json['valor'],
      data: json['data'] != null ? DateTime.parse(json['data']) : null,
      tipoId: json['tipoId'],
      categoriaId: json['categoriaId'],
      usuarioId: json['usuarioId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'descricao': descricao,
      'valor': valor,
      'data': data?.toIso8601String(),
      'tipoId': tipoId,
      'categoriaId': categoriaId,
      'usuarioId': usuarioId,
    };
  }
}
