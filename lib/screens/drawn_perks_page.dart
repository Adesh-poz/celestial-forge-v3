import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:celestial_forge/providers/perk_draw_provider.dart';

/// Displays the list of owned perks drawn from the Celestial Forge.
/// - Allows users to swipe to remove perks.
/// - Shows an undo SnackBar.
/// - Fetches data from Riverpod provider `perkDrawProvider`.
class OwnedPerksPage extends ConsumerWidget {
  const OwnedPerksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the list of owned perks from provider state
    final owned = ref.watch(perkDrawProvider.select((state) => state.owned));
    final drawNotifier = ref.read(perkDrawProvider.notifier);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shadowColor: Colors.black,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Owned Perks (${owned.length})',
          style: GoogleFonts.raleway(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        elevation: 6.0,
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/space-bg.jpg'), // Cosmic vibes
            fit: BoxFit.cover,
          ),
        ),
        child: owned.isEmpty
            ? Center(
                child: Text(
                  'No perks owned yet.',
                  style: GoogleFonts.poppins(color: Colors.white70),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 55),
                itemCount: owned.length,
                itemBuilder: (context, index) {
                  final perk = owned[index];

                  return Dismissible(
                    // Uniquely identifies the widget (assumes unique perk names)
                    // NOTE: IDK how it'll act in case of mactching Perk names in the list.
                    // Might be a bug, lol
                    key: ValueKey(perk.name),
                    direction: DismissDirection.endToStart,
                    dismissThresholds: const {DismissDirection.horizontal: 0.7},
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.delete, color: Colors.redAccent),
                    ),
                    onDismissed: (direction) {
                      drawNotifier.removeOwnedPerk(perk);

                      // Show snackbar with undo
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: const Duration(seconds: 3),
                          margin: const EdgeInsets.fromLTRB(12, 5, 12, 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          behavior: SnackBarBehavior.floating,
                          // backgroundColor: Theme.of(
                          //   context,
                          // ).dialogTheme.backgroundColor?.withValues(alpha: 0.8),
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.surface.withValues(alpha: 0.9),
                          content: Text(
                            '"${perk.name}" removed!',
                            style: GoogleFonts.poppins(color: Colors.white),
                          ),
                          action: SnackBarAction(
                            label: 'UNDO',
                            textColor: Colors.purple,
                            onPressed: () {
                              drawNotifier.addOwnedPerk(context, perk);
                            },
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Theme.of(
                          context,
                        ).colorScheme.surface.withValues(alpha: 0.85),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            leading: const SizedBox(width: 30, height: 30),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  perk.name,
                                  style: GoogleFonts.raleway(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${perk.source} — ${perk.cost}',
                                  style: GoogleFonts.poppins(fontSize: 12),
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                            subtitle: Text(
                              perk.description,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            top: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.horizontal(
                                  left: Radius.circular(12),
                                ),
                                color: Theme.of(context).canvasColor,
                              ),
                              child: const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
