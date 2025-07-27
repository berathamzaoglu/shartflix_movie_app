import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

class ErrorProfileView extends StatelessWidget {
  final String message;

  const ErrorProfileView({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Error Profile Picture
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey.shade800,
            child: const Icon(
              Icons.error,
              color: Color(0xFFE53E3E),
              size: 30,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Error Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.profile_error,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          // Retry Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE53E3E),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              l10n.profile_retry,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 