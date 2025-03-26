#!/bin/bash

CONFIG_FILE="/usr/src/app/conf/local.yml"
MAGMA_PATH="/usr/src/app/plugins/magma"

# Ensure custom local.yml is generated per container
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Generating new local.yml using Caldera's built-in method..."
    python3 -c "import app; import app.utility.config_generator; app.utility.config_generator.ensure_local_config()"
    echo "new config file generated, rebuild frontend"
    EXTRA_ARGS="--build"
fi

# Start Caldera
exec python3 server.py "$@" $EXTRA_ARGS
