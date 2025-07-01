import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_app/apis/exam_api.dart';
import 'package:social_app/common/loading_view.dart';
import 'package:social_app/features/auth/controller/auth_controller.dart';
import 'package:social_app/features/explore/controller/explore_controller.dart';
import 'package:social_app/models/exam_model.dart';
import 'package:social_app/models/user_model.dart';

class CreateExamView extends ConsumerStatefulWidget {
  const CreateExamView({super.key});

  static route() => MaterialPageRoute(
        builder: (context) => const CreateExamView(),
      );

  @override
  ConsumerState<CreateExamView> createState() => CreateExamViewState();
}

class CreateExamViewState extends ConsumerState<CreateExamView> {
  List<UserModel> followingUserList = [];
  String currentExamId = '';
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _examNameController = TextEditingController();
  final TextEditingController _studentSearchController = TextEditingController();

  List<Question> questions = [
    Question(options: ['', '', '', ''])
  ];

  int hours = 0;
  int minutes = 30; // Default to 30 minutes
  int seconds = 0;

  List<String> selectedStudentIds = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.read(currentUserDetailProvider).value;
    if (currentUser == null) {
      return const LoadingPage();
    }
    followingUserList = ref.watch(getFollowingUserProvider(currentUser.following)).value ?? [];
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Create Exam'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                maxLines: null,
                controller: _examNameController,
                decoration: InputDecoration(
                  labelText: 'Exam Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a exam name';
                  }
                  return null;
                },
              ),

              //Enter duration
              Text(
                'Exam Duration',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  // Hours
                  Expanded(
                    child: TextFormField(
                      maxLength: 2,
                      keyboardType: TextInputType.numberWithOptions(),
                      decoration: InputDecoration(
                        labelText: 'Hours',
                        border: OutlineInputBorder(),
                        counterText: '',
                      ),
                      initialValue: '0',
                      onChanged: (value) {
                        hours = int.tryParse(value) ?? 0;
                      },
                    ),
                  ),
                  SizedBox(width: 10),

                  // Minutes
                  Expanded(
                    child: TextFormField(
                      maxLength: 2,
                      keyboardType: TextInputType.numberWithOptions(),
                      decoration: InputDecoration(
                        labelText: 'Minutes',
                        border: OutlineInputBorder(),
                        counterText: '',
                      ),
                      initialValue: '30',
                      onChanged: (value) {
                        minutes = int.tryParse(value) ?? 0;
                      },
                    ),
                  ),
                  SizedBox(width: 10),

                  // Seconds
                  Expanded(
                    child: TextFormField(
                      maxLength: 2,
                      keyboardType: TextInputType.numberWithOptions(),
                      decoration: InputDecoration(
                        labelText: 'Seconds',
                        border: OutlineInputBorder(),
                        counterText: '',
                      ),
                      initialValue: '0',
                      onChanged: (value) {
                        seconds = int.tryParse(value) ?? 0;
                      },
                    ),
                  ),
                ],
              ),

              //Add student
              SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.group),
                    label: Row(
                      children: [
                        Text('Add Participants'),
                        SizedBox(width: 10),
                        if (selectedStudentIds.isNotEmpty)
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              selectedStudentIds.length.toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                      ],
                    ),
                    onPressed: _showStudentSelectionDialog,
                  ),
                ],
              ),

              SizedBox(height: 20),
              Text(
                'Questions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  return _buildQuestionCard(index);
                },
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.add),
                  label: Text('Add Question'),
                  onPressed: () {
                    setState(() {
                      questions.add(Question(options: ['', '', '', '']));
                    });
                  },
                ),
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Save the exam data
                      _saveExam(userID: currentUser.uid);
                    }
                  },
                  child: Text('Save Exam'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionCard(int questionIndex) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${questionIndex + 1}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 10),
            TextFormField(
              maxLines: null,
              decoration: InputDecoration(
                labelText: 'Question Content',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the question';
                }
                return null;
              },
              onChanged: (value) {
                questions[questionIndex].content = value;
              },
            ),
            SizedBox(height: 15),
            Text('Options', style: TextStyle(fontWeight: FontWeight.bold)),
            ...List.generate(4, (optionIndex) {
              return Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        maxLines: null,
                        decoration: InputDecoration(
                          labelText: 'Option ${optionIndex + 1}',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter option ${optionIndex + 1}';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          questions[questionIndex].options[optionIndex] = value;
                        },
                      ),
                    ),
                    Radio(
                      value: optionIndex,
                      groupValue: questions[questionIndex].correctAnswerIndex,
                      onChanged: (value) {
                        setState(() {
                          questions[questionIndex].correctAnswerIndex = value ?? 2;
                        });
                      },
                    ),
                  ],
                ),
              );
            }),
            SizedBox(height: 10),
            if (questions.length > 1)
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      questions.removeAt(questionIndex);
                    });
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  _showStudentSelectionDialog() {
    // Temporary list to hold selections while in dialog
    List<String> tempSelectedIds = List.from(selectedStudentIds);
    List<UserModel> filteredStudents = followingUserList;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDiaLog) {
            return AlertDialog(
              title: Text('Select Participants'),
              content: Container(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Search Bar
                    TextField(
                      onChanged: (value) {
                        final query = _studentSearchController.text.toLowerCase();
                        setStateDiaLog(() {
                          filteredStudents = followingUserList.where((student) {
                            return student.name.toLowerCase().contains(query) ||
                                student.email.toLowerCase().contains(query);
                          }).toList();
                        });
                      },
                      controller: _studentSearchController,
                      decoration: InputDecoration(
                        labelText: 'Search for Participants',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                        suffixIcon: _studentSearchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () {
                                  _studentSearchController.clear();
                                  setStateDiaLog(() {
                                    filteredStudents = followingUserList;
                                  });
                                  //_filterStudents();
                                },
                              )
                            : null,
                      ),
                    ),
                    SizedBox(height: 16),

                    // Selected Students Chips
                    // if (tempSelectedIds.isNotEmpty) ...[
                    //   Wrap(
                    //     spacing: 8.0,
                    //     children: tempSelectedIds.map((studentId) {
                    //       final student = allStudents.firstWhere((s) => s.id == studentId);
                    //       return Chip(
                    //         label: Text(student.name),
                    //         onDeleted: () {
                    //           setStateDiaLog(() {
                    //             tempSelectedIds.remove(studentId);
                    //           });
                    //         },
                    //       );
                    //     }).toList(),
                    //   ),
                    //   SizedBox(height: 16),
                    // ],

                    // Student List
                    Container(
                      height: (MediaQuery.of(context).viewInsets.bottom > 0) ? 180 : 400,
                      child: Scrollbar(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: filteredStudents.length,
                          itemBuilder: (context, index) {
                            final student = filteredStudents[index];
                            final isSelected = tempSelectedIds.contains(student.uid);

                            return CheckboxListTile(
                              contentPadding: EdgeInsets.symmetric(horizontal: 4),
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(student.profilePic),
                                    radius: 20,
                                  ),
                                  SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(student.name),
                                      Text(
                                        student.email,
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              value: isSelected,
                              onChanged: (bool? value) {
                                setStateDiaLog(() {
                                  if (value == true) {
                                    tempSelectedIds.add(student.uid);
                                  } else {
                                    tempSelectedIds.remove(student.uid);
                                  }
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: Text('Confirm'),
                  onPressed: () {
                    setState(() {
                      selectedStudentIds = tempSelectedIds;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _saveExam({required String userID}) async {
    // Process the exam data
    final examName = _examNameController.text;
    if (selectedStudentIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Your must choose at least one participant')),
      );
      return;
    }
    ;

    ExamModel exam = ExamModel(
      examName: examName,
      authorID: userID,
      memberID: selectedStudentIds,
      questions: questions,
      createAt: DateTime.now().millisecondsSinceEpoch,
      duration: Duration(hours: hours, minutes: minutes, seconds: seconds),
    );
    if (currentExamId.isEmpty) {
      currentExamId = await ExamApi().addNewExam(exam: exam);
    } else {
      await ExamApi().updateExam(examId: currentExamId, newData: exam);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Exam saved successfully!')),
    );
  }

  @override
  void dispose() {
    _examNameController.dispose();
    _studentSearchController.dispose();
    super.dispose();
  }
}
