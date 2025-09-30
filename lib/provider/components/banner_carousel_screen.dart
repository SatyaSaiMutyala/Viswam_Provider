import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../utils/configs.dart';
import '../controllers/banner_controller.dart';

class BannerCarouselSlider extends StatefulWidget {
  const BannerCarouselSlider({Key? key}) : super(key: key);

  @override
  State<BannerCarouselSlider> createState() => _BannerCarouselSliderState();
}

class _BannerCarouselSliderState extends State<BannerCarouselSlider> {
  final BannerController controller = Get.put(BannerController());
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    controller.fetchBanners();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: height * 0.24,
              autoPlay: true,
              enlargeCenterPage: true,
              //  viewportFraction: 1.0,  
              onPageChanged: (index, reason) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
            items: controller.bannerList.map((banner) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin:  EdgeInsets.symmetric(horizontal: width * 0.01 ),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        banner.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),

           SizedBox(height: height * 0.015),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: controller.bannerList.asMap().entries.map((entry) {
              bool isActive = currentIndex == entry.key;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: isActive ? 20.0 : 10.0,
                height: 10.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: isActive ? primaryColor : Colors.grey[400],
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.4),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
              );
            }).toList(),
          ),
        ],
      );
    });
  }
}
