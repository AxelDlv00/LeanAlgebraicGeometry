# Blueprint-clean directive — Picard_QuotScheme.tex

## Scope
Clean ONLY `blueprint/src/chapters/Picard_QuotScheme.tex`, focusing on the two blocks just added by
the blueprint-writer this iter:
- `lem:annihilator_localization_eq_map` (algebra engine lemma)
- `lem:qcoh_section_localization_basicOpen` (QCoh→IsLocalizedModule bridge)
and the edited `def:modules_annihilator`.

## Tasks
- Strip any Lean tactic syntax / Lean-code leakage from the informal prose (math only).
- Verify every `% SOURCE:` carries a `(read from references/<file>)` parenthetical and that the
  `% SOURCE QUOTE:` text is genuinely present in the named local file; if a quote was flagged
  "verbatim text not yet retrieved" and a source is readily fetchable, spawn a reference-retriever
  to obtain it; otherwise leave the flag intact (do NOT fabricate a quote).
- Remove project-history verbosity / iter-narrative from the prose (keep concise `% NOTE` flags only
  where they carry a live blocker).
- Do NOT touch `\leanok`. Leave `\mathlibok` only on the genuine Mathlib anchor.
- Do NOT modify any other chapter or the Lean file.
