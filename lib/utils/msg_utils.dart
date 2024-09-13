
class MsgUtils {
  static showError(String message) {
    print("---------------------------------------");
    print("[🚫] $message");
    print("---------------------------------------");
  }

  static showSuccess(String message) {
    print("---------------------------------------");
    print("[✅] $message");
    print("---------------------------------------");
  }

  static showInfo(String message) {
    print("❃ $message");
  }

  static showList(String message) {
    print(" ➥ $message");
  }
}