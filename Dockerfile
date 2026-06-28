# ============================
# FFmpeg 7.1.1 (estável)
# ============================
FROM mwader/static-ffmpeg:7.1.1 AS ffmpeg-source

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
# Instala Python 3 e dependências
# ----------------------------
RUN apk add --no-cache \
    python3 \
    py3-pip \
    bash \
    curl \
    wget \
    git \
    ca-certificates \
    tzdata

# Cria links simbólicos para compatibilidade
RUN ln -sf /usr/bin/python3 /usr/local/bin/python && \
    ln -sf /usr/bin/python3 /usr/local/bin/python3 && \
    ln -sf /usr/bin/pip3 /usr/local/bin/pip

# Atualiza o pip
RUN python3 -m ensurepip && \
    python3 -m pip install --no-cache-dir --upgrade pip setuptools wheel

# ----------------------------
# yt-dlp
# ----------------------------
ADD https://github.com/yt-dlp/yt-dlp/releases/download/2026.06.24/yt-dlp /usr/local/bin/yt-dlp

RUN chmod +x /usr/local/bin/yt-dlp

USER node
