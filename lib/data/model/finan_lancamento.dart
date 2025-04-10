class FinanLancamento {
  int? id;
  String? descricao;
  double? valor;
  String? data;
  int? tipoId; // "Geral" ou "Pessoal"
  int? categoriaId; // "A Pagar" ou "A Receber"
  int? usuarioId; // ID do usuário associado a este lançamento

  FinanLancamento({
    this.id,
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
      data: json['data'],
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
      'data': data,
      'tipoId': tipoId,
      'categoriaId': categoriaId,
      'usuarioId': usuarioId,
    };
  }
}
