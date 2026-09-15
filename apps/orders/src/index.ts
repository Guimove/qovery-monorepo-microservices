import { createServer } from "node:http";
import type { Order, ServiceInfo } from "@acme/contracts";
import { createLogger } from "@acme/logger";

const logger = createLogger("orders");

if (process.argv.includes("migrate")) {
  logger.info("applying orders migrations", { directory: "./migrations" });
  process.exit(0);
}

const port = Number(process.env.PORT ?? 8081);
const service: ServiceInfo = { name: "orders", version: process.env.GIT_SHA ?? "local", status: "ok" };
const sample: Order = { id: "ord_demo", customerId: "cus_demo", totalInCents: 4900, status: "confirmed" };

createServer((_request, response) => {
  response.writeHead(200, { "content-type": "application/json" });
  response.end(JSON.stringify({ service, orders: [sample] }));
}).listen(port, () => logger.info("orders ready", { port }));
