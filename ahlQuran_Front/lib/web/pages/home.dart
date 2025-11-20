import 'package:flutter/material.dart';
import '../widgets/ContactForm.dart';
import '../../system/widgets/footer.dart';
import '../widgets/partners_section.dart';
import '../widgets/SubscriptionSection.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/helpers/nav.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/helpers/custom_drawer.dart';
import '../widgets/custom_app_section.dart';
import '../widgets/features_section.dart';
import '../widgets/image3scrol.dart';
import '../widgets/mobile_showcase.dart';
import '../widgets/nutif_form.dart';
import '../widgets/pricing_section.dart';
import '../widgets/section3.dart';
import '../widgets/additional_services_section.dart';
import '../widgets/users_section.dart';
import '../widgets/image_carousel.dart';
import '../widgets/stats_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  bool _isImageHovered = false;
  bool _isButtonHovered = false;
  bool showNavbarBackground = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll); // event scroll added
  }

  void _handleScroll() {
    if (_scrollController.offset > 250 && !showNavbarBackground) {
      setState(() => showNavbarBackground = true);
    } else if (_scrollController.offset <= 250 && showNavbarBackground) {
      setState(() => showNavbarBackground = false);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // build in

    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(),
      body: Scrollbar(
        thumbVisibility: true,
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              // Fullscreen Header
              Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary,
                  image: DecorationImage(
                    image: AssetImage('assets/back.png'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.white.withValues(alpha: 0.2),
                      BlendMode.dstIn,
                    ),
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 60),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      child: NavBar(
                        scaffoldKey: _scaffoldKey,
                        showBackground: showNavbarBackground,
                      ),
                    ),
                    const SizedBox(height: 20),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isLargeScreen = constraints.maxWidth > 800;
                        return isLargeScreen
                            ? _buildLargeScreenHeader(theme)
                            : _buildSmallScreenHeader(theme);
                      },
                    ),
                  ],
                ),
              ),

              // Rest of the page
              SizedBox(height: 80),
              FeaturesSection(),
              SizedBox(height: 50),
              UsersSection(),
              SizedBox(height: 50),
              Section3(),
              SizedBox(height: 50),
              ImageCarousel(),
              SizedBox(height: 50),
              MobileShowcase(),
              SizedBox(height: 50),
              PricingSection(),
              AdditionalServicesSection(),
              CustomAppPricingSection(),
              StatsSection(),
              ImageCarousel3(),
              PartnersSection(),
              SubscriptionSection(),
              ContactForm(),
              NutifForm(),
              FooterSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLargeScreenHeader(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: MouseRegion(
            onEnter: (_) => setState(() => _isImageHovered = true),
            onExit: (_) => setState(() => _isImageHovered = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              transform: _isImageHovered
                  ? Matrix4.translationValues(0, -10, 0)
                  : Matrix4.identity(),
              child: Image.asset(
                'assets/home.png',
                fit: BoxFit.contain,
                height: 350,
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(child: _buildHeaderText(theme)),
      ],
    );
  }

  Widget _buildSmallScreenHeader(ThemeData theme) {
    return Column(
      children: [
        _buildHeaderText(theme),
        const SizedBox(height: 40),
        MouseRegion(
          onEnter: (_) => setState(() => _isImageHovered = true),
          onExit: (_) => setState(() => _isImageHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            transform: _isImageHovered
                ? Matrix4.translationValues(0, -10, 0)
                : Matrix4.identity(),
            child: Image.asset(
              'assets/men.png',
              fit: BoxFit.contain,
              height: 250,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderText(ThemeData theme) {
    return Column(
      children: [
        Text(
          'نظام أهل القرآن',
          style: theme.textTheme.displayLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 52,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          'تسيير وتيسير التعليم القرآني',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 32,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Text(
          '.نظام أهل القرآن هو نظام سحابي متكامل .. يمكن بواسطته إنشاء بيئة رقمية',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          ' تربط بين مشرفي الحلقات ومدرسيها وطلابها وأولياء الأمور ، وذلك بمنحهم الأدوات الحديثة للارتقاء بحلقات القرآن',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 25),
        MouseRegion(
          onEnter: (_) => setState(() => _isButtonHovered = true),
          onExit: (_) => setState(() => _isButtonHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color:
                  _isButtonHovered ? theme.colorScheme.secondary : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.colorScheme.secondary,
                width: 2,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
            child: Text(
              'طلب نسخة',
              style: theme.textTheme.labelLarge?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _isButtonHovered
                    ? Colors.white
                    : theme.colorScheme.secondary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
