import 'package:flutter/material.dart';
import '../utils/ClassData.dart';
import '../utils/text.dart';
import '../utils/FoodCard.dart';

class ClassList extends StatefulWidget {
  const ClassList({super.key});

  @override
  State<ClassList> createState() => _ClassListState();
}
class _ClassListState extends State<ClassList> {
  String searchQuery = '';
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();
  int selectedIndex = 0;

  final List<String> categories = [
    'All', 'Fruits/Vegetables', 'Meats', 'Carbs/Grains', 'Sugary Drinks'
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(text: buildTextSpan("Food Classes", Colors.white)),
        backgroundColor: const Color(0xFF90b79e),
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 40,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  filled: true,
                  fillColor: Color(0xFFcfcfcf),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(fontSize: 14),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
            ),
          ),

          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF90b79e),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
              ),
              child: Column(
                children: [
                  // Categories Row (Scrollable and Synchronized)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: SizedBox(
                      height: 40, // Adjust height as needed
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        controller: _scrollController,
                        itemCount: categories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final isSelected = selectedIndex == index;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                                _pageController.jumpToPage(index);
                                _scrollToCategory(index);
                              });
                            },
                            child: Text(
                              categories[index],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: isSelected ? 15 : 14,
                                color: isSelected ? Colors.black : Colors.black54,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // Swipable Pages (PageView)
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          selectedIndex = index;
                        });
                        _scrollToCategory(index);
                      },
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        final filteredList = foodClassMetadata.entries.where((entry) {
                          final matchesCategory = category == 'All' || entry.value.category == category;
                          final matchesSearch = entry.value.name.toLowerCase().contains(searchQuery.toLowerCase());
                          return matchesCategory && matchesSearch;
                        }).toList();

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GridView.builder(
                            padding: const EdgeInsets.only(bottom: 12),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 3,
                              mainAxisSpacing: 3,
                              childAspectRatio: 0.65,
                            ),
                            itemCount: filteredList.length,
                            itemBuilder: (context, i) {
                              final entry = filteredList[i];
                              return FoodCard(
                                name: entry.value.name,
                                protein: entry.value.protein,
                                imagePath: entry.value.imagePath,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Scroll to the selected category
  void _scrollToCategory(int index) {
    final itemWidth = 100.0; // Approximate width of each category item
    final offset = index * (itemWidth + 12); // 12 is the separator width between categories
    _scrollController.animateTo(
      offset,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
