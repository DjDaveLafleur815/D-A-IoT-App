class Endpoints {
  // Adapte selon ta machine/émulateur
  static const String apiBase = String.fromEnvironment(
    'API_BASE',
    defaultValue: 'http://localhost:8000',
  );

  static String get ws => apiBase.replaceFirst('http', 'ws');

  static String get login => '$apiBase/users/login'; // dev mode
  static String get register => '$apiBase/users/register'; // dev mode
  static String get me => '$apiBase/users/me';

  static String get rooms => '$apiBase/rooms';
  static String get devices => '$apiBase/devices';
  static String get sensors => '$apiBase/sensors';
  static String get sensorValue => '$apiBase/sensors/value';

  static String get socket => '$ws/ws';
}
