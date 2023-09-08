class Filter {

  String name = "red";
  bool isSelected = false;
  Filter({required this.name, required this.isSelected}) : super();

  Map<String, dynamic> toJson() => {
    'name': name,
    'isSelected': isSelected,
  };

  factory Filter.fromJson(Map<String, dynamic> json) {
    return Filter(
      name: json['name'].toString(),
      isSelected: json['isSelected'] as bool,
    );
  }
}