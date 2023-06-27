import 'package:flutter/material.dart';

  class firstPage extends StatefulWidget {
  const firstPage({Key? key}) : super(key: key);

  @override
  State<firstPage> createState() => _firstPageState();
}
enum SingingCharacter { Single, Double}
const List<String> unitlist = <String>['m3/day', 'USGPD', 'IGPD'];
class _firstPageState extends State<firstPage> {
  SingingCharacter? _character = SingingCharacter.Single;
  String dropdownValue = unitlist.first;

  late TextEditingController totalplantcapacityInput;
  late TextEditingController totalplantcapacityOutput;
  late TextEditingController TDSPPM;
  late TextEditingController Designrecovery;
  late TextEditingController targetproducttds;
  late TextEditingController streamnum;
  late TextEditingController floweachstream;
  late TextEditingController feedflow;
  late TextEditingController rejectflow;
  late TextEditingController singleproductflow;
  late TextEditingController singlefeedflow;
  late TextEditingController singlerejectflow;
  late TextEditingController rejectproducttds;







  bool singlePassvisibility = true;
  bool doublePassvisibility = false;

  @override
  void initState() {
    super.initState();
    singlePassvisibility = true;


    totalplantcapacityInput = TextEditingController();
    totalplantcapacityOutput = TextEditingController();
    TDSPPM = TextEditingController();
    Designrecovery = TextEditingController();
    targetproducttds = TextEditingController();
    streamnum = TextEditingController();
    floweachstream = TextEditingController();
    feedflow = TextEditingController();
    rejectflow = TextEditingController();
    singleproductflow = TextEditingController();
    singlefeedflow = TextEditingController();
    singlerejectflow = TextEditingController();
    rejectproducttds = TextEditingController();
  }

  @override
  void dispose() {


    totalplantcapacityInput.dispose();
    totalplantcapacityOutput.dispose();
    TDSPPM.dispose();
    Designrecovery.dispose();
    targetproducttds.dispose();
    streamnum.dispose();
    floweachstream.dispose();
    feedflow.dispose();
    rejectflow.dispose();
    singleproductflow.dispose();
    singlefeedflow.dispose();
    singlerejectflow.dispose();
    rejectproducttds.dispose();
    super.dispose();
  }

  void calculateCapacityUnit() {
    String input = totalplantcapacityInput.text;
    double parsedInput = double.parse(input);
    double result;


    if (dropdownValue == 'm3/day') {
      result = parsedInput/24; // Calculation for Option 1
    } else if (dropdownValue == 'USGPD') {
      result = (parsedInput * 3.785)/24000; // Calculation for Option 2
    } else if (dropdownValue == 'IGPD') {
      result = (parsedInput * 4.5)/24000; // Calculation for Option 3
    } else {
      result = 0.0;
    }
    double rounded = double.parse(result.toStringAsFixed(2));
    totalplantcapacityOutput.text = rounded.toString();
  }
  void calculateFlowEachStream() {
    String productflow = totalplantcapacityOutput.text;
    double pc = double.parse(productflow);
    double result;
    String noStream= streamnum.text;
    double ns = double.parse(noStream);
    result = pc/ns;
    double rounded = double.parse(result.toStringAsFixed(2));
    floweachstream.text = rounded.toString();
  }

  void calculatesingleproductflow() {
    String plantcapacity = totalplantcapacityOutput.text;
    double pc = double.parse(plantcapacity);
    String noStream= streamnum.text;
    double ns = double.parse(noStream);
    double singleresult;

    singleresult = pc/ns;

    double rounded = double.parse(singleresult.toStringAsFixed(2));
    singleproductflow.text = rounded.toString();
  }

  void calculatefeedflow() {
    String plantcapacity = totalplantcapacityOutput.text;
    double pc = double.parse(plantcapacity);

    double result;
    String designrecovery = Designrecovery.text;
    double dr = double.parse(designrecovery);

    result = pc/(dr/100);

    double rounded = double.parse(result.toStringAsFixed(2));
    feedflow.text = rounded.toString();
  }

  void calculaterejectflow() {
    String productflow = totalplantcapacityOutput.text;
    double pc = double.parse(productflow);
    double result;
    String feed = feedflow.text;
    double ff = double.parse(feed);

    result = ff-pc;


    double rounded = double.parse(result.toStringAsFixed(2));

    rejectflow.text = rounded.toString();
  }

  void calculatesinglefeedflow() {
    String plantcapacity = totalplantcapacityOutput.text;
    double pc = double.parse(plantcapacity);
    String noStream= streamnum.text;
    double ns = double.parse(noStream);
    double singleresult;

    double result;
    String designrecovery = Designrecovery.text;
    double dr = double.parse(designrecovery);

    result = pc/(dr/100);
    singleresult = result/ns;

    double rounded = double.parse(result.toStringAsFixed(2));
    double singlerounded = double.parse(singleresult.toStringAsFixed(2));
    singlefeedflow.text = singlerounded.toString();
  }

  void calculatesinglerejectflow() {
    String productflow = totalplantcapacityOutput.text;
    double pc = double.parse(productflow);
    double result;
    String feed = feedflow.text;
    double ff = double.parse(feed);
    String noStream= streamnum.text;
    double ns = double.parse(noStream);
    double singleresult;

    result = ff-pc;
    singleresult = result/ns;

    double singlerounded = double.parse(singleresult.toStringAsFixed(2));

    singlerejectflow.text = singlerounded.toString();
  }

  void calculaterejecttds() {
    String productflow = totalplantcapacityOutput.text;
    double pc = double.parse(productflow);
    //
    String reject = rejectflow.text;
    double rf = double.parse(reject);
    //
    String designtds = TDSPPM.text;
    double design = double.parse(designtds);
    //
    String feed = feedflow.text;
    double f = double.parse(feed);
    //
    String productds = targetproducttds.text;
    double ptds = double.parse(productds);


    // double result = ((f * design)  - (pc*ptds))/rf;

    double result = ((f * design) - (pc*ptds))/rf;
    double round = double.parse(result.toStringAsFixed(2));

    rejectproducttds.text = round.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Design Calculation (Process)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            RadioListTile(
              title: Text('Single Pass'),
              value: true,
              groupValue: singlePassvisibility,
              onChanged: (value) {
                setState(() {
                  singlePassvisibility = true;
                  doublePassvisibility = false;

                });
              },
            ),
            RadioListTile(
              title: Text('Double Pass'),
              value: false,
              groupValue: singlePassvisibility,
              onChanged: (value) {
                setState(() {
                  singlePassvisibility = false;
                  doublePassvisibility = true;
                });
              },
            ),

            //Single Pass

            //total plant capacity
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 children:[
                   Visibility(
                     visible: singlePassvisibility,
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.start,
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Row(
                           children: [
                             SizedBox(
                                 width: MediaQuery.of(context).size.width*0.17 ,
                                 child: Text("Total Plant Capacity")),
                             SizedBox(
                               width:  MediaQuery.of(context).size.width*0.09,
                               height: 40,

                               child: TextField(
                                 controller: totalplantcapacityInput,
                                 decoration: InputDecoration(
                                   border: OutlineInputBorder(),
                                 ),
                                 onChanged: (value) {
                                   calculateCapacityUnit();
                                   calculaterejecttds();
                                 },
                               ),

                             ),
                             SizedBox(width: MediaQuery.of(context).size.width*0.01,),


                             DropdownButton<String>(
                               value: dropdownValue,

                               style: const TextStyle(color: Colors.deepPurple),
                               underline: Container(
                                 height: 2,
                                 color: Colors.deepPurpleAccent,
                               ),
                               onChanged: (String? value) {
                                 // This is called when the user selects an item.
                                 setState(() {
                                   dropdownValue = value!;
                                   calculateCapacityUnit();
                                   calculatefeedflow();
                                   calculaterejectflow();
                                   calculatesingleproductflow();
                                   calculatesinglefeedflow();
                                   calculatesinglerejectflow();

                                 });
                               },
                               items: unitlist.map<DropdownMenuItem<String>>((String value) {
                                 return DropdownMenuItem<String>(
                                   value: value,
                                   child: Text(value),
                                 );
                               }).toList(),
                             ),
                           ],
                         ),
                         SizedBox(height: MediaQuery.of(context).size.height*0.01,),

                         //result of total plant capacity
                         Row(
                           children: [
                             SizedBox(                  width: MediaQuery.of(context).size.width*0.17 ,
                                 child: Text("m3/hr")),

                             SizedBox(
                               width:  MediaQuery.of(context).size.width*0.09,
                               height: 50,
                               child: TextField(
                                 readOnly: true,
                                 controller: totalplantcapacityOutput,
                                 style: TextStyle(fontSize: 12),

                                 decoration: InputDecoration(
                                   border: OutlineInputBorder(),
                                 ),
                                 onChanged: (value) {
                                 },
                               ),

                             ),

                           ],
                         ),
                         SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                         //Design TDS PPM
                         Row(
                           children: [
                             SizedBox(
                               width: MediaQuery.of(context).size.width*0.17 ,
                               child:  Text("Design TDS ppm"),

                             ),



                             SizedBox(
                               width:  MediaQuery.of(context).size.width*0.09,
                               height: 40,

                               child: TextField(
                                 controller: TDSPPM,
                                 decoration: InputDecoration(
                                   border: OutlineInputBorder(),
                                 ),
                                 onChanged: (value) {
                                   calculaterejecttds();
                                 },
                               ),

                             ),
                             SizedBox(width: MediaQuery.of(context).size.width*0.01,),

                             Text("PPM"),

                           ],
                         ),
                         SizedBox(height: MediaQuery.of(context).size.height*0.01,),

                         //Target Product TDS
                         Row(
                           children: [
                             SizedBox(
                               width: MediaQuery.of(context).size.width*0.17 ,
                               child: Text("Target Product TDS"),



                             ),



                             SizedBox(
                               width:  MediaQuery.of(context).size.width*0.09,
                               height: 40,

                               child: TextField(
                                 controller: targetproducttds,
                                 decoration: InputDecoration(
                                   border: OutlineInputBorder(),
                                 ),
                                 onChanged: (value) {
                                   calculaterejecttds();

                                 },
                               ),

                             ),
                             SizedBox(width: MediaQuery.of(context).size.width*0.01,),

                             Text("PPM"),

                           ],
                         ),
                         SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                         //Design Recovery
                         Row(
                           children: [
                             SizedBox(
                               width: MediaQuery.of(context).size.width*0.17 ,
                               child: Text("Design Recovery"),


                             ),



                             SizedBox(
                               width:  MediaQuery.of(context).size.width*0.09,
                               height: 40,

                               child: TextField(
                                 controller: Designrecovery,
                                 decoration: InputDecoration(
                                   border: OutlineInputBorder(),
                                 ),
                                 onChanged: (value) {
                                   calculatefeedflow();
                                   calculaterejectflow();
                                   calculaterejecttds();

                                 },
                               ),

                             ),
                             SizedBox(width: MediaQuery.of(context).size.width*0.01,),

                             Text("%"),

                           ],
                         ),
                         SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                         //Target Product TDS
                         Row(
                           children: [
                             SizedBox(
                               width: MediaQuery.of(context).size.width*0.17 ,
                               child: Text("Reject TDS"),



                             ),



                             SizedBox(
                               width:  MediaQuery.of(context).size.width*0.09,
                               height: 40,

                               child: TextField(
                                 controller: rejectproducttds,
                                 decoration: InputDecoration(
                                   border: OutlineInputBorder(),
                                 ),
                                 onChanged: (value) {
                                 },
                               ),

                             ),
                             SizedBox(width: MediaQuery.of(context).size.width*0.01,),

                             Text("PPM"),

                           ],
                         ),
                         SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                         //No of stream
                         Row(
                           children: [
                             SizedBox(
                               width: MediaQuery.of(context).size.width*0.17 ,
                               child: Text("No of streams"),



                             ),



                             SizedBox(
                               width:  MediaQuery.of(context).size.width*0.09,
                               height: 40,

                               child: TextField(
                                 controller: streamnum,
                                 decoration: InputDecoration(
                                   border: OutlineInputBorder(),
                                 ),
                                 onChanged: (value) {
                                   calculateFlowEachStream();
                                   calculatesingleproductflow();
                                   calculatesinglefeedflow();
                                   calculatesinglerejectflow();
                                 },
                               ),

                             ),
                             SizedBox(width: MediaQuery.of(context).size.width*0.01,),

                             Text("Nos"),

                           ],
                         ),
                         SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                         //Flow of each stream
                         Row(
                           children: [
                             SizedBox(
                               width: MediaQuery.of(context).size.width*0.17 ,
                               child: Text("Flow each stream"),



                             ),



                             SizedBox(
                               width:  MediaQuery.of(context).size.width*0.09,
                               height: 50,

                               child: TextField(

                                 controller: floweachstream,
                                 decoration: InputDecoration(
                                   border: OutlineInputBorder(),
                                 ),
                                 onChanged: (value) {
                                 },
                               ),

                             ),
                             SizedBox(width: MediaQuery.of(context).size.width*0.01,),

                             Text("m3/hr"),

                           ],
                         ),
                       ],
                     ),
                   ),

                   Visibility(
                     visible: doublePassvisibility,
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.start,
                       crossAxisAlignment: CrossAxisAlignment.start,

                       children: [
                         Row(
                           children: [
                             SizedBox(
                                 width: MediaQuery.of(context).size.width*0.17 ,
                                 child: Text("Final Plant Capacity")),
                             SizedBox(
                               width:  MediaQuery.of(context).size.width*0.09,
                               height: 40,

                               child: TextField(
                                 controller: totalplantcapacityInput,
                                 decoration: InputDecoration(
                                   border: OutlineInputBorder(),
                                 ),
                                 onChanged: (value) {
                                 },
                               ),

                             ),
                             SizedBox(width: MediaQuery.of(context).size.width*0.01,),


                             DropdownButton<String>(
                               value: dropdownValue,

                               style: const TextStyle(color: Colors.deepPurple),
                               underline: Container(
                                 height: 2,
                                 color: Colors.deepPurpleAccent,
                               ),
                               onChanged: (String? value) {
                                 // This is called when the user selects an item.
                                 setState(() {
                                   dropdownValue = value!;
                                   calculateCapacityUnit();

                                 });
                               },
                               items: unitlist.map<DropdownMenuItem<String>>((String value) {
                                 return DropdownMenuItem<String>(
                                   value: value,
                                   child: Text(value),
                                 );
                               }).toList(),
                             ),
                           ],
                         ),
                         SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                         //Design TDS PPM
                         Row(
                           children: [
                             SizedBox(
                               width: MediaQuery.of(context).size.width*0.17 ,
                               child:  Text("Total Plant Capacity"),

                             ),



                             SizedBox(
                               width:  MediaQuery.of(context).size.width*0.09,
                               height: 40,

                               child: TextField(
                                 controller: TDSPPM,
                                 decoration: InputDecoration(
                                   border: OutlineInputBorder(),
                                 ),
                                 onChanged: (value) {
                                 },
                               ),

                             ),
                             SizedBox(width: MediaQuery.of(context).size.width*0.01,),

                             Text("M3/hr"),

                           ],
                         ),
                         SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                         //Design Recovery
                         Row(
                           children: [
                             SizedBox(
                               width: MediaQuery.of(context).size.width*0.17 ,
                               child: Text("First Pass TDs Max"),


                             ),



                             SizedBox(
                               width:  MediaQuery.of(context).size.width*0.09,
                               height: 40,

                               child: TextField(
                                 controller: Designrecovery,
                                 decoration: InputDecoration(
                                   border: OutlineInputBorder(),
                                 ),
                                 onChanged: (value) {
                                   calculateCapacityUnit();
                                 },
                               ),

                             ),
                             SizedBox(width: MediaQuery.of(context).size.width*0.01,),

                             Text("PPM"),

                           ],
                         ),
                         SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                         //Target Product TDS
                         Row(
                           children: [
                             SizedBox(
                               width: MediaQuery.of(context).size.width*0.17 ,
                               child: Text("Second Pass TDS"),



                             ),



                             SizedBox(
                               width:  MediaQuery.of(context).size.width*0.09,
                               height: 40,

                               child: TextField(
                                 controller: targetproducttds,
                                 decoration: InputDecoration(
                                   border: OutlineInputBorder(),
                                 ),
                                 onChanged: (value) {
                                 },
                               ),

                             ),
                             SizedBox(width: MediaQuery.of(context).size.width*0.01,),

                             Text("PPM"),

                           ],
                         ),
                         SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                         //No of stream
                         Row(
                           children: [
                             SizedBox(
                               width: MediaQuery.of(context).size.width*0.17 ,
                               child: Text("Final TDS-Actual"),



                             ),



                             SizedBox(
                               width:  MediaQuery.of(context).size.width*0.09,
                               height: 40,

                               child: TextField(
                                 controller: streamnum,
                                 decoration: InputDecoration(
                                   border: OutlineInputBorder(),
                                 ),
                                 onChanged: (value) {
                                 },
                               ),

                             ),
                             SizedBox(width: MediaQuery.of(context).size.width*0.01,),

                             Text("PPM"),

                           ],
                         ),
                         SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                         //Flow of each stream
                         Row(
                           children: [
                             SizedBox(
                               width: MediaQuery.of(context).size.width*0.17 ,
                               child: Text("Second Pass Flow"),



                             ),



                             SizedBox(
                               width:  MediaQuery.of(context).size.width*0.09,
                               height: 40,

                               child: TextField(
                                 controller: floweachstream,
                                 decoration: InputDecoration(
                                   border: OutlineInputBorder(),
                                 ),
                                 onChanged: (value) {
                                 },
                               ),

                             ),
                             SizedBox(width: MediaQuery.of(context).size.width*0.01,),

                             Text("%"),

                           ],
                         ),
                         SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                         //Flow of each stream
                         Row(
                           children: [
                             SizedBox(
                               width: MediaQuery.of(context).size.width*0.17 ,




                             ),



                             SizedBox(
                               width:  MediaQuery.of(context).size.width*0.09,
                               height: 40,

                               child: TextField(
                                 controller: floweachstream,
                                 decoration: InputDecoration(
                                   border: OutlineInputBorder(),
                                 ),
                                 onChanged: (value) {
                                 },
                               ),

                             ),
                             SizedBox(width: MediaQuery.of(context).size.width*0.01,),

                             Text("%"),

                           ],
                         ),
                         SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                         //Flow of each stream
                         Row(
                           children: [
                             SizedBox(
                               width: MediaQuery.of(context).size.width*0.17 ,
                               child: Text("Total Flow- Second Pass"),



                             ),



                             SizedBox(
                               width:  MediaQuery.of(context).size.width*0.09,
                               height: 40,

                               child: TextField(
                                 controller: floweachstream,
                                 decoration: InputDecoration(
                                   border: OutlineInputBorder(),
                                 ),
                                 onChanged: (value) {
                                 },
                               ),

                             ),
                             SizedBox(width: MediaQuery.of(context).size.width*0.01,),

                             Text("m3/hr"),

                           ],
                         ),
                         SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                         //Flow of each stream
                         Row(
                           children: [
                             SizedBox(
                               width: MediaQuery.of(context).size.width*0.17 ,
                               child: Text("Second Pass Flow"),



                             ),



                             SizedBox(
                               width:  MediaQuery.of(context).size.width*0.09,
                               height: 40,

                               child: TextField(
                                 controller: floweachstream,
                                 decoration: InputDecoration(
                                   border: OutlineInputBorder(),
                                 ),
                                 onChanged: (value) {
                                 },
                               ),

                             ),
                             SizedBox(width: MediaQuery.of(context).size.width*0.01,),

                             Text("m3/hr"),

                           ],
                         ),
                         SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                         //Flow of each stream
                         Row(
                           children: [
                             SizedBox(
                               width: MediaQuery.of(context).size.width*0.17 ,
                               child: Text("First Pass by Pass"),



                             ),



                             SizedBox(
                               width:  MediaQuery.of(context).size.width*0.09,
                               height: 40,

                               child: TextField(
                                 controller: floweachstream,
                                 decoration: InputDecoration(
                                   border: OutlineInputBorder(),
                                 ),
                                 onChanged: (value) {
                                 },
                               ),

                             ),
                             SizedBox(width: MediaQuery.of(context).size.width*0.01,),

                             Text("m3/hr"),

                           ],
                         ),
                         SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                         //Flow of each stream
                         Row(
                           children: [
                             SizedBox(
                               width: MediaQuery.of(context).size.width*0.17 ,
                               child: Text("Recovery Second Pass"),



                             ),



                             SizedBox(
                               width:  MediaQuery.of(context).size.width*0.09,
                               height: 40,

                               child: TextField(
                                 controller: floweachstream,
                                 decoration: InputDecoration(
                                   border: OutlineInputBorder(),
                                 ),
                                 onChanged: (value) {
                                 },
                               ),

                             ),
                             SizedBox(width: MediaQuery.of(context).size.width*0.01,),

                             Text("m3/hr"),

                           ],
                         ),
                         SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                         //Flow of each stream
                         Row(
                           children: [
                             SizedBox(
                               width: MediaQuery.of(context).size.width*0.17 ,
                               child: Text("Feed Flow- Second Pass"),



                             ),



                             SizedBox(
                               width:  MediaQuery.of(context).size.width*0.09,
                               height: 40,

                               child: TextField(
                                 controller: floweachstream,
                                 decoration: InputDecoration(
                                   border: OutlineInputBorder(),
                                 ),
                                 onChanged: (value) {
                                 },
                               ),

                             ),
                             SizedBox(width: MediaQuery.of(context).size.width*0.01,),

                             Text("m3/hr"),

                           ],
                         ),
                         SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                         //Flow of each stream
                         Row(
                           children: [
                             SizedBox(
                               width: MediaQuery.of(context).size.width*0.17 ,
                               child: Text("Reject Flow- Second Pass"),



                             ),



                             SizedBox(
                               width:  MediaQuery.of(context).size.width*0.09,
                               height: 40,

                               child: TextField(
                                 readOnly: true,
                                 style: TextStyle(fontSize: 12),
                                 controller: floweachstream,
                                 decoration: InputDecoration(
                                   border: OutlineInputBorder(),
                                 ),
                                 onChanged: (value) {
                                 },
                               ),

                             ),
                             SizedBox(width: MediaQuery.of(context).size.width*0.01,),

                             Text("m3/hr"),

                           ],
                         ),

                       ],
                     ),
                   ),
                 ]
               ),
               Column(
                 children: [
                   Table(
                   border: TableBorder.all(),
      columnWidths: const <int, TableColumnWidth>{
        0: IntrinsicColumnWidth(),

        1: IntrinsicColumnWidth(),
        2: IntrinsicColumnWidth(),

      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: <TableRow>[
        TableRow(
          decoration: const BoxDecoration(
          ),
          children: <Widget>[
            Container(
                height: 30,
                child:Text("Flow Type")

            ),
            Container(
                height: 30,
                child:Text("Total Flow Calculation")
            ),
            Container(
                height: 30,

                child:Text("Flow Calculation/ stream")

            ),


          ],
        ),

        //Product flow

        TableRow(
          decoration: const BoxDecoration(
          ),
          children: <Widget>[
            Container(
                height: 30,
                child:Text("Product Flow")

            ),
            Container(
                height: 30,
                child:Row(
                  children: [
                    SizedBox(
                      width:  MediaQuery.of(context).size.width*0.09,
                      height: 50,
                      child: TextField(
                        readOnly: true,
                        controller: totalplantcapacityOutput,
                        style: TextStyle(fontSize: 12),

                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                        },
                      ),

                    ),
                    SizedBox(width: MediaQuery.of(context).size.width*0.01,),

                    Text("M3/hr"),
                  ],
                )
            ),
            Container(
                height: 30,

                child:Row(
                  children: [
                    SizedBox(
                      width:  MediaQuery.of(context).size.width*0.09,
                      height: 50,
                      child: TextField(
                        readOnly: true,
                        controller: singleproductflow,
                        style: TextStyle(fontSize: 12),

                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                        },
                      ),

                    ),
                    SizedBox(width: MediaQuery.of(context).size.width*0.01,),

                    Text("M3/hr"),
                  ],
                )

            ),


          ],
        ),

        //Feed Flow
        TableRow(
          decoration: const BoxDecoration(
          ),
          children: <Widget>[
            Container(
                height: 30,
                child:Text("Feed Flow")

            ),
            Container(
                height: 30,
                child:Row(
                  children: [
                    SizedBox(
                      width:  MediaQuery.of(context).size.width*0.09,
                      height: 50,
                      child: TextField(
                        readOnly: true,
                        controller: feedflow,
                        style: TextStyle(fontSize: 12),

                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                        },
                      ),

                    ),
                    SizedBox(width: MediaQuery.of(context).size.width*0.01,),

                    Text("M3/hr"),
                  ],
                )
            ),
            Container(
                height: 30,

                child:Row(
                  children: [
                    SizedBox(
                      width:  MediaQuery.of(context).size.width*0.09,
                      height: 50,
                      child: TextField(
                        readOnly: true,
                        controller: singlefeedflow,
                        style: TextStyle(fontSize: 12),

                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                        },
                      ),

                    ),
                    SizedBox(width: MediaQuery.of(context).size.width*0.01,),

                    Text("M3/hr"),
                  ],
                )

            ),


          ],
        ),
        //Reject Flow

        TableRow(
          decoration: const BoxDecoration(
          ),
          children: <Widget>[
            Container(
                height: 30,
                child:Text("Reject Flow")

            ),
            Container(
                height: 30,
                child:Row(
                  children: [
                    SizedBox(
                      width:  MediaQuery.of(context).size.width*0.09,
                      height: 50,
                      child: TextField(
                        readOnly: true,
                        controller: rejectflow,
                        style: TextStyle(fontSize: 12),

                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                        },
                      ),

                    ),
                    SizedBox(width: MediaQuery.of(context).size.width*0.01,),

                    Text("M3/hr"),
                  ],
                )
            ),
            Container(
                height: 30,

                child:Row(
                  children: [
                    SizedBox(
                      width:  MediaQuery.of(context).size.width*0.09,
                      height: 50,
                      child: TextField(
                        readOnly: true,
                        controller: singlerejectflow,
                        style: TextStyle(fontSize: 12),

                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                        },
                      ),

                    ),
                    SizedBox(width: MediaQuery.of(context).size.width*0.01,),

                    Text("M3/hr"),
                  ],
                )

            ),


          ],
        ),

      ],
    )
                 ],
               ),

             ],
           )




          ],
        ),
      ),
    );
  }
}


