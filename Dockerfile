FROM node:7.8.0
WORKDIR /opt
ADD . /opt
RUN npm install
EXPOSE 3001
ENTRYPOINT npm run start
