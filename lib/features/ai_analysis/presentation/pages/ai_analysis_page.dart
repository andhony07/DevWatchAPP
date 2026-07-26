import 'package:flutter/material.dart';

import '../../data/models/ai_analysis_model.dart';
import '../widgets/ai_recommendation_card.dart';
import '../widgets/analysis_history_card.dart';
import '../widgets/risk_score_card.dart';

class AiAnalysisPage extends StatefulWidget {
  const AiAnalysisPage({super.key});

  @override
  State<AiAnalysisPage> createState() => _AiAnalysisPageState();
}

class _AiAnalysisPageState extends State<AiAnalysisPage> {
  bool _isAnalyzing = false;

  static const _analysis = AiAnalysisModel(
    id: 'analysis-1',
    projectName: 'Production API',
    summary:
        'The infrastructure is currently stable, but sustained memory usage '
        'and intermittent response-time spikes may create performance issues '
        'under increased traffic.',
    riskScore: 46,
    confidenceScore: 91,
    recommendations: [
      'Investigate sustained memory utilization on the Worker Service.',
      'Configure automatic scaling before peak traffic periods.',
      'Review API Gateway latency and slow downstream requests.',
      'Create alerts for sustained CPU usage above 80%.',
    ],
    generatedAt: '10 min ago',
  );

  Future<void> _runAnalysis() async {
    setState(() {
      _isAnalyzing = true;
    });

    await Future<void>.delayed(const Duration(seconds: 2));

    if (!mounted) {
      return;
    }

    setState(() {
      _isAnalyzing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Development analysis completed. AI API is not connected yet.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('AI Analysis', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              'Intelligent infrastructure insights',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI Infrastructure Analysis',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Analyze monitoring signals and identify potential risks.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Production API',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text('Analyze current infrastructure metrics'),
                              ],
                            ),
                          ),
                          FilledButton.icon(
                            onPressed: _isAnalyzing ? null : _runAnalysis,
                            icon: _isAnalyzing
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.auto_awesome),
                            label: Text(
                              _isAnalyzing ? 'Analyzing...' : 'Run Analysis',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth >= 850) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: RiskScoreCard(
                                riskScore: _analysis.riskScore,
                                confidenceScore: _analysis.confidenceScore,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 3,
                              child: AiRecommendationCard(
                                recommendations: _analysis.recommendations,
                              ),
                            ),
                          ],
                        );
                      }

                      return Column(
                        children: [
                          RiskScoreCard(
                            riskScore: _analysis.riskScore,
                            confidenceScore: _analysis.confidenceScore,
                          ),
                          const SizedBox(height: 16),
                          AiRecommendationCard(
                            recommendations: _analysis.recommendations,
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AI Summary',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          Text(_analysis.summary),
                          const SizedBox(height: 12),
                          Text(
                            'Generated ${_analysis.generatedAt}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const AnalysisHistoryCard(),

                  const SizedBox(height: 30),

                  Center(
                    child: Text(
                      'Development analysis — AI service not connected',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
