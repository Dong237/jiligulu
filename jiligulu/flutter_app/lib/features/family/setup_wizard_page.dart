import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../shared/widgets/elder_button.dart';
import '../../shared/widgets/elder_text.dart';

/// 4-step setup wizard for children to set up their parents' account.
class SetupWizardPage extends StatefulWidget {
  const SetupWizardPage({super.key});

  @override
  State<SetupWizardPage> createState() => _SetupWizardPageState();
}

class _SetupWizardPageState extends State<SetupWizardPage> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Step 1 fields
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  // Step 2 fields
  final _parentNameController = TextEditingController();
  String _gender = '妈妈';
  String _englishLevel = '零基础';

  // Step 3 fields
  String _learningGoal = '出国旅游';

  // Step 4 — generated token
  final String _setupToken = 'JLG-${DateTime.now().millisecondsSinceEpoch}';

  final List<String> _genderOptions = ['妈妈', '爸爸', '爷爷', '奶奶', '外公', '外婆'];
  final List<String> _levelOptions = ['零基础', '会一点点', '还可以'];
  final List<String> _goalOptions = ['出国旅游', '看懂英文', '跟孙辈聊天', '日常生活', '纯粹好玩'];

  @override
  void dispose() {
    _pageController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _parentNameController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softBackground,
      appBar: AppBar(
        backgroundColor: AppColors.softBackground,
        elevation: 0,
        leading: _currentStep > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back,
                    color: AppColors.darkText, size: 28),
                onPressed: () {
                  setState(() => _currentStep--);
                  _pageController.animateToPage(
                    _currentStep,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              )
            : IconButton(
                icon: const Icon(Icons.close,
                    color: AppColors.darkText, size: 28),
                onPressed: () => Navigator.of(context).pop(),
              ),
      ),
      body: Column(
        children: [
          // Step indicator dots
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSizes.spacingM),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (i) {
                return Container(
                  width: _currentStep == i ? 24 : 10,
                  height: 10,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: _currentStep == i
                        ? AppColors.parrotGreen
                        : AppColors.warmGrey.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(5),
                  ),
                );
              }),
            ),
          ),
          // Pages
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildStep1(),
                _buildStep2(),
                _buildStep3(),
                _buildStep4(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep1() {
    return _StepContainer(
      children: [
        const ElderText('先注册你的账号', style: ElderTextStyle.title),
        const SizedBox(height: AppSizes.spacingXL),
        _buildTextField(
          controller: _phoneController,
          label: '手机号',
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: AppSizes.spacingM),
        _buildTextField(
          controller: _passwordController,
          label: '设一个密码',
          obscure: true,
        ),
        const Spacer(),
        ElderButton(
          label: '下一步',
          onPressed: _nextStep,
        ),
        const SizedBox(height: AppSizes.spacingL),
      ],
    );
  }

  Widget _buildStep2() {
    return _StepContainer(
      children: [
        const ElderText('爸妈叫什么名字？', style: ElderTextStyle.title),
        const SizedBox(height: AppSizes.spacingXL),
        _buildTextField(
          controller: _parentNameController,
          label: '名字或昵称',
        ),
        const SizedBox(height: AppSizes.spacingM),
        const ElderText('称呼', style: ElderTextStyle.caption),
        const SizedBox(height: AppSizes.spacingS),
        Wrap(
          spacing: AppSizes.spacingS,
          runSpacing: AppSizes.spacingS,
          children: _genderOptions.map((option) {
            final selected = _gender == option;
            return _buildChip(option, selected, () {
              setState(() => _gender = option);
            });
          }).toList(),
        ),
        const SizedBox(height: AppSizes.spacingM),
        const ElderText('英语水平', style: ElderTextStyle.caption),
        const SizedBox(height: AppSizes.spacingS),
        Wrap(
          spacing: AppSizes.spacingS,
          runSpacing: AppSizes.spacingS,
          children: _levelOptions.map((option) {
            final selected = _englishLevel == option;
            return _buildChip(option, selected, () {
              setState(() => _englishLevel = option);
            });
          }).toList(),
        ),
        const Spacer(),
        ElderButton(
          label: '下一步',
          onPressed: _nextStep,
        ),
        const SizedBox(height: AppSizes.spacingL),
      ],
    );
  }

  Widget _buildStep3() {
    return _StepContainer(
      children: [
        const ElderText('想学英语做什么？', style: ElderTextStyle.title),
        const SizedBox(height: AppSizes.spacingXL),
        ...(_goalOptions.map((goal) {
          final selected = _learningGoal == goal;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.spacingS),
            child: ElderButton(
              label: goal,
              variant: selected
                  ? ElderButtonVariant.primary
                  : ElderButtonVariant.outline,
              size: ElderButtonSize.standard,
              onPressed: () => setState(() => _learningGoal = goal),
            ),
          );
        })),
        const Spacer(),
        ElderButton(
          label: '下一步',
          onPressed: _nextStep,
        ),
        const SizedBox(height: AppSizes.spacingL),
      ],
    );
  }

  Widget _buildStep4() {
    return _StepContainer(
      children: [
        const ElderText('让爸妈扫一下这个码', style: ElderTextStyle.title),
        const SizedBox(height: AppSizes.spacingXL),
        Center(
          child: Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
              border: Border.all(color: AppColors.warmGrey, width: 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const ElderText('QR CODE', style: ElderTextStyle.subtitle),
                const SizedBox(height: AppSizes.spacingS),
                ElderText(
                  _setupToken,
                  style: ElderTextStyle.caption,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSizes.spacingL),
        const Center(
          child: ElderText(
            '爸妈用手机扫这个二维码就能登录啦',
            style: ElderTextStyle.body,
            textAlign: TextAlign.center,
          ),
        ),
        const Spacer(),
        ElderButton(
          label: '完成',
          onPressed: () => Navigator.of(context).pop(),
        ),
        const SizedBox(height: AppSizes.spacingL),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      style: const TextStyle(
        fontSize: AppSizes.fontBody,
        color: AppColors.darkText,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontSize: AppSizes.fontBody,
          color: AppColors.warmGrey,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall),
          borderSide:
              const BorderSide(color: AppColors.parrotGreen, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spacingM,
          vertical: AppSizes.spacingM,
        ),
      ),
    );
  }

  Widget _buildChip(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: AppSizes.touchTarget),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spacingM,
          vertical: AppSizes.spacingS,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.parrotGreen : AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall),
          border: Border.all(
            color: selected ? AppColors.parrotGreen : AppColors.warmGrey,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: AppSizes.fontBody,
            color: selected ? AppColors.white : AppColors.darkText,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

/// Scrollable step container with consistent padding.
class _StepContainer extends StatelessWidget {
  const _StepContainer({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
