class UnusedAssetModel {
  String fileName;
  String filePath;
  UnusedAssetModel({
    required this.fileName,
    required this.filePath,
  });

  String toString() {
    return "UnusedAssetModel(fileName: $fileName, filePath: $filePath)";
  }
}
