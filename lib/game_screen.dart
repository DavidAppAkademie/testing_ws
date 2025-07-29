import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testing_ws/funcs.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static const int _gameDuration = 15;

  bool _gameActive = false;
  int _timeLeft = _gameDuration;
  int _hits = 0;
  int _attempts = 0;
  double _targetX = 100;
  double _targetY = 100;
  Timer? _gameTimer;
  final Random _random = Random();
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  void _startGame() {
    setState(() {
      _gameActive = true;
      _timeLeft = _gameDuration;
      _hits = 0;
      _attempts = 0;
    });

    _spawnNewTarget();

    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeLeft--;
      });

      if (_timeLeft <= 0) {
        _endGame();
      }
    });
  }

  void _spawnNewTarget() {
    final size = MediaQuery.of(context).size;
    const targetSize = 60.0;
    const margin = 50.0;

    setState(() {
      _targetX = margin + _random.nextDouble() * (size.width - targetSize - 2 * margin);
      _targetY = margin + _random.nextDouble() * (size.height - targetSize - 2 * margin);
    });
  }

  void _onTargetTap() {
    if (!_gameActive) return;

    setState(() {
      _hits++;
      _attempts++;
    });

    _spawnNewTarget();
  }

  void _onMiss() {
    if (!_gameActive) return;

    setState(() {
      _attempts++;
    });
  }

  void _endGame() {
    _gameTimer?.cancel();
    setState(() {
      _gameActive = false;
    });
  }

  void _resetStats() {
    setState(() {
      _timeLeft = _gameDuration;
      _hits = 0;
      _attempts = 0;
    });
    _spawnNewTarget();
  }

  void _resetGame() {
    _gameTimer?.cancel();
    setState(() {
      _gameActive = false;
      _timeLeft = _gameDuration;
      _hits = 0;
      _attempts = 0;
    });
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.enter && !_gameActive) {
            if (_timeLeft == _gameDuration) {
              _startGame();
            } else {
              _resetGame();
            }
          } else if (event.logicalKey == LogicalKeyboardKey.space && _gameActive) {
            _resetStats();
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          title: Text('Davids Aim Game'),
          actions: [
            if (_gameActive)
              IconButton(
                onPressed: _resetGame,
                icon: const Icon(Icons.refresh),
              ),
          ],
        ),
        body: GestureDetector(
          onTap: _onMiss,
          behavior: HitTestBehavior.translucent,
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: _buildGameContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildGameContent() {
    if (!_gameActive) {
      // Check if game has ended (timeLeft = 0) or not started yet
      if (_timeLeft <= 0) {
        // Game ended
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Spiel beendet!',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              Text(
                'Treffer: $_hits',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                'Versuche: $_attempts',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                'Punkte: ${calculateScore(_hits, calculateHitRate(_hits, _attempts))}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                'Trefferquote: ${calculateHitRate(_hits, _attempts).toStringAsFixed(1)}%',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                'Rang: ${getRankTitle(calculateScore(_hits, calculateHitRate(_hits, _attempts)))}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _resetGame,
                child: const Text('Neues Spiel'),
              ),
              const SizedBox(height: 12),
              Text(
                'Drücke Enter für neues Spiel',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        );
      } else {
        // Start screen
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Aim Game',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              Text(
                'Klicke auf die erscheinenden Boxen!\n$_gameDuration Sekunden Zeit.',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _startGame,
                child: const Text('Start'),
              ),
              const SizedBox(height: 12),
              Text(
                'Drücke Enter zum Starten',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        );
      }
    }

    // Active game
    return Stack(
      children: [
        // Game stats
        Positioned(
          top: 20,
          left: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Zeit: $_timeLeft s',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                'Treffer: $_hits',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                'Versuche: $_attempts',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
        // Space hint
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              'Space: Restart',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
        ),
        // Target
        Positioned(
          left: _targetX,
          top: _targetY,
          child: GestureDetector(
            onTap: _onTargetTap,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.onPrimary,
                  width: 2,
                ),
                image: const DecorationImage(
                  image: AssetImage('assets/dav.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
