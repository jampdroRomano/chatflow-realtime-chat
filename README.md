# 💬 ChatFlow - Realtime Messenger

![Status](https://img.shields.io/badge/status-%20Concluido-gree)
![Mobile](https://img.shields.io/badge/tecnologia-Flutter-blue)
![Backend](https://img.shields.io/badge/backend-Firebase_Realtime_Database-yellow)
![Architecture](https://img.shields.io/badge/arquitetura-MVVM-purple)

---

## 📖 Descrição do Projeto
**ChatFlow** é uma aplicação móvel desenvolvida em **Flutter** para comunicação em tempo real. O projeto implementa uma arquitetura **MVVM (Model-View-ViewModel)** robusta e utiliza o ecossistema **Firebase** para fornecer autenticação segura e sincronização de dados instantânea. O aplicativo suporta recursos modernos de chat como reações, indicadores de digitação, respostas a mensagens específicas e monitoramento de usuários online.

---

## 🗂 Estrutura do Repositório
```text
chatflow-realtime-chat/
│
├─── assets/                  # Imagens e ícones (Logo, Splash)
│
├─── lib/
│    ├─── core/               # Núcleo da aplicação
│    │    ├─── constants/     # Constantes globais (ex: Reações)
│    │    ├─── services/      # Serviços de Autenticação e Chat (Firebase)
│    │    ├─── theme/         # Definições de tema e estilização
│    │    └─── utils/         # Validadores e transformadores de UI
│    │
│    ├─── models/             # Modelos de dados (MessageModel, User, etc.)
│    │
│    ├─── viewmodels/         # Gerenciamento de estado (Provider)
│    │    └─── helpers/       # Gerenciadores de lógica (Typing, Selection)
│    │
│    ├─── views/              # Camada de apresentação
│    │    ├─── screens/       # Telas principais (Auth, Chat, Splash)
│    │    └─── widgets/       # Componentes reutilizáveis
│    │         ├─── auth/     # Widgets de autenticação
│    │         ├─── chat/     # Bolhas de mensagem, inputs, reações
│    │         └─── common/   # Diálogos e campos de texto genéricos
│    │
│    ├─── firebase_options.dart # Configuração gerada do Firebase
│    └─── main.dart           # Ponto de entrada da aplicação
│
└─── pubspec.yaml             # Dependências e configuração de assets
```

| ID    | Funcionalidade           | Descrição                                                   |
|-------|--------------------------|-------------------------------------------------------------|
| RF01  | Autenticação Segura      | Sistema de Login e Registro gerenciado pelo Firebase Auth, com tratamento de erros amigável e validação de campos. |
| RF02  | Chat em Tempo Real       | Troca de mensagens instantânea utilizando Firebase Realtime Database, com atualização automática da interface. |
| RF03  | Reações a Mensagens      | Interface interativa para reagir a mensagens com emojis, persistindo as reações para todos os usuários. |
| RF04  | Respostas (Reply)        | Funcionalidade de responder a uma mensagem específica, criando um contexto de conversa mais organizado. |
| RF05  | Presença e Status        | Monitoramento de usuários online em tempo real e indicadores visuais de "Digitando..." para melhorar a UX. |
| RF06  | Gestão de Mensagens      | Capacidade de deletar mensagens enviadas (soft delete) com feedback visual na interface. |

## 🛠 Tecnologias Utilizadas
- **Core:** Flutter (Dart), SDK `^3.10.4`
- **Gerenciamento de Estado:** Provider
- **Backend & Database:** Firebase Realtime Database
- **Autenticação:** Firebase Auth
- **UI/Assets:** Google Fonts, Cupertino Icons, Flutter Native Splash
- **Linting:** Flutter Lints

---

## 🔥 Configuração do Firebase

O projeto utiliza o pacote `flutterfire_cli` para configuração. As credenciais específicas para já estão configuradas no arquivo `lib/firebase_options.dart`.

> **Nota de Segurança:** O arquivo `google-services.json` (Android) e `GoogleService-Info.plist` (iOS) foram **commitados intencionalmente** neste repositório. O objetivo é facilitar a execução e evitar a configuração de um projeto Firebase próprio.
>
> Em um cenário real de produção, estes arquivos seriam ignorados pelo `.gitignore` e injetados via variáveis de ambiente ou segredos de CI/CD, seguindo as boas práticas de segurança.

---

## ⚠️ Pré-requisitos
-   Flutter SDK Instalado
-   Dart SDK
-   Emulador Android ou Dispositivo Android Físico configurado e ligado a maquina com modo desenvolvedor e depuração ativadados

---

## 🚀 Instalação de Dependências
Na raiz do projeto, execute o comando para baixar todas as dependências listadas no `pubspec.yaml`:



```
flutter pub get
```

## 💻 Como Rodar o Projeto
1.  Garanta que um emulador esteja rodando ou um dispositivo esteja conectado.
2.  Execute o comando abaixo para iniciar o aplicativo:

```
flutter run
```
- Caso queira gerar o APK para instalação manual:

```
flutter build apk
```

**Dica**: Se encontrar problemas de cache ou build, tente limpar o projeto antes de rodar:

```
flutter clean
flutter pub get
```