FROM n8nio/n8n:2.10.4

# Entra como root para ter permissões de instalação de pacotes no Debian
USER root

# Atualiza os repositórios e instala as dependências necessárias
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    python3 \
    python3-pip \
    python3-six \
    curl \
    && curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp \
    && chmod a+rx /usr/local/bin/yt-dlp \
    && rm -rf /var/lib/apt/lists/*

# Devolve a execução para o usuário padrão do n8n por segurança
USER node
