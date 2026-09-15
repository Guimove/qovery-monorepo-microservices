import { createServer } from "node:http";
import type { ServiceInfo } from "@acme/contracts";
import { createLogger } from "@acme/logger";

const port = Number(process.env.PORT ?? 8080);
const logger = createLogger("api-gateway");
const service: ServiceInfo = { name: "api-gateway", version: process.env.GIT_SHA ?? "local", status: "ok" };

createServer((request, response) => {
  const status = request.url === "/health" ? 200 : 200;
  response.writeHead(status, { "content-type": "application/json" });
  response.end(JSON.stringify({ ...service, route: request.url }));
}).listen(port, () => logger.info("gateway ready", { port }));
