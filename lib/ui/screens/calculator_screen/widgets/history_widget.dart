import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:robs_currency_calculator/bloc/bloc.dart';
import 'package:robs_currency_calculator/i18n/app_localization.dart';
import 'package:robs_currency_calculator/models/history_element_model.dart';
import 'package:robs_currency_calculator/theme/colors.dart';
import 'package:robs_currency_calculator/ui/screens/calculator_screen/actions/calculator_screen_actions.dart';
import 'package:robs_currency_calculator/ui/screens/calculator_screen/widgets/history_element_widget.dart';
import 'package:robs_currency_calculator/utils/email_sender.dart';
import 'package:robs_currency_calculator/utils/ShowToastComponent.dart';


//widget, which display history of calculations
class HistoryWidget extends StatefulWidget {
  const HistoryWidget({Key key, this.onTap, this.height,
    this.historyElementHeight}): super(key: key);

  final double height;
  final double historyElementHeight;
  final Function() onTap;

  @override
  HistoryWidgetState createState() => HistoryWidgetState();
}

class HistoryWidgetState extends State<HistoryWidget> with CalculatorScreenActions {

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  static List<HistoryElementModel> history = [];
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context).translate;
    return Container(
      color: accentBlack,
      height: widget.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top +  40,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  icon: const Icon(Icons.delete_forever, color: accentWhite,),
                  onPressed:(){
                    showDialog(
                        builder: (BuildContext ctx) {
                          return CupertinoAlertDialog(
                            title: Text(translate('CLEAR_TAPE_TITLE')),
                            content: Text(translate('CLEAR_TAPE_MESSAGE')),
                            actions: <Widget>[
                              CupertinoDialogAction(
                                isDefaultAction: true,
                                onPressed: (){
                                  Navigator.pop(context);
                                },
                                child: Text(translate('CANCEL')),
                              ),
                              CupertinoDialogAction(
                                isDefaultAction: true,
                                onPressed: ()  {
                                  removeAllHistoryItems(context);
                                  Navigator.pop(context);
                                },
                                child: Text(translate('CLEAR')),
                              ),
                            ],
                          );
                        },
                        context: context,);
                        //child:  );
                   }
              ),
              Text(
                translate('HISTORY'),
                style: Theme.of(context).primaryTextTheme.headline4,
              ),
              IconButton(
                  icon: const Icon(Icons.email, color: accentWhite),
                  onPressed: (){
                    final EmailSender emailSender = EmailSender(
                      emailBody: createEmailBody(),
                      emailSubject: 'Settlement history from Wedge'
                    );
                    String response = '';
                    emailSender.sendEmail().then((value){
                      response = value;
                      if (response != '' && response != 'success'){
                        showDialog(
                            context: context,
                            builder: (BuildContext ctx) {
                              return  CupertinoAlertDialog(
                                title: Text(translate('COULDNT_SEND_EMAIL_TITLE')),
                                content: Text(translate('COULDNT_SEND_EMAIL_MESSAGE')),
                                actions: <Widget>[
                                  CupertinoDialogAction(
                                    isDefaultAction: true,
                                    onPressed: (){
                                      Navigator.pop(context);
                                    },
                                    child: Text(translate('CANCEL')),
                                  ),
                                ],
                              );
                            },);
                          //  child: );
                      }
                    });
                  }
                  )

          ],),
          const SizedBox(height: 30,),
          const Spacer(),
          GestureDetector(
            onTap: widget.onTap,
            child: Container(
              color: accentBlack,
              height: widget.height - MediaQuery.of(context).padding.top - 120,
              child: AnimatedList(
                key: listKey,
                reverse: true,
                initialItemCount: history.length,
                itemBuilder: (context, index, animation) {
                  return sizeIt(context, index, animation);
                },
              )
            ),
          )
        ],
      ),
    );
  }

  //animation for removing element from list
  Widget slideIt(BuildContext context, int index, Animation<double> animation ) {
    return SlideTransition(
      position:
      Tween<Offset>(
        begin: const Offset(-1, 0),
        end: const Offset(0, 0),
      ).animate(animation),
      child: history.isNotEmpty
              ? HistoryElementWidget(
                  height: widget. historyElementHeight,
                  model: history[index],
                )
              : Container()
        );
  }

  //animation for adding element to list
  Widget sizeIt(BuildContext context, int index,Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: HistoryElementWidget(
        height: widget. historyElementHeight,
        model: history[index],
      ),
    );
  }

  void addHistoryItem(HistoryElementModel item){

    listKey.currentState.insertItem(0,
        duration: const Duration(milliseconds: 310));
    history = [item, ...history];
  }

  void removeHistoryItem(BuildContext context){
    listKey.currentState.removeItem(
        0, (_, animation) => slideIt(context, 0, animation),
        duration: const Duration(milliseconds: 400));
    history.removeAt(0);
  }

  String createEmailBody(){
    final buffer = StringBuffer();
    for(int i = 0; i < history.length; i++){
      buffer.write('${history[i]?.day} ${history[i]?.month} \n ${history[i]?.upperString} \n ${history[i]?.calculationsString} \n ${history[i]?.loverString} \n \n ');
       }
    return buffer.toString();
  }

  Future<void> removeAllHistoryItems(BuildContext context) async {
    final int listSize = history.length;
    for (int i=0; i<listSize ; i++){
      removeHistoryItem(context);
      BlocProvider.of<SoundsBloc>(context).add(PlaySnip());
      await Future.delayed(const Duration(milliseconds: 200));
    }
    counter = 0;
  }
}
