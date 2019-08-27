class engchapters{

  String chapter_no;
  String chapter_name;
  String description;

  engchapters({
    this.chapter_no,
    this.chapter_name,
    this.description,
  });

  factory engchapters.fromJson(Map<String, dynamic> data) => engchapters(
    chapter_no: data["chapter_no"],
    chapter_name: data["chapter_name"],
    description: data["description"]
  );

  Map<String, dynamic> toJson() => {
    "chapter_no": chapter_no,
    "chapter_name": chapter_name,
    "description": description,
  };

}