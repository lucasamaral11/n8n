# Mantém a imagem base original do n8n que você estava usando
FROM n8nio/n8n:2.10.4

USER root

# Instala o ffmpeg, python3 (para o yt-dlp) e as ferramentas necessárias usando o apt
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    python3 \
    python3-pip \
    curl \
    && curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp \
    && chmod a+rx /usr/local/bin/yt-dlp \
    && rm -rf /var/lib/apt/lists/*

USER node
