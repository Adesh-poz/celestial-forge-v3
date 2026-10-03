import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:celestial_forge/providers/add_perk_mode_provider.dart';
import 'package:celestial_forge/providers/perk_draw_provider.dart';
import 'package:celestial_forge/screens/drawn_perks_page.dart';

class PerkDrawer extends ConsumerWidget {
  const PerkDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drawState = ref.watch(perkDrawProvider);
    final drawNotifier = ref.read(perkDrawProvider.notifier);

    // Read the current value of isAddModeEnabled
    final isAddModeEnabled = ref.watch(addModeProvider);

    return Drawer(
      width: MediaQuery.of(context).orientation == Orientation.landscape
          ? MediaQuery.of(context).size.width * 0.45
          : null,
      child: SafeArea(
        top: false,
        left: MediaQuery.of(context).orientation == Orientation.landscape
            ? false
            : true,
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).orientation == Orientation.landscape
                ? MediaQuery.of(context).size.width * 0.8
                : MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height:
                      MediaQuery.of(context).orientation ==
                          Orientation.landscape
                      ? 150
                      : 250,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(12),
                    ),
                    gradient: LinearGradient(
                      colors: [Colors.deepPurple.shade800, Colors.black],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CircleAvatar(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.surface.withValues(alpha: 0.7),
                            radius: 15,
                            child: Image.asset(
                              'assets/images/forge.png',
                              width: 35,
                              height: 35,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Celestial Forge V3',
                            textAlign: TextAlign.end,
                            style: GoogleFonts.raleway(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Roll for a Perk based on your current CP!',
                        textAlign: TextAlign.end,
                        style: GoogleFonts.poppins(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 8,
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Theme.of(
                      context,
                    ).colorScheme.surface.withValues(alpha: 0.85),
                    elevation: 2,
                    child: ListTile(
                      title: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Current CP\n',
                              style: GoogleFonts.raleway(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: '${drawState.currentCP}',
                              style: GoogleFonts.raleway(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: 'Decrease 50 CP',
                            icon: const Icon(Icons.remove),
                            onPressed: () => drawNotifier.decrementCP(50),
                          ),
                          IconButton(
                            tooltip: 'Increase 50 CP',
                            icon: const Icon(Icons.add),
                            onPressed: () => drawNotifier.incrementCP(50),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: AnimatedButton(
                    onPressed: () => drawNotifier.drawPerk(),
                    icon: Icons.casino,
                    label: 'Draw Perk',
                    backgroundColor: Colors.amber,
                    textStyle: GoogleFonts.raleway(),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: AnimatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const OwnedPerksPage()),
                    ),
                    icon: Icons.list_alt_rounded,
                    label: 'Owned Perks',
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    textStyle: GoogleFonts.poppins(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 20.0,
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Theme.of(
                      context,
                    ).colorScheme.surface.withValues(alpha: 0.85),
                    elevation: 2,
                    child: SwitchListTile(
                      visualDensity: VisualDensity.compact,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      value: isAddModeEnabled,
                      onChanged: (value) {
                        // Toggle the isAddModeEnabled state
                        ref.read(addModeProvider.notifier).state =
                            !isAddModeEnabled;
                      },
                      thumbColor: WidgetStatePropertyAll(
                        Theme.of(context).colorScheme.onPrimary,
                      ),
                      activeThumbColor: Theme.of(context).colorScheme.secondary,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 8,
                      ),
                      title: Text(
                        'Toggle Add Mode',
                        style: GoogleFonts.raleway(fontWeight: FontWeight.w600),
                      ),
                      dense: true,
                      subtitle: Text(
                        'Enable Perk adding from Perks list',
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.raleway(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 8.0,
                      bottom: 8.0,
                      top: 50,
                    ),
                    child: Text(
                      'Created with \u2764\uFE0F by Adesh',
                      textAlign: TextAlign.end,
                      style: GoogleFonts.poppins(color: Colors.white54),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedButton extends StatefulWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final TextStyle textStyle;

  const AnimatedButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.textStyle,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  double _scale = 1.0;

  void _onTapDown(_) {
    setState(() => _scale = 0.95); // shrink a bit
  }

  void _onTapUp(_) {
    setState(() => _scale = 1.0); // back to normal
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeInOut,
        child: ElevatedButton.icon(
          onPressed: widget.onPressed,
          icon: Icon(widget.icon),
          label: Text(widget.label),
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.backgroundColor,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(48),
            textStyle: widget.textStyle,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}
