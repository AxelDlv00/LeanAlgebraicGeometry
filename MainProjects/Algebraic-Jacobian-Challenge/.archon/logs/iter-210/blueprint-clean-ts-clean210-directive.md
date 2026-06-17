# Blueprint Clean Directive

## Slug
ts-clean210

## Target chapter(s)
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Context
A blueprint-writer round (ts-engine210) just re-scoped `lem:tensorobj_assoc_iso`
from arbitrary to ⊗-invertible objects and rewrote its proof to the
local-trivialization construction, removed the old `% NOTE` absorption-iso /
`MonoidalClosed` paragraph, and trimmed `rem:scheme_modules_monoidal_off_path` and
the LOC-estimate section. This chapter is about to be handed to a prover, so it must
be a clean, standalone mathematical document.

## What to clean
- Strip any Lean leakage (tactic syntax, "the prover should…", typeclass-wiring
  asides, declaration-body hints) that may have crept into the prose.
- Strip any project-history / process narrative ("since iteration N", "after the
  pivot", "the old route", references to agents or the Archon loop, "strategy-modifying
  finding" framing).
- Remove redundancy / hedging / meta-commentary left from successive rewrites of
  this chapter (it has been rewritten several times; watch for stale dual claims,
  e.g. any lingering text implying the associator holds for arbitrary modules).
- Verify citation discipline: every block deriving from an external source has a
  `% SOURCE:` (with `(read from references/<file>)`), a verbatim `% SOURCE QUOTE:`
  (and `% SOURCE QUOTE PROOF:` before proof envs where applicable), and a visible
  `\textit{Source: …}` prose line. If a cited block is missing its verbatim quote,
  fetch and insert it (spawn `reference-retriever` if needed; `references/**` is in
  your write-domain).

## Out of scope
- Do NOT change mathematical content or statements — purity/format only.
- Do NOT add `\leanok` / `\mathlibok` markers.
- Do NOT touch other chapters.

## Expected outcome
A purity-clean `Picard_TensorObjSubstrate.tex` ready for prover consumption: no Lean
leakage, no project history, no stale arbitrary-module associator claims, all
external-source blocks carrying verbatim quotes.
