# Mathlib Analogist Report

## Slug
mulright-globalises-iter133

## Iteration
133

## Question

What is the canonical Mathlib pattern for proving that the relative
cotangent sheaf `Ω_{G/k}` of a smooth group scheme `G/k` is trivialised
by translation, i.e.\ globally isomorphic to the pullback along
`G → Spec k` of the cotangent space at the identity?

Sub-questions:
(A) Mathlib precedent for the shear-iso globalisation
    `σ = ⟨pr₁, μ⟩ : G ×_k G ≅ G ×_k G` as a categorical map in
    `Over (Spec k)` from `GrpObj` data only, and idiom for the natural
    iso `Ω_{G/k} ≅ pr_1^*(η_G^* Ω_{G/k})`.
(B) Whether the iter-131 `Classical.choose`-chain body of
    `cotangentSpaceAtIdentity` composes with the shear iso, or
    whether piece (i.b) needs an inline (B)→(A) stalk-cotangent
    bridge.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| 1: Shear iso `σ = ⟨pr₁, μ⟩` as `A ⊗ A ≅ A ⊗ A` | NEEDS_MATHLIB_GAP_FILL | informational (modelled on `GrpObj.mulRight`, ~30–60 LOC) |
| 2: Natural iso `Ω_{(G ×_k G)/G} ≅ pr_2^* Ω_{G/k}` (sheaf-level) | NEEDS_MATHLIB_GAP_FILL | major (~150–300 LOC; load-bearing for piece (i.b)) |
| 3: iter-131 (B)-body composability with shear iso | PROCEED | critical guidance — refutes iter-130 strategy-critic Q2 worry |
| 4: Lemma RHS style (sheaf-level abstract fibre vs. value-level chart-base-changed) | ALIGN_WITH_MATHLIB (sheaf-level) | major (sets piece (i.b) LOC envelope) |

## Must-fix-this-iter

None. Piece (i.b) has **not yet shipped**; this consult is the
proactive design check the iter-131 strategy-critic Q3 scheduled. All
verdicts apply to the iter-134+ prover lane that will land piece (i.b).

## Major

- **Decision 4 (ALIGN_WITH_MATHLIB)**: The iter-134+ prover lane should
  state `AlgebraicGeometry.GrpObj.mulRight_globalises_cotangent` with
  a **sheaf-level** RHS using the abstract pullback presheaf
  `η_G^* (relativeDifferentialsPresheaf G.hom)`, NOT a value-level RHS
  exposing `cotangentSpaceAtIdentity G`. Rationale: this decouples
  piece (i.b)'s body from the chart-localisation work and stays in the
  blueprint's `\notready` envelope. The conversion to
  `cotangentSpaceAtIdentity G` becomes a separate chart-localisation
  identification lemma (~100–200 LOC) consumed in piece (i.c)
  (`omega_free`).

  **Forbidden alternative** (per iter-127 over-k risk register at
  `RigidityKbar.tex:258`): do NOT model on the pointwise idiom of
  `Mathlib.Geometry.Manifold.GroupLieAlgebra.mulInvariantVectorField`
  (which requires `[Group G]` + pointwise translation) or
  `Mathlib.Topology.Algebra.Group.Basic.Homeomorph.shearMulRight`
  (which requires `[Group G]` typeclass on the carrier). The
  `pointEquivClosedPoint`/`IsAlgClosed K`-based idiom of
  `Mathlib.AlgebraicGeometry.Group.Smooth.lean:50-51` is also
  forbidden for the same reason.

- **Decision 2 (NEEDS_MATHLIB_GAP_FILL, ~150–300 LOC)**: the
  sheaf-level natural iso `Ω_{(G ×_k G)/G} ≅ pr_2^* Ω_{G/k}` is the
  load-bearing piece of (i.b). Mathlib has no scheme-level relative
  cotangent sheaf at all (Decision 2 of `analogies/lieAlgebra-rank-bridge.md`
  iter-129 already noted this); the chaining of `TopCat.Presheaf.pullback`
  with the algebra-side `KaehlerDifferential.tensorKaehlerEquiv` is the
  Mathlib idiom to consume.

## Informational

- **Decision 1 (NEEDS_MATHLIB_GAP_FILL, ~30–60 LOC)**: the categorical
  shear iso `σ = lift (fst G G) μ : G ⊗ G ≅ G ⊗ G` in `Over (Spec k)`
  is not packaged in Mathlib, but the construction template is in
  `CategoryTheory.GrpObj.mulRight`
  (`Mathlib.CategoryTheory.Monoidal.Grp_.lean:277-281`) and the proof
  shape is in `CategoryTheory.GrpObj.isPullback` (Grp_.lean:293-323).
  This is a clean GAP_FILL, not divergence from any idiom.

- **Decision 3 (PROCEED — refutes the iter-130 strategy-critic Q2
  worry)**: the iter-131 `Classical.choose`-chain body of
  `cotangentSpaceAtIdentity` (per `analogies/cotangent-body-shape.md`)
  composes cleanly with the shear iso. The bridge piece (i.b) needs
  is a **chart-localisation identification** (~100–200 LOC), NOT the
  **(B)→(A) stalk-cotangent bridge** (~300–600 LOC) that the iter-130
  strategy-critic Q2 worried about. These are structurally distinct
  artefacts:
  - Chart-localisation: identifies the presheaf-pullback along `η_G` of
    `relativeDifferentialsPresheaf` with `cotangentSpaceAtIdentity G`'s
    chart-base-change body, via
    `relativeDifferentialsPresheaf_obj_kaehler` + `Scheme.ΓSpecIso`.
  - Stalk-cotangent bridge: identifies `cotangentSpaceAtIdentity G` with
    `Ideal.IsLocalRing.CotangentSpace 𝔪_{η_G}` via a localisation-at-the-
    identity-stalk step (the `lem:GrpObj_cotangent_bridge` of
    `RigidityKbar.tex:124-178`, currently `\notready`).

  **Trigger (a') refinement**: trigger (a') in STRATEGY.md should
  fire only if the prover lane chooses the value-level-stalk RHS
  phrasing. With the recommended sheaf-level RHS, trigger (a') does
  NOT fire and the deferred `lem:GrpObj_cotangent_bridge` stays
  vestigial.

## LOC envelope for piece (i.b)

| Closure path | Piece (i.b) LOC | Bridge artefact | Trigger (a') fires? |
|---|---|---|---|
| **Sheaf-level RHS (recommended)** | **210–440** | chart-localisation iso (~100–200 LOC, deferred to piece (i.c)) | NO |
| Value-level RHS via `cotangentSpaceAtIdentity` | 310–640 | chart-localisation iso (inline) | NO |
| Value-level RHS via stalk `m/m²` | 500–1100 | (B)→(A) stalk bridge (inline) | YES |

The directive's worry-scenario (500–1100 LOC, route pivot, trigger (a')
fires) is the third row, which the iter-134+ prover lane should
explicitly avoid by adopting the sheaf-level RHS (top row). **Original
200–500 LOC envelope for piece (i.b) holds under the recommended
phrasing.**

## Persistent file
- `analogies/mulright-globalises-cotangent.md` — full design rationale,
  citations, and per-decision verdicts.

## Overall verdict

PROCEED with the iter-131 (B)-body composition, but **state piece (i.b)
at the sheaf level** with abstract `η_G^* Ω_{G/k}` RHS — this keeps
piece (i.b) in the original 200–500 LOC envelope and pushes the
(distinct, smaller, non-stalk-flavoured) chart-localisation
identification into piece (i.c).
