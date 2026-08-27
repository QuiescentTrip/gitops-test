import http from "node:http";

const port = Number.parseInt(process.env.PORT || "8080", 10);

export function createServer() {
  return http.createServer((request, response) => {
    const payload = {
      service: "hopeful-api",
      environment: process.env.APP_ENV || "dev",
      cloudProvider: process.env.CLOUD_PROVIDER || "mock-gcp",
      region: process.env.GCP_REGION || "local-kind",
      path: request.url,
      status: "ok"
    };

    if (request.url === "/healthz") {
      response.writeHead(200, { "content-type": "application/json" });
      response.end(JSON.stringify({ status: "healthy" }));
      return;
    }

    response.writeHead(200, { "content-type": "application/json" });
    response.end(JSON.stringify(payload, null, 2));
  });
}

if (import.meta.url === `file://${process.argv[1]}`) {
  createServer().listen(port, "0.0.0.0", () => {
    console.log(`hopeful-api listening on ${port}`);
  });
}
