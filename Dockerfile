FROM docker.n8n.io/n8nio/n8n:latest

# Copy start script
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Expose the default n8n port
EXPOSE 5678

# Use the start script as entrypoint
ENTRYPOINT ["/usr/local/bin/start.sh"]

