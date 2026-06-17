# Directive — blueprint-writer

## Chapter
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (the consolidated chapter; its
`% archon:covers` list includes both `CechAcyclic.lean` and `CechHigherDirectImage.lean`).

## Goal
Restore the Lean↔blueprint 1-to-1 correspondence for declarations that landed in iter-051, fix two
hint-precision defects, and **rewrite the `lem:cech_augmented_resolution` proof sketch to the chosen
sections/sheafification route** (the current stalk-at-prime sketch is being replaced). Do NOT add
`\leanok` anywhere (the deterministic sync handles it). Most new blocks are **Archon-original
project infrastructure** (no external source) — for those, omit the `% SOURCE`/`\textit{Source}` lines
and let the block stand on its statement + one-line proof. Keep the existing `% SOURCE QUOTE` material
on `lem:cech_augmented_resolution` (the "augmented Čech complex is a resolution" Stacks quote) intact.

---

## Part 1 — Coverage-debt blocks (CechAcyclic.lean route-B helpers)

Add blueprint blocks (or bundle into existing blocks' `\lean{}`) for these PROVED, axiom-clean
declarations. Statements are below; give each a one-line informal proof and an accurate `\uses{}`.

### 1a. `lem:isLocalizedModule_comp_away` (new block, near `lem:away_comparison_isLocalizedModule`)
- `\lean{AlgebraicGeometry.AwayComparison.isLocalizedModule_comp_away}`
- **Statement:** Let `R → Rf` localize `R` at `f`. If `mkf : M → Mf` exhibits `Mf` as `M` localised at
  the powers of `f`, and `gN : Mf → N` is an `Rf`-linear map exhibiting `N` as `Mf` localised at the
  powers of `algebraMap R Rf a` (where `a^j = f·h` for some `h`, i.e. `f ∣ aʲ`), then the `R`-linear
  composite `gN.restrictScalars R ∘ mkf : M → N` exhibits `N` as `M` localised at the powers of `a`.
- **Proof (one line):** Verify the three `IsLocalizedModule` clauses directly: map_units transports the
  `Rf`-action bijectivity via `map_pow`; surjectivity uses the witness `hˡ • m₀` with
  `a^{jl+k} = hˡ·(fˡ·aᵏ)`; exists_of_eq chains `IsLocalizedModule.exists_of_eq` for `gN` then `mkf`.
  (Avoids the Mathlib-absent converse of `of_restrictScalars`.)
- `\uses{}`: the Mathlib `IsLocalizedModule` API only (no project deps).

### 1b. `lem:section_cech_module_exact_of_localizationAway` (new block, sub-lemma of the subcover lemma)
- `\lean{AlgebraicGeometry.SectionCechModule.dDiff_exact_of_localizationAway}`
- **Statement:** For `M : ModuleCat R`, finite `s : ι → R`, and `f : R` with (a) each `sᵢ ∈ √(f)`
  (`f ∣ sᵢ^{kᵢ}`) and (b) `{algebraMap R Rf (sᵢ)}` spanning `⊤` in `Rf = Localization.Away f`, the
  un-localised module complex `D•(s, M)` is `Function.Exact` in positive degrees — **without** assuming
  `Ideal.span (range s) = ⊤` over `R`.
- **Proof (sketch, ~2–3 sentences):** Instantiate the polymorphic `dDiff_exact` (lem:section_cech_module_exact)
  over the ring `Rf` with module `Mf = LocalizedModule (powers f) M` and family `s/1` — hypothesis (b)
  supplies its spanning datum. Transport positive-degree exactness back to the `R`-side along the
  degreewise `R`-linear isomorphisms `M_{sσ} ≅ (M_f)_{sσ}` (the composite-localisation iso from
  `lem:isLocalizedModule_comp_away`, via `IsLocalizedModule.iso`) using
  `Function.Exact.of_ladder_addEquiv_of_exact`; per-coface naturality is `IsLocalizedModule.ext`.
- `\uses{lem:section_cech_module_exact, lem:isLocalizedModule_comp_away}`.

### 1c. Expand `lem:affine_cech_vanishing_tilde_subcover` proof block
The current proof sketch treats the change-of-ring as a one-line reuse of `dDiff_exact`. Replace it with:
"Derive (a) each `sᵢ ∈ √(f)` from `D(sᵢ) ⊆ D(f)` (via `basicOpen_le_basicOpen_iff`) and (b) the
`Rf`-spanning condition from `hcov` (the cover of `D(f)` becomes a cover of all `Spec Rf` since `f/1` is
a unit). Then `dDiff_exact_of_localizationAway` (lem:section_cech_module_exact_of_localizationAway)
supplies positive-degree exactness of the module complex; the tilde-bridge ladder
(`sectionToModuleAddEquiv`, `sectionCechCofaceMatch`, identical to `lem:section_cech_homology_exact`)
and `sectionCech_isZero_homology_of_objD_exact` wrap it as vanishing section-Čech homology."
- Update the proof `\uses{}` to include `lem:section_cech_module_exact_of_localizationAway` and
  `lem:isLocalizedModule_comp_away`.
- The private `sectionCechAbExact_loc` is bundled into this block's `\lean{}` (append it to the
  `\lean{...}` list so it is not an unmatched node).

### 1d. Fix `lem:away_comparison_isLocalizedModule` hint precision
The lean-vs-blueprint checker found this block's `\lean{}` pins `comparison_isLocalizedModule` but the
Lean section docstring says this label is meant to cover `isLocalizedModule_comp_away` — the two are
distinct (one is `M_a → M_{ab}` localisation; the other is the two-step base-change composite). Keep the
existing `comparison_isLocalizedModule` block as-is, and ensure the NEW `lem:isLocalizedModule_comp_away`
block (1a) is the home for the composite lemma so the route-B proof's `\uses` resolve correctly.

---

## Part 2 — Object-layer blocks (CechHigherDirectImage.lean) + split

The augmented-complex OBJECT layer was built axiom-clean in iter-051. Add a definition subsection
"Object layer for the augmented Čech complex" (place it between the `relativeCechComplexOfNerve` block
and `lem:cech_augmented_resolution`). All are Archon-original (no external source). Add a `def`/`lemma`
block for each, with one-line informal content and accurate `\uses`:

- `def:cech_complex_on_X` — `\lean{AlgebraicGeometry.cechComplexOnX}` — the un-augmented Čech cochain
  complex `C⁰→C¹→⋯` on `X` (the `alternatingCofaceMapComplex` of `Augmented.drop` of the Čech nerve);
  `\uses` the nerve `def:cech_nerve` / `relativeCechComplexOfNerve` block.
- `def:cech_nerve_point_iso` — `\lean{AlgebraicGeometry.cechNervePointIso}` — the iso
  `(CechNerve 𝒰 F).left ≅ F` (augmentation point `(𝟙X)_*(𝟙X)^*F ≅ F` via the pushforward/pullback
  unitors).
- `def:cech_augmentation` — `\lean{AlgebraicGeometry.cechAugmentation}` — the augmentation map
  `ε : F ⟶ C⁰`, built from `cechNervePointIso` and the nerve's augmentation NatTrans;
  `\uses{def:cech_nerve_point_iso, def:cech_complex_on_X}`.
- `lem:cech_augmentation_comp_d` — `\lean{AlgebraicGeometry.cechAugmentation_comp_d}` — `ε ≫ d⁰ = 0`;
  proved from the abstract augmented-cosimplicial identity (cosimplicial naturality, alternating sum
  `δ⁰−δ¹`). Bundle the private helper `augmentation_comp_alternatingCofaceMap_objD_zero` into this
  block's `\lean{...}` list. `\uses{def:cech_augmentation}`.
- `def:cech_augmented_complex` — `\lean{AlgebraicGeometry.cechAugmentedComplex}` — the augmented complex
  `0→F→C⁰→C¹→⋯` (`CochainComplex.augment`); `\uses{def:cech_complex_on_X, def:cech_augmentation,
  lem:cech_augmentation_comp_d}`. **This is the OBJECT that `lem:cech_augmented_resolution` is about.**

Then make `lem:cech_augmented_resolution` (`\lean{AlgebraicGeometry.cechAugmented_exact}`) depend on
`def:cech_augmented_complex` in its statement `\uses{}`, and note in its statement prose that the object
layer is built and only the exactness (acyclicity) remains.

---

## Part 3 — REWRITE the `lem:cech_augmented_resolution` PROOF sketch to the sections/sheafification route

**This is the most important part.** The current proof block (around lines 7029–7066) sketches a
stalk-at-prime argument. That route requires a `SheafOfModules.stalk` functor and an "exact iff stalkwise
exact" criterion that are BOTH absent from Mathlib. Replace the proof body with the following route
(keep the existing `% SOURCE QUOTE PROOF:` Stacks quote — it justifies "the augmented Čech complex is a
resolution"; the route below is the project's formalization strategy for it):

**Route: sections / sheafification (no stalk functor).** Exactness of `cechAugmentedComplex` in
`X.Modules` is proved by showing each homology object `Hᵖ` (`p ≥ 1`, plus the augmentation node) is zero,
via:
1. **Reflect through the faithful `toSheaf`.** `IsZero (Hᵖ in X.Modules)` follows from `IsZero` of its
   image under `SheafOfModules.toSheaf` (to abelian sheaves), because `toSheaf` is faithful and additive:
   `CategoryTheory.Functor.reflects_exact_of_faithful` needs only `[Faithful]` + `[PreservesZeroMorphisms]`,
   both Mathlib instances on `toSheaf` (no `PreservesFiniteColimits` needed).
2. **Homology sheaf = sheafification of the presheaf homology.** By `PresheafOfModules.homologyIsoSheafify`
   (project, `HigherDirectImagePresheaf.lean`), the degree-`p` homology of the sheaf complex is the
   sheafification of the degree-`p` homology of the underlying PRESHEAF complex. The presheaf homology at
   an open `V` is the homology of the section complex `C•(V)` (= the Čech cochain complex of `F` over the
   cover restricted to `V`).
3. **The presheaf homology is locally zero on the affine basis.** This presheaf is nonzero in general (it
   is `V ↦ Ȟᵖ(V,·)`), but it VANISHES locally: over any basic affine `D(g)` small enough to sit inside a
   cover element, the section-Čech complex of `~M` is exact in positive degrees — exactly
   `sectionCech_affine_vanishing` / `sectionCech_homology_exact_of_localizationAway` (P3). Hence the map
   `0 → (presheaf homology)` is a local isomorphism (`J.W`, a `LocallyBijective` W-equivalence), so its
   sheafification is an iso: `sheafify(presheaf homology) ≅ 0`. (Mathlib: `Sheaf.isLocallyBijective_iff_isIso`,
   `Presheaf.isLocallySurjective_presheafToSheaf_map_iff`, `GrothendieckTopology.WEqualsLocallyBijective`
   for `AddCommGrp`; the cofinal affine basis is `standard_cover_cofinal` / `affineCoverSystem`.)
4. **Augmentation node (degree 0).** Separately, `ε : F → C⁰` is the kernel inclusion: `H⁰` of the
   augmented complex is zero because over each affine the augmented section complex is exact at degree 0
   (`exact_of_isLocalized_span`, complementing the degree ≥1 vanishing).

Make the proof `\uses{}` cite: `def:cech_augmented_complex`, `lem:section_cech_homology_exact` (or the
P3 section-vanishing label), `lem:affine_cech_vanishing_tilde_subcover`, the `homologyIsoSheafify`
block label (find it in `Cohomology_HigherDirectImagePresheaf.tex`), and the qcoh-tilde iso
`lem:qcoh_isIso_fromTildeGamma` (for `F|_U ≅ ~M` on affines). Add a one-line remark that the stalk-at-prime
route was rejected because Mathlib lacks a `SheafOfModules` stalk functor and an exact-iff-stalkwise
criterion; and that a fallback (local "insert index i" contracting homotopy over each `Uᵢ` +
restriction-exactness + sheaf-local-vanishing) exists if the sections route's mapHomology-vs-section
plumbing stalls.

---

## Out of scope
- Do not touch `lem:cech_computes_cohomology` (the protected P5b target) beyond what already exists.
- Do not add `\leanok`. Do not invent external sources for the Archon-original blocks.
- Keep each block's prose textbook-level and math-only (no Lean tactic strings).
