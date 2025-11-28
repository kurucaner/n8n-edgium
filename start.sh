#!/bin/sh

# Map Railway's PORT environment variable to N8N_PORT if PORT is set
if [ -n "$PORT" ]; then
  export N8N_PORT=$PORT
fi

# Start n8n
exec n8n start

