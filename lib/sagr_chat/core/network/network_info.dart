abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    // In a real app, you'd check internet connectivity
    // For now, we'll assume connected
    return true;
  }
}