class Conversao {
  static double strToDouble(str) => (str as num).toDouble();

  static double intToDouble(str) => double.parse(str);

  static bool trataBool(int? b) => b! == 1;
}
