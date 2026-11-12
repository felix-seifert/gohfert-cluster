FROM caddy:2.11.8-alpine@sha256:f6228111e5fafa1a5238258d0858e103f10599b8d1659a146e7726681a002bb9
WORKDIR /srv
COPY site /srv
COPY Caddyfile /etc/caddy/Caddyfile
EXPOSE 80
CMD ["sh", "-c", "caddy run --config /etc/caddy/Caddyfile --adapter caddyfile"]
