///
class Node {
  ///
  final String part;

  ///
  final Node? parent;

  ///
  const Node(
    this.part, [
    this.parent,
  ]);

  ///
  String get(
    Map<String, dynamic> path,
  ) =>
      _parent(path) + '/${path.containsKey(part) ? path[part] : part}';

  String _parent(
    Map<String, dynamic> path,
  ) =>
      this.parent != null ? this.parent!.get(path) : '';
}
