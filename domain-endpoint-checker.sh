#!/bin/bash

# Define color variables
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Function to display usage information and help menu
function display_help {
    echo "Usage: $0 <file or domain> [<endpoint>]"
    echo "Examples:"
    echo "  $0 domains.txt"
    echo "  $0 example.com"
    echo "  $0 example.com .htaccess"
    echo ""
    echo "Options:"
    echo "  -h, -help       Display this help menu"
}

# Check if help flag is present
if [[ "$1" == "-h" || "$1" == "-help" ]]; then
    display_help
    exit 0
fi

# Check if the first argument is provided
if [[ -z "$1" ]]; then
    echo -e "${RED}Error:${NC} Missing argument"
    display_help
    exit 1
fi

# Check if the first argument is a file or a single domain
if [[ -f "$1" ]]; then
    domains=$(sort -u "$1")
else
    domains="$1"
fi

# Check if the endpoint argument is provided, otherwise use the default ".git/config"
endpoint="${2:-.git/config}"

# Initialize an array to store final URLs with status code 200
final_urls=()

# Loop through each domain and check status code and final URL
for domain in $domains; do
    echo -e "${YELLOW}Checking $domain ...${NC}"
    response=$(curl --max-time 3 -sL -w "%{http_code} %{url_effective}\\n" "$domain/$endpoint" -o /dev/null)
    if [ $? -ne 0 ]; then
        echo -e "  ${RED}Timed out${NC}"
        continue
    fi
    code=$(echo "$response" | awk '{print $1}')
    url=$(echo "$response" | awk '{print $2}')
    case $code in
        200)
            echo -e "  ${GREEN}Status code: $code${NC}"
            echo -e "  ${GREEN}Final URL: $url${NC}"
            echo -e "  ${YELLOW}Response body:${NC}"
            curl -sL "$domain/$endpoint" | head -n 5
            final_urls+=("$url")
            ;;
        301 | 302)
            redirect_url=$(curl -sLI -o /dev/null -w '%{url_effective}' "$domain/$endpoint")
            echo -e "  ${YELLOW}Status code: $code${NC}"
            echo -e "  ${YELLOW}Redirect From: $url${NC}"
            echo -e "  ${YELLOW}Redirect To: $redirect_url${NC}"
            ;;
        404)
            echo -e "  ${RED}Status code: $code${NC}"
            ;;
        *)
            echo -e "  ${YELLOW}Status code: $code${NC}"
            ;;
    esac
done

# Print table of final URLs with status code 200
echo ""
echo -e "${YELLOW}Final URLs:${NC}"
echo -e "-----------"
for url in "${final_urls[@]}"; do
    echo -e "${GREEN}$url${NC}"
done

# Ask the user if they want to save final URLs to a file
read -p "$(echo -e "${YELLOW}Save final URLs to a file? [y/n]${NC} ")" save
if [[ "$save" == "y" ]]; then
    read -p "$(echo -e "${YELLOW}Enter the filename: ${NC}")" filename
    echo -e "${GREEN}Saving final URLs to file: $filename${NC}"
    printf "%s\n" "${final_urls[@]}" > "$filename"
    echo -e "${GREEN}File saved successfully.${NC}"
else
    echo -e "${YELLOW}Final URLs not saved.${NC}"
fi
