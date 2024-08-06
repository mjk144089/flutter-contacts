import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {

  List<Contact> name = [];
  getPermission() async {
    var status = await Permission.contacts.status;
    if(status.isGranted) {
      print('허가됨');
      var contacts = await ContactsService.getContacts();

      setState(() {
        name = contacts;
      });
    } else {
      print('거절됨');
      Permission.contacts.request();
    }

    if(status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_alert_rounded),
        onPressed: (){
          getPermission();
        },
      ),
      appBar: AppBar(title: Text('연락처'),),
      body: ListView.builder(
        itemCount: name.length,
        itemBuilder: (context, index){
          return ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('${name[index].givenName} ${name[index].familyName}'),
          );
        },
      ),
    );
  }
}
