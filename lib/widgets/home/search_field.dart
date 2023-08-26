// Flutter imports:
import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  const SearchField({super.key});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
          suffixIcon: const Icon(Icons.search),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            borderSide: BorderSide(color: Colors.blue),
          ),
          hintText: 'Search for movies, tv show or actor...',
          errorBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: const BorderSide(
                color: Colors.red,
              ))),
    );
  }
}
