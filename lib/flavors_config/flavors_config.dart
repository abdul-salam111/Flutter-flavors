enum Environment { dev, staging, prod }

abstract class AppEnvironment {
  static late String baseUrl;
  static late String environmentName;
  static late bool enableLogging;
  static late bool debugMode;

  static late Environment _environment;
  static Environment get environment => _environment;

  static void setEnvironment(Environment environment) {
    _environment = environment;
    switch (environment) {
      case Environment.dev:
        baseUrl = 'https://dev-api.example.com/api/';
        environmentName = '🔵 Development';
        enableLogging = true;
        debugMode = true;
        break;

      case Environment.staging:
        baseUrl = 'https://staging-api.example.com/api/';
        environmentName = '🟡 Staging';
        enableLogging = true;
        debugMode = false;
        break;

      case Environment.prod:
        baseUrl = 'https://api.example.com/api/';
        environmentName = '🟢 Production';
        enableLogging = false;
        debugMode = false;
        break;
    }
  }

  // Helper methods
  static bool get isDevelopment => _environment == Environment.dev;
  static bool get isStaging => _environment == Environment.staging;
  static bool get isProduction => _environment == Environment.prod;
}
