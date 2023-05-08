import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;

// -------------------------------------------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------------------------------------------
class OzelButon extends StatefulWidget {
  double top;
  double left;

  OzelButon(this.left, this.top);
  @override
  State<OzelButon> createState() => _OzelButonState(left, top);
}

class _OzelButonState extends State<OzelButon> {
  final Map<String, int> harfPuani = {
    "A": 1,
    "B": 3,
    "C": 4,
    "Ç": 4,
    "D": 3,
    "E": 1,
    "F": 7,
    "G": 5,
    "Ğ": 8,
    "H": 5,
    "I": 2,
    "İ": 1,
    "J": 10,
    "K": 1,
    "L": 1,
    "M": 2,
    "N": 1,
    "O": 2,
    "Ö": 7,
    "P": 5,
    "R": 1,
    "S": 2,
    "Ş": 4,
    "T": 1,
    "U": 2,
    "Ü": 3,
    "V": 7,
    "Y": 3,
    "Z": 4,
  };

  double left;
  double top;
  List<String> dosyaIciBol = [];
  String arananKelime = '';
  _OzelButonState(this.left, this.top);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dosyaAc();
    //iptal();
  }

  void iptal() {
    Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        if (_GameArea2State.butonaBasildiMi) {
          _GameArea2State.butonaBasildiMi = false;
          print("iptal edildi");
        }
      });
      timer.cancel();
    });
  }

  dosyaAc() async {
    //dosya = File('assets/kelimeHavuz.txt');
    String dosyaIci = await rootBundle.loadString('assets/kelimeHavuzu.txt');
    dosyaIciBol = dosyaIci.split('\n');
    //print(dosyaIciBol[35325].runtimeType);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: this.left,
      top: this.top,
      child: Container(
        width: 40,
        height: 40,
        color: Colors.green,
        child: InkWell(
          onTap: () {
            setState(() {
              //print(dosyaIciBol[45562]);
              //print(_GameArea2State.butonaBasildiMi);
              for (String k in _GameArea2State.selectedLetters) {
                arananKelime += k;
              }
              print(arananKelime);
              bool yanlisVar = true;
              for (String kelime in dosyaIciBol) {
                if (arananKelime.trim().toLowerCase() ==
                    kelime.trim().toLowerCase()) {
                  //print("a");
                  for (String k in _GameArea2State.selectedLetters) {
                    int? alincakPuan = harfPuani[k];
                    _GameArea2State.puan += alincakPuan!;
                  }

                  yanlisVar = false;
                  _GameArea2State.dogrumu = "Doğru";
                }
              }
              if (yanlisVar == true) {
                _GameArea2State.yanlisSayisi++;
                _GameArea2State.dogrumu = "Yanlış";



              }
              else{
                _GameArea2State.butonaBasildiMi = true;

              }
              MyAppState.cevapYaz = true;
              _GameArea2State.selectedLetters.clear();

              arananKelime = '';

              //print(_GameArea2State.puan);
              iptal();
            });
          },
        ),
      ),
    );
  }
}

// -------------------------------------------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------------------------------------------
class MyBox extends StatefulWidget {
  double top;
  double left;
  double bottom;

  MyBox(this.bottom, this.left, this.top);
  @override
  _MyBoxState createState() => _MyBoxState(bottom, left, top);
}

class _MyBoxState extends State<MyBox> {
  bool isSelected = false;
  String letter = '';
  //Random _random = Random();
  double top;
  double left;
  double bottom;

  bool durdu = false;
  bool yokOldu = false;
  int silindi = 0;

  bool _isWidgetVisible = true;
  bool sesliMi = false;

  List<Color> renkler = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.black,
    Colors.white,
    Colors.teal,
    Colors.purple,
    Colors.pink,
    Colors.orange,
    Colors.indigo,
    Colors.cyan,
    Colors.brown,
    Colors.grey,
  ];

  List<Color> koyuRenkler = [
    Colors.red.withOpacity(0.5),
    Colors.green.withOpacity(0.5),
    Colors.blue.withOpacity(0.5),
    Colors.yellow.withOpacity(0.5),
    Colors.black.withOpacity(0.5),
    Colors.white.withOpacity(0.5),
    Colors.teal.withOpacity(0.5),
    Colors.purple.withOpacity(0.5),
    Colors.pink.withOpacity(0.5),
    Colors.orange.withOpacity(0.5),
    Colors.indigo.withOpacity(0.5),
    Colors.cyan.withOpacity(0.5),
    Colors.brown.withOpacity(0.5),
    Colors.grey.withOpacity(0.5),
  ];

  var rndRenk = Random();


  _MyBoxState(this.bottom, this.left, this.top);
  @override
  void dispose() {
    // Nesne yok ediliyor.
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    generateLetter();
    doldur();
    change();
    oyunBittiMi();

  }



  void oyunBittiMi() {
    Timer.periodic(Duration(seconds: 5), (timer) {
      int x = (this.left / 50).toInt();
      int y = (this.top / 50).toInt();
      if (y == 0) {
        if (_GameArea2State.doluYer[x][y] == true && this.durdu) {
          print("GameOver");
          _GameArea2State.OyunBittiMi = true;
        }
      }
      if (_GameArea2State.OyunBittiMi) {
        timer.cancel();
      }
    });
  }

  void doldur() {
    int x = (this.left / 50).toInt();
    int y = (this.top / 50).toInt();
    setState(() {
      if (y - 1 >= 0 && !this.durdu) {
        _GameArea2State.doluYer[x][y - 1] = false;
      }
      if (!yokOldu) {
        _GameArea2State.doluYer[x][y] = true;
      }
    });
  }

  void change() {
    Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (_GameArea2State.OyunBittiMi) {
        timer.cancel();
      }
      doldur();
      setState(() {
        if (this.top < bottom &&
            !_GameArea2State.doluYer[(this.left / 50).toInt()]
                [(this.top / 50).toInt() + 1]) {

          this.top += 50;
          this.durdu = false;
        } else {
          this.durdu = true;
        }
      });

      if (_GameArea2State.butonaBasildiMi && this.isSelected) {
        _isWidgetVisible = false;
        int x = (this.left / 50).toInt();
        int y = (this.top / 50).toInt();
        // _GameArea2State.harfler.remove(widget);
        this.yokOldu = true;
        if (this.silindi == 0) {
          _GameArea2State.doluYer[x][y] = false;
        }
        this.silindi = 1;
      }


    });
  }



  void generateLetter() {

    final harfler = [
      'B',
      'C',
      'Ç',
      'D',
      'F',
      'G',
      'Ğ',
      'H',
      'J',
      'K',
      'K',
      'K',
      'K',
      'K',
      'K',
      'L',
      'L',
      'L',
      'L',
      'M',
      'M',
      'M',
      'M',
      'N',
      'N',
      'N',
      'N',
      'P',
      'R',
      'R',
      'R',
      'R',
      'R',
      'S',
      'S',
      'Ş',
      'T',
      'T',
      'T',
      'T',
      'V',
      'Y',
      'Z'
    ];
    final sesli = [
      'A',
      'E',
      'I',
      'İ',
      'İ',
      'O',
      'Ö',
      'U',
      'Ü',
      'A',
      'A',
      'A',
      'E',
      'E',
      'E',
    ];

    var rng = Random();
    var rnd = Random();
    int r = rnd.nextInt(8);
    if (r == 0 || r == 3 || r == 6) {
      int kacinci = rng.nextInt(sesli.length);
      letter = sesli[kacinci];
      sesliMi = true;
    } else {
      int kacinci = rng.nextInt(harfler.length);
      letter = harfler[kacinci];
      sesliMi = false;
    }
  }



  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: this.left,
      top: this.top,
      child: _isWidgetVisible
          ? Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isSelected ? renkler[2] : koyuRenkler[2],
                border: Border.all(color: Colors.black),
                borderRadius: sesliMi
                    ? BorderRadius.circular(50)
                    : BorderRadius.circular(5),
              ),
              child: InkWell(
                onTap: () {
                  setState(() {
                    isSelected = !isSelected;
                    if (isSelected) {
                      _GameArea2State.selectedLetters.add(letter);
                      print(_GameArea2State.selectedLetters);
                    } else {
                      _GameArea2State.selectedLetters.remove(letter);
                      print(_GameArea2State.selectedLetters);
                    }
                  });
                },
                child: Center(
                  child: Text(
                    letter,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
          : SizedBox(height: 0),
    );
  }
}

// -------------------------------------------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------------------------------------------

class GameArea2 extends StatefulWidget {
  const GameArea2({Key? key}) : super(key: key);

  @override
  State<GameArea2> createState() => _GameArea2State();
}

class _GameArea2State extends State<GameArea2> {
  static List<String> selectedLetters = [];
  static List<List<bool>> doluYer =
      List.generate(8, (index) => List<bool>.filled(10, false));
  static bool butonaBasildiMi = false;
  static List<Widget> secilenKutular = [];
  double y = 500;
  int ii = 9;
  int jj = 0;
  int kk = 2;
  int ss = 0;

  static int puan = 0;
  static int dusmeSuresi = 5;
  static int yanlisSayisi = 0;

  static bool OyunBittiMi = false;

  static String dogrumu = '';



  static List<MyBox> harfler = [];


  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    // change();
    doldur();
    add();
  }

  void doldur() {
    Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {
        harfler.add(MyBox(50.0 * ii, 50.0 * this.jj, 50.0 * this.kk));
        jj++;
      });
      if (jj == 8) {
        kk--;
        jj = 0;
      }

      if (kk < 0) {
        timer.cancel();
      }
    });
  }

  void add() {
    Timer.periodic(Duration(seconds: dusmeSuresi), (timer) {
      print(dusmeSuresi);

      if (yanlisSayisi == 3) {
        doluSatirEkle();
        setState(() {
          yanlisSayisi = 0;
        });
      } else {
        setState(() {
          double y = 450;

          double x = Random().nextInt(8) * 50;
          harfler.add(MyBox(y, x, 0));
        });
      }
      if (_GameArea2State.OyunBittiMi) {
        timer.cancel();
      }
    });
  }

  void doluSatirEkle() {
    Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {
        harfler.add(MyBox(50.0 * ii, 50.0 * this.ss, 0));
        ss++;
      });
      if (ss == 8) {
        ss = 0;
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (OyunBittiMi) {
      return Container(
        child: Text(
          "Oyun Bitti\nSkorunuz: $puan",
          style: TextStyle(fontSize: 50),
        ),
      );
    } else {
      return Stack(
        children: [
          ...harfler,
          for (int i = 0; i < selectedLetters.length; i++)
            Positioned(
              child: Text(selectedLetters[i], style: TextStyle(fontSize: 20)),
              top: 550,
              left: 30.0 * (i + 2),
            ),
          //OzelButon2(10, 550),
          OzelButon(350, 550),
          //Positioned(child: Text(puan.toString()))
          // PuanHesap(),
        ],
      );
    }
  }
}

// -------------------------------------------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------------------------------------------

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
// Satır başına kutucuk sayısı
  String p = '';
  String dogruMu = '';
  int sure = 0;
  static bool cevapYaz = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Yaz();
  }

  void Yaz() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_GameArea2State.puan < 500) {
          _GameArea2State.dusmeSuresi =
              5 - (_GameArea2State.puan / 100).toInt();
        } else {
          _GameArea2State.dusmeSuresi = 1;
        }

        p = _GameArea2State.puan.toString();

        if (cevapYaz) {
          dogruMu = _GameArea2State.dogrumu.toString();
          sure++;
        }

        if (sure == 3) {
          dogruMu = '';
          sure = 0;
          cevapYaz = false;
        }
      });
      if (_GameArea2State.OyunBittiMi) {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          flexibleSpace: Center(
            child: Row(
              children: [
                SizedBox(width: 150),
                Text(
                  p,
                  style: TextStyle(color: Colors.black, fontSize: 30),
                ),
                SizedBox(width: 50),
                Text(
                  dogruMu,
                  style: TextStyle(color: Colors.black, fontSize: 30),
                ),
              ],
            ),
          ),
        ),
        body: GameArea2(),
        backgroundColor: Colors.white,
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

