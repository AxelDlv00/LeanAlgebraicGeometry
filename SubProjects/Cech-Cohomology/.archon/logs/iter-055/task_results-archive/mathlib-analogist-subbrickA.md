# Mathlib Analogist Report

## Mode
api-alignment

## Slug
subbrickA

## Iteration
055

## Question
Identify degreewise + on differentials `Γ(V, pushPullObj F Y_p) ≅ ∏_{σ:Fin(p+1)→I} Γ(U_σ ∩ V, F)`
for the evaluated augmented Čech section complex. (Q1) Mathlib idiom for "sections of a module
sheaf over a coproduct scheme = product of sections"? (Q2) Does Mathlib identify pullback-along-
open-immersion with restriction for sheaves of modules? Should Sub-brick A be expressed THROUGH
the existing `sectionCechProductEquiv` machinery?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| Q2 — pullback along open immersion = restriction | PROCEED (idiom exists, already adopted in project) | informational |
| Q1 — module sheaf over coproduct scheme = product | NEEDS_MATHLIB_GAP_FILL (1 lemma; everything around it off-the-shelf) | informational |
| Differential via existing `sectionCech_objD_apply` | ALIGN (reuse, don't rebuild) | informational |

## Answer to Q1 (coproduct-scheme sections = product)

**Mathlib does NOT have it in the needed form.** Only binary, and only for the structure sheaf /
general `TopCat.Sheaf`:
- `Scheme.coprodPresheafObjIso` — `(X⨿Y).presheaf.obj(op U) ≅ X.presheaf(inl⁻¹U) ⨯ Y.presheaf(inr⁻¹U)`, **binary, structure sheaf** (`Mathlib/AlgebraicGeometry/Limits.lean:476`).
- `TopCat.Sheaf.isProductOfDisjoint` — `F(U⊔V) ≅ F(U)⨯F(V)` for `U⊓V=⊥`, **binary, general `TopCat.Sheaf`** (`Mathlib/Topology/Sheaves/SheafCondition/PairwiseIntersections.lean:430`).
- `Scheme.sigmaMk : (Σ i, f i) ≃ₜ ∐ f` (`Limits.lean:246`) — indexed coproduct of *spaces*, no section decomposition.

No indexed (`σ`-family) version; nothing for `SheafOfModules`/`X.Modules`. **Must be built.**

**The gap is small, because the surrounding pieces are off-the-shelf.** `SheafOfModules.evaluation`
**preserves all limits** (`Mathlib/Algebra/Category/ModuleCat/Sheaf/Limits.lean:85,108`) and `X.Modules`
`HasLimits` (`Sheaf.lean:50`). So if the degree-`p` object is recognised as a *product in `X.Modules`*,
then `Γ(V, ∏_σ N_σ) ≅ ∏_σ Γ(V, N_σ)` is free. The single new lemma is therefore at the MODULE level:

  `pushPullObj F Y_p ≅ ∏_σ pushPullObj F (Over.mk j_σ)`   (equiv. `(q_p)_*(q_p)^*F ≅ ∏_σ (j_σ)_*(j_σ)^*F`)

— the disjoint-union decomposition of a module on `∐_σ U_σ`. **Port technique**: generalise the binary
`isProductOfDisjoint`/`coprodPresheafObjIso` argument to finite-indexed `σ` and lift from presheaves
to `SheafOfModules` through `Scheme.Modules.toPresheaf` (faithful, reflects isos, preserves limits —
`Sheaf.lean:75–78`) plus `M.presheaf.IsSheaf` (`Sheaf.lean:126`). Scope this as a dedicated prover lane.

## Answer to Q2 (pullback along open immersion = restriction)

**Mathlib HAS it, and the project already uses it.**
- `Scheme.Modules.restrictFunctor f : Y.Modules ⥤ X.Modules` (`Sheaf.lean:319`), "better-defeq" pullback.
- `restrict_obj` (`Sheaf.lean:328`): `Γ(M.restrict f, U) = Γ(M, f ''ᵁ U)` — **`rfl`**.
- `restrict_map` (`:331`), `restrictFunctorComp` (`:392`), `restrictFunctorId`, `restrictFunctorCongr`.
- `restrictFunctorIsoPullback f : restrictFunctor f ≅ pullback f` (`Sheaf.lean:371`) — bridges to the
  `Scheme.Modules.pullback` that `pushPullObj` is literally built on.

The project ALREADY adopts exactly this idiom in `QcohRestrictBasicOpen.lean:113–114,248,283–286`.
Reuse that established pattern — no new infra, just `restrictFunctorIsoPullback` + `restrict_obj`.
**Caveat**: `q_p` is a *coproduct* map, not itself an open immersion; the open immersions are the
legs `j_σ : U_σ ↪ X`. So Q2 applies per-leg, AFTER the Q1 coproduct→product split.

## Route through existing `sectionCechProductEquiv` machinery — YES

`CechAcyclic.lean:1513` `sectionCech_objD_apply` already proves that, read through
`sectionCechProductEquiv`, the cosimplicial coface differential equals the alternating sum
`∑ᵢ (-1)ⁱ • sectionCechFaceRestr` of presheaf restrictions — the shape `SectionCechModule.dDiff`
consumes. **Do not rebuild this.** Land Sub-brick A's degreewise iso in the shape
`∏_σ Γ(coverInterOpen 𝒰 σ ⊓ V, F)` and route the differential-match through `sectionCech_objD_apply`.
The only genuinely NEW geometric work is the degreewise *object* iso.

## `\uses`-chain decomposition (one new-infra leaf)

For `Γ(V, pushPullObj F Y_p) ≅ ∏_σ Γ(U_σ ∩ V, F)`:
1. `pushforward_obj_obj` (`Sheaf.lean:156`, `rfl`): `Γ(V,(q_p)_* N)=Γ(q_p⁻¹V,N)`. **off-the-shelf**
2. **[NEW — prover lane]** `pushPullObj F Y_p ≅ ∏_σ pushPullObj F (Over.mk j_σ)` (Q1 gap).
3. `evaluation` preserves products (`Sheaf/Limits.lean:85`): `Γ(V,∏_σ N_σ)≅∏_σ Γ(V,N_σ)`. **off-the-shelf**
4. `restrictFunctorIsoPullback` (`Sheaf.lean:371`): `(j_σ)^*F ≅ F.restrict j_σ`. **off-the-shelf, already in project**
5. `restrict_obj` (`:328`, `rfl`) + `opensRange`/image-preimage: `Γ(j_σ⁻¹V, F.restrict j_σ)=Γ(U_σ∩V,F)`. **off-the-shelf**

Plus a separate geometric identification `(coverCechNerveOver 𝒰).obj [p] = ∐_σ U_σ` (fibre powers of
open immersions = intersection opens) — bookkeeping, distinct from the sheaf-theoretic gap #2.

## Informational

- Same gap (#2) also unblocks the dead `CechAcyclic.affine` and the L1 bridge: both want exactly this
  product-of-sections identification; building #2 once at the module level should serve both.
- `CechBridge.lean:93–97,156` already wields the dual coproduct-hom identity `Hom(∐_σ A_σ,F)≅∏_σ Hom(A_σ,F)`
  for the FREE/representable Čech route via `Limits.Sigma.desc`/`Sigma.ι` — confirms the project is fluent
  in the `Sigma` universal-property pattern that leaf #2's proof will lean on.

## Persistent file
- `analogies/subbrickA.md` — design-rationale captured for future iters.

Overall verdict: Q2 is off-the-shelf and already an adopted project pattern (`restrictFunctorIsoPullback`/`restrict_obj`); Q1 reduces to ONE new module-level coproduct→product lemma (port binary `isProductOfDisjoint`/`coprodPresheafObjIso` via `toPresheaf`), with `evaluation`-preserves-products making the rest free; route the differential through the existing `sectionCech_objD_apply`.
