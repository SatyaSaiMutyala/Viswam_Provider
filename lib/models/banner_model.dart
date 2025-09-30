class BannerModel {
  int id;
  String serviceName;
  String imageUrl;
  String createdAt;

  BannerModel({
    required this.id,
    required this.serviceName,
    required this.imageUrl,
    required this.createdAt,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'],
      serviceName: json['service_name'] ?? '',
      imageUrl: json['image_url'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}
