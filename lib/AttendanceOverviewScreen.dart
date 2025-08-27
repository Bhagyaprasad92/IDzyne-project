import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:idzyne/services/student_data.dart';

class AttendanceOverviewScreen extends StatefulWidget {
  final String userName;

  const AttendanceOverviewScreen({super.key, required this.userName});

  @override
  State<AttendanceOverviewScreen> createState() => _AttendanceOverviewScreenState();
}


// class _AttendanceOverviewScreenState extends State<AttendanceOverviewScreen> {
//   List<Student> _presentList = [];

//   List<Map<String, String>> _presentListData() {
//     return _presentList.map((student) {
//       return {
//         'image': student.image,
//         'roll': student.roll,
//         'date': student.date,
//         'time': student.time,
//       };
//     }).toList();
//   }

//   List<Student> _unmarkedListData = [];

//   @override
//   void initState() {
//     super.initState();
//     _refreshAllData();
//   }

//   Future<void> _refreshAllData() async {
//     await StudentDataService.fetchTodayPresentStudents();
//     final newPresentList = StudentDataService.getPresentList();

//     final allUnmarked = await StudentDataService.fetchUnmarkedStudents();

//     final presentRolls = newPresentList.map((s) => s.roll).toSet();

//     setState(() {
//       _presentList = newPresentList;
//       _unmarkedListData =
//           allUnmarked
//               .where((student) => !presentRolls.contains(student.roll))
//               .toList();
//     });
//   }

//   Future<void> _downloadAndSharePresentList() async {
//     if (_presentList.isEmpty) return;

//     final now = DateTime.now();
//     final dateStr =
//         "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

//     final StringBuffer buffer = StringBuffer();
//     buffer.writeln('Roll No,Date,Time');

//     for (final student in _presentList) {
//       final roll = '"${student.roll}"';
//       final date = '"${student.date}"';
//       final time = '"${student.time}"';
//       buffer.writeln('$roll,$date,$time');
//     }

//     final fileName = 'PresentList_$dateStr.csv';
//     final directory = await getTemporaryDirectory();
//     final file = File('${directory.path}/$fileName');
//     await file.writeAsString(buffer.toString());

//     await Share.shareXFiles([
//       XFile(file.path),
//     ], text: 'Present list for $dateStr');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xfff1f2f2),
//       body: Column(
//         children: [
//           SafeArea(
//             child: Container(
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               color: Colors.transparent,
//               child: Row(
//                 spacing: 10,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   IconButton.outlined(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     padding: EdgeInsets.zero,
//                     icon: Icon(Icons.arrow_back_ios_new, size: 18),
//                     style: ButtonStyle(
//                       minimumSize: WidgetStateProperty.all(Size.square(36)),
//                       shape: WidgetStateProperty.all(
//                         RoundedRectangleBorder(borderRadius: BorderRadius.zero),
//                       ),
//                     ),
//                   ),
//                   Center(
//                     child: Text(
//                       "Today's Attendance",
//                       style: GoogleFonts.poppins(
//                         color: Colors.black,
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           _buildSummarySection(context),
//           const SizedBox(height: 8),
//           Expanded(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.only(bottom: 16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildSectionTitle("Marked"),
//                   _buildListWithFixedHeader(_presentListData()),
//                   const SizedBox(height: 16),
//                   _buildSectionTitle("Unmarked"),
//                   _unmarkedListData.isEmpty
//                       ? const Padding(
//                         padding: EdgeInsets.all(16),
//                         child: Text("No unmarked students found."),
//                       )
//                       : _buildListWithFixedHeader(
//                         _unmarkedListData.map((student) {
//                           return {
//                             'image': student.image,
//                             'roll': student.roll,
//                             'date': student.date,
//                             'time': student.time,
//                           };
//                         }).toList(),
//                       ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSummarySection(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "Summary",
//                 style: GoogleFonts.poppins(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black87,
//                 ),
//               ),
//               IconButton(
//                 icon: const Icon(Icons.filter_list, color: Colors.grey),
//                 onPressed: () async {
//                   final selectedTech = await Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (_) => AttendanceFilterScreen()),
//                   );

//                   if (selectedTech != null) {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder:
//                             (_) => AttendanceOverviewScreenFiltered(
//                               technology: selectedTech,
//                             ),
//                       ),
//                     );
//                   }
//                 },
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               boxShadow: const [
//                 BoxShadow(
//                   color: Colors.black12,
//                   blurRadius: 4,
//                   offset: Offset(0, 4),
//                 ),
//               ],
//             ),
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 _buildStat(
//                   Icons.person_outline,
//                   "Active",
//                   "${_presentListData().length}",
//                   Colors.black,
//                 ),
//                 Container(width: 1, height: 40, color: Colors.grey[300]),
//                 _buildStat(
//                   Icons.person_outline,
//                   "Inactive",
//                   "${_unmarkedListData.length}",
//                   Colors.black,
//                 ),
//                 Container(width: 1, height: 40, color: Colors.grey[300]),
//                 _buildStat(
//                   Icons.groups_outlined,
//                   "Total",
//                   "${_presentListData().length + _unmarkedListData.length}",
//                   Colors.black,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStat(IconData icon, String label, String value, Color color) {
//     return Column(
//       children: [
//         Row(
//           children: [
//             Icon(icon, size: 16, color: color),
//             const SizedBox(width: 4),
//             Text(
//               label,
//               style: GoogleFonts.poppins(fontSize: 13, color: Colors.black54),
//             ),
//           ],
//         ),
//         SizedBox(height: 4),
//         Text(
//           value,
//           style: GoogleFonts.poppins(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             color: Colors.black87,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildSectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: GoogleFonts.poppins(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           if (title == "Marked")
//             GestureDetector(
//               onTap: _downloadAndSharePresentList,
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade200,
//                   shape: BoxShape.rectangle,
//                   border: Border.all(width: 1),
//                 ),
//                 padding: const EdgeInsets.all(4),
//                 child: const Icon(Icons.download, color: Colors.grey),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildListWithFixedHeader(List<Map<String, String>> dataList) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: const [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 4,
//               offset: Offset(0, 4),
//             ),
//           ],
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Column(
//           children: [
//             _buildListHeaderRow(),
//             const Divider(height: 1),
//             ConstrainedBox(
//               constraints: BoxConstraints(maxHeight: 500),
//               child:
//                   dataList.isEmpty
//                       ? const Padding(
//                         padding: EdgeInsets.all(16),
//                         child: Text("No data available."),
//                       )
//                       : ListView.builder(
//                         shrinkWrap: true,
//                         itemCount: dataList.length,
//                         itemBuilder: (context, index) {
//                           final data = dataList[index];
//                           return _buildStudentRow(
//                             data['image'] ?? '',
//                             data['roll'] ?? '',
//                             data['date'] ?? '',
//                             data['time'] ?? '',
//                           );
//                         },
//                       ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildListHeaderRow() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(12),
//           topRight: Radius.circular(12),
//         ),
//         boxShadow: const [
//           BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
//         ],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             flex: 4,
//             child: Text(
//               "Roll No",
//               style: GoogleFonts.poppins(
//                 fontWeight: FontWeight.w600,
//                 fontSize: 14,
//                 color: Colors.black87,
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 2,
//             child: Center(
//               child: Text(
//                 "Date",
//                 style: GoogleFonts.poppins(
//                   fontWeight: FontWeight.w600,
//                   fontSize: 12,
//                   color: Colors.black87,
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: Align(
//               alignment: Alignment.centerRight,
//               child: Text(
//                 "Time",
//                 style: GoogleFonts.poppins(
//                   fontWeight: FontWeight.w600,
//                   fontSize: 12,
//                   color: Colors.black87,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStudentRow(
//     String imagePath,
//     String rollNo,
//     String date,
//     String time,
//   ) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: const BoxDecoration(
//         border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             flex: 4,
//             child: Row(
//               children: [
//                 ClipOval(
//                   child: Image.network(
//                     imagePath,
//                     width: 40,
//                     height: 40,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 Expanded(
//                   child: Text(
//                     rollNo,
//                     style: GoogleFonts.poppins(fontSize: 14),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             flex: 2,
//             child: Center(
//               child: Text(date, style: GoogleFonts.poppins(fontSize: 12)),
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: Align(
//               alignment: Alignment.centerRight,
//               child: Text(time, style: GoogleFonts.poppins(fontSize: 12)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
class _AttendanceOverviewScreenState extends State<AttendanceOverviewScreen> {
  List<Student> _presentList = [];
  List<Student> _unmarkedListData = [];
  int _selectedTabIndex = 0;
  late FocusNode _focusNode;
  bool isLoggedIn = false;
  String? username;
  String _selectedTechnology = 'All Tech';

  @override
  void initState() {
    super.initState();
    _refreshAllData();
  }

  Future<void> _refreshAllData() async {
    final selectedTech = _selectedTechnology;

    await StudentDataService.fetchTodayPresentStudents(
      technology: selectedTech,
    );

    final allUnmarked = await StudentDataService.fetchUnmarkedStudents(
      technology: selectedTech,
    );

    final newPresentList = StudentDataService.getPresentList();
    final presentRolls = newPresentList.map((s) => s.roll).toSet();

    setState(() {
      _presentList = newPresentList;
      _unmarkedListData =
          allUnmarked
              .where((student) => !presentRolls.contains(student.roll))
              .toList();
    });
  }

  List<Map<String, String>> _presentListData() =>
      _presentList
          .map(
            (student) => {
              'image': student.image,
              'roll': student.roll,
              'date': student.date,
              'time': student.time,
            },
          )
          .toList();

  List<Map<String, String>> _getFilteredList() {
    if (_selectedTabIndex == 0) {
      return _presentListData();
    } else if (_selectedTabIndex == 1) {
      return _unmarkedListData
          .map(
            (student) => {
              'image': student.image,
              'roll': student.roll,
              'date': student.date,
              'time': student.time,
            },
          )
          .toList();
    } else {
      final total = [..._presentList, ..._unmarkedListData];
      return total
          .map(
            (student) => {
              'image': student.image,
              'roll': student.roll,
              'date': student.date,
              'time': student.time,
            },
          )
          .toList();
    }
  }

  Widget _buildStat(
    IconData icon,
    String label,
    String value,
    Color color,
    int tabIndex,
  ) {
    final isSelected = _selectedTabIndex == tabIndex;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedTabIndex = tabIndex;
          });
        },
        borderRadius: BorderRadius.circular(0),
        splashColor: Colors.black.withOpacity(0.2),
        highlightColor: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? Colors.black : Colors.transparent,
                width: 1,
              ),
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 16, color: color),
                  const SizedBox(width: 4),
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getTechIcon(String tech) {
    switch (tech) {
      case 'Flutter':
        return Icons.phone_android;
      case 'React Native':
        return Icons.devices;
      case 'AWS':
        return Icons.cloud;
      case 'Service Now':
        return Icons.build_circle;
      case 'VLSI':
        return Icons.memory;
      case 'Data specialist':
        return Icons.bar_chart;
      case 'All Tech':
      default:
        return Icons.all_inclusive;
    }
  }


  Widget _buildSummarySection(double screenWidth, double screenHeight) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Summary",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (String tech) {
                  setState(() {
                    _selectedTechnology = tech;
                  });
                  _refreshAllData();
                },
                position: PopupMenuPosition.under,
                color: Color(0xfff1f2f2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                itemBuilder: (BuildContext context) {
                  final techList = [
                    'Flutter',
                    'React Native',
                    'AWS',
                    'Service Now',
                    'VLSI',
                    'Data specialist',
                    'All Tech',
                  ];

                  return techList.map((tech) {
                    final isSelected = tech == _selectedTechnology;
                    return PopupMenuItem<String>(
                      value: tech,
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? Colors.grey[300]
                                  : null,
                          borderRadius: BorderRadius.zero,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _getTechIcon(tech),
                              color: isSelected ? Colors.black : Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              tech,
                              style: TextStyle(
                                fontWeight:
                                    isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                color:
                                    isSelected
                                        ? Colors.black
                                        : Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList();
                },
                icon: Icon(Icons.filter_list, color: Colors.grey),
              ),
            ],
          ),
          // const SizedBox(height: 12),
          // Container(
          //   decoration: const BoxDecoration(
          //     color: Colors.white,
          //     boxShadow: [
          //       BoxShadow(
          //         color: Colors.black12,
          //         blurRadius: 4,
          //         offset: Offset(0, 4),
          //       ),
          //     ],
          //   ),
          //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          //   child: Row(
          //     spacing: 20,
          //     children: [
          //       _buildStat(
          //         Icons.person_outline,
          //         "Active",
          //         "${_presentList.length}",
          //         Colors.black,
          //         0,
          //       ),
          //       Container(width: 1, height: 40, color: Colors.grey[300]),
          //       _buildStat(
          //         Icons.person_outline,
          //         "Inactive",
          //         "${_unmarkedListData.length}",
          //         Colors.black,
          //         1,
          //       ),
          //       Container(width: 1, height: 40, color: Colors.grey[300]),
          //       _buildStat(
          //         Icons.groups_outlined,
          //         "Total",
          //         "${_presentList.length + _unmarkedListData.length}",
          //         Colors.black,
          //         2,
          //       ),
          //     ],
          //   ),
          // ),
                    SizedBox(height: screenHeight * 0.015),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 4))],
            ),
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
            child: Row(
              children: [
                _buildStat(Icons.person_outline, "Active", "${_presentList.length}", Colors.black, 0),
                Container(width: 1, height: screenHeight * 0.05, color: Colors.grey[300]),
                _buildStat(Icons.person_outline, "Inactive", "${_unmarkedListData.length}", Colors.black, 1),
                Container(width: 1, height: screenHeight * 0.05, color: Colors.grey[300]),
                _buildStat(Icons.groups_outlined, "Total", "${_presentList.length + _unmarkedListData.length}", Colors.black, 2),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xfff1f2f2),
      body: Column(
        children: [
          SafeArea(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton.outlined(
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                    style: ButtonStyle(
                      minimumSize: WidgetStateProperty.all(Size.square(36)),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Today's Attendance",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildSummarySection(screenWidth, screenHeight),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedTabIndex == 0
                              ? "Marked Students"
                              : _selectedTabIndex == 1
                              ? "Unmarked Students"
                              : "All Students",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (_selectedTabIndex == 0 || _selectedTabIndex == 2)
                          GestureDetector(
                            onTap: _downloadAndSharePresentList,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                shape: BoxShape.rectangle,
                                border: Border.all(width: 1),
                              ),
                              padding: const EdgeInsets.all(4),
                              child: const Icon(
                                Icons.download,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  _buildListWithFixedHeader(_getFilteredList()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _downloadAndSharePresentList() async {
    final List<Map<String, String>> listToExport = _getFilteredList();

    final String csvData = listToExport
        .map((row) {
          return "${row['roll']},${row['date']},${row['time']}";
        })
        .join("\n");

    final directory = await getApplicationDocumentsDirectory();
    final file = File("${directory.path}/attendance_export.csv");
    await file.writeAsString("Roll,Date,Time\n$csvData");

    Share.shareXFiles([XFile(file.path)], text: "Attendance Data");
  }

  Widget _buildListWithFixedHeader(List<Map<String, String>> dataList) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
          borderRadius: BorderRadius.zero,
        ),
        child: Column(
          children: [
            _buildListHeaderRow(),
            const Divider(height: 1),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 500),
              child:
                  dataList.isEmpty
                      ? const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text("No data available."),
                      )
                      : ListView.builder(
                        shrinkWrap: true,
                        itemCount: dataList.length,
                        itemBuilder: (context, index) {
                          final data = dataList[index];
                          return _buildStudentRow(
                            data['image'] ?? '',
                            data['roll'] ?? '',
                            data['date'] ?? '',
                            data['time'] ?? '',
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentRow(
    String imagePath,
    String rollNo,
    String date,
    String time,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Row(
              children: [
                ClipOval(
                  child: Image.network(
                    imagePath,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    rollNo,
                    style: GoogleFonts.poppins(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(date, style: GoogleFonts.poppins(fontSize: 12)),
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(time, style: GoogleFonts.poppins(fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListHeaderRow() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.zero,
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              "Roll No",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                "Date",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Time",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
