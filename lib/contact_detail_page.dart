import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_contact_app/contact.dart';
import 'package:my_contact_app/contact_input_page.dart';

class ContactDetailPage extends StatelessWidget {
  final Contact contact;
  final Function(Contact) onEdit;
  final Function() onDelete;

  ContactDetailPage(
      {required this.contact, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        leading: BackButton(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContactInputPage(
                    onSave: (updatedContact) {
                      onEdit(updatedContact);
                      Navigator.pop(context);
                    },
                    initialContact: contact,
                  ),
                ),
              );
            },
            icon: Icon(Icons.edit, color: Colors.white),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: contact.photo != ''
                          ? DecorationImage(
                              image: FileImage(File(contact.photo)),
                              fit: BoxFit.cover,
                            )
                          : DecorationImage(
                              image: AssetImage('../assets/images/profile.png'),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '${contact.name}',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${contact.phone}',
                      style: TextStyle(color: Colors.white)),
                  Text('Phone',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 128, 128, 128),
                          fontSize: 12)),
                ],
              ),
            ),
            ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${contact.email}',
                      style: TextStyle(color: Colors.white)),
                  Text('Email',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 128, 128, 128),
                          fontSize: 12)),
                ],
              ),
            ),
            ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${contact.description}',
                      style: TextStyle(color: Colors.white)),
                  Text('Description',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 128, 128, 128),
                          fontSize: 12)),
                ],
              ),
            ),
            ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${contact.address}',
                      style: TextStyle(color: Colors.white)),
                  Text('Address',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 128, 128, 128),
                          fontSize: 12)),
                ],
              ),
            ),
            ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      '${contact.birthDate.day}-${contact.birthDate.month}-${contact.birthDate.year}',
                      style: TextStyle(color: Colors.white)),
                  Text('Birth Date',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 128, 128, 128),
                          fontSize: 12)),
                ],
              ),
            ),
            ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${contact.status}',
                      style: TextStyle(color: Colors.white)),
                  Text('Status',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 128, 128, 128),
                          fontSize: 12)),
                ],
              ),
            ),
            SizedBox(height: 4),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.grey.shade900,
                      title: Text('Delete contact',
                          style: TextStyle(color: Colors.white)),
                      content: Text(
                          'Are you sure you want to delete this contact?',
                          style: TextStyle(color: Colors.white)),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel',
                              style: TextStyle(color: const Color.fromARGB(255, 204, 204, 204))),
                        ),
                        TextButton(
                          onPressed: () {
                            onDelete();
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Text('Delete',
                              style: TextStyle(color: const Color.fromARGB(255, 181, 2, 2))),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Center(
                child: Text(
                  'Delete Contact',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
