import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'section_header.dart';

class MobileShowcase extends StatelessWidget {
  // List of image asset paths
  final List<String> imagePaths =
      List.generate(21, (index) => 'assets/images/img${index + 1}.png');

  MobileShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.background, // Use app theme background color
      padding: const EdgeInsets.symmetric(vertical: 30), // Vertical spacing
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SectionHeader(
            header: 'صور من التطبيق',
          ),

          const SizedBox(height: 20), // Space between title and carousel
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Phone frame image
                Image.asset(
                  'assets/phone.png',
                  width: 680,
                ),
                // Carousel slider positioned over the phone screen area
                Positioned(
                  top: 27,
                  child: SizedBox(
                    width: 400,
                    height: 290,
                    child: CarouselSlider.builder(
                      itemCount: imagePaths.length,
                      options: CarouselOptions(
                        height: 290,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 3),
                        viewportFraction: 0.32, // Show 3 images at once
                        enableInfiniteScroll: true,
                        enlargeCenterPage: false,
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                        autoPlayCurve: Curves.easeInOut,
                        scrollPhysics: const BouncingScrollPhysics(),
                      ),
                      itemBuilder: (context, index, realIndex) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8), // Space between images
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(15), // Rounded corners
                            child: Image.asset(
                              imagePaths[index],
                              width: 120,
                              height: 290,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
