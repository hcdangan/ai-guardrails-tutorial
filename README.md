<div align="center">

# AI Guardrails Tutorial

**A hands-on Jupyter course in AI Guardrails** — attack an unguarded LLM agent, then defend it. Runnable notebooks, no slides.

Five modules and fourteen lessons — three modules written, two in progress — against **OpenAI or a local Ollama server**, without changing a line of code.

[![Python](https://img.shields.io/badge/Python-3.14-3776ab?logo=python&logoColor=white)](https://www.python.org/)
[![uv](https://img.shields.io/badge/uv-0.11-de5fe9?logo=astral&logoColor=white)](https://docs.astral.sh/uv/)
[![Jupyter](https://img.shields.io/badge/Jupyter-4.5-f37626?logo=jupyter&logoColor=white)](https://jupyter.org/)
[![pydantic-ai](https://img.shields.io/badge/pydantic--ai-2.31-e92063?logo=pydantic&logoColor=white)](https://ai.pydantic.dev/)
[![Guardrails AI](https://img.shields.io/badge/Guardrails_AI-0.11-6b4fbb)](https://guardrailsai.com/)
[![OWASP](https://img.shields.io/badge/OWASP-LLM_Top_10_2025-000000?logo=owasp&logoColor=white)](https://genai.owasp.org/)
[![License](https://img.shields.io/badge/license-BSD--3--Clause-blue)](LICENSE)

</div>

---

## What this is

This is a working notebook course for engineers who have to ship an LLM feature and
then defend it. It starts from the failure — Module 1 hijacks an unguarded
`pydantic_ai` agent with an indirect prompt injection and shows the system prompt
falling out the other side — and then builds the defense a layer at a time.

Every lesson is a runnable Jupyter cell, not a slide. The validation code is real
`guardrails-ai` code running against a real model, and the same `.env` drives OpenAI
or a local Ollama server.

The course is organised around the **OWASP Top 10 for LLM Applications (2025)**, so
each lesson maps to a published risk rather than an invented taxonomy. It is also
explicit about what guardrails *cannot* fix: they are one layer of defense, not a
substitute for it.

## Status

| Module | Title | Notebook | Status |
| --- | --- | --- | --- |
| 1 | Introduction to AI Vulnerabilities & OWASP Top 10 for LLMs | `module_1.ipynb` | Complete |
| 2 | Introduction to Guardrails AI | `module_2.ipynb` | Complete |
| 3 | Input Guardrails (Shielding the Model) | `module_3.ipynb` | Complete |
| 4 | Output Guardrails (Validating Model Responses) | `module_4.ipynb` | Planned |
| 5 | End-to-End Integration with Pydantic AI | `module_5.ipynb` | Planned |

Modules are published one at a time. The scope of Modules 4 and 5 is fixed in
[AGENTS.md](AGENTS.md) and listed under [Course outline](#course-outline).

## Architecture

```
notebook cell  ──▶  .env  ──▶  OpenAI  ──or──  Ollama (local)
     │
     ├─ Module 1   unguarded pydantic_ai.Agent        ◀── indirect prompt injection
     │
     └─ Module 2+  the same agent, wrapped:
                    │
            user input ──▶ INPUT RAIL ──▶  LLM  ──▶ OUTPUT RAIL ──▶ user
                            │                          │
                     custom validators          schema / moderation /
                     + DetectPII                grounding / leakage
                            │                          │
                            └────── Guard(rails) ──────┘
                                  guardrails-ai 0.11
```

**One model interface, two backends.** `pydantic_ai` is pointed at an
OpenAI-compatible endpoint via `BASE_URL` + `LLM_MODEL`, so the notebooks run
against OpenAI, Ollama, or any compatible gateway with no code change. The
`.env` file is the only switch.

**Guardrails sit around the agent, not inside it.** A `Guard` binds validators to
the points where untrusted text crosses a trust boundary — in on the input rail,
out on the output rail. Module 1's exploit is the control case; every later module
is measured against it.

## Course outline

**Module 1 — Introduction to AI Vulnerabilities & OWASP Top 10 for LLMs.** The
LLM01–LLM10 taxonomy, why prompt injection is not "just a bad prompt", and a live
indirect injection against an unguarded agent. Establishes the unmitigated baseline
every later module is compared against.

**Module 2 — Introduction to Guardrails AI.** Validators, Guards, and Rails defined
concretely, why runtime validation is necessary, and a custom validator written with
`@register_validator`, tested directly and then enforced through a `Guard`.

**Module 3 — Input Guardrails (Shielding the Model).** Prompt-injection detection
built as a custom input rail, then PII scan-and-redact with the real `DetectPII` Hub
validator — including a look at how it surfaces redacted output via `fix_value`, and
how false positives are handled in practice. An evasion lab that attacks the filter
with character insertion, unicode, and encoding tricks is scoped in
[AGENTS.md](AGENTS.md) and lands with Module 5.

**Module 4 — Output Guardrails.** *(planned)* Pydantic-enforced JSON schema
compliance with automatic re-asking, content moderation, hallucination grounding
against supplied context, and output leakage detection: secrets, credentials, and
system-prompt leakage caught before the response reaches the user.

**Module 5 — End-to-End Integration with Pydantic AI.** *(planned)* A guarded
`pydantic_ai.Agent` with input and output rails wired into its execution pipeline,
tool-call validation, a mixed-traffic resiliency loop that measures the guardrails'
bypass rate, streaming validation, and the observability to report guardrail latency
and false-positive rate.

## Tech stack

| Layer | Choice |
| --- | --- |
| Language | Python 3.14 |
| Environment | `uv` — one shared `pyproject.toml`, reproducible `uv.lock` |
| Courseware | Jupyter notebooks, UTF-8 JSON, cleared outputs |
| Agent framework | `pydantic-ai` 2.31 (`Agent`, `OpenAIChatModel`, `OpenAIProvider`) |
| Guardrails | `guardrails-ai` 0.11 (`Guard`, `Validator`, `@register_validator`) |
| Hub validators | `guardrails-ai-detect-pii` 0.0.6 (`DetectPII`) |
| Model backends | OpenAI-compatible endpoint, or Ollama served locally |
| Security taxonomy | OWASP Top 10 for LLM Applications (2025) |

### A note on the Guardrails Hub

The `hub://guardrails/...` private registry is retired: `guardrails hub install`
prints a deprecation notice and its registry host no longer resolves. Modern
validator packages are ordinary PyPI dependencies imported from the `guardrails_ai`
namespace. This course therefore uses validators that actually resolve, and where
one does not, it teaches the concept by building the validator in the notebook —
which is the more useful lesson anyway.

## Quickstart

```bash
git clone https://github.com/hcdangan/ai-guardrails-tutorial.git
cd ai-guardrails-tutorial
uv sync
```

Create `.env` in the repository root (it is gitignored — see
[Configuration](#configuration)), then launch Jupyter:

```bash
uv run jupyter lab
```

Open `module_1.ipynb` and run the cells top to bottom. Start with Module 1: it
establishes the exploit that every later module defends against.

## Repository layout

```
module_1.ipynb                    vulnerabilities & the OWASP LLM Top 10
module_2.ipynb                    Guardrails AI: validators, guards, rails
module_3.ipynb                    input guardrails: injection + PII
module_4.ipynb                    output guardrails (planned)
module_5.ipynb                    end-to-end guarded agent (planned)
ai-guardrails-tutorial.ipynb      empty notebook shell
pyproject.toml                    shared dependencies for all modules
uv.lock                           pinned, reproducible resolution
AGENTS.md                         course outline + authoring rules
src/ai_guardrails_tutorial/       package marker (no library code)
```

Notebooks are the deliverable. `src/` holds only the package marker that keeps `uv`
happy; there is no importable library behind the course.

## Configuration

All lessons read the same variables from `.env`:

| Variable | Purpose |
| --- | --- |
| `BASE_URL` | OpenAI-compatible endpoint. Point at `http://localhost:11434/v1` for Ollama. |
| `LLM_MODEL` | Model name sent to that endpoint. |
| `API_KEY` | Key for the endpoint. Ollama ignores it, but the client requires a value. |
| `EMBEDDING_MODEL` | Embedding model, for lessons that need one. |
| `USE_OLLAMA` | Switches the notebooks to the local Ollama path. |
| `DEBUG_MODE` | Turns on Guardrails logging, so validation failures are diagnosable. |

A minimal OpenAI `.env`:

```ini
BASE_URL=https://api.openai.com/v1
LLM_MODEL=gpt-4o-mini
EMBEDDING_MODEL=text-embedding-3-small
API_KEY=sk-...
USE_OLLAMA=false
DEBUG_MODE=true
```

The same file against a local Ollama server:

```ini
BASE_URL=http://localhost:11434/v1
LLM_MODEL=llama3.1
API_KEY=ollama
USE_OLLAMA=true
DEBUG_MODE=true
```

## Dataset & safety

Every payload in this course is synthetic and deliberately artificial: the injected
HTML, the fake SSNs and emails, and the attacker prompts are constructed to
demonstrate a technique. No real personal data is used or required, and Module 3
uses the openly documented `DetectPII` validator rather than a home-grown scanner
for exactly that reason.

The attack in Module 1 targets an agent you run yourself, against your own API key.
Nothing in this course is written to be pointed at a third party.

## License

BSD 3-Clause — see [LICENSE](LICENSE). © 2026 Harley C. Dangan.
