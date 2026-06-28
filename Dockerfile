FROM n8nio/n8n:2.10.4

# Garante o usuário root com privilégios totais
USER root

# Instala as ferramentas usando o caminho absoluto do gerenciador de pacotes do Alpine
RUN /sbin/apk update && /sbin/apk add --no-cache \
    ffmpeg \
    python3 \
    py3-pip \
    yt-dlp

# Devolve a execução para o usuário padrão por segurança
USER node
