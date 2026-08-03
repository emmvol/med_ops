enum PatientStatus {
  stable,
  serious,
  critical,
  dead,
}

class Patient {

  PatientStatus status;

  Patient({
    this.status = PatientStatus.stable,
  });

}