import 'package:flutter/material.dart';
import 'package:yaml/yaml.dart';

class Config {
  static dynamic yamlFile;

  static createConfig(BuildContext context) async {
    yamlFile = await loadAsset(context);
    return Config();
  }

  static Future<dynamic> loadAsset(BuildContext context) async {
    final yamlString = await DefaultAssetBundle.of(context)
        .loadString('assets/craft_dynamic.yaml');
    return loadYaml(yamlString);
  }
}
