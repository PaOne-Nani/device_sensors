class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

class CacheException implements Exception {
  final String message;
  CacheException(this.message);
}

class DeviceException implements Exception {
  final String message;
  DeviceException(this.message);
} 