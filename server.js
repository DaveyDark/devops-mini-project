const express = require("express");
const axios = require("axios");
const path = require("path");

const app = express();
app.use(express.json());
app.use(express.static("public"));

// Get Ollama host from environment variable or default to ollama service name
const OLLAMA_HOST = process.env.OLLAMA_HOST || "ollama";

app.post("/api/chat", async (req, res) => {
  try {
    console.log(`Sending request to http://${OLLAMA_HOST}:11434/api/chat`);
    const response = await axios.post(`http://${OLLAMA_HOST}:11434/api/chat`, {
      model: "qwen2.5:0.5b",
      messages: req.body.messages,
      stream: false,
    });

    res.json({
      message: {
        role: "assistant",
        content: response.data.message?.content || response.data.response,
      },
    });
  } catch (err) {
    console.error("Error connecting to Ollama:", err.message);
    res.status(500).json({ error: "Error connecting to Ollama" });
  }
});

// Serve the frontend for all other routes
app.get("*url", (req, res) => {
  res.sendFile(path.join(__dirname, "public/index.html"));
});

// Use PORT environment variable or default to 80
const PORT = process.env.PORT || 80;
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
