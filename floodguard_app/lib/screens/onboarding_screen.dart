import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../localization/app_strings.dart';
import '../widgets/fade_slide_in.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onFinished;

  const OnboardingScreen({super.key, required this.onFinished});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingSlide {
  final IconData icon;
  final String titleKey;
  final String descKey;
  final Color color;

  const _OnboardingSlide({
    required this.icon,
    required this.titleKey,
    required this.descKey,
    required this.color,
  });
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const List<_OnboardingSlide> _slides = [
    _OnboardingSlide(
      icon: Icons.water_drop,
      titleKey: 'onb_title_1',
      descKey: 'onb_desc_1',
      color: Colors.blue,
    ),
    _OnboardingSlide(
      icon: Icons.map,
      titleKey: 'onb_title_2',
      descKey: 'onb_desc_2',
      color: Colors.orange,
    ),
    _OnboardingSlide(
      icon: Icons.notifications_active,
      titleKey: 'onb_title_3',
      descKey: 'onb_desc_3',
      color: Colors.red,
    ),
    _OnboardingSlide(
      icon: Icons.chat_bubble,
      titleKey: 'onb_title_4',
      descKey: 'onb_desc_4',
      color: Colors.green,
    ),
  ];

  Future<void> _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_seen', true);
    widget.onFinished();
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _slides.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: TextButton(
                  onPressed: _finishOnboarding,
                  child: Text(tr(context, 'onb_skip')),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return Padding(
                    key: ValueKey(index),
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PopIn(
                          child: Container(
                            padding: const EdgeInsets.all(28),
                            decoration: BoxDecoration(
                              color: slide.color.withOpacity(0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(slide.icon, size: 72, color: slide.color),
                          ),
                        ),
                        const SizedBox(height: 32),
                        FadeSlideIn(
                          baseDelay: const Duration(milliseconds: 100),
                          child: Text(
                            tr(context, slide.titleKey),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 12),
                        FadeSlideIn(
                          baseDelay: const Duration(milliseconds: 160),
                          child: Text(
                            tr(context, slide.descKey),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _slides.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 22 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? Colors.blue : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLastPage
                      ? _finishOnboarding
                      : () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
                  child: Text(isLastPage ? tr(context, 'onb_get_started') : tr(context, 'onb_next')),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}