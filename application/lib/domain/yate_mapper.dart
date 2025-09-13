abstract class YateMapper {
  Map<String, dynamic> toJson();

  static List<Map<String, dynamic>> itemsToJson<T extends YateMapper>(List<T> items) {
    List<Map<String, dynamic>> result = [];
    for (var item in items) {
      result.add(item.toJson());
    }
    return result;
  }
}
