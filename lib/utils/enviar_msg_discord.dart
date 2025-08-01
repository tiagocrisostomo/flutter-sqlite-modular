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
  const String webhookUrl = 'https://discord.com/api/webhooks/1400529302105100319/tMGV7bAwZjbP_AYdNzGk2LLMaaKf-h7UiYQG12EMgdgMDfSFaG6IDa7Y36bAalzNA4x9';

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
