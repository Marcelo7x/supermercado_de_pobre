// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  bool operator ==(covariant Item other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.value == value &&
        other.quantity == quantity;
  }

  @override
  int get hashCode => name.hashCode ^ value.hashCode ^ quantity.hashCode;
}

class MainController {
  final essencial = listSignal<Item>(<Item>[], debugLabel: 'essencialList');
  final superfluos = listSignal<Item>(<Item>[], debugLabel: 'superfluosList');
  final nomeCompraController = TextEditingController();
  final valorCompraController = TextEditingController();
  final qtdController = TextEditingController();

  MainController();

  Future<void> load() async {
    SharedPreferences.getInstance().then((prefs) {
        final essencialList = prefs.getStringList('essencial');
        final superfluosList = prefs.getStringList('superfluos');
        if (essencialList != null) {
          essencial.addAll(essencialList
              .map((compra) => Item.fromJson(json.decode(compra))));
          essencial.sort((a, b) => (-a.value).compareTo(-b.value));
        }
        if (superfluosList != null) {
          superfluos.addAll(superfluosList
              .map((compra) => Item.fromJson(json.decode(compra))));
          superfluos.sort((a, b) => (-a.value).compareTo(-b.value));
        }
      });
  }

  void addEssencial(String nome, double valor, [int qtd = 1]) {
    essencial.add(Item(nome, valor, qtd));
    essencial.sort((a, b) => a.value.compareTo(b.value));
    SharedPreferences.getInstance().then((prefs) {
      prefs.setStringList('essencial',
          essencial.value.map((compra) => json.encode(compra)).toList());
    });
  }

  void addSuperfluo(String nome, double valor, [int qtd = 1]) {
    superfluos.add(Item(nome, valor, qtd));
    superfluos.sort((a, b) => (-a.value).compareTo(-b.value));
    SharedPreferences.getInstance().then((prefs) {
      prefs.setStringList('superfluos',
          superfluos.value.map((compra) => json.encode(compra)).toList());
    });
  }

  void updateEssencial(int index, String nome, double valor, [int qtd = 1]) {
    essencial[index] = Item(nome, valor, qtd);

    SharedPreferences.getInstance().then((prefs) {
      prefs.setStringList('essencial',
          essencial.value.map((compra) => json.encode(compra)).toList());
    });
  }

  void updateSuperfluo(int index, String nome, double valor, [int qtd = 1]) {
    superfluos[index] = Item(nome, valor, qtd);

    SharedPreferences.getInstance().then((prefs) {
      prefs.setStringList('superfluos',
          superfluos.value.map((compra) => json.encode(compra)).toList());
    });
  }

  void increaseQuantityEssencial(int index) {
    if (superfluos[index].quantity < 999) {
      essencial[index].quantity++;

      SharedPreferences.getInstance().then((prefs) {
        prefs.setStringList('essencial',
            essencial.value.map((compra) => json.encode(compra)).toList());
      });
    }
  }

  void decreaseQuantityEssencial(int index) {
    if (essencial[index].quantity > 1) {
      essencial[index].quantity--;

      SharedPreferences.getInstance().then((prefs) {
        prefs.setStringList('essencial',
            essencial.value.map((compra) => json.encode(compra)).toList());
      });
    }
  }

  void increaseQuantitySuperfluo(int index) {
    if (superfluos[index].quantity < 999) {
      superfluos[index].quantity++;

      SharedPreferences.getInstance().then((prefs) {
        prefs.setStringList('superfluos',
            superfluos.value.map((compra) => json.encode(compra)).toList());
      });
    }
  }

  void decreaseQuantitySuperfluo(int index) {
    if (superfluos[index].quantity > 1) {
      superfluos[index].quantity--;

      SharedPreferences.getInstance().then((prefs) {
        prefs.setStringList('superfluos',
            superfluos.value.map((compra) => json.encode(compra)).toList());
      });
    }
  }

  void removeEssencial(int index) {
    essencial.removeAt(index);

    SharedPreferences.getInstance().then((prefs) {
      prefs.setStringList('essencial',
          essencial.value.map((compra) => json.encode(compra)).toList());
    });
  }

  void removeSuperfluo(int index) {
    superfluos.removeAt(index);

    SharedPreferences.getInstance().then((prefs) {
      prefs.setStringList('superfluos',
          superfluos.value.map((compra) => json.encode(compra)).toList());
    });
  }
}
