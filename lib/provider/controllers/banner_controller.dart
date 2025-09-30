import 'package:get/get.dart';
import '../../models/banner_model.dart';
import '../services/banner_service.dart';

class BannerController extends GetxController {
  RxList<BannerModel> bannerList = <BannerModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    fetchBanners();
    super.onInit();
  }

  void fetchBanners() async {
    print('yeah its hitting man ------');
    try {
      isLoading(true);
    print('yeah Its fetch baanner controller -------------------------------------');
      final banners = await BannerService.fetchBannersSlider();
      bannerList.assignAll(banners);
      print('yeah its coming --------------- ${banners}');
    } catch (e) {
      Get.snackbar('Error', e.toString());
      print('Error of Banner images --------->$e');
    } finally {
      isLoading(false);
    }
  }
}
