
/// A model that contains data about an items location
class EbayLocation {

  /// Location name
  final String name;

  /// Location country ISO 3166 country code
  final String countryCode;

  /// Location postal code
  final String? postalCode;

  EbayLocation({
    required this.name, 
    required this.countryCode, 
    required this.postalCode
  });

  /// Creates a location from a json
  factory EbayLocation.fromJson(Map<String, dynamic> json){

    return EbayLocation(
      name: json['location'][0], 
      countryCode: json['country'][0],
      postalCode: json['postalCode'] == null ? null : json['postalCode'][0]
    );
  }

}