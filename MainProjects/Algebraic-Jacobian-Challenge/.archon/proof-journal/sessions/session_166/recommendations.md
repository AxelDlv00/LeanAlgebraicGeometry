# Iter-167 Plan Agent — Recommendations

## CRITICAL

None. No must-fix-this-iter findings (the g0bo-iter166 must-fix on `gmScalingP1` body is plan-marked
deferred — already tracked, not a fresh discovery).

## HIGH — closest-to-completion targets

### 1. Discharge the 5 helper-internal sorries in `morphism_P1_to_grpScheme_const_aux`

`AlgebraicJacobian/AbelianVarietyRigidity.lean` L944/L949/L953/L1029/L1037. Auditor confirms all
5 are honest open math obligations, NOT laundering. Once they close, both
`morphism_P1_to_grpScheme_const` (L1089) and `rigidity_genus0_curve_to_grpScheme` (L1156) lift to
axiom-clean automatically (modulo the RR-bridge `genusZero_curve_iso_P1`).

Per-sorry estimated routes:

- **L944 `GeometricallyIrreducible ((ProjectiveLineBar kbar) ⊗ Gm kbar).hom`** — needs
  product-of-geom-irred Mathlib bridge over an alg-closed base. Mathlib likely has the morphism
  property `IsStableUnderBaseChange` for `GeometricallyIrreducible`; if not directly, derive via
  `ProjectiveLineBar.left` and `Gm.left` geom-irred individually + `MorphismProperty` plumbing.
  Recommend `mathlib-analogist (api-alignment)` consult: "is `GeometricallyIrreducible` stable
  under tensor products in `Over (Spec k̄)` for `k̄` alg closed?"
- **L949 `LocallyOfFiniteType ((ProjectiveLineBar kbar) ⊗ Gm kbar).hom`** — `ℙ¹` is LOFT via
  `Proj` of FT ring, `Gm` is LFP hence LOFT; product preserves LOFT. Mathlib should have
  `MorphismProperty.IsStableUnderBaseChange.of_isPullback` for LOFT directly.
- **L953 `IsReduced ((ProjectiveLineBar kbar) ⊗ Gm kbar).left`** — both factors reduced +
  perfect (alg-closed) base ⟹ product reduced. Search for
  `IsReduced.isStableUnderBaseChange` / `Algebra.TensorProduct.reduced`.
- **L1029 `IsReduced (ProjectiveLineBar kbar).left`** — `Proj`-of-MvPolynomial integrality.
  Mathlib does not package this directly for the standard ℕ-grading; may need a short helper
  via `Proj.isReduced_of_isReduced` or a Hartshorne-style "Proj of an integral graded ring is
  integral" argument.
- **L1037 `IsDominant iotaGm.left`** — depends on the concrete `gmScalingP1` body (Lane 2 deferred);
  lifts automatically once `gmScalingP1` lands. NO independent action — schedule alongside Lane 2.

**Bundled estimate:** ~1 iter of bookkeeping once the right Mathlib lemmas are located. Start
with a `mathlib-analogist` consult on all 4 product-stability + Proj-integrality questions
before the prover lane.

### 2. `gm_grpObj` via `GrpObj.ofRepresentableBy` + units functor

`AlgebraicJacobian/Genus0BaseObjects.lean` L400. The CRITICAL deferred sorry from iter-166 Lane 2.
Mathlib has the algebraic machinery (`IsLocalization.away_of_isUnit_of_bijective`,
`AffineSpace.homOverEquiv`) but does not ship the units-functor → `Spec k̄[t,t⁻¹]`
representable-by witness; sub-build is non-trivial. **Plan recommendation: BEFORE prover dispatch,
run `mathlib-analogist (api-alignment)`** scoped to:
- "Does Mathlib package `Hom(T, Spec (Localization.Away t)) ≃ Γ(T, ⊤)ˣ` as a
  `RepresentableBy`?"
- "What is the standard Mathlib idiom for installing `GrpObj` on `Spec (Localization.Away t)`
  via the units functor?"
- "Is there a precedent for installing `GrpObj` on `AffineSpace`-like schemes via
  `GrpObj.ofRepresentableBy` we can mirror?"

### 3. `gmScalingP1` body via `Scheme.Cover.glueMorphisms`

`AlgebraicJacobian/Genus0BaseObjects.lean` L439. The chartwise glue requires the two
`Spec.map`-of-ring-map chart morphisms (`t ↦ λ·t` on `𝔸¹ × Gm`, `u ↦ u/λ` near `∞`) +
overlap-agreement. Chapter prose at `AbelianVarietyRigidity.tex` L960-965 gives the exact
prescription. Likely coordinated with (2) — `gm_grpObj` lands the ring-level multiplication
that `gmScalingP1`'s chartwise ring maps use.

### 4. `gmScalingP1_collapse_at_zero` body

`AlgebraicJacobian/Genus0BaseObjects.lean` L456. Strictly downstream of (3). Once `gmScalingP1`
has a body, this reduces to a chart-level `(λ·0 = 0)` ring-map computation.

## MEDIUM — promising approaches needing more work

### 5. `genusZero_curve_iso_P1` (RR bridge, dominant long pole)

`AlgebraicJacobian/AbelianVarietyRigidity.lean` L1131. The genus-0 path's dominant long pole
(STRATEGY-flagged "no Mathlib RR"). Iter-167+ approach:

- First dispatch a `reference-retriever` + `mathlib-analogist (api-alignment)` consult
  on whether Mathlib has any divisor / RR / degree-map machinery to leverage. Genus-0 → ℙ¹ has
  multiple textbook realizations:
  - Hartshorne IV.1.3.5 via Riemann–Roch.
  - Canonical-divisor degree-2-pole-free divisor argument.
  - Hurwitz-style by-genus-bound.
- If Mathlib has even a partial degree-1 divisor / map-to-ℙ¹ characterization (e.g. via the
  Hodge bundle, or via `Module.finrank (H⁰(C, L)) = ⌊…⌋` for a divisor of suitable degree), a
  short adapter may suffice. If not, this stays a multi-iter sub-build and needs its own
  strategy phase.

### 6. Blueprint `\lean{...}` per-decl coverage gap (still open from iter-165)

`blueprint/src/chapters/AbelianVarietyRigidity.tex` `def:genus0_base_objects` /
`def:gaTranslationP1` blocks. Per the iter-166 g0bo-iter166 checker:
- Add per-decl `\lean{...}` hooks for `ProjectiveLineBar.zeroPt`, `.onePt`, `.inftyPt` (the 3
  k̄-points landed iter-166).
- Add `\lean{...}` for `gm_grpObj` (live consumer for iter-167+ refactor).
- Add `\lean{...}` for `gmScalingP1_collapse_at_zero`.
- Promote the "[expected]" annotations for `Ga`, `Gm`, `gaTranslationP1` to real `\lean{...}`
  hooks (Lean names landed for `Ga`, `Gm`; `gaTranslationP1` still un-declared).

Recommended action: ONE blueprint-writer dispatch on `AbelianVarietyRigidity.tex` scoped to
the per-decl-hook coverage gap (low LOC, low risk).

### 7. Helper-`\lean{...}` consideration

`AbelianVarietyRigidity.tex` `prop:morphism_P1_to_AV_constant` proof block. Per
`lean-vs-blueprint-checker avr-iter166` (informational): either
- (a) add a `\lean{AlgebraicGeometry.morphism_P1_to_grpScheme_const_aux}` block describing
  the basepoint helper, OR
- (b) explicitly state in the proof block that the Lean factors into outer translation
  reduction + private basepoint helper.

Cosmetic — not blocking.

## LOW — hygiene debt and excuse-comment cleanup

### 8. Strip the 5 redundant `-- TODO:` excuse-comments

`AlgebraicJacobian/AbelianVarietyRigidity.lean` L943/L947-948/L952/L1028/L1034-1036. Per
`lean-auditor-iter166`: these duplicate the kernel `sorry` alarm + the helper's docstring
disclosure (L924-930). Strict excuse-comment per the auditor rubric. **Recommend:** drop the
inline `-- TODO:` prose lines; let the `sorry`s + docstring carry the alarm.

Trivial single-iter cleanup; bundle with any other prover lane in iter-167.

### 9. Stale-narrative purge across 6 files (carry-over from iter-164)

Long-standing major hygiene debt:

- `Jacobian.lean:237-263` — 26-line stale narrative inside `genusZeroWitness` describing 3
  route-(a) blockers; route-(c) headline now exists in `AbelianVarietyRigidity.lean`. Rewrite
  to a one-liner pointing to `rigidity_genus0_curve_to_grpScheme`.
- `RigidityKbar.lean:9-89` — module narrative still treats `rigidity_over_kbar` as the
  "M2.a sub-step keystone"; demoted to fallback artifact iter-156. Trim to a fallback
  marker.
- `Cotangent/GrpObj.lean:297-326` — "Piece (i.b)" narrative naming iter-145-EXCISED
  declarations.
- `Cotangent/GrpObj.lean:465-525` — "iter-138 PARTIAL skeleton" describing now-excised
  declarations' planned sub-goals. Severely stale.
- `Cotangent/GrpObj.lean:552-560, 624-629` — Two "iter-145 EXCISE" stub comments; defensible
  but bloat.
- `Cotangent/ChartAlgebra.lean:36-79` — module docstring describes the iter-144 chart-algebra
  pivot; off-path post route-(c). Mildly stale; per-declaration documentation is accurate.

Recommended: ONE hygiene-only iter (refactor subagent or a dedicated prover comment-only
lane on each file) before the debt grows further. Off the genus-0 critical path; can slip
indefinitely without harming the proof, but each iter the carry-over accumulates more
stale-narrative debt in the auditor reports.

## Blocked targets — do NOT re-assign without structural change

### `genusZeroWitness.key` (Jacobian.lean L265)

Gated on `rigidity_genus0_curve_to_grpScheme` becoming axiom-clean, which itself depends on
- the 5 helper sorries in `morphism_P1_to_grpScheme_const_aux`,
- `genusZero_curve_iso_P1`'s RR-bridge body,
- which depends on the 3 CRITICAL deferred sorries in `Genus0BaseObjects.lean`
  (`gm_grpObj`, `gmScalingP1` body, `gmScalingP1_collapse_at_zero` body).

Do NOT attempt `genusZeroWitness.key` until iter-167+ closes at least items 1–4 above.

### `positiveGenusWitness` (Jacobian.lean L303)

Off-critical-path per docstring. Schedule after the genus-0 arm closes.

### `rigidity_over_kbar` (RigidityKbar.lean L88)

Fallback artifact; per iter-156 strategy decision the route (a) is demoted in favor of route
(c). Do NOT prover-dispatch unless an explicit strategy reversal happens (would need a
strategy-critic re-dispatch). Touching the file is comment-only / narrative-cleanup territory.

## Reusable proof patterns discovered this iter

(See PROJECT_STATUS.md Knowledge Base for the canonical entries.)

- **`Proj.fromOfGlobalSections` k̄-point constructor `pointOfVec`** — shared helper parametrised
  over a `Fin 2 → kbar` evaluation vector + `IsUnit (v i)` certificate; the irrelevant-ideal
  condition discharges via `HomogeneousIdeal.mem_irrelevant_of_mem` + `MvPolynomial.isHomogeneous_X`
  + `Ideal.eq_top_iff_one` + `IsUnit.map`. Reusable for any "explicit k̄-rational point on
  `Proj 𝒜`" construction.
- **Iso-transport of a rigidity headline through a curve-iso `C ≅ ℙ¹`** — clean
  `obtain ⟨φ⟩` + `set g := φ.inv ≫ f` + apply on `g` + pin via basepoint transport +
  back-transport via `Iso.hom_inv_id`. Reusable for any "headline-on-target factors through
  iso-substituted source".
- **`set ι := …` traps on near-reserved tokens** — rename to ASCII (`iotaGm`).
- **`IsSeparated A.hom` from `[IsProper A.hom]` only** — derive explicitly via
  `IsProper.toIsSeparated`; bare `‹...›` fails when only `[IsProper]` is in scope.
- **Inline `ext_of_isDominant_of_isSeparated'` when `Scheme.Over.ext_of_eqOnOpen` is downstream**
  — pattern recurs whenever a new upstream file needs the dominant-globalisation argument that
  lives in `AlgebraicJacobian.Rigidity` (which is downstream of any file imported by
  `Jacobian`).

## Dispatch sanity for iter-167

- **2 lanes possible** (independent helper-discharge in AVR + `gm_grpObj`/`gmScalingP1` in
  Genus0BaseObjects), but the AVR helper lane partially depends on Lane 2 (`IsDominant
  iotaGm.left`). Recommended sequencing:
  - **Iter-167 = Lane A + Lane B in parallel:** (A) `gm_grpObj` + `gmScalingP1` body +
    `gmScalingP1_collapse_at_zero` body in `Genus0BaseObjects.lean` (after analogist consult);
    (B) the 4 NON-iotaGm helper sorries in `morphism_P1_to_grpScheme_const_aux` (product
    instances + `IsReduced ProjectiveLineBar.left`) plus the redundant-TODO cleanup.
  - **Iter-168:** `IsDominant iotaGm.left` once `gmScalingP1` has a body; then
    `rigidity_genus0_curve_to_grpScheme` lifts to axiom-clean modulo RR.
  - **Iter-169+:** the RR-bridge sub-build (long pole).
- A 3rd lane on stale-narrative purge could ride along iter-167 if the helper bookkeeping
  finishes early.
