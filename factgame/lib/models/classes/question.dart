class Question {
  Question({this.display, this.value});

  final String display;
  Map value;

  @override toString() => 'display: $display';
  @override toMap() => 'value: $value';

  Map toJson() => {
    'display': display,
    'value': value,
  };

}