# ============================
# FFmpeg 7.1.1 (estável)
# ============================
FROM mwader/static-ffmpeg:7.1.1 AS ffmpeg-source

# ============================
# Python 3.13 (estável)
# ============================
FROM python:3.13-alpine AS python-source

# ============================
# n8n 2.26.8 (estável)
# ============================
FROM n8nio/n8n:2.26.8

USER root

# ----------------------------
# FFmpeg + FFprobe
# ----------------------------
COPY --from=ffmpeg-source /ffmpeg /usr/local/bin/ffmpeg
COPY --from=ffmpeg-source /ffprobe /usr/local/bin/ffprobe

# ----------------------------
# Python
# ----------------------------
COPY --from=python-source /usr/local/bin/python* /usr/local/bin/
COPY --from=python-source /usr/local/lib/ /usr/local/lib/
COPY --from=python-source /usr/lib/libffi* /usr/lib/

# ----------------------------
# Dependências úteis
# ----------------------------
RUN apk add --no-cache \
    bash \
    curl \
    wget \
    git \
    ca-certificates

# ----------------------------
# yt-dlp (última versão estável no momento)
# ----------------------------
ADD https://github.com/yt-dlp/yt-dlp

RUN chmod +x /usr/local/bin/yt-dlp

USER node
