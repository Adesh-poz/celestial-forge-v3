import 'package:celestial_forge/models/perk_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:celestial_forge/components/perk_details_bottomsheet.dart';
import 'package:celestial_forge/providers/add_perk_mode_provider.dart';
import 'package:celestial_forge/providers/perk_draw_provider.dart';

class PerkExpansionTile extends ConsumerWidget {
  final Map<String, dynamic> perk;

  const PerkExpansionTile({super.key, required this.perk});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subPerks = perk['sub_perks'] as List<dynamic>;

    // Watch the value of isAddModeEnabled
    final isAddModeEnabled = ref.watch(addModeProvider);

    final drawNotifier = ref.read(perkDrawProvider.notifier);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
      ),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        leading: const Icon(
          Icons.extension,
          color: Colors.teal,
        ),
        title: Text(
          perk['name'],
          style: GoogleFonts.raleway(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${perk['source']} — ${perk['cost']}',
          style: GoogleFonts.poppins(fontSize: 13),
        ),
        children: subPerks.asMap().entries.map((entry) {
          final index = entry.key;
          final sub = entry.value;

          final subTile = ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            leading: const Icon(
              Icons.arrow_right,
              color: Colors.deepPurple,
            ),
            title: Text(
              '${sub['name']} — ${sub['cost']}',
              style: GoogleFonts.raleway(),
            ),
            trailing: isAddModeEnabled
                ? IconButton.outlined(
                    visualDensity: VisualDensity.compact,
                    onPressed: () {
                      drawNotifier.addOwnedPerk(
                          context, PerkModel.fromJson(sub));
                    },
                    icon: const Icon(Icons.add_rounded),
                  )
                : null,
            onTap: () => showPerkDetailsBottomSheet(
              context: context,
              name: sub['name'],
              cost: sub['cost'],
              source: sub['source'], // or, use parent's source: perk['source']
              description: sub['description'],
            ),
          );

          return Column(
            children: [
              subTile,
              if (index != subPerks.length - 1)
                const Divider(
                  indent: 55,
                  endIndent: 16,
                  thickness: 0.3,
                  height: 1,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
