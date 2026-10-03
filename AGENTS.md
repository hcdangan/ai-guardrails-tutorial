# Development Guide
This is an interactive Jupyter Notebook that serves as a tutorial on Implementing AI Guardrails.

## Important Notes
- Use skills in the skill catalog section.
- The format should be similar to an online e-learning module with runnable samples in Jupyter code cells. 
- Never install packages. Update the pyproject.toml file instead and run "uv sync". In any of the modules, never
instruct the user to update pyproject.toml manually.
- Do not create any other external python (.py) files unless they are just temporary scripts.
- All sample code should be in a Jupyter Notebook code cell so that the user can run it interactively. Only sample code to demonstrate the concepts should be created. Code to setup or prepare or initialize the sample code is also okay.
- Facilitate the learning process by adding snippets of runnable python code in code cells. Include explanations as comments in the code and print statements for demonstration.
- Environment variables are expected to be in the .env file. 
- The tutorial outline is in the "Interactive Notebook Course Outline: Implementing AI Guardrails" section below
- Create tables, charts, or diagrams if necessary to facilitate learning. Consider these parts of the lecture or lesson material.
- Tables, diagrams, or charts that are part of the lecture should be shown in markdown cells or raw cells, whichever suits best. Do not ask the user to run a code cell just to see a diagram, chart, or table of a lecture. Tables, diagrams, or chart output via code cell execution is permitted as an output of a sample code.
- Check for JSON parsing errors after each change to rag_tutorial.ipynb with: `python -m json.tool rag_tutorial.ipynb`
- **CRITICAL: The user must be able to run sample codes that are OpenAI or Ollama compatible.**
- **CRITICAL: All modules share the same pyproject.toml file. When updating the pyproject.toml file, make sure that dependencies of other modules are not affected.***
- **CRITICAL: When working on a module, do not make changes to other modules unless instructed to do so.**
- **CRITICAL: Maintain valid JSON structure in Jupyter notebooks** - every string must end with `,` except the last one in an array, and all JSON objects must have proper comma separation
- **CRITICAL: Always use UTF-8 encoding** when reading or writing files to prevent character encoding issues
- When running Python scripts, ensure you specify `encoding='utf-8'` in file open operations
- Keep all notebook files as UTF-8 encoded JSON
- Environment variables should be set in the `.env` file using UTF-8 encoding
- Generate one module at a time upon my request or approval. Each module should be a separate Jupyter notebook.

## Environment Variables

BASE_URL
LLM_MODEL
EMBEDDING_MODEL
API_KEY
USE_OLLAMA
DEBUG_MODE

## Skill Catalog
Skills are pre-packaged capabilities available to the agent working on this project. Load one with the `skill` tool, using the exact skill name, before acting on a matching task. This catalog lists skills that support *building* the tutorial; it is not part of the course content.

### `agent-reach` — Internet Research and Content Retrieval

**Purpose:** Read access to the live internet across 16 platforms — any web page, Exa semantic search, YouTube, GitHub, RSS, V2EX, Bilibili, Twitter/X, Reddit, Facebook, Instagram, LinkedIn, 小宇宙播客, 雪球, 小红书, and Boss直聘.

**When to use it:**
- Researching lesson material: OWASP Top 10 for LLMs, prompt injection techniques, guardrail design patterns.
- Knowing how to use the Guardrails AI library from this website: https://guardrailsai.com/hub
- Verifying current `guardrails-ai` / `pydantic_ai` APIs, `hub://guardrails/...` validator names, and version changes *before* writing sample code into a module.
- Checking how the community currently solves a problem a module covers.

**When NOT to use it:**
- **Never** as a source of project dependencies, and never to install anything into this project — see "Never install packages" in Important Notes.
- Read-only retrieval only. Do not post, comment, like, or otherwise write to any platform.
- Not for content authoring (writing lessons, analysis, translation) — it only fetches source material.

**Status on this machine:** `agent-reach` v1.5.0 installed and already available to the agent. 5/16 channels active. Working now: Web (Jina Reader), Exa semantic search, YouTube, GitHub, RSS, V2EX, Bilibili search. The credential-based channels (Twitter/X, Reddit, Facebook, Instagram, 小红书, 雪球, LinkedIn, 小宇宙, Boss直聘) are **not** configured — ask the user before attempting to add them.

**Health check:**
```powershell
agent-reach doctor --json
```

**Notes:**
- Agent Reach is **agent tooling, not a project dependency**. Never add it to `pyproject.toml` and never install it via `uv sync`; that rule governs the tutorial's own Python packages only.
- Full command reference: `~/.agents/skills/agent-reach/SKILL.md`, plus `references/*.md` for per-platform details.

## Interactive Notebook Course Outline: Implementing AI Guardrails
**CRITICAL: Do not make changes to the course outline without approval**

### Outline Conventions (apply to every module)
- **Learning objectives:** Every module states explicit "By the end of this module you can..." objectives. These are shown as a markdown cell at the top of the notebook and are written as testable outcomes.
- **Validator availability:** Always verify a Hub validator actually resolves in *this* project's environment before writing it into a lesson. The `hub://guardrails/...` private registry is retired in `guardrails-ai` 0.11 — see 2.2. Where a validator is unavailable, teach the concept with a custom validator built in the notebook.
- **Required dependencies:** `guardrails-ai` and `guardrails-ai-detect-pii` are managed in `pyproject.toml`. No module may install packages at runtime.

### Module 1: Introduction to AI Vulnerabilities & OWASP Top 10 for LLMs
**Objectives:** Explain the LLM-specific risks in the OWASP Top 10 for LLM Applications (2025); run an indirect prompt injection against an unguarded agent and describe why it succeeded; map a running application to at least three OWASP LLM categories.

* 1.1 Conceptual Overview: The Risks of Unconstrained LLMs
  * Core vulnerabilities: Prompt Injection, Insecure Output Handling, and Data Leakage.
  * The OWASP Top 10 for LLM Applications (2025) as the organizing taxonomy: LLM01 Prompt Injection, LLM02 Sensitive Information Disclosure, LLM03 Supply Chain, LLM04 Data and Model Poisoning, LLM05 Improper Output Handling, LLM06 Excessive Agency, LLM07 System Prompt Leakage, LLM08 Vector and Embedding Weaknesses, LLM09 Misinformation, LLM10 Unbounded Consumption.
  * Which of the ten are addressable with runtime guardrails and which are not — guardrails are one layer of defense, not a complete fix.
* 1.2 Interactive Lab: Simulating an Exploit
  * Runnable Code: Set up a vulnerable pydantic_ai agent and execute a basic indirect prompt injection attack.
  * Runnable Code: View how malicious system instructions can override default application behavior.
  * Runnable Code: Re-run the same attack with no guardrail to establish the unmitigated baseline used for comparison in later modules.

### Module 2: Introduction to Guardrails AI
**Objectives:** Distinguish validators, guards, and rails, and say where each sits in a request lifecycle; set up the project environment via `pyproject.toml` and `uv sync` without installing anything from a notebook; write and test a custom validator using `@register_validator`.

* 2.1 Architectural Concepts: Validators, Guards, and Rails
  * Understanding the Guardrails AI ecosystem and why runtime validation is necessary.
  * The three terms defined concretely: a **Validator** checks one value, a **Guard** binds validators to an LLM call, and **Rails** are the input/output stages a Guard enforces at.
  * Why the input rail and the output rail are different problems: the input rail inspects untrusted text before it reaches the model, the output rail inspects model-generated text before it reaches the user.
* 2.2 Environment Setup & Initialization
  * Not a lesson in package installation. Dependencies (`guardrails-ai`, `guardrails-ai-detect-pii`) live in `pyproject.toml` and are installed with `uv sync`; environment variables live in `.env`.
  * Runnable Code: Import `Guard`, `Validator`, and `@register_validator`, confirm the installed version, and inspect where validation hooks are available.
  * Runnable Code: Enable `DEBUG_MODE` and observe the Guardrails logging output so failures are diagnosable later.
  * Note for the author (teaching moment, not course content): the `hub://guardrails/...` private registry is retired — `guardrails hub install` prints a deprecation notice and its registry host no longer resolves. Modern validator packages are distributed as ordinary PyPI dependencies and imported from the `guardrails_ai` namespace, e.g. `from guardrails_ai.detect_pii import DetectPII`.

### Module 3: Input Guardrails (Shielding the Model)
**Objectives:** Build an input pre-filter that blocks adversarial prompts before they reach the LLM; scan and redact PII in inbound traffic with a real Hub validator; demonstrate at least two techniques that evade a naive filter and explain the fix.

* 3.1 Detecting Prompt Injection
  * Runnable Code: Building an input pre-filter that blocks adversarial user prompts before they reach the LLM, and wiring it as an input rail.
  * Runnable Code: Building the injection detector as a custom validator. The retired `hub://guardrails/prompt_injection` validator is used as the historical reference point and as the reason a custom validator is the practical path.
  * Runnable Code: Showing what the pre-filter costs — added latency and prompt volume per call.
* 3.2 Preventing PII Leakage
  * Runnable Code: Using the real Hub validator `DetectPII` (`from guardrails_ai.detect_pii import DetectPII`) to scan and redact sensitive user information (SSNs, emails) in incoming traffic.
  * Runnable Code: Evasion lab — attempt to slip PII past the detector using character insertion, unicode, and encoding tricks, then close the gaps. Regex-based detection is deliberately imperfect and the lesson is to measure the bypass rate, not assume zero.
  * Runnable Code: Handling a false positive, including the fail-open versus fail-closed decision for an input rail.

### Module 4: Output Guardrails (Validating Model Responses)
**Objectives:** Force schema compliance with automatic re-asking on failure; moderate toxic output; ground a response in supplied context; detect and redact secrets, PII, and system-prompt leakage in outbound text.

* 4.1 Structural Integrity & JSON Validation
  * Runnable Code: Defining rigid data structures using Pydantic models.
  * Runnable Code: Wrapping the LLM call in a Guardrails wrapper to force schema compliance and trigger automatic re-asking on failure.
  * Runnable Code: Observing what re-asking does to cost and latency, and deciding when a bounded retry count should give up.
* 4.2 Content Moderation & Toxic Output Prevention
  * Runnable Code: Catching and blocking abusive or offensive model generations on the output rail.
  * Runnable Code: Implementing the moderation validator directly and noting that the historical `hub://guardrails/toxic_language` Hub package is no longer resolvable here, so the concept is demonstrated with an available or custom validator.
* 4.3 Hallucination & Fact-Checking Controls
  * Runnable Code: Setting up semantic similarity metrics to ground responses within a provided text context and flag unsupported claims.
  * Runnable Code: Implementing the check directly, noting that the historical `hub://guardrails/provenance_llm` Hub package is no longer resolvable here, so the grounding check is built from an available or custom metric.
  * Runnable Code: Discussing how grounding is scored and why a similarity threshold is a tunable tradeoff between missed hallucinations and false accusations.
* 4.4 Output Leakage & Secret Detection
  * Runnable Code: Scanning model output for PII, API keys, credentials, and other secrets before the response reaches the user.
  * Runnable Code: Detecting system-prompt leakage and validating it with a canary string planted in the system prompt.
  * Closing the loop on Module 1: this is the outbound half of LLM02 Sensitive Information Disclosure, and it is the higher-severity direction because the model may disclose context the user never sent.

### Module 5: End-to-End Integration with Pydantic AI
**Objectives:** Build a guarded `pydantic_ai.Agent` with input and output rails; run a mixed-traffic test loop and report real error handling and fallback behavior; explain why streaming breaks output validation and how to validate a stream; log guardrail decisions as an audit trail.

* 5.1 Building a Production-Ready Guarded Agent
  * Runnable Code: Constructing a comprehensive pydantic_ai.Agent.
  * Runnable Code: Embedding Guardrails AI within Pydantic AI's execution pipeline using input/output decorators.
  * Runnable Code: Validating tool calls, since an agent that can act is where an unchecked value causes the most damage.
* 5.2 Resiliency Testing
  * Runnable Code: Running a continuous test loop feeding a mix of safe, toxic, and malicious prompts to observe real-time error handling, validation logs, and fallback triggers.
  * Runnable Code: Testing the guardrails themselves against evasive inputs from the 3.2 evasion lab, so the learner measures bypass rate rather than only happy-path success.
* 5.3 Streaming & Asynchronous Validation
  * Runnable Code: Showing why a single end-of-response validation pass does not work on a stream, and demonstrating incremental validation over chunks.
  * Runnable Code: Handling the case where a chunk already reached the user before a later chunk failed validation.
* 5.4 Observability & Operational Tradeoffs
  * Runnable Code: Logging every guardrail decision (validator, verdict, latency) to produce an audit trail.
  * Runnable Code: Measuring guardrail overhead and false-positive rate so the safety-versus-usability tradeoff is decided with numbers rather than intuition.

## === AUTOMATIC CLEANUP & SAFETY RULES (MUST FOLLOW) ===
# =============================================================================
# THESE RULES MUST BE FOLLOWED TO PREVENT MISSED FILES AND DATA LOSS

## RULE #1: WORK IN ORIGINAL FILE FIRST - TEST BEFORE REPLACING
# Before making ANY changes to a notebook (.ipynb):
# 1. READ the current contents using: read file_path
# 2. VERIFY you understand the complete structure and all cells
# 3. Make small, TARGETED edits using the edit tool (never replace entire files)
# 4. VERIFY edits are valid JSON: python -m json.tool module_*.ipynb
# 5. ONLY THEN apply changes - keep the original safe until verified

## RULE #2: NO TEMPORARY FILES IN FINAL OUTPUT - CLEAN UP IMMEDIATELY
# The following are ALLEGED TEMPORARY FILES that MUST BE DELETED:
# - *.corrected, *.fixed, *.backup - backup test files
# - test_*.py, _test_*.py - standalone test scripts (unless explicitly requested)
# - *.tmp, *.temp, *.scratch - any temporary helper files
# - module_*.fixed, module_*.corrected - notebook backups
# Action: These must be deleted AFTER every task completion
# Clean command: Remove-Item -Path "*.corrected" "*.fixed" "*.backup" "*.tmp" "*.temp" "test_*.py" module_*.fixed -Force

## RULE #3: ALWAYS VERIFY JSON VALIDITY AFTER NOTEBOOK EDITS
# After ANY notebook change:
# python -m json.tool module_2.ipynb
# Should output "Expecting value: line 1 column 1 (char 0)" for empty or valid JSON
# OR exit code 0 for valid JSON
# If invalid: fix the JSON BEFORE continuing

## RULE #4: EDIT SMALLER CHUNKS - ONE CELL AT A TIME
# When modifying notebooks:
# - Edit ONE cell at a time, not multiple
# - When using edit tool: keep old_string EXACT (read file FIRST)
# - Don't replace entire files with write unless absolutely necessary
# - Use edit tool for targeted changes OVER write tool

## RULE #5: BACKUPS ARE TEMPORARY AND MUST BE CLEANED EVERY SESSION
# If you create a backup during troubleshooting:
# 1. Complete the fix in the ORIGINAL file first
# 2. NEVER leave backup files in the directory
# 3. Run cleanup AFTER EVERY session ends

# =============================================================================
## CLEANUP COMMAND (RUN AT END OF EVERY TASK):
# Remove-Item -Path "*.corrected" "*.fixed" "*.backup" "*.tmp" "*.temp" "test_*.py" -Force 2>$null
# Verify notebooks load: python -c "import json; [json.load(open(f)) for f in (\\'.*\\.ipynb\\' if \\'.*\\.ipynb\\' else \\'.*)\'])" 2>$null
# =============================================================================
