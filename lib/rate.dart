class Rate {
  String base;
  String target;
  double value;
  String updated;

  Rate(this.base, this.target, this.value, this.updated);

  factory Rate.fromJson(Map<String, dynamic> json, String target) {
    return Rate(
      json['base_code'],
      target,
      (json['rates'][target] as num).toDouble(),
      json['time_last_update_utc'],
    );
  }
}
