# blueprint-clean report — iter-241

## Chapters cleaned
1. `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`
2. `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`

---

## Issues found and fixed

### 1. Picard_TensorObjSubstrate.tex — `lem:pullback_unit_iso` proof (line ~2850)

**Problem:** The prose contained `\(\mathtt{i7}\) step used inside` — a label for a
specific step inside the Lean proof of `IsLocallyTrivial.pullback`, not a
mathematical term.

**Fix:** Removed the step label. The sentence now reads:
> "This instance is used in the proof of the open-immersion case
> `\(\mathtt{IsLocallyTrivial.pullback}\)`: for an open immersion the comparison
> functor is `\(\mathtt{Final}\)` outright, so `\(\mathtt{pullbackObjUnitToUnit}\)`
> is an isomorphism on the nose."

Mathematical content preserved; implementation-step label stripped.

### 2. Cohomology_FlatBaseChange.tex — `lem:gammaPushforwardIsoAt_naturality` proof (line ~358)

**Problem:** The proof referred to `\(\mathrm{eqToHom}\)-naturality of the top-open
ring equation` — `eqToHom` is a Lean/Mathlib combinator name (`eqToHom : X = Y → X ⟶ Y`),
not standard mathematical terminology.

**Fix:** Replaced with the mathematically neutral phrase:
> "the naturality of the canonical isomorphism induced by the top-open ring equation"

Mathematical content preserved; implementation-specific combinator name stripped.

---

## Checks passed

### Math-only purity
- All other new/edited blocks (`lem:unitToPushforwardObjUnit_comp`,
  `lem:pullbackObjUnitToUnit_comp`, and the rewritten `lem:pullback_unit_iso` proof
  outside the single fixed sentence) are clean textbook mathematics with no tactic
  syntax, `infer_instance`, or meta-prose.
- `lem:gammaPushforwardIsoAt_naturality` statement block is clean.
- `lem:pushforward_spec_tilde_iso` rewritten proof (movements 1–3) is clean; the
  `% NOTE:` comment block (LaTeX comment, not visible prose) is left intact as it
  is review-agent domain.

### Source-quote integrity
All existing `% SOURCE QUOTE` / `% SOURCE QUOTE PROOF` comments in both chapters
were not touched by this iter's writer and remain byte-intact (verified by reading
the relevant sections). The new blocks are Archon-original; no source quote was
introduced or fabricated for them.

### Cross-reference validation (no dangling refs, no cycles)
**Picard_TensorObjSubstrate.tex:**
- `lem:unitToPushforwardObjUnit_comp` — no `\uses{}`; references `lem:pullbackObjUnitToUnit_comp` only in prose (no `\uses` entry for it → no cycle).
- `lem:pullbackObjUnitToUnit_comp` — `\uses{lem:unitToPushforwardObjUnit_comp}` (defined immediately above → no cycle).
- `lem:pullback_unit_iso` statement — `\uses{def:scheme_modules_tensorobj}` (exists ✓).
- `lem:pullback_unit_iso` proof — `\uses{def:scheme_modules_tensorobj, lem:pullbackObjUnitToUnit_comp, lem:unitToPushforwardObjUnit_comp}` (all defined above, no cycle ✓).

**Cohomology_FlatBaseChange.tex:**
- `lem:gammaPushforwardIsoAt_naturality` statement — `\uses{lem:gammaPushforwardIsoAt}` (defined above ✓).
- `lem:gammaPushforwardIsoAt_naturality` proof — `\uses{lem:gammaPushforwardIsoAt, lem:globalSectionsIso_hom_comp_specMap_appTop}` (both exist ✓).
- `lem:pushforward_spec_tilde_iso` proof — `\uses{..., lem:gammaPushforwardIsoAt_naturality, ...}` (now defined in this chapter ✓).
- No cycles introduced.

### `\leanok` / `\mathlibok` discipline
- `lem:gammaPushforwardIsoAt_naturality` correctly has neither `\lean{...}` nor `\leanok` (intentionally unpinned) — left as is ✓.
- No other marker changes made.

---

## Verdict: CLEAN — two Lean-leakage items stripped, all other checks pass.
