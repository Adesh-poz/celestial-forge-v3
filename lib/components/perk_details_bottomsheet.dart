import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:celestial_forge/custom_dividers.dart';

/// A Bottom Sheet to show the details of the perk
void showPerkDetailsBottomSheet({
  required BuildContext context,
  required String name,
  required String cost,
  required String source,
  required String? description,
}) {
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    useSafeArea: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    backgroundColor: Theme.of(context).colorScheme.surface,
    clipBehavior: Clip.antiAlias,
    builder: (_) => SafeArea(
      left: false,
      top: false,
      right: false,
      bottom: true,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              Theme.of(context).colorScheme.onSecondary.withValues(alpha: 0.95),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const CustomDivider(height: 15, widthFactor: 0.35),
              SelectableText(
                name,
                textAlign: TextAlign.center,
                style: GoogleFonts.raleway(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const CustomDivider(height: 15, widthFactor: 0.35),
              SelectableText(
                '$source — $cost',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              const SizedBox(height: 16),
              SelectableText(
                description ?? 'No description available.',
                style: GoogleFonts.poppins(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
