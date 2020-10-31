class Staff {
  String name;
  String imageUrl;
  String description;
  String linkUrl;

  Staff(Map map) {
    name = map['name'];
    imageUrl = map['imgURL'];
    description = map['position'];
    linkUrl = map['SNS'];
  }

  Map toJson() => {
        'name': name,
        'imgURL': imageUrl,
        'position': description,
        'SNS': linkUrl,
      };
}
