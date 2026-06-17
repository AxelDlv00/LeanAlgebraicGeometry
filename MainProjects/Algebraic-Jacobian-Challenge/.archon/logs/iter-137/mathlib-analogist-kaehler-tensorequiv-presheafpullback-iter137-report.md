# Mathlib Analogist Report

## Slug

kaehler-tensorequiv-presheafpullback-iter137

## Iteration

137

## Question

How should the algebra-side base-change-of-Ω equivalence
`KaehlerDifferential.tensorKaehlerEquiv` (`Mathlib.RingTheory.Kaehler.TensorProduct`)
be promoted to a sheaf-level natural iso of presheaves of modules —
specifically to close

```
Scheme.relativeDifferentialsPresheaf (fst G G).left ≅
  (PresheafOfModules.pullback
      (Scheme.Hom.toRingCatSheafHom (snd G G).left).hom).obj
    (Scheme.relativeDifferentialsPresheaf G.hom)
```

at `AlgebraicJacobian/Cotangent/GrpObj.lean:480–488` (piece (i.b) Step 2,
load-bearing for `mulRight_globalises_cotangent`)?

## Signature audit

The iter-135 honest scaffold's signature at
`AlgebraicJacobian/Cotangent/GrpObj.lean:480–488` **correctly encodes the
blueprint claim** at `RigidityKbar.tex:464–468`. Specifically:

- LHS `relativeDifferentialsPresheaf (fst G G).left` uses `pr_1.left`
  as the source/structure morphism — realises "view `G ⊗ G` as a
  `G`-scheme via `pr_1`".
- RHS pullback is along `(snd G G).left = pr_2.left` — realises
  `pr_2^* Ω_{G/k}`.
- Both sides land in `(G ⊗ G).left.PresheafOfModules`.
- φ-compatibility morphism is `(Scheme.Hom.toRingCatSheafHom _).hom`
  per iter-135 verdict (`analogies/phi-compatibility-morphisms.md`).
- Used downstream by `relativeDifferentialsPresheaf_restrict_along_identity_section`
  (lines 508–551, iter-136 closed) in exactly this form. Refactoring
  the signature would break Step 3.

**No CRITICAL issue with the signature**. Proceed to body closure.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| 1. Mathlib idiom for sheaf-level base-change-of-Ω | NEEDS_MATHLIB_GAP_FILL | informational |
| 2. `Algebra.IsPushout`-from-affine-product source | NEEDS_MATHLIB_GAP_FILL | informational |
| 3. Naturality assembly via `PresheafOfModules.isoMk` | ALIGN_WITH_MATHLIB | major (still in proposal) |
| 4. `presheaf` vs `sheaf` and non-affine-V hazard | PROCEED (universal-property-at-presheaf route) | major (strategy choice) |
| 5. LOC envelope refinement | refined to ~250–500 LOC body + ~110–210 LOC helpers | informational |
| Signature shape (iter-135 scaffold sign-off) | PROCEED — correct | informational |

## Must-fix-this-iter

None. No ALIGN_WITH_MATHLIB verdict on already-shipped divergent code.
The signature is correct; the body is `sorry` and the iter-137 prover
lane is the right consumer.

## Major

- **Decision 3 (still in proposal)**: the iter-137 prover should use
  `PresheafOfModules.isoMk`
  (`Mathlib/Algebra/Category/ModuleCat/Presheaf.lean:118`) to assemble
  the iso, **NOT** a hand-rolled `Iso.mk { hom, inv, hom_inv_id,
  inv_hom_id }`. `isoMk` consumes a chart-wise `app V` plus a
  naturality square (the latter `cat_disch`-discharged by default),
  matches Mathlib's convention, and auto-generates `simp` lemmas
  `isoMk_hom_app` / `isoMk_inv_app` useful downstream.

- **Decision 4 (strategy choice)**: the iter-137 prover should use the
  **universal-property-at-presheaf-level** route (define a
  chart-wise derivation `D_V`, apply `KaehlerDifferential.lift`,
  glue), **NOT** the chart-affine-cover-and-glue route the blueprint
  prose at `RigidityKbar.tex:474–478` hints at. The latter requires
  sheafifying `relativeDifferentialsPresheaf` (not in the project)
  and fights `isoMk`'s presheaf-level naturality requirement. This
  is the load-bearing strategy decision for body closure.

## Informational

- **Decision 1**: NEEDS_MATHLIB_GAP_FILL confirmed from iter-133.
  Mathlib has `KaehlerDifferential.tensorKaehlerEquiv`
  (`Mathlib/RingTheory/Kaehler/TensorProduct.lean:249`,
  signature `B ⊗[A] Ω[A⁄R] ≃ₗ[B] Ω[B⁄S]` under
  `Algebra.IsPushout R S A B`) but no sheaf-level promotion. Search
  via `lean_leansearch` ("PresheafOfModules pullback differentials"),
  `lean_loogle` (`PresheafOfModules.pullback _ ≅ _`) yields only
  `pullbackId` / `pullbackComp` — no Ω-pullback lemma.

- **Decision 2**: No `Algebra.IsPushout`-from-affine-product helper
  in Mathlib. The chain
  `CommRingCat.isPushout_iff_isPushout`
  (`Mathlib/Algebra/Category/Ring/Constructions.lean:133`) →
  `AlgebraicGeometry.pullbackSpecIso`
  (`Mathlib/AlgebraicGeometry/Pullbacks.lean:703`) →
  `AlgebraicGeometry.isPullback_SpecMap_of_isPushout`
  (`Mathlib/AlgebraicGeometry/Pullbacks.lean:771`) provides the
  building blocks. Project must build the chart-level helper (~80–150
  LOC) — recommend factoring as a stand-alone reusable lemma in
  `Differentials.lean` or a new utility section in
  `Cotangent/GrpObj.lean`.

- **Decision 5 (revised envelope)**: ~250–500 LOC body alone; plus
  `Algebra.IsPushout`-from-affine-product helper (~80–150 LOC) and
  `PresheafOfModules.pullback`-unfolding helper (~30–60 LOC) — both
  factorable. **Total piece (i.b) Step 2 budget: ~360–710 LOC.** This
  widens iter-133's ~150–300 LOC envelope upper bound by ~200 LOC,
  reflecting (i) Mathlib's lack of pointwise unfolding for
  `PresheafOfModules.pullback` (defined as `(pushforward φ).leftAdjoint`,
  opaque on `.obj`/`.map` — `Mathlib/Algebra/Category/ModuleCat/Presheaf/Pullback.lean:44`),
  (ii) the missing `Algebra.IsPushout`-from-affine-product helper, and
  (iii) the universal-property-at-presheaf-level work caused by the
  non-affine-V hazard. **Recommended stall threshold for follow-up
  analogist call: 400 LOC** without a close-in-sight.

## Closure recipe (5-step prose outline)

For the iter-137 prover lane:

1. **Chart-level `Algebra.IsPushout` helper** (~80–150 LOC): for an
   affine `U ⊆ Spec k` and affine charts `V_1, V_2 ⊆ G.left` mapping
   to `U` via `G.hom`, with `W = V_1 ×_{U} V_2` the corresponding
   affine chart of `(G ⊗ G).left`, conclude
   `Algebra.IsPushout Γ(Spec k, U) Γ(G.left, V_1) Γ(G.left, V_2)
     Γ((G ⊗ G).left, W)`.
   Chain: `CommRingCat.isPushout_iff_isPushout` ↔
   `pullbackSpecIso` ↔ `isPullback_SpecMap_of_isPushout`.

2. **`PresheafOfModules.pullback` chart unfolding** (~30–60 LOC):
   build `(PresheafOfModules.pullback φ).obj M)`-on-each-V description
   from the left-adjoint definition + `pullbackPushforwardAdjunction`
   counit (`Pullback.lean:44, 50`). Without this, the chart-wise `app`
   of `isoMk` cannot be written explicitly.

3. **Chart-wise derivation `D_V`** (~50–80 LOC): for each `V ⊆ (G ⊗ G).left`,
   define a `((Opens.map pr_1.base).op ⋙ G.left.presheaf).obj V`-derivation
   `D_V : Γ((G ⊗ G).left, V) → (RHS).obj V`. Concretely, `D_V(b) =
   image of (1 ⊗ d b)` under the helper from Step 2 + the
   `tensorKaehlerEquiv` value identity.

4. **Apply `KaehlerDifferential.lift`** (~30–50 LOC): universal property
   gives a unique linear map `Ω[…] → (RHS).obj V` extending `D_V`. By
   `relativeDifferentials'_map_d`
   (`Mathlib/Algebra/Category/ModuleCat/Differentials/Presheaf.lean:201`)
   these glue into a presheaf-of-modules morphism `LHS → RHS`.

5. **Inverse + `PresheafOfModules.isoMk` assembly** (~80–150 LOC):
   construct the inverse map by the same universal property (analogue
   of `tensorKaehlerEquiv_tmul_D` at
   `Mathlib/RingTheory/Kaehler/TensorProduct.lean:283`). Package via
   `PresheafOfModules.isoMk`
   (`Mathlib/Algebra/Category/ModuleCat/Presheaf.lean:118`). Naturality
   square reduces to compatibility of `lift` with restriction, which
   is `relativeDifferentials'_map_d` plus a chase.

## Alternatives considered

- **Affine-cover-and-glue + sheafification** (the blueprint prose at
  `RigidityKbar.tex:474–478` suggests this). Rejected because the
  project ships `relativeDifferentialsPresheaf` as a presheaf, not a
  sheaf; sheafification would be a separate stack of infrastructure
  (~200–400 LOC of glue) and `PresheafOfModules.isoMk` requires
  naturality over all opens, not just affine ones.

- **Restrict to the affine-open subcategory and apply `isoMk` there,
  then transport via a forgetful functor**. Rejected because no
  `relativeDifferentialsPresheaf` restriction-to-affine-opens
  identification is in the project or Mathlib; would require
  ~150–250 LOC of fresh infrastructure for marginal benefit.

- **Hand-rolled `Iso.mk { hom, inv, hom_inv_id, inv_hom_id }` without
  `isoMk`**. Rejected — Mathlib idiom is `isoMk`, and hand-rolling
  forfeits the auto-`simp` API.

## Cost analysis

- **Cost of NOT aligning with `isoMk` (Decision 3)**: 4 hand-built
  natural-iso fields plus 2 inverse identities, easily ~80 LOC of
  boilerplate that `isoMk` discharges via `cat_disch`. Plus downstream
  consumers (Step 3 closure at lines 540–551) would need bridge
  lemmas to recover the chart-wise `app`-shape they implicitly assume.

- **Cost of NOT addressing Decision 4 (sheaf vs presheaf hazard)**:
  the prover lane would attempt the chart-affine-cover route, hit
  the non-affine-V wall, and either (i) stall and rebuild the
  presheaf-level universal-property argument anyway (wasted ~150 LOC
  of dead-end work) or (ii) introduce a `sorry`-bodied sheafification
  helper that propagates as a hidden axiom (architectural debt).

- **Cost of NOT factoring the helpers (Decision 5 advice)**:
  inlining `Algebra.IsPushout`-from-affine-product into the body
  makes the body 80–150 LOC longer and unreadable; future iters
  (e.g. if other base-change-of-Ω lemmas are needed) re-derive the
  helper. The helper is a genuinely reusable scheme-side
  infrastructure piece and deserves its own declaration.

## Persistent file

- `analogies/kaehler-tensorequiv-presheafpullback.md` — design-rationale
  for the iter-137 prover lane and future iters.

## Overall verdict

**PROCEED with iter-135 honest scaffold signature** (it is correct);
**NEEDS_MATHLIB_GAP_FILL on the body** (Mathlib has no scheme-level
relative cotangent sheaf and no Ω-pullback compatibility lemma — the
project must build it); **ALIGN_WITH_MATHLIB on the assembly idiom**
(use `PresheafOfModules.isoMk`); **strategy decision: universal-property-at-
presheaf route, NOT chart-affine-cover-and-glue**; **revised LOC envelope
~360–710 LOC total** (250–500 LOC body + 110–210 LOC factorable helpers).
