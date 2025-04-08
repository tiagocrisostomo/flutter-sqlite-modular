import 'dart:convert';
import 'package:crypto/crypto.dart';

class Seguranca {
  static hashSenha(String senha) {
    final bytes = utf8.encode(senha);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
