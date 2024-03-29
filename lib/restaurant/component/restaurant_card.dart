import 'package:delivery_app_project/common/const/colors.dart';
import 'package:delivery_app_project/restaurant/model/restaurant_detail_model.dart';
import 'package:delivery_app_project/restaurant/model/restaurant_model.dart';
import 'package:flutter/material.dart';

class RestaurantCard extends StatelessWidget {
  final Widget image;
  final String name;
  final List<String> tags;
  final int ratingsCount;
  final int deliveryTime;
  final int deliveryFee;
  final double ratings;
  final bool isDetail;
  final String? detail;
  final String? heroKey;

  const RestaurantCard({
    Key? key,
    required this.image,
    required this.name,
    required this.tags,
    required this.ratingsCount,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.ratings,
    this.isDetail = false,
    this.detail,
    this.heroKey,
  }) : super(key: key);

  factory RestaurantCard.fromModel({
    required RestaurantModel model,
    bool isDetail = false,
  }) {
    return RestaurantCard(
      image: Image.network(
        model.thumbUrl,
        fit: BoxFit.cover,
      ),
      name: model.name,
      tags: model.tags,
      ratingsCount: model.ratingsCount,
      deliveryTime: model.deliveryTime,
      deliveryFee: model.deliveryFee,
      ratings: model.ratings,
      isDetail: isDetail,
      detail: model is RestaurantDetailModel ? model.detail : null,
      heroKey: model.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (heroKey != null)
          Hero(
            tag: ObjectKey(heroKey),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(isDetail ? 0 : 12.0),
              child: image,
            ),
          ),
        if (heroKey == null)
          ClipRRect(
            borderRadius: BorderRadius.circular(isDetail ? 0 : 12.0),
            child: image,
          ),
        const SizedBox(
          height: 16.0,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isDetail ? 16.0 : 0.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              Text(
                tags.join(" · "),
                style: TextStyle(
                  color: BODY_TEXT_COLOR,
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              Row(
                children: [
                  _IconText(
                    iconData: Icons.star,
                    label: ratings.toString(),
                  ),
                  _renderDot(),
                  _IconText(
                    iconData: Icons.receipt,
                    label: ratingsCount.toString(),
                  ),
                  _renderDot(),
                  _IconText(
                    iconData: Icons.timelapse_outlined,
                    label: "$deliveryTime분",
                  ),
                  _renderDot(),
                  _IconText(
                    iconData: Icons.monetization_on,
                    label: deliveryFee == 0 ? "무료" : deliveryFee.toString(),
                  ),
                ],
              ),
              if (detail != null && isDetail)
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 8.0,
                  ),
                  child: Text(
                    detail!,
                  ),
                ),
            ],
          ),
        )
      ],
    );
  }

  Widget _renderDot() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 4.0,
      ),
      child: Text(
        "·",
        style: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _IconText extends StatelessWidget {
  final IconData iconData;
  final String label;

  const _IconText({
    Key? key,
    required this.iconData,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          iconData,
          size: 14.0,
          color: PRIMARY_COLOR,
        ),
        SizedBox(
          width: 8.0,
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }
}
