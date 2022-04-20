class ReportModel{
  String online;
  int trips ;
  int points;
  String distance;
  String customerRating;
  String merchantRating;
  double deliveryFee;
  double bonus;
  double tip;

  ReportModel({
    this.online = '60h:22m',
    this.trips = 50,
    this.points = 400,
    this.distance = '150Km',
    this.customerRating = '4.5/5 rating',
    this.merchantRating = '5/5 rating',
    this.deliveryFee = 120,
    this.bonus = 21.25,
    this.tip = 11,
  });
}