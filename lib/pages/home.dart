import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.load();
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        Text(
                          'Essencial',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: ListItensComponent(
                            listItens: controller.essencial.watch(context),
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
                        const SizedBox(height: 16),
                        Text(
                          'Superfluos ',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: ListItensComponent(
                            listItens: controller.superfluos.watch(context),
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
                      ],
                    ),
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
