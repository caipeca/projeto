import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel_slider;
import 'package:piloto/app.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Center(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Pesquisa',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child:
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: carousel_slider.CarouselSlider(
                    items:
                        [
                          Categoria(categoria: 'Álcool'),
                          Categoria(categoria: 'Aperetivos'),
                          Categoria(categoria: 'Legumes'),
                          Categoria(categoria: 'Aves'),
                          Categoria(categoria: 'Bebida'),
                        ].map((widget) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: widget,
                          );
                        }).toList(),
                    options: carousel_slider.CarouselOptions(
                      viewportFraction: 0.33,
                      enableInfiniteScroll: true,
                      enlargeCenterPage: false,
                      autoPlay: true,
                    ),
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }
}

class Categoria extends StatelessWidget {
  const Categoria({super.key, required this.categoria, this.border});
  final String categoria;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 150,
        height: 20,
        decoration: BoxDecoration(
          border: border,
          color: Colors.teal.shade900,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Text(
          categoria,
          style: TextStyle(fontSize: 14),
          softWrap: true,
          overflow: TextOverflow.visible,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
