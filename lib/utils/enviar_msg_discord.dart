import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> enviarMensagemDiscord(
  dynamic exception,
  StackTrace? stack, {
  dynamic reason,
  Iterable<Object> information = const [],
  bool? printDetails,
  bool fatal = false,
}) async {
  const String webhookUrl = '<SUA WEBHOOK URL AQUI>';

  final String mensagem = '''
🔴🔴🔴🔴🔴🔴🔴
**Erro:** $exception
**Razão:** $reason
**Informações:** ${information.join('\n')}
**Stack Trace:** $stack
**Fatal:** $fatal''';

  final response = await http.post(Uri.parse(webhookUrl), headers: {'Content-Type': 'application/json'}, body: jsonEncode({'content': mensagem}));

  if (response.statusCode == 204) {
    debugPrint('Mensagem enviada com sucesso!');
  } else {
    debugPrint('Erro ao enviar mensagem: ${response.statusCode}');
    debugPrint(response.body);
  }
}
