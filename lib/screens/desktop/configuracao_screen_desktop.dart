import 'package:db_sqlite/screens/desktop/finan_categoria_screen_desktop.dart';
import 'package:db_sqlite/screens/desktop/finan_tipo_screen_desktop.dart';
import 'package:db_sqlite/screens/mobile/usuario_screen.dart';
import 'package:db_sqlite/utils/routes_context_transations.dart';
import 'package:flutter/material.dart';

class ConfigScreenDesktop extends StatelessWidget {
  const ConfigScreenDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold))),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(20),
        children: [
          ListTile(
            leading: Container(
              height: double.infinity,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  colors: [Color(0xFF0f2027), Color(0xFF203A43), Color(0xFF2c5364)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),

                border: Border.all(color: Colors.grey, width: 2),
              ),
              child: const Icon(Icons.person, color: Colors.white),
            ),
            title: const Text('Usuários', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            subtitle: const Text('Gerencie os usuários do sistema'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => context.pushRtL(const UsuarioScreen()),
          ),
          const Divider(),

          ListTile(
            leading: Container(
              height: double.infinity,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  colors: [Color(0xFF0f2027), Color(0xFF203A43), Color(0xFF2c5364)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),

                border: Border.all(color: Colors.grey, width: 2),
              ),
              child: const Icon(Icons.category, color: Colors.white),
            ),
            title: const Text('Categorias de Finanças', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            subtitle: const Text('Cadastrar e editar categorias'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => context.pushRtL(const FinanCategoriaScreenDesktop()),
          ),
          const Divider(),

          ListTile(
            leading: Container(
              height: double.infinity,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  colors: [Color(0xFF0f2027), Color(0xFF203A43), Color(0xFF2c5364)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),

                border: Border.all(color: Colors.grey, width: 2),
              ),
              child: const Icon(Icons.label, color: Colors.white),
            ),
            title: const Text('Tipos de Finanças', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            subtitle: const Text('Cadastrar e editar tipos'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => context.pushRtL(const FinanTipoScreenDesktop()),
          ),
        ],
      ),
    );
  }
}
