import 'package:flutter/material.dart';

class GrowanaInfoPage extends StatelessWidget {
  const GrowanaInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFEFF3F8),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        children: [
          Text(
            'Profil',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0A703A),
              height: 1.2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              "Growana adalah sebuah ekosistem urban farming yang berdedikasi membantu individu mencapai stabilitas emosional dan spiritual melalui kegiatan menanam yang ringan dan bermakna. Didirikan dengan visi mengatasi tekanan era digital dan ketiadaan aktivitas bermakna bagi lansia purnatugas, Growana menawarkan solusi menanam yang mudah diimplementasikan di lahan terbatas (rumah, balkon, teras).",
            ),
          ),

          const SizedBox(height: 40),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _InfoSection(
                  title: 'Filosofi Kegiatan',
                  content:
                      'Kegiatan ini didasari keyakinan bahwa interaksi langsung dengan alam (menanam) dapat memutus tekanan digital, memberikan rasa ketenangan, koneksi, dan peran yang berarti (sense of purpose) bagi lansia.',
                ),
              ),

              Container(
                width: 1,
                height: 180,
                color: Colors.grey.shade400,
                margin: const EdgeInsets.symmetric(horizontal: 20),
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tujuan Program',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0A703A),
                      ),
                    ),
                    const SizedBox(height: 10),

                    const _Bullet(
                      'Primer (Validasi Hipotesis): Mengumpulkan data kuantitatif dan kualitatif mengenai dampak langsung kegiatan menanam terhadap mood score, tingkat interaksi sosial, dan perasaan "kehilangan peran" pada lansia.',
                    ),
                    const _Bullet(
                      'Sekunder: Memberikan stimulasi motorik halus dan kognitif, serta menciptakan lingkungan sosial yang suportif di Senior Day Care RSUI.',
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final String content;

  const _InfoSection({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0A703A),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          content,
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFF333333),
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;

  const _Bullet(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('•  ', style: TextStyle(fontSize: 16)),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              height: 1.4,
              color: Color(0xFF333333),
            ),
          ),
        ),
      ],
    );
  }
}
