import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_contact_app/contact.dart';
import 'package:my_contact_app/contact_detail_page.dart';
import 'package:my_contact_app/contact_input_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactListPage extends StatefulWidget {
  @override
  _ContactListPageState createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  List<Contact> contacts = [];
  List<Contact> filteredContacts = [];

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> contactsStringList = prefs.getStringList('contacts') ?? [];
    List<Contact> loadedContacts = contactsStringList
        .map((contactString) => Contact.fromJson(json.decode(contactString)))
        .toList();
    setState(() {
      contacts = loadedContacts;
      filteredContacts = loadedContacts;
    });
  }

  Future<void> _saveContact(Contact contact) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> contactsStringList = prefs.getStringList('contacts') ?? [];
    contactsStringList.add(json.encode(contact.toJson()));
    prefs.setStringList('contacts', contactsStringList);
  }

  Future<void> _deleteContact(Contact contact) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> contactsStringList = prefs.getStringList('contacts') ?? [];
    contactsStringList.remove(json.encode(contact.toJson()));
    prefs.setStringList('contacts', contactsStringList);
  }

  void onSearchTextChanged(String text) {
    setState(() {
      filteredContacts = contacts.where((contact) {
        return contact.name.toLowerCase().contains(text.toLowerCase()) ||
            contact.phone.toLowerCase().contains(text.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Contacts',
          style: TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        actions: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isEditing = !_isEditing;
                    });
                  },
                  child: Text(
                    'Edit', //nggak saya kasih fungsi, hanya tampilan. nanti mau dikembangkan untuk jadi fitur selection contact yang mau di delete
                    style: TextStyle(
                      color: Color.fromARGB(255, 107, 107, 107),
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContactInputPage(
                        onSave: (newContact) {
                          setState(() {
                            contacts.add(newContact);
                          });
                          _saveContact(newContact);
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: onSearchTextChanged,
                style: TextStyle(fontSize: 16, color: Colors.white),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 11),
                  hintText: "Search contacts...",
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  fillColor: Colors.grey.shade900,
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 5),
                  itemCount: filteredContacts.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListTile(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey.shade800,
                            child: _imageOrPlaceholder(
                                filteredContacts[index].photo),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 2),
                              Text(
                                filteredContacts[index].name,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              SizedBox(height: 2),
                              Text(
                                filteredContacts[index].phone,
                                style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 173, 173, 173),
                                    fontSize: 15),
                              ),
                              SizedBox(height: 2),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ContactDetailPage(
                                  contact: contacts[index],
                                  onEdit: (updatedContact) {
                                    setState(() {
                                      contacts[index] = updatedContact;
                                    });
                                    _saveContact(updatedContact);
                                  },
                                  onDelete: () {
                                    setState(() {
                                      contacts.removeAt(index);
                                    });
                                    _deleteContact(contacts[index]);
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageOrPlaceholder(String? photo) {
    if (photo != null && File(photo).existsSync()) {
      return ClipOval(
        child: Image.file(
          File(photo),
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Image.asset(
        'assets/images/profile.png',
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      );
    }
  }
}
