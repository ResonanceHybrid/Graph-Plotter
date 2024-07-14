import 'package:epc/appbar.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Map<String, Map<int, int>> facultyFullMarks = {
    'BCT': {
      1: 800,
      2: 700,
      3: 800,
      4: 800,
      5: 800,
      6: 800,
      7: 800,
      8: 800,
    },
    'BCE': {
      1: 750,
      2: 720,
      3: 700,
      4: 750,
      5: 780,
      6: 760,
      7: 790,
      8: 780,
    },
    'BEI': {
      1: 800,
      2: 650,
      3: 700,
      4: 750,
      5: 780,
      6: 900,
      7: 900,
      8: 780,
    },
  };

  String selectedFaculty = 'BCT';
  Map<int, int?> marksObtained = {
    1: 0,
    2: 0,
    3: 0,
    4: 0,
    5: 0,
    6: 0,
    7: 0,
    8: 0,
  };

  final _formKey = GlobalKey<FormState>();
  final Map<int, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    for (int i = 1; i <= 8; i++) {
      _controllers[i] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (int i = 1; i <= 8; i++) {
      _controllers[i]?.dispose();
    }
    super.dispose();
  }

  double calculateOverallPercentage() {
    int totalObtained = 0;
    int totalFullMarks = 0;

    marksObtained.forEach((semester, marks) {
      if (marks != null) totalObtained += marks;
    });

    facultyFullMarks[selectedFaculty]?.forEach((semester, marks) {
      totalFullMarks += marks;
    });

    if (totalFullMarks == 0) return 0;

    return (totalObtained / totalFullMarks) * 100;
  }

  String getFeedback(double percentage) {
    if (percentage >= 90) {
      return " Excellent";
    } else if (percentage >= 75) {
      return " Very Good";
    } else if (percentage >= 50) {
      return " Good";
    } else if (percentage == 0) {
      return " ";
    } else {
      return " You Need Some Improvements";
    }
  }

  @override
  Widget build(BuildContext context) {
    const kblue = Color(0xFF71b8ff);
    return SafeArea(
      child: Scaffold(
        appBar: OtherPageAppBar(heading: "Graph Plotter"),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      Center(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 10.0,
                          children: facultyFullMarks.keys.map((faculty) {
                            return ChoiceChip(
                              label: Text(
                                faculty,
                                style: TextStyle(
                                  color: selectedFaculty == faculty
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              selected: selectedFaculty == faculty,
                              selectedColor: kblue,
                              onSelected: (selected) {
                                setState(() {
                                  selectedFaculty = faculty;
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Bar chart container
                      Container(
                        height: 270,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: BarChart(
                            BarChartData(
                              borderData: FlBorderData(show: true),
                              barGroups: List.generate(8, (index) {
                                int semester = index + 1;
                                double percentage =
                                    (marksObtained[semester] ?? 0) /
                                        (facultyFullMarks[selectedFaculty]![
                                                semester] ??
                                            1) *
                                        100;
                                return BarChartGroupData(
                                  x: semester,
                                  barRods: [
                                    BarChartRodData(
                                      toY: percentage,
                                      color: Colors.blue,
                                      width: 15,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5)),
                                    ),
                                  ],
                                );
                              }),
                              gridData: FlGridData(show: true),
                              barTouchData: BarTouchData(
                                touchTooltipData: BarTouchTooltipData(
                                  getTooltipItem:
                                      (group, groupIndex, rod, rodIndex) {
                                    return BarTooltipItem(
                                      rod.toY.toStringAsFixed(2) + '%',
                                      TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Overall percentage display
                      Center(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Overall Percentage:',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  ' ${calculateOverallPercentage().toStringAsFixed(2)}%',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: kblue,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(children: [
                              Text(
                                'Feedback:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                getFeedback(calculateOverallPercentage()),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: kblue,
                                ),
                              ),
                            ])
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(8, (index) {
                            int semester = index + 1;
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Semester $semester:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Container(
                                    width: 100,
                                    child: TextFormField(
                                      controller: _controllers[semester],
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(3),
                                      ],
                                      onChanged: (value) {
                                        int? enteredMarks = int.tryParse(value);
                                        if (enteredMarks != null &&
                                            enteredMarks <=
                                                facultyFullMarks[
                                                        selectedFaculty]![
                                                    semester]!) {
                                          setState(() {
                                            marksObtained[semester] =
                                                enteredMarks;
                                          });
                                        } else {
                                          setState(() {
                                            marksObtained[semester] = null;
                                          });
                                        }
                                        _formKey.currentState?.validate();
                                      },
                                      validator: (value) {
                                        int? enteredMarks =
                                            int.tryParse(value ?? '');
                                        if (enteredMarks != null &&
                                            enteredMarks >
                                                facultyFullMarks[
                                                        selectedFaculty]![
                                                    semester]!) {
                                          return 'Max: ${facultyFullMarks[selectedFaculty]![semester]}';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Marks',
                                        labelStyle:
                                            TextStyle(color: Colors.black),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        errorStyle:
                                            TextStyle(color: Colors.red),
                                      ),
                                      style: TextStyle(color: Colors.black),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
