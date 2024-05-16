import 'package:flutter/widgets.dart';
import 'package:supermercado_de_pobre/controllers/main_controller.dart';
import 'package:flutter/material.dart';

class ListItensComponent extends StatelessWidget {
  const ListItensComponent(
      {super.key,
      required this.listItens,
      required this.removeItem,
      required this.increaseQuantity,
      required this.decreaseQuantity});

  final List<Item> listItens;
  final Function(int) removeItem;
  final Function(int) increaseQuantity;
  final Function(int) decreaseQuantity;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: listItens
          .map(
            (item) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.35),
                      child: Text(
                        item.name.toString().toUpperCase(),
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .copyWith(fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'R\$${item.value.toStringAsFixed(2).replaceAll('.', ',')}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () =>
                          decreaseQuantity(listItens.indexOf(item)),
                      icon: const Icon(Icons.remove),
                    ),
                    SizedBox(
                      width: 32,
                      child: Text(
                        item.quantity.toString(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .copyWith(fontSize: 16),
                      ),
                    ),
                    IconButton(
                      onPressed: () =>
                          increaseQuantity(listItens.indexOf(item)),
                      icon: const Icon(Icons.add),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      onPressed: () => removeItem(listItens.indexOf(item)),
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
          .toList(),
    );
  }
}
