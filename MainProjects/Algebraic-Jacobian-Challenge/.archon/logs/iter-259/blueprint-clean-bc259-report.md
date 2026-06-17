# blueprint-clean report — bc259

## Scope
- `blueprint/src/chapters/Picard_SheafOverEquivalence.tex`
- `blueprint/src/chapters/Picard_LineBundleCoherence.tex`

## Findings and actions

### Picard_SheafOverEquivalence.tex — no changes required

The `unitOverIso` proof expansion (bw259-soe, lines 155–197) is clean:
- All Lean identifiers are inside `\mathtt{...}` (e.g.\ `\mathtt{unitToPushforwardObjUnit\_val\_app\_apply}`, `\mathtt{NatTrans.isIso\_iff\_isIso\_app}`).
- No raw tactic strings or `by ...` blocks.
- No iteration-narrative references.
- No fabricated `% SOURCE` lines. The pre-existing `% SOURCE:` block (lines 14–24) explicitly declares itself a Mathlib provenance note, not an external literature citation, and predates this iteration.
- `\leanok` markers untouched.

### Picard_LineBundleCoherence.tex — one NOTE comment fixed

**Issue**: The `% NOTE` comment introduced by bw259-lbc (inside the proof of `lem:lbc_chart_presentation`) contained two purity violations:
1. `(updated iter-259)` — explicit iteration-narrative label.
2. `"The local chartOverIso def in LineBundleCoherence.lean is a redirect to it and carries no sorry; this file is locally sorry-free. No bridge block is needed in this chapter."` — Lean-implementation details (sorry count, redirect mechanics, scaffolding guidance) with no mathematical content.

**Fix applied** (lines 206–210): replaced with a concise cross-reference preserving the mathematical content:

```
  % NOTE. The over-restrict categorical bridge is the shared construction
  % `Scheme.Modules.chartOverIso` (lem:chart_over_iso,
  % chap:Picard_SheafOverEquivalence).
```

No other content was altered. `\leanok` / `\mathlibok` markers were not touched. No fabricated `% SOURCE` lines were found in this chapter's new content.

## Summary
- 1 file changed (1 comment cleaned).
- 1 file unchanged (clean as written).
- No citations to add or validate (both constructions are Archon-original).
- No retriever spawned.
