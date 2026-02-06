import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:alumns_app/services/person.dart';

class PeopleService {
  static const String baseUrl = "https://yourserver.com/api";

  Future<List<Person>> fetchPeople() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/people"));

      if (response.statusCode == 200) {
        final body = response.body.trim();
        if (body.startsWith("{") || body.startsWith("[")) {
          final List<dynamic> data = json.decode(body);
          return data.map((json) => Person.fromMap(json)).toList();
        } else {
          throw Exception("Response was not JSON");
        }
      } else {
        throw Exception("Failed with status ${response.statusCode}");
      }
    } catch (e) {
      // fallback to local JSON until backend is ready
      return await loadLocalPeople();
    }
  }

  Future<List<Person>> loadLocalPeople() async {
    final String jsonString = await rootBundle.loadString(
      "assets/data/people.json",
    );
    final List<dynamic> data = json.decode(jsonString);
    return data.map((json) => Person.fromMap(json)).toList();
  }

  // 🔹 New method for connected people
  Future<List<Person>> loadConnectedPeople() async {
  // 🔹 For now, reuse local data or return empty list
  // Later, replace with API call like:
  // final response = await http.get(Uri.parse("$baseUrl/connections"));
  // parse response into List<Person>
  return loadLocalPeople(); 
}
}
