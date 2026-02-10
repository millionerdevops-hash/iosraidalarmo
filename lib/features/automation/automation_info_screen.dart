import 'package:flutter/material.dart';
import '../../core/theme/rust_colors.dart';

class AutomationInfoScreen extends StatelessWidget {
  const AutomationInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RustColors.background,
      appBar: AppBar(
        title: const Text("OTOMASYON REHBERİ"),
        backgroundColor: RustColors.surface,
        foregroundColor: RustColors.textPrimary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader("OTOMASYON MANTIĞI", Icons.psychology),
            _buildInfoCard(
              "Otomashon sistemi, cihazlar arasında 'dijital kablolar' kurmanızı sağlar. Bir tetikleyici (IF) gerçekleştiğinde, belirlediğiniz aksiyonlar (THEN) sırasıyla çalışır.",
            ),
            const SizedBox(height: 24),
            
            _buildHeader("1. DELAY (GECİKME) & AUTO-OFF", Icons.timer),
            _buildConceptCard(
              title: "Tetiklenme Gecikmesi",
              desc: "Gecikme süresi sadece kural ilk tetiklendiğinde (ON) devreye girer. Yanlış alarmları ve anlık sinyal gürültülerini engellemek için kullanılır.",
              color: RustColors.accent,
            ),
            _buildConceptCard(
              title: "Auto-Off (Otomatik Kapanma)",
              desc: "Tetikleyici sinyal kesildiğinde (OFF), sistem yapılan işlemi anında geri alır. Kapanma anında gecikme süresi uygulanmaz.",
              color: RustColors.primary,
            ),
            _buildScenarioBox(
              "ÖRNEK SENARYO",
              "Ayar: 5s delay + Auto-Off Açık\n"
              "• Tetiklendi: 5 sn bekler, sonra açılır.\n"
              "• Sinyal Kesildi: Beklemeden anında kapanır.\n"
              "Neden?: Savunmanın boşuna açık kalmaması için kapanma hızlıdır.",
            ),
            const SizedBox(height: 24),

            _buildHeader("2. TRIGGER THRESHOLD (EŞİK)", Icons.reorder),
            _buildConceptCard(
              title: "Eşik = 1 (Normal)",
              desc: "Cihazdan gelen ilk sinyalde otomasyon anında çalışır. Kapı dedektörü veya ışık sensörü gibi durumlar için idealdir.",
              color: RustColors.success,
            ),
            _buildConceptCard(
              title: "Eşik = 2+ (Israrcı Mod)",
              desc: "Cihaz o sayıda sinyal gönderene kadar bekler. Sismik sensör veya RAID tespiti gibi durumlarda 'gerçekten' bir olay olduğundan emin olmak için kullanılır.",
              color: RustColors.info,
            ),
            const SizedBox(height: 24),

            _buildHeader("3. EŞİK + AUTO-OFF KOMBİNASYONU", Icons.layers),
            _buildScenarioBox(
              "Eşik = 1 + Auto-Off",
              "Alarm çalınca açar, durunca kapatır. Cihaz sensörle tam senkronize çalışır.",
            ),
            _buildScenarioBox(
              "Eşik > 1 + Auto-Off (Pro Mod)",
              "Eşik değerine (Örn: 3) ulaşıldığında, sistem olayı 'kesin tehlike' olarak kodlar ve KİLİT MODUNA geçer. Sensör sussa bile cihazlar kapanmaz (Güvenlik için kalıcı açık kalır).",
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: RustColors.accent, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              color: RustColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              letterSpacing: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: RustColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: RustColors.divider),
      ),
      child: Text(
        text,
        style: const TextStyle(color: RustColors.textSecondary, height: 1.5),
      ),
    );
  }

  Widget _buildConceptCard({required String title, required String desc, required Color color}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: RustColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: color, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 6),
          Text(
            desc,
            style: const TextStyle(color: RustColors.textPrimary, fontSize: 12, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildScenarioBox(String title, String content) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: RustColors.divider.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: RustColors.textMuted, fontWeight: FontWeight.bold, fontSize: 10),
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: const TextStyle(color: RustColors.textSecondary, fontSize: 11, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}
