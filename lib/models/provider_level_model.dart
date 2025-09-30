class ProviderLevelModel {
  final int id;
  final String name; // plan_name
  final double price;
  final String duration;
  final String tag;
  final List<String> subscriptionPoints;
  final int tax;
  final double taxAmount;
  final double totalAmount;

  ProviderLevelModel({
    required this.id,
    required this.name,
    required this.price,
    required this.duration,
    required this.tag,
    required this.subscriptionPoints,
    required this.tax,
    required this.taxAmount,
    required this.totalAmount,
  });

  factory ProviderLevelModel.fromJson(Map<String, dynamic> json) {
    return ProviderLevelModel(
      id: json['id'],
      name: json['plan_name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      duration: json['duration'] ?? '',
      tag: json['tag'] ?? '',
      subscriptionPoints: (json['subscription_points'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      tax: json['tax'] ?? 0,
      taxAmount: (json['tax_amount'] ?? 0).toDouble(),
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
    );
  }
}
