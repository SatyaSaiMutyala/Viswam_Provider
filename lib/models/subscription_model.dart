class SubscriptionModel {
  final int id;
  final String planName;
  final double price;
  final String duration;
  final String tag;
  final double tax;
  final double taxAmount;
  final double totalAmount;
  final List<String> subscriptionPoints;

  SubscriptionModel({
    required this.id,
    required this.planName,
    required this.price,
    required this.duration,
    required this.tag,
    required this.subscriptionPoints,
    required this.tax,
    required this.taxAmount,
    required this.totalAmount,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id'] as int,
      planName: json['plan_name'] ?? '',
      price: (json['price'] as num).toDouble(),
      duration: json['duration'] ?? '',
      tag: json['tag'] ?? '',
      tax: (json['tax'] as num).toDouble(),
      taxAmount: (json['tax_amount'] as num).toDouble(),
      totalAmount: (json['total_amount'] as num).toDouble(),
      subscriptionPoints: List<String>.from(json['subscription_points'] ?? []),
    );
  }
}
