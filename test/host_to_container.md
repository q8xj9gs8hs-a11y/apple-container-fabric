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
# Test `fabric-server`
You may run an instance of `fabric-server` with an alternative command and port mapping (host `8080` to container `8080`) to ensure it works:
```
container run -it --rm -p 8080:8080 -v "${HOME}/.fabric-config:/home/appuser/.config/fabric" jimscard/fabric-yt fabric -l | head -n 10
```
```
# This will list fabric's first 10 patterns in alphabetical order

agility_story
ai
analyze_answers
analyze_bill
analyze_bill_short
analyze_candidates
analyze_cfp_submission
analyze_claims
analyze_comments
analyze_debate
```
