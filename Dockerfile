# Estágio 1: Pegar o FFmpeg pronto
FROM mwader/static-ffmpeg:6.1.1 as ffmpeg-source

# Estágio 2: Pegar o Python pronto do Debian Slim
FROM python:3.11-slim as python-source

# Estágio Final: Montar tudo na imagem oficial do n8n
FROM n8nio/n8n:2.10.4

USER root

# Copia o FFmpeg do primeiro estágio
COPY --from=ffmpeg-source /ffmpeg /usr/local/bin/ffmpeg
COPY --from=ffmpeg-source /ffprobe /usr/local/bin/ffprobe

# Copia o ambiente do Python do segundo estágio
COPY --from=python-source /usr/local/bin/python* /usr/local/bin/
COPY --from=python-source /usr/local/lib/ /usr/local/lib/

# Baixa e instala o binário do yt-dlp usando o próprio Python que copiamos
RUN python3 -m pip install --no-cache-dir yt-dlp

USER node
