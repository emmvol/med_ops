class GameFlags {

  // ============================================================
  // PACIENTE
  // ============================================================

  bool patientStable = false;

  bool patientCritical = false;

  bool patientAwake = false;

  bool patientDead = false;

  bool vitalsTaken = false;

  bool glucoseChecked = false;

  bool ecgPerformed = false;

  bool ivAccessObtained = false;

  bool agitationControlled = false;

  bool airwaySecured = false;


  // ============================================================
  // INVESTIGACIÓN
  // ============================================================

  bool foundPhone = false;

  bool phoneTracked = false;

  bool knowsAlias = false;

  bool raveDiscovered = false;

  bool raveBraceletFound = false;

  bool warehouseUnlocked = false;

  bool laboratoryCompleted = false;

  bool labRequested = false;

  bool labConfirmed = false;

  bool paramedicsInterviewed = false;


  // ============================================================
  // POLICÍA
  // ============================================================

  bool policeCalled = false;

  bool policeTrust = false;


  // ============================================================
  // ESCENARIOS
  // ============================================================

  bool crimeSceneVisited = false;

  bool familyInterviewed = false;

  bool autopsyUnlocked = false;

  bool secondaryPatientArrived = false;
  bool secondaryPatientInterviewed = false;
  bool secondaryVitalsTaken = false;
  bool witnessInterviewed = false;
  bool organizerInterviewed = false;
  bool raveHouseSuspected = false;

  bool secondaryPatientResolved = false;

  bool specialPatientArrived = false;
  bool specialPatientResolved = false;

  void reset() {
    patientStable = false;
    patientAwake = false;
    patientDead = false;
    patientCritical = false;

    vitalsTaken = false;
    glucoseChecked = false;
    ecgPerformed = false;

    foundPhone = false;
    phoneTracked = false;
    knowsAlias = false;
    raveDiscovered = false;
    raveBraceletFound = false;

    warehouseUnlocked = false;
    laboratoryCompleted = false;
    labConfirmed = false;

    policeCalled = false;
    policeTrust = false;

    crimeSceneVisited = false;
    familyInterviewed = false;
    autopsyUnlocked = false;

    paramedicsInterviewed = false;

    secondaryPatientArrived = false;
    secondaryPatientInterviewed = false;
    secondaryVitalsTaken = false;
    witnessInterviewed = false;
    organizerInterviewed = false;
    raveHouseSuspected = false;

    secondaryPatientResolved = false;

    specialPatientArrived = false;
    specialPatientResolved = false;
  }

}