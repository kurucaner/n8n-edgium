# Stage 1: Download static ffmpeg build
FROM alpine:3.19 AS ffmpeg-builder
RUN apk add --no-cache curl xz && \
    curl -L https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz -o ffmpeg.tar.xz && \
    tar xf ffmpeg.tar.xz && \
    mv ffmpeg-*-amd64-static/ffmpeg /usr/local/bin/ffmpeg && \
    mv ffmpeg-*-amd64-static/ffprobe /usr/local/bin/ffprobe && \
    chmod +x /usr/local/bin/ffmpeg /usr/local/bin/ffprobe

# Stage 2: Use n8n image
FROM docker.n8n.io/n8nio/n8n:stable

# Switch to root for setup
USER root

# 1. Create the nodes directory and install the community package
# We install to /home/node/.n8n/nodes to avoid workspace protocol conflicts
RUN mkdir -p /home/node/.n8n/nodes && \
    cd /home/node/.n8n/nodes && \
    npm init -y && \
    npm install @elevenlabs/n8n-nodes-elevenlabs && \
    chown -R node:node /home/node/.n8n

# 2. Copy static ffmpeg binaries from the builder stage
COPY --from=ffmpeg-builder /usr/local/bin/ffmpeg /usr/local/bin/ffmpeg
COPY --from=ffmpeg-builder /usr/local/bin/ffprobe /usr/local/bin/ffprobe

# 3. Setup files and permissions
COPY --chown=node:node start.sh /home/node/start.sh
RUN chmod +x /home/node/start.sh
COPY --chown=node:node assets /home/node/assets
RUN mkdir -p /home/node/.n8n-files && chown -R node:node /home/node/.n8n-files

# Switch back to node user
USER node
EXPOSE 5678
ENTRYPOINT ["/home/node/start.sh"]