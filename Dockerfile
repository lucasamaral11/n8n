# Estágio 1: Pegar o FFmpeg estático pronto
FROM mwader/static-ffmpeg:7.1.1 AS ffmpeg-source

# Estágio 2: Pegar o Python estável (Alpine), compatível com a libc do n8n
FROM python:3.11-alpine AS python-source

# Estágio Final: Montar tudo no n8n
FROM n8nio/n8n:2.26.8

USER root

# Copia o FFmpeg e FFprobe
COPY --from=ffmpeg-source /ffmpeg /usr/local/bin/ffmpeg
COPY --from=ffmpeg-source /ffprobe /usr/local/bin/ffprobe

# Copia o binário do Python e TODAS as dependências nativas do Alpine
COPY --from=python-source /usr/local/bin/python* /usr/local/bin/
COPY --from=python-source /usr/local/lib/ /usr/local/lib/
COPY --from=python-source /usr/lib/libffi* /usr/lib/
# Garante as bibliotecas compartilhadas do sistema Alpine para o Python não quebrar
COPY --from=python-source /lib/ld-musl-* /lib/
COPY --from=python-source /lib/libz.* /lib/

# Baixa diretamente o executável standalone do yt-dlp
ADD https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp /usr/local/bin/yt-dlp
RUN chmod a+rx /usr/local/bin/yt-dlp

USER node
