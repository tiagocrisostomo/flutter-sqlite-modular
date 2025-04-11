import 'package:db_sqlite/screens/finan_categoria_screen.dart';
import 'package:db_sqlite/screens/finan_tipo_screen.dart';
import 'package:db_sqlite/screens/usuario_screen.dart';
import 'package:flutter/material.dart';

class ConfigScreen extends StatelessWidget {
  const ConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Usuários'),
            subtitle: const Text('Gerencie os usuários do sistema'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UsuarioScreen()),
              );
            },
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Categorias Financeiras'),
            subtitle: const Text('Cadastrar e editar categorias'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FinanCategoriaScreen()),
              );
            },
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.label),
            title: const Text('Tipos Financeiros'),
            subtitle: const Text('Cadastrar e editar tipos'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FinanTipoScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
