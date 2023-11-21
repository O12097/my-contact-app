import 'package:flutter/material.dart';
import 'package:my_contact_app/contact_list_page.dart';

void main() => runApp(MyContactApp());

class MyContactApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyContactApp',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: ContactListPage(),
    );
  }
}
