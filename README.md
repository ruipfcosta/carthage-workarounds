#Carthage Workarounds
Shell scripts to make life a little easier when using Carthage.

Check my article [Saving precious time when building Carthage dependencies](https://medium.com/@ruipfcosta/saving-precious-time-when-building-carthage-dependencies-486225eb93ca#.74ucnxgj2).

##carthage-build.sh
Workaround for Carthage to avoid rebuilding all your dependencies every time you want to add a new one to your Cartfile.

- [x] Builds a single dependency using Carthage and merges it with the existing ones.
- [x] Updates your Cartfile with the new dependency.

![carthage-build.sh demo](https://raw.githubusercontent.com/ruipfcosta/carthage-workarounds/master/extras/carthage-build.gif)

##Usage

Run carthage-build from the same directory where you have your Cartfile/Carthage directory:

```bash
./carthage-build.sh --dependency 'github "ruipfcosta/SwiftyWalkthrough"'
```

The default carthage command used to build the dependencies is ```carthage update --no-use-binaries --platform iOS```. If that doesn't suit your needs you can specify the command when running the script:

```bash
./carthage-build.sh --dependency 'github "ruipfcosta/SwiftyWalkthrough"' --command "carthage update"
```

For a more permanent solution you can simply edit the value of the variable ```DEFAULT_COMMAND```.

## Credits

Owned and maintained by Rui Costa ([@ruipfcosta](https://twitter.com/ruipfcosta)). 

## Contributing

Bug reports and pull requests are welcome.

## License

Carthage-Workarounds is released under the MIT license. See LICENSE for details.
