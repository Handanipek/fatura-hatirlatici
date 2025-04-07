import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/bill_provider.dart';
import '../providers/user_provider.dart';

class AddBillScreen extends StatefulWidget {
  const AddBillScreen({super.key});

  @override
  State<AddBillScreen> createState() => _AddBillScreenState();
}

class _AddBillScreenState extends State<AddBillScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;

  void _submit() {
    if (!_formKey.currentState!.validate() || _selectedDate == null) return;

    final user = Provider.of<UserProvider>(context, listen: false).currentUser;
    if (user == null) return;

    final title = _titleController.text.trim();
    final amount = double.tryParse(_amountController.text.trim()) ?? 0;

    Provider.of<BillProvider>(context, listen: false).addBill(
      title,
      amount,
      _selectedDate!,
      user.id, // ✅ kullanıcıya özel ekleme
    );

    Navigator.of(context).pop();
  }

  void _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Fatura Ekle'),
        backgroundColor: const Color(0xFF4C9F70),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Fatura Başlığı'),
                validator: (value) =>
                value!.isEmpty ? 'Başlık giriniz' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountController,
                decoration:
                const InputDecoration(labelText: 'Tutar (₺)'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value!.isEmpty ? 'Tutar giriniz' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'Tarih seçilmedi'
                          : 'Son tarih: ${_selectedDate!.toLocal()}'.split(' ')[0],
                    ),
                  ),
                  TextButton(
                    onPressed: _pickDate,
                    child: const Text('Tarih Seç'),
                  )
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4C9F70),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Fatura Ekle'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
