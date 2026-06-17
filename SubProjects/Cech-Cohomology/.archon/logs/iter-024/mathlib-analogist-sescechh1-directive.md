# mathlib-analogist directive — ses_cech_h1 sheaf-theory API

## Mode: api-alignment

## Context
Project `Cech-Cohomology`, working in `AlgebraicGeometry`. We are formalizing the
Stacks lemma "lemma-ses-cech-h1": for a short exact sequence of `O_X`-modules
`0 → F → G → H → 0` on a scheme `X`, an open `U : Opens ↥X`, and an open cover
`𝒰 : ι → Opens ↥X` with `⨆ 𝒰 = U` that is fine enough that `Ȟ¹(𝒰, F) = 0`, the
section map `G(U) → H(U)` is surjective.

The project's category of `O_X`-modules is `X.Modules = SheafOfModules X.ringCatSheaf`,
which is `SheafOfModules` over the Grothendieck topology `Opens.grothendieckTopology ↥X`
on the topological space of the scheme. The underlying presheaf is accessed via
`F.val` / `F.val.presheaf` (a `PresheafOfModules`). The Čech-algebra core is ALREADY
proven in-file (`sectionCech_one_coboundary_of_isZero_homology` : Ȟ¹=0 ⟹ every Čech
1-cocycle in section coordinates is a coboundary). What remains is purely sheaf-theoretic.

## The two API questions (this is what I need located, with exact Mathlib names + signatures)

### Q1 — Local surjectivity / local lifting from an epi of sheaves of modules
We have `G → H` an epimorphism in `X.Modules` (the `g` of a `ShortComplex`/`ShortExact`,
or the cokernel-zero map of the SES). We need: **for a section `s ∈ H(U)` there is a cover
`𝒰` of `U` such that each `s|_{𝒰 i}` lifts to a section of `G` over `𝒰 i`.**
- Is `CategoryTheory.Sheaf.isLocallySurjective_iff_epi` (Mathlib/CategoryTheory/Sites/LocallySurjective.lean)
  the right entry point? Does it apply to `SheafOfModules` directly, or do we go through the
  forgetful functor to `Sheaf J AddCommGrp` / `Sheaf J (Type _)` first?
- What is the exact statement of `PresheafOfModules.IsLocallySurjective` / the
  `SheafOfModules`-level local surjectivity, and how does one extract, from
  `IsLocallySurjective φ` + a section `s` over `U`, an explicit cover + per-piece lifts?
  (i.e. the "unfold IsLocallySurjective at a section" lemma — name + signature.)
- For the topological-space site specifically (`Opens.grothendieckTopology`), is there a
  cleaner `TopCat.Presheaf.IsLocallySurjective` route (Mathlib/Topology/Sheaves/LocallySurjective.lean)
  giving lifts on a basis of opens? Which is the lower-friction path for our `SheafOfModules`?

### Q2 — Gluing sections over a cover (Grothendieck-topology amalgamation)
We then have sections `g_i ∈ G(𝒰 i)` that agree on pairwise overlaps `𝒰 i ⊓ 𝒰 j`, and need
to glue them to a single `g ∈ G(U)` (where `⨆ 𝒰 = U`).
- What is the canonical Mathlib gluing API for a `SheafOfModules` / `PresheafOfModules` that
  `Presheaf.IsSheaf J _`? Name the exact lemma(s): `Presheaf.IsSheaf.amalgamate`,
  `Presheaf.IsSheaf.amalgamate_map`, the `Presheaf.IsSheaf` compatible-family → unique-glue
  statement, and how `SheafOfModules.isSheaf` / `.cond` feeds them.
- Is there a more direct `TopCat`-sheaf gluing (`TopCat.Sheaf` / `TopCat.Presheaf.IsSheaf`
  pairwise-intersections form, `TopCat.Sheaf.objSupIsoProdEqLocus` / opens-cover gluing) that is
  easier for `Opens.grothendieckTopology`? The cover is by opens with `⨆ 𝒰 = U`.
- Concretely: given the compatible family `g_i`, what produces `g ∈ G(U)` and the rewrite
  `g|_{𝒰 i} = g_i` we need to verify `g ↦ s`?

## What I need back
For EACH of Q1 and Q2: the canonical Mathlib idiom (exact declaration names + signatures, file
paths), whether it applies to `SheafOfModules X.ringCatSheaf` directly or via a forget functor,
and a concrete 3–6 step skeleton (Mathlib lemma names, no full tactic proofs) the prover can
follow. Flag any genuine Mathlib GAP (no usable lemma exists) so we can plan a project-side
mathlib-build instead. Verify names exist via Lean search — do not guess. Write the persistent
findings to `analogies/ses-cech-h1-sheaf-api.md`.
