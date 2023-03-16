!/bin/bash
curl -q https://raw.githubusercontent.com/massbitprotocol/zesty/feature/cron-job/version -o VERSION_INFO

# check Zesty + Juicy + SSL production tag

while IFS='=' read -r key value; do
  echo "Key: $key"
  echo "Value: $value"

    case $key in
    "ZESTY")
        # statements for pattern1
        ;;
    "JUICY")
        # statements for pattern2
        ;;
    "SSL")
        ;;
    *)
        ;;
    esac



done < VERSION_INFO

