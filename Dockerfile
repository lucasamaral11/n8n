FROM n8nio/n8n:2.10.4

USER root

# Instala o ffmpeg, python3 (necessário para o yt-dlp) e ferramentas de download
RUN apk add --no-cache ffmpeg python3 yt-dlp

# Garante que o usuário nativo do n8n (node) tenha permissões normais
USER node
