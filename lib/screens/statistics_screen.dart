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
      return const Scaffold(
        backgroundColor: Color(0xFFEAF4F2),
        body: Center(
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
            width: 18,
            color: const Color(0xFF92B4EC),
            borderRadius: BorderRadius.circular(6),
          ),
        ],
      );
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFEAF4F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4C9F70),
        title: const Text("İstatistikler"),
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "En yüksek fatura: ${highestBill.title} - ₺${highestBill.amount.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF134530),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              "Fatura Durumu",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
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
            const Text(
              "Aylara Göre Toplam Harcama",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: BarChart(
                BarChartData(
                  barGroups: barGroups,
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 24,
                        getTitlesWidget: (value, meta) {
                          const months = [
                            '', 'Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz',
                            'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara'
                          ];
                          if (value.toInt() >= 1 && value.toInt() <= 12) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                months[value.toInt()],
                                style: const TextStyle(fontSize: 12),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
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
