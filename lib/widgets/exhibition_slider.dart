// lib/widgets/exhibition_slider.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../services/exhibition_service.dart';
import '../models/exhibition_model.dart';
import '../screens/exhibition_detail_page.dart';

class ExhibitionSlider extends StatelessWidget {
  final String? title;
  final bool showFeaturedOnly;
  final bool autoPlay;
  final double height;
  final double viewportFraction;

  const ExhibitionSlider({
    super.key,
    this.title,
    this.showFeaturedOnly = false,
    this.autoPlay = true,
    this.height = 300,
    this.viewportFraction = 0.8,
  });

  @override
  Widget build(BuildContext context) {
    final exhibitionService = Provider.of<ExhibitionService>(context);
    
    return ValueListenableBuilder<List<Exhibition>>(
      valueListenable: exhibitionService.exhibitions,
      builder: (context, exhibitions, child) {
        List<Exhibition> displayExhibitions = showFeaturedOnly
            ? exhibitionService.featuredExhibitions
            : exhibitionService.allExhibitions;

        if (displayExhibitions.isEmpty) {
          return _buildEmptyState(context, exhibitionService);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title!,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO: Navigate to all exhibitions page
                      },
                      child: const Text('Lihat Semua'),
                    ),
                  ],
                ),
              ),
            ],
            
            CarouselSlider.builder(
              itemCount: displayExhibitions.length,
              options: CarouselOptions(
                height: height,
                autoPlay: autoPlay,
                enlargeCenterPage: true,
                viewportFraction: viewportFraction,
                autoPlayInterval: const Duration(seconds: 4),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
              ),
              itemBuilder: (context, index, realIndex) {
                final exhibition = displayExhibitions[index];
                return _buildExhibitionCard(context, exhibition);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildExhibitionCard(BuildContext context, Exhibition exhibition) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ExhibitionDetailPage(exhibition: exhibition),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: Image.network(
                  exhibition.imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(
                          Icons.photo,
                          color: Colors.grey,
                          size: 64,
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // Gradient Overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                      stops: const [0.5, 1.0],
                    ),
                  ),
                ),
              ),
              
              // Featured Badge
              if (exhibition.isFeatured)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, size: 12, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          'Featured',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              
              // Content
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      exhibition.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Location & Date
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 12, color: Colors.white70),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            exhibition.location,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 12, color: Colors.white70),
                        const SizedBox(width: 4),
                        Text(
                          exhibition.formattedDate,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Status & Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Status
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: exhibition.statusColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: exhibition.statusColor),
                          ),
                          child: Text(
                            exhibition.statusText,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: exhibition.statusColor,
                            ),
                          ),
                        ),
                        
                        // Price
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            exhibition.formattedTicketPrice,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1D7140),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ExhibitionService service) {
    return ValueListenableBuilder<bool>(
      valueListenable: service.isLoading,
      builder: (context, isLoading, child) {
        if (isLoading) {
          return SizedBox(
            height: height,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return SizedBox(
          height: height,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.event,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Belum ada pameran',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Muat Ulang'),
                  onPressed: () {
                    service.refresh();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D7140),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}