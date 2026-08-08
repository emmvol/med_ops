class GameFlags {

  // ============================================================
  // EXPEDIENTE 1 — PACIENTE ÍNDICE
  // ============================================================

  bool patientStable = false;
  bool patientCritical = true;
  bool patientAwake = false;
  bool patientDead = false;

  bool vitalsTaken = false;
  bool glucoseChecked = false;
  bool ecgPerformed = false;
  bool ivAccessObtained = false;
  bool agitationControlled = false;
  bool airwaySecured = false;

  bool paramedicsInterviewed = false;

  // ============================================================
  // EXPEDIENTE 1 — INVESTIGACIÓN
  // ============================================================

  bool foundPhone = false;
  bool raveBraceletFound = false;
  bool raveDiscovered = false;

  bool labRequested = false;
  bool labConfirmed = false;
  bool laboratoryCompleted = false;

  bool policeCalled = false;
  bool policeTrust = false;

  bool exp1Complete = false;

  // ============================================================
  // MINICASO — PACIENTE ÍNDICE DESPIERTO
  // ============================================================

  bool indexPatientInterviewStarted = false;
  bool indexPatientInterviewCompleted = false;

  // ============================================================
  // EXPEDIENTE 2 — PACIENTES SECUNDARIOS
  // ============================================================

  bool secondaryPatientArrived = false;
  bool secondaryPatientInterviewed = false;
  bool secondaryVitalsTaken = false;
  bool secondaryPatientResolved = false;
  bool secondaryReassessed = false;

  bool specialPatientArrived = false;
  bool specialPatientResolved = false;

  bool knowsAlias = false;

  // ============================================================
  // EXPEDIENTE 2 — POLICÍA
  // ============================================================

  bool witnessInterviewed = false;
  bool organizerInterviewed = false;
  bool phoneTracked = false;

  bool raveHouseSuspected = false;
  bool raveHouseIdentified = false;
  bool raveHouseUnlocked = false;

  bool exp2HospitalReviewComplete = false;
  bool exp2Complete = false;

  // ============================================================
  // EXPEDIENTE 3 — CASA DEL RAVE
  // ============================================================

  bool raveHouseVisited = false;
  bool raveHouseInspected = false;
  bool raveHouseEvidenceFound = false;
  bool raveHouseReconstructed = false;

  bool crimeSceneLeadFound = false;
  bool crimeSceneUnlocked = false;

  bool exp3Complete = false;

  // ============================================================
  // EXPEDIENTE 4 — ESCENA DEL CRIMEN
  // ============================================================

  bool crimeSceneVisited = false;
  bool crimeSceneDocumented = false;
  bool crimeSceneInspected = false;

  bool crimeSceneEvidenceFound = false;
  bool warehouseLeadFound = false;
  bool warehouseUnlocked = false;

  // ============================================================
  // EXPEDIENTE 4 — AUTOPSIA
  // ============================================================

  bool autopsyUnlocked = false;
  bool autopsyRequested = false;
  bool autopsyCompleted = false;

  bool familyInterviewed = false;

  // ============================================================
  // EXPEDIENTE 4
  // ============================================================

  bool exp4Complete = false;

  // ============================================================
  // EXPEDIENTE 5 — ALMACÉN
  // ============================================================

  bool warehouseVisited = false;
  bool warehouseInspected = false;
  bool distributionEvidenceFound = false;
  bool quimeraNetworkIdentified = false;

  bool finalEvidenceSecured = false;
  bool exp5Complete = false;

  // ============================================================
  // RESET
  // ============================================================

  void reset() {

    patientStable = false;
    patientCritical = true;
    patientAwake = false;
    patientDead = false;

    vitalsTaken = false;
    glucoseChecked = false;
    ecgPerformed = false;
    ivAccessObtained = false;
    agitationControlled = false;
    airwaySecured = false;

    paramedicsInterviewed = false;

    foundPhone = false;
    raveBraceletFound = false;
    raveDiscovered = false;

    labRequested = false;
    labConfirmed = false;
    laboratoryCompleted = false;

    policeCalled = false;
    policeTrust = false;

    exp1Complete = false;

    indexPatientInterviewStarted = false;
    indexPatientInterviewCompleted = false;

    secondaryPatientArrived = false;
    secondaryPatientInterviewed = false;
    secondaryVitalsTaken = false;
    secondaryPatientResolved = false;
    secondaryReassessed = false;

    specialPatientArrived = false;
    specialPatientResolved = false;

    knowsAlias = false;

    witnessInterviewed = false;
    organizerInterviewed = false;
    phoneTracked = false;

    raveHouseSuspected = false;
    raveHouseIdentified = false;
    raveHouseUnlocked = false;

    exp2HospitalReviewComplete = false;
    exp2Complete = false;

    raveHouseVisited = false;
    raveHouseInspected = false;
    raveHouseEvidenceFound = false;
    raveHouseReconstructed = false;

    crimeSceneLeadFound = false;
    crimeSceneUnlocked = false;

    exp3Complete = false;

    crimeSceneVisited = false;
    crimeSceneDocumented = false;
    crimeSceneInspected = false;

    crimeSceneEvidenceFound = false;
    warehouseLeadFound = false;
    warehouseUnlocked = false;

    autopsyUnlocked = false;
    autopsyRequested = false;
    autopsyCompleted = false;

    familyInterviewed = false;

    exp4Complete = false;

    warehouseVisited = false;
    warehouseInspected = false;
    distributionEvidenceFound = false;
    quimeraNetworkIdentified = false;

    finalEvidenceSecured = false;
    exp5Complete = false;
  }
}