## Mode: api-alignment

## Context
We are about to scaffold a NEW Lean file `AlgebraicJacobian/Picard/GrassmannianQuot.lean`
realizing five declarations from the (gate-cleared) blueprint chapter
`blueprint/src/chapters/Picard_GrassmannianQuot.tex`. The Grassmannian scheme
`Grassmannian.scheme` already exists (glued from affine charts `U^I = Spec ℤ[X^I]`
via transition isos `θ_{I,J}` satisfying a cocycle `gr_cocycle`, in
`AlgebraicJacobian/Picard/GrassmannianCells.lean`). We need the Mathlib-aligned
SHAPE for two pieces of new infrastructure before writing signatures.

## Questions (find Mathlib's canonical idiom for each)

1. **Gluing a sheaf of modules from local data + a GL_d cocycle.** We have, on each
   chart `U^I`, the free sheaf `O_{U^I}^d`, and on overlaps `U^I_J` invertible
   transition matrices `g_{I,J} = (X^I_J)⁻¹ ∈ GL_d(R^I_J)` satisfying the
   multiplicative cocycle condition. We want to build a global locally-free rank-`d`
   `SheafOfModules` (or `X.Modules`) `universalQuotient` on `Grassmannian.scheme`.
   - What is Mathlib's idiom to glue a `SheafOfModules`/`PresheafOfModules` from an
     open cover + descent/transition data? Is there `SheafOfModules` gluing, a
     `TopCat.Sheaf` gluing, or a descent API (`CategoryTheory.…descent`,
     `Limits`-based gluing, `GlueData` for sheaves)?
   - How is "locally free of rank `d`" expressed for `SheafOfModules`/`X.Modules`?
     (a predicate? `IsLocallyFree`? rank via `Module.Free` on stalks/sections?)
   - Likewise the tautological surjection `u : O^r ↠ U`: gluing a sheaf MORPHISM
     from local maps `u^I` compatible with the cocycle — Mathlib idiom?

2. **Representability of a functor of points.** We want
   `Grassmannian.functor : Schemeᵒᵖ ⥤ Type _` sending `T` to equivalence classes
   of rank-`d` locally-free quotients of `O_T^r`, and a theorem `represents` that
   `Grassmannian.scheme` represents it.
   - Mathlib idiom: `CategoryTheory.Functor.RepresentableBy`, `yoneda`/`coyoneda`
     natural iso, `Functor.representableBy…`? Which is the canonical target shape
     for "scheme `X` represents functor `F`"?
   - How is a "family of rank-`d` quotients of `O_T^r` up to iso" best encoded as a
     `Type`-valued functor in Mathlib's `AlgebraicGeometry` conventions
     (subobject/quotient API, `SheafOfModules` hom up to iso, kernel as the datum)?

## Out of scope
- Do NOT design the proofs; only the DEFINITION/SIGNATURE shapes + whether each
  needed primitive already exists in the pinned Mathlib or must be built project-side.
- Report, per piece: the Mathlib idiom (with citations), whether it EXISTS in pinned
  Mathlib, and a concrete proposed Lean signature shape for the scaffold. Flag any
  piece that has NO Mathlib support (must be built project-side) — that is the most
  important output, since it determines whether iter-050 scaffolds directly or needs
  an infra-build step first.
