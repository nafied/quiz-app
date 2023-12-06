import 'package:flutter/material.dart';
import 'dart:async'; // Import 'dart:async' for Future.delayed
import 'quiz_styles.dart';

void main() {
  runApp(QuizApp());
}

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: QuizScreen(),
    );
  }
}

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  int totalScore = 0;
  List<int> selectedAnswerIndices =
      List.generate(10, (index) => -1); // Initialize as a list of -1 values
  bool isAnsweredCorrectly = false; // Initialize as false by default

  List<Map<String, dynamic>> questions = [
    {
      'question': 'What is the capital of France?',
      'options': ['London', 'Berlin', 'Paris', 'Madrid'],
      'correctAnswerIndex': 2,
    },
    {
      'question': 'Which planet is known as the Red Planet?',
      'options': ['Earth', 'Mars', 'Venus', 'Jupiter'],
      'correctAnswerIndex': 1,
    },
    {
      'question': 'What is the largest mammal on Earth?',
      'options': ['Elephant', 'Blue Whale', 'Giraffe', 'Hippopotamus'],
      'correctAnswerIndex': 1,
    },
    {
      'question': 'Which gas do plants absorb from the atmosphere?',
      'options': ['Oxygen', 'Carbon Dioxide', 'Nitrogen', 'Methane'],
      'correctAnswerIndex': 1,
    },
    {
      'question': 'Which famous scientist developed the theory of relativity?',
      'options': [
        'Isaac Newton',
        'Niels Bohr',
        'Galileo Galilei',
        'Albert Einstein'
      ],
      'correctAnswerIndex': 3,
    },
    {
      'question': 'What is the chemical symbol for gold?',
      'options': ['Go', 'Ag', 'Au', 'Gd'],
      'correctAnswerIndex': 2,
    },
    {
      'question': 'Which country is known as the Land of the Rising Sun?',
      'options': ['China', 'South Korea', 'Japan', 'Vietnam'],
      'correctAnswerIndex': 2,
    },
    {
      'question': 'What is the largest organ in the human body?',
      'options': ['Brain', 'Heart', 'Liver', 'Skin'],
      'correctAnswerIndex': 3,
    },
    {
      'question': 'What is the capital of Bangladesh?',
      'options': ['London', 'Dhaka', 'Paris', 'Madrid'],
      'correctAnswerIndex': 1,
    },
    {
      'question': 'What is the capital of India?',
      'options': ['London', 'Delhi', 'Paris', 'Madrid'],
      'correctAnswerIndex': 1,
    },
    // Add more questions here...
  ];

  void checkAnswer(int selectedAnswerIndex) {
    if (selectedAnswerIndex ==
        questions[currentQuestionIndex]['correctAnswerIndex']) {
      setState(() {
        totalScore++;
        selectedAnswerIndices[currentQuestionIndex] =
            selectedAnswerIndex; // Mark the answer as correct
        isAnsweredCorrectly = true;
      });
    } else {
      setState(() {
        selectedAnswerIndices[currentQuestionIndex] =
            selectedAnswerIndex; // Mark the answer as wrong
        isAnsweredCorrectly = false;
      });
    }

    // Delay for 1 second before moving to the next question
    Future.delayed(Duration(seconds: 1), () {
      nextQuestion();
    });
  }

  void nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        isAnsweredCorrectly = false; // Reset the answer status
      });
    } else {
      // End of the quiz
      showResultDialog();
    }
  }

  void resetQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      totalScore = 0;
      selectedAnswerIndices =
          List.generate(10, (index) => -1); // Reset selected answers
      isAnsweredCorrectly = false; // Reset the answer status
    });
  }

  void showResultDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Quiz Results'),
          content: Text('Your score: $totalScore / ${questions.length}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetQuiz();
              },
              child: Text('Play Again'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Quiz App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Question ${currentQuestionIndex + 1}/${questions.length}',
              textAlign: TextAlign.center,
              style: QuizStyles.questionTextStyle,
            ),
            SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.circle), // Add a bullet point sign
              title: Text(
                questions[currentQuestionIndex]['question'],
                style: QuizStyles.questionTextStyle,
              ),
            ),
            SizedBox(height: 20),
            Column(
              children: List.generate(
                questions[currentQuestionIndex]['options'].length,
                (index) {
                  final isCorrect =
                      selectedAnswerIndices[currentQuestionIndex] == index;
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 5.0), // Increase the vertical padding
                    child: ElevatedButton(
                      onPressed: () {
                        checkAnswer(index);
                      },
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(
                          Size(200.0, 45.0), // Set specific width and height
                        ),
                        backgroundColor: MaterialStateProperty.all(
                          isCorrect
                              ? Colors
                                  .green // Set button color to green for correct answer
                              : selectedAnswerIndices[currentQuestionIndex] ==
                                      index
                                  ? Colors
                                      .red // Set button color to red for wrong answer
                                  : Colors
                                      .blue, // Default color for unselected options
                        ),
                        padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(
                              vertical: 4.0,
                              horizontal: 5.0), // Reduce horizontal padding
                        ),
                      ),
                      child: Text(
                        questions[currentQuestionIndex]['options'][index],
                        style: QuizStyles.answerTextStyle.copyWith(
                            color: Colors.white), // Set text color to white
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Correct Answers: $totalScore',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
