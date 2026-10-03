import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:celestial_forge/components/app_drawer.dart';
import 'package:celestial_forge/components/domain_expansion_tile.dart';
import 'package:celestial_forge/models/perk_model.dart';
import 'package:celestial_forge/providers/perk_draw_provider.dart';

/// HomePage widget is the entry point of the app's UI,
/// responsible for rendering the domain list loaded from a JSON file,
/// and initializing the perks for the perk draw system.
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _DomainListScreenState();
}

class _DomainListScreenState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  Future<Map<String, dynamic>>? _jsonFuture;
  bool _perksInitialized = false;
  bool isAddModeEnabled = false;

  late ScrollController _scrollController;
  double _scrollOffset = 0;

  late List<dynamic>? _domains;
  late List<bool>? isDomainExpanded;

  @override
  void initState() {
    super.initState();
    _jsonFuture = loadJson();

    // Listen to scroll and track the offset to apply dynamic AppBar background
    _scrollController = ScrollController()
      ..addListener(() {
        final newOffset = _scrollController.offset;
        if ((newOffset - _scrollOffset).abs() > 5) {
          setState(() {
            _scrollOffset = newOffset;
          });
        }
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Dynamically adjust AppBar color based on scroll to add that slick fade-in effect
  Color _getAppBarColor() {
    final themeColor = Theme.of(context).colorScheme.surface;
    final opacity = (_scrollOffset / 100).clamp(0, 1).toDouble();
    return themeColor.withValues(alpha: opacity);
  }

  /// Loads and parses the local structured JSON containing all domain + perk data.
  Future<Map<String, dynamic>> loadJson() async {
    final String response = await rootBundle.loadString(
      'assets/celestial_forge_v3_structured.json',
    );

    // Note: Artificial Delay added to have a smoother Loading Animation
    // Otherwise, this parsing/decoding operation is too quick, even with such a large data set.
    // Feel free to remove it to get quicker loading.
    await Future.delayed(const Duration(seconds: 1));

    return json.decode(response);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Background starfield to make it all feel spacey and cosmic
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/space-bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: const PerkDrawer(),
        body: FutureBuilder<Map<String, dynamic>>(
          future: _jsonFuture,
          builder: (context, snapshot) {
            // Show loading spinner while JSON loads
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SpinKitFadingCube(color: Colors.white),
                    const SizedBox(height: 20),
                    Text('Forge Loading...', style: GoogleFonts.raleway()),
                  ],
                ),
              );
            }

            // Error fallback with retry button
            if (!snapshot.hasData || snapshot.data == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline_rounded, size: 28),
                    const Text('Failed to load data.'),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: () {
                        setState(() {});
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        visualDensity: VisualDensity.comfortable,
                      ),
                      label: const Text('Retry'),
                      icon: const Icon(Icons.refresh_rounded, size: 18),
                    ),
                  ],
                ),
              );
            }

            _domains = (snapshot.data?["domains"] ?? []) as List<dynamic>;
            isDomainExpanded = List.generate(
              _domains?.length ?? 0,
              (index) => false,
            );

            // Initialize the perks pool only once after data is loaded
            if (!_perksInitialized) {
              _perksInitialized = true;
              Future.microtask(() {
                final drawNotifier = ref.read(perkDrawProvider.notifier);
                final allPerks = <PerkModel>[];

                // Flatten perks and sub-perks from each domain
                for (final domain in _domains!) {
                  for (final perk in domain['perks']) {
                    if (perk.containsKey('sub_perks')) {
                      for (final sub in perk['sub_perks']) {
                        allPerks.add(
                          PerkModel(
                            name: sub['name'],
                            cost: sub['cost'],
                            source: sub['source'],
                            description: sub['description'] ?? '',
                          ),
                        );
                      }
                    } else {
                      allPerks.add(
                        PerkModel(
                          name: perk['name'],
                          cost: perk['cost'],
                          source: perk['source'],
                          description: perk['description'] ?? '',
                        ),
                      );
                    }
                  }
                }

                drawNotifier.initialize(allPerks, 0);
              });
            }

            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 100,
                  elevation: 5,
                  backgroundColor: _getAppBarColor(),
                  shadowColor: Colors.black,
                  surfaceTintColor: Colors.transparent,
                  centerTitle: false,
                  leading:
                      const SizedBox(), // Empty space instead of back arrow
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () => Scaffold.of(context).openDrawer(),
                          radius: 13,
                          borderRadius: BorderRadius.circular(60),
                          child: CircleAvatar(
                            backgroundColor: Colors.white12,
                            minRadius: 9,
                            maxRadius: 13,
                            child: Image.asset(
                              'assets/images/forge.png',
                              width: 35,
                              height: 35,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            'Celestial Forge v3',
                            style: GoogleFonts.raleway(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    background: Container(
                      alignment: Alignment.bottomLeft,
                      padding: const EdgeInsets.only(top: 16, left: 70),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withValues(alpha: 0.7),
                            Colors.transparent,
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      child: Text(
                        'Explore the 38 Domains',
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _jsonFuture = loadJson();
                        });
                      },
                      icon: const Icon(Icons.refresh_rounded),
                    ),
                  ],
                ),

                /// SliverList for Domain Tiles
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    12,
                    10,
                    12,
                    MediaQuery.of(context).viewPadding.bottom + 12,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final domain = _domains?[index];

                      return TweenAnimationBuilder<Offset>(
                        duration: const Duration(milliseconds: 300),
                        tween: Tween<Offset>(
                          begin: const Offset(1, 0),
                          end: Offset.zero,
                        ),
                        curve: Curves.easeOutCubic,
                        builder: (context, offset, child) {
                          return Transform.translate(
                            offset: Offset(offset.dx * 30, 0),
                            child: child,
                          );
                        },
                        child: AnimatedDomainTile(
                          domain: domain,
                          isExpanded: isDomainExpanded![index],
                          onExpansionChanged: (value) =>
                              setState(() => isDomainExpanded?[index] = value),
                        ),
                      );
                    }, childCount: _domains?.length),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
