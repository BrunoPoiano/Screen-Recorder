FROM node:lts-slim

RUN apt-get update && \
    apt-get install -y libgtk-3-0 \
    libdbus-1-3 \
    libudev1 \
    libnotify4 \
    libgconf-2-4 \
    libnss3 \
    libasound2 \
    libxtst6 \
    libx11-xcb1 \
    libxss1 \
    libatk1.0-0 \
    libgtk-3-0 \
    libxcomposite1 \
    libxdamage1 \
    libxext6 \
    libxi6 \
    libappindicator3-1 \
    libnspr4 \
    libgbm1 \
    libasound2 \
    libatk-bridge2.0-0 \
    xvfb dbus-x11 \
    xorg \
    dbus \
    xvfb \
    x11-xkb-utils \
    xfonts-100dpi \
    xfonts-75dpi \
    xfonts-scalable \
    x11-apps \
    clang \
    libxrandr2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/src/app

WORKDIR /usr/src/app

ENV DISPLAY=:99

COPY package.json package.json
COPY package-lock.json package-lock.json

USER root
RUN npm install
RUN echo 'kernel.unprivileged_userns_clone=1' > /etc/sysctl.d/userns.conf
RUN chown root /usr/src/app/node_modules/electron/dist/chrome-sandbox
RUN chmod 4755 /usr/src/app/node_modules/electron/dist/chrome-sandbox
RUN chown -R node:node /usr/src/app
RUN chmod -R 777 /usr/src/app

USER node

COPY . .

CMD ["Xvfb", ":99", "-screen", "0", "1024x768x16", "-ac", "+extension", "GLX", "+render", "-noreset", "-nolisten", "tcp", "&", "npm", "start"]
