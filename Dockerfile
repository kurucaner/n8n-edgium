FROM docker.n8n.io/n8nio/n8n:2.1.4

# Switch to root to copy and set permissions
USER root

# Install ffmpeg
RUN apk add --no-cache ffmpeg

# Copy start script to home directory (writable by node user)
COPY --chown=node:node start.sh /home/node/start.sh
RUN chmod +x /home/node/start.sh

# Copy assets directory
COPY --chown=node:node assets /home/node/assets

# Create .n8n-files directory
RUN mkdir -p /home/node/.n8n-files && chown -R node:node /home/node/.n8n-files

# Switch back to node user
USER node

# Expose the default n8n port
EXPOSE 5678

# Use the start script as entrypoint
ENTRYPOINT ["/home/node/start.sh"]
