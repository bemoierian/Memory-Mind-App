import 'package:flutter/material.dart';

class MediaCard extends StatelessWidget {
  final String mediaURL;
  final String title;
  const MediaCard({
    required this.mediaURL,
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      // color: Colors.grey.shade200,
      decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          // image
          SizedBox(
            width: 170,
            height: 170,
          ),
          Text("Title")
        ],
      ),
    );
  }
}
