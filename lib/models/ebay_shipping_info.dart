
import 'package:ebay_search/models/price.dart';

/// A model that contains information about a products shipping info
class EbayShippingInfo{

  /// If expedited shipping is available for this item
  final bool expeditedShipping;

  /// The number of days it takes to ship this item
  final int handlingTime;

  /// Set to true if one day shipping is available
  final bool oneDayShipping;

  /// The list of locations this item ships to
  final List<String> shipsToLocations;

  /// The type of shipping fee
  final String shippingType;

  /// The shipping cost
  final Price shippingCost;

  EbayShippingInfo({
    required this.expeditedShipping, 
    required this.handlingTime, 
    required this.oneDayShipping, 
    required this.shipsToLocations, 
    required this.shippingType, 
    required this.shippingCost
  });

  factory EbayShippingInfo.fromJson(Map<String, dynamic> json){

    return EbayShippingInfo(
      expeditedShipping: json['expeditedShipping'][0] == 'true', 
      handlingTime: int.parse(json['handlingTime'][0]),
      oneDayShipping: json['oneDayShippingAvailable'][0] == 'true', 
      shipsToLocations: json['shipToLocations'].cast<String>(), 
      shippingType: json['shippingType'][0], 
      shippingCost: Price.fromJson(json['shippingServiceCost'][0])
    );
  }

}