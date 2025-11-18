class Facility {
  final String id;
  final String name;
  final String type;
  final String address;
  final double latitude;
  final double longitude;
  final double distance; // in kilometers
  final String phone;
  final bool isAvailable;
  final double rating;

  Facility({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.distance,
    required this.phone,
    this.isAvailable = true,
    this.rating = 4.0,
  });

  factory Facility.fromJson(Map<String, dynamic> json) {
    return Facility(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      address: json['address'] ?? '',
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      distance: json['distance']?.toDouble() ?? 0.0,
      phone: json['phone'] ?? '',
      isAvailable: json['isAvailable'] ?? true,
      rating: json['rating']?.toDouble() ?? 4.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'distance': distance,
      'phone': phone,
      'isAvailable': isAvailable,
      'rating': rating,
    };
  }
}
