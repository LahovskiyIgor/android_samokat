import 'scooter.dart';

class ScooterOrder {
  final int id;
  final int scooterId;
  final Scooter? scooter;
  final int? planId;
  final ScooterPlan? plan;
  final int clientId;
  final int? subscriptionId;
  final int? cardId;
  final bool isBalance;
  final int decimals;
  final bool isInsurance;
  final double? insurancePrice;
  final String? insurancePricePrint;
  final double? holdPrice;
  final String? holdPricePrint;
  final double? totalPrice;
  final String? totalPricePrint;
  final int? currencyId;
  final String status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? startAt;
  final DateTime? finishAt;
  final DateTime? expiresAt;
  final DateTime? cancelAt;
  final String? cancelDescription;

  ScooterOrder({
    required this.id,
    required this.scooterId,
    this.scooter,
    this.planId,
    this.plan,
    required this.clientId,
    this.subscriptionId,
    this.cardId,
    required this.isBalance,
    required this.decimals,
    required this.isInsurance,
    this.insurancePrice,
    this.insurancePricePrint,
    this.holdPrice,
    this.holdPricePrint,
    this.totalPrice,
    this.totalPricePrint,
    this.currencyId,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.startAt,
    this.finishAt,
    this.expiresAt,
    this.cancelAt,
    this.cancelDescription,
  });

  factory ScooterOrder.fromJson(Map<String, dynamic> json) {
    return ScooterOrder(
      id: json['id'] ?? 0,
      scooterId: json['scooterId'] ?? 0,
      scooter: json['scooter'] != null ? Scooter.fromJson(json['scooter']) : null,
      planId: json['planId'],
      plan: json['plan'] != null ? ScooterPlan.fromJson(json['plan']) : null,
      clientId: json['clientId'] ?? 0,
      subscriptionId: json['subscriptionId'],
      cardId: json['cardId'],
      isBalance: json['isBalance'] ?? false,
      decimals: json['decimals'] ?? 0,
      isInsurance: json['isInsurance'] ?? false,
      insurancePrice: (json['insurancePrice'] as num?)?.toDouble(),
      insurancePricePrint: json['insurancePricePrint'],
      holdPrice: (json['holdPrice'] as num?)?.toDouble(),
      holdPricePrint: json['holdPricePrint'],
      totalPrice: (json['totalPrice'] as num?)?.toDouble(),
      totalPricePrint: json['totalPricePrint'],
      currencyId: json['currencyId'],
      status: json['status'] ?? '',
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
      startAt: json['startAt'] != null 
          ? DateTime.parse(json['startAt']) 
          : null,
      finishAt: json['finishAt'] != null 
          ? DateTime.parse(json['finishAt']) 
          : null,
      expiresAt: json['expiresAt'] != null 
          ? DateTime.parse(json['expiresAt']) 
          : null,
      cancelAt: json['cancelAt'] != null 
          ? DateTime.parse(json['cancelAt']) 
          : null,
      cancelDescription: json['cancelDescription'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scooterId': scooterId,
      'planId': planId,
      'subscriptionId': subscriptionId,
      'cardId': cardId,
      'isBalance': isBalance,
      'isInsurance': isInsurance,
    };
  }
}

class ScooterPlan {
  final int id;
  final String name;
  final double price;
  final String? description;

  ScooterPlan({
    required this.id,
    required this.name,
    required this.price,
    this.description,
  });

  factory ScooterPlan.fromJson(Map<String, dynamic> json) {
    return ScooterPlan(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      description: json['description'],
    );
  }
}
