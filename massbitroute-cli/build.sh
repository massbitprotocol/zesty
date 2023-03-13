echo "Build for $1 env"
go build -tags $1
strip -s ./mbr