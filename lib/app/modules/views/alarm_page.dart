import 'package:flutter_alarm_clock/alarm_helper.dart';
import 'package:flutter_alarm_clock/app/data/theme_data.dart';
import 'package:flutter_alarm_clock/app/data/models/alarm_info.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_alarm_clock/main.dart';

class AlarmPage extends StatefulWidget {
  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  DateTime? _alarmTime;
  late String _alarmTimeString;
  late String _alarmTitle;
  bool _isRepeatSelected = false;
  AlarmHelper _alarmHelper = AlarmHelper();
  Future<List<AlarmInfo>>? _alarms;
  List<AlarmInfo>? _currentAlarms;
   late tz.TZDateTime _local; // Declare _local as a late-initialized variable
  @override
  void initState() {
    _alarmTime = DateTime.now();
    _initializeTimeZone();
    super.initState();
    _alarmTimeString = DateFormat('HH:mm').format(DateTime.now());
    _alarmTitle = '';
    tz.TZDateTime scheduledDate = tz.TZDateTime.now(tz.local).add(const Duration(days: 1));
    _alarmHelper.initializeDatabase().then((value) {
      print('------database intialized');
      loadAlarms();
    });
    super.initState();
  }

  void loadAlarms() {
    _alarms = _alarmHelper.getAlarms();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: CustomColors.pageBackgroundGradient_alarm,
        ),
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Alarm',
            style:
                TextStyle(fontFamily: 'avenir', fontWeight: FontWeight.w700, color: CustomColors.primaryTextColor, fontSize: 24),
          ),
          Expanded(
            child: FutureBuilder<List<AlarmInfo>>(
              future: _alarms,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _currentAlarms = snapshot.data;
                  return ListView(
                    children: snapshot.data!.map<Widget>((alarm) {
                      var alarmTime = DateFormat('hh:mm aa').format(alarm.alarmDateTime!);
                      var gradientColor = GradientTemplate.gradientTemplate[alarm.gradientColorIndex!].colors;
                      
                      return InkWell(
                        onLongPress: () {
                          showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Delete Alarm'),
                              content: Text('Kamu Yakin?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close the dialog
                                  },
                                  child: Text('No'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    deleteAlarm(alarm.id); // Call delete function
                                    Navigator.of(context).pop(); // Close the dialog
                                  },
                                  child: Text('Yes'),
                                ),
                              ],
                            );
                          },
                        );
                        },
                        onTap: () {
                          _updateAlarm(alarm);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 32),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: gradientColor,
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: gradientColor.last.withOpacity(0.4),
                                blurRadius: 8,
                                spreadRadius: 2,
                                offset: Offset(4, 4),
                              ),
                            ],
                            borderRadius: BorderRadius.all(Radius.circular(24)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      
                                      Text(
                                        'Title: '+ alarm.title!,
                                        style: TextStyle(color: Colors.white, fontFamily: 'avenir', fontSize: 20,fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                 
                                ],
                              ),
                              Text(
                                'Mon-Fri',
                                style: TextStyle(color: Colors.white, fontFamily: 'avenir'),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    alarmTime,
                                    style: TextStyle(
                                        color: Colors.white, fontFamily: 'avenir', fontSize: 15, fontWeight: FontWeight.w700),
                                  ),
                                  
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).followedBy([
                      if (_currentAlarms!.length < 5)
                        DottedBorder(
                          strokeWidth: 2,
                          color: CustomColors.clockOutline,
                          borderType: BorderType.RRect,
                          radius: Radius.circular(24),
                          dashPattern: [5, 4],
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: CustomColors.clockBG,
                              borderRadius: BorderRadius.all(Radius.circular(24)),
                            ),
                            child: MaterialButton(
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              onPressed: () {
                                _alarmTimeString = DateFormat('HH:mm').format(DateTime.now());
                                showModalBottomSheet(
                                  useRootNavigator: true,
                                  context: context,
                                  clipBehavior: Clip.antiAlias,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(24),
                                    ),
                                  ),
                                  builder: (context) {
                                    return StatefulBuilder(
                                      builder: (context, setModalState) {
                                        return Container(
                                          padding: const EdgeInsets.all(32),
                                          child: Column(
                                            children: [
                                              TextButton(
                                                onPressed: () async {
                                                  var selectedTime = await showTimePicker(
                                                    context: context,
                                                    initialTime: TimeOfDay.now(),
                                                  );
                                                  if (selectedTime != null) {
                                                    final now = DateTime.now();
                                                    var selectedDateTime = DateTime(
                                                        now.year, now.month, now.day, selectedTime.hour, selectedTime.minute);
                                                    _alarmTime = selectedDateTime;
                                                    setModalState(() {
                                                      _alarmTimeString = DateFormat('HH:mm').format(selectedDateTime);
                                                    });
                                                  }
                                                },
                                                child: Text(
                                                  _alarmTimeString,
                                                  style: TextStyle(fontSize: 32),
                                                ),
                                              ),
                                              ListTile(
                                                title: Text('Repeat'),
                                                trailing: Switch(
                                                  onChanged: (value) {
                                                    setModalState(() {
                                                      _isRepeatSelected = value;
                                                    });
                                                  },
                                                  value: _isRepeatSelected,
                                                ),
                                              ),
                                             
                                               ListTile(
                                                title: Text('Title'),
                                                trailing: SizedBox(
                                                  width: 150,
                                                  child: TextFormField(
                                                    initialValue: '', // Nilai awal untuk title
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _alarmTitle = value; // Tangkap perubahan nilai title
                                                      });
                                                    },
                                                    decoration: InputDecoration(
                                                      hintText: 'Enter title',
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              FloatingActionButton.extended(
                                                onPressed: () {
                                                  onSaveAlarm(_isRepeatSelected);
                                                },
                                                icon: Icon(Icons.alarm),
                                                label: Text('Save'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                                // scheduleAlarm();
                              },
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    'assets/add_alarm.png',
                                    scale: 1.5,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Add Alarm',
                                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontFamily: 'avenir', fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      else
                        Center(
                            child: Text(
                          'Only 5 alarms allowed!',
                          style: TextStyle(color: Colors.white),
                        )),
                    ]).toList(),
                  );
                }
                return Center(
                  child: Text(
                    'Loading..',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void scheduleAlarm(DateTime scheduledNotificationDateTime, AlarmInfo alarmInfo, {required bool isRepeating}) async {

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      channelDescription: 'Channel for Alarm notification',
      icon: 'alarmku',
      sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
      largeIcon: DrawableResourceAndroidBitmap('alarmku'),
    );

    
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    if (isRepeating)
      await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        'ALARMKU',
        alarmInfo.title,
        Time(
          scheduledNotificationDateTime.hour,
          scheduledNotificationDateTime.minute,
          scheduledNotificationDateTime.second,
        ),
        platformChannelSpecifics,
      );
    else
      await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'ALARMKU',
        alarmInfo.title,
        tz.TZDateTime.from(scheduledNotificationDateTime, tz.local),
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
  }

  void onSaveAlarm(bool _isRepeating) {
    DateTime? scheduleAlarmDateTime;
    if (_alarmTime!.isAfter(DateTime.now()))
      scheduleAlarmDateTime = _alarmTime;
    else
      scheduleAlarmDateTime = _alarmTime!.add(Duration(days: 1));

    var alarmInfo = AlarmInfo(
      alarmDateTime: scheduleAlarmDateTime,
      gradientColorIndex: _currentAlarms!.length,
      title: _alarmTitle,
    );
    _alarmHelper.insertAlarm(alarmInfo);
    if (scheduleAlarmDateTime != null) {
      scheduleAlarm(scheduleAlarmDateTime, alarmInfo, isRepeating: _isRepeating);
    }
    Navigator.pop(context);
    loadAlarms();
  }

  void deleteAlarm(int? id) {
    _alarmHelper.delete(id);
    //unsubscribe for notification
    loadAlarms();
  }

  void _saveUpdatedAlarm(AlarmInfo alarm, bool _isRepeating) {
  // Simpan perubahan alarm yang diperbarui
  alarm.title = _alarmTitle;
  _alarmHelper.updateAlarm(alarm);

  // Atur ulang notifikasi untuk alarm yang diperbarui
  if (alarm.alarmDateTime != null) {
    scheduleAlarm(alarm.alarmDateTime!, alarm, isRepeating: _isRepeating);
  }

  // Tutup modal bottom sheet setelah update selesai
  Navigator.pop(context);

  // Muat ulang daftar alarm
  loadAlarms();
}

void _updateAlarm(AlarmInfo alarm) {
  // Menampilkan modal bottom sheet untuk mengedit alarm
  showModalBottomSheet(
    useRootNavigator: true,
    context: context,
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(24),
      ),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                TextButton(
                  onPressed: () async {
                    var selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(alarm.alarmDateTime!),
                    );
                    if (selectedTime != null) {
                      final now = DateTime.now();
                      var selectedDateTime = DateTime(
                        now.year,
                        now.month,
                        now.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      );
                      // Update waktu alarm
                      alarm.alarmDateTime = selectedDateTime;
                      setModalState(() {
                        _alarmTimeString = DateFormat('HH:mm').format(selectedDateTime);
                      });
                    }
                  },
                  child: Text(
                    _alarmTimeString,
                    style: TextStyle(fontSize: 32),
                  ),
                ),
                ListTile(
                  title: Text('Repeat'),
                  trailing: Switch(
                    onChanged: (value) {
                      setModalState(() {
                        _isRepeatSelected = value;
                      });
                    },
                    value: _isRepeatSelected,
                  ),
                ),
                
                ListTile(
                  title: Text('Title'),
                  trailing: SizedBox(
                    width: 150,
                    child: TextFormField(
                      initialValue: alarm.title,
                      onChanged: (value) {
                        setState(() {
                          _alarmTitle = value; // Perbarui nilai _alarmTitle
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter title',
                      ),
                    ),
                  ),
                ),
                FloatingActionButton.extended(
                  onPressed: () {
                    _saveUpdatedAlarm(alarm, _isRepeatSelected);
                  },
                  icon: Icon(Icons.alarm),
                  label: Text('Update'),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

  
  void _initializeTimeZone() {
  tz.initializeTimeZones();
  _local = tz.TZDateTime.now(tz.local);
}
void requestPermission() async {
  var status = await Permission.scheduleExactAlarm.status;
  if (status.isDenied) {
    await Permission.scheduleExactAlarm.request();
  }
}
}
