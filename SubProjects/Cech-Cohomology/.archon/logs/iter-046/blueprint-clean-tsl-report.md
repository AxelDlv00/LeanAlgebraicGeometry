# blueprint-clean report — iter-046 (tsl)

**Chapter:** `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

## Summary

Four targeted edits applied to purify the iter-046 changes. No mathematical content altered; no `\leanok`/`\mathlibok` touched.

---

## Changes applied

### 1. `lem:tile_section_ring_identity_genV` — statement (Lean leakage in prose)

**Removed** the parenthetical "(The two section-restriction naturality wrappers `\texttt{appIso\_inv\_res}` and `\texttt{appIso\_inv\_res\_assoc}` used in the proof are bundled into this block.)" from the statement body. This named internal Lean helper lemmas in the rendered statement — pure implementation detail.  The `\lean{}` tag already lists these names; no mathematical information is lost.

### 2. `lem:tile_section_ring_identity_genV` — proof (Lean leakage in prose)

**Stripped** the parenthetical "(restated with explicit `\hom`-of-`\le` restrictions and image opens as the wrappers `\texttt{appIso\_inv\_res}` and its associativity-folded variant `\texttt{appIso\_inv\_res\_assoc}` so it rewrites cleanly inside the composite, with explicit order-restriction maps and image opens)" from the naturality argument. The surrounding sentence — asserting that the inverse section iso commutes with restriction — is complete without it and reads as pure mathematics.

### 3. `lem:tile_section_localization` Step 4 — satisfied planner NOTE removed

**Deleted** the `% NOTE (iter-046)` comment that explained the old Lean-engineering blockers (noncomputable-aux hoist, missing R-action, definitional timeout) and said the descent would be restated as restriction of scalars. That restatement is now the body of Step 4, so the NOTE is fully satisfied project history.

### 4. `% NOTE: naive recipe` — Lean jargon cleaned from comment

**Rewrote** the mathematical NOTE that warns against the naive definitional-equality route. Replaced:
- `"the section comparison is the restrict_obj rfl"` → description via `Lemma~\ref{lem:restrict_obj_mathlib}`
- `restrict_obj is rfl only for the local-ring SheafOfModules functor Γ(M,-)` → "holds only for the local-ring section functor"
- `the global-ring functor (modulesSpecToSheaf.obj)` → "the global-ring section functor"

Semantic content (the naive route is UNSOUND because the global-ring functor does not commute with restriction definitionally) is fully preserved.

---

## Verification

- Three companion blocks (`lem:modulesRestrictBasicOpen_smul_eq_genV`, `lem:tile_section_ring_identity_genV`, `lem:tile_scalar_compat_genV`) confirmed to read as mathematics: each has a clearly stated mathematical claim and a one-paragraph informal proof. No tactic names, no instance identifiers, no `letI`/`inferInstance` in prose.
- All `\label{}`, `\lean{}`, `\uses{}`, `% SOURCE`/`% SOURCE QUOTE` comments, and `% NOTE (review iter-045)` markers preserved verbatim.
- No `\leanok`/`\mathlibok` markers touched.
- Final scan: no remaining Lean-syntax leakage or project-history verbosity in prose or non-preserved comments.
