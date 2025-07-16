class SubscriptionModel {
  final int id;
  final String planName;
  final int price;
  final String duration;
  final String tag;
  final List<String> subscriptionPoints;

  SubscriptionModel({
    required this.id,
    required this.planName,
    required this.price,
    required this.duration,
    required this.tag,
    required this.subscriptionPoints,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id'],
      planName: json['plan_name'],
      price: json['price'],
      duration: json['duration'],
      tag: json['tag'],
      subscriptionPoints: List<String>.from(json['subscription_points']),
    );
  }
}
