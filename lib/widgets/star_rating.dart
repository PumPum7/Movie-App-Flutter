// Flutter imports:
import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final int starCount;
  final double rating;
  final Color color;
  final double? size;

  const StarRating({super.key, this.starCount = 5, this.rating = .0, required this.color, this.size});

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon =  Icon(
        Icons.star_border,
        size: size,
      );
    }
    else if (index > rating - 1 && index < rating) {
      icon =  Icon(
        Icons.star_half,
        color: color,
        size: size,
      );
    } else {
      icon =  Icon(
        Icons.star,
        color: color,
        size: size,
      );
    }
    return icon;
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: List.generate(starCount, (index) => buildStar(context, index)));
  }
}
