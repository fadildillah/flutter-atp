import 'package:flutter/material.dart';

class CustomDropDown<T> extends StatelessWidget {
  final IconData? icon;
  final T? value;
  final List<DropdownMenuItem<T>>? items;
  final void Function(T?)? onChanged;
  final String hintText;

  const CustomDropDown({
    super.key,
    this.icon,
    this.value,
    this.items,
    this.onChanged,
    this.hintText = "Select an option",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.onSurface),
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<T>(
            hint: Text(
              hintText,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            icon: Icon(
              icon ?? Icons.arrow_drop_down,
              color: Colors.blue,
            ),
            isExpanded: true,
            value: value,
            items: items,
            onChanged: onChanged,
            dropdownColor: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(12),
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
      ),
    );
  }
}
