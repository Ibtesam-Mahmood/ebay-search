
import 'package:ebay_search/models/ebay_item.dart';
import 'package:flutter/material.dart';

/// Uses an [EbayItem] and displays the items information within a list tile
class EbayItemListTile extends StatelessWidget {

  final EbayItem item;

  const EbayItemListTile({ Key? key, required this.item }) : super(key: key);

  /// Returns a shipping price string
  String get shippingPrice {
    final shippingType = item.shippingInfo?.shippingType;
    if(shippingType == 'Free'){
      return 'Free Shipping';
    }
    else if(shippingType == 'FreePickup'){
      return 'Pick up only';
    }
    else if(shippingType == 'FreightFlat' || shippingType == 'Flat' || shippingType == 'FlatDomesticCalculatedInternational'){
      return '+ \$${item.shippingInfo?.shippingCost?.value} shipping';
    }
    else if(shippingType == 'Calculated' || shippingType == 'CalculatedDomesticFlatInternational' || shippingType == 'Freight'){
      if(item.shippingInfo?.shippingCost?.value != null){
        return '+ \$${item.shippingInfo?.shippingCost?.value} estimated shipping';
      }
      return '+ shipping';
    }

    return '';
  }

  Widget _buildImage(BuildContext context){
    return Container(
      width: 75,
      height: 75,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        image: DecorationImage(
          image: NetworkImage(item.galleryURL ?? ''),
          fit: BoxFit.cover
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!, width: 1),
        borderRadius: BorderRadius.circular(16)
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          // The preview image for the item
          _buildImage(context),

          Container(width: 8,),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                // Top rated item flag
                if(item.isTopRated)
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.blue[300]!,
                        size: 16,
                      ),
                      Text(' Top Rated Item', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 11, color: Colors.blue[300]!),)
                    ],
                  ),
                
                // The name of the item
                Text(
                  item.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),

                Container(height: 8,),

                // Item price 
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(text: '\$ ', style: TextStyle(fontSize: 14),),
                      TextSpan(text: '${item.saleInfo.price.value}'),
                      TextSpan(text: ' ${item.saleInfo.price.currency} ', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),),
                      TextSpan(text: shippingPrice, style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 14),),
                    ],
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      fontSize: 18
                    )
                  ),
                ),
                


              ],
            ),
          )
        ],
      )
    );
  }
}