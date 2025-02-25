import 'dart:convert';
import 'package:cripto_dasturi/Details.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'package:cripto_dasturi/CriptoModels.dart';
import 'package:flutter/material.dart';

class CriptoPage extends StatefulWidget {
  const CriptoPage({super.key});

  @override
  State<CriptoPage> createState() => _CriptoPageState();
}
class _CriptoPageState extends State<CriptoPage> {
  List<CriptoModels> news = [];
  Map<int, List<FlSpot>> cryptoData = {};

  Future<void> getCryptoApi(int index, int duration) async {
    final String apiUrl =
        "https://api.coingecko.com/api/v3/coins/${news[index].id}/market_chart?vs_currency=usd&days=$duration&interval=daily";
    final response = await http.get(Uri.parse(apiUrl));

    try {
      if (response.statusCode == 200) {
        final List<dynamic> responsepricedata =
        jsonDecode(response.body.toString())['prices'];

        setState(() {
          cryptoData[index] = responsepricedata
              .map((price) => FlSpot(
            responsepricedata.indexOf(price).toDouble(),
            price[1].toDouble(),
          ))
              .toList();
        });
      }
    } catch (e) {
      print("Api error");
    }
  }

  Future<List<CriptoModels>> getNewList() async {
    var response = await http.get(Uri.parse(
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=50&page=1'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      for (var photo in data) {
        news.add(CriptoModels.fromJson(photo));
      }
      return news;
    }
    return news;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          SizedBox(height: 70,),
          SizedBox(
            height: 150,
            child: Center(
              child: Column(
                children: [
                  Text('Current Wallet Balance',style: TextStyle(color: Colors.grey),),
                  Text('\$3,293.45',style: TextStyle(color: Colors.orange,fontSize: 40),)
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal:30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Column(
                children: [
                  Icon(Icons.arrow_upward_outlined,size: 30,color: Colors.white,),
                  Text('Send',style: TextStyle(color: Colors.white,fontSize: 15),)
                ],
              ), Column(
                  children: [
                    Icon(Icons.arrow_downward_outlined,size: 30,color: Colors.white,),
                    Text('Receive',style: TextStyle(color: Colors.white,fontSize: 15),)
                  ],
                ), Column(
                  children: [
                    Icon(Icons.wallet,size: 30,color: Colors.white,),
                    Text('Buy',style: TextStyle(color: Colors.white,fontSize: 15),)
                  ],
                ), Column(
                  children: [
                    Icon(Icons.swap_vert_outlined,size: 30,color: Colors.white,),
                    Text('Swap',style: TextStyle(color: Colors.white,fontSize: 15),)
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            height: 50,
          color: Colors.black,
          child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Portfolio',style: TextStyle(color: Colors.white,fontSize: 15),),
                  Text('See all',style: TextStyle(color: Colors.white,fontSize: 15),)
                ],
              )

          ),
          Container(
            height: 140,
            color: Colors.black,
            child: FutureBuilder(
              future: getNewList(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    getCryptoApi(index, 30);
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => Details(criptos: news[index]),
                          ),
                        );
                      },
                      child: Card(
                        color: Colors.black,
                        child: Container(
                          margin: const EdgeInsets.all(15),
                          child: Column(
                              children: [ CircleAvatar(
                                child: Image.network(news[index].image.toString()),
                              ),
                               Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        news[index].name,
                                        style: TextStyle(color: Colors.white, fontSize: 12),
                                      ),
                                      Text(
                                        '(${news[index].symbol})',
                                        style: TextStyle(color: Colors.white, fontSize: 9),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                               Text(
                                news[index].id,
                                style: TextStyle(color: Colors.grey, fontSize: 7),
                              ),
                                Text('${news[index].currentPrice.toString()}\$',style: TextStyle(color: Colors.white,fontSize: 15),),
]
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: news.length,
                );
              },
            ),
          ),
          Container(
              margin: EdgeInsets.all(20),
              height: 50,
              color: Colors.black,
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('YourAssets',style: TextStyle(color: Colors.white,fontSize: 15),),
                  Text('See all',style: TextStyle(color: Colors.white,fontSize: 15),)
                ],
              )

          ),
          Expanded(
            child: Container(
              height: 400,
              child: FutureBuilder(
                future: getNewList(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      getCryptoApi(index, 30);
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => Details(criptos: news[index]),
                            ),
                          );
                        },
                        child: Card(
                          color: Colors.black,
                          child: Container(
                            margin: const EdgeInsets.all(15),
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Image.network(news[index].image.toString()),
                              ),
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        news[index].name,
                                        style: TextStyle(color: Colors.white, fontSize: 12),
                                      ),
                                      Text(
                                        '(${news[index].symbol})',
                                        style: TextStyle(color: Colors.white, fontSize: 9),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    height: 30,
                                    width: 40,
                                    child: LineChart(
                                      LineChartData(
                                        lineBarsData: [
                                          LineChartBarData(
                                            spots: cryptoData[index],
                                            isCurved: true,
                                            color:  news[index].priceChangePercentage24H>0?
                                            Colors.green
                                                :Colors.red,
                                            dotData: FlDotData(show: false),
                                            belowBarData: BarAreaData(show: false),
                                          ),
                                        ],
                                        titlesData: FlTitlesData(show: false),
                                        gridData: FlGridData(show: false),
                                        borderData: FlBorderData(show: false),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                news[index].id,
                                style: TextStyle(color: Colors.grey, fontSize: 7),
                              ),
                              trailing: Column(
                                children: [
                                  Text('${news[index].currentPrice.toString()}\$',style: TextStyle(color: Colors.white,fontSize: 15),),
                                  Text('${news[index].priceChangePercentage24H.toString()}\%',style: TextStyle(color:
                                  news[index].priceChangePercentage24H>0?
                                  Colors.green
                                  :Colors.red),),
                                ],
                              )

                              ),
                            ),
                          ),
                      );
                    },
                    itemCount: news.length,
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

