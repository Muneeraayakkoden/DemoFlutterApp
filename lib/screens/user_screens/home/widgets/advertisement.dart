import 'package:flutter/material.dart';
import '../../../../constants/color_class.dart';

class Advertisement extends StatelessWidget {
  const Advertisement({super.key});

  @override
  Widget build(BuildContext context) {
    final bool hasAd = false;

    if (!hasAd) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        height: 120,
        decoration: BoxDecoration(
          color: ColorClass.greenDarker,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Text(
          'Latest updates available here!',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: ColorClass.white,
          ),
        ),
      );
    }

    // return Container(
    //   margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    //   child: ClipRRect(
    //     borderRadius: BorderRadius.circular(16),
    //     child: Stack(
    //       children: [
    //         AspectRatio(
    //           aspectRatio: 16 / 9,
    //           child: Image.network(
    //             'sample image',
    //             fit: BoxFit.cover,
    //             width: double.infinity,
    //             height: double.infinity,
    //           ),
    //         ),
    //         Positioned(
    //           left: 0,
    //           right: 0,
    //           bottom: 0,
    //           child: Container(
    //             padding: const EdgeInsets.symmetric(
    //               horizontal: 16,
    //               vertical: 8,
    //             ),
    //             color: Colors.black.withOpacity(0.4),
    //             child: Text(
    //               'Title',
    //               style: TextStyle(
    //                 fontWeight: FontWeight.w600,
    //                 fontSize: 16,
    //                 color: Colors.white,
    //               ),
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    //);
  }
}
