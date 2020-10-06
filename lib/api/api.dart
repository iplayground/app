library api;

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'src/program.dart';
import 'src/session.dart';
import 'src/sponsor.dart';
import 'src/staff.dart';

export 'src/program.dart';
export 'src/session.dart';
export 'src/sponsor.dart';

class APIRepository {
  /// Fetches programs.
  Future<List<Program>> fetchPrograms() async {
    final response = await http.get(
        'https://raw.githubusercontent.com/iplayground/SessionData/2020/v1/program.json');
    final map = json.decode(response.body);
    List list = map['program'];
    return List.from(list.cast<Map>().map((x) => (Program(x))));
  }

  /// Fetches sessions.
  Future<List<Session>> fetchSessions() async {
    final response = await http.get(
        'https://raw.githubusercontent.com/iplayground/SessionData/2020/v1/sessions.json');
    final map = json.decode(response.body);
    List list = map['sessions'];
    return List.from(list.cast<Map>().map((x) => (Session(x))));
  }

  /// Fetches sponsors and partners.
  Future<Sponsors> fetchSponsors() async {
    final response = await http.get(
        'https://raw.githubusercontent.com/iplayground/SessionData/2020/v1/sponsors.json');
    final map = json.decode(response.body);
    return Sponsors(map);
  }

  /// Fetch staffs.
  Future<List<Staff>> fetchStaffs() async {
    final response = await http.get(
        'https://raw.githubusercontent.com/iplayground/SessionData/2020/v1/staffs.json');
    final map = json.decode(response.body);
    List list = map['staff'];
    return List.from(list.cast<Map>().map((x) => (Staff(x))));
  }
}
