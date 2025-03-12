#!/bin/bash

CONFIG_FILE="/usr/src/app/conf/local.yml"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Generating new local.yml using Caldera's built-in method..."
    python3 -c "import app; import app.utility.config_generator; app.utility.config_generator.ensure_local_config()"
else
    echo "Using existing local.yml"
fi

exec python3 server.py "$@"

