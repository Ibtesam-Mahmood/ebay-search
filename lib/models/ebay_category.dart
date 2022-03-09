
/// A model that contains information about a product category
class EbayCategory {

  final String id;
  final String name;

  EbayCategory({
    required this.id,
    required this.name
  });

  /// Parses an ebay category from json
  factory EbayCategory.fromJson(Map<String, dynamic> json){

    return EbayCategory(
      id: json['categoryId'][0], 
      name: json['categoryName'][0],
    );
  }

}