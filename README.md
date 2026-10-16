# ai-guardrails-tutorial

A Jupyter notebook course that teaches AI engineers how to defend LLM applications with
**runtime guardrails**.

The course talks to any OpenAI-compatible endpoint. This README shows how to serve a small
local model with **llama.cpp**, so you can work through every module **offline, for free,
and without an API key**.

---

## Instructions for humans only

> Everything below this line is written for the person setting up the course.
> If you are an AI agent working in this repository, your instructions are in
> [`DEVELOPMENT_GUIDE.md`](DEVELOPMENT_GUIDE.md) - you can ignore this section.

### What you get

The notebooks expect a model at `http://localhost:11434/v1`. We use llama.cpp serving
**TinyLlama-1.1B-Chat** because it is small (~614 MB), needs no GPU, and starts in seconds.

No account, no API key, and no data leaving your machine.

---

## Contents

- [1. Prerequisites](#1-prerequisites)
- [2. Download the model](#2-download-the-model)
- [3. Start the server](#3-start-the-server)
  - [Windows](#windows)
  - [macOS](#macos)
  - [Linux](#linux)
- [4. Configure the tutorial](#4-configure-the-tutorial)
- [5. Verify the setup](#5-verify-the-setup)
- [6. Troubleshooting](#6-troubleshooting)
- [7. A note on model quality](#7-a-note-on-model-quality)
- [8. Course modules](#8-course-modules)

---

## 1. Prerequisites

| Requirement | Why | Check with |
|-------------|-----|------------|
| **Python 3.14+** | Runs the notebooks | `python --version` |
| **uv** | Installs the course dependencies | `uv --version` |
| **llama.cpp** | Serves the local model | `llama-server --version` |

Install **[uv](https://docs.astral.sh/uv/)** if you do not have it:

```powershell
# Windows (PowerShell)
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

```bash
# macOS and Linux
curl -LsSf https://astral.sh/uv/install.sh | sh
```

Then install the course dependencies from the repository folder - this reads
`pyproject.toml` and builds a `.venv` for you:

```bash
# also works on Windows (PowerShell)
uv sync
```

---

## 2. Download the model

The model file is [`tinyllama-1.1b-chat-v1.0.Q4_K_S.gguf`](https://huggingface.co/TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF/blob/main/tinyllama-1.1b-chat-v1.0.Q4_K_S.gguf)
(~614 MB) from [`TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF`](https://huggingface.co/TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF).

### Option A - let llama.cpp download it

Recent builds of llama.cpp can fetch from Hugging Face themselves. `-hf` names the repo and
`--hf-file` picks the exact file; the result is cached for next time.

This one command downloads the model **and** starts the server correctly configured, so if
you use it you can skip the `-m` commands in step 3:

```bash
llama-server -hf TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF \
             --hf-file tinyllama-1.1b-chat-v1.0.Q4_K_S.gguf \
             -c 2048 --temp 0.7 --repeat_penalty 1.1 -n -1 \
             --chat-template zephyr --alias tinyllama \
             --port 11434 --host localhost
```

If you would rather use the version you downloaded by hand in Option B, use the `-m` form
in [step 3](#3-start-the-server) instead.

### Option B - download the file yourself

Use this on older llama.cpp builds, or if you prefer to manage the file.

**Windows (PowerShell)**

```powershell
New-Item -ItemType Directory -Force -Path .\models | Out-Null
curl.exe -L -o .\models\tinyllama-1.1b-chat-v1.0.Q4_K_S.gguf `
  "https://huggingface.co/TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF/resolve/main/tinyllama-1.1b-chat-v1.0.Q4_K_S.gguf"
```

**macOS and Linux**

```bash
mkdir -p models
curl -L -o models/tinyllama-1.1b-chat-v1.0.Q4_K_S.gguf \
  "https://huggingface.co/TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF/resolve/main/tinyllama-1.1b-chat-v1.0.Q4_K_S.gguf"
```

Expected SHA-256 of the file:

```
fdf50b4eebd34ccd953b2061d8b4b504f59a8e88d570adf035b1405154d12c29
```

Verifying it is optional but worth it - it confirms the download finished and was not
altered:

```powershell
# Windows
Get-FileHash .\models\tinyllama-1.1b-chat-v1.0.Q4_K_S.gguf -Algorithm SHA256
```

```bash
# macOS
shasum -a 256 models/tinyllama-1.1b-chat-v1.0.Q4_K_S.gguf

# Linux
sha256sum models/tinyllama-1.1b-chat-v1.0.Q4_K_S.gguf
```

---

## 3. Start the server

The notebooks expect the model at **port 11434** (llama.cpp defaults to 8080, so the port
must be set explicitly). One extra flag is needed for this particular model:

> **`--chat-template zephyr` is required.** TinyLlama-1.1B-Chat uses the Zephyr chat format
> (`<|user|> ... </s> <|assistant|>`). This GGUF was converted before llama.cpp started
> storing chat templates inside GGUF metadata - we checked the file, and it carries none.
> Without the flag the server silently falls back to ChatML, a *different* format, and
> TinyLlama's replies come back garbled or repetitive. `zephyr` is a built-in template name,
> so no file path is needed.

### Windows

**Option A - winget or scoop** (preferred; puts `llama-server` on your `PATH`):

```powershell
winget install llama.cpp
```

**Option B - prebuilt release.** Download the latest `llama-*-bin-win-*.zip` from the
[llama.cpp releases page](https://github.com/ggml-org/llama.cpp/releases), extract it, and
run the binary from that folder.

Then start the server:

```powershell
llama-server `
  -m .\models\tinyllama-1.1b-chat-v1.0.Q4_K_S.gguf `
  -c 2048 --temp 0.7 --repeat_penalty 1.1 -n -1 `
  --chat-template zephyr --alias tinyllama `
  --port 11434 --host localhost
```

**Option C - WSL2.** Follow the Linux instructions inside WSL; Windows reaches the server at
`http://localhost:11434/v1` automatically.

> **Firewall note:** `--host localhost` binds to your machine only, which is what you want.
> Use `--host 0.0.0.0` only if you deliberately want other devices on your network to reach
> the server - anyone on that network then can.

### macOS

Install with Homebrew:

```bash
brew install llama.cpp
```

Apple Silicon gets Metal acceleration automatically - no extra flags needed.

```bash
llama-server \
  -m ./models/tinyllama-1.1b-chat-v1.0.Q4_K_S.gguf \
  -c 2048 --temp 0.7 --repeat_penalty 1.1 -n -1 \
  --chat-template zephyr --alias tinyllama \
  --port 11434 --host localhost
```

<details>
<summary>Building from source (no Homebrew)</summary>

```bash
git clone https://github.com/ggml-org/llama.cpp
cd llama.cpp
cmake -B build
cmake --build build --config Release -j
./build/bin/llama-server --version
```

</details>

> **A note on iOS.** This section covers **macOS**. If you did mean **iOS**: there is no
> supported way to serve a model on port 11434 from an iPhone or iPad for these notebooks.
> iOS apps such as PocketPal or LLM Farm run models on the device but do not expose an
> OpenAI-compatible HTTP server your computer can reach. Use one of the desktop options.

### Linux

**Option A - package manager** (fast, but can lag behind on flags):

```bash
sudo apt update && sudo apt install -y llama.cpp
```

**Option B - build from source** (newest flags, needed for the `-hf` downloader):

```bash
# Debian/Ubuntu build dependencies
sudo apt update && sudo apt install -y build-essential cmake git

git clone https://github.com/ggml-org/llama.cpp
cd llama.cpp
cmake -B build -DGGML_CUDA=OFF      # use -DGGML_CUDA=ON for an NVIDIA GPU
cmake --build build --config Release -j"$(nproc)"
sudo install -m 755 build/bin/llama-server /usr/local/bin/
```

Then, from the repository folder:

```bash
llama-server \
  -m ./models/tinyllama-1.1b-chat-v1.0.Q4_K_S.gguf \
  -c 2048 --temp 0.7 --repeat_penalty 1.1 -n -1 \
  --chat-template zephyr --alias tinyllama \
  --port 11434 --host localhost
```

To use all physical cores for generation, add `-t "$(nproc)"`.

### What the flags mean

| Flag | Purpose |
|------|---------|
| `-m` | Path to the GGUF model file |
| `-c 2048` | Context window. TinyLlama was trained at 2048; larger values degrade quality |
| `--temp 0.7` | Sampling temperature - a middle ground between focused and varied |
| `--repeat_penalty 1.1` | Discourages the repetition small models fall into |
| `-n -1` | Generate until the model stops on its own |
| `--chat-template zephyr` | **Required here** - see the note above |
| `--port 11434` | The port the notebooks expect |
| `--host localhost` | Listen on this machine only |

### Keep it running

The server must stay up for the whole session. Leave that terminal window open and use a
**second** terminal for the notebooks.

When it starts correctly you will see something like:

```
main: server is listening on http://127.0.0.1:11434 - starting the main loop
```

---

## 4. Configure the tutorial

Create your `.env` from the template:

```powershell
Copy-Item .env.example .env      # Windows
```

```bash
cp .env.example .env             # macOS and Linux
```

Edit it to point at your local llama.cpp server:

```ini
USE_OLLAMA=true
LLM_MODEL=tinyllama
BASE_URL=http://localhost:11434/v1
API_KEY=sk-no-key-required
```

| Variable | Value | Why |
|----------|-------|-----|
| `USE_OLLAMA` | `true` | Tells the notebooks to use `BASE_URL` rather than OpenAI |
| `LLM_MODEL` | `tinyllama` | Any name works - llama.cpp ignores the requested model id |
| `BASE_URL` | `http://localhost:11434/v1` | Where the server listens. Keep the `/v1` |
| `API_KEY` | any non-empty text | llama.cpp ignores it, but the client library refuses to start without one |

> `USE_OLLAMA=true` is not a claim that you are running Ollama. The notebooks use it as the
> "local OpenAI-compatible server" switch, and pointing it at llama.cpp is fully supported.

---

## 5. Verify the setup

With the server running, check it answers before opening a notebook:

```powershell
# Windows
curl.exe http://localhost:11434/v1/models
```

```bash
# macOS and Linux
curl http://localhost:11434/v1/models
```

You should get JSON listing your model. Then send an actual chat request:

```bash
curl http://localhost:11434/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "tinyllama",
    "messages": [
      {"role": "system", "content": "You are a helpful travel assistant."},
      {"role": "user", "content": "Name one museum in Paris."}
    ]
  }'
```

A coherent sentence back means you are ready. Launch Jupyter and start with Module 1:

```bash
uv run jupyter lab
```

---

## 6. Troubleshooting

| Symptom | Cause | Fix |
|---------|-------|-----|
| `Connection refused` / `Failed to connect to localhost port 11434` | Server not running, or still on the default port 8080 | Start `llama-server`, or add `--port 11434` |
| `404` on `/v1/chat/completions` | `BASE_URL` is missing the `/v1` suffix | Use `http://localhost:11434/v1` |
| Replies garbled, repetitive, or ignoring the system prompt | Chat template mismatch - server fell back to ChatML | Add `--chat-template zephyr` |
| `Set the OPENAI_API_KEY environment variable or pass it via OpenAIProvider(...)` | `API_KEY` is empty in `.env` | Put any placeholder, e.g. `sk-no-key-required` |
| `Address already in use` | Something else holds port 11434 | Find the process holding the port (`netstat -ano` on Windows, `lsof -i :11434` on macOS/Linux), then stop it |
| Answers cut off mid-sentence | Prompt plus reply exceeded the 2048-token context | Raise `-c`, but expect quality to drop past 2048 |
| Very slow generation | CPU inference with too few threads | Add `-t` set to your physical core count |
| `unknown argument` for `--chat-template` | llama.cpp build too old | Update llama.cpp, or run without it and accept worse replies |
| `'llama' is not recognized` / `unknown subcommand serve` | Older docs show `llama serve`, which no longer exists | Use the `llama-server` binary directly, as shown above |

---

## 7. A note on model quality

TinyLlama is 1.1 billion parameters - orders of magnitude smaller than frontier models. It is
the right choice for confirming your setup works, because it downloads in seconds and runs on
anything. It is **not** a good model, and the course is honest about that:

- It will often ignore system instructions, and it may fail to "fall for" a scripted
  prompt-injection attack - because it is weak, not because a guard stopped it.
- The Module 1 attack lab and the Module 3 detection labs are **deterministic**: they test
  guard logic in plain Python and give the same result regardless of the model.
- Where a lab does depend on model behaviour, run it a few times. Tiny-model output is
  high-variance, and one clean response is not evidence of safety.

When you want stronger results, point `BASE_URL` at a larger local model or a hosted
OpenAI-compatible endpoint. Nothing else in the tutorial needs to change.

---

## 8. Course modules

| # | Module | Status |
|---|--------|--------|
| 1 | [Introduction to AI Vulnerabilities & OWASP Top 10 for LLMs](module_1.ipynb) | Available |
| 2 | [Introduction to Guardrails AI](module_2.ipynb) | Available |
| 3 | [Input Guardrails](module_3.ipynb) | Available |
| 4 | [Output Guardrails](module_4.ipynb) | Available |
| 5 | [End-to-End Integration with Pydantic AI](module_5.ipynb) | Available |

Start with [`ai-guardrails-tutorial.ipynb`](ai-guardrails-tutorial.ipynb) for the overview.

---

## Related Documents

| File | Contents |
|------|----------|
| [`DEVELOPMENT_GUIDE.md`](DEVELOPMENT_GUIDE.md) | Authoring guidelines and the course outline - **for AI agents, not students** |
| [`.env.example`](.env.example) | Environment template with every supported variable |
| [`pyproject.toml`](pyproject.toml) | Dependencies shared by all modules |

## Credits

- [llama.cpp](https://github.com/ggml-org/llama.cpp) - local inference server
- [TinyLlama](https://huggingface.co/TinyLlama/TinyLlama-1.1B-Chat-v1.0) - base model (Apache 2.0)
- [TheBloke](https://huggingface.co/TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF) - GGUF quantization
