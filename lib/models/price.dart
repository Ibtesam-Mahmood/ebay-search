
/// A model that contains the price value and currency
class Price {

  /// The currency type
  final String currency;

  /// The amount
  final double value;

  Price({
    required this.currency, 
    required this.value
  });

  factory Price.fromJson(Map<String, dynamic> json){

    return Price(
      currency: json['@currencyId'],
      value: double.parse(json['__value__']),
    );
  }

}