import 'dart:math';

import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

import '../components/add_item_component.dart';
import '../components/list_itens_component.dart';
import '../components/total_component.dart';
import '../controllers/main_controller.dart';
import '../main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = AUTOINJECTOR.get<MainController>();
  bool showEssencial = true;
  bool showSuperfluo = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    final safeAreaHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: height - safeAreaHeight,
          width: width,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: () => setState(() {
                          showEssencial = !showEssencial;
                        }),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Essencial',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(fontWeight: FontWeight.w500),
                            ),
                            AnimatedRotation(
                              turns: showEssencial ? 0.25 : 0,
                              duration: const Duration(milliseconds: 100),
                              child: const Icon(
                                  Icons.keyboard_arrow_right_rounded),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                controller.clearEssencial();
                              },
                              child: const Text('Limpar'),
                            ),
                          ],
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeIn,
                        height: showEssencial
                            ? max(
                                40,
                                controller.essencial.watch(context).length *
                                        40 +
                                    24,
                              )
                            : 0,
                        child: SizedBox(
                          width: double.infinity,
                          child: controller.essencial.watch(context).isEmpty
                              ? const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Nenhum item adicionado',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                )
                              : Card(
                                  color: Theme.of(context).colorScheme.surface,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListItensComponent(
                                      listItens:
                                          controller.essencial.watch(context),
                                      removeItem: controller.removeEssencial,
                                      increaseQuantity: (v) {
                                        controller.increaseQuantityEssencial(v);
                                        setState(() {});
                                      },
                                      decreaseQuantity: (v) {
                                        controller.decreaseQuantityEssencial(v);
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => setState(() {
                          showSuperfluo = !showSuperfluo;
                        }),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Superfluo',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(fontWeight: FontWeight.w500),
                            ),
                            AnimatedRotation(
                              turns: showSuperfluo ? 0.25 : 0,
                              duration: const Duration(milliseconds: 100),
                              child: const Icon(
                                  Icons.keyboard_arrow_right_rounded),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                controller.clearSuperfluos();
                              },
                              child: const Text('Limpar'),
                            ),
                          ],
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeIn,
                        height: showSuperfluo
                            ? max(
                                40,
                                controller.superfluos.watch(context).length *
                                        40 +
                                    24,
                              )
                            : 0,
                        child: SizedBox(
                          width: double.infinity,
                          child: controller.superfluos.watch(context).isEmpty
                              ? const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Nenhum item adicionado',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                )
                              : Card(
                                  color: Theme.of(context).colorScheme.surface,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListItensComponent(
                                      listItens:
                                          controller.superfluos.watch(context),
                                      removeItem: controller.removeSuperfluo,
                                      increaseQuantity: (v) {
                                        controller.increaseQuantitySuperfluo(v);
                                        setState(() {});
                                      },
                                      decreaseQuantity: (v) {
                                        controller.decreaseQuantitySuperfluo(v);
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 8,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                width: width,
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Watch.builder(builder: (context) {
                      return TotalComponent(
                          totalEssencial: controller.essencial.value.fold(
                              0.0,
                              (previousValue, element) =>
                                  previousValue +
                                  (element.value * element.quantity)),
                          totalSuperfluos: controller.superfluos.value.fold(
                              0.0,
                              (previousValue, element) =>
                                  previousValue +
                                  (element.value * element.quantity)),
                          total: controller.essencial.value.fold(
                                  0.0,
                                  (previousValue, element) =>
                                      previousValue +
                                      (element.value * element.quantity)) +
                              controller.superfluos.value.fold(
                                  0.0,
                                  (previousValue, element) =>
                                      previousValue +
                                      (element.value * element.quantity)));
                    }),
                    const SizedBox(height: 8),
                    AddItemComponent(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
