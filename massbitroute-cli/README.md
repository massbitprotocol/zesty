Run `strip -s <file>` after build to reduce the size of binary file

1. How to build? (prod | uat)
```
sh build.sh <env> linux amd64
```
For detail os and architecture, check here https://www.digitalocean.com/community/tutorials/how-to-build-go-executables-for-multiple-platforms-on-ubuntu-16-04#step-4-building-executables-for-different-architectures

2. Load environment dynamically: cLI will read config from environment variable `MBR_CONFIG_FILE`, if don't exist, it will use the default config inside the binary
```
export MBR_CONFIG_FILE=~/.mbr
```
