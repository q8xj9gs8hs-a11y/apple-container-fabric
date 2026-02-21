#!/bin/bash
run_containers() {
  container run --rm -d --name fabric-server --network fabric-network -v "${HOME}/.fabric-config:/home/appuser/.config/fabric" jimscard/fabric-yt fabric --serve --address 0.0.0.0:8080
  container run --rm -d --name fabric-mcp --network fabric-network -v "${HOME}/.fabric-config:/home/appuser/.config/fabric" -p 8000:8000 -e FABRIC_BASE_URL=http://fabric-server:8080 fabric-mcp
  echo "Containers started successfully"
  echo ""
}

# Main menu function
show_menu() {
  echo "1) Start containers"
  echo "2) Stop containers"
  echo "3) List running containers"
  echo "4) List networks"
  echo "5) List DNS domains"
  echo "0) Exit"
  echo "Select an option: "
  echo ""
}

stop_containers() {
  container stop fabric-mcp
  container stop fabric-server
  echo "Containers stopped successfully"
  echo ""
}

list_networks() {
  echo "Container networks: "
  echo ""
  container n ls
  echo ""
}

list_dns_domains() {
  echo "Container DNS domains: "
  echo ""
  container s dns ls
  echo ""
}

list_containers() {
  echo "Running containers:"
  echo ""
  container ls | grep fabric
  echo ""
}

# Main loop
while true; do
  show_menu
  read -r option

  case $option in
  1)
    run_containers
    ;;
  2)
    stop_containers
    ;;
  3)
    list_containers
    ;;
  4)
    list_networks
    ;;
  5)
    list_dns_domains
    ;;
  0)
    echo "Exiting..."
    exit 0
    ;;
  *)
    echo "Invalid option."
    echo ""
    ;;
  esac
done
