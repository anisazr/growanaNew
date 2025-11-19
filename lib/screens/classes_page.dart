import 'package:flutter/material.dart';
import '../models/class.dart';
import '../services/class_service.dart';
import '../widgets/growana_appbar.dart';
import '../widgets/bottom_navbar.dart';
import '../services/user_service.dart';
import '../screens/login_page.dart';
import '../screens/user_page.dart';

class ClassesPage extends StatefulWidget {
  const ClassesPage({Key? key}) : super(key: key);

  @override
  State<ClassesPage> createState() => _ClassesPageState();
}

class _ClassesPageState extends State<ClassesPage> {
  int _currentIndex = 0;
  final ClassService _classService = ClassService();

  // Data dummy kelas online
  final List<OnlineClass> availableClasses = [
    OnlineClass(
      id: '1',
      title: 'Flutter untuk Pemula',
      imageUrl: 'https://picsum.photos/seed/flutter1/400/250',
      isFree: true,
    ),
    OnlineClass(
      id: '2',
      title: 'Advanced Dart Programming',
      imageUrl: 'https://picsum.photos/seed/dart2/400/250',
      isFree: false,
    ),
    OnlineClass(
      id: '3',
      title: 'UI/UX Design Fundamental',
      imageUrl: 'https://picsum.photos/seed/uiux3/400/250',
      isFree: true,
    ),
    OnlineClass(
      id: '4',
      title: 'Firebase Integration',
      imageUrl: 'https://picsum.photos/seed/firebase4/400/250',
      isFree: false,
    ),
    OnlineClass(
      id: '5',
      title: 'State Management dengan Provider',
      imageUrl: 'https://picsum.photos/seed/provider5/400/250',
      isFree: true,
    ),
    OnlineClass(
      id: '6',
      title: 'REST API Integration',
      imageUrl: 'https://picsum.photos/seed/api6/400/250',
      isFree: false,
    ),
    OnlineClass(
      id: '7',
      title: 'Flutter Animation Mastery',
      imageUrl: 'https://picsum.photos/seed/animation7/400/250',
      isFree: false,
    ),
    OnlineClass(
      id: '8',
      title: 'Clean Architecture in Flutter',
      imageUrl: 'https://picsum.photos/seed/clean8/400/250',
      isFree: true,
    ),
  ];

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ClassesPage()),
      );
    }
    if (index == 2) {
      if (UserService.currentUser != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserPage()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    }
  }

  void _toggleClass(OnlineClass classItem) {
    setState(() {
      if (_classService.isClassAdded(classItem.id)) {
        _classService.removeClass(classItem.id);
        classItem.isAdded = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${classItem.title} dihapus dari kelas saya'),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        _classService.addClass(classItem);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${classItem.title} ditambahkan ke kelas saya'),
            duration: const Duration(seconds: 2),
            backgroundColor: const Color(0xFF1D7140),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GrowanaAppBar(showBack: true),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: availableClasses.length,
        itemBuilder: (context, index) {
          final classItem = availableClasses[index];
          final isAdded = _classService.isClassAdded(classItem.id);

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gambar
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: Stack(
                    children: [
                      Image.network(
                        classItem.imageUrl,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 180,
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.image,
                              size: 50,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                      // Badge Status
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color:
                                classItem.isFree ? Colors.green : Colors.orange,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            classItem.isFree ? 'FREE' : 'SUBSCRIBE',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Konten
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        classItem.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1D7140),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _toggleClass(classItem),
                          icon: Icon(
                            isAdded ? Icons.check : Icons.add,
                            color: Colors.white,
                          ),
                          label: Text(
                            isAdded
                                ? 'Sudah Ditambahkan'
                                : 'Tambahkan ke Kelas Saya',
                            style: const TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isAdded ? Colors.grey : const Color(0xFF1D7140),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }
}
