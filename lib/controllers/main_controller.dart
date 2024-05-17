import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:signals/signals.dart';

class Item {
  String name;
  double value;
  int quantity;

  Item(this.name, this.value, [this.quantity = 1]);

  Map<String, dynamic> toMap() => {
        'name': name,
        'value': value,
        'quantity': quantity,
      };

  factory Item.fromMap(Map<String, dynamic> map) =>
      Item(map['name'], map['value'], map['quantity']);

  String toJson() => json.encode(toMap());
  factory Item.fromJson(String json) => Item.fromMap(jsonDecode(json));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Item &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          value == other.value &&
          quantity == other.quantity;

  @override
  int get hashCode => name.hashCode ^ value.hashCode ^ quantity.hashCode;
}

class MainController {
  final loading = signal(false);
  final essencial = listSignal<Item>(<Item>[], debugLabel: 'essencialList');
  final superfluos = listSignal<Item>(<Item>[], debugLabel: 'superfluosList');
  final nomeCompraController = TextEditingController();
  final valorCompraController = MoneyMaskedTextController(
      decimalSeparator: ',', thousandSeparator: '.', precision: 2);
  final qtdController = TextEditingController();

  MainController();

  Future<void> load() async {
    loading.value = true;
    final prefs = await SharedPreferences.getInstance();
    _loadList(prefs, 'essencial', essencial);
    _loadList(prefs, 'superfluos', superfluos);
    loading.value = false;
  }

  void _loadList(SharedPreferences prefs, String key, ListSignal<Item> list) {
    final storedList = prefs.getStringList(key);
    if (storedList != null) {
      list.value = storedList.map((item) => Item.fromJson(item)).toList();
      list.sort((a, b) => b.value.compareTo(a.value));
    }
  }

  void _saveList(String key, ListSignal<Item> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        key, list.value.map((item) => item.toJson()).toList());
  }

  void addItem(String key, ListSignal<Item> list, String nome, double valor,
      [int qtd = 1]) {
    loading.value = true;
    list.add(Item(nome, valor, qtd));
    list.sort((a, b) => b.value.compareTo(a.value));
    _saveList(key, list);
    loading.value = false;
  }

  void updateItem(
      String key, ListSignal<Item> list, int index, String nome, double valor,
      [int qtd = 1]) {
    loading.value = true;
    list[index] = Item(nome, valor, qtd);
    _saveList(key, list);
    loading.value = false;
  }

  void changeQuantity(String key, ListSignal<Item> list, int index, int delta) {
    loading.value = true;
    final item = list[index];
    final newQuantity = item.quantity + delta;
    if (newQuantity > 0 && newQuantity < 1000) {
      list[index] = Item(item.name, item.value, newQuantity);
      _saveList(key, list);
    }
    loading.value = false;
  }

  void removeItem(String key, ListSignal<Item> list, int index) {
    loading.value = true;
    list.removeAt(index);
    _saveList(key, list);
    loading.value = false;
  }

  void clearList(String key, ListSignal<Item> list) {
    loading.value = true;
    list.clear();
    _saveList(key, list);
    loading.value = false;
  }

  void addEssencial(String nome, double valor, [int qtd = 1]) =>
      addItem('essencial', essencial, nome, valor, qtd);

  void addSuperfluo(String nome, double valor, [int qtd = 1]) =>
      addItem('superfluos', superfluos, nome, valor, qtd);

  void updateEssencial(int index, String nome, double valor, [int qtd = 1]) =>
      updateItem('essencial', essencial, index, nome, valor, qtd);

  void updateSuperfluo(int index, String nome, double valor, [int qtd = 1]) =>
      updateItem('superfluos', superfluos, index, nome, valor, qtd);

  void increaseQuantityEssencial(int index) =>
      changeQuantity('essencial', essencial, index, 1);

  void decreaseQuantityEssencial(int index) =>
      changeQuantity('essencial', essencial, index, -1);

  void increaseQuantitySuperfluo(int index) =>
      changeQuantity('superfluos', superfluos, index, 1);

  void decreaseQuantitySuperfluo(int index) =>
      changeQuantity('superfluos', superfluos, index, -1);

  void removeEssencial(int index) => removeItem('essencial', essencial, index);

  void removeSuperfluo(int index) =>
      removeItem('superfluos', superfluos, index);

  void clearEssencial() => clearList('essencial', essencial);

  void clearSuperfluos() => clearList('superfluos', superfluos);
}
