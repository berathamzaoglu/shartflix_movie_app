abstract class NetworkInfo {
  Future<bool> get isConnected;
}

// İmplementasyon daha sonra connectivity_plus package ile yapılacak
class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    // TODO: connectivity_plus package ile implement edilecek
    return true;
  }
} 