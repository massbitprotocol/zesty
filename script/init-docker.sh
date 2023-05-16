mbr login -t $TOKEN
# mbr gateway run --id=${GW_ID} --ip=${GW_IP}
mbr gateway run --id=${GW_ID} --ip=$(curl ifconfig.me)
