class FourDigits {
  int digit0;
  int digit1;
  int digit2;
  int digit3;

  FourDigits({
    required this.digit0,
    required this.digit1,
    required this.digit2,
    required this.digit3,
  });

  // factory FourDigits.fromData(Map<String, dynamic> data) =>
  //     FourDigits(
  //         digit0: data[0],
  //         digit1: data[1],
  //         digit2: data[2],
  //         digit3: data[3]
  //     );

  FourDigits.fromData(Map<String, dynamic> data)
      : digit0 = data['digit0'],
        digit1 = data['digit1'],
        digit2 = data['digit2'],
        digit3 = data['digit3'];

  Map<String, dynamic> toJson() =>
      {
        'digit0': digit0,
        'digit1': digit1,
        'digit2': digit2,
        'digit3': digit3
      };

  bool isDummy() {
    return (
        digit0 == 0 &&
            digit1 == 0 &&
            digit2 == 0 &&
            digit3 == 0
    );
  }

  List<int> toList() => [digit0, digit1, digit2, digit3];

  FourDigits.fromList(List<int> digits)
      : digit0 = digits[0],
        digit1 = digits[1],
        digit2 = digits[2],
        digit3 = digits[3];

  @override
  String toString() => digit0.toString()+digit1.toString()+digit2.toString()+digit3.toString();

  @override
  bool operator ==(Object other) {
    return hashCode == other.hashCode;
  }

  @override
  int get hashCode {
    return digit0.hashCode ^ digit1.hashCode ^ digit2.hashCode ^ digit3.hashCode;
  }
}

