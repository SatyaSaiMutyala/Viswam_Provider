import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

import '../components/back_widget.dart';
import '../utils/configs.dart';

class PaymentDetailsScreen extends StatelessWidget {
  const PaymentDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double padding = width * 0.05;
    double fontSize = width * 0.04;
    double titleSize = width * 0.045;

    return Scaffold(
      appBar: appBarWidget(
        'Payment Details',
        textColor: white,
        color: primaryColor,
        showBack: true,
        backWidget: BackWidget(),
      ),
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(padding),
              decoration: BoxDecoration(
                color: Color(0xFFFDF8ED),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Order Summary',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: titleSize)),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Gold Plan ( Monthly )',
                          style: TextStyle(fontSize: fontSize)),
                      Text('₹999',
                          style: TextStyle(
                              fontSize: fontSize,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('GST ( 15 % )', style: TextStyle(fontSize: fontSize)),
                      Text('₹179',
                          style: TextStyle(
                              fontSize: fontSize,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                  Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Amount',
                          style: TextStyle(
                              fontSize: fontSize,
                              fontWeight: FontWeight.bold)),
                      Text('₹1,178',
                          style: TextStyle(
                              fontSize: fontSize + 1,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: padding),
            // Text('Payments',
            //     style:
            //         TextStyle(fontSize: titleSize, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: width * 0.13,
              child: ElevatedButton(
                onPressed: () {
                  toast('Pay ₹1,178 tapped');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text('Pay ₹1,178',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentTabWidget extends StatefulWidget {
  final double fontSize;

  const PaymentTabWidget({super.key, required this.fontSize});

  @override
  State<PaymentTabWidget> createState() => _PaymentTabWidgetState();
}

class _PaymentTabWidgetState extends State<PaymentTabWidget> {
  int selectedTab = 0;

  final List<String> tabs = ['UPI', 'Cards', 'Net Banking'];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(width * 0.03),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(tabs.length, (index) {
              bool isSelected = selectedTab == index;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTab = index;
                    });
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: width * 0.03),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.amber : Colors.grey[200],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    alignment: Alignment.center,
                    child: Text(tabs[index],
                        style: TextStyle(
                            color:
                                isSelected ? Colors.white : Colors.black,
                            fontSize: widget.fontSize - 1,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: width * 0.04),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                upiAppIcon(Icons.account_balance_wallet, 'Google Pay'),
                upiAppIcon(Icons.account_balance, 'Phonepe'),
                upiAppIcon(Icons.payment, 'Paytm'),
              ],
            )
          ] 
      ),
    );
  }

  Widget upiAppIcon(IconData icon, String label) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        CircleAvatar(
          radius: width * 0.07,
          backgroundColor: Colors.grey[300],
          child: Icon(icon, size: width * 0.08, color: Colors.black),
        ),
        SizedBox(height: 6),
        Text(label,
            style:
                TextStyle(fontSize: widget.fontSize - 2, color: Colors.black)),
      ],
    );
  }
}
