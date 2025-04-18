class Usuario {
  int? id;
  String nome;
  String senha;
  String email;

  Usuario({this.id, required this.nome, required this.senha, required this.email});

  factory Usuario.fromMap(Map<String, dynamic> json) {
    return Usuario(id: json['id'], nome: json['nome'], senha: json['senha'], email: json['email']);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'nome': nome, 'senha': senha, 'email': email};
  }
}
