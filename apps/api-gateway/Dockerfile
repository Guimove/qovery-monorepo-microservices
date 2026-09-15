# syntax=docker/dockerfile:1.7
FROM node:22-alpine AS base
ARG TURBO_VERSION=2.5.6
RUN npm install --global pnpm@10.15.1 turbo@${TURBO_VERSION}

FROM base AS pruner
WORKDIR /repo
COPY . .
RUN turbo prune @acme/api-gateway --docker

FROM base AS builder
WORKDIR /repo
COPY --from=pruner /repo/out/json/ .
COPY --from=pruner /repo/out/pnpm-lock.yaml ./pnpm-lock.yaml
RUN pnpm install --frozen-lockfile
COPY --from=pruner /repo/out/full/ .
RUN turbo run build --filter=@acme/api-gateway

FROM node:22-alpine AS runner
ENV NODE_ENV=production PORT=8080
WORKDIR /app
USER node
COPY --from=builder --chown=node:node /repo/apps/api-gateway/dist ./dist
EXPOSE 8080
CMD ["node", "dist/index.js"]
