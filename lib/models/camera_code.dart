class CameraCode {
  final String id;
  final String label;
  final String code;
  final String? img;
  final bool isRandom;
  final String category;

  CameraCode({
    required this.id,
    required this.label,
    required this.code,
    this.img,
    this.isRandom = false,
    required this.category,
  });
}
