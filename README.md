#Carthage Workarounds
Shell scripts to make life a little easier when using Carthage.

##carthage-build.sh
Workaround for Carthage to avoid rebuilding all your dependencies every time you want to add a new one to your Cartfile.

- [x] Builds a single dependency using Carthage and merges it the existing ones.
- [x] Updates your Cartfile with the new dependency.

##Usage

```bash
./carthage-build.sh --dependency 'github "ruipfcosta/SwiftyWalkthrough"'
```

The default carthage command used to build the dependencies is ```carthage update --no-use-binaries --platform iOS```. If that doesn't suit your needs you can specify the command when running the script:

```bash
./carthage-build.sh --dependency 'github "ruipfcosta/SwiftyWalkthrough"' --command "carthage update"
```

For a more permanent solution you can simply edit the script and change the variable ```DEFAULT_COMMAND```.

