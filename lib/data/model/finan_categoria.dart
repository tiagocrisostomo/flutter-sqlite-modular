class FinanCategoria {
  int? id;
  String? descricao;

  FinanCategoria({this.id, required this.descricao});

  factory FinanCategoria.fromMap(Map<String, dynamic> json) {
    return FinanCategoria(id: json['id'], descricao: json['descricao']);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'descricao': descricao};
  }
}
