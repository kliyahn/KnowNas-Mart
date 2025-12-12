import 'package:flutter/material.dart';
import 'package:sulam/widgets/bottom_nav.dart';

class AnalyticsFarmerPage extends StatefulWidget {
  const AnalyticsFarmerPage({super.key, required List<Map<String, dynamic>> cartItems});

  @override
  State<AnalyticsFarmerPage> createState() => _AnalyticsFarmerPageState();
}

class _AnalyticsFarmerPageState extends State<AnalyticsFarmerPage> {
  String selectedPeriod = 'Days';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF2D5F3F),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: EdgeInsets.fromLTRB(20, 50, 20, 30),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Analytics',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 48), // Balance the back button
                    ],
                  ),
                  SizedBox(height: 20),
                  
                  // Period Selector
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xFF9BB8A3),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Last 50',
                          style: TextStyle(
                            color: Color(0xFF2D5F3F),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Color(0xFF2D5F3F),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DropdownButton<String>(
                            value: selectedPeriod,
                            underline: SizedBox(),
                            dropdownColor: Color(0xFF2D5F3F),
                            icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            items: ['Hours', 'Days', 'Months'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedPeriod = newValue!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // SALES Section
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    decoration: BoxDecoration(
                      color: Color(0xFF2D5F3F),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'SALES',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),

                  // Sales Revenue Card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xFF9BB8A3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SALES REVENUE',
                          style: TextStyle(
                            color: Color(0xFF2D5F3F),
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'RM 12,500',
                                  style: TextStyle(
                                    color: Color(0xFF2D5F3F),
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '+12% MoM',
                                  style: TextStyle(
                                    color: Color(0xFF2D5F3F),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            // Simple Bar Chart
                            _buildMiniBarChart([50, 70, 90]),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),

                  // Total Units Sold Card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xFF9BB8A3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TOTAL UNITS SOLD (kg/pcs)',
                          style: TextStyle(
                            color: Color(0xFF2D5F3F),
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '5,800 units',
                                  style: TextStyle(
                                    color: Color(0xFF2D5F3F),
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '+8% MoM',
                                  style: TextStyle(
                                    color: Color(0xFF2D5F3F),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            // Simple Bar Chart
                            _buildMiniBarChart([60, 85, 70]),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25),

                  // TRENDING Section
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    decoration: BoxDecoration(
                      color: Color(0xFF2D5F3F),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'TRENDING',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),

                  // Trending Items Card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xFF9BB8A3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TRENDING ITEMS',
                          style: TextStyle(
                            color: Color(0xFF2D5F3F),
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTrendingItem(
                                'Nenas MD2',
                                '2510',
                                'Sales: +12%',
                                'assets/nenas01.png',
                              ),
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: _buildTrendingItem(
                                'Red Pineapple',
                                '200',
                                'Sales: +5%',
                                'assets/nenas02.png',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
    );
  }

  Widget _buildMiniBarChart(List<double> values) {
    return Container(
      width: 70,
      height: 80,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(0xFF7FA88E),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: values.map((value) {
          return Container(
            width: 14,
            height: value,
            decoration: BoxDecoration(
              color: Color(0xFF2D5F3F),
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTrendingItem(
    String name,
    String units,
    String salesText,
    String imagePath,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF9BB8A3),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: Color(0xFF4A9D6F),
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 12),
          
          // Product Info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: Color(0xFF2D5F3F),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                units,
                style: TextStyle(
                  color: Color(0xFF2D5F3F),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2),
              Text(
                salesText,
                style: TextStyle(
                  color: Color(0xFF2D5F3F),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}