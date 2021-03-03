import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:robs_currency_calculator/models/settings_model.dart';
import 'package:robs_currency_calculator/utils/local_storage.dart';
import 'package:soundpool/soundpool.dart';

part 'sounds_event.dart';
part 'sounds_state.dart';

class SoundsBloc extends Bloc<SoundsEvent, SoundsState> {
  SoundsBloc() : super(SoundsInitial());

  final Soundpool _soundPool = Soundpool(streamType: StreamType.notification, maxStreams: 7);
  SettingsModel settings;

  int pop;
  int popQuiet;
  int polaroid;
  int clickSharp;
  int clickInOut;
  int clickDouble;
  int snip;

  @override
  Stream<SoundsState> mapEventToState(SoundsEvent event) async* {
    if (event is LoadSounds){
      await loadSounds();
    }

    if (event is DisposeSounds){
      _soundPool.dispose();
    }

    if (event is PlayPop){
      _playSound(pop);
    }

    if (event is PlayPopQuiet){
      _playSound(popQuiet);
    }

    if (event is PlayPolaroid){
      _playSound(polaroid);
    }

    if (event is PlayClickSharp){
      _playSound(clickSharp);
    }

    if (event is PlayClickInOut){
      _playSound(clickInOut);
    }

    if (event is PlayClickDouble){
      _playSound(clickDouble);
    }

    if (event is PlaySnip){
      _playSound(snip);
    }
  }

  Future<void> _playSound(int soundId) async {
    if (soundId != null && globalSettings.soundsEnabled){
      await _soundPool.play(soundId);
    }
  }

  Future<void> loadSounds() async {
    pop ??= await _soundPool.load(await rootBundle.load('assets/sounds/pop.wav'));
    // _soundPool.setVolume(soundId:  pop, volume: volume);

    popQuiet ??= await _soundPool.load(await rootBundle.load('assets/sounds/pop_quiet.wav'));
    // _soundPool.setVolume(soundId:  popQuiet, volume: volume);

    polaroid ??= await _soundPool.load(await rootBundle.load('assets/sounds/polaroid.wav'));
    // _soundPool.setVolume(soundId:  polaroid, volume: volume);

    clickSharp ??= await _soundPool.load(await rootBundle.load('assets/sounds/pop.wav'));
    // _soundPool.setVolume(soundId:  clickSharp, volume: volume);

    clickInOut ??= await _soundPool.load(await rootBundle.load('assets/sounds/click_in_out.wav'));
    // _soundPool.setVolume(soundId:  clickInOut, volume: volume);

    clickDouble ??= await _soundPool.load(await rootBundle.load('assets/sounds/click_double.wav'));
    // _soundPool.setVolume(soundId:  clickDouble, volume: volume);

    snip ??= await _soundPool.load(await rootBundle.load('assets/sounds/snip.wav'));
    // _soundPool.setVolume(soundId:  snip, volume: volume);
  }
}