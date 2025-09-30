import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../components/app_widgets.dart';
import '../../components/back_widget.dart';
import '../../components/custom_image_picker.dart';
import '../../main.dart';
import '../../models/realestate_service.modal.dart';
import '../../networks/network_utils.dart';
import '../../utils/common.dart';
import '../../utils/configs.dart';
import 'package:http/http.dart' as http;

class AddRealEstateServices extends StatefulWidget {
  final int? serviceId;

  const AddRealEstateServices({Key? key, this.serviceId}) : super(key: key);

  @override
  State<AddRealEstateServices> createState() => AddRealEstateServicesState();
}

class AddRealEstateServicesState extends State<AddRealEstateServices> {
  List<File> imageFiles = [];
  List<String> selectedImages = [];

  UniqueKey uniqueKey = UniqueKey();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  UniqueKey formWidgetKey = UniqueKey();
  bool isImmediteSelected = true;
  bool selectDate = false;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController rentController = TextEditingController();
  final TextEditingController depositController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String? selectedType;
  String? selectedPropertyType;
  String? selectedFurnishingType;
  DateTime? selectedDate;

  String? ownerName;
  String? ownerPhone;
  String? ownerEmail;

  List<String> furnishingTypes = ['Furnished', 'Unfurnished', 'Semi-Furnished'];

  @override
  void initState() {
    super.initState();
    setState(() {
      ownerEmail = appStore.userEmail;
      ownerName = appStore.userFullName;
      ownerPhone = appStore.userContactNumber;
    });
    if (widget.serviceId != null) {
      fetchServiceById();
    }
  }

  Future<void> fetchServiceById() async {
    if (widget.serviceId == null) return;

    try {
      final response = await http.get(
        Uri.parse('${BASE_URL}get-realstate/${widget.serviceId}'),
        headers: buildHeaderTokens(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final model = RealEstateServiceModel.fromJson(data);
        DateTime parsedDate = DateTime.parse(model.date!);
        titleController.text = model.title ?? '';
        locationController.text = model.location ?? '';
        rentController.text = model.monthlyRent?.toString() ?? '';
        areaController.text = model.areaSqfeet?.toString() ?? '';
        depositController.text = model.securityDeposit?.toString() ?? '';
        descriptionController.text = model.description ?? '';
        ownerName = model.ownerName ?? '';
        ownerPhone = model.ownerPhone ?? '';
        ownerEmail = model.ownerEmail ?? '';
        selectedPropertyType = model.propertyType ?? '';
        if (model.images.isNotEmpty) {
          imageFiles = model.images.map((e) => File(e)).toList();
          setState(() {
            selectedImages = model.images.map((img) => '$DOMAIN_URL/$img') 
        .toList();
          });
        }
        setState(() {
          selectedFurnishingType = model.furnishing_type;
          print('--------->, ${selectedFurnishingType}');
          print('date ------->, ${model.date}');
          selectedDate = parsedDate;
          isImmediteSelected = false;
          selectDate = true;
          selectedType = model.type;
        });
        print(selectDate);
        print('---------------');
        print('Images------->,${DOMAIN_URL}/${selectedImages[0]}');
        setState(() {});
      } else {
        toast('Failed to load service data');
      }
    } catch (e) {
      toast('Error: $e');
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    locationController.dispose();
    areaController.dispose();
    rentController.dispose();
    depositController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> submitRealEstateForm() async {
    hideKeyboard(context);

    if (!formKey.currentState!.validate()) return;

    appStore.setLoading(true);
    print('yeah this is type --------->, ${selectedFurnishingType}');
    try {
      if (widget.serviceId != null) {
        final uri =
            Uri.parse('${BASE_URL}update-realestate/${widget.serviceId}');
        var request = http.MultipartRequest('POST', uri);

        request.headers.addAll(buildHeaderTokens());
        request.fields['_method'] = 'PUT';

        request.fields['property_type'] = selectedPropertyType ?? '';
        request.fields['title'] = titleController.text.trim();
        request.fields['location'] = locationController.text.trim();
        request.fields['furnishing_type'] = selectedFurnishingType ?? '';
        request.fields['area_sqfeet'] = areaController.text.trim();
        request.fields['monthly_rent'] = rentController.text.trim();
        request.fields['security_deposit'] = depositController.text.trim();
        request.fields['description'] = descriptionController.text.trim();
        request.fields['owner_name'] = ownerName ?? '';
        request.fields['owner_phn'] = ownerPhone ?? '';
        request.fields['owner_email'] = ownerEmail ?? '';
        request.fields['type'] = selectedType ?? '';
        request.fields['date'] = isImmediteSelected
            ? DateTime.now().toIso8601String()
            : (selectedDate?.toIso8601String() ?? '');

        request.fields['existing_images'] = jsonEncode(selectedImages);
        for (File file in imageFiles) {
          if (file.existsSync()) {
            request.files
                .add(await http.MultipartFile.fromPath('images[]', file.path));
          }
        }

        var response = await request.send();

        if (response.statusCode == 200) {
          toast('Service updated successfully');
          finish(context);
        } else {
          final error = await response.stream.bytesToString();
          toast('Failed: $error');
          print('Update Error -----------> $error');
        }
      } else {
        final uri = Uri.parse('${BASE_URL}save-realestate');
        var request = http.MultipartRequest('POST', uri);

        request.headers.addAll(buildHeaderTokens());
        request.fields['provider_id'] = appStore.userId.toString();
        request.fields['property_type'] = selectedPropertyType ?? '';
        request.fields['title'] = titleController.text.trim();
        request.fields['location'] = locationController.text.trim();
        request.fields['furnishing_type'] = selectedFurnishingType ?? '';
        request.fields['area_sqfeet'] = areaController.text.trim();
        request.fields['monthly_rent'] = rentController.text.trim();
        request.fields['security_deposit'] = depositController.text.trim();
        request.fields['description'] = descriptionController.text.trim();
        request.fields['owner_name'] = ownerName ?? '';
        request.fields['owner_phn'] = ownerPhone ?? '';
        request.fields['owner_email'] = ownerEmail ?? '';
        request.fields['type'] = selectedType ?? '';
        request.fields['date'] = isImmediteSelected
            ? DateTime.now().toIso8601String()
            : (selectedDate?.toIso8601String() ?? '');

        for (File file in imageFiles) {
          request.files.add(
            await http.MultipartFile.fromPath('images[]', file.path),
          );
        }

        var response = await request.send();

        if (response.statusCode == 200) {
          toast('Service added successfully');
          finish(context, true);
        } else {
          final error = await response.stream.bytesToString();
          toast('Failed: $error');
          print('Create Error -----------> $error');
        }
      }
    } catch (e) {
      toast('Error: $e');
      print('Catch Error ------------> $e');
    } finally {
      appStore.setLoading(false);
    }
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  void editContactInfoModal(double width, double height) {
    final nameController = TextEditingController(text: ownerName);
    final phoneController = TextEditingController(text: ownerPhone);
    final emailController = TextEditingController(text: ownerEmail);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Edit Contact Info', style: boldTextStyle(size: 18)),
                16.height,
                AppTextField(
                  controller: nameController,
                  textFieldType: TextFieldType.NAME,
                  decoration: inputDecoration(context, hint: "Owner Name"),
                ),
                16.height,
                AppTextField(
                  controller: phoneController,
                  textFieldType: TextFieldType.PHONE,
                  decoration: inputDecoration(context, hint: "Phone Number"),
                ),
                16.height,
                AppTextField(
                  controller: emailController,
                  textFieldType: TextFieldType.EMAIL,
                  decoration: inputDecoration(context, hint: "Email"),
                ),
                20.height,
                AppButton(
                  width: width * 0.9,
                  text: languages.btnSave,
                  color: primaryColor,
                  onTap: () {
                    setState(() {
                      ownerName = nameController.text.trim();
                      ownerPhone = phoneController.text.trim();
                      ownerEmail = emailController.text.trim();
                    });
                    toast('Contact info updated');
                    finish(context);
                  },
                ),
              ],
            ),
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
      resizeToAvoidBottomInset: true,
      appBar: appBarWidget(
        'Add Service',
        textColor: white,
        color: context.primaryColor,
        backWidget: BackWidget(),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                16.height,
                CustomImagePicker(
                  key: uniqueKey,
                  selectedImages: selectedImages,
                  onRemoveClick: (value) {
                    showConfirmDialogCustom(
                      context,
                      dialogType: DialogType.DELETE,
                      positiveText: languages.lblDelete,
                      negativeText: languages.lblCancel,
                      onAccept: (p0) {
                        selectedImages.remove(value);
                        imageFiles.removeWhere((file) => file.path == value);
                        setState(() {});
                      },
                    );
                  },
                  onFileSelected: (List<File> files) async {
                    imageFiles = files;
                    selectedImages.addAll(files.map((e) => e.path));
                    setState(() {});
                  },
                ).paddingSymmetric(horizontal: 16),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: width * 0.02),
                  decoration: boxDecorationWithRoundedCorners(
                      borderRadius: radius(),
                      backgroundColor: context.cardColor),
                  child: Column(children: [
                    buildFormWidget(),
                    buildButtons(width, height),
                    buildCustomerInfo(width, height),
                  ]),
                ),
                AppButton(
                  width: width * 0.9,
                  text: languages.btnSave,
                  color: primaryColor,
                  textStyle: boldTextStyle(color: white),
                  onTap: () {
                    submitRealEstateForm();
                  },
                ).paddingOnly(left: 16, right: 16, top: 16, bottom: 16),
              ],
            ),
          ),
          Observer(
            builder: (_) => LoaderWidget().center().visible(appStore.isLoading),
          ),
        ],
      ),
    );
  }

  Widget buildCustomerInfo(double width, double height) {
    return Container(
      margin: EdgeInsets.all(width * 0.05),
      decoration: boxDecorationWithRoundedCorners(
        borderRadius: BorderRadius.circular(width * 0.02),
        backgroundColor: context.cardColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Contact Info',
                style: TextStyle(
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.w600,
                    color: textPrimaryColorGlobal),
              ),
              GestureDetector(
                onTap: () {
                  editContactInfoModal(width, height);
                },
                child: Container(
                  decoration: boxDecorationWithRoundedCorners(
                      backgroundColor: primaryColor,
                      borderRadius: BorderRadius.circular(width * 0.02)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Edit', style: TextStyle(color: Colors.white)),
                      SizedBox(width: width * 0.01),
                      Icon(
                        Icons.edit_outlined,
                        size: width * 0.04,
                        color: Colors.white,
                      )
                    ],
                  ).paddingAll(width * 0.03),
                ),
              ),
            ],
          ),
          SizedBox(height: width * 0.03),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.person_4_outlined,
                size: width * 0.06,
              ),
              SizedBox(
                width: width * 0.02,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ownerName!,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: width * 0.035,
                          color: textPrimaryColorGlobal)),
                  Text('Property Owner',
                      style: TextStyle(
                          color: Colors.grey, fontSize: width * 0.03)),
                ],
              )
            ],
          ),
          SizedBox(height: width * 0.03),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.local_phone_outlined,
                size: width * 0.06,
              ),
              SizedBox(
                width: width * 0.02,
              ),
              Text(ownerPhone!,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: width * 0.035,
                      color: textPrimaryColorGlobal)),
            ],
          ),
          SizedBox(height: width * 0.03),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.email_outlined,
                size: width * 0.06,
              ),
              SizedBox(
                width: width * 0.02,
              ),
              Text(ownerEmail!,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: width * 0.035,
                      color: textPrimaryColorGlobal)),
            ],
          )
        ],
      ).paddingAll(width * 0.03),
    );
  }

  Widget buildButtons(double width, double height) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: height * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isImmediteSelected = true;
                selectDate = false;
              });
            },
            child: Container(
                decoration: BoxDecoration(
                    color:
                        isImmediteSelected ? primaryColor : Colors.transparent,
                    border: Border.all(color: primaryColor, width: 1.0),
                    borderRadius: BorderRadius.circular(width * 0.02)),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: width * 0.04, horizontal: height * 0.05),
                  child: Text('Immediate',
                      style: TextStyle(
                          color:
                              isImmediteSelected ? Colors.white : Colors.grey)),
                )),
          ),
          SizedBox(width: width * 0.03),
          GestureDetector(
            onTap: () async {
              final now = DateTime.now();
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: selectedDate ?? now,
                firstDate: DateTime(now.year - 1),
                lastDate: DateTime(now.year + 5),
              );

              if (pickedDate != null) {
                setState(() {
                  selectedDate = pickedDate;
                  isImmediteSelected = false;
                  selectDate = true;
                });
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: selectDate ? primaryColor : Colors.transparent,
                border: Border.all(color: primaryColor, width: 1.0),
                borderRadius: BorderRadius.circular(width * 0.02),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: width * 0.04,
                  horizontal: height * 0.05,
                ),
                child: Row(
                  children: [
                    Text(
                      selectedDate != null
                          ? formatDate(selectedDate!)
                          : 'Select date',
                      style: TextStyle(
                        color: selectDate ? Colors.white : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ).paddingSymmetric(vertical: 10);
  }

  Widget buildFormWidget() {
    return Container(
      key: formWidgetKey,
      padding: EdgeInsets.all(16),
      child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Property Details',
              style: primaryTextStyle(),
            ).paddingBottom(25),
            DropdownButtonFormField<String>(
              value: selectedType,
              decoration: inputDecoration(context,
                  fillColor: context.scaffoldBackgroundColor,
                  hint: "Select Type"),
              isExpanded: true,
              dropdownColor: context.cardColor,
              items: ['Sell', 'Rent']
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type, style: primaryTextStyle()),
                      ))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  selectedType = val;
                });
              },
              validator: (value) =>
                  value == null ? languages.hintRequired : null,
            ),
            16.height,
            DropdownButtonFormField<String>(
              value: selectedPropertyType,
              decoration: inputDecoration(context,
                  fillColor: context.scaffoldBackgroundColor,
                  hint: "Select Property Type"),
              isExpanded: true,
              dropdownColor: context.cardColor,
              items: ['Apartment', 'Villa', 'Plot', 'Commercial']
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type, style: primaryTextStyle()),
                      ))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  selectedPropertyType = val;
                });
              },
              validator: (value) =>
                  value == null ? languages.hintRequired : null,
            ),
            16.height,
            selectedPropertyType != 'Plot' ?
            AppTextField(
              controller: titleController,
              textFieldType: TextFieldType.NAME,
              decoration: inputDecoration(context,
                  fillColor: context.scaffoldBackgroundColor,
                  hint: "Title eg: family house 2BHK"),
              validator: (val) => val!.isEmpty ? languages.hintRequired : null,
            ) : const SizedBox.shrink(),
            16.height,
            AppTextField(
              controller: locationController,
              textFieldType: TextFieldType.NAME,
              decoration: inputDecoration(context,
                  fillColor: context.scaffoldBackgroundColor, hint: "Location"),
              validator: (val) => val!.isEmpty ? languages.hintRequired : null,
            ),
            16.height,
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: areaController,
                    textFieldType: TextFieldType.NUMBER,
                    decoration: inputDecoration(context,
                        fillColor: context.scaffoldBackgroundColor,
                        hint: "Area sqft eg:1200"),
                    validator: (val) =>
                        val!.isEmpty ? languages.hintRequired : null,
                  ),
                ),
                 if (selectedPropertyType != 'Plot') ...[
      16.width,
      Expanded(
        child: DropdownButtonFormField<String>(
          value: furnishingTypes.contains(selectedFurnishingType)
              ? selectedFurnishingType
              : null,
          decoration: inputDecoration(
            context,
            fillColor: context.scaffoldBackgroundColor,
            hint: "Furnishing",
          ),
          isExpanded: true,
          dropdownColor: context.cardColor,
          items: furnishingTypes
              .map((status) => DropdownMenuItem(
                    value: status,
                    child: Text(status, style: primaryTextStyle()),
                  ))
              .toList(),
          onChanged: (val) {
            setState(() {
              selectedFurnishingType = val;
            });
          },
          validator: (value) =>
              value == null ? languages.hintRequired : null,
        ),
      ),
    ]
              ],
            ),
            16.height,
            // Row(
            //   children: [
            //     Expanded(
            //       child: AppTextField(
            //         controller: rentController,
            //         textFieldType: TextFieldType.NUMBER,
            //         decoration: inputDecoration(context,
            //             fillColor: context.scaffoldBackgroundColor,
            //             hint: "Monthly rent"),
            //         validator: (val) =>
            //             val!.isEmpty ? languages.hintRequired : null,
            //       ),
            //     ),
            //     16.width,
            //     Expanded(
            //       child: AppTextField(
            //         controller: depositController,
            //         textFieldType: TextFieldType.NUMBER,
            //         decoration: inputDecoration(context,
            //             fillColor: context.scaffoldBackgroundColor,
            //             hint: "Security Despoit"),
            //         validator: (val) =>
            //             val!.isEmpty ? languages.hintRequired : null,
            //       ),
            //     ),
            //   ],
            // ),

            selectedType == "Sell" || selectedType == 'Rent' && selectedPropertyType == 'Plot'
                ? AppTextField(
                    controller: rentController,
                    textFieldType: TextFieldType.NUMBER,
                    decoration: inputDecoration(
                      context,
                      fillColor: context.scaffoldBackgroundColor,
                      hint: "Price",
                    ),
                    validator: (val) =>
                        val!.isEmpty ? languages.hintRequired : null,
                  )
                : Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: rentController,
                          textFieldType: TextFieldType.NUMBER,
                          decoration: inputDecoration(
                            context,
                            fillColor: context.scaffoldBackgroundColor,
                            hint: "Monthly rent",
                          ),
                          validator: (val) =>
                              val!.isEmpty ? languages.hintRequired : null,
                        ),
                      ),
                      16.width,
                      Expanded(
                        child: AppTextField(
                          controller: depositController,
                          textFieldType: TextFieldType.NUMBER,
                          decoration: inputDecoration(
                            context,
                            fillColor: context.scaffoldBackgroundColor,
                            hint: "Security Deposit",
                          ),
                          validator: (val) =>
                              val!.isEmpty ? languages.hintRequired : null,
                        ),
                      ),
                    ],
                  ),

            16.height,
            AppTextField(
              controller: descriptionController,
              textFieldType: TextFieldType.MULTILINE,
              minLines: 5,
              maxLines: 8,
              decoration: inputDecoration(context,
                  fillColor: context.scaffoldBackgroundColor,
                  hint: "Description"),
              validator: (val) => val!.isEmpty ? languages.hintRequired : null,
            ),
          ],
        ),
      ),
    );
  }
}
