# aws-auto-sg
```   
      __          _______                 _        _____  _____ 
     /\ \        / / ____|     /\        | |      / ____|/ ____|
    /  \ \  /\  / / (___      /  \  _   _| |_ ___| (___ | |  __ 
   / /\ \ \/  \/ / \___ \    / /\ \| | | | __/ _ \\___ \| | |_ |
  / ____ \  /\  /  ____) |  / ____ \ |_| | || (_) |___) | |__| |
 /_/    \_\/  \/  |_____/  /_/    \_\__,_|\__\___/_____/ \_____|

 ```

Automatically add/update ingress rule in AWS security group

# 🚩 Pre-requisites

 - awscli (if not, install [here](https://aws.amazon.com/cli/) and configure aws profile)
 - curl (`apt-get install curl` / `brew install curl`)

# ⚙️ Setup

Clone the repo 
`git clone https://github.com/arddluma/aws-auto-sg.git`

You have to have installed awscli with valid credentials!
**Make sure you have properly set default region using aws configure command or export as variable like this:**
e.g `export AWS_DEFAULT_PROFILE=eu-central-1`

Edit `magic.sh` as following:
- line 3 `SG_ID` add correct security group rule ID `sg-xxxxxxxxxxxxxx`.
- line 4 `SG_DESCRIPTION` add proper security group rule description. e.g `Office Access port 22`
  ***(Note description has to be unique because script queries based on description set!)***
- line 5 `AWS_PROFILE` add AWS profile configured.
- line 6 `PORT` set port you want to whitelist e.g `22`.

# 🚀 Usage

```
    chmod +x magic.sh
    ./magic.sh
```

# 📖 What is covered

- First time applying the rule
- If your IP changes, it will update the rule with new IP
- If your IP has not changed and you try to re-create same rule it shows that rule exist and IP is  already whitelisted.

# ❤️ Contribution

Feel free to fork the repo and create a PR!