class MetalType {
  final String name;
  final double pricePerGram;
  final double purity; // in Karat (e.g., 24K, 22K, 18K)

  MetalType({
    required this.name,
    required this.pricePerGram,
    required this.purity,
  });
}
