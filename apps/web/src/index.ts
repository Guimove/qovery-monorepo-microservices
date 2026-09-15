import { createServer } from "node:http";
import type { ServiceInfo } from "@acme/contracts";

const port = Number(process.env.PORT ?? 3000);
const service: ServiceInfo = { name: "web", version: process.env.GIT_SHA ?? "local", status: "ok" };

createServer((_request, response) => {
  response.writeHead(200, { "content-type": "text/html; charset=utf-8" });
  response.end(`<!doctype html><html><body><h1>Acme Commerce</h1><p>${service.name} · ${service.status}</p></body></html>`);
}).listen(port, () => console.log(`web ready on :${port}`));
