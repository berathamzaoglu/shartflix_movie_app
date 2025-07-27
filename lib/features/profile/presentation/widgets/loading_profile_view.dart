import 'package:flutter/material.dart';

class LoadingProfileView extends StatelessWidget {
  const LoadingProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Loading Profile Picture
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey.shade800,
            child: const CircularProgressIndicator(
              color: Color(0xFFE53E3E),
              strokeWidth: 2,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Loading User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 18,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade700,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  height: 14,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade700,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          
          // Loading Button
          Container(
            height: 32,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.grey.shade700,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ],
      ),
    );
  }
} 