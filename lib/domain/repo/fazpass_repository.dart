
abstract interface class FazpassRepository {
  Future<void> initialize(List sensitiveData);
  Future<String> generateMeta();
}