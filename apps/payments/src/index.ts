import { createServer } from "node:http";
import type { Payment, ServiceInfo } from "@acme/contracts";
import { createLogger } from "@acme/logger";

const logger = createLogger("payments");

if (process.argv.includes("migrate")) {
  logger.info("applying payments migrations", { directory: "./migrations" });
  process.exit(0);
}

const port = Number(process.env.PORT ?? 8082);
const service: ServiceInfo = { name: "payments", version: process.env.GIT_SHA ?? "local", status: "ok" };
const sample: Payment = { id: "pay_demo", orderId: "ord_demo", amountInCents: 4900, status: "captured" };

createServer((_request, response) => {
  response.writeHead(200, { "content-type": "application/json" });
  response.end(JSON.stringify({ service, payments: [sample] }));
}).listen(port, () => logger.info("payments ready", { port }));
