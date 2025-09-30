import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../provider/provider_dashboard_screen.dart';

// class BackWidget extends StatelessWidget {
//   final Color? color;
//   final VoidCallback? onPressed;
//   final double? iconSize;

//   BackWidget({this.color, this.onPressed, this.iconSize});

//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//       onPressed: () {
//         if (onPressed != null) {
//           onPressed?.call();
//         } else {
//           pop();
//         }
//       },
//       alignment: Alignment.center,
//       icon: Icon(Icons.arrow_back_ios, color: color ?? Colors.white, size: iconSize ?? 20),
//     );
//   }
// }

class BackWidget extends StatelessWidget {
  final Color? color;
  final VoidCallback? onPressed;
  final double? iconSize;
  final bool goToHome;

  BackWidget(
      {this.color, this.onPressed, this.iconSize, this.goToHome = false});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        if (onPressed != null) {
          onPressed?.call();
        } else {
          if (goToHome) {
            await Future.delayed(Duration(milliseconds: 50));
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => ProviderDashboardScreen(index: 0),
              ),
              (route) => false,
            );
          } else {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          }
        }
      },
      alignment: Alignment.center,
      icon: Icon(Icons.arrow_back_ios,
          color: color ?? Colors.white, size: iconSize ?? 20),
    );
  }
}
