# apple-container-fabric
Run Fabric-AI REST API and MCP server in containers with [apple/container](https://github.com/apple/container.git)

# Quickest Setup
1. Clone this repository for the MCP server Containerfile
```
git clone https://github.com/q8xj9gs8hs-a11y/apple-container-fabric.git
cd apple-container-fabric
```
2. Build the image
```
container build -t fabric-mcp .
```
3. [Pull the image](https://hub.docker.com/r/jimscard/fabric-yt/tags) for the REST API container
```
container image pull jimscard/fabric-yt:latest
```
4. Create a dustom DNS domain for hostname resolution
```
sudo container system dns create fabric-dns
```
5. Set `fabric-dns` to the default DNS
```
container system property set dns.domain fabric-dns
```
6. Create a custom network for an isolated container network
```
container network create fabric-network
```
7. Create fabric's configuration for the bind mount
```
mkdir -p ~/.fabric-config
cd ~/.fabric-config

# Run the fabric container to initiate the setup
container run -it --rm -v "${HOME}/.fabric-config:/root/.config/fabric" jimscard/fabric-yt fabric --setup

# Continue through the setup process for installing patterns, strategies, and configuring your AI vendor and model
```
8. Run both containers
```
container run --rm -d --name fabric-server --network fabric-network -v "${HOME}/.fabric-config:/root/.config/fabric" jimscard/fabric-yt

container run --rm -d --name fabric-mcp --network fabric-network -p 8000:8000 -e FABRIC_BASE_URL=http://fabric-server:8080 fabric-mcp --transport http --port 8000 --host 0.0.0.0
```
9. Configure your `mcp.json`
```json
"fabric": {
  "url": "http://localhost:8000/message"
}
```

Tasklist:
- [ ] Deep dive into `container run` commands and syntax
- [ ] Guide through workflow involved
- [ ] Add `docker-compose.yml` for use with `container-compose` wrapper
- [ ] Deep dive into networking involved
- [x] Customizing Containerfile `ENTRYPOINT`
- [ ] Testing and verification techniques, debugging
- [ ] Add system prompt to complement this workflow
- [ ] Additional notes and nuances
