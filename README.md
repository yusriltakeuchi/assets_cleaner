# Assets Cleaner

A command-line tool wich helps you to clean your assets folder. It will remove all files that are not used in your project. You can choose to remove all files or just to see which files are not being used.
This tool support for any assets extensions from your [assets] folder. But you must specify which folder you want to clean.

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
[![Scan Unsed Assets](https://i.ibb.co/KzqpwTh/Assets-Cleaner-Unused.png)](https://i.ibb.co/KzqpwTh/Assets-Cleaner-Unused.png)
```shell
$ assets_cleaner unused
```

#### Scanning all unused assets from your project and remove it
[![Scan Unsed Assets And Clean](https://i.ibb.co/s27R1tZ/Assets-Cleaner-Clean.png)](https://i.ibb.co/s27R1tZ/Assets-Cleaner-Clean.png)
```shell
$ assets_cleaner clean
```
