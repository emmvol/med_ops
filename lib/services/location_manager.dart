import '../models/game_state.dart';
import '../models/location.dart';

class LocationManager {

  static List<Location> availableLocations(GameState game) {

    final flags = game.flags;

    final locations = <Location>[
      Location.hospital,
    ];

    // ============================================================
    // POLICÍA
    // ============================================================

    if (flags.policeUnlocked) {
      locations.add(Location.police);
    }

    // ============================================================
    // EXPEDIENTE 3 — CASA DEL RAVE
    //
    // Solo se puede visitar cuando:
    // 1. El expediente 3 está activo.
    // 2. La integración del expediente 2 fue aprobada.
    // 3. La casa fue identificada.
    // ============================================================

    if (
    game.currentExpediente >= 3 &&
        flags.evalExp2IntegrationCompleted &&
        flags.raveHouseIdentified
    ) {
      locations.add(Location.raveHouse);
    }

    // ============================================================
    // EXPEDIENTE 4 — ESCENA DEL CRIMEN
    //
    // Solo se puede visitar cuando:
    // 1. El expediente 4 está activo.
    // 2. La integración del expediente 3 fue aprobada.
    // 3. La escena fue identificada como siguiente ubicación.
    // ============================================================

    if (
    game.currentExpediente >= 4 &&
        flags.evalExp3IntegrationCompleted &&
        flags.crimeSceneUnlocked
    ) {
      locations.add(Location.crimeScene);
    }

    // ============================================================
    // EXPEDIENTE 5 — ALMACÉN
    //
    // Solo se puede visitar cuando:
    // 1. El expediente 5 está activo.
    // 2. La integración del expediente 4 fue aprobada.
    // 3. El almacén fue desbloqueado.
    // ============================================================

    if (
    game.currentExpediente >= 5 &&
        flags.evalExp4IntegrationCompleted &&
        flags.warehouseUnlocked
    ) {
      locations.add(Location.warehouse);
    }

    return locations;
  }
}