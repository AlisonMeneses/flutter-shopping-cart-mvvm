# Flutter Shopping Cart

Um projeto de exemplo de carrinho de compras em Flutter para demonstrar uma arquitetura modular e escalável.

## Requisitos

- **Flutter SDK**: `3.38.6` (ou compatível)
- **Dart SDK**: `^3.10.7`

## Começando

1.  **Clone o repositório:**
    ```bash
    git clone https://github.com/AlisonMeneses/flutter-shopping-cart-mvvm.git
    cd flutter_shopping_cart_mvvm
    ```

2.  **Instale as dependências:**
    ```bash
    flutter pub get
    ```

## Executando a Aplicação

Para executar a aplicação em modo de depuração, use o seguinte comando:

```bash
flutter run
```

## Estrutura do Projeto

O projeto segue uma arquitetura modular, separando as responsabilidades em camadas bem definidas para promover a reutilização e a manutenibilidade.

```
lib/
  config/
    app_module.dart       # Providers dos módulos das features
    app_theme.dart        # Tema global
  routing/
    app_router.dart       # Rotas globais
    routes.dart           # Constantes de rotas
  data/                   # Camadas de dados globais
    services/             # Interfaces e implementações de serviços
    repositories/         # Implementações de repositórios
  domain/                 # Camadas de domínio globais
    models/               # Modelos de dados
    repositories/         # Interfaces de repositórios
  utils/                  # Utilitários, extensões, formatadores
  ui/
    <feature>/
        screen              # Widgets e página da feature
        viewmodels          # ViewModel da feature
    widgets             # Widgets reutilizáveis
  main.dart                 # Ponto de entrada
```

## Arquitetura e Conceitos

### 1. Injeção de Dependência (Provider)

-   Utilizado o `provider` para injeção de dependência.
-   As dependências são registradas no `config/app_module.dart`.
-   A injeção de dependências é feita via **construtor**.

### 2. Gerenciamento de Estado (Command Pattern)

-   O estado das telas é gerenciado por ViewModels.
-   Ações assíncronas (chamadas de API, acesso a banco de dados) são encapsuladas usando o padrão **Command**. A classe `Command` (localizada em `lib/utils/command.dart`) gerencia os estados de execução (`isExecuting`, `hasData`, `hasError`).
-   A UI reage a essas mudanças de estado de forma declarativa usando `ValueListenableBuilder`.

### 3. Tratamento de Sucesso/Erro (Result)

-   Retornos de operações de I/O (Input/Output) ou regras de negócio utilizam a classe `Result` (localizada em `lib/utils/result.dart`).
-   `Result` é uma classe selada que pode representar `Success(data)` ou `Failure(error)`, garantindo um tratamento de erros mais seguro e explícito.

### 4. Roteamento

-   A navegação é centralizada no `routing/app_router.dart`.
-   As rotas são definidas como constantes em `routing/routes.dart`.

### 5. Camadas de Domínio e Dados

-   **Domain**: Contém as abstrações (interfaces) dos repositórios, além das entidades da aplicação. Esta camada não depende de nenhuma outra.
-   **Data**: Contém as implementações concretas das interfaces definidas no domínio, como repositórios que consomem APIs (`Dio`) ou serviços de banco de dados.

### 6. Convenções de Nomenclatura

-   **Interfaces**: Nomes diretos, com prefixo `I` (ex: `IProductRepository`).
-   **Implementações**: Sufixo `Impl` (ex: `ProductRepositoryImpl`).
-   **Arquivos**: `snake_case` (ex: `product_repository.dart`).

## Principais Dependências

-   `flutter`: SDK de desenvolvimento de UI.
-   `provider`: Para injeção de dependência.
-   `dio`: Cliente HTTP para chamadas de API.
