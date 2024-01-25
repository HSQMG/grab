class SearchPlaceModel {
  final String stringName;
  final String placeId;

  SearchPlaceModel({
    required this.placeId,
    required this.stringName,
  });
  Map<String, dynamic> toJson() {
    return {"stringName": stringName, "placeId": placeId};
  }

  static SearchPlaceModel fromJson(Map<String, dynamic> map) {
    return SearchPlaceModel(
      placeId: map['place_id'],
      stringName: map["description"],
    );
  }
}
