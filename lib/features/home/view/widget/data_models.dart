// =============================================
// Data Models
// =============================================
// تعريف نماذج البيانات (مثال: مستخدم ومشروع)
//استبدلها لاحقا

class Project {
  final String id;
  final String name;
  final DateTime createdAt;

  Project({required this.id, required this.name, required this.createdAt});
}
