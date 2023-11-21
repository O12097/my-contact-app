class Contact {
  late final String name;
  final String description;
  late final String email;
  late final String phone;
  final String address;
  final DateTime birthDate;
  final String status;
  final List<String> tags;
  late final String photo;
  bool isSelected;

  Contact({
    required this.name,
    required this.description,
    required this.email,
    required this.phone,
    required this.address,
    required this.birthDate,
    required this.status,
    required this.tags,
    required this.photo,
    this.isSelected = false,
  });

  Contact.withoutPhoto(
    this.photo, {
    required this.name,
    required this.description,
    required this.email,
    required this.phone,
    required this.address,
    required this.birthDate,
    required this.status,
    required this.tags,
    required this.isSelected,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      name: json['name'],
      description: json['description'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      birthDate: DateTime.parse(json['birthDate']),
      status: json['status'],
      tags: List<String>.from(json['tags']),
      photo: json['photo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'email': email,
      'phone': phone,
      'address': address,
      'birthDate': birthDate.toIso8601String(),
      'status': status,
      'tags': tags,
      'photo': photo,
    };
  }

  // @override
  // String toString() {
  //   return "photo=$phone, name=$name, description=$description, email=$email, phone=$phone, address=$address, birthDate=$birthDate, status=$status, tags=$tags";
  // }
}
