import 'price.dart';

/// A container for item price and selling information
class SellingStatus {

  /// The count of bids made for this item
  final int? bidCount;

  /// The price for the item within its original currency
  final Price originPrice;

  /// The converted item price within the requested currency
  final Price price;

  /// The current selling state for the item
  final String state;

  /// The time left for this item
  // final Duration timeLeft;

  SellingStatus({
    required this.bidCount, 
    required this.originPrice, 
    required this.price, 
    required this.state, 
    // required this.timeLeft
  });

  factory SellingStatus.fromJson(Map<String, dynamic> json){

    return SellingStatus(
      bidCount: json['bidCount'] == null ? null : int.parse(json['bidCount'][0]),
      originPrice: Price.fromJson(json['currentPrice'][0]),
      price: Price.fromJson(json['convertedCurrentPrice'][0]),
      state: json['sellingState'][0],
    );
  }

}