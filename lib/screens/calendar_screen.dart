import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/bill.dart';
import '../providers/bill_provider.dart';
import 'package:provider/provider.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  // Takvimin odaklandığı gün
  DateTime _focusedDay = DateTime.now();
  // Kullanıcının seçtiği gün
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    // BillProvider'dan faturaları al
    final billProvider = Provider.of<BillProvider>(context);
    final bills = billProvider.bills;

    // Faturaları tarih bazında grupla
    Map<DateTime, List<Bill>> groupedBills = {};
    for (var bill in bills) {
      final dueDate = DateTime(bill.dueDate.year, bill.dueDate.month, bill.dueDate.day);
      if (groupedBills.containsKey(dueDate)) {
        groupedBills[dueDate]!.add(bill);
      } else {
        groupedBills[dueDate] = [bill];
      }
    }

    // Belirli bir güne ait faturaları getir
    List<Bill> _getBillsForDay(DateTime day) {
      return groupedBills[DateTime(day.year, day.month, day.day)] ?? [];
    }

    // Uygulamanın ana renk tonu
    final primaryColor = const Color(0xFF6A4C93);

    return Scaffold(
      appBar: AppBar(
        // Başlık metni "Takvim" beyaz yapıldı
        title: const Text(
          'Takvim',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        elevation: 6,
        shadowColor: primaryColor.withOpacity(0.6),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Takvim widget'ı
          TableCalendar<Bill>(
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: _getBillsForDay,
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: primaryColor.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
              outsideDaysVisible: false,
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                color: primaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              leftChevronIcon: Icon(Icons.chevron_left, color: primaryColor),
              rightChevronIcon: Icon(Icons.chevron_right, color: primaryColor),
            ),
          ),
          const SizedBox(height: 12),
          // Seçilen günün faturaları listesi
          Expanded(
            child: _getBillsForDay(_selectedDay ?? _focusedDay).isEmpty
                ? Center(
              child: Text(
                'Seçilen günde fatura bulunmamaktadır.',
                style: TextStyle(
                  fontSize: 16,
                  color: primaryColor.withOpacity(0.7),
                ),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _getBillsForDay(_selectedDay ?? _focusedDay).length,
              itemBuilder: (context, index) {
                final bill = _getBillsForDay(_selectedDay ?? _focusedDay)[index];
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    title: Text(
                      bill.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                    subtitle: Text(
                      'Son ödeme tarihi: ${bill.dueDate.day}.${bill.dueDate.month}.${bill.dueDate.year}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    trailing: Icon(
                      bill.isPaid ? Icons.check_circle : Icons.pending_outlined,
                      color: bill.isPaid ? Colors.green : Colors.orange,
                      size: 28,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
