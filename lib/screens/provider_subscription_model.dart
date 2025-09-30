class LevelSubscriptionResponse {
  final bool success;
  final String message;
  final LevelSubscriptionData? data;

  LevelSubscriptionResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory LevelSubscriptionResponse.fromJson(Map<String, dynamic> json) {
    return LevelSubscriptionResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? LevelSubscriptionData.fromJson(json['data'])
          : null,
    );
  }
}

class LevelSubscriptionData {
  final LevelUser levelUser;
  final LevelPlan levelPlan;

  LevelSubscriptionData({
    required this.levelUser,
    required this.levelPlan,
  });

  factory LevelSubscriptionData.fromJson(Map<String, dynamic> json) {
    return LevelSubscriptionData(
      levelUser: LevelUser.fromJson(json['level_user']),
      levelPlan: LevelPlan.fromJson(json['level_plan']),
    );
  }
}

class LevelUser {
  final int id;
  final int levelId;
  final int userId;
  final String transactionId;
  final String startDate;
  final String endDate;
  final String paymentStatus;
  final double totalAmount;
  final double gstAmount;

  LevelUser({
    required this.id,
    required this.levelId,
    required this.userId,
    required this.transactionId,
    required this.startDate,
    required this.endDate,
    required this.paymentStatus,
    required this.totalAmount,
    required this.gstAmount,
  });

  factory LevelUser.fromJson(Map<String, dynamic> json) {
    return LevelUser(
      id: json['id'],
      levelId: json['level_id'],
      userId: json['user_id'],
      transactionId: json['transaction_id'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      paymentStatus: json['payment_status'],
      totalAmount: double.tryParse(json['total_amount'].toString()) ?? 0,
      gstAmount: double.tryParse(json['gst_amount'].toString()) ?? 0,
    );
  }
}

class LevelPlan {
  final int id;
  final String name;
  final String price;
  final String duration;

  LevelPlan({
    required this.id,
    required this.name,
    required this.price,
    required this.duration,
  });

  factory LevelPlan.fromJson(Map<String, dynamic> json) {
    final provider = json['provider_level'] ?? {};
    return LevelPlan(
      id: json['id'],
      name: provider['name'] ?? '',
      price: provider['price']?.toString() ?? '',
      duration: provider['duration'] ?? '',
    );
  }
}

