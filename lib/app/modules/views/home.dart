import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_alarm_clock/app/data/theme_data.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: CustomColors.pageBackgroundGradient_house,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 50, bottom: 10),
                  child: Column(
                    children:[
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Mobile Alarmku', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, fontFamily: 'avenir'),),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Card(child: Center(child: Text('About',style: TextStyle(fontSize: 20, fontFamily: 'avenir'),))),
              SizedBox(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Alarm Saya adalah aplikasi pengatur alarm yang memungkinkan pengguna untuk menetapkan alarm harian dengan berbagai opsi pengulangan. Aplikasi ini dirancang untuk memberikan pengalaman yang simpel dan efisien dalam mengelola alarm sehari-hari.'
                      , style: TextStyle( fontFamily: 'avenir'),),
                  ),
                ),
              ),
              Card(child: Center(child: Text('Description',style: TextStyle(fontSize: 20, fontFamily: 'avenir'),))),
              SizedBox(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Aplikasi ini dirancang untuk membantu Kita mengatur alarm dengan mudah dan efisien. Dengan fitur-fitur yang intuitif, Kita dapat menetapkan waktu alarm, mengelola pengulangan, dan menyesuaikan pengaturan suara notifikasi.'
                      , style: TextStyle( fontFamily: 'avenir'),),
                  ),
                ),
              ),
             Center(
               child: Padding(
                 padding: const EdgeInsets.only(top: 5),
                 child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    border: Border.all(width: 10),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Image(
                    image: AssetImage('assets/apkku.png'),
                    ),
                  ),
               ),
             ),
             Center(
               child: Padding(
                 padding: const EdgeInsets.only(bottom: 50),
                 child: Container(
                  child: Text('Alarmku Alarmmu',style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, fontFamily: 'avenir',
                    color: Colors.white,
                  ),
                  ),
                 ),
               ),
             )    
            ],
          ),
        ),
      ),
    );
  }
}