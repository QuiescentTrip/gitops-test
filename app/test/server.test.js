import assert from "node:assert/strict";
import { test } from "node:test";
import { createServer } from "../src/server.js";

function listen(server) {
  return new Promise((resolve) => {
    server.listen(0, "127.0.0.1", () => {
      resolve(server.address().port);
    });
  });
}

function close(server) {
  return new Promise((resolve, reject) => {
    server.close((error) => (error ? reject(error) : resolve()));
  });
}

test("health endpoint reports healthy", async () => {
  const server = createServer();
  const port = await listen(server);

  try {
    const response = await fetch(`http://127.0.0.1:${port}/healthz`);
    const body = await response.json();

    assert.equal(response.status, 200);
    assert.equal(body.status, "healthy");
  } finally {
    await close(server);
  }
});

test("root endpoint includes mock cloud context", async () => {
  const server = createServer();
  const port = await listen(server);

  try {
    const response = await fetch(`http://127.0.0.1:${port}/`);
    const body = await response.json();

    assert.equal(response.status, 200);
    assert.equal(body.service, "hopeful-api");
    assert.equal(body.cloudProvider, "mock-gcp");
  } finally {
    await close(server);
  }
});
