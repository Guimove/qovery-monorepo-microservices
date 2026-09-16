# syntax=docker/dockerfile:1.7
FROM node:22-alpine AS base
ARG TURBO_VERSION=2.5.6
RUN npm install --global pnpm@10.15.1 turbo@${TURBO_VERSION}

FROM base AS pruner
WORKDIR /repo
COPY . .
RUN turbo prune @acme/orders --docker

FROM base AS builder
WORKDIR /repo
COPY --from=pruner /repo/out/json/ .
COPY --from=pruner /repo/out/pnpm-lock.yaml ./pnpm-lock.yaml
RUN pnpm install --frozen-lockfile
COPY --from=pruner /repo/out/full/ .
COPY --from=pruner /repo/packages/config ./packages/config
RUN turbo run build --filter=@acme/orders

FROM node:22-alpine AS runner
ENV NODE_ENV=production PORT=8081
WORKDIR /app
USER node
# test
COPY --from=builder --chown=node:node /repo/apps/orders/dist ./dist
COPY --from=builder --chown=node:node /repo/apps/orders/migrations ./migrations
EXPOSE 8081
CMD ["node", "dist/index.js"]
