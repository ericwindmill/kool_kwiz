import 'package:flutter/material.dart';
import 'package:koolkwiz/marketplace/marketplace.dart';

class Seasons extends StatelessWidget {
  const Seasons({this.smallSize = false, super.key});

  final bool smallSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Circle(
          color: Marketplace.theme.colorScheme.tertiary,
          size: smallSize ? small : medium,
        ),
        SizedBox(width: 8),
        Circle(
          color: Marketplace.theme.colorScheme.secondary,
          size: smallSize ? small : medium,
        ),
        SizedBox(width: 8),
        Circle(
          color: Marketplace.theme.colorScheme.scrim,
          size: smallSize ? small : medium,
        ),
        SizedBox(width: 8),
        Circle(
          color: Marketplace.theme.colorScheme.primary,
          size: smallSize ? small : medium,
        ),
      ],
    );
  }
}

class SmallCard extends StatelessWidget {
  const SmallCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Marketplace.theme.colorScheme.onSecondary,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(25),
          color: Marketplace.theme.colorScheme.onPrimary,
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(15, 15, 20, 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 105,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Marketplace.theme.colorScheme.onSecondary,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child:
                      Image.asset('assets/images/apple.jpg', fit: BoxFit.cover),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Apples',
                            style: Marketplace.heading2,
                          ),
                          Spacer(),
                          Seasons(
                            smallSize: true,
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                          style: Marketplace.paragraph,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          'Green or red, they\'re generally round and tasty.'),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Marketplace.theme.colorScheme.onSecondary,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(25),
          color: Marketplace.theme.colorScheme.onPrimary,
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(6),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 190,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Marketplace.theme.colorScheme.onSecondary,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset('assets/images/apple.jpg',
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Row(
                  children: [
                    Text(
                      'Apples',
                      style: Marketplace.heading2,
                    ),
                    Spacer(),
                    Seasons(),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Text(
                  style: Marketplace.subheading1,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  'Green or red, they\'re generally round and tasty.',
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
