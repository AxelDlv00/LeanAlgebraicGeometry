## Mode: api-alignment

## Question
The GF base case (`lem:gf_affine_qcoh_Gamma_epi`) needs: on an affine open `V ≅ Spec B` of a
scheme, the global-sections functor `Γ(-, V)` on QUASI-COHERENT `O_V`-modules sends a sheaf
EPIMORPHISM `π : G ↠ F` to a SURJECTIVE `B`-module map `Γ(π) : Γ(G,V) → Γ(F,V)`. Equivalently:
`Γ` is exact / right-exact on affine quasi-coherent modules (no higher quasi-coherent cohomology).

## What we have (and why the obvious route fails)
The project deliberately built its qcoh≃Mod descent OBJECT-WISE, NOT as a global equivalence:
- `AlgebraicGeometry.Scheme.Modules.isIso_fromTildeΓ` (gap1) — a per-object `IsIso M.fromTildeΓ`
  for a quasi-coherent `M : X.Modules`, giving an iso `M ≅ ~Γ(M,V)` one object at a time.
- `isLocalizedModule_restrict_of_isIso_fromTildeΓ`, `isLocalizedModule_basicOpen` (gap2).
These are object isos, NOT a natural/exact functor, so they do NOT by themselves carry an epi to a
surjection.

## What I need from you
1. Does Mathlib provide a usable AFFINE qcoh ≃ ModuleCat equivalence (or adjunction with the right
   exactness) at the `SheafOfModules`/`X.Modules` level over `Spec B` — e.g. around
   `Mathlib/AlgebraicGeometry/Modules/Tilde.lean`, `Spec`-pullback adjunctions, or
   `PresheafOfModules`/`SheafOfModules` machinery — that makes `Γ` on affine qcoh exact (preserves
   epis) WITHOUT building H¹-vanishing from scratch? Name the exact decls.
2. If no ready equivalence: what is the cheapest Mathlib-grounded mechanism for "sheaf epi of qcoh
   on affine ⟹ surjective on Γ"? Options to assess: (a) the tilde functor is right-exact /
   `Γ ∘ ~ ≅ id` is exact; (b) `IsLocalizedModule` surjectivity transported object-wise via the
   gap1 iso applied to BOTH `G` and `F` plus naturality of `fromTildeΓ`; (c) genuine
   H¹(affine, qcoh)=0 (name the Mathlib tag if it exists, else flag as a build).
3. Is the gap1 iso `fromTildeΓ` NATURAL in the module (a `NatIso`/`NatTrans` component) so a
   commuting square with `π` can carry surjectivity? Point at the naturality lemma if present.

## Deliverable
Ranked concrete mechanisms with exact Mathlib decl names (or a clear "absent, must-build" verdict
with the smallest buildable ingredient), written to analogies/ + your report. This re-grounds the
seam-2 blueprint proof, which currently hand-waves "global sections on affine are exact."
