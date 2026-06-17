# Lean ↔ Blueprint Checker Directive

## Slug

g0bo-iter167

## Lean file

`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Genus0BaseObjects.lean`

## Blueprint chapter

`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/AbelianVarietyRigidity.tex`

(This chapter declares `% archon:covers AlgebraicJacobian/AbelianVarietyRigidity.lean
AlgebraicJacobian/Genus0BaseObjects.lean`; this dispatch checks Genus0BaseObjects.
The AVR side is the subject of a sister dispatch `avr-iter167`.)

## Iter-167 prover delta (for context only)

Lane A landed 4 new axiom-clean exports + 3 scaffold-sorry exports:

- **Axiom-clean** (verify each is genuinely so):
  - `gmRing_isDomain` (L395-ish) — `Localization.Away` of a polynomial-ring
    domain via `IsLocalization.isDomain_localization`.
  - `gm_irreducibleSpace` (L404-ish) — chains `gmRing_isDomain` →
    `PrimeSpectrum.irreducibleSpace`.
  - `projGm_locallyOfFiniteType` — `change` + `infer_instance` via
    LOFT base-change + composition stability on
    `(X ⊗ Y).hom = pullback.fst X.hom Y.hom ≫ X.hom`.
  - `projGm_geomIrred` — `GeometricallyIrreducible.comp` (propagates
    `gm_geomIrred` + `projectiveLineBar_geomIrred` sorries).
- **Scaffold sorries**:
  - `projectiveLineBar_isReduced` — Mathlib gap on
    `IsReduced (HomogeneousLocalization.Away …)`.
  - `gm_geomIrred` — Mathlib gap on tensor-of-domains-over-field.
  - `projGm_isReduced` — propagates `projectiveLineBar_isReduced` + the
    `Smooth → GeometricallyReduced` Mathlib gap.

5 OPT-IN sorries remain unchanged: `projectiveLineBar_geomIrred` (L177),
`projectiveLineBar_smoothOfRelDim` (L184), `ga_grpObj` (L335),
`gm_grpObj` (L420), `gmScalingP1` (L459), `gmScalingP1_collapse_at_zero`
(L476).

## Checks to perform (bidirectional)

1. **Lean → blueprint** — does the chapter cover every load-bearing
   declaration in Genus0BaseObjects.lean? In particular the 3 NEW
   scaffold-sorry exports and the 4 NEW axiom-clean instances. The
   iter-167 `avr-lean-hooks` writer pass added per-decl `\lean{...}`
   blocks under `def:genus0_base_objects` — verify they cover at least
   the load-bearing decls.
2. **Blueprint → Lean** — does the chapter's `\lean{...}` hooks point to
   declarations that actually exist with the cited name + signature?
   The iter-167 writer pass promoted 3 "[expected]" annotations to real
   `\lean{...}` hooks; verify those names exist now.
3. **Marker hygiene** — flag any blueprint blocks whose `\leanok` /
   `\notready` semantics are out of step with actual Lean state
   (informational; the `sync_leanok` phase owns `\leanok`).
4. **Excuse comments** — flag any `-- TODO:` / "will fix later" prose
   in the Lean file.
5. **Scaffold-`sorry` docstring honesty** — for the 3 new scaffold
   sorries, do their Lean docstrings honestly describe the Mathlib gap
   (vs. smuggled-in excuse-comments)?

## Output

Bidirectional report in the standard format. Must-fix-this-iter issues
block downstream work on Genus0BaseObjects; minor recommendations go to
recommendations.md.
