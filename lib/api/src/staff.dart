import 'dart:convert';

import 'package:http/http.dart' as http;

class Staff {
  String name;
  String imageUrl;
  String description;
  String linkUrl;

  Staff(Map map) {
    name = map['name'];
    imageUrl = map['imgURL'];
    description = map['position'];
    linkUrl = map['SNS'];
  }

  Map toJson() => {
        'name': name,
        'imgURL': imageUrl,
        'position': description,
        'SNS': linkUrl,
      };
}

/// Fetch staffs.
Future<List<Staff>> fetchStaffs() async {
  final response = await http.get(
      'https://raw.githubusercontent.com/iplayground/SessionData/2020/v1/staffs.json');
  final map = json.decode(response.body);
  List list = map['staff'];
  return List.from(list.cast<Map>().map((x) => (Staff(x))));
}
