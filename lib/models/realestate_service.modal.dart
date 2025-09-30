class RealEstateServiceModel {
  int id;
  int providerId;
  String propertyType;
  String? type;
  String title;
  String location;
  int areaSqfeet;
  double monthlyRent;
  double securityDeposit;
  String description;
  String? date;
  List<String> images;
  String? ownerName;
  String? ownerEmail;
  String? ownerPhone;
  String? furnishing_type;


  RealEstateServiceModel({
    required this.id,
    required this.providerId,
    this.type,
    required this.propertyType,
    required this.title,
    required this.location,
    required this.areaSqfeet,
    required this.monthlyRent,
    required this.securityDeposit,
    required this.description,
    this.date,
    required this.images,
    required this.ownerName,
    required this.ownerEmail,
    required this.ownerPhone,
    required this.furnishing_type,
  });

  factory RealEstateServiceModel.fromJson(Map<String, dynamic> json) {
    return RealEstateServiceModel(
      id: json['id'],
      providerId: json['provider_id'],
      propertyType: json['property_type'] ?? '',
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      location: json['location'] ?? '',
      areaSqfeet: json['area_sqfeet'] ?? 0,
      monthlyRent: double.tryParse(json['monthly_rent'].toString()) ?? 0.0,
      securityDeposit:
          double.tryParse(json['security_deposit'].toString()) ?? 0.0,
      description: json['description'] ?? '',
      furnishing_type: json['furnishing_type'] ?? '',
      date: json['date'],
      images: json['images'] is List
          ? List<String>.from(json['images'])
          : (json['images'] != null ? [json['images'].toString()] : []),
          ownerName: json['owner_name'],
          ownerEmail: json['owner_email'],
          ownerPhone: json['owner_phn'],
    );
  }
}
