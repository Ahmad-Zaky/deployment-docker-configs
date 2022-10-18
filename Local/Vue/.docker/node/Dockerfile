FROM node:16-alpine
EXPOSE 8080

RUN apk add --no-cache bash

# set working directory
WORKDIR /usr/src/app

COPY package*.json /usr/src/app/
RUN npm install

RUN npm install -g @vue/cli

COPY . /usr/src/app/

ENV PATH /usr/src/app/node_modules/.bin:$PATH

RUN chown -R 1000:1000 /usr/src/app

CMD ["npm", "run", "serve"]