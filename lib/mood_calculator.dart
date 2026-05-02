class MoodCalculator {
  static double journalToScore(String text) {
    text = text.toLowerCase();

    int score = 50;

    // POSITIF
    if (text.contains("senang") || text.contains("bahagia")) score += 30;
    if (text.contains("bersyukur")) score += 20;
    if (text.contains("tenang")) score += 15;

    // NEGATIF
    if (text.contains("sedih")) score -= 25;
    if (text.contains("hancur")) score -= 30;
    if (text.contains("lelah") || text.contains("capek")) score -= 10;
    if (text.contains("cemas")) score -= 20;
    if (text.contains("takut")) score -= 15;
    if (text.contains("marah")) score -= 15;
    if (text.contains("stress") || text.contains("stres")) score -= 20;
    if (text.contains("overthinking")) score -= 25;
    if (text.contains("hampa")) score -= 30;

    if (score > 100) score = 100;
    if (score < 0) score = 0;

    return score.toDouble();
  }

  static String status(int score) {
    if (score >= 80) return "Sangat Stabil";
    if (score >= 70) return "Stabil";
    if (score >= 50) return "Cukup Stabil";
    if (score >= 30) return "Perlu Perhatian";
    return "Risiko Tinggi";
  }

  static String recommendation(int score) {
    if (score >= 80) {
      return "🔥 Hari kamu sangat bagus! Pertahankan kebiasaan positif.";
    }
    if (score >= 60) {
      return "🙂 Kondisi cukup baik, tetap jaga emosi.";
    }
    if (score >= 40) {
      return "⚠️ Kamu mulai butuh stabilisasi emosi.";
    }
    return "🧘 Fokus pemulihan diri sangat disarankan.";
  }

  static String meditation(int score) {
    if (score >= 80) {
      return "Meditasi gratitude untuk menjaga energi positif.";
    }
    if (score >= 60) {
      return "Meditasi pernapasan 4-7-8.";
    }
    if (score >= 40) {
      return "Meditasi anxiety & overthinking.";
    }
    return "Meditasi stres berat (suara alam).";
  }
}