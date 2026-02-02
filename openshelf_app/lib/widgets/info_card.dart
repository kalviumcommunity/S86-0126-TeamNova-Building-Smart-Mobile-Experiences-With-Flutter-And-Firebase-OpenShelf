import 'package:flutter/material.dart';

/// ============================================================================
/// INFO CARD - REUSABLE WIDGET
/// ============================================================================
///
/// A reusable card widget that displays information with an icon, title,
/// subtitle, and optional action button.
///
/// Features:
/// - Customizable icon, title, subtitle, and colors
/// - Optional tap action
/// - Consistent card styling across the app
/// - Supports gradient backgrounds
///
/// ============================================================================

class InfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color? iconColor;
  final Color? cardColor;
  final VoidCallback? onTap;
  final bool useGradient;

  const InfoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.iconColor,
    this.cardColor,
    this.onTap,
    this.useGradient = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: useGradient
            ? BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    cardColor?.withOpacity(0.7) ?? Colors.teal.withOpacity(0.7),
                    cardColor ?? Colors.teal,
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              )
            : BoxDecoration(
                color: cardColor ?? Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: useGradient
                  ? Colors.white.withOpacity(0.3)
                  : (iconColor ?? Colors.teal).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 32,
              color: useGradient ? Colors.white : (iconColor ?? Colors.teal),
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: useGradient ? Colors.white : Colors.black87,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: useGradient
                    ? Colors.white.withOpacity(0.9)
                    : Colors.black54,
              ),
            ),
          ),
          trailing: onTap != null
              ? Icon(
                  Icons.arrow_forward_ios,
                  color: useGradient ? Colors.white : Colors.grey,
                )
              : null,
          onTap: onTap,
        ),
      ),
    );
  }
}
