import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/theme/colors.dart';

class SearchBar extends StatefulWidget {
  final void Function(String) search;
  final String? text;
  const SearchBar({super.key, required this.search, this.text});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) => widget.search(value),
      decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.lightGrey,
          contentPadding: const EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.dark,
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide.none),
          hintStyle: TextStyle(fontSize: 14, color: AppColors.dark),
          hintText: widget.text ?? "Search courses"),
    );
  }
}
