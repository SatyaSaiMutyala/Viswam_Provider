import 'dart:convert';
import 'package:handyman_provider_flutter/networks/network_utils.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:http/http.dart' as http;

import '../../models/banner_model.dart';

class BannerService {
  static Future<List<BannerModel>> fetchBannersSlider() async {
    print('yeah it is banner servuce file -----------------');
    final response = await http.get(
      Uri.parse('${BASE_URL}promotionalbannersinfo'),headers: buildHeaderTokens()
    );
  
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body)['banners'];
      print('this is status ------------->, ${response.statusCode}');
      return data.map((e) => BannerModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load banners');
    }
  }
}
