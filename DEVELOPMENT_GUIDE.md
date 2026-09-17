# Development Guide
This is an interactive Jupyter Notebook that serves as a tutorial on Retrieval-Augmented Generation (RAG).

## Important Notes
- The main tutorial file is ai-guardrails-tutorial.ipynb
- The format should be similar to an online e-learning module with runnable samples in Jupyter code cells. 
- Never install packages. Update the pyproject.toml file instead and run "uv sync".
- Do not create any other external python (.py) files unless they are just temporary scripts.
- All sample code should be in a Jupyter Notebook code cell so that the user can run it interactively. Only sample code to demonstrate the concepts should be created. Code to setup or prepare or initialize the sample code is also okay.
- Facilitate the learning process by adding snippets of runnable python code in code cells. Include explanations as comments in the code and print statements for demonstration.
- Environment variables are expected to be in the .env file. 
- The tutorial outline is in the "Interactive Notebook Course Outline: Implementing AI Guardrails" section below
- Create tables, charts, or diagrams if necessary to facilitate learning. Consider these parts of the lecture or lesson material.
- Tables, diagrams, or charts that are part of the lecture should be shown in markdown cells or raw cells, whichever suits best. Do not ask the user to run a code cell just to see a diagram, chart, or table of a lecture. Tables, diagrams, or chart output via code cell execution is permitted as an output of a sample code.
- Check for JSON parsing errors after each change to rag_tutorial.ipynb with: `python -m json.tool rag_tutorial.ipynb`
- **CRITICAL: The user must be able to run sample codes that are OpenAI or Ollama compatible.**
- **CRITICAL: Maintain valid JSON structure in Jupyter notebooks** - every string must end with `,` except the last one in an array, and all JSON objects must have proper comma separation
- **Always use UTF-8 encoding** when reading or writing files to prevent character encoding issues
- When running Python scripts, ensure you specify `encoding='utf-8'` in file open operations
- Keep all notebook files as UTF-8 encoded JSON
- Environment variables should be set in the `.env` file using UTF-8 encoding
- Generate one module at a time upon my request or approval.

## Environment Variables

BASE_URL
LLM_MODEL
EMBEDDING_MODEL
API_KEY

## Interactive Notebook Course Outline: Implementing AI Guardrails

### Module 1: Introduction to AI Vulnerabilities & OWASP Top 10 for LLMs
* 1.1 Conceptual Overview: The Risks of Unconstrained LLMs
  * Core vulnerabilities: Prompt Injection, Insecure Output Handling, and Data Leakage.
* 1.2 Interactive Lab: Simulating an Exploit
  * Runnable Code: Set up a vulnerable pydantic_ai agent and execute a basic indirect prompt injection attack.
  * Runnable Code: View how malicious system instructions can override default application behavior.

### Module 2: Introduction to Guardrails AI & The Hub
* 2.1 Architectural Concepts: Validators, Guards, and Rails
  * Understanding the Guardrails AI ecosystem and why runtime validation is necessary.
* 2.2 Environment Setup & Initialization
  * Runnable Code: Installing guardrails-ai and downloading specific validation packages from the Guardrails Hub.

### Module 3: Input Guardrails (Shielding the Model)
* 3.1 Detecting Prompt Injection
  * Runnable Code: Integrating the hub://guardrails/prompt_injection validator.
  * Runnable Code: Building an input pre-filter that blocks adversarial user prompts before they reach the LLM.
* 3.2 Preventing PII Leakage
  * Runnable Code: Using hub://guardrails/detect_pii to scan and redact sensitive user information (SSNs, emails) in incoming traffic.

### Module 4: Output Guardrails (Validating Model Responses)
* 4.1 Structural Integrity & JSON Validation
  * Runnable Code: Defining rigid data structures using Pydantic models.
  * Runnable Code: Wrapping the LLM call in a Guardrails wrapper to force schema compliance and trigger automatic re-asking on failure.
* 4.2 Content Moderation & Toxic Output Prevention
  * Runnable Code: Implementing hub://guardrails/toxic_language to catch and block abusive or offensive model generations.
* 4.3 Halucination & Fact-Checking Controls
  * Runnable Code: Setting up hub://guardrails/provenance_llm or similar semantic similarity metrics to ground responses within a provided text context.

### Module 5: End-to-End Integration with Pydantic AI
* 5.1 Building a Production-Ready Guarded Agent
  * Runnable Code: Constructing a comprehensive pydantic_ai.Agent.
  * Runnable Code: Embedding Guardrails AI seamlessly within Pydantic AI's execution pipeline using input/output decorators.
* 5.2 Resiliency Testing
  * Runnable Code: Running a continuous test loop feeding a mix of safe, toxic, and malicious prompts to observe real-time error handling, validation logs, and fallback triggers.

