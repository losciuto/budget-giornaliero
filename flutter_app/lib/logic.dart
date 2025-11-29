import 'package:flutter/material.dart';

class BudgetLogic {
  /// Calcola i giorni mancanti alla data target.
  /// [currentDate] è la data di oggi.
  /// [targetDay] è il giorno del mese target (default 27).
  static int calculateDays(DateTime currentDate, {int targetDay = 27}) {
    DateTime targetDate;
    
    // Se il giorno corrente è già oltre il target, andiamo al mese prossimo
    if (currentDate.day > targetDay) {
      if (currentDate.month == 12) {
        targetDate = DateTime(currentDate.year + 1, 1, targetDay);
      } else {
        targetDate = DateTime(currentDate.year, currentDate.month + 1, targetDay);
      }
    } else {
      // Altrimenti restiamo nel mese corrente
      try {
        targetDate = DateTime(currentDate.year, currentDate.month, targetDay);
      } catch (e) {
        // Gestione casi limite (es. febbraio non ha 30 giorni)
        // Per semplicità, se fallisce, proviamo l'ultimo giorno del mese
        int lastDay = DateUtils.getDaysInMonth(currentDate.year, currentDate.month);
        targetDate = DateTime(currentDate.year, currentDate.month, lastDay);
      }
    }

    // Calcoliamo la differenza
    // Aggiungiamo 1 perché vogliamo includere il giorno target nel conteggio?
    // La logica originale Python faceva: (target - today).days + 1
    // Verifichiamo: oggi 20, target 27. Diff = 7 giorni. +1 = 8 giorni (20,21,22,23,24,25,26,27). Corretto.
    
    // Normalizziamo le date a mezzanotte per evitare problemi con le ore
    final todayMidnight = DateTime(currentDate.year, currentDate.month, currentDate.day);
    final targetMidnight = DateTime(targetDate.year, targetDate.month, targetDate.day);
    
    return targetMidnight.difference(todayMidnight).inDays + 1;
  }

  /// Calcola il budget giornaliero.
  static double calculateDailyBudget(double amount, int days) {
    if (days <= 0) return 0.0;
    return amount / days;
  }
  
  /// Determina la data target iniziale basata sulla data corrente.
  static DateTime getInitialTargetDate(DateTime now, {int targetDay = 27}) {
    if (now.day > targetDay) {
      if (now.month == 12) {
        return DateTime(now.year + 1, 1, targetDay);
      } else {
        return DateTime(now.year, now.month + 1, targetDay);
      }
    } else {
      return DateTime(now.year, now.month, targetDay);
    }
  }
}
