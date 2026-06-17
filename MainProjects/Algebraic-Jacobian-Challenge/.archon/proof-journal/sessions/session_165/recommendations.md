# Iter-165 → iter-166 recommendations

## CRITICAL — iter-166 plan must close on AVR consumer

**Action**: dispatch the AVR refactor lane (`AbelianVarietyRigidity.lean`)
to consume the iter-165 scaffold via Cor 1.5. This is the iter-164
progress-critic's **iter-166 watch tripwire** — a second iter without
either (a) closing the scaffold sorries or (b) starting the AVR body
will flip the genus-0 route to CHURNING.

The recipe (from `task_results/AlgebraicJacobian_Genus0BaseObjects.lean.md`
handoff note 1):

1. `import AlgebraicJacobian.Genus0BaseObjects` in `AbelianVarietyRigidity.lean`.
2. Refactor `morphism_P1_to_grpScheme_const` (currently a sorry with an
   abstract `P1 : Over (Spec (.of kbar))` proxy) to take the CONCRETE
   `ProjectiveLineBar kbar` from the new file.
3. Body chain:
   - Apply `hom_additive_decomp_of_rigidity` (proven Cor 1.5) with
     `V = ProjectiveLineBar kbar`, `W = Gm kbar`, base points
     `ProjectiveLineBar.zeroPt`, `Gm.onePt`.
   - The `_hf` collapse hypothesis is precisely
     `gmScalingP1_collapse_at_zero` (its STATEMENT matches the `_hf` shape
     verbatim — iter-165 attempt 1 deliverable).
   - W-axis collapse + density (Gm ⊆ ProjectiveLineBar as a dense open) +
     A separated (`ext_of_eqOnOpen`, proven) close the proof.
4. Genus-0 scaffold `projectiveLineBar_geomIrred` + `projectiveLineBar_smoothOfRelDim`
   are NOT load-bearing for `morphism_P1_to_grpScheme_const` itself (only
   the IsProper instance is) — defer them.

**Why CRITICAL**: 9 of the 15 global sorries are now in `Genus0BaseObjects.lean`,
not blocking the headline directly. The AVR refactor is the closure
mechanism. Without it, iter-165's depth-conversion lands but doesn't
reach productive use.

## HIGH — Close `gm_grpObj` (Genus0BaseObjects.lean:329, LIVE consumer)

**Action**: Prove `gm_grpObj : GrpObj (Gm kbar)` via
`GrpObj.ofRepresentableBy` with:

- **Functor**: `T ↦ GrpCat.of Γ(T.left, ⊤)ˣ` (the units of global sections).
- **RepresentableBy witness**: morphisms `T ⟶ Gm` in `Over (Spec k̄)`
  correspond exactly to units in `Γ(T.left, ⊤)` (Mathlib's
  "morphism into `Spec` of an away-localization ↔ unit in global sections"
  — see `Mathlib.AlgebraicGeometry.AffineScheme` L632/651/666).

This is the ONLY `_grpObj` scaffold that the live consumer
`morphism_P1_to_grpScheme_const` actually exercises (Cor 1.5 applied with
`W = Gm`). `ga_grpObj` is off the live route (the 𝔾ₐ-additive route was
demoted iter-164) and can wait further.

## HIGH — Close `gmScalingP1` + `gmScalingP1_collapse_at_zero` (Genus0BaseObjects.lean:368/385)

**Action**: Land the scaling morphism's body and its load-bearing
fixed-point lemma.

### `gmScalingP1` body

Use `AlgebraicGeometry.Scheme.Cover.glueMorphisms` over the two `Proj.awayι`-charts
of `ProjectiveLineBar`, each paired with `Gm`:

- On `𝔸¹ × 𝔾_m` (chart `t = X₀ ≠ 0`): `Spec.map` of the ring map
  `k̄[t, λ, λ⁻¹] →+* k̄[t, λ, λ⁻¹]`, `t ↦ λ · t`.
- Near `∞` (chart `u = X₁ ≠ 0`, with `u = 1/t`): `Spec.map` of `u ↦ u/λ`
  (regular because `λ ∈ 𝔾_m` is invertible).
- Agreement on the overlap `k̄[t, t⁻¹, λ, λ⁻¹]`: a direct ring-level
  computation.

### `gmScalingP1_collapse_at_zero` body

A chart-level computation: on the `𝔸¹` chart, `t ↦ λ · 0 = 0`. The lift
factors `gmScalingP1` composed with `(toUnit ≫ zeroPt) × 𝟙` through the
closed `k̄`-subscheme `{zeroPt} ⊆ ProjectiveLineBar`.

## HIGH — Close the 3 `ProjectiveLineBar.{zeroPt, onePt, inftyPt}` (Genus0BaseObjects.lean:201/206/211)

Concrete `k̄`-points via `Proj.awayι` (the affine charts) composed with
`Spec.map` of the appropriate ring homomorphism. iter-166 prerequisite for
the `gmScalingP1_collapse_at_zero` body and for the AVR consumer (which
applies Cor 1.5 with base point `ProjectiveLineBar.zeroPt`).

## MEDIUM — Reword `ga_grpObj` docstring (Genus0BaseObjects.lean:253-263)

**Action**: lean-auditor `iter165` flagged the docstring "**PARTIAL
placeholder**: the type signature is correct and the projects' downstream
consumer (`hom_additive_decomp_of_rigidity` with `W = Gm`, NOT `W = Ga` —
`Ga` is on the demoted route only) does not exercise this." as a borderline
excuse-comment.

Recommended rewording (from the auditor): "scaffold body for iter-166;
off-path for the genus-0 closure (rigidity consumer uses `Gm`, not `Ga`)".
Pair this with the closure of `gm_grpObj` so the prover already in the file
makes the edit in passing.

## MEDIUM — Blueprint chapter coverage (3 minor gaps, lean-vs-blueprint-checker g0bo-iter165)

**Action**: Dispatch a blueprint-writer on `AbelianVarietyRigidity.tex` to
land the 3 minor coverage gaps the checker surfaced (chapter L912 / L943):

1. Add per-decl `\lean{...}` hints inside `def:genus0_base_objects` for
   `Ga`, `Gm`, `Gm.onePt`, and the three `ProjectiveLineBar.{zeroPt,
   onePt, inftyPt}` points. The chapter currently uses `[expected]`
   annotations in prose; the Lean ships all of them.
2. Add a dedicated `\lean{AlgebraicGeometry.gmScalingP1_collapse_at_zero}`
   block. Currently the chapter has prose at L1252–1259 but no formal pin,
   while Lean ships the named lemma at `Genus0BaseObjects.lean:381`.
3. Trim `def:gaTranslationP1` prose at L967–970. The chapter currently
   claims full `MulAction`-style identities (`σ_×(x, 1) = x`, associativity);
   Lean (per analogist D3 verdict) ships only the bare morphism +
   `_collapse_at_zero`. Either trim or explicitly flag the action laws as
   out-of-scope for the formalisation.

Non-urgent — none of these gate iter-166 prover work directly.

## MEDIUM — Address the 5 carry-over stale-narrative MAJORs (lean-auditor iter165)

**Action**: SAME as iter-164's MEDIUM recommendation #3 (still open). The
5 files have axiom-clean code but stale `iter-NNN`/route framing in
section headers and docstrings. A single hygiene pass would close all 5
in one iter. Listed for completeness; iter-164's recommendation already
deferred this; iter-165 reaffirms.

- `AlgebraicJacobian/Cotangent/GrpObj.lean:297–327` — Step-2/excised plan.
- `AlgebraicJacobian/Cotangent/GrpObj.lean:428–525` — excised helpers.
- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean:36–79` — iter-144 framing
  on a now-fallback route.
- `AlgebraicJacobian/RigidityKbar.lean:20–29, 70–74` — "keystone classical
  input" framing on a fallback artifact.
- `AlgebraicJacobian/Jacobian.lean:237–263` — partial-3-gate analysis
  inside `genusZeroWitness.key`'s `sorry`, gates (1)+(2) now resolved.

## DO-NOT-RE-ATTEMPT

None new. The route-decision blockers from earlier iters
(Auslander–Buchsbaum, theorem of the cube, Milne Thm 3.2 for the
genus-0 path, `Hom(𝔾_a, A) = 0` standalone) remain off the genus-0
critical path per iter-164 STRATEGY commitment.

## Reusable proof patterns discovered (lifted to PROJECT_STATUS.md Knowledge Base)

1. **Bijectivity of `algebraMap k → ↥(MvPolynomial.homogeneousSubmodule σ k 0)`
   via `homogeneousComponent_of_mem` + `homogeneousComponent_zero`** —
   surjection witness `MvPolynomial.coeff 0 v` for `⟨v, hv⟩`; the simp set
   `[homogeneousComponent_zero, if_true]` is the exact resolver (more
   aggressive `reduceIte` FAILS).
2. **Compose-with-iso = property-preserved for scheme morphism properties**
   via the chain (a) install needed `IsScalarTower`/`Algebra.FiniteType` via
   `restrictScalars`, (b) prove bijectivity of the algebraMap, (c) lift to
   `IsIso (Spec.map _)` via `isIso_SpecMap_iff`, (d) `infer_instance` on
   the composite.
3. **`HasRingHomProperty.Spec_iff (P := @LocallyOfFinitePresentation)` as
   the morphism-property ↔ ring-hom-property bridge** for `Spec.map`-shaped
   morphisms (chains through `RingHom.finitePresentation_algebraMap.mpr`
   to algebra-side instances).
4. **`isReduced_of_isOpenImmersion (AffineSpace.isoOfIsAffine _ _).hom`** —
   transport `IsReduced` from `Spec (.of (MvPolynomial _ _))` (free) back
   to `AffineSpace _ _` via the iso-as-open-immersion pattern. `inferInstance`
   on `AffineSpace _ _` directly does NOT fire.
5. **Analogist "FREE-from-Mathlib" can hide algebraMap-bijectivity
   one-step gap.** When a Mathlib instance lands "FREE" on a canonical
   form `f` and the project composes `f` with `Spec.map`-of-algebraMap, the
   composition step requires explicit bijectivity proof.
