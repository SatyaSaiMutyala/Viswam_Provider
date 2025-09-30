import 'package:get/get.dart';
import 'package:handyman_provider_flutter/provider/controllers/provider_level_service.dart';
import '../../models/provider_level_model.dart';

class ProviderLevelController extends GetxController {
  var levels = <ProviderLevelModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchLevels();
    super.onInit();
  }

  Future<void> fetchLevels() async {
    try {
      isLoading(true);
      final data = await ProviderLevelService.fetchLevels();
      print('contoller ----------> ${data}');
      levels.assignAll(data);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
