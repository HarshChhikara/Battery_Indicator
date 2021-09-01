import 'package:battery/battery.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:batterycheck/drawer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Battery b = Battery();
  int showbatteryLevels =0;
  BatteryState state;
  bool broadcastBattery;

  Color COLOR_RED = Colors.red;
  Color COLOR_GREEN = Color.fromARGB(255, 0, 169, 181);
  Color COLOR_GREY = Colors.grey;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _broadcastBatteryLevels();
    b.onBatteryStateChanged.listen((event) {
      setState(() {
        state = event;
      });
    });
  }

  _broadcastBatteryLevels() async {
    broadcastBattery = true;
    while(broadcastBattery){
      var blevels = await b.batteryLevel;
      setState(() {
        showbatteryLevels = blevels;
      });
      await Future.delayed(Duration(seconds: 1));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    setState(() {
      broadcastBattery = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text('Battery Indicator'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 50),
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.width *0.6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(200),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 7,
                      spreadRadius: -5,
                      offset: Offset(4,4),
                      color: COLOR_GREY
                    ),

                  ],
                ),
                child: SfRadialGauge(
                  axes: [
                    RadialAxis(
                      minimum: 0,
                      maximum: 100,
                      startAngle: 270,
                      endAngle: 270,
                      showLabels: false,
                      showTicks: false,
                      axisLineStyle: AxisLineStyle(
                        thickness: 1,
                        color: showbatteryLevels <= 10 ? COLOR_RED: COLOR_GREEN,
                        thicknessUnit: GaugeSizeUnit.factor
                      ),
                      pointers: <GaugePointer>[
                        RangePointer(
                          value: double.parse(showbatteryLevels.toString()),
                          width: 0.3,
                          color: Colors.white,
                          pointerOffset: 0.1,
                          cornerStyle: showbatteryLevels == 100 ? CornerStyle.bothFlat : CornerStyle.endCurve,
                          sizeUnit: GaugeSizeUnit.factor
                        ),
                      ],
                      annotations: <GaugeAnnotation>[
                        GaugeAnnotation(
                          positionFactor: 0.5,
                          angle: 90,
                          widget: Text(showbatteryLevels == null ? 0 : showbatteryLevels.toString() + " %",
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                            ),
                          )
                        ),
                      ]
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.4,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    batterContainer(70, Icons.power, 40, showbatteryLevels <=10 ? COLOR_RED:COLOR_GREEN, state == BatteryState.charging ? true : false),
                    batterContainer(70, Icons.power_off, 40, showbatteryLevels <=10 ? COLOR_RED:COLOR_GREEN, state == BatteryState.discharging ? true : false),
                    batterContainer(70, Icons.battery_charging_full, 40, showbatteryLevels <=10 ? COLOR_RED:COLOR_GREEN, state == BatteryState.full ? true : false),
                  ],),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  batterContainer(double size, IconData icon, double iconSize, Color iconColor, bool hasGlow) {
    return Container(
      width: size,
      height: size,
      child: Icon(
        icon,
        size: iconSize,
        color: iconColor,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          hasGlow
          ? BoxShadow(
              blurRadius: 10,
              spreadRadius: 2,
              offset: Offset(0,0),
              color: iconColor)
          : BoxShadow(
              blurRadius: 7,
              spreadRadius: -5,
              offset: Offset(2,2),
              color: COLOR_GREY)
        ]),
    );
  }
}
