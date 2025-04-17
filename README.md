# 📱 Flutter SQLite Modular App

Este projeto é um exemplo de aplicação Flutter modular, utilizando `SQLite` para persistência local e `Provider` com `ChangeNotifier` para gerenciamento de estado.

---

## 🚀 Tecnologias Utilizadas

## [![flutter version](https://img.shields.io/badge/flutter%20%20-blue?style=for-the-badge&logo=flutter)](https://flutter.dev/) [![sqllite version](https://img.shields.io/badge/sqlite%20%20-darkblue?style=for-the-badge&logo=Sqlite)](https://sqlite.org/)

- **Flutter**
- **SQLite** com `sqflite`
- **Provider** (`ChangeNotifier`)
- Estrutura modular (camadas: `Model`, `DAO`, `Service`, `Store`, `UI`)

---

## 📂 Estrutura de Pastas

```bash
flutter-sqlite-modular/
├── screenshots/
│   ├── login.png
│   ├── painel.png
│   ├── categorias.png
│   ├── tipos.png
│   ├── lancamentos.png
│   └── usuarios.dart
│
lib/
│
├── main.dart
│
├── data/
│   ├── db/
│   │   └── banco_de_dados.dart        # Instância do SQLite
│   │
│   ├── dao/
│   │   └── finan_categoria_dao.dart   # CRUD da entidade Financeiro Categoria
│   │   └── finan_tipo_dao.dart        # CRUD da entidade Financeiro Tipo
│   │   └── finan_lancamento_dao.dart  # CRUD da entidade Financeiro Lançamento
│   │   └── usuario_dao.dart           # CRUD da entidade Usuário
│   │
│   ├── model/
│   │   └── finan_categoria.dart       # Classe Financeiro Categoria 
│   │   └── finan_tipo.dart            # Classe Financeiro Tipo
│   │   └── finan_lancamento.dart      # Classe Financeiro Lançamento
│   │   └── usuario.dart               # Classe Usuário
│   │           
│   └── service/
│       ├── finan_categoria_service.dart    # Service da entidade Financeiro Categoria
│       ├── finan_tipo_service.dart         # Service da entidade Financeiro Tipo
│       ├── finan_lancamento_service.dart   # Service da entidade Financeiro lançamento
│       ├── usuario_service.dart            # Service da entidade Usuário
│       └── auth_service.dart               # 🔐 Service responsável pela autenticação
│
├── store/
│   ├── finan_categoria_service.dart        # Store da lista categorias
│   ├── finan_tipo_service.dart             # Store da lista tipos
│   ├── finan_lancamento_service.dart       # Store da lista lançamentos
│   ├── usuario_store.dart                  # Store da lista de usuários
│   └── auth_store.dart                     # Store que lida com login/logout
│
├── screens/
│   ├── home.dart                           # Tela principal
│   ├── finan_categoria_screen.dart         # Tela de categorias
│   ├── finan_tipo_screen.dart              # Tela de tipos
│   ├── finan_lancamento_screen.dart        # Tela de lancçamentos
│   ├── configuracao_screen.dart            # Tela de configuração
│   ├── login_screen.dart                   # Tela de login
│   └── usuario_screen.dart                 # Tela de usuários
│
├── utils/
│   ├── seguranca.dart                 # Criptografia de senha com SHA-256
│   └── seed.dart                      # Criação de usuário padrão ao iniciar
│
├── widgets/
│   ├── finan_categoria_form.dart      # Formulário de cadastro de categorias
│   ├── finan_tipo_form.dart           # Formulário de cadastro de tipos
│   ├── finan_lancamento_form.dart     # Formulário de cadastro de lançamentos
│   ├── finan_painel.dart              # Tela Painel Financeiro
│   └── usuario_form.dart              # Formulário de cadastro de usuários
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
📁 Suporte a múltiplas entidades (produtos, pedidos, etc.)

## 📸 Capturas de Tela

### 🔐 Tela de Login
![Tela de Login](screenshots/login.png)

### 🏠 Tela Home/Painel
![Tela Home](screenshots/home.png)

### 🗂️ Cadastros
#### Categorias
![Cadastro Categoria](screenshots/cadastro_categoria.png)
#### Tipos
![Cadastro Tipo](screenshots/cadastro_tipo.png)
#### Usuários
![Cadastro Usuário](screenshots/cadastro_usuario.png)
#### Lançamentos
![Cadastro Lançamento](screenshots/cadastro_lancamento.png)
