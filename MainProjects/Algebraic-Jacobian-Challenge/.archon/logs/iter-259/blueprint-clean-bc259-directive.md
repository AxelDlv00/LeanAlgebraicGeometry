# blueprint-clean directive — bc259

## Scope
Purity gate on the two chapters edited by blueprint-writers this iter:
- `blueprint/src/chapters/Picard_SheafOverEquivalence.tex` (bw259-soe expanded the `unitOverIso` proof sketch)
- `blueprint/src/chapters/Picard_LineBundleCoherence.tex` (bw259-lbc replaced a stale NOTE comment)

## Task
Enforce blueprint purity on these two chapters:
- Strip any Lean-tactic leakage or Lean-syntax phrasing introduced in prose (named identifiers inside
  `\mathtt{...}` are acceptable as the chapters already use them; raw tactic strings / `by ...` blocks
  are not).
- Remove project-history / iteration-narrative verbosity if any crept in.
- Validate citations: both edits concern Archon-original / project-bespoke constructions (no external
  source quote required); ensure no fabricated `% SOURCE` lines were added.
- Do NOT touch `\leanok` / `\mathlibok` markers.
- Do NOT alter mathematical content or any other chapter.
