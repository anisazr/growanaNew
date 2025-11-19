import '../models/class.dart';

class ClassService {
  static final ClassService _instance = ClassService._internal();
  factory ClassService() => _instance;
  ClassService._internal();

  final List<OnlineClass> _myClasses = [];

  List<OnlineClass> get myClasses => _myClasses;

  void addClass(OnlineClass classItem) {
    if (!_myClasses.any((c) => c.id == classItem.id)) {
      _myClasses.add(classItem);
      classItem.isAdded = true;
    }
  }

  void removeClass(String classId) {
    _myClasses.removeWhere((c) => c.id == classId);
  }

  bool isClassAdded(String classId) {
    return _myClasses.any((c) => c.id == classId);
  }
}
