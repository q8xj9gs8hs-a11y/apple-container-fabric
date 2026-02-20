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
  ```
  # Correct
  dns.domain         String  fabric-dns         If defined, the local DNS domain to use for containers with unqualified names.

  # Incorrect
  dns.domain         String  *undefined*         If defined, the local DNS domain to use for containers with unqualified names.
  ```
* Verify you mounted the configuration files to the correct container directory:
  ```
  container exec fabric-server ls -a home/appuser/.config/fabric
  ```
  ```
  # You should see fabric's files
  .env
  contexts
  extensions
  locales
  my-custom-patterns
  patterns
  sessions
  strategies
  unique_patterns.txt
  ```
