import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class LeftSideBar extends StatelessWidget {
  final String userName;
  final String planName;
  final double storageUsed;
  final double storageLimit;
  const LeftSideBar(
      {required this.userName,
      required this.planName,
      required this.storageUsed,
      required this.storageLimit,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      color: Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          Text(
            "Welcome, $userName",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            "$planName Plan",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
          ),
          const SizedBox(height: 20),
          LinearPercentIndicator(
            width: 250.0,
            lineHeight: 14.0,
            percent: storageUsed / storageLimit,
            backgroundColor: Colors.grey,
            progressColor: Colors.blue,
            barRadius: const Radius.circular(5),
            alignment: MainAxisAlignment.center,
          ),
          const SizedBox(height: 20),
          Text(
            "${storageUsed.toStringAsFixed(2)} MB of ${storageLimit.toStringAsFixed(2)} MB used",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }
}
