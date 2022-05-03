#!/bin/bash

SG_ID="__SECURITY_GROUP_ID__"
SG_DESCRIPTION="__SECURITY_GROUP_RULE_DESCRIPTION__"
AWS_PROFILE="__AWS_PROFILE__"
PORT=22
AWS_CLI_PATH=$(command -v aws)
CURL_PATH=$(command -v curl)

cat << "EOF"
      __          _______                 _        _____  _____ 
     /\ \        / / ____|     /\        | |      / ____|/ ____|
    /  \ \  /\  / / (___      /  \  _   _| |_ ___| (___ | |  __ 
   / /\ \ \/  \/ / \___ \    / /\ \| | | | __/ _ \\___ \| | |_ |
  / ____ \  /\  /  ____) |  / ____ \ |_| | || (_) |___) | |__| |
 /_/    \_\/  \/  |_____/  /_/    \_\__,_|\__\___/_____/ \_____|

                           by: Ardd

EOF


GET_IP=$(curl -s https://checkip.amazonaws.com)
GET_IP_CIDR=$GET_IP/32

params () {
    echo "----------------------------------------------------"
    printf "AWS PROFILE: $AWS_PROFILE\n"
    printf "Your IP: $GET_IP_CIDR\n"
    printf "Security Rule Description: $SG_DESCRIPTION\n"
    printf "Security Group ID: $SG_ID\n"
    printf "Port set: $PORT\n"
    echo -e "----------------------------------------------------\n"
}

main () {
    OLD_CIDR=$(aws ec2 describe-security-groups --group-ids $SG_ID --query "SecurityGroups[*].IpPermissions[*].IpRanges[?Description=='$SG_DESCRIPTION'].CidrIp" --output text --profile $AWS_PROFILE)

    if [[ $OLD_CIDR != "" ]] && [[ $OLD_CIDR != $GET_IP_CIDR ]]; then
        printf "New IP $GET_IP_CIDR is not equal with old IP set in SG $SG_ID - $OLD_CIDR \nRevoking old rule now...\n"
        aws ec2 revoke-security-group-ingress --group-id $SG_ID --protocol tcp --port $PORT --cidr $OLD_CIDR --profile $AWS_PROFILE > /dev/null 2>&1
        printf "Old rule is revoked!\n\nSetting up new rule with Source IP: $GET_IP_CIDR for port $PORT"
    fi

    if [[ $GET_IP != "" ]] && [[ $OLD_CIDR != $GET_IP_CIDR ]]; then
        aws ec2 authorize-security-group-ingress --group-id $SG_ID --ip-permissions IpProtocol=tcp,FromPort=$PORT,ToPort=$PORT,IpRanges="[{CidrIp=$GET_IP_CIDR,Description='$SG_DESCRIPTION'}"] --profile $AWS_PROFILE > /dev/null 2>&1 \
        && printf "\nSG rule is applied successfully! \n" || printf "\nFailed to apply rule!"
    fi

    if [[ $GET_IP_CIDR == $OLD_CIDR ]]; then
        printf "Your IP $GET_IP_CIDR is already whitelisted !\n"
    fi
}
if [[ ! -x $AWS_CLI_PATH || ! -x $CURL_PATH ]]; then
    echo "You do not have aws cli or curl installed !" 
    exit 0
else
    params
    echo -e "Everything set! \nStarting now..."
    main
fi