import 'package:flutter/material.dart';

import 'decision_type.dart';
import 'game_state.dart';
import 'location.dart';

class Decision {

  /// Identificador único
  final String id;

  /// Nombre mostrado al jugador
  final String title;

  /// Descripción corta
  final String description;

  /// Costo en dinero
  final int moneyCost;

  /// Cambio de confianza si tiene éxito
  final int trustChange;

  /// Resultado mostrado si sale bien
  final String result;

  /// Evidencia obtenida (opcional)
  final String? evidence;

  /// Nodo al que avanza si sale bien
  final String nextNode;

  /// Probabilidad de éxito (0-100)
  final int successRate;

  /// Resultado si falla
  final String failResult;

  /// Nodo al que avanza si falla
  final String failNode;

  final IconData icon;

  final DecisionType type;

  final bool unique;

  final int apCost;

  final Location location;

  final bool Function(GameState game)? condition;

  final void Function(GameState game)? onSuccess;

  final void Function(GameState game)? onFail;

  const Decision({
    required this.id,
    required this.title,
    required this.description,
    required this.moneyCost,
    required this.trustChange,
    required this.result,
    required this.nextNode,
    required this.icon,
    required this.type,
    required this.location,

    this.evidence,

    this.successRate = 100,

    this.failResult = "",

    this.failNode = "",

    this.unique = true,

    this.apCost = 1,

    this.condition,

    this.onSuccess,

    this.onFail,
  });

  bool isAvailable(GameState game){

    return condition?.call(game) ?? true;

  }

}