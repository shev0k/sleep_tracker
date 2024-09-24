import 'package:flutter/material.dart';
import 'package:sleeping_tracker_ui/models/(home)/obtained_item.dart';
import 'package:sleeping_tracker_ui/components/custom_painters/subtle_cross_painter.dart';

class UnlockedItemsDialog extends StatefulWidget {
  final List<ObtainedItem> obtainedItems;
  final List<String> addedItems;
  final Function(ObtainedItem) onItemTapped;

  const UnlockedItemsDialog({
    super.key,
    required this.obtainedItems,
    required this.addedItems,
    required this.onItemTapped,
  });

  @override
  // ignore: library_private_types_in_public_api
  _UnlockedItemsDialogState createState() => _UnlockedItemsDialogState();
}

class _UnlockedItemsDialogState extends State<UnlockedItemsDialog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(35),
          color: const Color.fromARGB(255, 29, 29, 29).withOpacity(0.9),
          child: Column(
            children: [
              const Text(
                'Unlocked Items',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                  ),
                  itemCount: widget.obtainedItems.length,
                  itemBuilder: (context, index) {
                    ObtainedItem item = widget.obtainedItems[index];
                    bool isAdded = widget.addedItems.contains(item.name);

                    return GestureDetector(
                      onTap: () {
                        widget.onItemTapped(item);
                        
                        if (!isAdded) {
                          Navigator.pop(context);
                        } else {
                          setState(() {});
                        }
                      },
                      child: _buildItemCard(item, isAdded),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Close',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemCard(ObtainedItem item, bool isAdded) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: isAdded
                  ? Border.all(
                      color: const Color.fromARGB(218, 255, 255, 255),
                      width: 1.5)
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, color: Colors.white, size: 50),
                const SizedBox(height: 10),
                Text(
                  item.name,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          if (isAdded)
            Positioned.fill(
              child: CustomPaint(
                painter: SubtleCrossPainter(),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.4),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
