import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import 'package:celestial_forge/models/perk_model.dart';

class PerkDrawState {
  int currentCP;
  List<PerkModel> owned;
  List<PerkModel> remaining;

  PerkDrawState({
    required this.currentCP,
    required this.owned,
    required this.remaining,
  });

  PerkDrawState copyWith({
    int? currentCP,
    List<PerkModel>? owned,
    List<PerkModel>? remaining,
  }) {
    return PerkDrawState(
      currentCP: currentCP ?? this.currentCP,
      owned: owned ?? this.owned,
      remaining: remaining ?? this.remaining,
    );
  }
}

class PerkDrawNotifier extends StateNotifier<PerkDrawState> {
  final Box<PerkModel> ownedBox = Hive.box<PerkModel>('ownedPerks');
  final Box<PerkModel> remainingBox = Hive.box<PerkModel>('remainingPerks');
  final Box<int> cpBox = Hive.box<int>('cpBox');

  PerkDrawNotifier()
      : super(PerkDrawState(
          currentCP: Hive.box<int>('cpBox').get('cp', defaultValue: 0) ?? 0,
          owned: Hive.box<PerkModel>('ownedPerks').values.toList(),
          remaining: Hive.box<PerkModel>('remainingPerks').values.toList(),
        ));

  void initialize(List<PerkModel> allPerks, int savedCP) {
    if (remainingBox.isEmpty && ownedBox.isEmpty) {
      for (var perk in allPerks) {
        remainingBox.add(perk);
      }
      cpBox.put('cp', savedCP);
      state = state.copyWith(
        currentCP: savedCP,
        owned: [],
        remaining: List.from(allPerks),
      );
    }
  }

  void _persistState() {
    ownedBox.clear();

    for (var p in state.owned) {
      ownedBox.add(p.clone());
    }

    remainingBox.clear();

    for (var p in state.remaining) {
      remainingBox.add(p.clone());
    }

    cpBox.put('cp', state.currentCP);
  }

  void incrementCP([int value = 50]) {
    state = state.copyWith(currentCP: state.currentCP + value);
    _persistState();
  }

  void decrementCP([int value = 50]) {
    state =
        state.copyWith(currentCP: (state.currentCP - value).clamp(0, 99999));
    _persistState();
  }

  void drawPerk() {
    if (state.remaining.isEmpty) return;
    final random = Random();
    final index = random.nextInt(state.remaining.length);
    final perk = state.remaining[index];

    final perkCost =
        int.tryParse(perk.cost.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

    if (perkCost <= state.currentCP) {
      final updatedOwned = [...state.owned, perk];
      final updatedRemaining = [...state.remaining]..removeAt(index);

      state = state.copyWith(
        currentCP: state.currentCP - perkCost,
        owned: updatedOwned,
        remaining: updatedRemaining,
      );
    } else {
      state = state.copyWith(currentCP: state.currentCP + 50);
    }

    _persistState();
  }

  void resetDrawPool(List<PerkModel> allPerks) {
    state = state.copyWith(remaining: List.from(allPerks));
    _persistState();
  }

  void removeOwnedPerk(PerkModel perk) {
    final updated = List<PerkModel>.from(state.owned)..remove(perk);
    state = state.copyWith(owned: updated);
    _persistState();
  }

  // void addOwnedPerk(PerkModel perk) {
  //   final updated = List<PerkModel>.from(state.owned)..add(perk);
  //   state = state.copyWith(owned: updated);
  //   _persistState();
  // }
  void addOwnedPerk(BuildContext context, PerkModel perk) {
    // Check if the perk is already in the list of owned perks
    final isPerkAlreadyAdded =
        state.owned.any((ownedPerk) => ownedPerk.name == perk.name);

    if (isPerkAlreadyAdded) {
      // Show a Snackbar if the perk is already in the owned list
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '"${perk.name}" is already in your owned perks!',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent,
          duration: const Duration(seconds: 1),
        ),
      );
    } else {
      // Proceed with adding the perk if it is not already in the list
      final updated = List<PerkModel>.from(state.owned)..add(perk);
      state = state.copyWith(owned: updated);
      _persistState();
    }
  }
}

final perkDrawProvider =
    StateNotifierProvider<PerkDrawNotifier, PerkDrawState>((ref) {
  return PerkDrawNotifier();
});
