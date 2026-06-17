# Mathlib-analogist directive — Sub-brick A (section identification)

## Mode: api-alignment

## The construction we need to build (and a 4-iter wall around it)

We are proving the augmented Čech complex is a resolution of an `O_X`-module `F`.
Locally over an open `V ⊆ X` with `V ≤ coverOpen 𝒰 i` (i.e. `V` lies inside one
cover member), we must show the **evaluated-at-`V` augmented Čech section complex**
is contractible. The wall is identifying, degreewise and on differentials:

    Γ(V, pushPullObj F Y_p)  ≅  ∏_{σ : Fin(p+1) → I}  Γ(U_σ ∩ V, F)

where, in this project (`AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean`):

- `X : Scheme`, `X.Modules` is `SheafOfModules` over `(X, 𝒪_X)`.
- `pushPullObj F Y := (Scheme.Modules.pushforward Y.hom).obj
    ((Scheme.Modules.pullback Y.hom).obj F)` for `Y : Over X` (def at line 135).
- `Y_p` is the degree-`p` object of `coverCechNerveOver 𝒰` (line 552) = the Čech
  nerve of the cover MAP `q : ∐_i 𝒰.X i → X`. Its degree-`p` left object is
  `∐_{σ : Fin(p+1)→I} U_σ`, with each component mapping by the open immersion
  `U_σ = ⋂_k coverOpen 𝒰 (σ k) ↪ X`. `coverOpen 𝒰 i := (𝒰.f i).opensRange`
  (`FreePresheafComplex.lean:129`).
- So `Γ(V, pushPullObj F Y_p) = Γ(q⁻¹V, q^*F)` (pushforward sections are
  DEFINITIONAL here via `Scheme.Modules.pushforward_obj_obj`, already confirmed),
  and `q⁻¹V = ∐_σ (U_σ ∩ V)` in the coproduct scheme.

## The two precise idiom questions

**Q1 — sections of a sheaf of modules over a coproduct scheme.** For
`q : ∐_{σ∈S} W_σ → X` the canonical map from a coproduct of schemes (each `W_σ` an
open of `X`), and an `𝒪`-module `N` on `∐ W_σ`, is there a Mathlib idiom giving
`Γ(∐_σ W_σ, N) ≅ ∏_σ Γ(W_σ, N|_σ)`? I.e. the sheaf condition / additivity of
global sections over a disjoint union (coproduct in `Scheme` / `TopCat`). Look in:
`AlgebraicGeometry.Scheme`, `TopCat.Presheaf`, `SheafOfModules`, the sheaf-on-a-
coproduct / `Sigma` / disjoint-union sheaf API. Does Mathlib have
"sections over a coproduct = product of sections" for `TopCat.Sheaf` or
`SheafOfModules`, and is it usable here, or must we build it?

**Q2 — pullback of a module sheaf along an open immersion = restriction.** For an
open immersion `j : U ↪ X` and `F : X.Modules`, is `(Scheme.Modules.pullback j).obj F`
canonically the restriction `F|_U`, with sections `Γ(W, (pullback j).obj F) ≅
Γ(j(W), F)` for `W ⊆ U`? Look at `Scheme.Modules.pullback`, `Modules.restrict`,
`SheafOfModules` pullback-along-open-immersion, `Scheme.restrict`,
`AlgebraicGeometry.morphismRestrict`, `IsOpenImmersion` module API. Does Mathlib
identify pullback-along-open-immersion with restriction for sheaves of modules, or
only for the structure sheaf / `TopCat`-level presheaves?

## Why this matters

This identification (Sub-brick A) has blocked `cechAugmented_exact` for 4 iters and
also blocks the dead `CechAcyclic.affine`. We are about to decompose it into a
`\uses`-chain and scaffold a shared Lean file. Before that, I need to know which
pieces are off-the-shelf Mathlib (so the leaves are easy) and which are genuine new
project infra (so I scope a prover lane for them). Tell me, per Q1 and Q2:
- the exact Mathlib decl(s) if they exist (PROCEED), or
- that Mathlib lacks it and the project must build it (name the closest analogue +
  the technique to port), or
- that the project already has a parallel API we should reuse (point at it).

Also check `CechAcyclic.lean` `SectionCechModule`/`sectionCechProductEquiv`/
`sectionCech_objD_apply` (around line 1513) — the project's existing
product-of-sections + alternating-differential machinery — and say whether Sub-brick
A should be expressed THROUGH that existing API (the differential-match piece) rather
than rebuilt.

Write your findings to `analogies/<slug>.md`.
