import 'package:flutter/material.dart';
import 'package:flutter_30days/week2/shrine_app/models/product.dart';
import 'package:flutter_30days/week2/shrine_app/supplemental/product_card.dart';

class TwoProductColumn extends StatelessWidget {
  final Product? top;
  final Product bottom;

  const TwoProductColumn({Key? key, this.top, required this.bottom})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      const spacerHeight = 44.0;

      double heightOfCards = (constraints.biggest.height - spacerHeight) / 2.0;
      double heightOfImages = heightOfCards - ProductCard.kTextBoxHeight;
      // TODO: Change imageAspectRatio calculation (104)
      double imageAspectRatio = constraints.biggest.width / heightOfImages;

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsetsDirectional.only(start: 28.0),
            child: top != null
                ? ProductCard(
                    imageAspectRatio: imageAspectRatio,
                    product: top!,
                  )
                : SizedBox(
                    height: heightOfCards,
                  ),
          ),
          SizedBox(height: spacerHeight),
          Padding(
            padding: EdgeInsetsDirectional.only(end: 28.0),
            child: ProductCard(
              imageAspectRatio: imageAspectRatio,
              product: bottom,
            ),
          ),
        ],
      );
    });
  }
}

class OneProductColumn extends StatelessWidget {
  final Product product;

  const OneProductColumn({Key? key, required this.product}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ProductCard(product: product),
        const SizedBox(
          height: 40,
        )
      ],
    );
  }
}
