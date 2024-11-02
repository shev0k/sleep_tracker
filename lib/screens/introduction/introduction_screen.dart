import 'package:sleeping_tracker_ui/themes/app_theme.dart';
import '../../components/views/introduction_screen_views/care_view.dart';
import '../../components/center_next_button.dart';
import '../../components/views/introduction_screen_views/mood_diary_vew.dart';
import '../../components/views/introduction_screen_views/relax_view.dart';
import '../../components/views/introduction_screen_views/splash_view.dart';
import '../../components/top_back_skip_bar.dart';
import '../../components/views/introduction_screen_views/welcome_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleeping_tracker_ui/screens/home/home_screen.dart';

class IntroductionAnimationScreen extends StatefulWidget {
  const IntroductionAnimationScreen({super.key});

  @override
  IntroductionAnimationScreenState createState() =>
      IntroductionAnimationScreenState();
}

class IntroductionAnimationScreenState
    extends State<IntroductionAnimationScreen> with TickerProviderStateMixin {
  AnimationController? _animationController;
  final TextEditingController _nameController = TextEditingController();



  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 8));
    _animationController?.animateTo(0.0);
    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _signUpClick() async {
    String name = _nameController.text;
    if (name.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', name);
      await prefs.setBool('hasSeenIntroduction', true);

      // Check if the widget is still mounted before navigating
      if (mounted) {
        // Navigate to the HomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } else {
      // Show a prettier error or warning from the top
      OverlayEntry overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          top: MediaQuery.of(context).padding.top + 10, // Adjust for status bar
          left: 20,
          right: 20,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 138, 116, 199),
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 2),
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: const Row(
                children: [
                  Icon(Icons.error, color: Colors.white),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Please enter your name.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      Overlay.of(context).insert(overlayEntry);

      // Optionally, you can remove the overlay after some time
      Future.delayed(const Duration(seconds: 3), () {
        overlayEntry.remove();
      });
    }
  }

  void _onSkipClick() {
    _animationController?.animateTo(0.8,
        duration: const Duration(milliseconds: 1200));
  }

  void _onBackClick() {
    if (_animationController!.value >= 0.8) {
      _animationController?.animateTo(0.6);
    } else if (_animationController!.value >= 0.6) {
      _animationController?.animateTo(0.4);
    } else if (_animationController!.value >= 0.4) {
      _animationController?.animateTo(0.2);
    } else if (_animationController!.value >= 0.2) {
      _animationController?.animateTo(0.0);
    }
    // If already at the first view, do nothing or handle accordingly
  }

  void _onNextClick() {
    if (_animationController!.value <= 0.0) {
      _animationController?.animateTo(0.2);
    } else if (_animationController!.value <= 0.2) {
      _animationController?.animateTo(0.4);
    } else if (_animationController!.value <= 0.4) {
      _animationController?.animateTo(0.6);
    } else if (_animationController!.value <= 0.6) {
      _animationController?.animateTo(0.8);
    } else if (_animationController!.value <= 0.8) {
      // Possibly handle the sign-up click if on the last view
      _signUpClick();
    }
    // If already at the last view, do nothing or handle accordingly
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.nearlyBlack,
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        behavior: HitTestBehavior.deferToChild,
        onPanStart: (details) {
        },
        onPanEnd: (details) {
          final dx = details.velocity.pixelsPerSecond.dx;
          final dy = details.velocity.pixelsPerSecond.dy;

          if (dx.abs() > dy.abs()) {
            // Horizontal swipe
            if (dx < -300) {
              // Swipe Left
              _onNextClick();
            } else if (dx > 300) {
              // Swipe Right
              _onBackClick();
            }
          } else {
            // Vertical swipe
            if (dy < -300) {
              // Swipe Up
              _onNextClick();
            } else if (dy > 300) {
              // Swipe Down
              _onBackClick();
            }
          }
        },
        child: ClipRect(
          child: Stack(
            children: [
              SplashView(
                animationController: _animationController!,
              ),
              RelaxView(
                animationController: _animationController!,
              ),
              CareView(
                animationController: _animationController!,
              ),
              MoodDiaryVew(
                animationController: _animationController!,
              ),
              WelcomeView(
                animationController: _animationController!,
                nameController: _nameController,
              ),
              TopBackSkipView(
                onBackClick: _onBackClick,
                onSkipClick: _onSkipClick,
                animationController: _animationController!,
              ),
              CenterNextButton(
                animationController: _animationController!,
                onNextClick: () {
                  if (_animationController!.value > 0.6 &&
                      _animationController!.value <= 0.8) {
                    _signUpClick();
                  } else {
                    _onNextClick();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
