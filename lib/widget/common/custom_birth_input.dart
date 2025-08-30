import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomBirthInput extends StatefulWidget {
  final void Function(DateTime?) onDateChanged;
  final DateTime? initialDate;

  final int minYear;
  final int maxYear;

  final bool autoPadOnBlur;

  final bool clampOutOfRangeOnBlur;

  CustomBirthInput({
    super.key,
    required this.onDateChanged,
    this.initialDate,
    this.minYear = 1900,
    int? maxYear,
    this.autoPadOnBlur = true,
    this.clampOutOfRangeOnBlur = true,
  }) : maxYear = maxYear ?? DateTime.now().year;

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
      final d = widget.initialDate!;
      yearController.text = d.year.toString();
      monthController.text = d.month.toString().padLeft(2, '0');
      dayController.text = d.day.toString().padLeft(2, '0');
      WidgetsBinding.instance.addPostFrameCallback((_) => _emitIfValid());
    }

    yearFocus.addListener(() => _onBlur(yearController, Part.year));
    monthFocus.addListener(() => _onBlur(monthController, Part.month));
    dayFocus.addListener(() => _onBlur(dayController, Part.day));
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

  void _emitIfValid() {
    final yStr = yearController.text.trim();
    final mStr = monthController.text.trim();
    final dStr = dayController.text.trim();

    if (yStr.isEmpty) {
      widget.onDateChanged(null);
      return;
    }
    if (mStr.isEmpty) {
      widget.onDateChanged(null);
      return;
    }
    if (dStr.isEmpty) {
      widget.onDateChanged(null);
      return;
    }

    final y = int.tryParse(yStr);
    final m = int.tryParse(mStr);
    final d = int.tryParse(dStr);

    DateTime? value;

    if (y != null && m != null && d != null) {
      final isYearOk = y >= widget.minYear && y <= widget.maxYear;
      final isMonthOk = m >= 1 && m <= 12;

      if (isYearOk && isMonthOk) {
        final maxDay = DateUtils.getDaysInMonth(y, m);
        final isDayOk = d >= 1 && d <= maxDay;
        if (isDayOk) {
          value = DateTime(y, m, d);
        }
      }
    }

    widget.onDateChanged(value);
  }

  void _onBlur(TextEditingController c, Part part) {
    if (c.selection.baseOffset >= 0) {
      if (part == Part.year && yearFocus.hasFocus) return;
      if (part == Part.month && monthFocus.hasFocus) return;
      if (part == Part.day && dayFocus.hasFocus) return;
    }

    var raw = c.text;
    if (raw.isEmpty) {
      _emitIfValid();
      return;
    }

    final n = int.tryParse(raw);
    if (n == null) {
      _emitIfValid();
      return;
    }

    if (widget.clampOutOfRangeOnBlur) {
      if (part == Part.year) {
        final clamped = n.clamp(widget.minYear, widget.maxYear);
        raw = clamped.toString();
      } else if (part == Part.month) {
        final clamped = n.clamp(1, 12);
        raw = clamped.toString();
      } else {
        final y = int.tryParse(yearController.text);
        final m = int.tryParse(monthController.text);
        final maxDay = (y != null && m != null && m >= 1 && m <= 12)
            ? DateUtils.getDaysInMonth(y, m)
            : 31;
        final clamped = n.clamp(1, maxDay);
        raw = clamped.toString();
      }
    }

    if (widget.autoPadOnBlur) {
      if (part == Part.month || part == Part.day) {
        raw = raw.padLeft(2, '0');
      }
    }

    c.value = TextEditingValue(
      text: raw,
      selection: TextSelection.collapsed(offset: raw.length),
    );

    _emitIfValid();
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
          textInputAction: TextInputAction.next,
          onFilledMoveTo: monthFocus,
        ),
        const SizedBox(width: 8),
        const Text("년"),
        const SizedBox(width: 8),
        _buildInput(
          controller: monthController,
          focusNode: monthFocus,
          hint: 'MM',
          maxLength: 2,
          textInputAction: TextInputAction.next,
          onFilledMoveTo: dayFocus,
        ),
        const SizedBox(width: 8),
        const Text("월"),
        const SizedBox(width: 8),
        _buildInput(
          controller: dayController,
          focusNode: dayFocus,
          hint: 'DD',
          maxLength: 2,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _onBlur(dayController, Part.day),
        ),
        const SizedBox(width: 8),
        const Text("일"),
      ],
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hint,
    required int maxLength,
    TextInputAction? textInputAction,
    FocusNode? onFilledMoveTo,
    ValueChanged<String>? onSubmitted,
  }) {
    final width = (maxLength == 4) ? 80.0 : 50.0;

    return SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: maxLength,
        textInputAction: textInputAction,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: const InputDecoration(
          hintText: '',
          counterText: '',
          border: OutlineInputBorder(),
        ).copyWith(hintText: hint),
        onChanged: (value) {
          if (value.length == maxLength && onFilledMoveTo != null) {
            onFilledMoveTo.requestFocus();
          }

          _emitIfValid();
        },
        onSubmitted: onSubmitted,
      ),
    );
  }
}

enum Part { year, month, day }
