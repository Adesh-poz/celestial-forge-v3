import 'package:celestial_forge/models/perk_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:celestial_forge/components/perk_details_bottomsheet.dart';
import 'package:celestial_forge/providers/add_perk_mode_provider.dart';
import 'package:celestial_forge/providers/perk_draw_provider.dart';

class PerkTile extends ConsumerWidget {
  final Map<String, dynamic> perk;

  const PerkTile({super.key, required this.perk});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the value of isAddModeEnabled
    final isAddModeEnabled = ref.watch(addModeProvider);

    final drawNotifier = ref.read(perkDrawProvider.notifier);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      leading: const Icon(Icons.star, color: Colors.amber),
      title: Text(
        perk['name'],
        style: GoogleFonts.raleway(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        '${perk['source']} — ${perk['cost']}',
        style: GoogleFonts.poppins(fontSize: 13),
      ),
      trailing: isAddModeEnabled
          ? IconButton.outlined(
              visualDensity: VisualDensity.compact,
              onPressed: () {
                drawNotifier.addOwnedPerk(context, PerkModel.fromJson(perk));
              },
              icon: const Icon(Icons.add_rounded),
            )
          : null,
      onTap: () => showPerkDetailsBottomSheet(
        context: context,
        name: perk['name'],
        cost: perk['cost'],
        source: perk['source'],
        description: perk['description'],
      ),
    );
  }
}
