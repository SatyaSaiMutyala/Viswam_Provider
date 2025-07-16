import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import '../models/realestate_service.modal.dart';
import '../networks/network_utils.dart';
import '../utils/configs.dart';
import 'real_estate/add_services.dart';

class RealEstate extends StatefulWidget {
  const RealEstate({super.key});

  @override
  State<RealEstate> createState() => _RealEstateState();
}

class _RealEstateState extends State<RealEstate> {
  List<RealEstateServiceModel> realEstates = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchRealEstates();
  }

  Future<void> fetchRealEstates() async {
    isLoading = true;
    setState(() {});

    try {
      final response = await http.get(
        Uri.parse('${BASE_URL}get-realstate-all/${appStore.userId}'),
        headers: buildHeaderTokens(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'] as List;
        realEstates =
            data.map((e) => RealEstateServiceModel.fromJson(e)).toList();
      } else {
        toast('Failed to load data');
      }
    } catch (e) {
      toast('Error: $e');
      print('Error man ----------->, ${e}');
    } finally {
      isLoading = false;
      setState(() {});
    }
  }

  Widget buildCard(RealEstateServiceModel model, double width, double height) {
    PageController _pageController = PageController();
    int _currentPage = 0;

    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          margin: EdgeInsets.all(12),
          width: width * 0.9,
          decoration: BoxDecoration(
            // color: Colors.white,
            color: context.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                    child: model.images.isNotEmpty
                        ? (model.images.length == 1
                            ? Image.network(
                                model.images.first,
                                width: double.infinity,
                                height: height * 0.2,
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                              )
                            : Column(
                                children: [
                                  SizedBox(
                                    height: height * 0.2,
                                    child: PageView.builder(
                                      controller: _pageController,
                                      itemCount: model.images.length,
                                      onPageChanged: (index) {
                                        _currentPage = index;
                                        setState(() {});
                                      },
                                      itemBuilder: (context, index) {
                                        return Image.network(
                                          model.images[index],
                                          width: double.infinity,
                                          height: height * 0.2,
                                          fit: BoxFit.cover,
                                          alignment: Alignment.center,
                                        );
                                      },
                                    ),
                                  ),
                                  6.height,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                      model.images.length,
                                      (index) => Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 3),
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: _currentPage == index
                                              ? primaryColor
                                              : Colors.grey.shade400,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ))
                        : Container(
                            height: height * 0.2,
                            width: double.infinity,
                            color: Colors.grey.shade300,
                            child: Icon(Icons.image, size: 40),
                          ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Rent',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.share,
                          size: 20,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(model.title, style: boldTextStyle(size: 18)),
                    4.height,
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.grey, size: 18),
                        4.width,
                        Text(model.location, style: secondaryTextStyle()),
                      ],
                    ),
                    8.height,
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: radius(),
                      ),
                      child: Center(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 16,
                          runSpacing: 8,
                          children: [
                            Text('${model.areaSqfeet} Sqft',
                                style: primaryTextStyle(
                                    color: white,
                                    size: (width * 0.025).toInt())),
                            Text('${model.propertyType}',
                                style: primaryTextStyle(
                                    color: white,
                                    size: (width * 0.025).toInt())),
                            Text('${model.furnishing_type}',
                                style: primaryTextStyle(
                                    color: white,
                                    size: (width * 0.025).toInt())),
                            Text(
                                'Deposit ₹${(double.tryParse(model.securityDeposit.toString()) ?? 0).toStringAsFixed(2)}',
                                style: primaryTextStyle(
                                    color: white,
                                    size: (width * 0.025).toInt())),
                          ],
                        ),
                      ),
                    ),
                    10.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '₹${model.monthlyRent}/month',
                          style: TextStyle(
                            fontSize: width * 0.035,
                            fontWeight: FontWeight.bold,
                            color: textPrimaryColorGlobal,
                          ),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AddRealEstateServices(
                                              serviceId: model.id),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: boxDecorationWithRoundedCorners(
                                    backgroundColor: primaryColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Text('Edit',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: width * 0.03)),
                                      SizedBox(width: 6),
                                      Icon(
                                        Icons.edit_outlined,
                                        size: width * 0.05,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ).paddingAll(8),
                                )),
                            SizedBox(width: width * 0.02),
                            GestureDetector(
                                onTap: () {
                                  showDeleteConfirmationDialog(context,
                                      id: model.id!);
                                },
                                child: Container(
                                  decoration: boxDecorationWithRoundedCorners(
                                    backgroundColor: Colors.redAccent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Text('Delete',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: width * 0.03)),
                                      SizedBox(width: 6),
                                      Icon(
                                        Icons.delete_outline,
                                        size: width * 0.05,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ).paddingAll(8),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> deleteRealEstate(int id) async {
    appStore.setLoading(true);
    setState(() {});
    try {
      final response = await http.delete(
        Uri.parse('${BASE_URL}delete-realestate/$id'),
        headers: buildHeaderTokens(),
      );

      if (response.statusCode == 200) {
        toast('Deleted successfully');
        await fetchRealEstates();
      } else {
        toast('Failed to delete');
      }
    } catch (e) {
      toast('Error: $e');
      print('Delete error -----------> $e');
    } finally {
      appStore.setLoading(false);
      setState(() {});
    }
  }

  void showDeleteConfirmationDialog(BuildContext context, {required int id}) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Container(
                margin: EdgeInsets.only(top: width * 0.15),
                padding: EdgeInsets.fromLTRB(
                  width * 0.06,
                  width * 0.20,
                  width * 0.06,
                  width * 0.06,
                ),
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(width * 0.04),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Are you sure, delete the property',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.w600,
                        color: textPrimaryColorGlobal,
                      ),
                    ),
                    SizedBox(height: width * 0.06),

                    // Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Cancel Button
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(width * 0.02),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.06,
                              vertical: width * 0.03,
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: width * 0.035,
                            ),
                          ),
                        ),

                        ElevatedButton(
                          onPressed: () {
                            deleteRealEstate(id);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(width * 0.02),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.06,
                              vertical: width * 0.03,
                            ),
                          ),
                          child: Text(
                            'Delete',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: width * 0.035,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Circular Delete Icon
              Positioned(
                top: 0,
                child: Container(
                  width: width * 0.3,
                  height: width * 0.3,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: width * 0.10,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: isLoading
          ? Loader().center()
          : realEstates.isEmpty
              ? Text('No properties found').center()
              : ListView.builder(
                  itemCount: realEstates.length,
                  itemBuilder: (context, index) {
                    return buildCard(realEstates[index], width, height);
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddRealEstateServices()));
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
