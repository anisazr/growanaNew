import 'package:flutter/material.dart';
import '../models/awards.dart';

class AwardsPage extends StatelessWidget {
  const AwardsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Data dummy leaderboard
    final List<Awards> users = [
      Awards(
        name: 'Ahmad Rizki',
        avatar:
            'https://ui-avatars.com/api/?name=Ahmad+Rizki&background=1D7140&color=fff&size=200',
        points: 2850,
        rank: 1,
        badge: '🏆',
      ),
      Awards(
        name: 'Siti Nurhaliza',
        avatar:
            'https://ui-avatars.com/api/?name=Siti+Nurhaliza&background=C0C0C0&color=fff&size=200',
        points: 2640,
        rank: 2,
        badge: '🥈',
      ),
      Awards(
        name: 'Budi Santoso',
        avatar:
            'https://ui-avatars.com/api/?name=Budi+Santoso&background=CD7F32&color=fff&size=200',
        points: 2420,
        rank: 3,
        badge: '🥉',
      ),
      Awards(
        name: 'Dewi Lestari',
        avatar:
            'https://ui-avatars.com/api/?name=Dewi+Lestari&background=4A5568&color=fff&size=200',
        points: 2180,
        rank: 4,
        badge: '⭐',
      ),
      Awards(
        name: 'Eko Prasetyo',
        avatar:
            'https://ui-avatars.com/api/?name=Eko+Prasetyo&background=4A5568&color=fff&size=200',
        points: 1950,
        rank: 5,
        badge: '⭐',
      ),
      Awards(
        name: 'Fitri Handayani',
        avatar:
            'https://ui-avatars.com/api/?name=Fitri+Handayani&background=4A5568&color=fff&size=200',
        points: 1820,
        rank: 6,
        badge: '⭐',
      ),
      Awards(
        name: 'Gita Savitri',
        avatar:
            'https://ui-avatars.com/api/?name=Gita+Savitri&background=4A5568&color=fff&size=200',
        points: 1650,
        rank: 7,
        badge: '⭐',
      ),
      Awards(
        name: 'Hendra Wijaya',
        avatar:
            'https://ui-avatars.com/api/?name=Hendra+Wijaya&background=4A5568&color=fff&size=200',
        points: 1490,
        rank: 8,
        badge: '⭐',
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D7140),
        elevation: 0,
        title: const Text(
          'Leaderboard',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Top 3 Podium Section
          Container(
            color: const Color(0xFF1D7140),
            padding: const EdgeInsets.only(bottom: 64, top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Rank 2 (Silver)
                _buildPodiumCard(users[1], 120),
                const SizedBox(width: 12),
                // Rank 1 (Gold)
                _buildPodiumCard(users[0], 140),
                const SizedBox(width: 12),
                // Rank 3 (Bronze)
                _buildPodiumCard(users[2], 100),
              ],
            ),
          ),

          // Rest of Leaderboard
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: users.length - 3,
              itemBuilder: (context, index) {
                final user = users[index + 3];
                return _buildLeaderboardCard(user);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumCard(Awards user, double height) {
    Color cardColor;
    if (user.rank == 1) {
      cardColor = const Color(0xFFFFD700); // Gold
    } else if (user.rank == 2) {
      cardColor = const Color(0xFFC0C0C0); // Silver
    } else {
      cardColor = const Color(0xFFCD7F32); // Bronze
    }

    return Container(
      width: 120, // lebih lebar
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // biar tinggi otomatis sesuai isi
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Badge
          Text(user.badge, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 8),
          // Avatar
          Container(
            width: 50, // lebih besar
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: cardColor, width: 3),
            ),
            child: ClipOval(
              child: Image.network(
                user.avatar,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.person, color: Colors.white),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Name
          Text(
            user.name.split(' ')[0],
            style: const TextStyle(
              fontSize: 14, // sedikit lebih besar
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D7140),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          // Points
          Text(
            '${user.points}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardCard(Awards user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Rank Number
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '#${user.rank}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D7140),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Avatar
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[300]!, width: 2),
            ),
            child: ClipOval(
              child: Image.network(
                user.avatar,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.person, color: Colors.white),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Name and Badge
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1D7140),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(user.badge, style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 4),
                    Text(
                      'Contributor',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Points
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${user.points}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D7140),
                ),
              ),
              Text(
                'points',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================
// CARA PENGGUNAAN
// ============================================
/*
// Di CustomAppBar atau widget lain:
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const AwardsPage()),
);

// Atau dengan named route:
Navigator.pushNamed(context, '/leaderboard');
*/