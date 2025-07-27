import 'package:flutter/material.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SocialButton(
          icon: Icons.g_mobiledata,
          onPressed: () {
            // TODO: Implement Google login
          },
        ),
        const SizedBox(width: 16),
        _SocialButton(
          icon:
            Icons.apple_outlined,
           
          onPressed: () {
            // TODO: Implement Apple login
          },
        ),
        const SizedBox(width: 16),
        _SocialButton(
          icon: Icons.facebook,
          onPressed: () {
            // TODO: Implement Facebook login
          },
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _SocialButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFFffffff).withAlpha(25),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withAlpha(52), width: 1),
      ),
      child: Icon(icon, color: Colors.white, size: 24),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF1877F2),
      ),
      child: const Center(
        child: Text(
          'f',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  
} 