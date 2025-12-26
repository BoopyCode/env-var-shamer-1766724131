#!/bin/bash

# ENV Var Shamer - Because your API keys deserve better than public humiliation
# Usage: ./env-shamer.sh [directory]

# Colors for maximum shame visibility
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Common sensitive patterns (your secrets are NOT special snowflakes)
PATTERNS=(
    "API_KEY"
    "SECRET"
    "PASSWORD"
    "TOKEN"
    "PRIVATE"
    "DATABASE_URL"
    "AWS_"
    "GITHUB_TOKEN"
    "STRIPE"
    "CRYPTO"
    "ENCRYPT"
)

# The main shaming function
shame_check() {
    local dir="${1:-.}"
    local shame_count=0
    
    echo -e "${YELLOW}🔍 Scanning for shameful env vars...${NC}"
    echo -e "${YELLOW}📁 Directory: $dir${NC}"
    echo ""
    
    # Find all .env* files and shame them appropriately
    while IFS= read -r -d '' file; do
        echo -e "${GREEN}Checking: $file${NC}"
        
        for pattern in "${PATTERNS[@]}"; do
            # Grep for the pattern, but be nice about it
            matches=$(grep -i "$pattern" "$file" 2>/dev/null | grep -v "^#" | grep -v "^$")
            
            if [[ -n "$matches" ]]; then
                shame_count=$((shame_count + 1))
                echo -e "${RED}  ⚠️  SHAME DETECTED! Pattern: $pattern${NC}"
                echo "$matches" | sed 's/^/    /'
                echo ""
            fi
        done
    done < <(find "$dir" -name ".env*" -type f -print0 2>/dev/null)
    
    # Final verdict
    echo "========================================"
    if [[ $shame_count -eq 0 ]]; then
        echo -e "${GREEN}✅ No shame detected! Your secrets are safe (for now).${NC}"
    else
        echo -e "${RED}🔥 $shame_count potential security shames found!${NC}"
        echo -e "${YELLOW}💡 Remember: .env files belong in .gitignore, not GitHub!${NC}"
        exit 1  # Exit with error for CI/CD integration
    fi
}

# Help text for the clueless
show_help() {
    echo "ENV Var Shamer - Finds potential secrets before they embarrass you"
    echo "Usage: $0 [directory]"
    echo "       $0              (scans current directory)"
    echo "       $0 /some/path   (scans specified directory)"
}

# Main execution with basic argument parsing
case "$1" in
    "-h"|"--help"|"help")
        show_help
        ;;
    *)
        shame_check "$1"
        ;;
esac
