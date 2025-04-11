class FinanTipo {
  int? id;
  String? descricao;
  String? cor;

  FinanTipo({this.id, required this.descricao, required this.cor});

  factory FinanTipo.fromMap(Map<String, dynamic> json) {
    return FinanTipo(
      id: json['id'],
      descricao: json['descricao'],
      cor: json['cor'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'descricao': descricao, 'cor': cor};
  }
}
