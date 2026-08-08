import 'package:flutter/material.dart';

import 'decision_type.dart';
import 'game_state.dart';
import 'location.dart';

enum DecisionRepeat {
  once,
  repeatable,
  untilSuccess,
}

class Decision {

  final String id;

  final int expediente;

  final String title;

  final String description;

  final IconData icon;

  final DecisionType type;

  final Location location;

  final DecisionRepeat repeat;

  final int apCost;

  final int moneyCost;

  final int trustChange;

  final int successRate;

  final String result;

  final String failResult;

  final String? evidence;

  final bool Function(GameState game)? condition;

  final void Function(GameState game)? onSuccess;

  final void Function(GameState game)? onFail;

  /// Nodo narrativo al que se avanza después de una decisión exitosa.
  final String? nextNode;

  /// Nodo narrativo opcional si la decisión falla.
  final String? failNextNode;

  const Decision({
    required this.id,
    required this.expediente,
    required this.title,
    required this.description,
    required this.icon,
    required this.type,
    required this.location,
    required this.repeat,
    required this.apCost,
    required this.moneyCost,
    required this.trustChange,
    required this.successRate,
    required this.result,
    this.failResult = "",
    this.evidence,
    this.condition,
    this.onSuccess,
    this.onFail,
    this.nextNode,
    this.failNextNode,
  });

  bool isAvailable(GameState game) {
    return condition?.call(game) ?? true;
  }
}