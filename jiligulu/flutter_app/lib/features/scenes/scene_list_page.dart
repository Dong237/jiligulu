import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../shared/widgets/elder_text.dart';
import 'widgets/scene_card.dart';

/// Mock scene data for development.
class _SceneData {
  final String name;
  final List<String> previewPhrases;
  final int difficulty;
  final bool isLocked;
  final bool isCompleted;

  const _SceneData({
    required this.name,
    required this.previewPhrases,
    required this.difficulty,
    this.isLocked = false,
    this.isCompleted = false,
  });
}

const _freeScenes = [
  _SceneData(
    name: '\u6253\u62DB\u547C',
    previewPhrases: ['Hello!', 'Good morning!'],
    difficulty: 1,
    isCompleted: true,
  ),
  _SceneData(
    name: '\u81EA\u6211\u4ECB\u7ECD',
    previewPhrases: ['My name is...', 'Nice to meet you!'],
    difficulty: 1,
  ),
  _SceneData(
    name: '\u95EE\u8DEF',
    previewPhrases: ['Where is...?', 'Turn left'],
    difficulty: 2,
  ),
  _SceneData(
    name: '\u4E70\u4E1C\u897F',
    previewPhrases: ['How much?', 'I want this one'],
    difficulty: 2,
  ),
  _SceneData(
    name: '\u70B9\u83DC',
    previewPhrases: ['I would like...', 'The check, please'],
    difficulty: 2,
    isCompleted: true,
  ),
];

const _dailyScenes = [
  _SceneData(
    name: '\u770B\u533B\u751F',
    previewPhrases: ['I have a headache', 'Where is the pharmacy?'],
    difficulty: 3,
    isLocked: true,
  ),
  _SceneData(
    name: '\u5750\u516C\u4EA4',
    previewPhrases: ['Which bus goes to...?', 'Next stop'],
    difficulty: 3,
    isLocked: true,
  ),
  _SceneData(
    name: '\u6253\u7535\u8BDD',
    previewPhrases: ['May I speak to...?', 'Hold on, please'],
    difficulty: 3,
    isLocked: true,
  ),
  _SceneData(
    name: '\u5929\u6C14\u804A\u5929',
    previewPhrases: ['How is the weather?', 'It is sunny today'],
    difficulty: 2,
    isLocked: true,
  ),
  _SceneData(
    name: '\u9080\u8BF7\u670B\u53CB',
    previewPhrases: ['Are you free tomorrow?', 'Let us have tea'],
    difficulty: 4,
    isLocked: true,
  ),
];

/// Scene selection page.
class SceneListPage extends StatelessWidget {
  const SceneListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softBackground,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spacingL,
            vertical: AppSizes.spacingL,
          ),
          children: [
            const ElderText(
              '\u9009\u4E2A\u573A\u666F\u804A\u804A\u5427',
              style: ElderTextStyle.title,
            ),
            const SizedBox(height: AppSizes.spacingXL),

            // Free scenes section
            const ElderText(
              '\u5165\u95E8\u573A\u666F',
              style: ElderTextStyle.subtitle,
            ),
            const SizedBox(height: AppSizes.spacingM),
            ..._freeScenes.map((scene) => Padding(
                  padding:
                      const EdgeInsets.only(bottom: AppSizes.spacingM),
                  child: SceneCard(
                    name: scene.name,
                    previewPhrases: scene.previewPhrases,
                    difficulty: scene.difficulty,
                    isLocked: scene.isLocked,
                    isCompleted: scene.isCompleted,
                    onTap: () {
                      // TODO: Navigate to voice chat with scene context
                    },
                  ),
                )),

            const SizedBox(height: AppSizes.spacingL),

            // Daily scenes section
            const ElderText(
              '\u65E5\u5E38\u573A\u666F',
              style: ElderTextStyle.subtitle,
            ),
            const SizedBox(height: AppSizes.spacingM),
            ..._dailyScenes.map((scene) => Padding(
                  padding:
                      const EdgeInsets.only(bottom: AppSizes.spacingM),
                  child: SceneCard(
                    name: scene.name,
                    previewPhrases: scene.previewPhrases,
                    difficulty: scene.difficulty,
                    isLocked: scene.isLocked,
                    isCompleted: scene.isCompleted,
                    onTap: scene.isLocked
                        ? null
                        : () {
                            // TODO: Navigate to voice chat with scene context
                          },
                  ),
                )),

            const SizedBox(height: AppSizes.spacingXL),
          ],
        ),
      ),
    );
  }
}
