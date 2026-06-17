# Mode: cross-domain-inspiration

## Slug
snap-route

## Structural problem
Build the section graded ring `R(L) = ⊕_{m≥0} Γ(X, L^{⊗m})` of a line bundle `L : X.Modules`
(`SheafOfModules X.ringCatSheaf`) as an associative graded ring. The multiplication
`Γ(L^{⊗m}) ⊗ Γ(L^{⊗m'}) → Γ(L^{⊗(m+m')})` (`sectionsMul`, lax-Γ) is BUILT and associator-free.
ASSOCIATIVITY of the graded ring requires a coherent comparison iso
`tensorPowAdd : L^{⊗m} ⊗ L^{⊗m'} ≅ L^{⊗(m+m')}` (`tensorPow` = iterated `tensorObj`, where
`tensorObj F G = sheafification(F.toPresheaf ⊗ G.toPresheaf)`). The inductive step of `tensorPowAdd`
needs the SHEAF-LEVEL ASSOCIATOR `(A⊗B)⊗C ≅ A⊗(B⊗C)` on `X.Modules`, i.e. strong-monoidality of
`sheafification : X.PresheafOfModules ⥤ X.Modules` — concretely `IsIso (sheafification.map (η_P ▷ Q))`
for the sheafification-adjunction unit `η`.

## Failed approaches
- Analogue-4 "avoid the associator via line-bundle local-freeness" (snap-assoc.md): INSUFFICIENT — moving
  the tensor factor across slots is irreducibly associativity; no unitor/braiding-only route exists.
- Stalkwise-iso ⟹ IsIso on `η_P ⊗ 𝟙_Q`: `η_P ⊗ 𝟙` not locally injective (tensor only right-exact); also
  no stalk infra for `SheafOfModules` in pinned Mathlib.
- `LocalizedMonoidal` (snap-assoc Analogue 1): needs `(J.W.inverseImage (toPresheaf R₀)).IsMonoidal`,
  whose Mathlib discharge route uses the tensor–hom adjunction + internal-hom-is-a-sheaf — but
  `MonoidalClosed (PresheafOfModules R)` is ABSENT in pinned Mathlib.

## What I need
The CHEAPEST route to either (a) the sheaf-level associator / `IsIso (sheafification.map (η_P ▷ Q))`, OR
(b) an ALTERNATIVE construction of the associative section graded ring that does NOT require a monoidal
structure on `X.Modules` at all. Specifically consider: can the graded ring be built at the PRESHEAF level
(`PresheafOfModules` IS genuinely monoidal — associator present) and only take Γ at the end? Does
`Γ(X, sheafification P) ≅ Γ(X, P)` (or the relevant adjunction unit on global sections) let the
associativity proof live entirely in the coherent presheaf monoidal category? Or is there a Mathlib idiom
for the section ring / Proj of an invertible sheaf that sidesteps tensor-power coherence? Rank by porting cost.

## Search radius
wide
