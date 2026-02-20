# Test connection between the containers
`fabric-mcp` has `wget` installed, use this to verify `fabric-mcp` can reach `fabric-server` at `fabric-server`'s port `8080`:
Run:
```
container exec fabric-mcp wget -O- http://fabric-server:8080/models/names | jq
```
Verify if you see the vendors and models you configured fabric with.

e.g.
```json
{
  "models": [
    "gpt-oss-120b",
    "llama3.1-8b",
    "qwen-3-235b-a22b-instruct-2507",
    "zai-glm-4.7"
  ],
  "vendors": {
    "Cerebras": [
      "gpt-oss-120b",
      "llama3.1-8b",
      "qwen-3-235b-a22b-instruct-2507",
      "zai-glm-4.7"
    ]
  }
}
```
## This verifies the following are functioning properly:
* `fabric-mcp` can information from `fabric-server` via API
* DNS resolution via our custom DNS domain `fabric-dns`
* Container network `fabric-network` joins both containers

# If you do not receive the same output:
* Verify you set `fabric-dns` to the default DNS domain:
  ```
  container system property list | grep dns.domain
  ```
* Verify you mounted the configuration files to the correct container directory:
  ```
  # Correct
  /home/appuser/

  # Incorrect
  /root/
  ```
