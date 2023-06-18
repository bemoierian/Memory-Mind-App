import 'package:flutter/material.dart';

class MediaCard extends StatelessWidget {
  final String mediaURL;
  final String title;
  final Function onTapFunc;
  const MediaCard({
    required this.mediaURL,
    required this.title,
    required this.onTapFunc,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTapFunc();
      },
      child: Container(
        width: 200,
        height: 200,
        // color: Colors.grey.shade200,
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // image
            SizedBox(
              width: 200,
              height: 200,
              child: Image(
                image: NetworkImage(mediaURL),
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text(title),
          ],
        ),
      ),
    );
  }
}
