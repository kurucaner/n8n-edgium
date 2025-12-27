# Stage 1: Download static ffmpeg build
FROM alpine:3.19 AS ffmpeg-builder
RUN apk add --no-cache curl xz && \
    curl -L https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz -o ffmpeg.tar.xz && \
    tar xf ffmpeg.tar.xz && \
    mv ffmpeg-*-amd64-static/ffmpeg /usr/local/bin/ffmpeg && \
    mv ffmpeg-*-amd64-static/ffprobe /usr/local/bin/ffprobe && \
    chmod +x /usr/local/bin/ffmpeg /usr/local/bin/ffprobe

# Stage 2: Use n8n image
FROM docker.n8n.io/n8nio/n8n:2.1.4

# Switch to root to copy and set permissions
USER root

# Copy static ffmpeg binaries from the builder stage
COPY --from=ffmpeg-builder /usr/local/bin/ffmpeg /usr/local/bin/ffmpeg
COPY --from=ffmpeg-builder /usr/local/bin/ffprobe /usr/local/bin/ffprobe

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
