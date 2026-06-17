# Session 165 — Summary

## Metadata
- **Session / iter**: session_165 = iter-165 review of the iter-165 prover phase.
- **Bare-`sorry` count (global)**: 6 → 15. Δ = +9 by design (depth-conversion
  scaffold, the iter-164 progress-critic's watch-item).
- **Per-file inventory (post-iter)**: `AlgebraicJacobian/AbelianVarietyRigidity.lean`
  L936/L960/L989 (3 deferred genus-0 scaffolds, unchanged); **NEW**
  `AlgebraicJacobian/Genus0BaseObjects.lean` L177/L184/L201/L206/L211/L264/L329/L368/L385
  (9 plan-allowed scaffold sorries — see Sorry inventory below);
  `AlgebraicJacobian/Jacobian.lean` L265/L303 (unchanged); `RigidityKbar.lean`
  L88 (unchanged).
- **Files modified this iter**: `AlgebraicJacobian/Genus0BaseObjects.lean`
  (NEW, 389 LOC); `AlgebraicJacobian.lean` (+1 line: `import
  AlgebraicJacobian.Genus0BaseObjects`).
- **Build status**: `lake build AlgebraicJacobian` → green (only `sorry` warnings).
- **Axioms (key new decls)**: `projectiveLineBar_isProper`,
  `projectiveLineBarGrading_gradedRing`, `ga_isReduced`, `gm_isReduced`,
  `ga_isAffineHom`, `ga_locallyOfFinitePresentation`, `gm_isAffine`,
  `gm_locallyOfFinitePresentation` all on `{propext, Classical.choice,
  Quot.sound}` (NO `sorryAx`). `ga_smooth`, `gm_smooth`, `Gm.onePt` carry
  `sorryAx` honestly (via `ga_grpObj` / `gm_grpObj` scaffolds — expected per
  the PARTIAL gate).
- **Rigidity-Lemma chain re-verified**: `rigidity_lemma`,
  `hom_additive_decomp_of_rigidity`, `av_regularMap_isHom_of_zero` still
  `{propext, Classical.choice, Quot.sound}` — unchanged this iter, no
  regression.

## The iter at a glance

iter-164 committed the **𝔾ₘ-scaling shortcut** as the genus-0 base-case
route and noted iter-165 MUST convert to depth (the progress-critic watch
item: "another hygiene round would CHURN"). iter-165 answered with a single
new-file lane: `AlgebraicJacobian/Genus0BaseObjects.lean`, scaffolding the
four concrete objects the iter-166 AVR refactor will consume —
`ProjectiveLineBar` (ℙ¹ as `Proj`), `Ga` / `Gm` (group objects via
`AffineSpace` / `Spec (Localization.Away _)`), and the `𝔾ₘ`-scaling action
`gmScalingP1`.

The depth conversion succeeded: **4/4 main objects defined, 3/4 with
axiom-clean primary instances**, 9 plan-allowed scaffold `sorry`s for
iter-166's lane. Of the 4 main objects, the most substantive deliverable is
**`projectiveLineBar_isProper`**, which the plan-phase mathlib-analogist
listed as "FREE from `Proj.instIsProperToSpecZero…`" but in practice
required a ~25-LOC proof closing the bijectivity of `algebraMap k̄ → ↥(𝒜 0)`
(see Key findings).

## Targets attempted

### `AlgebraicJacobian/Genus0BaseObjects.lean` (NEW file — primary lane)

**Status**: PARTIAL — plan-targeted, gate met.

Per the iter-165 plan's PARTIAL gate scorecard (plan.md L107–115):

> "PARTIAL is fine if some instance synthesis trips; the depth-conversion
> gate is met when ≥3 of the 4 main objects land with at least their
> primary instance."

Actual: **4/4 objects landed, 3/4 with axiom-clean primary instances**:

| Object | Definition | Primary instance(s) | Status |
|---|---|---|---|
| `ProjectiveLineBar` | `Proj 𝒜` of MvPolynomial homogeneous-grading | `IsProper` | **PROVEN axiom-clean** (better than analogist-predicted "FREE") |
| `Ga` | `AffineSpace (Fin 1) (Spec k̄) `.asOver` | `IsAffineHom`, `LocallyOfFinitePresentation`, `IsReduced` | All axiom-clean |
| `Gm` | `Spec (Localization.Away (X : MvPolynomial Unit k̄)) `.asOver` | `IsAffine`, `LocallyOfFinitePresentation`, `IsReduced` | All axiom-clean |
| `gmScalingP1` | `ProjectiveLineBar ⊗ Gm ⟶ ProjectiveLineBar` | (companion: `gmScalingP1_collapse_at_zero`) | Signature + statement only; body deferred |

### `AlgebraicJacobian/AbelianVarietyRigidity.lean`

**Status**: NOT_STARTED (deferred to iter-166 by plan design).

3 deferred sorry scaffolds (`morphism_P1_to_grpScheme_const`,
`genusZero_curve_iso_P1`, `rigidity_genus0_curve_to_grpScheme`) unchanged
this iter. The iter-166 plan dispatches the AVR refactor + Cor 1.5 chain
once the scaffold signatures are stable (which this iter delivered).

## Significant attempt detail (target 1: Genus0BaseObjects.lean)

### Attempt 1 — Write the full scaffold file (`Genus0BaseObjects.lean:1-389`)

The prover composed the file per the analogist's 4 ALIGN_WITH_MATHLIB
verdicts:

- `ProjectiveLineBarScheme := Proj (MvPolynomial.homogeneousSubmodule (Fin 2) kbar)`
  — the standard ℕ-graded `k̄[X₀, X₁]` (degree-by-total-degree). The
  `GradedRing` instance is `MvPolynomial.gradedAlgebra` (Mathlib, free).
- `GaScheme := AffineSpace (Fin 1) (Spec (.of kbar))` — the standard
  `AlgebraicGeometry.AffineSpace` for the affine line (per analogist D1b).
- `GmScheme := Spec (CommRingCat.of (Localization.Away (X : MvPolynomial Unit kbar)))`
  — affine encoding of `Spec k̄[t, t⁻¹]` (per analogist D2.b: AFFINE Spec, NOT
  the basic-open route, which loses `IsAffine`).
- `gmScalingP1 : ProjectiveLineBar ⊗ Gm ⟶ ProjectiveLineBar := sorry` — the
  bare morphism's type signature, body deferred to iter-166's
  `Scheme.Cover.glueMorphisms` over the two `Proj.awayι`-charts (analogist
  D3 verdict: no `IsAction`/`MulAction`-style typeclass at scheme level).

Plus a companion lemma `gmScalingP1_collapse_at_zero` whose STATEMENT
matches the rigidity consumer's `_hf` shape verbatim:

```lean
lemma gmScalingP1_collapse_at_zero (kbar : Type u) [Field kbar] :
    lift (toUnit (Gm kbar) ≫ ProjectiveLineBar.zeroPt kbar) (𝟙 (Gm kbar)) ≫
        gmScalingP1 kbar =
      toUnit (Gm kbar) ≫ ProjectiveLineBar.zeroPt kbar := by sorry
```

This is precisely the `_hf` antecedent that the proven Cor 1.5
(`hom_additive_decomp_of_rigidity`) consumes when iter-166's AVR proof
instantiates it with `V = ProjectiveLineBar`, `W = Gm`, base points
`ProjectiveLineBar.zeroPt`, `Gm.onePt`.

### Attempt 2 — Promote `projectiveLineBar_isProper` from analogist-"FREE" to a real proof (`Genus0BaseObjects.lean:127-170`)

The analogist's `gm-scaling-p1` report listed `IsProper ProjectiveLineBar.hom`
as "FREE from `Proj.instIsProperToSpecZero…`". This was true for
`Proj.toSpecZero 𝒜`, but the project's `ProjectiveLineBar` carries
`(ProjectiveLineBarScheme kbar).Over (Spec (.of kbar))` via the COMPOSITION
`Proj.toSpecZero 𝒜 ≫ Spec.map (algebraMap kbar ↥(𝒜 0))` (because the
canonical `Proj.toSpecZero` lands in `Spec ↥(𝒜 0)`, not `Spec k̄`).

The prover proved properness of the composite axiom-clean:

```lean
instance projectiveLineBar_isProper : IsProper (ProjectiveLineBar kbar).hom := by
  change IsProper (Proj.toSpecZero 𝒜 ≫
    Spec.map (CommRingCat.ofHom (algebraMap kbar ↥(𝒜 0))))
  -- IsScalarTower kbar ↥(𝒜 0) (MvPolynomial _ kbar)
  haveI : IsScalarTower kbar ↥(𝒜 0) (MvPolynomial (Fin 2) kbar) :=
    IsScalarTower.of_algebraMap_eq fun _ => rfl
  -- MvPoly is finite type over ↥(𝒜 0) (descended from finite-type over k̄)
  haveI : Algebra.FiniteType ↥(𝒜 0) (MvPolynomial (Fin 2) kbar) :=
    Algebra.FiniteType.of_restrictScalars_finiteType kbar _ _
  -- The key step: algebraMap k̄ → ↥(𝒜 0) is bijective
  have hbij : Function.Bijective (algebraMap kbar ↥(𝒜 0)) := by
    refine ⟨?_, ?_⟩
    · intro x y h
      apply MvPolynomial.C_injective (Fin 2) kbar
      exact congrArg Subtype.val h
    · intro ⟨v, hv⟩
      refine ⟨MvPolynomial.coeff 0 v, ?_⟩
      apply Subtype.ext
      rw [SetLike.GradeZero.coe_algebraMap]
      have key := MvPolynomial.homogeneousComponent_of_mem hv (m := 0)
      simp only [MvPolynomial.homogeneousComponent_zero, if_true] at key
      exact key
  haveI : IsIso (Spec.map (CommRingCat.ofHom (algebraMap kbar ↥(𝒜 0)))) := by
    rw [isIso_SpecMap_iff]; exact hbij
  infer_instance
```

`#print axioms` confirms `{propext, Classical.choice, Quot.sound}` — no
`sorryAx`.

**Key technique** (recorded in the Knowledge Base): the bijectivity proof
factors `↥(𝒜 0) = constants` via two non-obvious MvPolynomial lemmas
*together*: `homogeneousComponent_of_mem` (the degree-`0` component of a
polynomial in `𝒜 0` is itself) and `homogeneousComponent_zero` (the
degree-`0` component is `C ∘ coeff 0`). The simp set
`[MvPolynomial.homogeneousComponent_zero, if_true]` is the exact resolver
(`reduceIte` first attempt FAILED — it left the if-then-else trivially
unreduced).

### Attempt 3 — Discharge the 5 instance-bridge sub-builds via Mathlib `inferInstance` (`Genus0BaseObjects.lean:222-316`)

- `ga_isReduced := isReduced_of_isOpenImmersion (AffineSpace.isoOfIsAffine
  (Fin 1) _).hom` — transports `IsReduced` from the iso target
  `Spec (.of (MvPolynomial _ k̄))` (free) backward via the
  iso-as-open-immersion pattern.
- `gm_isReduced := inferInstanceAs (IsReduced (Spec _))` — picks up
  directly from `IsReduced (Localization.Away _)` (localization of a
  domain at a non-zero-divisor is a domain, hence reduced).
- `gm_locallyOfFinitePresentation := (HasRingHomProperty.Spec_iff (P :=
  @LocallyOfFinitePresentation)).mpr ((RingHom.finitePresentation_algebraMap
  (B := GmRing kbar)).mpr inferInstance)` — bridges the morphism property
  `LocallyOfFinitePresentation (Spec.map _)` to the ring-side
  `RingHom.FinitePresentation`, then to the algebra-side
  `Algebra.FinitePresentation k̄ (Localization.Away t)` (free from the
  finite-presentation localization instance).

### Attempt 4 — Bridge `ga_smooth` / `gm_smooth` through scaffold `_grpObj` sorries (`Genus0BaseObjects.lean:269-272, 333-336`)

```lean
instance ga_smooth : Smooth (Ga kbar).hom :=
  have : GrpObj (Over.mk (Ga kbar).hom) := ga_grpObj kbar
  smooth_of_grpObj_of_isAlgClosed (Ga kbar).hom
```

These two declarations consume the `_grpObj` scaffold sorries directly.
`#print axioms` confirms they carry `sorryAx` HONESTLY (not laundered) —
`sorryAx` traces transitively to `ga_grpObj` / `gm_grpObj`, the only path
to `Smooth` in the analogist's chain. The auditor confirmed
(`task_results/lean-auditor-iter165.md` L235–243): "logically valid modulo
the `_grpObj` scaffold sorries".

## Key findings / patterns discovered

1. **Analogist's "FREE-from-Mathlib" verdicts may hide one-step gaps.**
   `IsProper ProjectiveLineBar.hom` was listed FREE from
   `Proj.instIsProperToSpecZero…`, but the project's `OverClass` for ℙ¹
   uses the COMPOSITION `Proj.toSpecZero ≫ Spec.map (algebraMap k̄ → ↥(𝒜 0))`,
   so the prover had to (a) install `IsScalarTower`, (b) prove `algebraMap
   k̄ → ↥(𝒜 0)` bijective via degree-0-component-of-graded-polynomial = `C ∘
   coeff 0`, (c) lift to `IsIso (Spec.map _)`. The reusable pattern: when
   an analogist marks a property "FREE" through a Mathlib decl `f`, check
   whether your project's wired-up instance composes `f` with anything;
   each `Spec.map`-composition introduces a possibly-non-trivial
   ring-bijectivity obligation.

2. **`MvPolynomial.homogeneousComponent_zero` + `homogeneousComponent_of_mem`
   compose to give degree-0-piece-of-graded-polynomial = constants.** The
   `simp only [homogeneousComponent_zero, if_true]` set is the resolver;
   `reduceIte` (a more aggressive normalizer) fails on the bare `if 0 = 0`.

3. **`HasRingHomProperty.Spec_iff` bridges morphism properties on
   `Spec.map _` to the corresponding `RingHom.<P>` predicate.** Used here
   for `LocallyOfFinitePresentation` ↔ `RingHom.FinitePresentation`; the
   `.mpr` direction with `RingHom.finitePresentation_algebraMap.mpr
   inferInstance` then descends to algebra-side instances. Reusable
   whenever a scheme-property on a `Spec.map` of an algebraMap is needed.

4. **`AffineSpace.isoOfIsAffine` transports `IsReduced` from `Spec _` to
   `AffineSpace _ _` via `isReduced_of_isOpenImmersion`.** The pattern
   `inferInstance` directly on `AffineSpace _ _` does NOT work — the iso
   has to be applied as an open immersion explicitly.

5. **Borderline excuse-language in `ga_grpObj` docstring**
   (`Genus0BaseObjects.lean:253-263`). The text "**PARTIAL placeholder**:
   the type signature is correct and the projects' downstream consumer …
   does not exercise this" pattern-matches the audit's excuse-comment
   detector. The auditor flagged it as a borderline minor and recommended
   rewording to "scaffold body for iter-166; off-path for the genus-0
   closure (rigidity consumer uses `Gm`, not `Ga`)". A 1-line docstring
   refresh is the corrective; review agent does not edit `.lean` files so
   this lifts to recommendations.md as a candidate for iter-166's
   `ga_grpObj` close.

## Blueprint markers updated (manual)

None this iter. The plan agent did not need a `\mathlibok` because no
declaration was a direct Mathlib re-export (the new infrastructure is
Archon-original). The `\lean{AlgebraicGeometry.ProjectiveLineBar}` and
`\lean{AlgebraicGeometry.gmScalingP1}` hints on `def:genus0_base_objects`
(L912) and `def:gaTranslationP1` (L943) of `AbelianVarietyRigidity.tex` are
correct as-is — the prover did NOT rename either decl, so no `\lean{...}`
correction is needed. No stale `\notready` to strip. The `\leanok` markers
are owned by the deterministic `sync_leanok` phase (separate commit).

The lean-vs-blueprint-checker (`g0bo-iter165`) recommended 3 **minor**
chapter-side coverage gaps (writer-domain, not review-domain — lifted to
recommendations.md):
- Add per-decl `\lean{...}` hints for `Ga`, `Gm`, `Gm.onePt`,
  `ProjectiveLineBar.{zeroPt, onePt, inftyPt}` (the chapter uses
  `[expected]` annotations).
- Add a `\lean{AlgebraicGeometry.gmScalingP1_collapse_at_zero}` block for
  the load-bearing companion lemma.
- Trim `def:gaTranslationP1` prose at L967–970 (claims full `MulAction`-style
  identities `σ_×(x, 1) = x`, associativity — Lean ships only the bare
  morphism + collapse-at-zero, per analogist D3 verdict).

## Subagent results

| Subagent | Slug | Verdict | Key findings |
|---|---|---|---|
| `lean-auditor` | iter165 | 0 must-fix / 5 major / 4 minor | All 5 majors are unchanged carry-overs from iter-164 (stale-narrative debt in `Cotangent/`, `Jacobian.lean`, `RigidityKbar.lean`). 3 minors are also carry-overs; the 1 NEW minor is a borderline excuse-comment on the `ga_grpObj` docstring. **`projectiveLineBar_isProper` audited and confirmed sound + axiom-clean; `ga_smooth` / `gm_smooth` propagate `sorryAx` honestly.** Report: `logs/iter-165/lean-auditor-iter165-report.md` (also at `task_results/lean-auditor-iter165.md`). |
| `lean-vs-blueprint-checker` | g0bo-iter165 | 0 must-fix / 0 major / 3 minor | Lean ↔ blueprint binding intact: both `\lean{...}` pins (`ProjectiveLineBar`, `gmScalingP1`) point to actual file decls. No false `\leanok`, no laundering. 3 minors are chapter-side `\lean{...}` coverage gaps. Report: `logs/iter-165/lean-vs-blueprint-checker-g0bo-iter165-report.md`. |

## Sorry inventory (post-iter, the 9 new ones in detail)

All 9 are top-level NAMED declarations (no buried `letI`/`have :=` sorries
in otherwise-closed proofs — auditor-confirmed).

| Line | Decl | Why scaffold | Plan-allowed? |
|------|------|--------------|---------------|
| 177 | `projectiveLineBar_geomIrred` | Mathlib has no `GeometricallyIrreducible Proj _` instance | ✓ explicitly named |
| 184 | `projectiveLineBar_smoothOfRelDim` | Mathlib has no `SmoothOfRelativeDimension 1 Proj _` instance | ✓ explicitly named |
| 201/206/211 | `ProjectiveLineBar.{zeroPt,onePt,inftyPt}` | Concrete k̄-points via `Proj.awayι ≫ Spec.map` (iter-166+) | scaffold for downstream |
| 264 | `ga_grpObj` | `GrpObj.ofRepresentableBy` body via `AffineSpace.homOverEquiv` (iter-166 lane; off the live route — Cor 1.5 with W=Gm) | ✓ explicitly named |
| 329 | `gm_grpObj` | `GrpObj.ofRepresentableBy` body via units functor + `IsLocalization.Away`-Spec bijection (iter-166 lane; LIVE consumer of `morphism_P1_to_grpScheme_const`) | ✓ explicitly named |
| 368 | `gmScalingP1` | Bare ⊗-morphism via `Scheme.Cover.glueMorphisms` over the two `Proj.awayι × Gm` charts (iter-166 lane) | scaffold per plan |
| 385 | `gmScalingP1_collapse_at_zero` | Companion fixed-point lemma; chart-level computation (iter-166 lane; statement matches the rigidity consumer's `_hf` shape verbatim) | scaffold per plan |

## Recommendations for next session

See `recommendations.md` — top-3:

1. **CRITICAL** — iter-166 must dispatch the AVR refactor lane (the "B"
   half of the iter-165 plan): import `Genus0BaseObjects`, refactor
   `morphism_P1_to_grpScheme_const` to consume the concrete
   `ProjectiveLineBar`/`Gm`/`gmScalingP1` triple, body via Cor 1.5 + the
   scaling-shortcut chain. iter-164 progress-critic's `iter-166 watch
   item`: a second non-depth iter would flip the route to CHURNING.
2. **HIGH** — Close `gm_grpObj` (the only `_grpObj` scaffold the live
   consumer actually exercises) via `GrpObj.ofRepresentableBy` with units
   functor `T ↦ GrpCat.of Γ(T.left, ⊤)ˣ` and the `IsLocalization.Away`-Spec
   bijection (Mathlib's `AffineScheme.lean:632/651/666`). `ga_grpObj` is
   off the live path and can defer further.
3. **HIGH** — Close `gmScalingP1` + `gmScalingP1_collapse_at_zero` (the
   load-bearing morphism + its `_hf`-shaped companion). The chartwise glue
   is plan-detailed in `task_results/AlgebraicJacobian_Genus0BaseObjects.lean.md`
   (handoff notes 3 + 4).
