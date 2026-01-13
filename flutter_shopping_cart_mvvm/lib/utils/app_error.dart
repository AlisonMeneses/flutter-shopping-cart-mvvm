enum AppErrorType {
  local,      // SharedPreferences, SQLite, arquivos locais
  network,    // Sem internet, timeout, DNS
  server,     // 500, 404, API down
  validation, // Dados inválidos
  auth,       // Token expirado, não autorizado
  requisitionLimit, // Limite de requisição
  unknown,    // Erro não categorizado
}

class AppError {
  final String message;
  final AppErrorType type;

  AppError({
    required this.message,
    required this.type,
  });
}