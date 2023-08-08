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
  const SmallCard({super.key, required this.child});

  final Widget child;

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
                  child: child,
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
  const BigCard({super.key, required this.child});

  final Widget child;

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
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: child,
          ),
        ),
      ),
    );
  }
}
