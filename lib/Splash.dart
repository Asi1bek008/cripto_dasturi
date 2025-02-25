import 'package:cripto_dasturi/Cripto_page.dart';
import 'package:flutter/material.dart';
import 'package:slide_to_act/slide_to_act.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash>with SingleTickerProviderStateMixin {
  late AnimationController _container;
  late Animation<Size> _myAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _container =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    _myAnimation = Tween<Size>(begin: Size(100, 100), end: Size(300, 300))
        .animate(
        CurvedAnimation(parent: _container, curve: Curves.bounceInOut));
    _container.forward();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(flex: 2,
            child: AnimatedBuilder(
              animation: _myAnimation,
              builder: (context,index){
                return Container(
                  height: _myAnimation.value.height,
                    width: _myAnimation.value.width,

                    child: Image.asset('assets/cripto.png'));
              }


            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: 200,
              child: Text('Create Your\nCryptocurrency\nWallet App',style: TextStyle(color: Colors.white,fontSize: 39),),
            ),
          ),
          Container(
            height: 100,

            child: Text('Grow your Portfolio by receiving\nrevards up to 15.0% on your crypto ',style: TextStyle(color: Colors.white,fontSize: 17),),
          ),

          Container(
            margin: EdgeInsets.symmetric(horizontal: 25),
            child: Builder(
              builder: (context) {
                final GlobalKey<SlideActionState> key = GlobalKey();
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SlideAction(
                    textColor: Colors.black,
                    innerColor: Colors.white,
                    outerColor: Colors.amber[700],
                    sliderButtonIcon: const Icon(
                      Icons.arrow_forward,
                      color: Colors.black,
                    ),
                    key: key,
                    onSubmit: () {
                      Future.delayed(
                        const Duration(seconds: 1),
                            () => key.currentState!.reset(),
                      );
                      return Navigator.push(context, MaterialPageRoute(builder: (_){
                        return CriptoPage();
                      }));
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

