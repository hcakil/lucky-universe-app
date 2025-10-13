import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lucky Universe',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  final List<Widget> _screens = [
    const LuckyNumbersScreen(),
    const LuckyColorsScreen(),
    const HoroscopeScreen(),
    const LuckyQuotesScreen(),
    const HistoryScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _screens[_currentIndex],
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: 1.57, // Downward
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.purple,
                Colors.blue,
                Colors.green,
                Colors.yellow,
                Colors.orange,
                Colors.red,
                Colors.pink,
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.casino),
            selectedIcon: Icon(Icons.casino),
            label: 'Numbers',
          ),
          NavigationDestination(
            icon: Icon(Icons.palette),
            selectedIcon: Icon(Icons.palette),
            label: 'Colors',
          ),
          NavigationDestination(
            icon: Icon(Icons.star),
            selectedIcon: Icon(Icons.star),
            label: 'Horoscope',
          ),
          NavigationDestination(
            icon: Icon(Icons.format_quote),
            selectedIcon: Icon(Icons.format_quote),
            label: 'Quotes',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            selectedIcon: Icon(Icons.history),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class LuckyNumbersScreen extends StatefulWidget {
  const LuckyNumbersScreen({super.key});

  @override
  State<LuckyNumbersScreen> createState() => _LuckyNumbersScreenState();
}

class _LuckyNumbersScreenState extends State<LuckyNumbersScreen> with TickerProviderStateMixin {
  int _luckyNumber = 0;
  int _previousNumber = 0;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _generateLuckyNumber() async {
    setState(() {
      _previousNumber = _luckyNumber;
      _luckyNumber = Random().nextInt(100) + 1;
    });

    _animationController.reset();
    _animationController.forward();
    _confettiController.play();

    // Save to history
    await _saveToHistory('Lucky Number: $_luckyNumber');
  }

  Future<void> _saveToHistory(String entry) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('history') ?? [];
    final timestamp = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
    history.insert(0, '$timestamp - $entry');
    if (history.length > 100) history.removeLast();
    await prefs.setStringList('history', history);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lucky Numbers'),
        backgroundColor: theme.colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('About Lucky Numbers'),
                  content: const Text(
                    'Generate your daily lucky number between 1-100. '
                    'Use this number for lottery tickets, important decisions, '
                    'or just for fun!',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.purple.shade100,
                  Colors.blue.shade100,
                  Colors.green.shade100,
                ],
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.purple.shade300,
                              Colors.purple.shade600,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purple.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            '$_luckyNumber',
                            style: theme.textTheme.headlineLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 48,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30),
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Your Lucky Number',
                      textStyle: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.purple.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                      speed: const Duration(milliseconds: 100),
                    ),
                  ],
                  totalRepeatCount: 1,
                ),
                const SizedBox(height: 20),
                if (_previousNumber != 0)
                  Text(
                    'Previous: $_previousNumber',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  onPressed: _generateLuckyNumber,
                  icon: const Icon(Icons.casino),
                  label: const Text('Generate New Number'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: 1.57,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.purple,
                Colors.blue,
                Colors.green,
                Colors.yellow,
                Colors.orange,
                Colors.red,
                Colors.pink,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LuckyColorsScreen extends StatefulWidget {
  const LuckyColorsScreen({super.key});

  @override
  State<LuckyColorsScreen> createState() => _LuckyColorsScreenState();
}

class _LuckyColorsScreenState extends State<LuckyColorsScreen> with TickerProviderStateMixin {
  Color _luckyColor = Colors.purple;
  Color _previousColor = Colors.purple;
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  late ConfettiController _confettiController;

  final List<Color> _colorPalette = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _generateLuckyColor() async {
    setState(() {
      _previousColor = _luckyColor;
      _luckyColor = _colorPalette[Random().nextInt(_colorPalette.length)];
    });

    _animationController.reset();
    _animationController.forward();
    _confettiController.play();

    // Save to history
    await _saveToHistory('Lucky Color: ${_getColorName(_luckyColor)}');
  }

  String _getColorName(Color color) {
    if (color == Colors.red) return 'Red';
    if (color == Colors.pink) return 'Pink';
    if (color == Colors.purple) return 'Purple';
    if (color == Colors.deepPurple) return 'Deep Purple';
    if (color == Colors.indigo) return 'Indigo';
    if (color == Colors.blue) return 'Blue';
    if (color == Colors.lightBlue) return 'Light Blue';
    if (color == Colors.cyan) return 'Cyan';
    if (color == Colors.teal) return 'Teal';
    if (color == Colors.green) return 'Green';
    if (color == Colors.lightGreen) return 'Light Green';
    if (color == Colors.lime) return 'Lime';
    if (color == Colors.yellow) return 'Yellow';
    if (color == Colors.amber) return 'Amber';
    if (color == Colors.orange) return 'Orange';
    if (color == Colors.deepOrange) return 'Deep Orange';
    return 'Unknown';
  }

  Future<void> _saveToHistory(String entry) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('history') ?? [];
    final timestamp = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
    history.insert(0, '$timestamp - $entry');
    if (history.length > 100) history.removeLast();
    await prefs.setStringList('history', history);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lucky Colors'),
        backgroundColor: theme.colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('About Lucky Colors'),
                  content: const Text(
                    'Discover your lucky color for the day! '
                    'Colors can influence your mood, energy, and luck. '
                    'Use this color in your clothing, accessories, or surroundings.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _luckyColor.withOpacity(0.1),
                  _luckyColor.withOpacity(0.3),
                  _luckyColor.withOpacity(0.1),
                ],
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _rotationAnimation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotationAnimation.value * 2 * 3.14159,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              _luckyColor,
                              _luckyColor.withOpacity(0.7),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: _luckyColor.withOpacity(0.5),
                              blurRadius: 30,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            Icons.palette,
                            size: 80,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30),
                Text(
                  _getColorName(_luckyColor),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: _luckyColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                if (_previousColor != _luckyColor)
                  Text(
                    'Previous: ${_getColorName(_previousColor)}',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  onPressed: _generateLuckyColor,
                  icon: const Icon(Icons.palette),
                  label: const Text('Generate New Color'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _luckyColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: 1.57,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.purple,
                Colors.blue,
                Colors.green,
                Colors.yellow,
                Colors.orange,
                Colors.red,
                Colors.pink,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HoroscopeScreen extends StatefulWidget {
  const HoroscopeScreen({super.key});

  @override
  State<HoroscopeScreen> createState() => _HoroscopeScreenState();
}

class _HoroscopeScreenState extends State<HoroscopeScreen> {
  String _currentSign = 'Aries';
  String _currentHoroscope = '';
  late ConfettiController _confettiController;

  final List<String> _zodiacSigns = [
    'Aries',
    'Taurus',
    'Gemini',
    'Cancer',
    'Leo',
    'Virgo',
    'Libra',
    'Scorpio',
    'Sagittarius',
    'Capricorn',
    'Aquarius',
    'Pisces'
  ];

  final Map<String, List<String>> _horoscopes = {
    'Aries': [
      'Today is a day for bold action! Your energy is high and opportunities await.',
      'Trust your instincts today. Your natural leadership will guide you to success.',
      'A new beginning is on the horizon. Embrace change with confidence.',
    ],
    'Taurus': [
      'Focus on stability and comfort today. Your practical approach will pay off.',
      'Take time to appreciate the beauty around you. It will inspire your creativity.',
      'Your determination will help you overcome any obstacles that come your way.',
    ],
    'Gemini': [
      'Communication is key today. Your words have the power to inspire others.',
      'Embrace your curiosity and explore new ideas. Learning will bring you joy.',
      'Your adaptability is your greatest strength. Use it to navigate any situation.',
    ],
    'Cancer': [
      'Trust your emotions today. They are guiding you in the right direction.',
      'Nurture your relationships. Your caring nature will strengthen bonds.',
      'Home and family matters will bring you the most satisfaction today.',
    ],
    'Leo': [
      'Your natural charisma will shine today. Others will be drawn to your energy.',
      'Take center stage and share your talents. The world needs your light.',
      'Confidence is your superpower. Use it to achieve your goals.',
    ],
    'Virgo': [
      'Attention to detail will serve you well today. Your precision matters.',
      'Help others with your practical wisdom. Your service will be appreciated.',
      'Organize your thoughts and plans. Structure will bring you peace.',
    ],
    'Libra': [
      'Seek balance in all things today. Harmony will bring you happiness.',
      'Your diplomatic skills will help resolve conflicts around you.',
      'Beauty and aesthetics will inspire you. Surround yourself with lovely things.',
    ],
    'Scorpio': [
      'Trust your intuition today. It will reveal hidden truths.',
      'Transform challenges into opportunities. Your resilience is unmatched.',
      'Deep connections with others will bring you fulfillment.',
    ],
    'Sagittarius': [
      'Adventure calls to you today. Embrace new experiences with enthusiasm.',
      'Your optimism will inspire others. Share your positive outlook.',
      'Learning something new will expand your horizons.',
    ],
    'Capricorn': [
      'Your hard work will pay off today. Success is within your reach.',
      'Take responsibility for your goals. Your discipline will lead to achievement.',
      'Patience and persistence are your allies. Trust the process.',
    ],
    'Aquarius': [
      'Innovation and originality are your strengths today. Think outside the box.',
      'Your humanitarian spirit will guide you to help others.',
      'Embrace your uniqueness. It\'s what makes you special.',
    ],
    'Pisces': [
      'Your compassion will touch others today. Let your heart guide you.',
      'Creativity flows through you. Express yourself through art or music.',
      'Trust your dreams and intuition. They hold important messages.',
    ],
  };

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _generateHoroscope();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _generateHoroscope() async {
    setState(() {
      _currentSign = _zodiacSigns[Random().nextInt(_zodiacSigns.length)];
      final horoscopes = _horoscopes[_currentSign]!;
      _currentHoroscope = horoscopes[Random().nextInt(horoscopes.length)];
    });

    _confettiController.play();

    // Save to history
    await _saveToHistory('Horoscope for $_currentSign: $_currentHoroscope');
  }

  Future<void> _saveToHistory(String entry) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('history') ?? [];
    final timestamp = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
    history.insert(0, '$timestamp - $entry');
    if (history.length > 100) history.removeLast();
    await prefs.setStringList('history', history);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Horoscope'),
        backgroundColor: theme.colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('About Horoscopes'),
                  content: const Text(
                    'Discover your daily horoscope based on your zodiac sign. '
                    'These insights can guide your day and help you make better decisions. '
                    'Remember, horoscopes are for entertainment and inspiration!',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.purple.shade100,
                  Colors.blue.shade100,
                  Colors.indigo.shade100,
                ],
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.star,
                          size: 60,
                          color: Colors.amber,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _currentSign,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: Colors.purple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _currentHoroscope,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.grey.shade700,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton.icon(
                    onPressed: _generateHoroscope,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Get New Horoscope'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: 1.57,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.purple,
                Colors.blue,
                Colors.green,
                Colors.yellow,
                Colors.orange,
                Colors.red,
                Colors.pink,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LuckyQuotesScreen extends StatefulWidget {
  const LuckyQuotesScreen({super.key});

  @override
  State<LuckyQuotesScreen> createState() => _LuckyQuotesScreenState();
}

class _LuckyQuotesScreenState extends State<LuckyQuotesScreen> {
  String _currentQuote = '';
  String _currentAuthor = '';
  late ConfettiController _confettiController;

  final List<Map<String, String>> _quotes = [
    {'quote': 'The only way to do great work is to love what you do.', 'author': 'Steve Jobs'},
    {
      'quote': 'Success is not final, failure is not fatal: it is the courage to continue that counts.',
      'author': 'Winston Churchill'
    },
    {'quote': 'The future belongs to those who believe in the beauty of their dreams.', 'author': 'Eleanor Roosevelt'},
    {'quote': 'It is during our darkest moments that we must focus to see the light.', 'author': 'Aristotle'},
    {'quote': 'The way to get started is to quit talking and begin doing.', 'author': 'Walt Disney'},
    {
      'quote': 'Don\'t be pushed around by the fears in your mind. Be led by the dreams in your heart.',
      'author': 'Roy T. Bennett'
    },
    {'quote': 'Believe you can and you\'re halfway there.', 'author': 'Theodore Roosevelt'},
    {'quote': 'The only impossible journey is the one you never begin.', 'author': 'Tony Robbins'},
    {'quote': 'In the middle of difficulty lies opportunity.', 'author': 'Albert Einstein'},
    {'quote': 'Success is walking from failure to failure with no loss of enthusiasm.', 'author': 'Winston Churchill'},
  ];

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _generateQuote();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _generateQuote() async {
    setState(() {
      final randomQuote = _quotes[Random().nextInt(_quotes.length)];
      _currentQuote = randomQuote['quote']!;
      _currentAuthor = randomQuote['author']!;
    });

    _confettiController.play();

    // Save to history
    await _saveToHistory('Quote: "$_currentQuote" - $_currentAuthor');
  }

  Future<void> _saveToHistory(String entry) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('history') ?? [];
    final timestamp = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
    history.insert(0, '$timestamp - $entry');
    if (history.length > 100) history.removeLast();
    await prefs.setStringList('history', history);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lucky Quotes'),
        backgroundColor: theme.colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('About Lucky Quotes'),
                  content: const Text(
                    'Get inspired with daily motivational quotes from famous personalities. '
                    'These words of wisdom can provide guidance, motivation, and positive energy for your day.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.orange.shade100,
                  Colors.red.shade100,
                  Colors.pink.shade100,
                ],
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.format_quote,
                          size: 60,
                          color: Colors.orange,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _currentQuote,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.grey.shade700,
                            height: 1.5,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          '— $_currentAuthor',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton.icon(
                    onPressed: _generateQuote,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Get New Quote'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: 1.57,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.purple,
                Colors.blue,
                Colors.green,
                Colors.yellow,
                Colors.orange,
                Colors.red,
                Colors.pink,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<String> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _history = prefs.getStringList('history') ?? [];
    });
  }

  Future<void> _clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('history');
    setState(() {
      _history = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        backgroundColor: theme.colorScheme.inversePrimary,
        actions: [
          if (_history.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_all),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Clear History'),
                    content: const Text('Are you sure you want to clear all history?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _clearHistory();
                        },
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.green.shade100,
              Colors.blue.shade100,
              Colors.purple.shade100,
            ],
          ),
        ),
        child: _history.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.history,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'No history yet',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Start generating lucky numbers, colors, and more!',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.grey.shade500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _history.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.purple.shade100,
                        child: const Icon(
                          Icons.star,
                          color: Colors.purple,
                        ),
                      ),
                      title: Text(
                        _history[index].split(' - ').last,
                        style: theme.textTheme.bodyMedium,
                      ),
                      subtitle: Text(
                        _history[index].split(' - ').first,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Commented out non-functional settings
  // bool _notificationsEnabled = true;
  // bool _soundEnabled = true;
  String _selectedTheme = 'Purple';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // _notificationsEnabled = prefs.getBool('notifications') ?? true;
      // _soundEnabled = prefs.getBool('sound') ?? true;
      _selectedTheme = prefs.getString('theme') ?? 'Purple';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    // await prefs.setBool('notifications', _notificationsEnabled);
    // await prefs.setBool('sound', _soundEnabled);
    await prefs.setString('theme', _selectedTheme);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: theme.colorScheme.inversePrimary,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.indigo.shade100,
              Colors.purple.shade100,
              Colors.pink.shade100,
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Commented out non-functional settings
            // Card(
            //   child: ListTile(
            //     leading: Icon(Icons.notifications, color: Colors.blue),
            //     title: const Text('Notifications'),
            //     subtitle: const Text('Enable daily lucky updates'),
            //     trailing: Switch(
            //       value: _notificationsEnabled,
            //       onChanged: (value) {
            //         setState(() {
            //           _notificationsEnabled = value;
            //         });
            //         _saveSettings();
            //       },
            //     ),
            //   ),
            // ),
            // Card(
            //   child: ListTile(
            //     leading: Icon(Icons.volume_up, color: Colors.green),
            //     title: const Text('Sound Effects'),
            //     subtitle: const Text('Play sounds when generating'),
            //     trailing: Switch(
            //       value: _soundEnabled,
            //       onChanged: (value) {
            //         setState(() {
            //           _soundEnabled = value;
            //         });
            //         _saveSettings();
            //       },
            //     ),
            //   ),
            // ),
            Card(
              child: ListTile(
                leading: Icon(Icons.palette, color: Colors.purple),
                title: const Text('Theme Color'),
                subtitle: Text('Current: $_selectedTheme'),
                trailing: DropdownButton<String>(
                  value: _selectedTheme,
                  onChanged: (value) {
                    setState(() {
                      _selectedTheme = value!;
                    });
                    _saveSettings();
                  },
                  items: ['Purple', 'Blue', 'Green', 'Orange', 'Red'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.info, color: Colors.amber),
                title: const Text('About'),
                subtitle: const Text('Lucky Universe v1.0.1'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('About Lucky Universe'),
                      content: const Text(
                        'Lucky Universe is your daily companion for discovering luck, '
                        'inspiration, and positive energy. Generate lucky numbers, colors, '
                        'horoscopes, and motivational quotes to brighten your day!\n\n'
                        'Version: 1.0.1\n'
                        'Made with ❤️ for spreading positivity!',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
