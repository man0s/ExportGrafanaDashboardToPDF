FROM node:20-slim

RUN apt-get update && apt-get install -y \
    gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils wget \
    chromium \
    jq \
    curl \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

COPY package*.json ./

# RUN npm config set strict-ssl false # For those who encounter errors with certificates
RUN npm install -g dotenv
RUN npm install

COPY grafana_pdf.js .
COPY server.js .
COPY generate-pdf.sh ./

# ============================================
# Built-in default values (can be overridden at runtime by env vars)
# ============================================

# Puppeteer
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium
ENV PUPPETEER_NAVIGATION_TIMEOUT=120000

# Server
ENV EXPORT_SERVER_PORT=3001

# Grafana auth
ENV GRAFANA_USER=gfexp
ENV GRAFANA_PASSWORD=gfexp
ENV GRAFANA_SERVICE_ACCOUNT=false

# PDF output
ENV PDF_WIDTH_PX=1920
ENV PDF_HEIGHT_PX=auto
ENV ADD_RANDOM_STRING_TO_FILE_NAME=false
ENV FORCE_KIOSK_MODE=true

# Dashboard rendering
ENV HIDE_DASHBOARD_CONTROLS=true
ENV EXPAND_COLLAPSED_PANELS=true
ENV EXPAND_TABLES=false
ENV DEBUG_MODE=false
ENV EXTRACT_DATE_AND_DASHBOARD_NAME_FROM_HTML_PANEL_ELEMENTS=false

# Query completion checks
ENV CHECK_QUERIES_TO_COMPLETE=false
ENV CHECK_QUERIES_TO_COMPLETE_MAX_QUERY_COMPLETION_TIME=30000
ENV CHECK_QUERIES_TO_COMPLETE_QUERIES_INTERVAL=1000
ENV CHECK_QUERIES_TO_COMPLETE_QUERIES_COMPLETION_TIMEOUT=60000

# Suppress dotenv warnings when no .env file is present
ENV DOTENV_CONFIG_QUIET=true

EXPOSE ${EXPORT_SERVER_PORT}

CMD ["node", "server.js"]
