class Usuario {
  int? id;
  String nome;
  int idade;

  Usuario({this.id, required this.nome, required this.idade});

  factory Usuario.fromMap(Map<String, dynamic> json) {
    return Usuario(id: json['id'], nome: json['nome'], idade: json['idade']);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'nome': nome, 'idade': idade};
  }
}
