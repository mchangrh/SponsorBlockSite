FROM node:20-alpine as builder
RUN apk add --no-cache --virtual .build-deps python3 make g++
WORKDIR /app
COPY package.json package-lock.json gatsby-config.js ./
COPY src src
COPY static static
RUN npm ci && npm run build

FROM nginx as app
EXPOSE 80
COPY --from=builder /app/public/ /usr/share/nginx/html
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/default.conf /etc/nginx/conf.d/default.conf