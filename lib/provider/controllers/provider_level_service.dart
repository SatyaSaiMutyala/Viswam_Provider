import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:handyman_provider_flutter/networks/network_utils.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';

import '../../models/provider_level_model.dart';

class ProviderLevelService {
  static const String baseUrl = '${BASE_URL}provider-levels';

  static Future<List<ProviderLevelModel>> fetchLevels() async {
    final response = await http.get(Uri.parse(baseUrl), headers: buildHeaderTokens());

    if (response.statusCode == 200) {
      print('im in service function file -------------');
      final jsonData = json.decode(response.body);
      print('response --------> $jsonData');

      if (jsonData is Map && jsonData['subscriptions'] is List) {
        return (jsonData['subscriptions'] as List)
            .map((e) => ProviderLevelModel.fromJson(e))
            .toList();
      } else {
        throw Exception('Invalid response format: subscriptions not found');
      }
    } else {
      throw Exception('Failed to fetch provider levels');
    }
  }
}
