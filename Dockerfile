FROM docker.n8n.io/n8nio/n8n:2.0.3

# Switch to root to copy and set permissions
USER root

# Copy start script to home directory (writable by node user)
COPY --chown=node:node start.sh /home/node/start.sh
RUN chmod +x /home/node/start.sh

# Switch back to node user
USER node

# Expose the default n8n port
EXPOSE 5678

# Use the start script as entrypoint
ENTRYPOINT ["/home/node/start.sh"]

