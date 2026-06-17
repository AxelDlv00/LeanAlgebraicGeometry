# Blueprint Writer Directive (iter-172, slug `surjective-pin`)

## Target chapter

`blueprint/src/chapters/AbelianVarietyRigidity.tex` (EXISTING — 1692 LOC; covers AVR.lean + G0BO.lean + RigidityLemma.lean via `% archon:covers`).

## Tasks (small / focused — one chapter, ≤30 LOC edited)

### Task 1 — pin the new substantive sub-lemma

Per iter-171 lean-vs-blueprint-checker `g0bo171` MAJOR finding: `mvPolyToHomogeneousLocalizationAway_surjective` (Lean L372, `AlgebraicJacobian/Genus0BaseObjects.lean`) is a new substantive `sorry` that the iter-171 `aux_left` rewrite depends on, but it is NOT pinned in the blueprint.

**Action**: insert a new `\begin{lemma}[...]` sub-lemma block UNDER `lem:proj_chart_ring_iso_aux_left` (currently at L1100), pinning `\lean{AlgebraicGeometry.mvPolyToHomogeneousLocalizationAway_surjective}`. Statement: the ring-hom `MvPolynomial Unit kbar →+* HomogeneousLocalization.Away (projectiveLineBarGrading kbar) (MvPolynomial.X i)` (the explicit map `t ↦ Away.mk hf 1 (X (otherFin i)) (subseteq_of_mem)`-style assignment used in the project) is surjective. Proof sketch: image equals `Algebra.adjoin (𝒜 0) {the localised generator}` which equals `⊤` by `Away.adjoin_mk_prod_pow_eq_top` (Mathlib `RingTheory/GradedAlgebra/HomogeneousLocalization.lean:1064`) specialised to `d = 1, v = ![X 0, X 1], dv = ![1, 1]`. **Read the Lean file** (`AlgebraicJacobian/Genus0BaseObjects.lean` L370-410) for the exact ring-hom signature you must reproduce in prose.

Include the proven `% SOURCE:` + `% SOURCE QUOTE:` for the Mathlib lemma (read the relevant entry in `references/` — Mathlib pile may not have a verbatim source in `references/`; flag and skip the quote if so).

Add `\uses{def:proj_chart_ring_iso}` to the sub-lemma.

### Task 2 — refresh stale NOTEs

Per iter-171 lean-vs-blueprint-checker `g0bo171` MINOR findings (already partially handled in iter-171 review, but two NOTEs remain stale):

**NOTE on `def:proj_chart_ring_iso`** (L1091-94): currently says "the reverse round-trip ... is currently a scaffold `sorry`... the iso therefore ships sorry-tainted". As of iter-171 the reverse round-trip body is REAL (cancel-surjective); the residual `sorryAx` now propagates through the new helper `mvPolyToHomogeneousLocalizationAway_surjective`. Refresh the NOTE.

**(Already-landed iter-171 review NOTEs to LEAVE ALONE — do NOT re-edit)**:
- `def:gaTranslationP1` L1144-1156 — already refreshed.
- `lem:gmScaling_fixes_zero` L1206 — already refreshed.

### Task 3 — encoding clarification for `def:gm`

Per iter-171 checker `g0bo171` MINOR finding: chapter prose for `def:gm` (L960) does not document the affine-Spec vs basic-open encoding choice. Lean uses affine `Spec (Localization.Away t)`. Add a one-line `% NOTE:` (LaTeX comment, NOT prose) above `def:gm` recording the encoding choice + a one-line visible-prose note.

### Strategy context (slice that matters)

The genus-0 route C committed at iter-163; option (c) inline chart-glue committed at iter-170; body skeleton LANDED iter-171; this iter (172) the prover lane closes the named iter-171 scaffold sorries. Chapter must accurately track the Lean-side state to remain a useful prover reference.

## Out of scope

- Do NOT touch any other chapter.
- Do NOT add or remove `\leanok` or `\mathlibok` markers (`sync_leanok` / review domain only).
- Do NOT rewrite full proof blocks. Just the 3 focused edits above.

## References needed (existing in `references/`)

- `references/abelian-varieties.pdf` (Milne) — already present.
- Mathlib source `RingTheory/GradedAlgebra/HomogeneousLocalization.lean` — may need `references/` lookup if quoting verbatim; flag if `Away.adjoin_mk_prod_pow_eq_top` has no exportable source quote and skip the `% SOURCE QUOTE:` line in that case.

## Verification

Verify by re-reading the edited block + diffing against existing chapter shape. Build is NOT in scope (blueprint compile is the doctor's job).
