// lib/screens/exhibition_detail_page.dart - FIXED
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/exhibition_model.dart';

class ExhibitionDetailPage extends StatelessWidget {
  final Exhibition exhibition;

  const ExhibitionDetailPage({super.key, required this.exhibition});

  Future<void> _launchMaps(double lat, double lng) async {
    final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _shareExhibition() async {
    final text = 'Check out ${exhibition.title} at ${exhibition.location} on ${exhibition.formattedDate}';
    // TODO: Implement share functionality dengan share_plus package nanti
    print(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                exhibition.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(Icons.photo, size: 64, color: Colors.grey),
                    ),
                  );
                },
              ),
              title: Text(
                exhibition.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: _shareExhibition,
                color: Colors.white,
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Chip
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: exhibition.statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: exhibition.statusColor),
                        ),
                        child: Text(
                          exhibition.statusText,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: exhibition.statusColor,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (exhibition.isFeatured)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.orange),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.star, size: 14, color: Colors.orange),
                              SizedBox(width: 4),
                              Text(
                                'Featured',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Title
                  Text(
                    exhibition.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Info Grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    children: [
                      _buildInfoItem(
                        icon: Icons.calendar_today,
                        title: 'Tanggal',
                        value: exhibition.formattedDate,
                      ),
                      _buildInfoItem(
                        icon: Icons.location_on,
                        title: 'Lokasi',
                        value: exhibition.location,
                      ),
                      _buildInfoItem(
                        icon: Icons.business,
                        title: 'Penyelenggara',
                        value: exhibition.organizer,
                      ),
                      _buildInfoItem(
                        icon: Icons.monetization_on,
                        title: 'Harga Tiket',
                        value: exhibition.formattedTicketPrice,
                        valueColor: exhibition.ticketPrice == 0
                            ? Colors.green
                            : null,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Description
                  Text(
                    'Deskripsi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    exhibition.description,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Tags
                  if (exhibition.tags.isNotEmpty) ...[
                    Text(
                      'Kategori',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: exhibition.tags.map((tag) {
                        return Chip(
                          label: Text(tag),
                          backgroundColor:
                              const Color(0xFF1D7140).withOpacity(0.1),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.map),
                          label: const Text('Lihat di Maps'),
                          onPressed: () {
                            _launchMaps(
                                exhibition.latitude, exhibition.longitude);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1D7140),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.add_alarm),
                          label: const Text('Ingatkan'),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Pengingat ditambahkan'),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: Color(0xFF1D7140)),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF1D7140), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: valueColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}