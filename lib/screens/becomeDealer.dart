import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../components/app_widgets.dart';
import '../components/back_widget.dart';
import '../main.dart';
import '../provider/controllers/provider_level_controller.dart';
import '../utils/configs.dart';
import 'payment_details_screen.dart';
import 'provider_subscription_controller.dart';

class BecomeProviderLevel extends StatefulWidget {
  const BecomeProviderLevel({super.key});

  @override
  State<BecomeProviderLevel> createState() => _BecomeProviderLevelState();
}

class _BecomeProviderLevelState extends State<BecomeProviderLevel> {
  final ProviderLevelController controller = Get.put(ProviderLevelController());
  final subController = Get.put(ProviderSubscriptionController());
  String selectedLevel = 'Bronze';

  @override
  void initState() {
    super.initState();
    int id = appStore.userId;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      print('im touching ---------------');
      await subController.loadSubscription(id);
      await controller.fetchLevels();
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double padding = width * 0.05;
    double fontSize = width * 0.04;

    return Scaffold(
      appBar: appBarWidget(
        'Become a Dealer',
        textColor: white,
        color: context.primaryColor,
        backWidget: BackWidget(),
        showBack: true,
      ),
      body: Stack(
        children: [
          Obx(() {
            if (subController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            // ✅ User already has a subscription
            // print('yeah out of the if block');
            // if (subController.subscriptionData.value != null) {
            //   final data = subController.subscriptionData.value!;
            //   print('this is checking data ------> ${data.levelPlan.name} ');
            //   return Padding(
            //     padding: EdgeInsets.all(padding),
            //     child: Card(
            //       elevation: 4,
            //       child: Padding(
            //         padding: EdgeInsets.all(padding),
            //         child: Column(
            //           mainAxisSize: MainAxisSize.min,
            //           children: [
            //             Text("Current Plan: ${data.levelPlan.name}",
            //                 style: const TextStyle(
            //                     fontSize: 20, fontWeight: FontWeight.bold)),
            //             const SizedBox(height: 8),
            //             Text("Price: ₹${data.levelPlan.price}"),
            //             Text("Duration: ${data.levelPlan.duration}"),
            //             Text("Valid Till: ${data.levelUser.endDate}"),
            //           ],
            //         ),
            //       ),
            //     ),
            //   );
            // }

            print('yeah out of the if block');
            if (subController.subscriptionData.value != null) {
              final data = subController.subscriptionData.value!;
              print('this is checking data ------> ${data.levelPlan.name} ');

              return Padding(
                padding: EdgeInsets.all(padding),
                child: Card(
                  elevation: 8,
                  shadowColor: primaryColor.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: context.cardColor,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          context.cardColor,
                          context.cardColor.withOpacity(0.8),
                        ],
                      ),
                      border: Border.all(
                        color: primaryColor.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(padding * 1.2),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Section
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.workspace_premium,
                                  color: primaryColor,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Current Plan",
                                      style: secondaryTextStyle(size: 12),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      data.levelPlan.name,
                                      style: boldTextStyle(size: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Divider
                          Container(
                            height: 1,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  primaryColor.withOpacity(0.1),
                                  primaryColor.withOpacity(0.3),
                                  primaryColor.withOpacity(0.1),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Details Section
                          Column(
                            children: [
                              _buildDetailRow(
                                icon: Icons.currency_rupee,
                                label: "Price",
                                value: "₹${data.levelPlan.price}",
                                primaryColor: primaryColor,
                              ),
                              const SizedBox(height: 8),
                              _buildDetailRow(
                                icon: Icons.schedule,
                                label: "Duration",
                                value: data.levelPlan.duration,
                                primaryColor: primaryColor,
                              ),
                              const SizedBox(height: 8),
                              _buildDetailRow(
                                icon: Icons.calendar_today,
                                label: "Valid Till",
                                value: data.levelUser.endDate,
                                primaryColor: primaryColor,
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Status Indicator
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: primaryColor.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "Active Subscription",
                                  style: boldTextStyle(size: 12).copyWith(
                                    color: primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }

            print('issue with if condition bro ----------');

            if (controller.isLoading.value) {
              return LoaderWidget().center();
            }

            if (controller.levels.isEmpty) {
              return Center(child: Text("No Dealer levels found"));
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Text("Select The Perfect Dealer Level",
                            style: TextStyle(
                                fontSize: fontSize - 2,
                                color: Colors.grey[600])),
                        SizedBox(height: padding),
                      ],
                    ),
                  ),
                  ...controller.levels.map((level) {
                    bool isSelected = selectedLevel == level.name;
                    return Column(
                      children: [
                        PlanCard(
                          id: level.id,
                          title: level.name.capitalizeFirstLetter(),
                          price:
                              '₹${NumberFormat('#,##,###').format(level.price)}',
                          gst: level.tax,
                          taxAmount: level.taxAmount,
                          totalAmount: level.totalAmount,
                          yearly: '',
                          duration: "${level.duration} days",
                          features: level.subscriptionPoints,
                          tagLine: level.tag,
                          selected: isSelected,
                          isPopular: level.name.toLowerCase() == 'silver',
                          buttonText: isSelected
                              ? "Selected ${level.name.capitalizeFirstLetter()}"
                              : "Select ${level.name.capitalizeFirstLetter()}",
                          onTap: () {
                            setState(() {
                              selectedLevel = level.name;
                            });
                          },
                        ),
                        SizedBox(height: padding),
                      ],
                    );
                  }).toList(),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// Helper widget for detail rows
Widget _buildDetailRow({
  required IconData icon,
  required String label,
  required String value,
  required Color primaryColor,
}) {
  return Row(
    children: [
      Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 16,
          color: primaryColor,
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: secondaryTextStyle(size: 12),
            ),
            Text(
              value,
              style: boldTextStyle(size: 12),
            ),
          ],
        ),
      ),
    ],
  );
}

class PlanCard extends StatelessWidget {
  final int id;
  final String title;
  final String price;
  final int gst;
  final double taxAmount;
  final double totalAmount;
  final String yearly;
  final String duration;
  final List<String> features;
  final bool selected;
  final bool isPopular;
  final String tagLine;
  final String buttonText;
  final VoidCallback onTap;

  const PlanCard({
    required this.id,
    required this.title,
    required this.price,
    required this.gst,
    required this.taxAmount,
    required this.totalAmount,
    required this.yearly,
    required this.duration,
    required this.features,
    required this.selected,
    this.isPopular = false,
    required this.tagLine,
    required this.buttonText,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double padding = width * 0.05;
    double fontSize = width * 0.04;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: selected ? primaryColor : Colors.transparent,
                width: selected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  spreadRadius: 1,
                )
              ],
            ),
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: fontSize + 2, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(
                  tagLine,
                  style: TextStyle(
                      color: Colors.grey[600], fontSize: fontSize - 2),
                ),
                SizedBox(height: 8),
                Text('$price / $duration',
                    style: TextStyle(
                        color: Colors.orange[800],
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 12),
                ...features.map((f) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle,
                              color: Colors.green, size: fontSize),
                          SizedBox(width: 8),
                          Expanded(
                              child: Text(f,
                                  style: TextStyle(fontSize: fontSize - 1))),
                        ],
                      ),
                    )),
                SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selected ? primaryColor : Colors.grey,
                    minimumSize: Size(double.infinity, width * 0.12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: selected
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentDetailsScreen(
                                id: id,
                                price: price,
                                planName: title,
                                duration: duration,
                                gst: gst,
                                taxAmount: taxAmount,
                                totalAmount: totalAmount,
                                dealer: true,
                              ),
                            ),
                          );
                        }
                      : null,
                  child: Text(buttonText,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: fontSize - 1)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
