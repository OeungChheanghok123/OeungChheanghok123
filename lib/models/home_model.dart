class HomeModel{
  String online;
  int trips ;
  int points;
  String distance;
  String customerRating;
  String merchantRating;
  double deliveryFee;
  double bonus;
  double tip;

  HomeModel({
    this.online = '30h:22m',
    this.trips = 15,
    this.points = 150,
    this.distance = '30Km',
    this.customerRating = '4.5/5 rating',
    this.merchantRating = '4.0/5 rating',
    this.deliveryFee = 3,
    this.bonus = 5,
    this.tip = 0,
  });
}