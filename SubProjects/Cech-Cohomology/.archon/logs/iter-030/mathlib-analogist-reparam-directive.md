# Mathlib analogist — re-parameterization + local-surjectivity scouting

## Mode: api-alignment

## Context
Project formalizing Čech cohomology of schemes. Two API questions before committing prover budget.

### Question 1 — re-parameterizing a free-Čech resolution by a raw family of opens
The file `AlgebraicJacobian/Cohomology/FreePresheafComplex.lean` builds a free resolution
of a "cover structure presheaf" indexed by an `X.OpenCover` `𝒰` (a cover of the whole scheme
`X`). Key decls: `coverOpen 𝒰 i := (𝒰.f i).opensRange`, `coverInterOpen 𝒰 σ := ⨅ k, coverOpen 𝒰 (σ k)`,
`cechFreeSimplicial`, `cechFreePresheafComplex`, `cechFreeAug`,
`coverStructurePresheaf 𝒰 := Limits.image (cechFreeAug 𝒰)`, `cechFreeComplexAug`,
`cechFreeComplex_quasiIso`. Consumed in `CechBridge.lean` by `injective_cech_acyclic`
(positive-degree section-Čech cohomology of an injective vanishes).

The plan is to re-parameterize the whole machinery from `(𝒰 : X.OpenCover) [Finite 𝒰.I₀]`
to `{ι : Type} [Finite ι] (U : ι → Opens X)`, replacing `coverOpen 𝒰 → U`,
`coverInterOpen 𝒰 σ → ⨅ k, U (σ k)`, `𝒰.I₀ → ι`, and keeping the `X.OpenCover` API as thin
wrappers passing `coverOpen 𝒰`.

- Does Mathlib already have a Čech / nerve / coverage construction indexed by a raw family of
  opens (or objects) that we should align with, rather than re-parameterizing a bespoke one?
  Look at `CategoryTheory.Limits.Cech`, `AlgebraicGeometry.Scheme.Cover`, `Mathlib.Topology.Sheaves`
  Čech machinery, simplicial/nerve constructions, `Mathlib.AlgebraicTopology`.
- Is there any reason a free-Yoneda Čech resolution would *need* the family to cover the
  whole space (vs. covering just its own supremum `⨆ U i`)? We believe the augmentation target
  `image(cechFreeAug)` is the "locally `O_X`, else 0" presheaf and the resolution is intrinsically
  cover-agnostic. Sanity-check that reasoning against any Mathlib precedent for Čech resolutions
  of a cover sieve / coverage.

### Question 2 — sheaf-of-modules epimorphism ⇒ local section surjectivity
For `surj_of_vanishing` we need: given an epimorphism `g : M ⟶ N` of `X.Modules`
(`SheafOfModules` over `X.ringCatSheaf`), and a section `t ∈ N(V)` over an open `V`, there is a
cover of `V` by opens `{W_i}` and sections `s_i ∈ M(W_i)` with `g(s_i) = t|_{W_i}`. Ideally with
the `W_i` taken to be basic/affine opens (a standard cover).

Find the Mathlib idiom:
- Is there `CategoryTheory.Sheaf.epi_iff_isLocallySurjective` / `Presheaf.IsLocallySurjective`
  for the relevant Grothendieck topology, and how does it transfer through
  `SheafOfModules.forget` / `toSheaf` to give local surjectivity of *sections*?
- For schemes specifically (`X.Modules` = `SheafOfModules X.ringCatSheaf` on the opens-Grothendieck
  topology / `Opens X`), what is the concrete statement that yields per-point lifts, and can the
  cover be refined to basic opens via `Scheme.isBasis_affineOpens` / the distinguished-open basis?

## Output
Per your api-alignment format: for each question, the Mathlib idiom (with citations), whether the
project's planned path aligns or should change, and the concrete decl names a prover should target.
Write the persistent analysis to `analogies/<slug>.md`.
