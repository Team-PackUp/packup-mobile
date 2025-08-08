import 'package:flutter/material.dart';

class CustomBirthInput extends StatefulWidget {
  final void Function(DateTime?) onDateChanged;
  final DateTime? initialDate;

  const CustomBirthInput({
    super.key,
    required this.onDateChanged,
    this.initialDate,
  });

  @override
  State<CustomBirthInput> createState() => _CustomBirthInputState();
}

class _CustomBirthInputState extends State<CustomBirthInput> {
  final yearController = TextEditingController();
  final monthController = TextEditingController();
  final dayController = TextEditingController();

  final yearFocus = FocusNode();
  final monthFocus = FocusNode();
  final dayFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    if (widget.initialDate != null) {
      yearController.text = widget.initialDate!.year.toString();
      monthController.text = widget.initialDate!.month.toString().padLeft(2, '0');
      dayController.text = widget.initialDate!.day.toString().padLeft(2, '0');

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _onChanged();
      });
    }
  }

  @override
  void dispose() {
    yearController.dispose();
    monthController.dispose();
    dayController.dispose();
    yearFocus.dispose();
    monthFocus.dispose();
    dayFocus.dispose();
    super.dispose();
  }

  void _onChanged() {
    final y = int.tryParse(yearController.text);
    final m = int.tryParse(monthController.text);
    final d = int.tryParse(dayController.text);

    if (y != null && m != null && d != null) {
      try {
        final date = DateTime(y, m, d);
        widget.onDateChanged(date);
      } catch (e) {
        widget.onDateChanged(null);
      }
    } else {
      widget.onDateChanged(null);
    }
  }

  Widget _buildInput({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hint,
    required int maxLength,
    FocusNode? nextFocus,
  }) {
    return SizedBox(
      width: maxLength == 4 ? 80 : 50,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: maxLength,
        decoration: InputDecoration(
          hintText: hint,
          counterText: '',
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          if (value.length == maxLength && nextFocus != null) {
            nextFocus.requestFocus();
          }
          _onChanged();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildInput(
          controller: yearController,
          focusNode: yearFocus,
          hint: 'YYYY',
          maxLength: 4,
          nextFocus: monthFocus,
        ),
        const SizedBox(width: 8),
        const Text("년"),
        const SizedBox(width: 8),
        _buildInput(
          controller: monthController,
          focusNode: monthFocus,
          hint: 'MM',
          maxLength: 2,
          nextFocus: dayFocus,
        ),
        const SizedBox(width: 8),
        const Text("월"),
        const SizedBox(width: 8),
        _buildInput(
          controller: dayController,
          focusNode: dayFocus,
          hint: 'DD',
          maxLength: 2,
        ),
        const SizedBox(width: 8),
        const Text("일"),
      ],
    );
  }
}
