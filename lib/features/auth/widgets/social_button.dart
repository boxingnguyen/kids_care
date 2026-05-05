import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Social sign-in button (e.g. Google). Falls back gracefully if icon asset is missing.
class SocialButton extends StatelessWidget {
  final String label;
  final String iconPath;
  final VoidCallback onPressed;
  final bool isLoading;

  const SocialButton({
    super.key,
    required this.label,
    required this.iconPath,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 2,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black54),
                ),
              )
            : Stack(
                alignment: Alignment.centerLeft,
                children: [
                  // Try loading the image asset; fall back to a colored icon
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Image.asset(
                      iconPath,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.g_mobiledata_rounded,
                        size: 26,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      label,
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF757575),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
