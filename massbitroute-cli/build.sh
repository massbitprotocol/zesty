echo "Build for $1 env, os $2, architecture $3"
env GOOS=$2 GOARCH=$3 go build -tags $1
strip -s ./mbr