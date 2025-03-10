class AssetUtils {
  static getAssetImage(String iconName, {bool isPNG = true}) {
    return isPNG ? 'assets/images/$iconName.png' : 'assets/images/$iconName';
  }

  static getAssetImagePNG(String iconName) {
    return 'assets/images/$iconName.png';
  }
}
