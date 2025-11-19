class OnlineClass {
  final String id;
  final String title;
  final String imageUrl;
  final bool isFree;
  bool isAdded;

  OnlineClass({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.isFree,
    this.isAdded = false,
  });
}
