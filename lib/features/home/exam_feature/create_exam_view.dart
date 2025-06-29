import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_app/apis/fire_store_instance.dart';

class CreateExamView extends StatefulWidget {
  const CreateExamView({super.key});

  static route() => MaterialPageRoute(
        builder: (context) => const CreateExamView(),
      );

  @override
  CreateExamViewState createState() => CreateExamViewState();
}

class CreateExamViewState extends State<CreateExamView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _examNameController = TextEditingController();

  List<Question> questions = [Question()];

  @override
  Widget build(BuildContext context) {
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
                      questions.add(Question());
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
                      _saveExam();
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

  void _saveExam() {
    // Process the exam data
    final examName = _examNameController.text;
    final examQuestions = questions.map((q) => q.toMap()).toList();

    // Here you would typically save to a database or backend
    print({
      'examName': examName,
      'questions': examQuestions,
    });
    final user = <String, dynamic>{"first": "Ada", "last": "Lovelace", "born": 1815};

    FireStoreInstance.db
        .collection("users")
        .add(user)
        .then((DocumentReference doc) => print('qqq DocumentSnapshot added with ID: ${doc.id}'));

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

class Question {
  String content = '';
  List<String> options = ['', '', '', ''];
  int correctAnswerIndex = 2;

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
    };
  }
}
