enum PatientStatus {
  stable,
  serious,
  critical,
  dead,
}

class Patient {

  int stability = 70;

  PatientStatus status;

  Patient({
    this.status = PatientStatus.stable,
  });

}