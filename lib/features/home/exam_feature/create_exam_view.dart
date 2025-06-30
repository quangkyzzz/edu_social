import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_app/apis/exam_api.dart';
import 'package:social_app/features/auth/controller/auth_controller.dart';
import 'package:social_app/models/exam_model.dart';

class CreateExamView extends ConsumerStatefulWidget {
  const CreateExamView({super.key});

  static route() => MaterialPageRoute(
        builder: (context) => const CreateExamView(),
      );

  @override
  ConsumerState<CreateExamView> createState() => CreateExamViewState();
}

class CreateExamViewState extends ConsumerState<CreateExamView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _examNameController = TextEditingController();

  List<Question> questions = [
    Question(options: ['', '', '', ''])
  ];

  int hours = 0;
  int minutes = 30; // Default to 30 minutes
  int seconds = 0;

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.read(currentUserDetailProvider).value;

    return Scaffold(
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
                      _saveExam(userID: currentUser?.uid ?? 'unknow');
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

  void _saveExam({required String userID}) {
    // Process the exam data
    final examName = _examNameController.text;
    //final examQuestions = questions.map((q) => q.toMap()).toList();

    // final user = <String, dynamic>{"first": "Ada", "last": "Lovelace", "born": 1815};
    ExamModel exam = ExamModel(
      examName: examName,
      authorID: userID,
      memberID: ['12', '13', '14'],
      questions: questions,
      createAt: DateTime.now().millisecondsSinceEpoch,
      duration: Duration(hours: hours, minutes: minutes, seconds: seconds),
    );
    ExamApi().addNewExam(exam: exam);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Exam saved successfully!')),
    );
  }

  @override
  void dispose() {
    _examNameController.dispose();
    super.dispose();
  }
}
