import 'package:flutter/material.dart';
import 'package:online_shop/core/extensions/media_query_extension.dart';

class ProductWidget extends StatelessWidget {
  final String name;
  final String description;
  final double price;
  final double rating;
  final String thumbnail;

  const ProductWidget({
    super.key,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.thumbnail,
  });

  // I have used white and black color a lot in this widget so thats why defined them.
  final Color whiteColor = Colors.white;
  final Color blackColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        // Using media query so that my widget will be responsive in every device
        vertical: 0.016 * context.mqSize.height,
        horizontal: 0.041 * context.mqSize.width,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: whiteColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // This the custom widget to show the thumbnail of the product.
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AspectRatio(
              aspectRatio: 0.89,
              child: Image.network(thumbnail),
            ),
          ),
          SizedBox(height: 0.017 * context.mqSize.height),

          // This widget is used to show the product name properly.
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: blackColor,
              fontSize: 0.02 * context.mqSize.height,
            ),
          ),
          SizedBox(height: 0.008 * context.mqSize.height),

          // This widget is used to show the description of the product in three lines.
          Text(
            description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: blackColor,
              fontSize: 0.02 * context.mqSize.height,
            ),
          ),
          SizedBox(height: 0.0136 * context.mqSize.height),

          // This row consists the price of the product and the rating.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // I have used the Flexible on the Price text so that Text widget
              // will take the minimum required space from the available space.
              Flexible(
                child: Text(
                  '\$$price',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: blackColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 0.023 * context.mqSize.height,
                  ),
                ),
              ),

              // Row of Star Icon and the Rating of the product.
              Row(
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 0.017 * context.mqSize.height,
                  ),
                  Text(
                    // I have taken the rating upto 2 decimal places only.
                    rating.toStringAsFixed(2),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: blackColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 0.017 * context.mqSize.height,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
