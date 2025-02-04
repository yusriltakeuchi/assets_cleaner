# Assets Cleaner
[![pub package](https://img.shields.io/pub/v/assets_cleaner.svg)](https://pub.dev/packages/assets_cleaner)

A command-line tool wich helps you to clean your assets folder. It will remove all files that are not used in your project. You can choose to remove all files or just to see which files are not being used.
This tool support for any assets extensions from your [assets] folder. It will automatically detect the asset location from pubspec.yaml.
In the new version, we add a new feature to scan unused library in your project. You can use the command `scanlib` to scan and remove all unused dependencies from your project.

## :book: Guide

### 1. Installation
#### Pub Global
Works with macOS, Linux and Windows.
    
```shell
$ dart pub global activate assets_cleaner
```

### 2. Setup the config file (Optional for scanlib command)

Run the initialization command to create the config file. This command will create a file named `assets_cleaner.yaml` in your project root directory.

```shell
$ assets_cleaner init
```

After that, you can edit the config file to exclude some files or extensions that you don't want to be scanned.
An example is shown below.

```yaml
config:
  # If you want to exclude specific
  # extension
  exclude-extension:
  #  - jpg # Uncomment this if you want to use
  #  - png # Uncomment this if you want to use

  # If you want to exclude specific
  # file from assets
  exclude-file:
  #  - /assets/images/banner_upgrade.png # Uncomment this if you want to use
  #  - /assets/images/logo.png # Uncomment this if you want to use
  # Support GLOB
  #  - /assets/images/**
  #  - /assets/icons/**.jpg
  #  - /assets/icons/logo/**.png
  #  - /assets/icons/items/child/**
  #  - /assets/sound/**/**.mp3
```

## :rocket: Usage

After setting up the configuration, you can run the package by running the following command:

#### 1. Scanning all unused assets from your project
<img src="https://raw.githubusercontent.com/yusriltakeuchi/assets_cleaner/master/images/image_unused.png" width="400">

```shell
$ assets_cleaner unused
```

#### 2. Scanning all unused assets from your project and remove it
<img src="https://raw.githubusercontent.com/yusriltakeuchi/assets_cleaner/master/images/image_clean.png" width="400">

```shell
$ assets_cleaner clean
```

#### 3. Scanning all unused assets and move into trash folder
<img src="https://raw.githubusercontent.com/yusriltakeuchi/assets_cleaner/master/images/image_trash.png" width="400">

```shell
$ assets_cleaner trash
```

#### 4. Scan and remove all unused dependencies from your project
<img src="https://raw.githubusercontent.com/yusriltakeuchi/assets_cleaner/master/images/image_scanlib.png" width="400">

```shell
$ assets_cleaner scanlib
```
You can also use fast command without type any prompt
```shell
$ assets_cleaner scanlib -f
or 
$ assets_cleaner scanlib --fast
```

## :star: Contributing
If you wish to contribute a change to any of the existing plugins in this repo, please fork the repo and submit a pull request. If you have any questions, please open an issue.