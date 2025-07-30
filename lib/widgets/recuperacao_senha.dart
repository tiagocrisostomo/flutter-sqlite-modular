import 'package:flutter/material.dart';

class RecuperacaoSenha extends StatefulWidget {
  const RecuperacaoSenha({super.key});

  @override
  State<RecuperacaoSenha> createState() => _RecuperacaoSenhaState();
}

class _RecuperacaoSenhaState extends State<RecuperacaoSenha> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Recuperar Senha'),
      content: Text('Funcionalidade de recuperação de senha ainda não implementada.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.green),
            foregroundColor: WidgetStatePropertyAll(Colors.white),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          ),
          child: Text('Recuperar'),
        ),
        TextButton(
          onPressed: () async {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pop();
            });
          },
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.red),
            foregroundColor: WidgetStatePropertyAll(Colors.white),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          ),
          child: Text('Cancelar'),
        ),
      ],
    );
  }
}
