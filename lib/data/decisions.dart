import 'package:flutter/material.dart';

import '../models/decision.dart';
import '../models/decision_type.dart';
import '../models/location.dart';
import 'hospital_decisions.dart';

final decisions = {

  ...hospitalDecisions,

  ...policeDecisions,

  ...crimeSceneDecisions,

  ...raveHouseDecisions,

  ...warehouseDecisions,

};