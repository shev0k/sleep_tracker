import 'package:flutter/material.dart';
import 'dart:async';

import 'package:sleeping_tracker_ui/models/(home)/garden_item.dart';
import 'package:sleeping_tracker_ui/models/(home)/obtained_item.dart';
import 'package:sleeping_tracker_ui/components/widgets/(home)/transform_box.dart';
import 'package:sleeping_tracker_ui/components/widgets/(home)/rounded_card.dart';
import 'package:sleeping_tracker_ui/components/widgets/(home)/image_rounded_card.dart';
import 'package:sleeping_tracker_ui/components/widgets/(home)/bottom_button.dart';
import 'package:sleeping_tracker_ui/services/sleep_score_service.dart';
import 'package:sleeping_tracker_ui/utils/(home)/position_helper.dart';
import 'package:sleeping_tracker_ui/services/data_provider.dart';
import 'package:sleeping_tracker_ui/screens/daily_challenges/daily_challenges_screen.dart';
import 'package:sleeping_tracker_ui/screens/sleep_data/sleep_data_screen.dart';
import 'package:sleeping_tracker_ui/screens/progress/progress_screen.dart';
import 'package:sleeping_tracker_ui/screens/settings/settings_screen.dart';
import 'components/unlocked_items_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SleepScoreService _scoreService = SleepScoreService();
  int? _totalScore;
  
  // track added items by name
  List<String> addedItems = [];

  // keep track of items in the garden
  List<GardenItem> gardenItems = [];

  // items list loaded from JSON
  List<ObtainedItem> obtainedItems = [];

  // currently selected item in the garden
  GardenItem? selectedItem;

  // key to get the size of the garden area
  final GlobalKey gardenKey = GlobalKey();

  bool _isImagePrecached = false;
  bool _isLoading = true; 

  @override
  void initState() {
    super.initState();
    _loadObtainedItems();
    _fetchTotalScore();
  }

  void _fetchTotalScore() {
    _scoreService.getTotalScore().then((score) {
      setState(() {
        _totalScore = score;
      });
    }).catchError((error) {
      print('Error fetching total score: $error');
      // Optionally display an error message in the UI
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isImagePrecached) {
      precacheImage(const AssetImage('assets/images/garden.png'), context).then((_) {
        setState(() {
          _isImagePrecached = true;
          _isLoading = false;
        });
      }).catchError((error) {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  Future<void> _loadObtainedItems() async {
    DataProvider dataProvider = DataProvider();
    List<ObtainedItem> items = await dataProvider.fetchObtainedItems();
    setState(() {
      obtainedItems = items;
    });
  }

  void _openUnlockedItemsDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Close",
      barrierColor: Colors.black.withOpacity(0.7),
      transitionDuration: const Duration(milliseconds: 400),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
            .chain(CurveTween(curve: Curves.easeInOut));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return UnlockedItemsDialog(
          obtainedItems: obtainedItems,
          addedItems: addedItems,
          onItemTapped: _handleItemTapped,
        );
      },
    );
  }

  void _handleItemTapped(ObtainedItem item) {
    setState(() {
      String itemName = item.name;
      bool isAdded = addedItems.contains(itemName);

      if (isAdded) {
        addedItems.remove(itemName);
        gardenItems.removeWhere((gi) => gi.obtainedItem.name == itemName);
      } else {
        addedItems.add(itemName);
        final size = gardenKey.currentContext?.size ?? Size.zero;
        final center = Offset(
            size.width / 2 - GardenItem.gardenItemSize.width / 2,
            size.height / 2 - GardenItem.gardenItemSize.height / 2);
        gardenItems.add(
          GardenItem(
            obtainedItem: item,
            position: center,
          ),
        );
      }
    });
  }

  Widget _buildRoundedCard({required Widget child}) {
    return RoundedCard(child: child);
  }

  Widget _buildImageRoundedCard(
      {required String imagePath, required Widget child}) {
    return ImageRoundedCard(imagePath: imagePath, child: child);
  }

  Widget _buildBottomButton(
      BuildContext context, IconData icon, String label, Widget screen) {
    return BottomButton(icon: icon, label: label, screen: screen);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || !_isImagePrecached) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: SizedBox.shrink(),
      );
    }

    const Size controlCardSize = Size(160, 40); // width to accommodate 3 buttons

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedItem = null;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _buildRoundedCard(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Sleep Score",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "$_totalScore",
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: _buildImageRoundedCard(
                        imagePath: 'assets/images/garden.png',
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Garden Section
                            Expanded(
                              child: Center(
                                child: Stack(
                                  key: gardenKey,
                                  children: [
                                    // Garden items
                                    ...gardenItems.map((item) {
                                      return Positioned(
                                        left: item.position.dx,
                                        top: item.position.dy,
                                        child: GestureDetector(
                                          onPanUpdate: (details) {
                                            setState(() {
                                              item.position += details.delta;
                                              final gardenBox =
                                                  gardenKey.currentContext
                                                      ?.findRenderObject()
                                                      as RenderBox?;
                                              if (gardenBox != null) {
                                                item.position = PositionHelper
                                                    .clampPositionWithinGarden(
                                                        item.position,
                                                        GardenItem.gardenItemSize,
                                                        gardenBox);
                                              }
                                            });
                                          },
                                          onTap: () {
                                            setState(() {
                                              selectedItem = item;
                                            });
                                          },
                                          child: TransformBox(
                                            item: item,
                                            child: Container(
                                              decoration: selectedItem == item
                                                  ? BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.white
                                                            .withOpacity(0.5),
                                                      ),
                                                      color: Colors.white
                                                          .withOpacity(0.1),
                                                    )
                                                  : null,
                                              child: Icon(
                                                  item.obtainedItem.icon,
                                                  color: Colors.white,
                                                  size: 50),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),

                                    // delete button and controls for the selected item
                                    if (selectedItem != null)
                                      Builder(builder: (context) {
                                        final gardenBox =
                                            gardenKey.currentContext
                                                ?.findRenderObject()
                                                as RenderBox?;
                                        if (gardenBox == null) return Container();

                                        final controlPosition = PositionHelper
                                            .calculateControlCardPosition(
                                                selectedItem!,
                                                controlCardSize,
                                                gardenBox);

                                        return Positioned(
                                          left: controlPosition.dx,
                                          top: controlPosition.dy,
                                          child:
                                              _buildControlsCard(controlCardSize),
                                        );
                                      }),
                                  ],
                                ),
                              ),
                            ),
                            // + button at the Bottom
                            IconButton(
                              icon: const Icon(Icons.add, color: Colors.white),
                              onPressed: _openUnlockedItemsDialog,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Navigation Buttons
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildBottomButton(context, Icons.flag, "Challenges",
                            const DailyChallengesScreen()),
                        _buildBottomButton(context, Icons.data_usage, "Sleep Data",
                            const SleepDataScreen()),
                        _buildBottomButton(context, Icons.timeline, "Progress",
                            const ProgressScreen()),
                        _buildBottomButton(context, Icons.settings, "Settings",
                            const SettingsScreen()),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildControlsCard(Size controlCardSize) {
    return Container(
      width: controlCardSize.width,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Rotate Left Button
          IconButton(
            icon:
                const Icon(Icons.rotate_left, color: Colors.white, size: 20),
            onPressed: () {
              if (selectedItem != null) {
                setState(() {
                  selectedItem!.rotation -= 15;
                });
              }
            },
          ),
          // Delete Button (X)
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 20),
            onPressed: () {
              if (selectedItem != null) {
                setState(() {
                  gardenItems.remove(selectedItem);
                  addedItems.remove(selectedItem!.obtainedItem.name);
                  selectedItem = null;
                });
              }
            },
          ),
          // Rotate Right Button
          IconButton(
            icon:
                const Icon(Icons.rotate_right, color: Colors.white, size: 20),
            onPressed: () {
              if (selectedItem != null) {
                setState(() {
                  selectedItem!.rotation += 15;
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
