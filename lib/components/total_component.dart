import 'package:flutter/material.dart';

class TotalComponent extends StatelessWidget {
  const TotalComponent(
      {super.key, this.totalEssencial, this.totalSuperfluos, this.total});
  final totalEssencial;
  final totalSuperfluos;
  final total;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Essencial',
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              totalEssencial.toStringAsFixed(2),
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Superfluo: ',
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              totalSuperfluos.toStringAsFixed(2),
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              'Total: ',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              total.toStringAsFixed(2),
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}
