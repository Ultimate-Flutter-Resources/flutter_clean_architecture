import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

GlobalKey snackBar = GlobalKey();
GlobalKey inc = GlobalKey();

void main() {
  testWidgets('Controller can change data and refresh View',
      (WidgetTester tester) async {
    final AutomatedTestWidgetsFlutterBinding binding = tester.binding;
    binding.addTime(const Duration(seconds: 3));
    await tester.pumpWidget(CounterPage());

    // Create our Finders
    Finder counterFinder = find.text('0');
    expect(counterFinder, findsOneWidget);

    await tester.tap(find.byKey(inc));
    await tester.pump();

    expect(counterFinder, findsNothing);
    counterFinder = find.text('1');
    expect(counterFinder, findsOneWidget);

    await tester.tap(find.byKey(inc));
    await tester.pump();

    expect(counterFinder, findsNothing);
    counterFinder = find.text('2');
    expect(counterFinder, findsOneWidget);

    await tester.tap(find.byKey(snackBar));
    await tester.pump();
    expect(find.text('Hi'), findsOneWidget);
  });
}

class CounterController extends Controller {
  int counter;
  CounterController() : counter = 0;

  void increment() {
    counter++;
    refreshUI();
  }

  void showSnackBar() {
    ScaffoldState scaffoldState = getState();
    scaffoldState.showSnackBar(SnackBar(content: Text('Hi')));
  }

  @override
  void initListeners() {
    // No presenter needed for controller test
  }
}

class CounterPage extends View {
  @override
  State<StatefulWidget> createState() => CounterState();
}

class CounterState extends ViewState<CounterPage, CounterController> {
  CounterState() : super(CounterController());

  @override
  Widget buildPage() {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        key: globalKey,
        body: Column(
          children: <Widget>[
            Center(
              child: Text(controller.counter.toString()),
            ),
            MaterialButton(key: inc, onPressed: () => controller.increment()),
            MaterialButton(
                key: snackBar, onPressed: () => controller.showSnackBar()),
          ],
        ),
      ),
    );
  }
}
