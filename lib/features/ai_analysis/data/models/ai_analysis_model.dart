class AiAnalysisModel {
  const AiAnalysisModel({
    required this.id,
    required this.projectName,
    required this.summary,
    required this.riskScore,
    required this.confidenceScore,
    required this.recommendations,
    required this.generatedAt,
  });

  final String id;
  final String projectName;
  final String summary;
  final int riskScore;
  final int confidenceScore;
  final List<String> recommendations;
  final String generatedAt;
}
