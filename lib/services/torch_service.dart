import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart';

class TorchService{
  Future<void> turnOnTorch(BuildContext context) async{
    try{
      await TorchLight.enableTorch();
    } on Exception catch(_){
      _showErrorMes('Could not enable Flashlight', context);
    }
  }

  Future<void> turnOffTorch(BuildContext context) async{
    try{
      await TorchLight.disableTorch();
    } on Exception catch(_){
      _showErrorMes('Could not enable Flashlight', context);
    }
  }

  void _showErrorMes(String mes, BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mes)));
  }

}