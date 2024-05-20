import 'package:flutter/material.dart';
import 'package:flutter_alarm_clock/app/data/data.dart';
import 'package:flutter_alarm_clock/app/data/enums.dart';
import 'package:flutter_alarm_clock/app/data/models/menu_info.dart';
import 'package:flutter_alarm_clock/app/data/theme_data.dart';
import 'package:flutter_alarm_clock/app/modules/views/alarm_page.dart';
import 'package:flutter_alarm_clock/app/modules/views/clock_page.dart';
import 'package:flutter_alarm_clock/app/modules/views/home.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.pageBackgroundColor,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Consumer<MenuInfo>(
              builder: (BuildContext context, MenuInfo value, Widget? child) {
                return Expanded(
                  child: value.menuType == MenuType.clock
                      ? ClockPage()
                      : value.menuType == MenuType.alarm
                          ? AlarmPage()
                          : Home(),
                );
              },
            ),
          ),
          Divider(
            color: CustomColors.dividerColor,
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: menuItems.map((currentMenuInfo) => buildMenuButton(currentMenuInfo)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMenuButton(MenuInfo currentMenuInfo) {
    return Consumer<MenuInfo>(
      builder: (BuildContext context, MenuInfo value, Widget? child) {
        return MaterialButton(
          padding: const EdgeInsets.all(8),
          color: currentMenuInfo.menuType == value.menuType ? CustomColors.menuBackgroundColor : CustomColors.pageBackgroundColor,
          onPressed: () {
            var menuInfo = Provider.of<MenuInfo>(context, listen: false);
            menuInfo.updateMenu(currentMenuInfo);
          },
          child: Column(
            children: <Widget>[
              Image.asset(
                currentMenuInfo.imageSource!,
                width: 30,
              ),
              
              Text(
                currentMenuInfo.title ?? '',
                style: TextStyle(fontFamily: 'avenir', color: CustomColors.primaryTextColor, fontSize: 14),
              ),
            ],
          ),
        );
      },
    );
  }
}
