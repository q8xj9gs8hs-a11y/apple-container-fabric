FROM alpine:3.21

# Install system dependencies, create virtual environment, and install fabric-mcp
RUN apk add --no-cache python3 py3-pip && \
    python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install fabric-mcp

ENV PATH="/opt/venv/bin:${PATH}"

RUN adduser -D -h /home/appuser appuser
USER appuser

RUN fabric-mcp --version

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD fabric-mcp --version || exit 1

ENTRYPOINT ["fabric-mcp"]
