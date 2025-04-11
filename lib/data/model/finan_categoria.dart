class FinanCategoria {
  int? id;
  String? descricao;
  String? cor;

  FinanCategoria({this.id, required this.descricao, required this.cor});

  factory FinanCategoria.fromMap(Map<String, dynamic> json) {
    return FinanCategoria(
      id: json['id'],
      descricao: json['descricao'],
      cor: json['cor'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'descricao': descricao, 'cor': cor};
  }
}
