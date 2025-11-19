import 'package:flutter/material.dart';
import 'package:growana/screens/classes_page.dart';
import 'package:growana/widgets/growana_appbar.dart';
import 'user_page.dart';
import 'login_page.dart';
import '../services/user_service.dart';
import '../widgets/bottom_navbar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../widgets/my_classes.dart';
// import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final user = UserService.currentUser;
  final List<String> _carouselImages = [
    'assets/images/1.jpg',
    'assets/images/2.jpg',
    'assets/images/3.jpg',
    'assets/images/4.jpg',
    'assets/images/5.jpg',
    'assets/images/6.jpg',
    'assets/images/7.jpg',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GrowanaAppBar(showUser: true),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section dengan background hijau
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF1D7140),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Search Bar
                  // TextField(
                  //   decoration: InputDecoration(
                  //     hintText: 'Cari Produk yang Tersedia',
                  //     prefixIcon: const Icon(Icons.search),
                  //     filled: true,
                  //     fillColor: Colors.white,
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(8.0),
                  //       borderSide: BorderSide.none,
                  //     ),
                  //   ),
                  // ),

                  // My Classes Widget
                  const MyClassesWidget(),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Center(
              child: Text(
                'Pameran',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
              ),
            ),
            const SizedBox(height: 16),

            CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                autoPlayInterval: const Duration(seconds: 3),
                viewportFraction: 0.35,
              ),
              items:
                  _carouselImages.map((imageUrl) {
                    return Builder(
                      builder: (BuildContext context) {
                        return AspectRatio(
                          aspectRatio: 9 / 16,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            // margin: const EdgeInsets.symmetric(horizontal: 2.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset(imageUrl, fit: BoxFit.cover),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
            ),

            const SizedBox(height: 16),

            // Grid Produk Section
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: GridView.builder(
            //     shrinkWrap: true,
            //     physics: const NeverScrollableScrollPhysics(),
            //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //       crossAxisCount: 3,
            //       crossAxisSpacing: 12,
            //       mainAxisSpacing: 12,
            //       childAspectRatio: 0.85,
            //     ),
            //     itemCount: 6,
            //     itemBuilder: (context, index) {
            //       final products = [
            //         // Ganti gambarnya, tapi nama file harus disamakan
            //         {'name': 'Produk 1', 'image': 'assets/images/produk1.jpeg'},
            //         {'name': 'Produk 2', 'image': 'assets/images/produk2.jpeg'},
            //         {'name': 'Produk 3', 'image': 'assets/images/produk3.jpeg'},
            //         {'name': 'Produk 4', 'image': 'assets/images/produk4.jpeg'},
            //         {'name': 'Produk 5', 'image': 'assets/images/produk5.jpeg'},
            //         {'name': 'Produk 6', 'image': 'assets/images/produk6.jpeg'},
            //       ];

            //       return Container(
            //         decoration: BoxDecoration(
            //           color: Colors.grey[200],
            //           borderRadius: BorderRadius.circular(8.0),
            //         ),
            //         child: Column(
            //           children: [
            //             Expanded(
            //               child: ClipRRect(
            //                 borderRadius: const BorderRadius.vertical(
            //                   top: Radius.circular(8),
            //                 ),
            //                 child: Image.asset(
            //                   products[index]['image']!,
            //                   fit: BoxFit.cover,
            //                   width: double.infinity,
            //                 ),
            //               ),
            //             ),
            //             const SizedBox(height: 6),
            //             Padding(
            //               padding: const EdgeInsets.only(bottom: 8),
            //               child: Text(
            //                 products[index]['name']!,
            //                 style: TextStyle(
            //                   fontSize: 12,
            //                   color: Colors.grey[800],
            //                   fontWeight: FontWeight.w500,
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }
}
