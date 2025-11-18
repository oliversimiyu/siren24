import 'package:siren24/Models/facility.dart';

class FacilityService {
  // Mock data for nearby medical facilities
  static List<Facility> getMockFacilities() {
    return [
      Facility(
        id: "1",
        name: "Nairobi Hospital",
        type: "General Hospital",
        address: "Argwings Kodhek Rd, Nairobi",
        latitude: -1.3003,
        longitude: 36.8062,
        distance: 2.5,
        phone: "+254 20 2845000",
        isAvailable: true,
        rating: 4.5,
      ),
      Facility(
        id: "2",
        name: "Aga Khan Hospital",
        type: "Private Hospital",
        address: "3rd Parklands Ave, Nairobi",
        latitude: -1.2634,
        longitude: 36.8155,
        distance: 3.2,
        phone: "+254 20 3740000",
        isAvailable: true,
        rating: 4.7,
      ),
      Facility(
        id: "3",
        name: "MP Shah Hospital",
        type: "Private Hospital",
        address: "Shivachi Rd, Nairobi",
        latitude: -1.2921,
        longitude: 36.8219,
        distance: 1.8,
        phone: "+254 20 4269000",
        isAvailable: true,
        rating: 4.3,
      ),
      Facility(
        id: "4",
        name: "Kenyatta National Hospital",
        type: "Public Hospital",
        address: "Hospital Rd, Nairobi",
        latitude: -1.3013,
        longitude: 36.8067,
        distance: 4.1,
        phone: "+254 20 2726300",
        isAvailable: true,
        rating: 4.0,
      ),
      Facility(
        id: "5",
        name: "Karen Hospital",
        type: "Private Hospital",
        address: "Karen Rd, Karen",
        latitude: -1.3197,
        longitude: 36.6907,
        distance: 5.5,
        phone: "+254 20 6610000",
        isAvailable: true,
        rating: 4.4,
      ),
      Facility(
        id: "6",
        name: "Gertrude's Children Hospital",
        type: "Children Hospital",
        address: "Muthaiga Rd, Nairobi",
        latitude: -1.2696,
        longitude: 36.8344,
        distance: 3.8,
        phone: "+254 20 2712000",
        isAvailable: true,
        rating: 4.6,
      ),
      Facility(
        id: "7",
        name: "Metropolitan Hospital",
        type: "General Hospital",
        address: "Racecourse Rd, Nairobi",
        latitude: -1.2965,
        longitude: 36.8036,
        distance: 2.1,
        phone: "+254 20 2712240",
        isAvailable: true,
        rating: 4.2,
      ),
      Facility(
        id: "8",
        name: "Avenue Healthcare",
        type: "Medical Center",
        address: "Ngong Rd, Nairobi",
        latitude: -1.3021,
        longitude: 36.7832,
        distance: 2.9,
        phone: "+254 20 2712345",
        isAvailable: true,
        rating: 4.1,
      ),
      Facility(
        id: "9",
        name: "Bliss GVS Hospital",
        type: "Private Hospital",
        address: "Argwings Kodhek Rd, Nairobi",
        latitude: -1.3008,
        longitude: 36.8058,
        distance: 2.7,
        phone: "+254 20 2712456",
        isAvailable: true,
        rating: 4.3,
      ),
      Facility(
        id: "10",
        name: "Coptic Hospital",
        type: "General Hospital",
        address: "Nkrumah Rd, Nairobi",
        latitude: -1.2881,
        longitude: 36.8220,
        distance: 1.5,
        phone: "+254 20 2221355",
        isAvailable: true,
        rating: 4.0,
      ),
    ];
  }

  // Get facilities sorted by distance
  static List<Facility> getNearbyFacilities() {
    List<Facility> facilities = getMockFacilities();
    facilities.sort((a, b) => a.distance.compareTo(b.distance));
    return facilities;
  }

  // Get facilities by type
  static List<Facility> getFacilitiesByType(String type) {
    return getMockFacilities()
        .where((facility) => facility.type == type)
        .toList();
  }

  // Get available facilities only
  static List<Facility> getAvailableFacilities() {
    return getMockFacilities()
        .where((facility) => facility.isAvailable)
        .toList();
  }

  // Search facilities by name
  static List<Facility> searchFacilities(String query) {
    return getMockFacilities()
        .where((facility) =>
            facility.name.toLowerCase().contains(query.toLowerCase()) ||
            facility.type.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
