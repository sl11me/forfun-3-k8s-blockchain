#!/bin/bash

# Script to generate Kubernetes manifests from templates
# Usage: ./scripts/generate-manifests.sh [values-file]

set -e

# Default values file
VALUES_FILE="${1:-values.yaml}"
TEMPLATES_DIR="k8s-templates"
OUTPUT_DIR="k8s"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🔧 Generating Kubernetes manifests from ${VALUES_FILE}${NC}"

# Check if values file exists
if [ ! -f "$VALUES_FILE" ]; then
    echo -e "${RED}❌ Values file $VALUES_FILE not found!${NC}"
    echo -e "${YELLOW}💡 Copy values.yaml to values-local.yaml and modify as needed${NC}"
    exit 1
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Function to replace variables in a template
replace_vars() {
    local template_file="$1"
    local output_file="$2"
    
    # Read values from YAML file and create env vars
    eval $(python3 -c "
import yaml
import sys

with open('$VALUES_FILE', 'r') as f:
    values = yaml.safe_load(f)

def flatten_dict(d, parent_key='', sep='_'):
    items = []
    for k, v in d.items():
        new_key = parent_key + sep + k if parent_key else k
        if isinstance(v, dict):
            items.extend(flatten_dict(v, new_key, sep=sep).items())
        else:
            items.append((new_key.upper(), v))
    return dict(items)

flat_values = flatten_dict(values)
for k, v in flat_values.items():
    print(f'export {k}=\"{v}\"')
")
    
    # Replace variables in template
    envsubst < "$template_file" > "$output_file"
    echo -e "${GREEN}✅ Generated $output_file${NC}"
}

# Generate manifests from templates
if [ -d "$TEMPLATES_DIR" ]; then
    for template in "$TEMPLATES_DIR"/*.yaml.template; do
        if [ -f "$template" ]; then
            filename=$(basename "$template" .template)
            replace_vars "$template" "$OUTPUT_DIR/$filename"
        fi
    done
else
    echo -e "${YELLOW}⚠️  Templates directory not found. Creating basic manifests...${NC}"
    
    # Generate basic manifests with variables
    namespace_name=$(python3 -c "import yaml; print(yaml.safe_load(open('$VALUES_FILE'))['namespace']['name'])")
    
    # Generate namespace
    cat > "$OUTPUT_DIR/00-namespace.yaml" << EOF
apiVersion: v1
kind: Namespace
metadata:
  name: $namespace_name
EOF
    
    echo -e "${GREEN}✅ Generated basic manifests${NC}"
fi

echo -e "${GREEN}🎉 Manifest generation complete!${NC}"
echo -e "${YELLOW}📝 Review the generated files in $OUTPUT_DIR/ before applying${NC}"
