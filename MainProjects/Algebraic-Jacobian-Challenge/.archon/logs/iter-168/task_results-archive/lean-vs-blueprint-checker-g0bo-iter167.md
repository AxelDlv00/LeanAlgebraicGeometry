# Lean ↔ Blueprint Check Report

## Slug

g0bo-iter167

## Iteration

167

## Files audited

- Lean: `AlgebraicJacobian/Genus0BaseObjects.lean`
- Blueprint: `blueprint/src/chapters/AbelianVarietyRigidity.tex`
  (chapter shared with `AlgebraicJacobian/AbelianVarietyRigidity.lean` via
  the `% archon:covers` directive on L3; this dispatch audits only the
  Genus0BaseObjects side.)

## Per-declaration

Every `\lean{...}` hook in the chapter that points into
`Genus0BaseObjects.lean` is listed; for each I checked existence,
signature shape, and (where the chapter offers a sketch) proof
alignment.

### `\lean{AlgebraicGeometry.ProjectiveLineBar}` (chapter: `def:genus0_base_objects`, L913)
- **Lean target exists**: yes — `def ProjectiveLineBar` at L108.
- **Signature matches**: yes — `(kbar : Type u) [Field kbar] : Over (Spec (.of kbar))`, the
  asOver-packaging of `Proj` of the standard ℕ-graded `k̄[X₀, X₁]`. Matches the chapter's
  bullet for `ℙ¹_{k̄}`.
- **Proof follows sketch**: N/A (definition).
- **notes**: chapter bullet describes `ℙ¹` set-theoretically and lists the distinguished points
  `0, 1, ∞` and the two affine charts; Lean realises the construction via
  `Proj (homogeneousSubmodule (Fin 2) k̄)`. Faithful Mathlib encoding.

### `\lean{AlgebraicGeometry.Ga}` (chapter: `def:ga`, L949)
- **Lean target exists**: yes — `abbrev Ga` at L300.
- **Signature matches**: yes — `(kbar : Type u) [Field kbar] : Over (Spec (.of kbar))`, the
  asOver-packaging of `AffineSpace (Fin 1) (Spec (.of kbar))`. Matches the chapter's
  `ℙ¹ ∖ {∞}` description.
- **notes**: definition-level.

### `\lean{AlgebraicGeometry.Gm}` (chapter: `def:gm`, L960)
- **Lean target exists**: yes — `abbrev Gm` at L365.
- **Signature matches**: structurally yes — `(kbar : Type u) [Field kbar] : Over (Spec (.of kbar))`.
  The chapter writes "$\mathbb G_m = \mathbb A^1 \setminus \{0\} = \mathbb P^1 \setminus \{0, \infty\}$"
  (set-theoretic prose); Lean encodes it as `Spec k̄[t, t⁻¹]` (the affine `Spec` of
  `Localization.Away (X () : MvPolynomial Unit k̄)`). The two are canonically isomorphic schemes,
  and the Lean docstring (L41-46) flags the choice explicitly ("AFFINE — NOT the basic-open path");
  the chapter's set-theoretic description and the affine `Spec` encoding agree mathematically.
- **notes**: minor — the chapter's `\mathbb A^1 \setminus \{0\}` framing is informal; the Lean
  encoding choice is recorded only in the Lean docstring, not in the blueprint block. The
  difference is below the threshold for a flag (the chapter is at textbook-prose level, not
  pinning a specific Mathlib scheme).

### `\lean{AlgebraicGeometry.ProjectiveLineBar.zeroPt}` (chapter: `def:p1bar_zero`, L971)
- **Lean target exists**: yes — `def ProjectiveLineBar.zeroPt` at L268.
- **Signature matches**: yes — `: 𝟙_ (Over (Spec (.of kbar))) ⟶ ProjectiveLineBar kbar`, the
  `k̄`-point. Matches chapter prose ("$\Spec \bar k \to \mathbb P^1$ via
  `Proj.fromOfGlobalSections`").
- **Proof follows sketch**: N/A (definition); the chapter prose names the realisation route
  (`Proj.fromOfGlobalSections`) which is the actual Lean construction (via the bundled helper
  `ProjectiveLineBar.pointOfVec` at L234).

### `\lean{AlgebraicGeometry.ProjectiveLineBar.onePt}` (chapter: `def:p1bar_one`, L985)
- **Lean target exists**: yes — `def ProjectiveLineBar.onePt` at L274.
- **Signature matches**: yes (same shape as `zeroPt`).
- **notes**: realised via `pointOfVec (fun _ => 1) 0 _` (evaluation `X₀ ↦ 1`, `X₁ ↦ 1`).

### `\lean{AlgebraicGeometry.ProjectiveLineBar.inftyPt}` (chapter: `def:p1bar_infty`, L997)
- **Lean target exists**: yes — `def ProjectiveLineBar.inftyPt` at L280.
- **Signature matches**: yes.
- **notes**: realised via `pointOfVec (fun i => if i = 0 then 1 else 0) 0 _` (evaluation `X₀ ↦ 1`,
  `X₁ ↦ 0`).

### `\lean{AlgebraicGeometry.Gm.onePt}` (chapter: `def:gm_one`, L1010)
- **Lean target exists**: yes — `def Gm.onePt` at L431.
- **Signature matches**: yes — `: 𝟙_ … ⟶ Gm kbar`, defined as `η[Gm kbar]`. Matches the
  chapter prose ("supplied in Lean as the unit map $\eta[\mathbb G_m]$").
- **notes**: definition is `η[Gm kbar]`, exactly matching the prose hook.

### `\lean{AlgebraicGeometry.ga_grpObj}` (chapter: `def:ga_grpObj`, L1023)
- **Lean target exists**: yes — `instance ga_grpObj` at L335.
- **Signature matches**: yes — `: GrpObj (Ga kbar)`.
- **Proof follows sketch**: N/A — scaffold `sorry` (L335). The chapter block is a definition,
  not a proof; the docstring (L324-334) and the chapter prose for `def:ga_grpObj` both flag this
  as "iter-166+ scaffold" / "demoted $\mathbb G_a$-additive route, not on the genus-$0$ critical
  path". Docstring is honest about the gap and the route status.
- **notes**: OPT-IN sorry per the directive; not on the genus-$0$ critical path.

### `\lean{AlgebraicGeometry.gm_grpObj}` (chapter: `def:gm_grpObj`, L1037)
- **Lean target exists**: yes — `instance gm_grpObj` at L420.
- **Signature matches**: yes — `: GrpObj (Gm kbar)`.
- **Proof follows sketch**: N/A — scaffold `sorry` (L420). Docstring (L409-419) names the
  intended route (`GrpObj.ofRepresentableBy` with the units functor `T ↦ GrpCat.of Γ(T.left, ⊤)ˣ`,
  via the `IsLocalization.Away`-Spec bijection). Honest scaffold.
- **notes**: OPT-IN sorry per the directive; this `GrpObj` is the live consumer of
  `morphism_P1_to_grpScheme_const`.

### `\lean{AlgebraicGeometry.gmScalingP1}` (chapter: `def:gaTranslationP1`, L1052)
- **Lean target exists**: yes — `def gmScalingP1` at L457.
- **Signature matches**: yes — `: ProjectiveLineBar kbar ⊗ Gm kbar ⟶ ProjectiveLineBar kbar`,
  the scaling action morphism. Matches the chapter's "primary route" `\sigma_\times : \mathbb P^1
  \times \mathbb G_m \to \mathbb P^1` description.
- **Proof follows sketch**: N/A — scaffold `sorry` (L459). The Lean docstring (L451-456) explicitly
  defers the chart-glue body to iter-166+. Chapter prose for `def:gaTranslationP1` (L1068-1075)
  describes the chartwise glue: on `𝔸¹ × 𝔾_m` the polynomial map `(x, λ) ↦ λx`, on `D₊(X₁)` the
  rewrite `1/(λx) = u/λ` (regular because `λ ∈ 𝔾_m`), the two charts cover and overlap consistently.
- **notes**: OPT-IN sorry per the directive. The chapter's `def:gaTranslationP1` block also
  describes a *companion* `\sigma : \mathbb P^1 \times \mathbb G_a \to \mathbb P^1` (translation
  action) annotated as `[expected]` not yet a Lean target — that's the *demoted* route, and the
  expected-only annotation is honest.

### `\lean{AlgebraicGeometry.gmScalingP1_collapse_at_zero}` (chapter: `lem:gmScaling_fixes_zero`, L1103)
- **Lean target exists**: yes — `lemma gmScalingP1_collapse_at_zero` at L472.
- **Signature matches**: yes — the lemma asserts
  `lift (toUnit (Gm kbar) ≫ ProjectiveLineBar.zeroPt kbar) (𝟙 (Gm kbar)) ≫ gmScalingP1 kbar =
   toUnit (Gm kbar) ≫ ProjectiveLineBar.zeroPt kbar`,
  which is exactly the chapter's "$\sigma_\times(0, \lambda) = 0$" statement encoded via the
  `lift … ≫ gmScalingP1 = toUnit ≫ zeroPt` shape that
  `hom_additive_decomp_of_rigidity` consumes (the `_hf` `W`-axis-collapse hypothesis).
- **Proof follows sketch**: N/A — scaffold `sorry` (L476). The chapter proof block (L1115-1125)
  describes the chart-level computation: ring map `k̄[t, t⁻¹] → k̄`, `λ ↦ 0`. Lean docstring
  (L461-471) defers proof to iter-166+ and describes the same chart-level argument.
- **notes**: OPT-IN sorry per the directive.

## Red flags

None — the audit found no must-fix-this-iter issues.

### Placeholder / suspect bodies

No `:= True`, no `:= rfl` on non-trivial claims, no `:= Classical.choice _` patterns on
substantive declarations. The six `sorry`-bodied declarations (`projectiveLineBar_geomIrred`,
`projectiveLineBar_smoothOfRelDim`, `ga_grpObj`, `gm_grpObj`, `gmScalingP1`,
`gmScalingP1_collapse_at_zero`) plus the three new scaffold sorries this iter
(`projectiveLineBar_isReduced`, `gm_geomIrred`, `projGm_isReduced`) are all OPT-IN /
scaffold-of-record per the directive. Each carries an honest docstring naming the Mathlib gap
and (where applicable) the intended route.

### Excuse-comments

None. Grep for `TODO|temporary|placeholder|will fix later|wrong but works|for now` returned no
matches. All "we use a wrong def for now"-style red flags absent.

### Axioms / Classical.choice on non-trivial claims

No `axiom` declarations. The standard kernel set `{propext, Classical.choice, Quot.sound}` is
the only kernel-axiom footprint on the axiom-clean declarations (`gmRing_isDomain`,
`gm_irreducibleSpace`, `projGm_locallyOfFiniteType`, plus the older
`projectiveLineBar_isProper`). The `sorryAx` shows up exactly where the directive predicts:
the six pre-iter-167 OPT-IN sorries plus the three new scaffold sorries plus
`projGm_geomIrred` (which propagates upstream `gm_geomIrred` + `projectiveLineBar_geomIrred`
sorries by composition, as the directive specifies — its own proof body
`change …; exact GeometricallyIrreducible.comp _ _` introduces no new `sorry`).

## Unreferenced declarations (informational)

Most of the unreferenced declarations are typeclass scaffolding / Mathlib-instance helpers
that the consumer `morphism_P1_to_grpScheme_const_aux` (in `AbelianVarietyRigidity.lean`)
needs at instance-resolution time:

- `projectiveLineBarGrading` (L78), `projectiveLineBarGrading_gradedRing` (L82),
  `ProjectiveLineBarScheme` (L94), `projectiveLineBarScheme_canOver` (L99) — auxiliary
  structure for `ProjectiveLineBar`.
- `projectiveLineBar_isProper` (L127) — instance, load-bearing for `def:gaTranslationP1`'s
  `\sigma_\times` shortcut (the chapter's "first factor complete" hypothesis), axiom-clean.
- `projectiveLineBar_geomIrred` (L175), `projectiveLineBar_smoothOfRelDim` (L182) — `Proj`-side
  scaffold instances (OPT-IN sorries, mentioned in the Lean header docstring as iter-166+
  sub-builds; the chapter `def:genus0_base_objects` block describes them informally as part of
  "$\mathbb P^1$ is a smooth proper geometrically irreducible curve of genus 0").
- `ProjectiveLineBar.evalIntoGlobal` (L199), `ProjectiveLineBar.irrelevant_map_eq_top` (L207),
  `ProjectiveLineBar.pointOfVec` (L234) — private helpers for the three `k̄`-points;
  documented as private and load-bearing only for those.
- `GaScheme` (L289), `gaScheme_canOver` (L294), `ga_isAffineHom` (L305),
  `ga_locallyOfFinitePresentation` (L312), `ga_isReduced` (L321), `ga_smooth` (L340) — `𝔾_a`
  helper structure and instances (some `inferInstanceAs`, none load-bearing for the genus-0 path).
- `GmRing` (L349), `GmScheme` (L355), `gmScheme_canOver` (L359), `gm_isAffine` (L369),
  `gm_locallyOfFinitePresentation` (L377), `gm_isReduced` (L386), `gm_smooth` (L424) — `𝔾_m`
  helper structure and instances.
- **NEW iter-167 axiom-clean:** `gmRing_isDomain` (L395), `gm_irreducibleSpace` (L404),
  `projGm_locallyOfFiniteType` (L500), `projGm_geomIrred` (L542) — Lane-B
  product-stability instances on `ℙ¹ ⊗ 𝔾_m`; consumed by
  `morphism_P1_to_grpScheme_const_aux` in `AbelianVarietyRigidity.lean` to collapse its prior
  inline `haveI … := sorry` scaffolds.
- **NEW iter-167 scaffold sorries:** `projectiveLineBar_isReduced` (L517), `gm_geomIrred`
  (L530), `projGm_isReduced` (L560) — same Lane-B role.

The Lean header docstring (L26-55) and the section-E docstring (L478-494) both describe
these instances informally; the chapter prose acknowledges them in the iter-166 proof-body
NOTE for `prop:morphism_P1_to_AV_constant` (L1422-1432) as "five honest scaffold sorries"
without pinning each one to its own `\lean{...}` block. They are scheme-level typeclass
scaffolding, not blueprint-grade theorems, so leaving them as informational helpers
(rather than individually-pinned blueprint nodes) is acceptable.

## Blueprint adequacy for this file

- **Coverage**: 11 declarations in this file are `\lean{...}`-pinned by the chapter (the 4
  primary objects `ProjectiveLineBar` / `Ga` / `Gm` / `gmScalingP1`, the 3 ℙ¹-points + the
  `Gm.onePt`, the 2 `GrpObj` instances, and the fixed-point lemma
  `gmScalingP1_collapse_at_zero`). The remaining ~25 declarations are typeclass scaffolding
  (graded-ring instances, `Over` structure, instance-resolution helpers, private point-of-vec
  helpers, Lane-B product-stability instances) — all are legitimately helper-only and the
  chapter is right not to pin them as separate blueprint nodes.
- **Proof-sketch depth**: adequate. The chapter offers chart-level prose for `gmScalingP1`
  (the polynomial map on the affine chart, the `u/λ` rewrite near `∞`) and for
  `gmScalingP1_collapse_at_zero` (the chart-level ring map `λ ↦ 0`). These are appropriate
  for the iter-166+ proof landings; for the iter-167 scope (axiom-clean instance landings +
  Lane-B product-stability scaffolding) no further chapter content is required.
- **Hint precision**: precise. Every `\lean{...}` hook resolves cleanly to the named
  declaration with the right signature shape; nothing is left to "guess which Mathlib
  predicate".
- **Generality**: matches need. The chapter's bullet list under `def:genus0_base_objects`
  is at textbook-prose level (sets and group laws); the Lean file commits to specific
  Mathlib encodings (`Proj` of the standard grading; `AffineSpace`; `Spec (Localization.Away …)`)
  documented in the Lean header. No parallel-API drift.
- **Recommended chapter-side actions**: none required for must-fix-this-iter. *Optional
  hygiene*: a brief one-line note in `def:gm` flagging the affine-Spec encoding choice (vs.
  the basic-open-of-𝔸¹ alternative) would make the Lean realisation visible at the chapter
  level — see recommendations.md.

## Severity summary

- **must-fix-this-iter**: none.
- **major**: none.
- **minor**:
  - The new Lane-B product-stability instances (`projGm_locallyOfFiniteType`,
    `projectiveLineBar_isReduced`, `gm_geomIrred`, `projGm_geomIrred`, `projGm_isReduced`)
    are mentioned in chapter prose only via the iter-166 proof-body NOTE (L1422-1432 of the
    blueprint). For full hygiene one could promote each to a brief blueprint definition /
    lemma node, but they are typeclass-scaffolding instances, not theorems, and the existing
    informal mention is sufficient. (Minor; recommendations.md.)
  - The Lean's `Gm` encoding (`Spec k̄[t, t⁻¹]`, affine) vs. the chapter's set-theoretic
    "$\mathbb P^1 \setminus \{0, \infty\}$" framing — they agree mathematically, but the
    chapter could optionally flag the affine-Spec choice in a one-liner. (Minor;
    recommendations.md.)

Overall verdict: **CLEAN — Lean ↔ Blueprint alignment is sound**; all 11 `\lean{...}` hooks
resolve to declarations of the right name + shape, the 4 new axiom-clean instances verify as
expected (one of which propagates upstream scaffold sorries exactly as the directive
foretold), the 3 new scaffold sorries have honest gap-naming docstrings, and there are no
TODO/excuse-comments or placeholder-True bodies anywhere in the file.
