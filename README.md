# Assets Cleaner

A command-line tool wich helps you to clean your assets folder. It will remove all files that are not used in your project. You can choose to remove all files or just to see which files are not being used.
This tool support for any assets extensions from your [assets] folder. It will automatically detect the asset location from pubspec.yaml

## :book: Guide

### 1. Installation
#### Pub Global
Works with macOS, Linux and Windows.
    
```shell
$ dart pub global activate assets_cleaner
```

### 2. Setup the config file

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
```

## :rocket: Usage

After setting up the configuration, you can run the package by running the following command:

#### Scanning all unused assets from your project
[![Scan Unsed Assets](https://i.ibb.co/xXXgpy0/Assets-Cleaner-Unused.png)](https://i.ibb.co/xXXgpy0/Assets-Cleaner-Unused.png)
```shell
$ assets_cleaner unused
```

#### Scanning all unused assets from your project and remove it
[![Scan Unsed Assets And Clean](https://i.ibb.co/L0CK6C6/Assets-Cleaner-Clean.png)](https://i.ibb.co/L0CK6C6/Assets-Cleaner-Clean.png)
```shell
$ assets_cleaner clean
```
## :warning: Supporting Issue
These tools may not work properly if you use an asset generator like flutter_gen or similar. Because our tools will still detect that your Assets are used, even if these variables are not used in the code

## :star: Contributing
If you wish to contribute a change to any of the existing plugins in this repo, please fork the repo and submit a pull request. If you have any questions, please open an issue.