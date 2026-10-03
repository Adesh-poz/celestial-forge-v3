import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:celestial_forge/components/perk_expansion_tile.dart';
import 'package:celestial_forge/components/perk_tile.dart';

class AnimatedDomainTile extends StatefulWidget {
  final Map<String, dynamic> domain;
  final bool isExpanded;
  final void Function(bool isExpanded)? onExpansionChanged;

  const AnimatedDomainTile({
    super.key,
    required this.domain,
    required this.isExpanded,
    required this.onExpansionChanged,
  });

  @override
  State<AnimatedDomainTile> createState() => _AnimatedDomainTileState();
}

class _AnimatedDomainTileState extends State<AnimatedDomainTile>
    with SingleTickerProviderStateMixin {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.isExpanded;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _expanded = widget.isExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: ExpansionTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          initiallyExpanded: _expanded,
          onExpansionChanged: (expanded) {
            setState(() => _expanded = expanded);
            widget.onExpansionChanged?.call(expanded);
          },
          leading: AnimatedRotation(
            turns: _expanded
                ? (widget.domain['icon'] != "" ? 0.15 : 0.25)
                : 0.0,
            duration: const Duration(milliseconds: 300),
            child: Image.asset(
              widget.domain['icon'] ?? '',
              width: 25,
              height: 25,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.category, color: Colors.indigo),
            ),
          ),
          title: Text(
            '${widget.domain['name']} (${widget.domain['total_perks']} perks)',
            style: GoogleFonts.raleway(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          children: [
            ListView.separated(
              shrinkWrap: true,
              itemCount: widget.domain['perks'].length,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(),
              itemBuilder: (context, index) {
                final perk = widget.domain['perks'][index];

                return TweenAnimationBuilder(
                  duration: Duration(milliseconds: 300 + index * 50),
                  tween: Tween<double>(begin: 0.95, end: 1),
                  curve: Curves.easeOutBack,
                  builder: (context, value, child) {
                    return Transform.scale(scale: value, child: child);
                  },
                  child: perk.containsKey('sub_perks')
                      ? PerkExpansionTile(perk: perk)
                      : PerkTile(perk: perk),
                );
              },
              separatorBuilder: (_, __) => const Divider(
                indent: 16,
                endIndent: 16,
                thickness: 0.3,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
