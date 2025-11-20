import 'dart:async';
import 'package:flutter/material.dart';
import './section_header.dart';

class ImageCarousel extends StatefulWidget {
  const ImageCarousel({super.key});
  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  // List of images and their titles
  final List<Map<String, String>> images = [
    {'image': 'assets/images/img1.png', 'title': 'Session Report'},
    {'image': 'assets/images/img2.png', 'title': 'Attendance Stats'},
    {'image': 'assets/images/img3.png', 'title': 'Performance Review'},
    {'image': 'assets/images/img4.png', 'title': 'Daily Tasks'},
    {'image': 'assets/images/img5.png', 'title': 'Class Schedule'},
    {'image': 'assets/images/img6.png', 'title': 'Student Activities'},
    {'image': 'assets/images/img7.png', 'title': 'Admin Reports'},
    {'image': 'assets/images/img8.png', 'title': 'Subjects'},
    {'image': 'assets/images/img9.png', 'title': 'Study Plan'},
    {'image': 'assets/images/img10.png', 'title': 'Teacher Follow-up'},
    {'image': 'assets/images/img11.png', 'title': 'Student Results'},
    {'image': 'assets/images/img12.png', 'title': 'Document Archive'},
    {'image': 'assets/images/img13.png', 'title': 'Library Management'},
    {'image': 'assets/images/img14.png', 'title': 'Online Exams'},
    {'image': 'assets/images/img15.png', 'title': 'School Announcements'},
    {'image': 'assets/images/img16.png', 'title': 'Educational Meetings'},
    {'image': 'assets/images/img17.png', 'title': 'Activity Registration'},
    {'image': 'assets/images/img18.png', 'title': 'Class Management'},
    {'image': 'assets/images/img19.png', 'title': 'Data Analysis'},
    {'image': 'assets/images/img20.png', 'title': 'Achievements Log'},
    {'image': 'assets/images/img21.png', 'title': 'Chat System'},
    {'image': 'assets/images/img22.png', 'title': 'School Nutrition'},
    {'image': 'assets/images/img23.png', 'title': 'School News'},
    {'image': 'assets/images/img24.png', 'title': 'Self Assessment'},
    {'image': 'assets/images/img25.png', 'title': 'Admin Contact'},
    {'image': 'assets/images/img26.png', 'title': 'Attendance Management'},
    {'image': 'assets/images/img27.png', 'title': 'Performance Reports'},
    {'image': 'assets/images/img28.png', 'title': 'Profile'},
  ];

  final PageController _pageController = PageController();
  int currentIndex = 0;
  int itemsPerPage = 4; // Default: 4 cards per page

  @override
  void initState() {
    super.initState();
    // Auto-scroll timer
    Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          currentIndex = (currentIndex + itemsPerPage) % images.length;
          _pageController.animateToPage(
            currentIndex ~/ itemsPerPage,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Responsive: 2 cards on small screens, 4 on large
    double screenWidth = MediaQuery.of(context).size.width;
    itemsPerPage = screenWidth < 600 ? 2 : 4;

    final theme = Theme.of(context);

    return Column(
      children: [
        SectionHeader(
          header: 'صور المنصّة',
        ),
        const SizedBox(height: 40),
        SizedBox(
          height: 250,
          child: PageView.builder(
            controller: _pageController,
            itemCount: (images.length / itemsPerPage).ceil(),
            itemBuilder: (context, pageIndex) {
              int startIndex = pageIndex * itemsPerPage;
              int endIndex =
                  (startIndex + itemsPerPage).clamp(0, images.length);
              List<Map<String, String>> displayedImages =
                  images.sublist(startIndex, endIndex);

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: displayedImages.map((data) {
                  return _buildCard(
                      context, data['image']!, data['title']!, theme);
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }

  // Builds a single image card
  Widget _buildCard(
      BuildContext context, String imagePath, String title, ThemeData theme) {
    return GestureDetector(
      onTap: () => _showFullScreenImage(context, imagePath),
      child: Column(
        children: [
          Container(
            width: 150,
            height: 180,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.2),
                  blurRadius: 5,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.asset(imagePath,
                  fit: BoxFit.cover, width: double.infinity),
            ),
          ),
          const SizedBox(height: 5),
          Container(
            width: 150,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.15),
                  blurRadius: 3,
                  offset: const Offset(1, 1),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              title,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // Shows the image in fullscreen dialog
  void _showFullScreenImage(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return Dialog(
          backgroundColor: Colors.transparent,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: InteractiveViewer(
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: theme.cardColor,
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
