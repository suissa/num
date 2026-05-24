#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULE_SRC="$ROOT_DIR/ngx_http_hello_module.c"
CONF_FILE="$ROOT_DIR/nginx.conf"
BUILD_DIR="$ROOT_DIR/.build-nginx"
MODULE_OUT_DIR="$ROOT_DIR/modules"
MODULE_SO="$MODULE_OUT_DIR/ngx_http_hello_module.so"

mkdir -p "$BUILD_DIR" "$MODULE_OUT_DIR" "$ROOT_DIR/logs"

if ! command -v nginx >/dev/null 2>&1; then
    echo "nginx nao encontrado no PATH. Instale nginx primeiro."
    exit 1
fi

NGINX_VERSION="$(nginx -v 2>&1 | sed -n 's#.*nginx/\([0-9.]\+\).*#\1#p')"
if [[ -z "$NGINX_VERSION" ]]; then
    echo "Nao foi possivel detectar a versao do nginx."
    exit 1
fi

echo "[1/5] nginx detectado: $NGINX_VERSION"

NGINX_SRC_DIR="$BUILD_DIR/nginx-$NGINX_VERSION"
NGINX_TARBALL="$BUILD_DIR/nginx-$NGINX_VERSION.tar.gz"

if [[ ! -d "$NGINX_SRC_DIR" ]]; then
    echo "[2/5] baixando fonte nginx-$NGINX_VERSION"
    curl -fsSL "https://nginx.org/download/nginx-$NGINX_VERSION.tar.gz" -o "$NGINX_TARBALL"
    tar -xzf "$NGINX_TARBALL" -C "$BUILD_DIR"
fi

echo "[3/5] compilando modulo dinamico"
cc -fPIC -shared -o "$MODULE_SO" "$MODULE_SRC" \
    -I"$NGINX_SRC_DIR/src/core" \
    -I"$NGINX_SRC_DIR/src/event" \
    -I"$NGINX_SRC_DIR/src/event/modules" \
    -I"$NGINX_SRC_DIR/src/os/unix" \
    -I"$NGINX_SRC_DIR/src/http" \
    -I"$NGINX_SRC_DIR/src/http/modules" \
    -I"$NGINX_SRC_DIR/src/http/v2" \
    -I"$NGINX_SRC_DIR/src/http/v3" \
    -W -Wall -Wextra -O2

echo "[4/5] validando configuracao"
nginx -t -p "$ROOT_DIR" -c "$CONF_FILE"

echo "[5/5] iniciando/recarregando nginx"
if [[ -f "$ROOT_DIR/logs/nginx.pid" ]] && kill -0 "$(cat "$ROOT_DIR/logs/nginx.pid")" 2>/dev/null; then
    nginx -p "$ROOT_DIR" -c "$CONF_FILE" -s reload
else
    nginx -p "$ROOT_DIR" -c "$CONF_FILE"
fi

echo "Pronto! Teste em: http://127.0.0.1:8080/hello_c"
