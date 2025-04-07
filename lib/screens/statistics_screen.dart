import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../providers/bill_provider.dart';
import '../models/bill.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bills = Provider.of<BillProvider>(context).bills;

    if (bills.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("İstatistikler"),
          centerTitle: true,
          backgroundColor: const Color(0xFF4C9F70),
        ),
        body: const Center(
          child: Text(
            "Henüz fatura verisi yok.",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ),
      );
    }


    final highestBill = bills.reduce((a, b) => a.amount > b.amount ? a : b);
    final paidCount = bills.where((b) => b.isPaid).length;
    final unpaidCount = bills.length - paidCount;

    // Pie chart için bölümler
    final pieSections = [
      PieChartSectionData(
        value: paidCount.toDouble(),
        title: 'Ödenen',
        color: const Color(0xFFA0D995),
        radius: 50,
        titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        value: unpaidCount.toDouble(),
        title: 'Ödenmeyen',
        color: const Color(0xFFF5A9A9),
        radius: 50,
        titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ];

    // Aylık toplam harcamalar
    final Map<int, double> monthlyTotals = {};
    for (var bill in bills) {
      final month = bill.dueDate.month;
      monthlyTotals[month] = (monthlyTotals[month] ?? 0) + bill.amount;
    }

    final barGroups = monthlyTotals.entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: entry.value,
            width: 16,
            color: const Color(0xFF92B4EC),
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();

    // En çok harcama yapılan başlıklar
    final Map<String, double> titleTotals = {};
    for (var bill in bills) {
      titleTotals[bill.title] = (titleTotals[bill.title] ?? 0) + bill.amount;
    }

    final sortedEntries = titleTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final horizontalBars = List.generate(sortedEntries.length, (index) {
      final e = sortedEntries[index];
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: e.value,
            width: 14,
            color: const Color(0xFFB29DD9),
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("İstatistikler"),
        centerTitle: true,
        backgroundColor: const Color(0xFF4C9F70),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "En yüksek fatura: ${highestBill.title} - ₺${highestBill.amount.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),

            const Text("Fatura Durumu", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: PieChart(PieChartData(
                sections: pieSections,
                sectionsSpace: 2,
                centerSpaceRadius: 40,
              )),
            ),

            const SizedBox(height: 24),
            const Text("Aylık Harcama Grafiği", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  barGroups: barGroups,
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
                          const months = [
                            '', 'Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz',
                            'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara'
                          ];
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              months[value.toInt()],
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
            const Text("Harcama Başlığına Göre", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            SizedBox(
              height: sortedEntries.length * 40,
              child: BarChart(
                BarChartData(
                  barGroups: horizontalBars,
                  alignment: BarChartAlignment.spaceBetween,
                  barTouchData: BarTouchData(enabled: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= sortedEntries.length) return const SizedBox.shrink();
                          return Text(
                            sortedEntries[value.toInt()].key,
                            style: const TextStyle(fontSize: 10),
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
    );
  }
}
