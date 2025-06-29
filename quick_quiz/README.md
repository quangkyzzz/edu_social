# Quick Quiz

Quick Quiz package for flutter offers a seamless solution for developers to integrate text-based interactive quiz functionality into their applications. With it's user-friendly interface, Quick Quiz allows you to create engaing quizzes with minimal effort.
 
# Screen Shots
<table>
  <tr>
    <td><img src="https://github.com/poudelkiran/quick_quiz/blob/main/screenshots/question.png"></td>
    <td><img src="https://github.com/poudelkiran/quick_quiz/blob/main/screenshots/score.png"></td>
    <td><img src="https://github.com/poudelkiran/quick_quiz/blob/main/screenshots/review.png"></td>
  </tr>
 </table>

## Features
* Effortless MCQ Integration: Quickly add multiple-choice questions (MCQs) to your app with simple configurations.
* Customizable Quiz Timing: Set specific time limits for each quiz to enhance the challenge and user engagement.
* Answer Review: After completing the quiz, users can review their answers, helping them learn from their mistakes and reinforcing their knowledge.
* User-Friendly Interface: Designed with an intuitive layout for easy navigation, making it simple for users to focus on answering questions.

## Getting Started

Add the dependency in `pubspec.yaml`:

```yaml
dependencies:
  quick_quiz: ^1.0.0
```

Then, run `flutter pub get` to install the package.
## Usage

### Example

Prepare quiz model
```dart
       final quiz = Quiz(
      questions: [
        QuestionModel(
          question: 'How is acceleration related to mass and force according to Newton\'s second law of motion?',
          options: ['Acceleration is directly proportional to mass and inversely proportional to force', 'Acceleration is directly proportional to force and mass', 'Acceleration is inversely proportional to mass and force', 'Acceleration is inversely proportional to force and directly proportional to mass'],
          correctAnswerIndex: 0,
        ),
        QuestionModel(
          question: 'What is the largest planet in our solar system?',
          options: ['Earth', 'Jupiter', 'Mars', 'Saturn'],
          correctAnswerIndex: 1,
        ),
        QuestionModel(
          question: 'Which animal is known as the "King of the Jungle"?',
          options: ['Tiger', 'Lion', 'Elephant', 'Bear'],
          correctAnswerIndex: 1,
        ),
      ],
      timerDuration: 30,
    );  
```

Implement Quiz Page
```dart
       Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz'),
        ),
        body: QuizPage(quiz: quiz));
  }
```

See example for better understanding.
