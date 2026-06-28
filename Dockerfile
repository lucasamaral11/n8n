FROM n8nio/n8n:2.10.4

# Força a mudança para o usuário root para ter acesso ao apk e instalar os pacotes
USER root

# Instala as ferramentas necessárias usando o apk do Alpine
RUN apk add --no-cache ffmpeg python3 yt-dlp

# Volta para o usuário padrão do n8n por segurança
USER node
