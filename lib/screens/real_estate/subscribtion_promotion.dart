
import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/app_widgets.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/back_widget.dart';
import '../../models/caregory_response.dart';
import '../../networks/rest_apis.dart';
import '../../utils/configs.dart';
import '../subscription_screen.dart';

class TakeSubscriptionMessage extends StatefulWidget {
  final bool showAppBar;
  const TakeSubscriptionMessage({super.key, this.showAppBar = true});

  @override
  State<TakeSubscriptionMessage> createState() =>
      _TakeSubscriptionMessageState();
}

class _TakeSubscriptionMessageState extends State<TakeSubscriptionMessage> {
  Future<List<CategoryData>> getCategories() async {
    final res = await getCategoryList(perPage: 'all');
    return res.data ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
          ? appBarWidget(
              'Subscription Required',
              color: context.primaryColor,
              textColor: white,
              backWidget: BackWidget(),
              elevation: 0,
            )
          : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Icons.lock_outline, color: primaryColor, size: 80),
            24.height,
            Text(
              'To access this feature, please subscribe to a plan.',
              style: primaryTextStyle(size: 16),
              textAlign: TextAlign.center,
            ),
            12.height,
            Text(
              'A valid subscription helps you unlock premium features and ensures your services are visible to customers.',
              style: secondaryTextStyle(size: 14),
              textAlign: TextAlign.center,
            ),
            16.height,
            AppButton(
              text: 'Take Subscription',
              color: primaryColor,
              width: 180,
              onTap: () {
                finish(context);
                PlanSelectionScreen().launch(context);
              },
            ),
            20.height,
            Align(
              alignment: Alignment.centerLeft,
              child:
                  Text('Available Services', style: primaryTextStyle(size: 16)),
            ),
            16.height,
            FutureBuilder<List<CategoryData>>(
              future: getCategories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoaderWidget();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.data!.isEmpty) {
                  return const Text('No categories found');
                }

                final categories = snapshot.data!;

                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: categories.map((category) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              NetworkImage(category.categoryImage.validate()),
                          backgroundColor: Colors.grey.shade200,
                        ),
                        8.height,
                        SizedBox(
                          width: 72,
                          child: Text(
                            category.name.validate(),
                            style: secondaryTextStyle(size: 12),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                );
              },
            ),
            20.height,
          ],
        ),
      ),
    );
  }
}
