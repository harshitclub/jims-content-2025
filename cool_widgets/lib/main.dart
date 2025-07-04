import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cool Widgets',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: const ExpansionTileExample(),
    );
  }
}

class DismissibleExample extends StatefulWidget {
  const DismissibleExample({super.key});

  @override
  State<DismissibleExample> createState() => _DismissibleExampleState();
}

class _DismissibleExampleState extends State<DismissibleExample> {
  final List<String> _items = List<String>.generate(10, (i) => 'Item ${i + 1}');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dismissible To-Do List')),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final String item = _items[index];

          return Dismissible(
            key: Key(item),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.redAccent,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20.0),
              child: const Icon(Icons.delete, color: Colors.white),
            ),

            onDismissed: (direction) {
              // Remove the item from the data source
              setState(() {
                _items.removeAt(index);
              });
              // Show a snackbar feedback
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('"$item" dismissed'),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      setState(() {
                        _items.insert(index, item);
                      });
                    },
                  ),
                ),
              );
            },
            confirmDismiss: (direction) async {
              // Show a dialog before dismissing
              return await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirm Deletion'),
                    content: Text('Are you sure you want to delete: "$item"?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text("Delete"),
                      ),
                    ],
                  );
                },
              );
            },
            child: ListTile(
              title: Text(item),
              subtitle: const Text('Swipe to delete'),
            ),
          );
        },
      ),
    );
  }
}

class DragAndDropExample extends StatefulWidget {
  const DragAndDropExample({super.key});

  @override
  State<DragAndDropExample> createState() => _DragAndDropExampleState();
}

class _DragAndDropExampleState extends State<DragAndDropExample> {
  List<String> availableItems = ['Apple', 'Banana', 'Orange', 'Grapes', 'Milk'];
  List<String> shoppingCart = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Drag and Drop Shopping')),
      body: Column(
        children: [
          // Available Items
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 2.0, // Make items wider
              ),
              itemCount: availableItems.length,
              itemBuilder: (context, index) {
                final String item = availableItems[index];
                return Draggable<String>(
                  data: item, // The data carried by this Draggable
                  feedback: Material(
                    elevation: 4.0,
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade700,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        item,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  childWhenDragging: Container(
                    // Show an empty placeholder when dragging
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Center(
                      child: Text(
                        item,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                  child: Card(
                    elevation: 2.0,
                    child: Center(
                      child: Text(item, style: const TextStyle(fontSize: 16)),
                    ),
                  ),
                );
              },
            ),
          ),
          // Shopping Cart (DragTarget)
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: DragTarget<String>(
              onWillAcceptWithDetails: (data) {
                return true;
              },
              onAcceptWithDetails: (DragTargetDetails<String> details) {
                // When an item is dropped and accepted
                setState(() {
                  shoppingCart.add(details.data); // Correct: Use details.data
                  availableItems.remove(
                    details.data,
                  ); // Correct: Use details.data// Remove from available
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${details.data} added to cart!'),
                  ), // Correct: Use details.data
                );
              },
              builder: (context, acceptedData, rejectedData) {
                // Build the UI of the DragTarget based on its state
                Color targetColor = Colors.grey[300]!;
                String targetText = 'Drag items here to add to cart!';

                if (acceptedData.isNotEmpty) {
                  targetColor =
                      Colors.green.shade300; // Highlight when item is over it
                  targetText = 'Release to add to cart!';
                }

                return Container(
                  width: double.infinity,
                  height: 150.0,
                  decoration: BoxDecoration(
                    color: targetColor,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: acceptedData.isNotEmpty
                          ? Colors.green
                          : Colors.grey,
                      width: 2.0,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart,
                        size: 50,
                        color: acceptedData.isNotEmpty
                            ? Colors.green[700]
                            : Colors.grey[600],
                      ),
                      Text(
                        targetText,
                        style: TextStyle(
                          color: acceptedData.isNotEmpty
                              ? Colors.green[700]
                              : Colors.grey[600],
                        ),
                      ),
                      if (shoppingCart.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Items in cart: ${shoppingCart.join(', ')}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class ReorderableListExample extends StatefulWidget {
  const ReorderableListExample({super.key});

  @override
  State<ReorderableListExample> createState() => _ReorderableListExampleState();
}

class _ReorderableListExampleState extends State<ReorderableListExample> {
  // Our list of items. Each item needs a unique key.
  final List<String> _items = List<String>.generate(
    10,
    (index) => 'Task ${index + 1}',
  );

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1; // Adjust newIndex if moving item downwards
      }
      final String item = _items.removeAt(oldIndex);
      _items.insert(newIndex, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reorderable To-Do List')),
      body: ReorderableListView.builder(
        key: UniqueKey(),
        itemCount: _items.length,
        itemBuilder: (BuildContext context, int index) {
          final String item = _items[index];
          return Card(
            key: ValueKey(item),
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            elevation: 2.0,
            child: ListTile(
              title: Text(item),
              leading: const Icon(Icons.drag_handle),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    _items.removeAt(index);
                  });
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Removed "$item"')));
                },
              ),
            ),
          );
        },
        onReorder: _onReorder,
        // Optional: Customize the proxy decorator for the dragged item
        proxyDecorator: (Widget child, int index, Animation<double> animation) {
          return AnimatedBuilder(
            animation: animation,
            builder: (BuildContext context, Widget? child) {
              final double animValue = Curves.easeInOut.transform(
                animation.value,
              );
              final double elevation = Tween<double>(
                begin: 0,
                end: 6,
              ).evaluate(animation);
              final double scale = Tween<double>(
                begin: 1.0,
                end: 1.05,
              ).evaluate(animation); // Slightly enlarge
              return Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: Tween<double>(
                    begin: 1.0,
                    end: 0.7,
                  ).evaluate(animation), // Slightly transparent
                  child: Material(elevation: elevation, child: child),
                ),
              );
            },
            child: child,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _items.add('New Task ${_items.length + 1}');
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AnimatedContainerExample extends StatefulWidget {
  const AnimatedContainerExample({super.key});

  @override
  State<AnimatedContainerExample> createState() =>
      _AnimatedContainerExampleState();
}

class _AnimatedContainerExampleState extends State<AnimatedContainerExample> {
  // Initial properties
  double _width = 100.0;
  double _height = 100.0;
  Color _color = Colors.blue;
  BorderRadiusGeometry _borderRadius = BorderRadius.circular(8.0);
  AlignmentGeometry _alignment = Alignment.center;

  void _randomizeProperties() {
    setState(() {
      final random = Random();

      // Random width and height between 50 and 250
      _width = random.nextDouble() * 200 + 50;
      _height = random.nextDouble() * 200 + 50;

      // Random color
      _color = Color.fromRGBO(
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
        1,
      );

      // Random border radius
      _borderRadius = BorderRadius.circular(random.nextDouble() * 50);

      // Random alignment
      final alignments = [
        Alignment.topLeft,
        Alignment.topCenter,
        Alignment.topRight,
        Alignment.centerLeft,
        Alignment.center,
        Alignment.centerRight,
        Alignment.bottomLeft,
        Alignment.bottomCenter,
        Alignment.bottomRight,
      ];
      _alignment = alignments[random.nextInt(alignments.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AnimatedContainer Demo')),
      body: Center(
        child: AnimatedContainer(
          // Set the duration for the animation
          duration: const Duration(milliseconds: 700),
          // Set the curve for the animation
          curve: Curves.fastOutSlowIn, // A commonly used and pleasing curve
          // Apply the current state properties
          width: _width,
          height: _height,
          decoration: BoxDecoration(color: _color, borderRadius: _borderRadius),
          alignment: _alignment, // Animate alignment of the child
          // Optionally, animate padding or margin too if needed
          // padding: EdgeInsets.all(somePadding),
          child: const FlutterLogo(size: 75), // Child remains the same
          onEnd: () {
            // Optional: Callback when the animation completes
            debugPrint('Animation finished!');
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _randomizeProperties,
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}

class CustomScrollViewExample extends StatelessWidget {
  const CustomScrollViewExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          // 1. SliverAppBar: Our dynamic header
          SliverAppBar(
            expandedHeight: 250.0, // Height when fully expanded
            floating: false, // Does not immediately reappear on scroll up
            pinned: true, // Remains visible at collapsedHeight
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'My Awesome Scroll View',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              background: Image.network(
                'https://picsum.photos/id/1018/800/400', // Example background image
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 2. SliverList: A list of items below the app bar
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  elevation: 4.0,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal.shade100,
                      child: Text('${index + 1}'),
                    ),
                    title: Text('List Item $index'),
                    subtitle: const Text(
                      'Scroll me to see the app bar animate!',
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Tapped on Item $index')),
                      );
                    },
                  ),
                );
              },
              childCount: 50, // Number of list items
            ),
          ),
        ],
      ),
    );
  }
}

class PageViewExample extends StatefulWidget {
  const PageViewExample({super.key});

  @override
  State<PageViewExample> createState() => _PageViewExampleState();
}

class _PageViewExampleState extends State<PageViewExample> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  final List<Color> _pageColors = [
    Colors.red.shade300,
    Colors.green.shade300,
    Colors.blue.shade300,
  ];

  final List<String> _pageTitles = [
    "Welcome!",
    "Explore Features",
    "Get Started!",
  ];

  final List<String> _pageDescriptions = [
    "Swipe to learn more about our amazing app.",
    "Discover powerful tools and functionalities.",
    "Ready to dive in? Let's go!",
  ];

  @override
  void dispose() {
    _pageController.dispose(); // Important: Dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PageView Demo')),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pageTitles.length,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  color: _pageColors[index],
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _pageTitles[index],
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            _pageDescriptions[index],
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white70,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Previous Button
                _currentPage > 0
                    ? ElevatedButton(
                        onPressed: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        },
                        child: const Text('Previous'),
                      )
                    : const SizedBox.shrink(), // Hide button on first page
                // Page Indicator (Dots)
                Row(
                  children: List.generate(_pageTitles.length, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      width: _currentPage == index ? 12.0 : 8.0,
                      height: 8.0,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? Colors.blue
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    );
                  }),
                ),

                // Next/Done Button
                _currentPage < _pageTitles.length - 1
                    ? ElevatedButton(
                        onPressed: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        },
                        child: const Text('Next'),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          // Action when "Done" is pressed, e.g., navigate to home screen
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Onboarding Complete!'),
                            ),
                          );
                        },
                        child: const Text('Done'),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedListExample extends StatefulWidget {
  const AnimatedListExample({super.key});

  @override
  State<AnimatedListExample> createState() => _AnimatedListExampleState();
}

class _AnimatedListExampleState extends State<AnimatedListExample> {
  // 1. Declare a GlobalKey for AnimatedListState
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<String> _items = [];
  int _nextItem = 0; // Counter for new items

  // Function to add an item
  void _addItem() {
    final int newIndex = _items.length;
    _items.insert(newIndex, 'Item ${_nextItem++}');
    _listKey.currentState?.insertItem(
      newIndex,
      duration: const Duration(milliseconds: 500),
    );
  }

  // Function to remove an item
  void _removeItem(int indexToRemove) {
    if (_items.isEmpty || indexToRemove < 0 || indexToRemove >= _items.length) {
      return; // Ensure valid index
    }

    final String removedItem = _items[indexToRemove];

    // 1. Call removeItem on the AnimatedListState
    _listKey.currentState?.removeItem(indexToRemove, (
      BuildContext context,
      Animation<double> animation,
    ) {
      // This builder creates the animation for the item being removed.
      // It's still part of the widget tree for the duration of the animation.
      return FadeTransition(
        opacity: animation, // Fade out
        child: SizeTransition(
          sizeFactor: animation, // Shrink vertically
          axisAlignment: 0.0,
          child: _buildItem(
            context,
            removedItem,
            Icons.delete_forever,
          ), // Re-use item builder, or a simplified one
        ),
      );
    }, duration: const Duration(milliseconds: 500));

    // 2. IMPORTANT: Remove the item from your underlying data AFTER calling removeItem
    // This allows the removeItem builder to still access the item data for animation.
    _items.removeAt(indexToRemove);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Removed "$removedItem"')));
  }

  // Helper function to build a list item card
  Widget _buildItem(
    BuildContext context,
    String item, [
    IconData? leadingIcon,
  ]) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 4.0,
      child: ListTile(
        leading: leadingIcon != null
            ? Icon(leadingIcon)
            : const Icon(Icons.star),
        title: Text(item),
        trailing: IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: () {
            // Find the current index of the item before removing
            // This is important because indices can shift after other removals
            final int currentIndex = _items.indexOf(item);
            if (currentIndex != -1) {
              _removeItem(currentIndex);
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AnimatedList Demo'),
        actions: [IconButton(icon: const Icon(Icons.add), onPressed: _addItem)],
      ),
      body: AnimatedList(
        key: _listKey, // Assign the GlobalKey
        initialItemCount:
            _items.length, // Start with current items (0 initially)
        itemBuilder:
            (BuildContext context, int index, Animation<double> animation) {
              final String item = _items[index];
              // Use a SlideTransition to animate items sliding in from the left
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(-1, 0), // Start from left
                  end: Offset.zero, // Slide to original position
                ).animate(animation),
                child: _buildItem(context, item),
              );
            },
      ),
    );
  }
}

class ExpansionTileExample extends StatefulWidget {
  const ExpansionTileExample({super.key});

  @override
  State<ExpansionTileExample> createState() => _ExpansionTileExampleState();
}

class _ExpansionTileExampleState extends State<ExpansionTileExample> {
  // We can track the expanded state, though ExpansionTile often manages it internally
  // unless you need to programmatically control it.
  bool _isFirstTileExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FAQ Section')),
      body: ListView(
        children: <Widget>[
          // ExpansionTile 1: Simple FAQ
          ExpansionTile(
            title: const Text('What is Flutter?'),
            subtitle: const Text('Learn about Google\'s UI toolkit'),
            leading: const Icon(Icons.info_outline),
            onExpansionChanged: (bool expanded) {
              setState(() {
                _isFirstTileExpanded = expanded;
              });
              debugPrint('What is Flutter? Expanded: $expanded');
            },
            // Control its initial state based on our local variable
            initiallyExpanded: _isFirstTileExpanded,
            children: const <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'Flutter is an open-source UI software development kit created by Google. '
                  'It is used for developing cross-platform applications from a single codebase.',
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
          const Divider(height: 1), // Optional divider for visual separation
          // ExpansionTile 2: More advanced styling and multiple children
          ExpansionTile(
            title: const Text('How to get started with Flutter?'),
            subtitle: const Text('Steps for beginners'),
            leading: const Icon(Icons.lightbulb_outline),
            backgroundColor: Colors.purple.shade50, // Background when expanded
            collapsedBackgroundColor:
                Colors.grey.shade100, // Background when collapsed
            textColor: Colors.deepPurple, // Text color when expanded
            iconColor: Colors.deepPurpleAccent, // Icon color when expanded
            childrenPadding: const EdgeInsets.all(
              16.0,
            ), // Padding for the children content
            children: const <Widget>[
              ListTile(
                leading: Icon(Icons.looks_one),
                title: Text('Install Flutter SDK'),
                subtitle: Text('Download from flutter.dev'),
              ),
              ListTile(
                leading: Icon(Icons.looks_two),
                title: Text('Set up your editor'),
                subtitle: Text('VS Code or Android Studio'),
              ),
              ListTile(
                leading: Icon(Icons.looks_3),
                title: Text('Run your first app'),
                subtitle: Text('Hello World!'),
              ),
            ],
          ),
          const Divider(height: 1),

          // ExpansionTile 3: Custom trailing icon
          ExpansionTile(
            title: const Text('Where can I find resources?'),
            trailing: _isFirstTileExpanded
                ? const Icon(Icons.keyboard_arrow_up)
                : const Icon(Icons.keyboard_arrow_down), // Custom trailing icon
            // Note: If you provide a custom trailing, you lose the default rotation animation
            children: const <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Official Flutter Documentation'),
                    SizedBox(height: 5),
                    Text('Flutter Community Forums'),
                    SizedBox(height: 5),
                    Text('YouTube tutorials'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AlertDialogExample extends StatelessWidget {
  const AlertDialogExample({super.key});

  // Function to show the AlertDialog
  void _showDeleteConfirmationDialog(BuildContext context) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // User must tap a button to dismiss
      builder: (BuildContext dialogContext) {
        // Renamed context to dialogContext for clarity
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text(
            'Are you sure you want to delete this item? This action cannot be undone.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop(false); // Dismiss with 'false' (not confirmed)
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              // Use ElevatedButton for the primary action to give it more prominence
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop(true); // Dismiss with 'true' (confirmed)
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Red button for delete action
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              15.0,
            ), // Rounded corners for the dialog
          ),
          backgroundColor: Colors.white,
          elevation: 10.0,
        );
      },
    );

    // This code runs AFTER the dialog is dismissed
    if (confirmed == true) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Item deleted!')));
      // Perform the actual delete operation here
      print('Deletion confirmed!');
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Deletion cancelled.')));
      print('Deletion cancelled.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dialog Example')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showDeleteConfirmationDialog(context),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            textStyle: const TextStyle(fontSize: 18),
          ),
          child: const Text('Delete Item'),
        ),
      ),
    );
  }
}
