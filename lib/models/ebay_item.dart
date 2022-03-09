
import 'package:ebay_search/models/ebay_category.dart';
import 'package:ebay_search/models/ebay_location.dart';
import 'package:ebay_search/models/ebay_shipping_info.dart';

import 'selling_status.dart';

///A model that acts as a container for ebay product information
class EbayItem{

  /// The identifier for the item
  final String itemID;

  /// The name of the item
  final String title;

  /// The global marketplace ID
  final String globalID;

  /// The primary category this item belongs to
  final EbayCategory primaryCategory;

  /// The gallery picture for this item
  final String? galleryURL;

  /// The types of payment methods accepted for this item
  final List<String> paymentMethods;

  ///set to true if this seller accepts returns for this item
  final bool? acceptsReturns;

  /// The location information for this item
  final EbayLocation sellerLocation;

  /// The shipping information for this item
  final EbayShippingInfo? shippingInfo;

  /// The items store pricing info
  final SellingStatus saleInfo;

  /// The condition this item is in
  final String condition;

  /// Determines if this item is a top rated item
  final bool isTopRated;

  EbayItem({
    required this.itemID, 
    required this.title, 
    required this.globalID, 
    required this.primaryCategory, 
    required this.galleryURL, 
    required this.paymentMethods, 
    required this.acceptsReturns, 
    required this.sellerLocation, 
    required this.shippingInfo, 
    required this.saleInfo, 
    required this.condition, 
    required this.isTopRated
  });

  /// Parses an ebay item from a item json
  factory EbayItem.fromJson(Map<String, dynamic> json){

    return EbayItem(
      itemID: json['itemId'][0], 
      title: json['title'][0],
      globalID: json['globalId'][0],
      primaryCategory: EbayCategory.fromJson(json['primaryCategory'][0]), 
      galleryURL: json['galleryURL'][0], 
      paymentMethods: json['paymentMethod'] == null ? [] : json['paymentMethod'].cast<String>(),
      acceptsReturns: json['returnsAccepted'] == null ? null : json['returnsAccepted'][0] == 'true', 
      sellerLocation: EbayLocation.fromJson(json), 
      shippingInfo: EbayShippingInfo.fromJson(json['shippingInfo'][0]), 
      saleInfo: SellingStatus.fromJson(json['sellingStatus'][0]), 
      condition: json['condition'][0]['conditionDisplayName'][0], 
      isTopRated: json['topRatedListing'][0] == 'true',
    );
  }

}