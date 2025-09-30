import 'dart:convert';

import 'package:handyman_provider_flutter/networks/network_utils.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> getSubscriptionStatus(String id) async {
  try {
    final response = await http.get(
      Uri.parse('${BASE_URL}is-subscribe/$id'),
      headers: buildHeaderTokens(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('API Error: ${response.statusCode} - ${response.body}');
      throw Exception('Server responded with status ${response.statusCode}');
    }
  } catch (e, stackTrace) {
    // Print the actual error and stack trace for debugging
    print('Subscription check failed: $e');
    print(stackTrace);

    // Optionally, return a default error object
    return {
      'status': false,
      'message': 'Unable to check subscription. Please try again.',
      'error': e.toString()
    };
  }
}

// api_service.dart
Future<Map<String, dynamic>> getData() async {
  try {
    final res = await http.get(Uri.parse('$BASE_URL/user-ref-id'), headers: buildHeaderTokens());
    if (res.statusCode == 200) {
      return jsonDecode(res.body); // returns {success:true, ref_id:"#18083"}
    } else {
      throw Exception('Server responded with status ${res.statusCode}');
    }
  } catch (e, s) {
    print('Error man ------> $e');
    print('Stack -------> $s');
    return {
      "success": false,
      "message": "Unable to fetch referral ID"
    };
  }
}




