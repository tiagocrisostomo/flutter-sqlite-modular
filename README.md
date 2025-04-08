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
├── data/
│   ├── db/
│   │   └── banco_de_dados.dart        # Instância única do banco
│   ├── dao/
│   │   └── usuario_dao.dart           # CRUD direto com SQLite
│   └── model/
│       └── usuario.dart               # Modelo de dados
├── services/
│   └── usuario_service.dart           # Lógica de negócio sobre os dados
├── store/
│   └── usuario_store.dart             # Gerenciamento de estado (Provider)
├── screens/
│   └── home.dart                      # Interface do app
├── main.dart                          # Setup e Provider
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
