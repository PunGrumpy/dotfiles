# Installation script for Jenkins
# https://jenkins.io/doc/book/installing/

# Color
WHITE='\033[0;37m'
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Check apt-transport-https, ca-certificates, curl, gnupg-agent, and software-properties-common are installed
if test ! $(which apt-transport-https)
then
    read -r answer -p "${RED}apt-transport-https is not installed, do you want to install it? (y/n)${NC}"
    if [ "$answer" = "y" ]; then
        sudo apt-get install apt-transport-https
        echo "${GREEN}apt-transport-https installed${NC}"
    fi
else
    echo "${GREEN}apt-transport-https is installed${NC}"
fi

if test ! $(which ca-certificates)
then
    read -r answer -p "${RED}ca-certificates is not installed, do you want to install it? (y/n)${NC}"
    if [ "$answer" = "y" ]; then
        sudo apt-get install ca-certificates
        echo "${GREEN}ca-certificates installed${NC}"
    fi
else
    echo "${GREEN}ca-certificates is installed${NC}"
fi

if test ! $(which curl)
then
    read -r answer -p "${RED}curl is not installed, do you want to install it? (y/n)${NC}"
    if [ "$answer" = "y" ]; then
        sudo apt-get install curl
        echo "${GREEN}curl installed${NC}"
    fi
else
    echo "${GREEN}curl is installed${NC}"
fi

if test ! $(which gnupg-agent)
then
    read -r answer -p "${RED}gnupg-agent is not installed, do you want to install it? (y/n)${NC}"
    if [ "$answer" = "y" ]; then
        sudo apt-get install gnupg-agent
        echo "${GREEN}gnupg-agent installed${NC}"
    fi
else
    echo "${GREEN}gnupg-agent is installed${NC}"
fi

if test ! $(which software-properties-common)
then
    read -r answer -p "${RED}software-properties-common is not installed, do you want to install it? (y/n)${NC}"
    if [ "$answer" = "y" ]; then
        sudo apt-get install software-properties-common
        echo "${GREEN}software-properties-common installed${NC}"
    fi
else
    echo "${GREEN}software-properties-common is installed${NC}"
fi

# Check for Java Runtime Environment (JRE) and Java Development Kit (JDK) version 11 or higher
# openjdk-11-jre-headless
if test ! $(which java)
then
    read -r answer -p "${RED}Java is not installed, do you want to install it? (y/n)${NC}"
    if [ "$answer" = "y" ]; then
        sudo apt update -y && sudo apt-get upgrade -y
        sudo apt-get install openjdk-11-jre-headless
        echo "${GREEN}Java (openjdk-11-jre-headless) installed${NC}"
    fi
else
    echo "${GREEN}Java is installed${NC}"
fi

# Check for Jenkins
if test ! $(which jenkins)
then
    # ask before install
    read -r answer -p "${RED}Jenkins is not installed, do you want to install it? (y/n)${NC}"
    if [ "$answer" = "y" ]; then
        # Install the correct Jenkins for each OS type
        if test "$(uname)" = "Darwin"
        then
            brew install jenkins
            echo "${GREEN}Jenkins installed${NC}"
        elif test "$(expr substr $(uname -s) 1 5)" = "Linux"
        then
            wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
            sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
            sudo apt-get update
            sudo apt-get install jenkins
            echo "${GREEN}Jenkins installed${NC}"
        fi
    fi       
else
    echo "${GREEN}Jenkins is installed${NC}"
fi

# Update filewall to enable port Jenkins services and ask before update
read -r answer -p "${RED}Do you want to update the firewall to enable port Jenkins services? (y/n)${NC}"
if [ "$answer" = "y" ]; then
    sudo ufw enable
    sudo ufw allow 8080
    sudo ufw status
    echo "${GREEN}Firewall updated${NC}"
fi

echo "${GREEN}Jenkins installation completed${NC}"