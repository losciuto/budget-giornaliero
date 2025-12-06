import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class ReceiptScanner {
  /// Scans a receipt from the given [source] (camera or gallery) and returns the detected total amount.
  /// Returns null if cancelled, error, or no amount found.
  static Future<double?> scanReceipt(ImageSource source) async {
    // Basic check: MLKit text recognition is only available on Mobile (Android/iOS)
    // On other platforms, we return null or throw. 
    // Here we just return null to avoid crashing if main.dart doesn't check.
    if (!Platform.isAndroid && !Platform.isIOS) {
      debugPrint('Receipt Scanner not supported on this platform');
      return null;
    }

    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);
      
      if (pickedFile == null) return null;

      final inputImage = InputImage.fromFilePath(pickedFile.path);
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      
      try {
        final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
        return _extractAmount(recognizedText);
      } finally {
        textRecognizer.close();
      }
    } catch (e) {
      debugPrint('Error scanning receipt: $e');
      return null;
    }
  }

  static double? _extractAmount(RecognizedText text) {
    // Flatten lines for easier processing
    List<String> lines = [];
    for (TextBlock block in text.blocks) {
      for (TextLine line in block.lines) {
        lines.add(line.text);
      }
    }

    if (lines.isEmpty) return null;

    // RegEx to find prices (e.g., 12,50 or 12.50)
    // Matches numbers with exactly 2 decimal digits, allowing , or . as separator
    final priceRegex = RegExp(r'\b\d+[.,]\d{2}\b');
    
    // Keywords for total
    final totalKeywords = ['totale', 'total', 'importo', 'amount', 'summe', 'somme'];

    double? bestAmount;
    int bestAmountIndex = -1;

    // Strategy 1: Look for "Totale" keyword and finding number on same or next line
    for (int i = 0; i < lines.length; i++) {
      String lineLower = lines[i].toLowerCase();
      
      // Check if line contains any total keyword
      bool isTotalLine = totalKeywords.any((k) => lineLower.contains(k));
      
      if (isTotalLine) {
        // Try to find number in this line
        double? amount = _findNumberInString(lines[i], priceRegex);
        
        // If not found, try next line (often "Totale" is a label, amount is below)
        if (amount == null && i + 1 < lines.length) {
           amount = _findNumberInString(lines[i + 1], priceRegex);
        }

        if (amount != null) {
          // If we found a "Total" line with a number, this is a strong candidate.
          // We prefer the *last* occurrence of Total usually (grand total vs subtotal)
          bestAmount = amount;
          bestAmountIndex = i;
        }
      }
    }

    if (bestAmount != null) return bestAmount;

    // Strategy 2: If no "Total" keyword found, find the largest numerical value 
    // that looks like a price. (Risk: date 20.24 could be confused, but date usually not just 2 decimals)
    
    double maxAmount = 0.0;
    bool foundAny = false;

    for (String line in lines) {
      var matches = priceRegex.allMatches(line);
      for (var match in matches) {
        String numStr = match.group(0)!;
        double? val = _parsePrice(numStr);
        if (val != null) {
             // Heuristic: discard if it looks like a year (e.g. 2024, 2025)
             // Though 20.24 is a valid price. 
             // Receipts usually have dates like dd/mm/yyyy or dd.mm.yy.
             // Our regex requires X.XX or X,XX (2 decimals).
             // Year 2025 usually doesn't have decimals unless it's 20.25 (time?).
             // We'll take the risk or try to filter.
             if (val > maxAmount) {
               maxAmount = val;
               foundAny = true;
             }
        }
      }
    }

    return foundAny ? maxAmount : null;
  }

  static double? _findNumberInString(String text, RegExp regex) {
    // Find all matches, take the last one on the line (usually amount is right-aligned)
    var matches = regex.allMatches(text);
    if (matches.isEmpty) return null;
    
    String lastMatch = matches.last.group(0)!;
    return _parsePrice(lastMatch);
  }

  static double? _parsePrice(String priceStr) {
    // Replace , with .
    String normalized = priceStr.replaceAll(',', '.');
    return double.tryParse(normalized);
  }
}
