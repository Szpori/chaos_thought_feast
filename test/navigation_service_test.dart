import 'package:chaos_thought_feast/services/fire_db_auth_service.dart';
import 'package:chaos_thought_feast/services/fire_db_service.dart';
import 'package:chaos_thought_feast/services/language_notifier.dart';
import 'package:chaos_thought_feast/services/navigation_service.dart';
import 'package:chaos_thought_feast/domain/entities/game_mode.dart';
import 'package:chaos_thought_feast/domain/entities/game_record.dart';
import 'package:chaos_thought_feast/presentation/screens/game_lose_screen.dart';
import 'package:chaos_thought_feast/presentation/screens/game_screen.dart';
import 'package:chaos_thought_feast/presentation/screens/game_setup_screen.dart';
import 'package:chaos_thought_feast/presentation/screens/game_win_screen.dart';
import 'package:chaos_thought_feast/presentation/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

class MockFireDBService extends Mock implements IFireDBService {}
class MockFirebaseAuthService extends Mock implements IFirebaseAuthService {}
class MockLanguageNotifier extends Mock implements LanguageNotifier {}

class FakeGameRecord extends Fake implements GameRecord {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late NavigationService navigationService;
  late MockFireDBService mockFireDBService;
  late MockFirebaseAuthService mockFirebaseAuthService;
  late MockLanguageNotifier mockLanguageNotifier;
  final getIt = GetIt.instance;

  setUpAll(() async {
    registerFallbackValue(FakeGameRecord());
  });

  setUp(() async {
    mockFireDBService = MockFireDBService();
    mockFirebaseAuthService = MockFirebaseAuthService();
    mockLanguageNotifier = MockLanguageNotifier();
    navigationService = NavigationService(
      fireDBService: mockFireDBService,
      firebaseAuthService: mockFirebaseAuthService,
      languageNotifier: mockLanguageNotifier,
    );

    // Create a mock user
    final mockUser = MockUser(
      isAnonymous: false,
      uid: 'someuid',
      email: 'test@example.com',
    );

    // Mock the auth instance and current user
    final auth = MockFirebaseAuth(mockUser: mockUser);
    when(() => mockFirebaseAuthService.getCurrentUser()).thenReturn(mockUser);
    when(() => mockLanguageNotifier.currentLanguageCode).thenReturn('en');

    // Register the mocks in GetIt
    getIt.registerSingleton<LanguageNotifier>(mockLanguageNotifier);
  });

  tearDown(() {
    getIt.reset(); // Reset GetIt after each test to avoid conflicts
  });

  group('NavigationService', () {
    testWidgets('should navigate to GameSetupScreen', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigationService.navigatorKey,
          home: Builder(
            builder: (context) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                navigationService.setCurrentGameMode(GameMode.findYourLikings);
                navigationService.navigateToGameSetup(context);
              });
              return Container();
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(GameSetupScreen), findsOneWidget);
    });

    testWidgets('should navigate to GameScreen', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigationService.navigatorKey,
          home: Builder(
            builder: (context) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                navigationService.navigateToGame(context, GameMode.anyfinCanHappen, 'Start Concept', 'Goal Concept');
              });
              return Container();
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(GameScreen), findsOneWidget);
    });

    testWidgets('should navigate to GameWinScreen on win', (WidgetTester tester) async {
      when(() => mockFireDBService.saveGameRecord(any())).thenAnswer((_) async => SaveRecordResult.newRecord);

      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigationService.navigatorKey,
          home: Builder(
            builder: (context) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                navigationService.navigateToEndGame(context, true, 'Start Concept', 'Goal Concept', ['Start Concept', 'Goal Concept'], GameMode.likingSpectrumJourney, 2);
              });
              return Container();
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(GameWinScreen), findsOneWidget);
    });

    testWidgets('should navigate to GameLoseScreen on lose', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigationService.navigatorKey,
          home: Builder(
            builder: (context) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                navigationService.navigateToEndGame(context, false, 'Start Concept', 'Goal Concept', ['Start Concept', 'Goal Concept'], GameMode.likingSpectrumJourney, 2);
              });
              return Container();
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(GameLoseScreen), findsOneWidget);
    });

    testWidgets('should navigate to ProfileScreen', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigationService.navigatorKey,
          home: Builder(
            builder: (context) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                navigationService.navigateToProfile(context);
              });
              return Container();
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(ProfileScreen), findsOneWidget);
    });
  });
}