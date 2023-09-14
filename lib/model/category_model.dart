class CategoryModel {
  int? id;
  String? name;
  String? icon;
  bool? check;

  CategoryModel({this.id, this.name, this.icon, this.check});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    name = json['Name'];
    icon = json['Icon'];
    check = json['Check'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = id;
    data['Name'] = name;
    data['Icon'] = icon;
    data['Check'] = check;
    return data;
  }
}
