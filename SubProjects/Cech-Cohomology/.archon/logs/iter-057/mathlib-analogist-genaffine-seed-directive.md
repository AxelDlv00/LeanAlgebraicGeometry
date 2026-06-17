# Mathlib-analogist directive — general-affine-open section Čech vanishing seed

## Mode: api-alignment

## Question
We must build the LAST residual of the open-immersion-acyclicity lane (Need#2): the **general-affine-open
standard-cover Čech vanishing seed** `htilde`. Find the cheapest Mathlib-aligned formalization route, and
flag if the project is about to build a parallel API where Mathlib already has the idiom.

### Precise statement to prove
Let `R` be a commutative ring, `M : ModuleCat R`, `g : Fin n → R` a finite family, and suppose the open
`V := ⨆ᵢ D(gᵢ) ⊆ Spec R` is an AFFINE open (general — NOT assumed equal to `D(f)` for any single `f`).
Then for every `p > 0`:
`IsZero (cechCohomology (fun i => D(gᵢ)) ((toPresheafOfModules).obj (tilde M)) p)`,
i.e. the positive-degree homology of the section Čech complex of `~_R M` over the cover `{D(gᵢ)}` of `V`
vanishes. (`cechCohomology U F p := (sectionCechComplex U F).homology p`.)

### The intended route (adjudicate / improve / cite the Mathlib idioms)
Set `S := Γ(V, 𝒪_V)`, the coordinate ring of the affine open `V`; let `φ : R → S` be the restriction ring
map. The plan:
1. The `D(gᵢ) ⊆ V` correspond, under `V ≅ Spec S` (`IsAffineOpen.isoSpec` / `Scheme.isoSpec`), to basic
   opens `D_S(ḡᵢ)` of `Spec S` (`ḡᵢ := φ(gᵢ)`), and `{ḡᵢ}` **span the unit ideal of `S`** (because the
   `D_S(ḡᵢ)` cover `Spec S = V`).
2. The section Čech complex of `~_R M` over `{D_R(gᵢ)}` (terms `Γ(D_R(∏gσk), ~M) = M_{∏gσk}`) is
   isomorphic, complex-wise, to the **standard-cover** (full-span) section Čech complex over `Spec S` of
   `~_S(Γ(V,~M))` where `Γ(V,~M) = M ⊗_R S` (terms `(M⊗_R S)_{∏ḡσk}`).
3. Apply the EXISTING shipped full-span result `sectionCech_affine_vanishing` /
   `sectionCech_homology_exact` (CechAcyclic.lean ~1587) over `S` with the spanning family `ḡ`.

### Specific Mathlib-idiom questions I need answered (cite real decl names + file paths)
- **A. The coordinate-ring identification `R_g ≅ S_ḡ`** for `D_R(g) ⊆ V`. Is there a Mathlib lemma that a
  basic open `D(g)` contained in an affine open `V` has `Γ(D(g),𝒪) = Γ(V,𝒪)_{ḡ}` (i.e. `IsLocalization`
  of `S` away from `ḡ` equals `IsLocalization` of `R` away from `g`)? Look at `IsAffineOpen.isLocalization*`
  (e.g. `IsAffineOpen.isLocalization_basicOpen`, `IsAffineOpen.isLocalization_of_eq_basicOpen`), the
  `AlgebraicGeometry.Scheme` Γ-on-basic-opens API, and `IsAffineOpen.basicOpen` machinery. Does
  `Γ(V,~M)_{ḡᵢ} ≅ M_{gᵢ}` follow as `IsLocalizedModule` transitivity?
- **B. The quasi-coherent section base-change `Γ(V,~_R M) = M ⊗_R S`.** Does Mathlib package
  `Γ(affine open V, ~M)` as a base-change of `M` along `R → Γ(V,𝒪)`? See
  `AlgebraicGeometry.Scheme.Modules`/`Spec`-pullback API, `IsAffineOpen.SpecΓIdentity`,
  `ΓSpecIso`, quasi-coherent `Γ`-on-affine lemmas. Or is the section-level identification cleaner via
  `IsLocalizedModule`/`comparison` (the project's `AwayComparison` toolkit) WITHOUT ever forming `M⊗_R S`?
- **C. Is the whole seed obtainable WITHOUT change-of-ring at all** — e.g. is there a Mathlib
  "quasi-coherent cohomology vanishes on affine" or "Čech complex over a cover of an affine scheme is
  exact" result we can transport along `V ≅ Spec S` at the SECTION (not ambient-Ext) level? Note: ambient
  `Ext` transport along `V ↪ Spec R` is REJECTED (restriction-of-injectives wall, iter-056); we stay at
  the concrete section-complex level.
- **D. Cheapest packaging.** Is the cleanest route (i) co-locate a new public theorem in
  `CechAcyclic.lean` reusing the polymorphic `private SectionCechModule`/`SectionCechTilde` core
  re-instantiated over `S` (mirroring the done `sectionCech_homology_exact_of_localizationAway`), or
  (ii) a fresh file? Estimate LOC and the count of bridge lemmas.

## Project artifacts to read
- `analogies/02kg-residual-changeofbase.md` — the DONE `D(f)` case (route B change-of-ring over
  `Localization.Away f`); the new general-`V` case generalizes its `R_f` to `S = Γ(V)` which is NOT a
  localization. Read it to reuse the ladder structure.
- `analogies/change-of-scheme-cohomology.md` — the iter-056 WALL analysis (why ambient-Ext transport is
  rejected; what the sound section-level route is).
- `CechAcyclic.lean`: `sectionCech_affine_vanishing`/`sectionCech_homology_exact` (~1587), the
  `private SectionCechModule.dDiff_exact` (~874–1106, the `{R}[CommRing R]`-polymorphic core),
  `SectionCechTilde` bridge (~1330–1581), `AwayComparison` (~482–660),
  `sectionCech_homology_exact_of_localizationAway` (the done D(f) theorem, ~1868).
- `AffineSerreVanishing.lean`: the 7 new Need#2 decls (~544–852), `affine_cover_span_localizationAway`
  (~402), `affine_cech_vanishing_qcoh_general_of_tildeVanishing` (~795).

## Output
A `analogies/<slug>.md` file + report. I need: the verified Mathlib decl names/paths for A–C, a
PROCEED/ALIGN verdict on the route, and a concrete bridge-lemma decomposition with LOC estimate.
Write the analogy to `analogies/genaffine-cech-seed.md`.
