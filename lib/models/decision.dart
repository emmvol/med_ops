import 'package:flutter/material.dart';

import 'decision_type.dart';
import 'game_state.dart';
import 'location.dart';

enum DecisionRepeat {

  once,
  repeatable,

}

class Decision {

  final String id;

  final String title;

  final String description;

  final IconData icon;

  final DecisionType type;

  final Location location;

  final int expediente;

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

  const Decision({

    required this.id,
    required this.title,
    required this.description,

    required this.icon,
    required this.type,

    required this.location,

    required this.expediente,

    this.repeat = DecisionRepeat.once,

    this.apCost = 1,

    required this.moneyCost,

    required this.trustChange,

    required this.result,

    this.failResult = "",

    this.successRate = 100,

    this.evidence,

    this.condition,

    this.onSuccess,

    this.onFail,

  });

  bool isAvailable(GameState game){

    return condition?.call(game) ?? true;

  }

}