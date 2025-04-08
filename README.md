# 📱 Flutter SQLite Modular App

Este projeto é um exemplo de aplicação Flutter modular, utilizando `SQLite` para persistência local e `Provider` com `ChangeNotifier` para gerenciamento de estado.

---

## 🚀 Tecnologias Utilizadas

- **Flutter**
- **SQLite** com `sqflite`
- **Provider** (`ChangeNotifier`)
- Estrutura modular (camadas: `Model`, `DAO`, `Service`, `Store`, `UI`)

---

## 📂 Estrutura de Pastas

```bash
lib/
│
├── main.dart
│
├── data/
│   ├── db/
│   │   └── banco_de_dados.dart        # Instância do SQLite
│   ├── dao/
│   │   └── usuario_dao.dart           # CRUD da entidade Usuario
│   ├── model/
│   │   └── usuario.dart               # Classe Usuario
│   └── service/
│       ├── usuario_service.dart       # Service da entidade Usuario
│       └── auth_service.dart          # 🔐 Service responsável pela autenticação
│
├── store/
│   ├── usuario_store.dart             # Store da lista de usuários
│   └── auth_store.dart                # Store que lida com login/logout
│
├── auth/                              # Módulo de autenticação (UI)
│   ├── login_screen.dart              # Tela de login
│   ├── login_form.dart                # (opcional) Widget de formulário
│
├── screens/
│   └── usuario_screen.dart            # Tela principal (usuários)
│
├── utils/
│   ├── seguranca.dart                 # Criptografia de senha com SHA-256
│   └── seed.dart                      # Criação de usuário padrão ao iniciar
│
└── widgets/
    └── formulario_usuario.dart
```

## 🧠 Conceitos Aplicados
✅ Separação de responsabilidades
✅ Persistência local com SQLite
✅ Lógica de negócio isolada (Service)
✅ Interface reativa com ChangeNotifier
✅ Estados de carregamento e erro
✅ SnackBar para feedback de erros

# Clone o repositório
git clone https://github.com/seu-usuario/flutter-sqlite-modular.git

# Navegue até a pasta
cd flutter-sqlite-modular

# Instale as dependências
flutter pub get

# Execute o app
flutter run


## 🧩 Extensões Futuras
🔒 Login com autenticação local

🎯 Testes unitários e de integração

📁 Suporte a múltiplas entidades (produtos, pedidos, etc.)
