import 'package:supermercado_de_pobre/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controllers/main_controller.dart';

class AddItemComponent extends StatelessWidget {
  AddItemComponent({super.key});
  final controller = AUTOINJECTOR.get<MainController>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: width * 0.50,
              height: 40,
              child: TextField(
                controller: controller.nomeCompraController,
                decoration: InputDecoration(
                  hintText: 'Nome do item',
                  contentPadding: const EdgeInsets.all(8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.background,
                ),
              ),
            ),
            SizedBox(
              width: width * 0.38,
              height: 40,
              child: TextField(
                controller: controller.valorCompraController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: false),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(20),
                ],
                decoration: InputDecoration(
                  hintText: 'Valor do item',
                  prefix: const Text('R\$: '),
                  contentPadding: const EdgeInsets.all(8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.background,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: width * 0.28,
              height: 40,
              child: TextField(
                controller: controller.qtdController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+'))
                ],
                decoration: InputDecoration(
                  hintText: 'Quantidade',
                  contentPadding: const EdgeInsets.all(8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.background,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 40,
                  child: FilledButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                            Theme.of(context).colorScheme.secondary),
                        shape: WidgetStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        )),
                      ),
                      onPressed: () {
                        if (controller.nomeCompraController.text.isEmpty ||
                            controller.valorCompraController.text.isEmpty) {
                          return;
                        }
                        if (controller.qtdController.text.isEmpty) {
                          final s =
                              controller.nomeCompraController.text.split(' ');
                          if (s.length > 1 && int.tryParse(s[0]) != null) {
                            controller.addSuperfluo(
                                controller.nomeCompraController.text
                                    .trim()
                                    .substring(s[0].length + 1),
                                controller.valorCompraController.numberValue,
                                int.parse(s[0]));
                          } else {
                            controller.addSuperfluo(
                                controller.nomeCompraController.text,
                                controller.valorCompraController.numberValue);
                          }
                        } else {
                          controller.addSuperfluo(
                              controller.nomeCompraController.text,
                              controller.valorCompraController.numberValue,
                              int.parse(controller.qtdController.text));
                        }

                        controller.nomeCompraController.clear();
                        controller.valorCompraController.updateValue(0);
                        controller.qtdController.clear();
                      },
                      child: const Text('Superfluo')),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 40,
                  child: FilledButton(
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        )),
                      ),
                      onPressed: () {
                        if (controller.nomeCompraController.text.isEmpty ||
                            controller.valorCompraController.text.isEmpty) {
                          return;
                        }
                        if (controller.qtdController.text.isEmpty) {
                          final s =
                              controller.nomeCompraController.text.split(' ');
                          if (s.length > 1 && int.tryParse(s[0]) != null) {
                            controller.addEssencial(
                                controller.nomeCompraController.text
                                    .trim()
                                    .substring(s[0].length + 1),
                                controller.valorCompraController.numberValue,
                                int.parse(s[0]));
                          } else {
                            controller.addEssencial(
                                controller.nomeCompraController.text,
                                controller.valorCompraController.numberValue);
                          }
                        } else {
                          controller.addEssencial(
                              controller.nomeCompraController.text,
                              controller.valorCompraController.numberValue,
                              int.parse(controller.qtdController.text));
                        }

                        controller.nomeCompraController.clear();
                        controller.valorCompraController.updateValue(0);
                        controller.qtdController.clear();
                      },
                      child: const Text('Essencial')),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
