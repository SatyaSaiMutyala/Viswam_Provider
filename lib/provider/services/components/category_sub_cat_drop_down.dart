// import 'package:flutter/material.dart';
// import 'package:handyman_provider_flutter/main.dart';
// import 'package:handyman_provider_flutter/models/caregory_response.dart';
// import 'package:handyman_provider_flutter/networks/rest_apis.dart';
// import 'package:handyman_provider_flutter/utils/common.dart';
// import 'package:nb_utils/nb_utils.dart';

// class CategorySubCatDropDown extends StatefulWidget {
//   final int? categoryId;
//   final int? subCategoryId;
//   final Function(int? val) onCategorySelect;
//   final Function(int? val) onSubCategorySelect;
//   final bool? isCategoryValidate;
//   final bool? isSubCategoryValidate;
//   final Color? fillColor;

//   CategorySubCatDropDown(
//       {this.categoryId,
//       this.subCategoryId,
//       required this.onSubCategorySelect,
//       required this.onCategorySelect,
//       this.isSubCategoryValidate,
//       this.isCategoryValidate,
//       this.fillColor});

//   @override
//   State<CategorySubCatDropDown> createState() => _CategorySubCatDropDownState();
// }

// class _CategorySubCatDropDownState extends State<CategorySubCatDropDown> {
//   List<CategoryData> categoryList = [];
//   List<CategoryData> subCategoryList = [];

//   CategoryData? selectedCategory;
//   CategoryData? selectedSubCategory;

//   @override
//   void initState() {
//     super.initState();
//     init();
//   }

//   void init() async {
//     getCategory();
//   }

//   Future<void> getSubCategory({required int categoryId}) async {
//     await getSubCategoryList(catId: categoryId.toInt()).then((value) {
//       subCategoryList = value.data.validate();

//       if (widget.subCategoryId != null) {
//         selectedSubCategory = value.data!
//             .firstWhere((element) => element.id == widget.subCategoryId);
//         widget.onSubCategorySelect.call(selectedSubCategory?.id.validate());
//       }

//       setState(() {});
//     }).catchError((e) {
//       log(e.toString());
//     });
//   }

//   Future<void> getCategory() async {
//     appStore.setLoading(true);

//     await getCategoryList(perPage: 'all').then((value) {
//       categoryList = value.data!;

//       ///
//       if (widget.categoryId != null) {
//         ///
//         selectedCategory = value.data!
//             .firstWhere((element) => element.id == widget.categoryId);
//         widget.onCategorySelect.call(selectedCategory?.id.validate());

//         ///
//         if (widget.subCategoryId != null) {
//           getSubCategory(categoryId: selectedCategory!.id.validate());
//         }
//       }
//       setState(() {});
//     }).catchError((e) {
//       toast(e.toString(), print: true);
//     });

//     appStore.setLoading(false);
//   }

//   @override
//   void setState(fn) {
//     if (mounted) super.setState(fn);
//   }

//   String getStringValue() {
//     if (selectedCategory == null) {
//       return languages.hintSelectCategory;
//     } else {
//       return languages.lblSelectSubCategory;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         children: [
//           DropdownButtonFormField<CategoryData>(
//             decoration: inputDecoration(context,
//                 fillColor: widget.fillColor ?? context.scaffoldBackgroundColor,
//                 hint: languages.hintSelectCategory),
//             value: selectedCategory,
//             dropdownColor: context.scaffoldBackgroundColor,
//             items: categoryList.map((data) {
//               return DropdownMenuItem<CategoryData>(
//                 value: data,
//                 child: Text(data.name.validate(), style: primaryTextStyle()),
//               );
//             }).toList(),
//             validator: widget.isCategoryValidate.validate(value: true)
//                 ? (value) {
//                     if (value == null) return errorThisFieldRequired;

//                     return null;
//                   }
//                 : null,
//             onChanged: (CategoryData? value) async {
//               selectedCategory = value!;
//               widget.onCategorySelect.call(selectedCategory!.id.validate());

//               if (selectedSubCategory != null) {
//                 selectedSubCategory = null;
//                 subCategoryList.clear();
//                 widget.onSubCategorySelect.call(null);
//               }
//               getSubCategory(categoryId: value.id.validate());
//               setState(() {});
//             },
//           ),
//           16.height,
//           DropdownButtonFormField<CategoryData>(
//             decoration: inputDecoration(context,
//                 fillColor: context.scaffoldBackgroundColor,
//                 hint: getStringValue()),
//             value: selectedSubCategory,
//             dropdownColor: context.scaffoldBackgroundColor,
//             validator: widget.isSubCategoryValidate.validate(value: false)
//                 ? (value) {
//                     if (value == null) return errorThisFieldRequired;

//                     return null;
//                   }
//                 : null,
//             items: subCategoryList.map((data) {
//               return DropdownMenuItem<CategoryData>(
//                 value: data,
//                 child: Text(data.name.validate(), style: primaryTextStyle()),
//               );
//             }).toList(),
//             onChanged: (CategoryData? value) async {
//               selectedSubCategory = value!;
//               widget.onSubCategorySelect
//                   .call(selectedSubCategory!.id.validate());
//               setState(() {});
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/caregory_response.dart';
import 'package:handyman_provider_flutter/networks/rest_apis.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:nb_utils/nb_utils.dart';

class CategorySubCatDropDown extends StatefulWidget {
  final int? mainCategoryId;
  final int? categoryId;
  final int? subCategoryId;

  final Function(int? val)? onMainCategorySelect; // optional
  final Function(int? val) onCategorySelect;
  final Function(int? val) onSubCategorySelect;

  final bool? isMainCategoryValidate;
  final bool? isCategoryValidate;
  final bool? isSubCategoryValidate;
  final Color? fillColor;

  CategorySubCatDropDown({
    this.mainCategoryId,
    this.categoryId,
    this.subCategoryId,
    this.onMainCategorySelect, // optional
    required this.onSubCategorySelect,
    required this.onCategorySelect,
    this.isMainCategoryValidate,
    this.isSubCategoryValidate,
    this.isCategoryValidate,
    this.fillColor,
  });

  @override
  State<CategorySubCatDropDown> createState() => _CategorySubCatDropDownState();
}

class _CategorySubCatDropDownState extends State<CategorySubCatDropDown> {
  List<CategoryData> mainCategoryList = [];
  List<CategoryData> categoryList = [];
  List<CategoryData> subCategoryList = [];

  CategoryData? selectedMainCategory;
  CategoryData? selectedCategory;
  CategoryData? selectedSubCategory;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    if (widget.onMainCategorySelect != null) {
      getMainCategories();
    } else {
      getCategory();
    }
  }

  Future<void> getMainCategories() async {
    print('yeah im touch man ---------------');
    appStore.setLoading(true);

    await getMainCategoryList(perPage: 'all').then((value) {
      mainCategoryList = value.data.validate();

      // if (widget.mainCategoryId != null) {
      //   selectedMainCategory =
      //       mainCategoryList.firstWhere((e) => e.id == widget.mainCategoryId);
      //   widget.onMainCategorySelect?.call(selectedMainCategory?.id.validate());

      //   if (widget.categoryId != null) {
      //     getCategory(mainCategoryId: selectedMainCategory!.id.validate());
      //   }
      // }

      // MAIN CATEGORY
      if (widget.mainCategoryId != null) {
        try {
          selectedMainCategory = mainCategoryList.firstWhere(
            (e) => e.id == widget.mainCategoryId,
            orElse: () => CategoryData(),
          );

          if (selectedMainCategory?.id != null) {
            widget.onMainCategorySelect?.call(selectedMainCategory!.id);
          }

          if (widget.categoryId != null) {
            getCategory(mainCategoryId: selectedMainCategory!.id.validate());
          }
        } catch (e) {
          log("Main category not found: $e");
        }
      }

      setState(() {});
    }).catchError((e) {
      toast(e.toString(), print: true);
    });

    appStore.setLoading(false);
  }

  Future<void> getCategory({int? mainCategoryId}) async {
    appStore.setLoading(true);

    Future<CategoryResponse> api;
    if (mainCategoryId != null) {
      api = getCategoryListByMain(mainCategoryId: mainCategoryId);
    } else {
      api = getCategoryList(perPage: 'all');
    }

    await api.then((value) {
      categoryList = value.data.validate();

      // if (widget.categoryId != null) {
      //   selectedCategory =
      //       categoryList.firstWhere((e) => e.id == widget.categoryId);
      //   widget.onCategorySelect.call(selectedCategory?.id.validate());

      //   if (widget.subCategoryId != null) {
      //     getSubCategory(categoryId: selectedCategory!.id.validate());
      //   }
      // }

      // CATEGORY
      if (widget.categoryId != null) {
        try {
          selectedCategory = categoryList.firstWhere(
            (e) => e.id == widget.categoryId,
            orElse: () => CategoryData(),
          );

          if (selectedCategory?.id != null) {
            widget.onCategorySelect.call(selectedCategory!.id);
          }

          if (widget.subCategoryId != null) {
            getSubCategory(categoryId: selectedCategory!.id.validate());
          }
        } catch (e) {
          log("Category not found: $e");
        }
      }

      setState(() {});
    }).catchError((e) {
      toast(e.toString(), print: true);
    });

    appStore.setLoading(false);
  }

  Future<void> getSubCategory({required int categoryId}) async {
    await getSubCategoryList(catId: categoryId).then((value) {
      subCategoryList = value.data.validate();

      // if (widget.subCategoryId != null) {
      //   selectedSubCategory = subCategoryList.firstWhere((e) => e.id == widget.subCategoryId);
      //   widget.onSubCategorySelect.call(selectedSubCategory?.id.validate());
      // }

      // SUBCATEGORY
      if (widget.subCategoryId != null) {
        try {
          selectedSubCategory = subCategoryList.firstWhere(
            (e) => e.id == widget.subCategoryId,
            orElse: () => CategoryData(),
          );

          if (selectedSubCategory?.id != null) {
            widget.onSubCategorySelect.call(selectedSubCategory!.id);
          }
        } catch (e) {
          log("Subcategory not found: $e");
        }
      }

      setState(() {});
    }).catchError((e) {
      log(e.toString());
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  String getStringValue() {
    if (selectedCategory == null) {
      return languages.hintSelectCategory;
    } else {
      return languages.lblSelectSubCategory;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// MAIN CATEGORY DROPDOWN (optional)
        if (widget.onMainCategorySelect != null)
          DropdownButtonFormField<CategoryData>(
            decoration: inputDecoration(
              context,
              fillColor: widget.fillColor ?? context.scaffoldBackgroundColor,
              hint: 'Select Main Category',
            ),
            value: selectedMainCategory,
            dropdownColor: context.scaffoldBackgroundColor,
            items: mainCategoryList.map((data) {
              return DropdownMenuItem<CategoryData>(
                value: data,
                child: Text(data.name.validate(), style: primaryTextStyle()),
              );
            }).toList(),
            validator: widget.isMainCategoryValidate.validate(value: false)
                ? (value) {
                    if (value == null) return errorThisFieldRequired;
                    return null;
                  }
                : null,
            onChanged: (CategoryData? value) async {
              selectedMainCategory = value!;
              widget.onMainCategorySelect
                  ?.call(selectedMainCategory!.id.validate());

              // reset category + subcategory
              selectedCategory = null;
              categoryList.clear();
              widget.onCategorySelect.call(null);

              selectedSubCategory = null;
              subCategoryList.clear();
              widget.onSubCategorySelect.call(null);

              getCategory(mainCategoryId: value.id.validate());
              setState(() {});
            },
          ),
        if (widget.onMainCategorySelect != null) 16.height,

        /// CATEGORY DROPDOWN
        DropdownButtonFormField<CategoryData>(
          decoration: inputDecoration(
            context,
            fillColor: widget.fillColor ?? context.scaffoldBackgroundColor,
            hint: languages.hintSelectCategory,
          ),
          value: selectedCategory,
          dropdownColor: context.scaffoldBackgroundColor,
          items: categoryList.map((data) {
            return DropdownMenuItem<CategoryData>(
              value: data,
              child: Text(data.name.validate(), style: primaryTextStyle()),
            );
          }).toList(),
          validator: widget.isCategoryValidate.validate(value: true)
              ? (value) {
                  if (value == null) return errorThisFieldRequired;
                  return null;
                }
              : null,
          onChanged: (CategoryData? value) async {
            selectedCategory = value!;
            widget.onCategorySelect.call(selectedCategory!.id.validate());

            selectedSubCategory = null;
            subCategoryList.clear();
            widget.onSubCategorySelect.call(null);

            getSubCategory(categoryId: value.id.validate());
            setState(() {});
          },
        ),
        16.height,

        /// SUBCATEGORY DROPDOWN
        if (subCategoryList.isNotEmpty)
          DropdownButtonFormField<CategoryData>(
            decoration: inputDecoration(
              context,
              fillColor: widget.fillColor ?? context.scaffoldBackgroundColor,
              hint: getStringValue(),
            ),
            value: selectedSubCategory,
            dropdownColor: context.scaffoldBackgroundColor,
            validator: widget.isSubCategoryValidate.validate(value: false)
                ? (value) {
                    if (value == null) return errorThisFieldRequired;
                    return null;
                  }
                : null,
            items: subCategoryList.map((data) {
              return DropdownMenuItem<CategoryData>(
                value: data,
                child: Text(data.name.validate(), style: primaryTextStyle()),
              );
            }).toList(),
            onChanged: (CategoryData? value) async {
              selectedSubCategory = value!;
              widget.onSubCategorySelect
                  .call(selectedSubCategory!.id.validate());
              setState(() {});
            },
          ),
      ],
    );
  }
}
