import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../shared/widgets/elder_button.dart';
import '../../shared/widgets/elder_text.dart';
import 'widgets/review_card.dart';

/// Mock review data for development.
const _mockPhrases = [
  PhraseData(
    english: 'Good morning',
    phoneticIPA: '/\u0261\u028Ad \u02C8m\u0254\u02D0rn\u026A\u014B/',
    phoneticChinese: '\u53E4\u5FB7 \u83AB\u5B81',
    chinese: '\u65E9\u4E0A\u597D',
  ),
  PhraseData(
    english: 'Thank you',
    phoneticIPA: '/\u03B8\u00E6\u014Bk ju\u02D0/',
    phoneticChinese: '\u4ED6\u514B\u5C24',
    chinese: '\u8C22\u8C22',
  ),
  PhraseData(
    english: 'See you later',
    phoneticIPA: '/si\u02D0 ju\u02D0 \u02C8le\u026At\u0259r/',
    phoneticChinese: '\u89C1\u5C24 \u83B1\u7279',
    chinese: '\u56DE\u5934\u89C1',
  ),
];

const _mockScenes = ['\u6253\u62DB\u547C', '\u6253\u62DB\u547C', '\u81EA\u6211\u4ECB\u7ECD'];
const _mockDates = ['2026-03-05', '2026-03-05', '2026-03-04'];

/// Swipeable review cards page.
class ReviewCardsPage extends StatefulWidget {
  const ReviewCardsPage({super.key});

  @override
  State<ReviewCardsPage> createState() => _ReviewCardsPageState();
}

class _ReviewCardsPageState extends State<ReviewCardsPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softBackground,
      appBar: AppBar(
        backgroundColor: AppColors.softBackground,
        elevation: 0,
        title: const ElderText(
          '\u590D\u4E60\u5361\u7247',
          style: ElderTextStyle.subtitle,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Page indicator
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppSizes.spacingM,
              ),
              child: ElderText(
                '${_currentPage + 1} / ${_mockPhrases.length}',
                style: ElderTextStyle.caption,
              ),
            ),

            // Swipeable cards
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _mockPhrases.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  return Center(
                    child: ReviewCard(
                      phrase: _mockPhrases[index],
                      sceneName: _mockScenes[index],
                      learnedDate: _mockDates[index],
                      onPlayAudio: () {
                        // TODO: Play audio
                      },
                    ),
                  );
                },
              ),
            ),

            // Share button (placeholder for Phase 6)
            Padding(
              padding: const EdgeInsets.all(AppSizes.spacingL),
              child: ElderButton(
                label: '\u5206\u4EAB\u5230\u5FAE\u4FE1',
                variant: ElderButtonVariant.secondary,
                size: ElderButtonSize.standard,
                icon: Icons.share_rounded,
                onPressed: () {
                  // TODO: Phase 6 — WeChat sharing
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
