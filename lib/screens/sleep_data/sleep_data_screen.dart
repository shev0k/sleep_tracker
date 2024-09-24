// lib/screens/sleep_data_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sleeping_tracker_ui/models/(sleep)/sleep_data_state.dart';
import 'package:sleeping_tracker_ui/components/widgets/(sleep)/sleep_phase_card.dart';
import 'package:sleeping_tracker_ui/components/widgets/(sleep)/continue_button.dart';

class SleepDataScreen extends StatefulWidget {
  const SleepDataScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SleepDataScreenState createState() => _SleepDataScreenState();
}

class _SleepDataScreenState extends State<SleepDataScreen>
    with TickerProviderStateMixin {
  SleepDataState _currentState = SleepDataState.notConnected;
  SleepDataState _previousState = SleepDataState.notConnected;

  late AnimationController _fadeController;
  late Animation<double> _fadeOutAnimation;
  late Animation<double> _fadeInAnimation;

  late AnimationController _buttonWidthController;
  late Animation<double> _buttonWidthAnimation;

  late AnimationController _successAnimationController;

  final List<Timer> _timers = [];

  // Screen 2 button appearance
  bool _showContinueButton = false;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeOutAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    _buttonWidthController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _buttonWidthAnimation = Tween<double>(begin: 200.0, end: 80.0).animate(
      CurvedAnimation(
        parent: _buttonWidthController,
        curve: Curves.easeInOut,
      ),
    );

    _successAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Lottie animations
    _preloadLottieAnimations();
  }

  void _preloadLottieAnimations() {
    Lottie.asset('assets/animations/loading.json');
    Lottie.asset('assets/animations/success.json');
    Lottie.asset('assets/animations/sleeping.json');
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _buttonWidthController.dispose();
    _successAnimationController.dispose();
    for (var timer in _timers) {
      timer.cancel();
    }
    super.dispose();
  }

  void _changeState(SleepDataState newState) {
    setState(() {
      _previousState = _currentState;
      _currentState = newState;

      // cancel pending timers
      for (var timer in _timers) {
        timer.cancel();
      }
      _timers.clear();

      // reset state variables
      if (_currentState != SleepDataState.gatheringData) {
        _showContinueButton = false;
      }

      // if the state change is within the same screen or between screens
      bool isSameScreen =
          (_getScreenForState(_previousState) == _getScreenForState(_currentState));

      // fade animations only if within the same screen
      if (isSameScreen) {
        _fadeController.reset();
        _fadeController.forward();
      }

      // button width animation if connecting or connected
      if (_currentState == SleepDataState.connecting ||
          _currentState == SleepDataState.connected) {
        _buttonWidthController.forward();
      } else if (_currentState == SleepDataState.notConnected) {
        _buttonWidthController.reverse();
      }

      // success animation when entering connected state
      if (_currentState == SleepDataState.connected) {
        _successAnimationController.reset();
        _successAnimationController.forward();
      }

      // handle specific states
      if (_currentState == SleepDataState.gatheringData) {
        _enterGatheringDataState();
      }
    });
  }

  String _getScreenForState(SleepDataState state) {
    switch (state) {
      case SleepDataState.notConnected:
      case SleepDataState.connecting:
      case SleepDataState.connected:
        return 'ConnectWatchScreen';
      case SleepDataState.gatheringData:
        return 'GatheringDataScreen';
      case SleepDataState.dataAvailable:
        return 'DataAvailableScreen';
    }
  }

  void _enterGatheringDataState() {
    // timer to show the continue button after 2 seconds
    Timer timer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _showContinueButton = true;
      });
    });
    _timers.add(timer);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Sleep Data",
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            layoutBuilder:
                (Widget? currentChild, List<Widget> previousChildren) {
              return Stack(
                alignment: Alignment.topCenter,
                children: [
                  ...previousChildren,
                  if (currentChild != null) currentChild,
                ],
              );
            },
            child: SizedBox(
              key: ValueKey(_getScreenForState(_currentState)),
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: _buildBody(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentState) {
      case SleepDataState.notConnected:
      case SleepDataState.connecting:
      case SleepDataState.connected:
        return _buildConnectWatchScreen();
      case SleepDataState.gatheringData:
        return _buildGatheringDataScreen();
      case SleepDataState.dataAvailable:
        return _buildDataAvailableScreen();
    }
  }

  // methods to get content based on state
  String _getTitle(SleepDataState state) {
    switch (state) {
      case SleepDataState.connecting:
        return "Connecting Your Smartwatch";
      case SleepDataState.connected:
        return "Smartwatch Has Connected";
      case SleepDataState.gatheringData:
        return "Gathering Sleep Information";
      case SleepDataState.dataAvailable:
        return "Your Sleep Data";
      default:
        return "Connect Your Smartwatch";
    }
  }

  String _getMessage(SleepDataState state) {
    switch (state) {
      case SleepDataState.connecting:
        return "Please wait while we're connecting to your device...";
      case SleepDataState.connected:
        return "Connection successful! Waiting to proceed with the next step.";
      case SleepDataState.gatheringData:
        return "It'll take a few nights to gather enough data. Please check back soon!";
      case SleepDataState.dataAvailable:
        return "Here is your sleep data.";
      default:
        return "To start tracking your sleep patterns, please connect your smartwatch.";
    }
  }

  // return appropriate icon or animation widget based on state
  Widget _getIconWidget(SleepDataState state) {
    Widget widget;
    switch (state) {
      case SleepDataState.connecting:
        widget = Lottie.asset(
          'assets/animations/loading.json',
          width: 250,
          height: 150,
        );
        break;
      case SleepDataState.connected:
        widget = Lottie.asset(
          'assets/animations/success.json',
          width: 150,
          height: 150,
          repeat: false,
          controller: _successAnimationController,
        );
        break;
      case SleepDataState.gatheringData:
        widget = Lottie.asset(
          'assets/animations/sleeping.json',
          width: 120,
          height: 150,
        );
        break;
      default:
        widget = Icon(
          _getIconData(state),
          size: 120,
          color: Colors.white,
        );
    }

    // prevent other elements from moving when size changes
    return SizedBox(
      width: 250,
      height: 150,
      child: Center(child: widget),
    );
  }

  IconData _getIconData(SleepDataState state) {
    switch (state) {
      case SleepDataState.connecting:
        return Icons.sync;
      case SleepDataState.connected:
        return Icons.check_circle;
      default:
        return Icons.watch_rounded;
    }
  }

  Widget _buildConnectWatchScreen() {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Center(
        child: AnimatedBuilder(
          animation: _fadeController,
          builder: (context, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Opacity(
                      opacity: _fadeOutAnimation.value,
                      child: Text(
                        _getTitle(_previousState),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: _fadeInAnimation.value,
                      child: Text(
                        _getTitle(_currentState),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Icon or Animation
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Opacity(
                      opacity: _fadeOutAnimation.value,
                      child: _getIconWidget(_previousState),
                    ),
                    Opacity(
                      opacity: _fadeInAnimation.value,
                      child: _getIconWidget(_currentState),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Message
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Opacity(
                      opacity: _fadeOutAnimation.value,
                      child: Text(
                        _getMessage(_previousState),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: _fadeInAnimation.value,
                      child: Text(
                        _getMessage(_currentState),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 18),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                // show button only in specific states
                if (_currentState == SleepDataState.notConnected ||
                    _currentState == SleepDataState.connecting ||
                    _currentState == SleepDataState.connected)
                  AnimatedBuilder(
                    animation: _buttonWidthController,
                    builder: (context, child) {
                      return SizedBox(
                        width: _buttonWidthAnimation.value,
                        child: ElevatedButton(
                          onPressed:
                              (_currentState == SleepDataState.notConnected)
                                  ? _connectWatch
                                  : (_currentState == SleepDataState.connected)
                                      ? () {
                                          _changeState(
                                              SleepDataState.gatheringData);
                                        }
                                      : null, // disable button during connecting state
                          style: ButtonStyle(
                            foregroundColor:
                                WidgetStateProperty.all(Colors.black),
                            backgroundColor:
                                WidgetStateProperty.all(Colors.white),
                            padding: WidgetStateProperty.all(
                                const EdgeInsets.symmetric(vertical: 15)),
                            textStyle:
                                WidgetStateProperty.all(const TextStyle(fontSize: 18)),
                          ),
                          child: _buildButtonChild(),
                        ),
                      );
                    },
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildButtonChild() {
    if (_currentState == SleepDataState.connecting ||
        _currentState == SleepDataState.connected) {
      // animate between loading animation and success icon
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: _currentState == SleepDataState.connecting
            ? const SizedBox(
                key: ValueKey('loading'),
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              )
            : const Icon(
                Icons.check,
                key: ValueKey('success'),
                color: Colors.black,
                size: 24,
              ),
      );
    } else if (_currentState == SleepDataState.notConnected) {
      // default state: Show "Connect Watch" with icon and text
      return const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.link),
          SizedBox(width: 10),
          Text("Connect Watch"),
        ],
      );
    } else {
      // for other states, return empty container to prevent brief appearance
      return const SizedBox.shrink();
    }
  }

  void _connectWatch() {
    _changeState(SleepDataState.connecting);

    // simulate connection process with delays
    Timer timer1 = Timer(const Duration(seconds: 4), () {
      if (!mounted) return;
      // transition to connected state
      _changeState(SleepDataState.connected);

      // delay before moving to the next state
      Timer timer2 = Timer(const Duration(seconds: 5), () {
        if (!mounted) return;
        _changeState(SleepDataState.gatheringData);
      });
      _timers.add(timer2);
    });
    _timers.add(timer1);
  }

  // Screen 2: Gathering Data Screen with Lottie Animation
  Widget _buildGatheringDataScreen() {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _getTitle(_currentState),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _getIconWidget(_currentState),
            const SizedBox(height: 20),
            Text(
              _getMessage(_currentState),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 25),
            // reserve space for the Continue button
            SizedBox(
              height: 50, // button's height
              child: AnimatedOpacity(
                opacity: _showContinueButton ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: ContinueButton(onPressed: _simulateDataCollected),
              ),),
          ],
        ),
      ),
    );
  }

  Widget _buildDataAvailableScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sleep Duration Section
          Text(
            "Sleep Duration",
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          _buildRoundedCard(
            child: Padding(
              padding: const EdgeInsets.all(5.0), 
              child: Column(
                children: [
                  Text(
                    "Your Total Sleep Over Time",
                    style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16),
                  ),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: SizedBox(
                      height: 120, 
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: true,
                            verticalInterval: 1,
                            horizontalInterval: 1,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: Colors.white.withOpacity(0.2),
                                strokeWidth: 1,
                                dashArray: [5, 5],
                              );
                            },
                            getDrawingVerticalLine: (value) {
                              return FlLine(
                                color: Colors.white.withOpacity(0.2),
                                strokeWidth: 1,
                                dashArray: [5, 5],
                              );
                            },
                          ),
                          borderData: FlBorderData(show: false),
                          titlesData: const FlTitlesData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: [
                                const FlSpot(0, 7.5),
                                const FlSpot(1, 6.5),
                                const FlSpot(2, 8.0),
                                const FlSpot(3, 5.5),
                                const FlSpot(4, 7.8),
                              ],
                              isCurved: true,
                              barWidth: 3,
                              color: Colors.white,
                              belowBarData: BarAreaData(
                                show: true,
                                color: Colors.white.withOpacity(0.2),
                              ),
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, barData, index) =>
                                    FlDotCirclePainter(
                                  radius: 5.5, // Dot radius
                                  color: const Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                            ),
                          ],
                          // LineTouchData to show black background for tooltips
                          lineTouchData: LineTouchData(
                            touchTooltipData: LineTouchTooltipData(
                              tooltipPadding: const EdgeInsets.all(8),
                              tooltipRoundedRadius: 4,
                              tooltipMargin: 16,
                              getTooltipColor: (touchedSpot) => Colors.black,
                              getTooltipItems: (touchedSpots) {
                                return touchedSpots.map((touchedSpot) {
                                  return LineTooltipItem(
                                    '${touchedSpot.y}',
                                    const TextStyle(
                                      color: Colors.white, 
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  );
                                }).toList();
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Last 5 Days",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),
          // Sleep Phases Section
          Text(
            "Sleep Phases",
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          const SleepPhaseCard(
            title: "Deep Sleep",
            hours: "3 hours",
            icon: Icons.brightness_3,
            color: Colors.white,
            description:
                "Deep sleep is a stage of sleep that is important for physical restoration.",
          ),
          const SizedBox(height: 15),
          const SleepPhaseCard(
            title: "Light Sleep",
            hours: "4 hours",
            icon: Icons.brightness_5,
            color: Colors.white,
            description:
                "Light sleep is the transition from wakefulness to sleep, preparing your body for deeper stages.",
          ),
          const SizedBox(height: 15),
          const SleepPhaseCard(
            title: "REM Sleep",
            hours: "1.5 hours",
            icon: Icons.bedtime,
            color: Colors.white,
            description:
                "REM sleep is when most dreaming occurs and is important for mental restoration.",
          ),
        ],
      ),
    );
  }

  Widget _buildRoundedCard({required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }

  void _simulateDataCollected() {
    _changeState(SleepDataState.dataAvailable);
  }
}
