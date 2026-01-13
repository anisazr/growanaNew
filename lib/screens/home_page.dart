// lib/screens/home_page.dart - FIXED
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/bottom_navbar.dart';
import '../widgets/growana_appbar.dart';
import '../widgets/todo_list_widget.dart';
import '../widgets/exhibition_slider.dart';
import 'login_page.dart';
import 'user_page.dart';
import 'maps_page.dart';
import '../services/auth_service.dart';
import '../services/todo_service.dart';
import '../services/exhibition_service.dart';
import '../services/location_service.dart'; // IMPORT INI
import '../theme/theme_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final AuthService _authService = AuthService();
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TodoService>(context, listen: false);
      Provider.of<ExhibitionService>(context, listen: false).fetchExhibitions();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section
          Container(
            color: const Color(0xFF1D7140),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: FutureBuilder(
                future: _authService.getCurrentUser(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  final user = snapshot.data;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selamat datang,',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.name ?? 'Pengguna',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Ayo mulai perjalanan urban farming mu!',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          // Exhibition Slider - Featured
          Consumer<ExhibitionService>(
            builder: (context, exhibitionService, child) {
              return ExhibitionSlider(
                title: 'Pameran Unggulan',
                showFeaturedOnly: true,
                autoPlay: true,
                height: 280,
              );
            },
          ),

          // Quick Stats & Actions
          Padding(
            padding: const EdgeInsets.all(20),
            child: Consumer2<TodoService, ExhibitionService>(
              builder: (context, todoService, exhibitionService, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ringkasan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.5,
                      children: [
                        _buildStatCard(
                          title: 'Todo Aktif',
                          value: todoService.activeTodos.length.toString(),
                          icon: Icons.list,
                          color: Colors.blue,
                        ),
                        _buildStatCard(
                          title: 'Pameran',
                          value: exhibitionService.allExhibitions.length.toString(),
                          icon: Icons.event,
                          color: Colors.green,
                        ),
                        _buildStatCard(
                          title: 'Berlangsung',
                          value: exhibitionService.ongoingExhibitions.length.toString(),
                          icon: Icons.play_circle,
                          color: Colors.orange,
                        ),
                        _buildStatCard(
                          title: 'Mendatang',
                          value: exhibitionService.upcomingExhibitions.length.toString(),
                          icon: Icons.schedule,
                          color: Colors.purple,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Quick Actions
                    Text(
                      'Aksi Cepat',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.5,
                      children: [
                        _buildQuickAction(
                          icon: Icons.calendar_today,
                          label: 'Jadwal',
                          color: Colors.blue,
                          onTap: () {
                            // TODO: Navigate to calendar view
                          },
                        ),
                        _buildQuickAction(
                          icon: Icons.map,
                          label: 'Peta Pameran',
                          color: Colors.green,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const MapsPage(),
                              ),
                            );
                          },
                        ),
                        _buildQuickAction(
                          icon: Icons.add_task,
                          label: 'Todo List',
                          color: Colors.orange,
                          onTap: () {
                            setState(() {
                              _currentIndex = 1;
                              _pageController.jumpToPage(1);
                            });
                          },
                        ),
                        _buildQuickAction(
                          icon: Icons.location_on,
                          label: 'Lokasi Saya',
                          color: Colors.purple,
                          onTap: () async {
                            try {
                              // Show current location - panggil static method
                              final position = await LocationService.getCurrentLocation();
                              final address = await LocationService.getAddressFromCoordinates(
                                position.latitude,
                                position.longitude,
                              );
                              
                              if (!mounted) return;
                              
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Lokasi Anda'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Alamat: $address'),
                                      const SizedBox(height: 8),
                                      Text('Latitude: ${position.latitude.toStringAsFixed(6)}'),
                                      Text('Longitude: ${position.longitude.toStringAsFixed(6)}'),
                                      Text('Akurasi: ${position.accuracy.toStringAsFixed(2)}m'),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Tutup'),
                                    ),
                                  ],
                                ),
                              );
                            } catch (e) {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Gagal mendapatkan lokasi: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),

          // All Exhibitions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Semua Pameran',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.map),
                  label: const Text('Lihat di Peta'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MapsPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Consumer<ExhibitionService>(
            builder: (context, exhibitionService, child) {
              return ExhibitionSlider(
                showFeaturedOnly: false,
                autoPlay: false,
                height: 240,
                viewportFraction: 0.9,
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildTodoContent() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: [
          Expanded(
            child: TodoListWidget(
              categoryFilter: null,
              showCompleted: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const Spacer(),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.isDarkMode 
          ? Colors.grey[900] 
          : Colors.grey[50],
      appBar: GrowanaAppBar(
        showUserInfo: false,
        showThemeToggle: true,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          _buildHomeContent(),
          _buildTodoContent(),
          const UserPage(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
        showAddButton: _currentIndex == 1,
      ),
    );
  }
}