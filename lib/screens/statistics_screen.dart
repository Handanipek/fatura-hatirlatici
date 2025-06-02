import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../providers/bill_provider.dart';
import '../models/bill.dart';
import 'filtered_bills_screen.dart';
import 'month_bills_screen.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> with SingleTickerProviderStateMixin {
  // Animasyon kontrolcüsü ve opacity animasyonu için
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    // Animasyon kontrolcüsünü başlat
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    // Ease-in animasyon eğrisi
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    // Animasyonu başlat
    _controller.forward();
  }

  @override
  void dispose() {
    // Kaynakları temizle
    _controller.dispose();
    super.dispose();
  }

  // Fatura başlığına göre ilgili ikonu döndüren fonksiyon
  Widget buildIcon(String title) {
    final lower = title.toLowerCase();
    if (lower.contains('su')) {
      return const Icon(Icons.water_drop, color: Colors.blue);
    } else if (lower.contains('elektrik')) {
      return const Icon(Icons.flash_on, color: Colors.amber);
    } else if (lower.contains('internet')) {
      return const Icon(Icons.wifi, color: Colors.purple);
    } else {
      return const Icon(Icons.receipt_long, color: Colors.grey);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Provider'dan faturaları al
    final bills = Provider.of<BillProvider>(context).bills;

    // Eğer fatura yoksa kullanıcıya bilgilendirme göster
    if (bills.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          // AppBar başlığı ve yazı rengi beyaz yapıldı
          title: const Text(
            "İstatistikler",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFF6A4C93),
        ),
        body: const Center(
          child: Text(
            "Henüz fatura verisi yok.",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ),
      );
    }

    // En yüksek tutarlı faturayı bul
    final highestBill = bills.reduce((a, b) => a.amount > b.amount ? a : b);
    // Ödenen ve ödenmeyen faturaların sayısı
    final paidCount = bills.where((b) => b.isPaid).length;
    final unpaidCount = bills.length - paidCount;

    // Pasta grafik dilimleri
    final pieSections = [
      PieChartSectionData(
        value: paidCount.toDouble(),
        title: 'Ödenen',
        color: Colors.greenAccent.shade400,
        radius: 60,
        titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
      ),
      PieChartSectionData(
        value: unpaidCount.toDouble(),
        title: 'Ödenmeyen',
        color: Colors.redAccent,
        radius: 60,
        titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
      ),
    ];

    // Aylara göre toplam harcamaları hesapla
    final Map<int, double> monthlyTotals = {};
    for (var bill in bills) {
      final month = bill.dueDate.month;
      monthlyTotals[month] = (monthlyTotals[month] ?? 0) + bill.amount;
    }

    // Bar grafik için verileri hazırla
    final barGroups = monthlyTotals.entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: entry.value,
            width: 18,
            color: Colors.blueAccent.shade200,
            borderRadius: BorderRadius.circular(6),
          ),
        ],
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        // AppBar başlığı beyaz renkli
        title: const Text(
          "İstatistikler",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF6A4C93),
      ),
      // Ana içeriği animasyonlu opacity ile göster
      body: FadeTransition(
        opacity: _fadeIn,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En yüksek fatura bilgisi kartı
              Card(
                color: Colors.teal.shade50,
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Faturaya uygun ikon göster
                      buildIcon(highestBill.title),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "En yüksek fatura: ${highestBill.title} - ₺${highestBill.amount.toStringAsFixed(2)}",
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Fatura Durumu başlığı
              const Text("Fatura Durumu", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              // Pasta grafik widget'ı
              SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sections: pieSections,
                    sectionsSpace: 4,
                    centerSpaceRadius: 40,
                    pieTouchData: PieTouchData(
                      touchCallback: (event, response) async {
                        // Pasta grafik dilimlerine tıklandığında ilgili faturalar gösterilsin
                        if (event.isInterestedForInteractions && response?.touchedSection != null) {
                          final section = response?.touchedSection?.touchedSection;
                          final title = section?.title?.toLowerCase() ?? '';
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FilteredBillsScreen(
                                showPaid: title.contains('ödenen'),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Aylık Harcama Grafiği başlığı
              const Text("Aylık Harcama Grafiği", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              // Bar grafik widget'ı
              SizedBox(
                height: 220,
                child: BarChart(
                  BarChartData(
                    barGroups: barGroups,
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchCallback: (event, response) async {
                        // Bar grafik barlarına tıklanınca o aya ait faturalar gösterilsin
                        if (event.isInterestedForInteractions && response?.spot != null) {
                          final month = response!.spot!.touchedBarGroup.x;
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MonthBillsScreen(month: month),
                            ),
                          );
                        }
                      },
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            // Aylık kısaltmalar
                            const months = [
                              '', 'Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz',
                              'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara'
                            ];
                            return Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                months[value.toInt()],
                                style: const TextStyle(fontSize: 11),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
