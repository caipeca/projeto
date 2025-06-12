import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel_slider;
import 'package:piloto/app.dart';

import '../widget/categoria.dart';

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
        padding: EdgeInsets.fromLTRB(0, 10, 10, 0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Pesquisa',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),

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
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Card(
                      child:
                      Column(
                        children: [
                          Image(image: AssetImage('assets/images/logo.png'),width: 170, height: 150,),
                          Text('Porco')
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
