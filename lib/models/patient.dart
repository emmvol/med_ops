enum PatientStatus {
  stable,
  serious,
  critical,
  dead,
}

class Patient {

  int stability;

  Patient({
    this.stability = 55,
  });

  PatientStatus get status {

    if (stability <= 0) {
      return PatientStatus.dead;
    }

    if (stability <= 40) {
      return PatientStatus.critical;
    }

    if (stability <= 70) {
      return PatientStatus.serious;
    }

    return PatientStatus.stable;
  }

  void modifyStability(int amount) {

    stability += amount;

    if (stability < 0) {
      stability = 0;
    }

    if (stability > 100) {
      stability = 100;
    }
  }

  void reset() {
    stability = 55;
  }
}