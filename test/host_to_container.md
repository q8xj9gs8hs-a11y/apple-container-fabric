# Test port mapping between host machine and `fabric-mcp` container
We ran the `fabric-mcp` container with a port mapping of the host's port `8000` to the container's port `8000`. You can choose an alternative host port if needed.

Mapping these ports allows the MCP client, or more generally, the host machine, to access the container, but only because the `http` server that `fabric-mcp` runs is exposed to all networks via `0.0.0.0`.

To verify:
```
curl http://localhost:8000/message
```
The presence of this error (not a valid request) verifies the host to container connection:
```json
{"jsonrpc":"2.0","id":"server-error","error":{"code":-32600,"message":"Not Acceptable: Client must accept text/event-stream"}}
```
