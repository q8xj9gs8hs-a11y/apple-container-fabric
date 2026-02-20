# apple-container-fabric
Run Fabric-AI REST API and MCP server in containers with [apple/container](https://github.com/apple/container.git)

## Quickest Setup
### First, setup a custom `container` DNS and `network`:
1. Create a dustom DNS domain for hostname resolution:
```
sudo container system dns create fabric-dns
```
2. Set `fabric-dns` to the default DNS:
```
container system property set dns.domain fabric-dns
```
3. Create a custom network for an isolated container network:
```
container network create fabric-network
```

### Install images and configure fabric
4. Clone this repository for the MCP server Containerfile:
```
git clone https://github.com/q8xj9gs8hs-a11y/apple-container-fabric.git
cd apple-container-fabric
```

5. Build the image:
```
container build -t fabric-mcp .
```

6. [Pull the image](https://hub.docker.com/r/jimscard/fabric-yt/tags) for the REST API container:
```
container image pull jimscard/fabric-yt:latest
```

7. Create fabric's configuration for the bind mount:
```
mkdir -p "${HOME}/.fabric-config"
cd "${HOME}/.fabric-config"
```
[*Note: If you already have fabric's configuration files in `${HOME}/.config/fabric`, then you can either skip step 8 and mount that directory instead of `${HOME}/.fabric-config`, or run `cp -r ${HOME}/.config/fabric/ ${HOME}/.fabric-config` in place of step 8*]

8. Run `fabric --setup` in a container
```
container run -it --rm -v "${HOME}/.fabric-config:/home/appuser/.config/fabric" jimscard/fabric-yt fabric --setup

# Continue through the setup process for installing patterns, strategies, and configuring your AI vendor and model
```

### Start the REST API and MCP server containers
9. Run both containers:
```
container run --rm -d --name fabric-server --network fabric-network -v "${HOME}/.fabric-config:/home/appuser/.config/fabric" jimscard/fabric-yt fabric --serve --address 0.0.0.0:8080

container run --rm -d --name fabric-mcp --network fabric-network -v "${HOME}/.fabric-config:/home/appuser/.config/fabric" -p 8000:8000 -e FABRIC_BASE_URL=http://fabric-server:8080 fabric-mcp
```

10. Configure your `mcp.json`:
```json
{
  "mcpServers": {
    "fabric": {
      "url": "http://localhost:8000/message"
    }
  }
}
```

## Run as `--transport stdio` (optional)
Override the default `fabric-mcp` command without mapping a port. Your `mcp.json` will be change to:
```json
{
  "mcpServers": {
    "fabric": {
      "command": "container",
      "args": [
        "run",
        "-i",
        "--rm",
        "--network", "fabric-network",
        "-v", "${HOME}/.fabric-config:/home/appuser/.config/fabric",
        "-e", "FABRIC_BASE_URL",
        "fabric-mcp",
        "--transport", "stdio"
      ],
      "env": {
        "FABRIC_BASE_URL": "http://fabric-server:8080"
      }
    }
  }
}
```

## System Prompt
Use this system prompt with your MCP client to get the best results: [system.md](system.md)

## Testing
Follow this guide to ensure `fabric-mcp` and `fabric-server` can talk to each other: [container_networking.md](test/container_networking.md)

Ensure your MCP client can reach `fabric-mcp`: [host_to_container.md](test/host_to_container.md)

## Tasklist:
- [ ] Explanation on project architecture and workflow
- [ ] Usage
- [ ] Requirements
- [ ] Executable script to start and stop containers
- [ ] container-compose wrapper for compose yaml
- [x] Customizing Containerfile `ENTRYPOINT`
- [x] Testing and verification techniques, debugging
- [x] Add system prompt to complement this workflow
- [ ] Additional notes and nuances
- [x] Running the MCP server as `stdio`
- [ ] Bypass setting custom DNS to default
- [ ] Change fabric image `CMD ["fabric", "--serve"]` to `ENTRYPOINT ["fabric"] CMD ["--serve", "--address", "0.0.0.0:8080"]`
