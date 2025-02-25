import 'dart:convert';
import 'package:cripto_dasturi/CriptoModels.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Details extends StatefulWidget {
  CriptoModels criptos;
  Details({required this.criptos, super.key});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  List<FlSpot> historicalData = [];
  final TextEditingController _durationController = TextEditingController(); // TextField uchun controller

  Future<void> getCryptoApi(int duration) async {
    final String apiUrl =
        "https://api.coingecko.com/api/v3/coins/${widget.criptos.id}/market_chart?vs_currency=usd&days=$duration&interval=daily&precision=0";
    final response = await http.get(Uri.parse(apiUrl));

    try {
      if (response.statusCode == 200) {
        final List<dynamic> responsepricedata =
        jsonDecode(response.body.toString())['prices'];
        setState(() {
          historicalData = responsepricedata
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: Text(
          widget.criptos.name,
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.all(30),
                height: 100, // Kenglik va balandlikni sozlash
                width: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(widget.criptos.image.toString()),
                    fit: BoxFit.cover, // Rasmni to'liq to'ldiradi
                  ),
                ),
              ),
            ),
            Text(
              widget.criptos.name,
              style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Text(
              'Current Price: \$${widget.criptos.currentPrice}',
              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.symmetric(horizontal: 12),
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(20)),
            child: LineChart(LineChartData(
                lineBarsData: [
                  LineChartBarData(
                      spots: historicalData,
                      isCurved: false,
                      color: Colors.green,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: true))
                ],
                titlesData: FlTitlesData(
                  show: false,
                  leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 50,
                          interval: 100000)),
                  rightTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 44,
                      )),
                  topTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                        reservedSize: 44,
                      )),
                  bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                        reservedSize: 44,
                      )),
                ),
                gridData: FlGridData(show: true),
                borderData: FlBorderData(show: false)
            )),
          ),
          SizedBox(height: 20),
          // **TextField va Buttonni tagiga tushirish**
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                TextField(
                  controller: _durationController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter in days',
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.grey,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    int duration = int.tryParse(_durationController.text) ?? 365;
                    getCryptoApi(duration);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade900,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: Text('Get Data',style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
