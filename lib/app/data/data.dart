import 'package:flutter_alarm_clock/app/data/enums.dart';
import 'package:flutter_alarm_clock/app/data/models/alarm_info.dart';
import 'package:flutter_alarm_clock/app/data/models/menu_info.dart';

List<MenuInfo> menuItems = [
  MenuInfo(MenuType.home, title: 'Home', imageSource: 'assets/house.png'),
  MenuInfo(MenuType.clock, title: 'Clock', imageSource: 'assets/clock2.png'),
  MenuInfo(MenuType.alarm, title: 'Alarm', imageSource: 'assets/clock_alarm.png'),
  
];

List<AlarmInfo> alarms = [
  AlarmInfo(alarmDateTime: DateTime.now().add(Duration(hours: 1)), title: '', gradientColorIndex: 0),
  AlarmInfo(alarmDateTime: DateTime.now().add(Duration(hours: 2)), title: '', gradientColorIndex: 1),
];
