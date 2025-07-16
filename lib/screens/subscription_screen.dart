import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

import '../components/back_widget.dart';
import '../utils/configs.dart';
import 'payment_details_screen.dart';

class PlanSelectionScreen extends StatefulWidget {
  const PlanSelectionScreen({super.key});

  @override
  State<PlanSelectionScreen> createState() => _PlanSelectionScreenState();
}

class _PlanSelectionScreenState extends State<PlanSelectionScreen> {
  String selectedPlan = 'Gold'; 
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double padding = width * 0.05;
    double fontSize = width * 0.04;

    return Scaffold(
      appBar: appBarWidget(
        'Choose Your Plan',
        textColor: white,
        color: context.primaryColor,
        backWidget: BackWidget(),
        showBack: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Text("Select The Perfect Plan For Your Needs",
                      style: TextStyle(
                          fontSize: fontSize - 2, color: Colors.grey[600])),
                  SizedBox(height: padding),
                ],
              ),
            ),
            PlanCard(
              title: "Silver",
              price: "₹499/Mo",
              yearly: "₹4,999/Year",
              features: [
                "Up To 10 Property Listings",
                "Basic Support",
                "Standard Visibility"
              ],
              selected: selectedPlan == 'Silver',
              buttonText: selectedPlan == 'Silver'
                  ? "Selected Silver"
                  : "Select Silver",
              onTap: () {
                setState(() {
                  selectedPlan = 'Silver';
                });
              },
            ),
            SizedBox(height: padding),
            PlanCard(
              title: "Gold",
              price: "₹999/Mo",
              yearly: "₹4999/Year",
              features: [
                "Up To 50 Property Listings",
                "Priority Support",
                "Featured Listings",
                "Advanced Analytics"
              ],
              selected: selectedPlan == 'Gold',
              isPopular: true,
              buttonText:
                  selectedPlan == 'Gold' ? "Selected Gold" : "Select Gold",
              onTap: () {
                setState(() {
                  selectedPlan = 'Gold';
                });
              },
            ),
            SizedBox(height: padding),
            PlanCard(
              title: "Premium",
              price: "₹1,999/Mo",
              yearly: "₹5,999/Year",
              features: [
                "Unlimited Property Listings",
                "24/7 Premium Support",
                "Top Featured Listings",
                "Advanced Analytics & Reports",
                "Custom Branding"
              ],
              selected: selectedPlan == 'Premium',
              buttonText: selectedPlan == 'Premium'
                  ? "Selected Premium"
                  : "Select Premium",
              onTap: () {
                setState(() {
                  selectedPlan = 'Premium';
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final String yearly;
  final List<String> features;
  final bool selected;
  final bool isPopular;
  final String buttonText;
  final VoidCallback onTap;

  const PlanCard({
    required this.title,
    required this.price,
    required this.yearly,
    required this.features,
    required this.selected,
    this.isPopular = false,
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
                  title == "Silver"
                      ? "Basic Features For Starters"
                      : title == "Gold"
                          ? "Perfect Growing For Business"
                          : "For Professional Agents",
                  style: TextStyle(
                      color: Colors.grey[600], fontSize: fontSize - 2),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(price,
                        style: TextStyle(
                            color: Colors.orange[800],
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold)),
                    SizedBox(width: 10),
                    Text(yearly,
                        style: TextStyle(
                            color: Colors.orange[800],
                            fontSize: fontSize - 1,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
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
                  onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentDetailsScreen(),
                  ),
                );
                  },
                  child: Text(buttonText,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: fontSize - 1)),
                ),
              ],
            ),
          ),
          if (isPopular)
            Positioned(
              top: -12,
              left: 20,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text("Most Popular Plan",
                    style: TextStyle(
                        fontSize: fontSize - 3, fontWeight: FontWeight.bold)),
              ),
            ),
        ],
      ),
    );
  }
}
