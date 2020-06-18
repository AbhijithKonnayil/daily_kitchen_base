import 'package:daily_kitchen_base/theme/constants.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:store_redirect/store_redirect.dart';

///PopUp Menu
class DKPopupMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (menuType) {
        switch (menuType) {
          case "rate":
            {
              StoreRedirect.redirect(
                androidAppId: "com.daily_kitchen.customer_app",
              );
              break;
            }
          case "share":
            {
              Share.share(
                  "Hey, I just completed my order from Daily Kitchen. Download the app now to get home delivered daily kitchen commodities.\nhttps://play.google.com/store/apps/details?id=com.daily_kitchen.customer_app");
              break;
            }
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            value: "rate",
            child: Text(
              "Rate Us on PlayStore",
              style: TextStyle(color: DKTheme.green1),
            ),
          ),
          PopupMenuItem(
            value: "share",
            child: Text(
              "Share this App",
              style: TextStyle(color: DKTheme.green1),
            ),
          ),
        ];
      },
    );
  }
}
