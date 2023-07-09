# Domain-Endpoint-Checker

The "Domain Endpoint Checker" is a command-line tool that helps you check the status codes and final URLs of multiple domains or a single domain.
Usage


     ./domain-endpoint-checker.sh <file or domain> [<endpoint>]

Examples:

     ./domain-endpoint-checker.sh domains.txt
     ./domain-endpoint-checker.sh example.com
     ./domain-endpoint-checker.sh example.com .htaccess

Options:

    -h, -help: Display the help menu.

:floppy_disk: Installation

    git clone https://github.com/your-username/domain-endpoint-checker.git

  Navigate to the project directory

    cd domain-endpoint-checker

:rocket: Getting Started

  Run the script and provide the necessary arguments.

  Enjoy checking the status codes and final URLs of your domains!

:clipboard: Features
    Check status codes and final URLs of multiple domains or a single domain.
    Supports both file input and direct input of a domain.
    Color-coded output for easy identification.
    Option to save final URLs with status code 200 to a file.

:warning: Requirements

    Bash
    cURL
    chmod +x domain-endpoint-checker.sh

    
:bulb: Tips

    Use the -h or -help option to display the help menu and usage information.
