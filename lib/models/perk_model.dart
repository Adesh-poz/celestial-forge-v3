import 'package:hive/hive.dart';

part 'perk_model.g.dart';

@HiveType(typeId: 0)
class PerkModel extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String source;

  @HiveField(2)
  final String cost;

  @HiveField(3)
  final String description;

  PerkModel({
    required this.name,
    required this.source,
    required this.cost,
    required this.description,
  });

  factory PerkModel.fromJson(Map<String, dynamic> json) => PerkModel(
        name: json['name'],
        source: json['source'],
        cost: json['cost'],
        description: json['description'] ?? 'No descripption found',
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'source': source,
        'cost': cost,
        'description': description,
      };
}

extension PerkClone on PerkModel {
  PerkModel clone() => PerkModel(
        name: name,
        cost: cost,
        source: source,
        description: description,
      );
}
