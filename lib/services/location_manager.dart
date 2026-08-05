import '../models/location.dart';
import '../models/game_flags.dart';

class LocationManager {
  static List<Location> availableLocations(GameFlags flags) {
    final locations = <Location>[
      Location.hospital,
    ];

    if (flags.policeCalled) {
      locations.add(Location.police);
    }

    if (flags.raveDiscovered) {
      locations.add(Location.raveHouse);
      locations.add(Location.crimeScene);
    }

    if (flags.warehouseUnlocked) {
      locations.add(Location.warehouse);
    }

    return locations;
  }
}