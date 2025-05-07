#!/bin/sh
set -e

# Get the Ollama host from environment or default to 'ollama'
OLLAMA_HOST=${OLLAMA_HOST:-ollama}
OLLAMA_URL="http://${OLLAMA_HOST}:11434"

echo "Using Ollama server at ${OLLAMA_URL}"

# Wait for Ollama server to be ready
echo "Waiting for Ollama server to start..."
MAX_RETRIES=30
RETRY_COUNT=0

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
  if curl -s -f "${OLLAMA_URL}" > /dev/null 2>&1; then
    echo "Ollama server is up and running!"
    break
  else
    echo "Ollama server not ready yet, waiting... (${RETRY_COUNT}/${MAX_RETRIES})"
    RETRY_COUNT=$((RETRY_COUNT + 1))
    sleep 2
  fi
done

if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
  echo "Failed to connect to Ollama server after ${MAX_RETRIES} attempts"
  exit 1
fi

# Pull the Qwen model
echo "Pulling qwen2.5:0.5b model..."
RESPONSE=$(curl -s -X POST "${OLLAMA_URL}/api/pull" -d '{"name": "qwen2.5:0.5b", "stream": false}')
echo "$RESPONSE"

# Check if successful - this assumes any successful response is good
if echo "$RESPONSE" | grep -q "success"; then
  echo "Model pull initiated successfully!"
  exit 0
else
  echo "Failed to initiate model pull"
  exit 1
fi