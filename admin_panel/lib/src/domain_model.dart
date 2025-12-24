import 'dart:math';

import 'package:equatable/equatable.dart';

class AdminStats extends Equatable {
  final int adminUserCount;
  final int traineeUserCount;
  final int coachUserCount;
  int get totalUserCount =>
      max(adminUserCount, max(traineeUserCount, coachUserCount));
  final int coachProgramCount;
  final int completedExerciseCount;
  final int pendingSettlePurchasedProgramsCount;
  final int pendingTransferPurchasedProgramsCount;
  final int failedPurchasedProgramsCount;
  final int completedPurchasedProgramsCount;
  final int refundPurchasedProgramsCount;
  // Inside AdminStats class
  // double get liquidityRate {
  //   if (totalUserCount == 0) return 0.0;
  //   // Percentage of programs that lead to completed exercises (as a proxy for interaction)
  //   return (completedExerciseCount / totalUserCount);
  // }

  const AdminStats({
    required this.adminUserCount,
    required this.traineeUserCount,
    required this.coachUserCount,
    required this.coachProgramCount,
    required this.completedExerciseCount,
    required this.pendingSettlePurchasedProgramsCount,
    required this.pendingTransferPurchasedProgramsCount,
    required this.failedPurchasedProgramsCount,
    required this.completedPurchasedProgramsCount,
    required this.refundPurchasedProgramsCount,
  });
  int get totalPurchasedProgramsCount =>
      refundPurchasedProgramsCount +
      completedPurchasedProgramsCount +
      failedPurchasedProgramsCount +
      pendingTransferPurchasedProgramsCount +
      pendingSettlePurchasedProgramsCount;

  @override
  List<Object?> get props => [
    adminUserCount,
    traineeUserCount,
    coachUserCount,
    coachProgramCount,
    completedExerciseCount,
    pendingSettlePurchasedProgramsCount,
    pendingTransferPurchasedProgramsCount,
    failedPurchasedProgramsCount,
    completedPurchasedProgramsCount,
    refundPurchasedProgramsCount,
  ];
}
