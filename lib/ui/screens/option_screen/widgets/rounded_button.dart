import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:robs_currency_calculator/bloc/bloc.dart';
import 'package:robs_currency_calculator/theme/colors.dart';


class RoundedButton extends StatelessWidget {
  const RoundedButton({this.function});

  final Function function;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
      if (state is FetchSettingsState) {
        return Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: SizedBox(
            height: 30.0,
            width: 100.0,
            child: Material(
              shape: const StadiumBorder(),
              textStyle: Theme.of(context).textTheme.button,
              elevation: 6.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        BlocProvider.of<SoundsBloc>(context).add(PlayClickDouble());
                        function(state.settings.decimalPlaces--);
                        if (state.settings.decimalPlaces < 0) {
                          state.settings.decimalPlaces = 0;
                        }
                        BlocProvider.of<SettingsBloc>(context).add(ChangeSettingsEvent(state.settings));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: accentGray,
                            border: Border.all(color: accentWhite),
                            borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(6),
                            )),
                        child: const Icon(
                          Icons.remove,
                          color: accentWhite,
                          size: 30.0,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        BlocProvider.of<SoundsBloc>(context).add(PlayClickDouble());
                        function(state.settings.decimalPlaces++);
                        if (state.settings.decimalPlaces > 10) {
                          state.settings.decimalPlaces = 10;
                        }
                        BlocProvider.of<SettingsBloc>(context).add(ChangeSettingsEvent(state.settings));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: accentGray,
                            border: Border.all(color: accentWhite),
                            borderRadius: const BorderRadius.horizontal(
                                right: Radius.circular(6))),
                        child: const Icon(
                          Icons.add,
                          color: accentWhite,
                          size: 30.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
      return Container();
    });
  }
}
