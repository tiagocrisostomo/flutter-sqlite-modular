class Usuario {
  int? id;
  String nome;
  String senha;

  Usuario({this.id, required this.nome, required this.senha});

  factory Usuario.fromMap(Map<String, dynamic> json) {
    return Usuario(id: json['id'], nome: json['nome'], senha: json['senha']);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'nome': nome, 'senha': senha};
  }
}
