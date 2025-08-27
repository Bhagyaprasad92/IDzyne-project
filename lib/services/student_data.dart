
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class Student {
  final String image;
  final String roll;
  final String date;
  final String time;
  final String technologyName;

  Student({
    required this.image,
    required this.roll,
    required this.date,
    required this.time,
    required this.technologyName,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      image:
          "https://info.aec.edu.in/adityacentral/StudentPhotos/${json['rollNumber']}.jpg",
      roll: json['rollNumber'] ?? 'Unknown',
      technologyName: json['technologyName'] ?? '',
      date: DateFormat('dd MMM yyyy').format(DateTime.now()),
      time: '--:--',
    );
  }

  factory Student.fromAttendanceJson(Map<String, dynamic> json) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(
      json['dateAsInt'] ?? 0,
    );
    return Student(
      image:
          "https://info.aec.edu.in/adityacentral/StudentPhotos/${json['roll']}.jpg",
      roll: json['roll'] ?? 'Unknown',
      technologyName: json['technology'] ?? '',
      date: DateFormat('dd MMM yyyy').format(dateTime),
      time: DateFormat('HH:mm').format(dateTime),
    );
  }
}


class StudentDataService {
  static const String apiUrl =
      'https://example.com/api/user/all';
  static final List<Student> presentList = [];


  static List<Student> getPresentList() {
    return presentList;
  }

  static Map<String, String> technologyApiMap = {
    'Flutter': 'FSD With Flutter',
    'React Native': 'FSD With React Native',
    'Service Now': 'SERVICE NOW',
    'AWS' : 'AWS Development with DevOps',
    'VLSI' : 'VLSI',
    'Data specialist' : 'Data Specialist',
  };

  static Future<void> fetchTodayPresentStudents({
    String technology = 'All Tech',
  }) async {
    const url =
        'https://example.com/api/attendance/today';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final allPresent =
            jsonData.map((json) => Student.fromAttendanceJson(json)).toList();

        final techFromDropdown = technologyApiMap[technology];

        final filteredPresent =
            techFromDropdown == null
                ? allPresent
                : allPresent
                    .where(
                      (s) =>
                          s.technologyName.toUpperCase() ==
                          techFromDropdown.toUpperCase(),
                    )
                    .toList();

        presentList.clear();
        presentList.addAll(filteredPresent);

        debugPrint('Filtered present students: ${presentList.length}');
      } else {
        throw Exception('Failed to load today\'s attendance');
      }
    } catch (e) {
      debugPrint('Error fetching today\'s present students: $e');
    }
  }

  static Future<List<Student>> fetchUnmarkedStudents({
    String technology = 'All Tech',
  }) async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final allStudents =
            jsonData.map((json) => Student.fromJson(json)).toList();

        final techFromDropdown = technologyApiMap[technology];

        
        final filteredStudents =
            techFromDropdown == null
                ? allStudents
                : allStudents
                    .where(
                      (s) =>
                          s.technologyName.toUpperCase() ==
                          techFromDropdown.toUpperCase(),
                    )
                    .toList();

        final unmarked =
            filteredStudents
                .where(
                  (student) => !presentList.any((p) => p.roll == student.roll),
                )
                .toList();

        return unmarked;
      } else {
        throw Exception('Failed to load students');
      }
    } catch (e) {
      debugPrint('Error fetching students: $e');
      return [];
    }
  }
}
