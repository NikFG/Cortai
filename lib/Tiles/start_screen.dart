import 'package:cortai/Telas/login_tela.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  final tituloStyle = TextStyle(
    color: Colors.white,
    fontSize: 22.0,
    height: 1.5,
  );

  final subTituloStyle = TextStyle(
    color: Colors.white,
    fontSize: 14.0,
    height: 1.2,
  );

  List<Widget> _buildIndicadorPagina() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicador(true) : _indicador(false));
    }
    return list;
  }

  Widget _indicador(bool isActive) {
    MediaQueryData deviceInfo = MediaQuery.of(context);
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive
          ? deviceInfo.size.width * 24 / 100
          : deviceInfo.size.width * 16 / 100,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Theme.of(context).primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // var screenFactor = MediaQuery.of(context).textScaleFactor;

    MediaQueryData deviceInfo = MediaQuery.of(context);
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.1, 0.7],
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).accentColor,
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => LoginTela())),
                    child: Text(
                      'Pular',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: deviceInfo.size.height * 7 / 10,
                  child: PageView(
                    physics: ClampingScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Image(
                                image: AssetImage(
                                  'assets/images/BarberMan.png',
                                ),
                                fit: BoxFit.contain,
                                height: deviceInfo.size.height * 4 / 10,
                                width: deviceInfo.size.width,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Encontre o profissional que você precisa',
                              style: tituloStyle,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Os melhores profissionais estão a alguns toques de distância.",
                              textAlign: TextAlign.justify,
                              style: subTituloStyle,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Image(
                                image: AssetImage(
                                  'assets/images/BarberMan2.png',
                                ),
                                fit: BoxFit.contain,
                                height: deviceInfo.size.height * 4 / 10,
                                width: deviceInfo.size.width,
                              ),
                            ),
                            SizedBox(height: deviceInfo.size.height * 2 / 100),
                            Text(
                              'Quando você precisar\nEstaremos aqui!',
                              style: tituloStyle,
                            ),
                            SizedBox(height: deviceInfo.size.height * 1 / 100),
                            Text(
                              'Os profissionais cadastrados recebem qualificações por seus serviços, não se esqueça de deixar a sua avaliação!',
                              textAlign: TextAlign.justify,
                              style: subTituloStyle,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Image(
                                image: AssetImage(
                                  'assets/images/Saude.png',
                                ),
                                fit: BoxFit.contain,
                                height: deviceInfo.size.height * 4 / 10,
                                width: deviceInfo.size.width,
                              ),
                            ),
                            SizedBox(height: deviceInfo.size.height * 1 / 100),
                            Text(
                              'Saúde e Segurança\nem primeiro lugar',
                              style: tituloStyle,
                            ),
                            SizedBox(height: deviceInfo.size.height * 1 / 100),
                            Text(
                              'Recomendamos a todos os profissionais e clientes a seguirem sempre as normas de saúde divulgadas pela OMS',
                              textAlign: TextAlign.justify,
                              style: subTituloStyle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildIndicadorPagina(),
                ),
                _currentPage != _numPages - 1
                    ? Expanded(
                        child: Align(
                          alignment: FractionalOffset.bottomRight,
                          child: TextButton(
                            onPressed: () {
                              _pageController.nextPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'Próximo',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 18.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Text(''),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: _currentPage == _numPages - 1
          ? Container(
              height: MediaQuery.of(context).size.height / 10,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginTela()));
                },
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      'Comece agora',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            )
          : Text(''),
    );
  }
}
