extension CapExtension on String {
  String get _inCaps => this.length > 0 ?'${this[0].toUpperCase()}${this.substring(1)}':'';
  String toCamelCase() => this.toLowerCase().split(" ").map((str) => str._inCaps).join(" ");
}

extension NormalFormat on DateTime {
  String get normalFormat {
    return "${this.year}-${this.month}-${this.day}";
  }
}
