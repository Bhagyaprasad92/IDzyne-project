import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

void showBugReportPopup(BuildContext context) {
  final TextEditingController descriptionController = TextEditingController();
  String selectedCategory = 'Bug report';
  FocusNode dropdownFocusNode =
      FocusNode(); // Define this outside the build method

  List<String> categories = [
    'Bug report',
    'Suggestion',
    'Improvement',
    'Other',
  ];

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        backgroundColor: Color(0xfff1f2f2),
        child: Container(
          width: 350,
          padding: EdgeInsets.all(24),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade200,
                        ),
                        padding: EdgeInsets.all(8),
                        child: Icon(Icons.error_outline, color: Colors.black87),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Support',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.close,
                          color: Colors.black54,
                          size: 22,
                        ),
                        splashRadius: 20,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Support Category',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 6),

                  DropdownButtonFormField<String>(
                    focusNode: dropdownFocusNode,
                    value: selectedCategory,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      // labelText: "Category",
                      labelStyle: GoogleFonts.poppins(color: Colors.black54),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.zero,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    icon: Icon(Icons.arrow_drop_down, color: Colors.black87),
                    dropdownColor: Colors.white,
                    items:
                        categories.map((category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(
                              category,
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: Colors.black87,
                              ),
                            ),
                          );
                        }).toList(),
                    onTap: () {
                      FocusScope.of(context).unfocus();

                      Future.delayed(Duration(milliseconds: 1400), () {
                        dropdownFocusNode.requestFocus();
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value!;
                      });
                    },
                  ),

                  SizedBox(height: 18),
                  Text(
                    'Description',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 6),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.zero,
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    padding: EdgeInsets.all(12),
                    child: TextField(
                      controller: descriptionController,
                      maxLines: 5,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Describe the issue...',
                      ),
                      style: GoogleFonts.poppins(fontSize: 15),
                    ),
                  ),

                  SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.poppins(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () async {
                          final description = descriptionController.text.trim();
                          if (description.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Please enter a bug description.",
                                  style: GoogleFonts.poppins(fontSize: 15),
                                ),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                            return;
                          }

                          final success = await submitBugReport(
                            category: selectedCategory,
                            description: description,
                          );

                          Navigator.of(context).pop();

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor:
                                  Colors.black,
                              content: Text(
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                                success
                                    ? 'Failed to submit! ❌'
                                    : 'Thanks for your time! ✅',
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black87,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          elevation: 0,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 10,
                          ),
                          child: Text(
                            'Submit',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      );
    },
  );
}

Future<bool> submitBugReport({
  required String category,
  required String description,
}) async {
  try {
    final url = Uri.parse(
      'https://script.google.com/macros/s/AKfycbwRgivqMHIGxkaq6UrTnEZ0dmliQSU6pSInRNcHS_KPXIFn-M-IKLdPrsuE0SFGM6Zd/exec',
    );
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'category': category,
        'description': description,
        'device': '${Platform.operatingSystem} - ${Platform.version}',
      }),
    );

    return response.statusCode == 200;
  } catch (e) {
    print('Bug report failed: $e');
    return false;
  }
}
