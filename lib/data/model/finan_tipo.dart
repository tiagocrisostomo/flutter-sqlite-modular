class FinanTipo {
  int? id;
  String? descricao;

  FinanTipo({this.id, required this.descricao});

  factory FinanTipo.fromMap(Map<String, dynamic> json) {
    return FinanTipo(id: json['id'], descricao: json['descricao']);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'descricao': descricao};
  }
}
