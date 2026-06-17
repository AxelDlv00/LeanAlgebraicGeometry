## Mode: api-alignment

# Question
Can the project obtain the associator (and unitors, braiding) for its scheme-module
tensor product `tensorObj` **unconditionally** (no flatness, no local triviality) by
anchoring on Mathlib's monoidal-sheafification machinery, instead of the hand-built
whiskering transport that has been stuck for ~15 iterations?

# Project context (the current design)
File `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`. For a scheme `X`,
`X.Modules := SheafOfModules X.ringCatSheaf` (sheaves of modules over the scheme's
structure sheaf, a sheaf of CommRings on the topological site `Opens X` with
`J := Opens.grothendieckTopology X`).

- `tensorObj M N : X.Modules` is defined as the **sheafification** of the
  presheaf-of-modules tensor `M.val ⊗ᵖ N.val`, where the presheaf tensor is
  `PresheafOfModules.Monoidal.tensorObj` over the *varying* ring
  `R := X.presheaf ⋙ forget₂ CommRingCat RingCat : (Opens X)ᵒᵖ ⥤ RingCat`.
- The associator `tensorObj_assoc_iso {M N P}` is currently built from
  `PresheafOfModules.monoidalCategoryStruct (R := X.presheaf) |>.associator M.val N.val P.val`
  (this presheaf-level associator over the varying ring EXISTS in Mathlib and is used)
  COMPOSED WITH a sheafification-transport step. That transport's SINGLE remaining
  residual is a `sorry`: `PresheafOfModules.isLocallyInjective_whiskerLeft_of_W`
  ("for a `J.W` (locally-bijective) morphism `g` and any `F`, the left-whisker `F ◁ g`
  is locally injective"), used only with `g = toSheafify`. Proving it by hand needs the
  "stalk commutes with the relative-ring module tensor" lemma (d.2), claimed
  Mathlib-absent at the `PresheafOfModules` level, ~200-400 LOC stalk port.

# The proposed alternative to verify (from a strategy review)
Mathlib reportedly provides:
- `PresheafOfModules.monoidalCategory` — full `MonoidalCategory` on presheaves of
  modules over a varying ring `R : Cᵒᵖ ⥤ CommRingCat` (associator + unitors).
- `CategoryTheory.Sheaf.monoidalCategory` / `symmetricCategory`
  (`Mathlib.CategoryTheory.Sites.Monoidal`): a `MonoidalCategory` on `Sheaf J A` and
  the statement that `presheafToSheaf` is monoidal, GATED on the typeclass
  `J.W.IsMonoidal` (the sheafification weak-equivalence class is ⊗-compatible) +
  `HasWeakSheafify`.
- `CategoryTheory.GrothendieckTopology.W.monoidal` and/or
  `CategoryTheory.Sites.Point.IsMonoidalW` — instances providing `J.W.IsMonoidal`.
  The project's own notes claim `J.W.IsMonoidal` for `Opens X` should follow from
  `Sites.Point.IsMonoidalW` + `TopCat.hasEnoughPoints` (enough points for `Opens X`
  ships in Mathlib as of 2026).

# What I need from you (be concrete and cite exact Mathlib names/paths)
1. **Do these declarations exist** with the names/locations above (or what are the
   real current names)? Verify `PresheafOfModules.monoidalCategory`,
   `CategoryTheory.Sites.Monoidal` contents, `J.W.IsMonoidal`, `Sites.Point.IsMonoidalW`,
   `TopCat.hasEnoughPoints` / enough-points-for-`Opens X`.
2. **Does the chain actually apply to `SheafOfModules`** over the *varying* sheaf of
   rings `X.ringCatSheaf` (NOT a fixed monoidal value category `A`)? `SheafOfModules R`
   is modules over a sheaf of rings, not `Sheaf J A` for fixed `A` — so does
   `CategoryTheory.Sheaf.monoidalCategory` apply off-the-shelf, or is a transport step
   genuinely required, and if so what is its exact shape? Is there an existing
   `MonoidalCategory (SheafOfModules R)` instance (or `MonoidalCategoryStruct`)?
3. **Concretely, what is the cheapest path to an unconditional `tensorObj_assoc_iso`**
   (associativity iso for the sheafified tensor) that RETIRES the
   `isLocallyInjective_whiskerLeft_of_W` sorry? Two candidate shapes:
   (a) establish `J.W.IsMonoidal` for `Opens.grothendieckTopology X` (via
       `Sites.Point.IsMonoidalW` + enough points) and read the associator off the
       resulting `MonoidalCategory` on the sheaf category; vs
   (b) prove `isLocallyInjective_whiskerLeft_of_W` directly via the stalk route.
   Which is more aligned / cheaper, and give the concrete declaration sequence.
4. **Estimate the LOC / risk** for the recommended path, and name any typeclass
   prerequisite (e.g. `MonoidalClosed`, enriched-hom hypotheses on the site) that
   might NOT hold for the `Opens X` module-sheaf setting and block route (a).

Persist your findings to `analogies/monoidal-transport.md`.
