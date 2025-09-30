import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/provider_subscription_model.dart';
import '../networks/network_utils.dart';
import '../utils/configs.dart';      
import 'provider_subscription_model.dart'; // buildHeaderTokens()

class ProviderSubscriptionController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<LevelSubscriptionData?> subscriptionData = Rx<LevelSubscriptionData?>(null);
  RxString errorMessage = ''.obs;

  /// Fetch subscription by user id
  Future<void> loadSubscription(int userId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      print('yeah im in loadSubscription ------');
      final response = await http.get(
        Uri.parse('${BASE_URL}level/transactions/$userId'),
        headers: buildHeaderTokens(),
      );

      if (response.statusCode == 200) {
      print('yeah im pass with 200 status code ------');
        final Map<String, dynamic> jsonResp = jsonDecode(response.body);
        print('data ----------> ${jsonResp['data']}');
        if (jsonResp['success'] == true && jsonResp['data'] != null) {
          subscriptionData.value =
              LevelSubscriptionData.fromJson(jsonResp['data']);
        } else {
          subscriptionData.value = null;
          errorMessage.value = jsonResp['message'] ?? 'No active subscription';
        }
      } else if (response.statusCode == 404) {
        // No subscription found
        subscriptionData.value = null;
        errorMessage.value = 'No active subscription';
      } else {
        subscriptionData.value = null;
        errorMessage.value =
            'Error: ${response.statusCode} ${response.reasonPhrase}';
      }
    } catch (e) {
      subscriptionData.value = null;
      errorMessage.value = 'Failed to fetch subscription: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
