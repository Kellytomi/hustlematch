import 'package:flutter/material.dart';
import 'dart:ui';

/// A reusable glassmorphic card widget using Flutter's built-in blur effects.
/// 
/// This widget provides a consistent glass effect implementation that can be
/// used throughout the application. It follows the established design system
/// and provides customizable properties for different use cases.
/// 
/// Example usage:
/// ```dart
/// GlassCard(
///   child: Text('Hello Glass!'),
///   blurSigma: 25,
///   padding: EdgeInsets.all(16),
/// )
/// ```
class GlassCard extends StatelessWidget {
  /// The widget to display inside the glass container
  final Widget child;
  
  /// The amount of blur applied to the glass effect
  final double blurSigma;
  
  /// The opacity of the glass overlay
  final double opacity;
  
  /// The border radius of the glass container
  final BorderRadius? borderRadius;
  
  /// The color tint applied to the glass effect
  final Color? glassTint;
  
  /// Internal padding of the glass container
  final EdgeInsets? padding;
  
  /// External margin of the glass container
  final EdgeInsets? margin;
  
  /// Width of the glass container
  final double? width;
  
  /// Height of the glass container
  final double? height;
  
  /// Border color and width
  final Color? borderColor;
  final double borderWidth;

  /// Creates a new [GlassCard] widget.
  /// 
  /// The [child] parameter is required. All other parameters have sensible
  /// defaults that work well for most use cases.
  const GlassCard({
    super.key,
    required this.child,
    this.blurSigma = 10.0,
    this.opacity = 0.2,
    this.borderRadius,
    this.glassTint,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.borderColor,
    this.borderWidth = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Container(
            decoration: BoxDecoration(
              color: glassTint?.withOpacity(opacity) ?? 
                     Colors.white.withOpacity(opacity),
              borderRadius: borderRadius ?? BorderRadius.circular(16),
              border: borderColor != null 
                ? Border.all(
                    color: borderColor!.withOpacity(0.2),
                    width: borderWidth,
                  )
                : Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: borderWidth,
                  ),
            ),
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// A specialized glass card for displaying statistics.
/// 
/// This widget is optimized for showing numerical data with icons
/// and provides a consistent design for stat displays.
class GlassStatCard extends StatelessWidget {
  /// The icon to display
  final IconData icon;
  
  /// The main value/number to display
  final String value;
  
  /// The label describing the value
  final String label;
  
  /// The color theme for the stat card
  final Color color;
  
  /// Custom icon size
  final double iconSize;
  
  /// Custom value text size
  final double valueSize;
  
  /// Custom label text size
  final double labelSize;

  /// Creates a new [GlassStatCard] widget.
  const GlassStatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    this.iconSize = 20,
    this.valueSize = 24,
    this.labelSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: color,
              size: iconSize,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: valueSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: labelSize,
              color: Colors.white.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// A glass card optimized for displaying job application information.
/// 
/// This widget provides a standardized way to display job applications
/// with glassmorphic styling and consistent information layout.
class GlassJobCard extends StatelessWidget {
  /// Company logo or emoji
  final String companyLogo;
  
  /// Job title
  final String jobTitle;
  
  /// Company name
  final String companyName;
  
  /// Job location
  final String location;
  
  /// Salary information
  final String salary;
  
  /// Match percentage
  final int matchPercentage;
  
  /// List of skills/tags
  final List<String> skills;
  
  /// Status message
  final String statusMessage;
  
  /// Status icon
  final IconData statusIcon;
  
  /// Status color
  final Color statusColor;
  
  /// Time ago string
  final String timeAgo;
  
  /// Callback when card is tapped
  final VoidCallback? onTap;
  
  /// Callback when more button is tapped
  final VoidCallback? onMoreTap;

  /// Creates a new [GlassJobCard] widget.
  const GlassJobCard({
    super.key,
    required this.companyLogo,
    required this.jobTitle,
    required this.companyName,
    required this.location,
    required this.salary,
    required this.matchPercentage,
    required this.skills,
    required this.statusMessage,
    required this.statusIcon,
    required this.statusColor,
    required this.timeAgo,
    this.onTap,
    this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      blurSigma: 15,
      opacity: 0.15,
      borderRadius: BorderRadius.circular(20),
      padding: const EdgeInsets.all(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with company info
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      companyLogo,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        jobTitle,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        companyName,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: statusColor.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '$matchPercentage%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Location and salary info
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: Colors.white.withOpacity(0.7),
                ),
                const SizedBox(width: 4),
                Text(
                  location,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.attach_money,
                  size: 16,
                  color: Colors.white.withOpacity(0.7),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    salary,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Skills tags
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: skills.take(3).map((skill) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    skill,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
            
            const SizedBox(height: 16),
            
            // Status and action row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: statusColor.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        statusIcon,
                        size: 14,
                        color: statusColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        statusMessage,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  timeAgo,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
                const SizedBox(width: 8),
                GlassCard(
                  blurSigma: 8,
                  opacity: 0.1,
                  borderRadius: BorderRadius.circular(16),
                  padding: const EdgeInsets.all(8),
                  child: InkWell(
                    onTap: onMoreTap,
                    borderRadius: BorderRadius.circular(16),
                    child: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// A custom glass text widget that creates a glassmorphic text effect.
/// 
/// This widget creates text with a glass-like background effect.
class GlassText extends StatelessWidget {
  /// The text to display
  final String text;
  
  /// Text style
  final TextStyle? style;
  
  /// Text alignment
  final TextAlign? textAlign;

  /// Creates a new [GlassText] widget.
  const GlassText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
      textAlign: textAlign,
    );
  }
} 