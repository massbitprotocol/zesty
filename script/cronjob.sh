!/bin/bash
curl -q https://raw.githubusercontent.com/massbitprotocol/zesty/feature/cron-job/version -o VERSION_INFO

# check Zesty + Juicy + SSL production tag

while IFS='=' read -r key value; do
  echo "Key: $key"
  echo "Value: $value"

    case $key in
    "ZESTY")
        bash update-zesty.sh
        ;;
    "JUICY")
        bash update-juicy.sh
        ;;
    "SSL")
        ;;
    *)
        ;;
    esac



done < VERSION_INFO

