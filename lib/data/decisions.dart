import 'package:med_ops/data/hospital_expediente2_decisions.dart';
import 'package:med_ops/data/police_decisions.dart';
import 'package:med_ops/data/rave_house_decisions.dart';
import 'package:med_ops/data/warehouse_decisions.dart';

import 'crime_scene_decisions.dart';
import 'hospital_decisions.dart';
import 'hospital_expediente4_decisions.dart';

final decisions = {

  ...hospitalDecisions,
  ...hospitalExpediente2Decisions,
  ...hospitalExpediente4Decisions,

  ...policeDecisions,

  ...crimeSceneDecisions,

  ...raveHouseDecisions,

  ...warehouseDecisions,

};