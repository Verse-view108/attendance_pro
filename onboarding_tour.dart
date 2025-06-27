import 'package:flutter/material.dart';
import 'package:flutter_intro/flutter_intro.dart';

class OnboardingTour extends StatefulWidget {
  const OnboardingTour({Key? key}) : super(key: key);

  @override
  _OnboardingTourState createState() => _OnboardingTourState();
}

class _OnboardingTourState extends State<OnboardingTour> {
  final Intro _intro = Intro(stepCount: 3);

  @override
  void initState() {
    super.initState();
    _intro.setStep(0, 'Mark Attendance', 'Tap here to mark attendance', key: GlobalKey());
    _intro.setStep(1, 'View Timetable', 'Check your schedule', key: GlobalKey());
    _intro.setStep(2, 'Submit Assignments', 'Upload your work', key: GlobalKey());
    _intro.start(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome to AttendancePro')),
      body: Center(
        child: Text('Start your onboarding tour!'),
      ),
    );
  }
}
