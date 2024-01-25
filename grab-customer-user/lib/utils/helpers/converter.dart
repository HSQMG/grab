class Converter {
  static double distanceStringToDistance(String distanceStr) {

    RegExp regex = RegExp(r'(\d+(\.\d+)?)');

    // Extract the numeric part
    String result = regex.firstMatch(distanceStr)?.group(1) ?? "";
    if (distanceStr.contains("k")) return double.parse(result);
    return (double.parse(result) / 1000);

  }
}
