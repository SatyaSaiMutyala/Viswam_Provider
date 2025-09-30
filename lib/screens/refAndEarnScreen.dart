
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:share_plus/share_plus.dart';
import '../components/back_widget.dart';
import '../main.dart';
import '../provider/controllers/get_subscription_controller.dart';

class ReferAndEarnScreen extends StatefulWidget {
  const ReferAndEarnScreen({super.key});

  @override
  State<ReferAndEarnScreen> createState() => _ReferAndEarnScreenState();
}

class _ReferAndEarnScreenState extends State<ReferAndEarnScreen> {
  bool loading = true;
  bool isDealer = false;
  String? refId;
  String errorMsg = '';

  @override
  void initState() {
    super.initState();
    fetchRefId();
  }

  Future<void> fetchRefId() async {
    final data = await getData();
    if (mounted) {
      setState(() {
        loading = false;
        isDealer = data['success'] == true;
        if (isDealer) {
          refId = data['ref_id'];
        } else {
          errorMsg = data['message'] ?? 'You are not a dealer. Only dealers have a referral ID.';
        }
      });
    }
  }

  void _shareReferral(BuildContext context) {
    if (refId == null) return;
    String message = '''
🎉 Join this amazing app and get rewards!

Use my referral ID 👉 *$refId* during sign up to earn bonus points.

Download the app now and enjoy the benefits!

🔗 https://yourapp.com/referral/$refId
''';
    Share.share(message);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: appBarWidget(
        'Refer & Earn',
        textColor: white,
        color: context.primaryColor,
        backWidget: BackWidget(),
        showBack: true,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : !isDealer
              /// ------------ Show message if not dealer ---------------
              ? Center(
                  child: Text(
                    errorMsg,
                    style: boldTextStyle(size: 16, color: context.primaryColor),
                    textAlign: TextAlign.center,
                  ),
                )
              /// ------------ Show referral UI if dealer -----------------
              :  SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// HEADER CARD (same as before)
                        _buildHeader(width, context),
                        24.height,
                        _buildHowItWorks(width, context),
                        24.height,
                        _buildRefIdCard(width, context),
                        20.height,
                        _buildInfoCard(width, context),
                        // const Spacer(),
                        const SizedBox(height: 30),
                        _buildShareButton(width, context),
                        20.height,
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildHeader(double width, BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [context.primaryColor, context.primaryColor.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: context.primaryColor.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.card_giftcard_rounded, color: Colors.white, size: width * 0.08),
            ),
            16.width,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Earn Rewards!', style: boldTextStyle(size: (width * 0.06).toInt(), color: Colors.white)),
                4.height,
                Text('Refer friends & get benefits',
                    style: secondaryTextStyle(size: (width * 0.035).toInt(), color: Colors.white.withOpacity(0.9))),
              ],
            ),
          ],
        ),
      );

  Widget _buildHowItWorks(double width, BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: context.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.people_outline, color: context.primaryColor, size: 24),
                ),
                12.width,
                Text('How it works',
                    style: boldTextStyle(size: (width * 0.045).toInt(), color: context.primaryColor)),
              ],
            ),
            16.height,
            Text(
              'Invite your friends and family to join the app. When they register and start using the app with your referral ID, you\'ll earn cashback and rewards!',
              style: secondaryTextStyle(size: (width * 0.038).toInt(), height: 1.4),
            ),
          ],
        ),
      );

  Widget _buildRefIdCard(double width, BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: context.primaryColor.withOpacity(0.2), width: 1.5),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, 6))],
        ),
        child: Column(
          children: [
            Text('Your Referral ID', style: secondaryTextStyle(size: (width * 0.04).toInt())),
            12.height,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: context.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: context.primaryColor.withOpacity(0.3), width: 1),
              ),
              child: SelectableText(
                refId ?? '',
                style: boldTextStyle(size: (width * 0.055).toInt(), color: context.primaryColor, letterSpacing: 2),
              ),
            ),
          ],
        ),
      );

  Widget _buildInfoCard(double width, BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.primaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.primaryColor.withOpacity(0.2), width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: context.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.info_outline_rounded, color: context.primaryColor, size: 24),
            ),
            12.width,
            Expanded(
              child: Text(
                'Your friends must enter this Referral ID while signing up. Once they start using the app, your earnings begin!',
                style: secondaryTextStyle(size: (width * 0.036).toInt(), height: 1.3),
              ),
            ),
          ],
        ),
      );

  Widget _buildShareButton(double width, BuildContext context) => Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [context.primaryColor, context.primaryColor.withOpacity(0.8)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: context.primaryColor.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 6))],
        ),
        child: AppButton(
          color: Colors.transparent,
          text: '📱 Share Referral Link',
          textStyle: boldTextStyle(color: Colors.white, size: (width * 0.042).toInt()),
          width: context.width(),
          elevation: 0,
          shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          onTap: () => _shareReferral(context),
        ),
      );
}
