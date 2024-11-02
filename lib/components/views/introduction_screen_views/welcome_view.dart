import 'package:flutter/material.dart';

class WelcomeView extends StatefulWidget {
  final AnimationController animationController;
  final TextEditingController nameController;

  const WelcomeView({
    super.key,
    required this.animationController,
    required this.nameController,
  });

  @override
  // ignore: library_private_types_in_public_api
  _WelcomeViewState createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Detect the bottom inset (keyboard height)
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    // Define smoother animation parameters
    const keyboardAnimationDuration = Duration(milliseconds: 50); // Typical keyboard duration
    const paddingAnimationDuration = keyboardAnimationDuration; // Match duration
    const paddingAnimationCurve = Curves.ease; // Align with system curve

    // Define SlideTransition animations with reduced offsets for smoother motion
    final firstHalfAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: const Interval(
          0.6,
          0.8,
          curve: Curves.fastOutSlowIn, // Changed curve for smoother transition
        ),
      ),
    );

    final secondHalfAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(-1, 0),
    ).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: const Interval(
          0.8,
          1.0,
          curve: Curves.fastOutSlowIn, // Changed curve for smoother transition
        ),
      ),
    );

    final welcomeFirstHalfAnimation = Tween<Offset>(
      begin: const Offset(2, 0), // Reduced offset for smoother motion
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: const Interval(
          0.6,
          0.8,
          curve: Curves.fastOutSlowIn, // Changed curve
        ),
      ),
    );

    final welcomeImageAnimation = Tween<Offset>(
      begin: const Offset(4, 0), // Reduced offset for smoother motion
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: const Interval(
          0.6,
          0.8,
          curve: Curves.fastOutSlowIn, // Changed curve
        ),
      ),
    );


    return GestureDetector(
      onTap: () {
        // Unfocus the text field when tapping outside
        _focusNode.unfocus();
      },
      child: AnimatedPadding(
        // Adjust the padding when the keyboard appears
        padding: EdgeInsets.only(bottom: bottomInset),
        duration: paddingAnimationDuration, // Synchronized duration
        curve: paddingAnimationCurve, // Synchronized curve
        child: SlideTransition(
          position: firstHalfAnimation,
          child: SlideTransition(
            position: secondHalfAnimation,
            child: SingleChildScrollView(
              // Ensures the content is scrollable when needed
              reverse: true,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 110,
                  bottom: 40, // Adjust if necessary
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SlideTransition(
                      position: welcomeImageAnimation,
                      child: Container(
                        constraints: const BoxConstraints(
                          maxWidth: 350,
                          maxHeight: 350,
                        ),
                        child: Image.asset(
                          'assets/introduction_animation/welcome.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SlideTransition(
                      position: welcomeFirstHalfAnimation,
                      child: const Text(
                        "Welcome",
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 64,
                        vertical: 16,
                      ),
                      child: Text(
                        "Enter your name to start your journey toward better sleep",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 65,
                        vertical: 0,
                      ),
                      child: TextField(
                        controller: widget.nameController,
                        focusNode: _focusNode,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                        decoration: const InputDecoration(
                          labelText: "How should we call you?",
                          labelStyle: TextStyle(
                            color: Colors.white70,
                            fontSize: 14.5,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 138, 116, 199),
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 138, 116, 199),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
