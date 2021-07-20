import 'package:flutter/material.dart';
import 'package:victim_app/Assistants/assistantMethods.dart';
import 'package:victim_app/Models/history.dart';

class HistoryItem extends StatelessWidget
{
  final History history;
  HistoryItem({this.history});

  @override
  Widget build(BuildContext context)
  {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Container(
                child: Row(
                  children: <Widget>[

                    Image.asset('images/pickicon.png', height: 16, width: 16,),
                    SizedBox(width: 18,),
                    Expanded(child: Container(child: Text(history.pickupAddress, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 18),))),
                    SizedBox(width: 5,),

                    Text('\Ksh.${history.charges}', style: TextStyle(fontFamily: 'Poppins-Bold', fontSize: 16, color: Colors.black87),),
                  ],
                ),
              ),

              SizedBox(height: 8,),

              Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Image.asset('images/desticon.png', height: 16, width: 16,),
                  SizedBox(width: 18,),

                  Text(history.dropoffAddress, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 18),),
                ],
              ),

              SizedBox(height: 15,),

              Text(AssistantMethods.formatTripDate(history.timeCreated), style: TextStyle(color: Colors.grey),),
            ],
          ),
        ],
      ),
    );
  }
}
