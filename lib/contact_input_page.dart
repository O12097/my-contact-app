import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_contact_app/contact.dart';

class ContactInputPage extends StatefulWidget {
  final Function(Contact) onSave;
  final Contact? initialContact;

  ContactInputPage({required this.onSave, this.initialContact});

  @override
  _ContactInputPageState createState() => _ContactInputPageState();
}

class _ContactInputPageState extends State<ContactInputPage> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedStatus = 'Friend';
  List<String> _selectedTags = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialContact != null) {
      _nameController.text = widget.initialContact!.name;
      _descriptionController.text = widget.initialContact!.description;
      _emailController.text = widget.initialContact!.email;
      _phoneController.text = widget.initialContact!.phone;
      _addressController.text = widget.initialContact!.address;
      _selectedDate = widget.initialContact!.birthDate;
      _selectedStatus = widget.initialContact!.status;
      _selectedTags = widget.initialContact!.tags;
      if (widget.initialContact!.photo != null) {
        _image = File(widget.initialContact!.photo);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Center(
          child: Text(
            'New contact',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.black,
        leading: BackButton(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Contact newContact = Contact(
                  photo: _image != null ? _image!.path : '',
                  name: _nameController.text,
                  description: _descriptionController.text,
                  email: _emailController.text,
                  phone: _phoneController.text,
                  address: _addressController.text,
                  birthDate: _selectedDate,
                  status: _selectedStatus,
                  tags: _selectedTags,
                );
                widget.onSave(newContact);
                Navigator.pop(context);
              }
            },
            icon: Icon(
              Icons.save,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: InkWell(
                  onTap: () {
                    _pickImage();
                  },
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      shape: BoxShape.circle,
                      image: _image != null
                          ? DecorationImage(
                              image: FileImage(_image!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: Center(
                      child: _image == null
                          ? Icon(
                              Icons.camera_alt,
                              size: 50,
                              color: Colors.white,
                            )
                          : SizedBox.shrink(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Card(
                color: Colors.grey.shade900,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    style: TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Card(
                color: Colors.grey.shade900,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    style: TextStyle(color: Colors.white),
                    maxLines: 3,
                  ),
                ),
              ),
              Card(
                color: Colors.grey.shade900,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
              ),
              Card(
                color: Colors.grey.shade900,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ),
              Card(
                color: Colors.grey.shade900,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: 'Address',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Birth Date',
                style: TextStyle(color: Colors.white),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      ).then((pickedDate) {
                        if (pickedDate != null && pickedDate != _selectedDate) {
                          setState(() {
                            _selectedDate = pickedDate;
                          });
                        }
                      });
                    },
                    icon: Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${_selectedDate.day}-${_selectedDate.month}-${_selectedDate.year}',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Status',
                style: TextStyle(color: Colors.white),
              ),
              Row(
                children: [
                  Radio(
                    value: 'Friend',
                    groupValue: _selectedStatus,
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value.toString();
                      });
                    },
                    fillColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white),
                    activeColor: Colors.white,
                  ),
                  Text(
                    'Friend',
                    style: TextStyle(color: Colors.white),
                  ),
                  Radio(
                    value: 'Business Partner',
                    groupValue: _selectedStatus,
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value.toString();
                      });
                    },
                    fillColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white),
                    activeColor: Colors.white,
                  ),
                  Text(
                    'Business Partner',
                    style: TextStyle(color: Colors.white),
                  ),
                  Radio(
                    value: 'Family',
                    groupValue: _selectedStatus,
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value.toString();
                      });
                    },
                    fillColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white),
                    activeColor: Colors.white,
                  ),
                  Text(
                    'Family',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Tags',
                style: TextStyle(color: Colors.white),
              ),
              Row(
                children: [
                  Checkbox(
                    value: _selectedTags.contains('Business'),
                    onChanged: (value) {
                      setState(() {
                        if (value != null && value) {
                          _selectedTags.add('Business');
                        } else {
                          _selectedTags.remove('Business');
                        }
                      });
                    },
                    fillColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white),
                    checkColor: Colors.black,
                    activeColor: Colors.white,
                  ),
                  Text(
                    'Business',
                    style: TextStyle(color: Colors.white),
                  ),
                  Checkbox(
                    value: _selectedTags.contains('Friends'),
                    onChanged: (value) {
                      setState(() {
                        if (value != null && value) {
                          _selectedTags.add('Friends');
                        } else {
                          _selectedTags.remove('Friends');
                        }
                      });
                    },
                    fillColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white),
                    checkColor: Colors.grey.shade900,
                    activeColor: Colors.white,
                  ),
                  Text(
                    'Friends',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      Contact newContact = Contact(
        name: _nameController.text,
        description: _descriptionController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        birthDate: _selectedDate,
        status: _selectedStatus,
        tags: _selectedTags,
        photo: pickedFile.path,
      );

      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }
}
