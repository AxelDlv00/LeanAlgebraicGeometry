# Lean ↔ Blueprint Check Report

## Slug
cechacyclic

## Iteration
057

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/CechAcyclic.lean` (2215 lines)
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (relevant blocks: `lem:affine_cech_vanishing_general_seed` at line 8763,
  `lem:affine_cech_vanishing_tilde_subcover` at line 6256, and the route-B1 section)

---

## Per-declaration (blueprint `\lean{}` targets only)

### `\lean{AlgebraicGeometry.sectionCech_homology_exact_of_affineOpen}` (`lem:affine_cech_vanishing_general_seed`, line 8764)

- **Lean target exists**: yes — `theorem sectionCech_homology_exact_of_affineOpen` at lines 2162–2212
- **Signature matches**: yes
  - Blueprint: "R ring, M module, g : {1..n} → R, V = ⋃_i D(g_i) affine open, p > 0 → IsZero(ȞHˢᵖ = 0)"
  - Lean: `{R : CommRingCat.{u}} (M : ModuleCat.{u} R) {ι : Type u} [Finite ι] (s : ι → R) (hV : IsAffineOpen (X := Spec R) (⨆ i, PrimeSpectrum.basicOpen (s i))) (p : ℕ) (hp : 1 ≤ p) : IsZero ((sectionCechComplex …).homology p)` — exact match.
- **Proof follows sketch**: partial
  - The blueprint proof (lines 8802–8840) says: *"Scheme.isoSpec (Lemma~lem:isoSpec_scheme_mathlib) gives a scheme isomorphism V ≅ Spec S under which each D(g_i) ⊆ V corresponds to the distinguished open D_S(ḡ_i)"*, then identification of the two section complexes via base-change comparisons.
  - The Lean proof does NOT use `Scheme.isoSpec` at all. It works entirely algebraically: (a) proves `hspan` via `hV.iSup_basicOpen_eq_self_iff` + `basicOpen_algMap_section`, (b) proves `hloc` via `IsAffineOpen.isLocalization_of_eq_basicOpen` + `IsLocalization.algEquiv`, then calls `sectionCech_homology_exact_of_affineCover` with `S := Γ(V)`.
  - The mathematical content is the same (both establish that `M ⊗_R S` and `M` have the same localisations at each multi-index). This is a **route substitution** (algebraic vs. scheme-theoretic), not a mathematical error.
  - The blueprint `\uses` block lists `lem:isoSpec_scheme_mathlib` as a dependency; that lemma is not used in the Lean proof. The `\uses` is inaccurate.
- **notes**: The Lean proof is cleaner (avoids the `isoSpec`-mediated category equivalence) but the blueprint must be updated to remove the false `lem:isoSpec_scheme_mathlib` dependency and add the actual route: `isLocalizedModule_baseChange_away` + `IsAffineOpen.isLocalization_of_eq_basicOpen`.

---

## New declarations this iter with no `\lean{}` pin

### `AlgebraicGeometry.isLocalizedModule_baseChange_away` (lines 977–995, public theorem)

- Not referenced by any `\lean{...}` block in the chapter.
- Statement: "given `IsBaseChange S bc`, `IsLocalizedModule (powers (algebraMap R S a)) gN`, and `IsLocalization (powers a) Aloc` at both the S-level and R-level, the R-linear composite `gN ∘ bc : M → N` is `IsLocalizedModule (powers a)`."
- This is the route-B1 replacement for `AwayComparison.isLocalizedModule_comp_away` (which IS pinned at `lem:isLocalizedModule_comp_away`). The blueprint's proof narrative alludes to it as "transitivity of base change for localised modules" (line 8830) but names no Lean lemma.
- Substantive infrastructure; should receive a `\lean{}` pin at a new `lem:isLocalizedModule_baseChange_away` blueprint block, mirroring `lem:isLocalizedModule_comp_away`.

### `AlgebraicGeometry.SectionCechModule.dDiff_exact_of_affineCover` (lines 1382–1480, public lemma)

- Not referenced by any `\lean{...}` block in the chapter.
- Statement: "for `s : ι → R` whose images in `S = Γ(V)` span the unit ideal and with per-σ localisation data `hloc`, the un-localised section Čech module complex `D•(s,M)` is exact in positive degrees."
- Direct route-B1 analogue of `SectionCechModule.dDiff_exact_of_localizationAway` (which IS pinned at `lem:section_cech_module_exact_of_localizationAway`). The asymmetry is notable: the route-B infrastructure is fully enumerated in the chapter; the route-B1 counterpart is not.
- Should be pinned at a new blueprint block `lem:section_cech_module_exact_of_affineCover`.

### `AlgebraicGeometry.sectionCech_homology_exact_of_affineCover` (lines 2103–2115, public theorem)

- Not referenced by any `\lean{...}` block in the chapter.
- Statement: "given `S, hspan, hloc`, the positive-degree section Čech homology of `~M` over `{D(s_i)}` vanishes."
- Intermediate wrapper between `dDiff_exact_of_affineCover` and `sectionCech_homology_exact_of_affineOpen`; analogue of `sectionCech_homology_exact_of_localizationAway` (pinned at `lem:affine_cech_vanishing_tilde_subcover`).
- Should be added to the `\lean{}` list of `lem:affine_cech_vanishing_general_seed` (or a separate `lem:affine_cech_vanishing_tilde_subcover_general` block), mirroring the way `sectionCechAbExact_loc` is listed alongside `sectionCech_homology_exact_of_localizationAway`.

### `AlgebraicGeometry.sectionCechAbExact_affine` (lines 1993–2021, **private**)

- Private lemma — no `\lean{}` pin expected. Routes ladder transport for the route-B1 `dDiff_exact_of_affineCover` back through the tilde-bridge.
- Informational only.

### `AlgebraicGeometry.basicOpen_algMap_section` (lines 2140–2148, **private**)

- Private geometric brick: `(Spec R).basicOpen (algebraMap R Γ(V) a) = V ⊓ D(a)`.
- No `\lean{}` pin expected. Project-local helper behind `hspan` in `sectionCech_homology_exact_of_affineOpen`.

---

## Red flags

None on the six new declarations.

### Placeholder / suspect bodies
None. All six new declarations have complete, sorry-free proof bodies. Confirmed by `grep -n "sorry"` — the only `sorry` in the file is line 110 in the pre-existing `CechAcyclic.affine` stub, which is explicitly out of scope for this iteration (the header comment calls it "the P3 prover lane" with the `sorry` at line 110).

### Excuse-comments
None on the six new declarations. The long comments on `CechAcyclic.affine` (lines 83–109) are strategic notes for the future P3 prover, not excuses for wrong code.

### Axioms / Classical.choice on non-trivial claims
None introduced this iteration. `Classical.choose` is used at line 1205 for `spanIdx` (a private definitional helper, expected and benign).

---

## Unreferenced declarations (informational)

The following public declarations in the file have no `\lean{...}` blueprint reference:

| Declaration | Kind | Comment |
|---|---|---|
| `isLocalizedModule_baseChange_away` | public theorem | route-B1 infrastructure; see above |
| `SectionCechModule.dDiff_exact_of_affineCover` | public lemma | route-B1 infrastructure; see above |
| `sectionCech_homology_exact_of_affineCover` | public theorem | route-B1 intermediate; see above |
| `AwayComparison.isLocalizedModule_comp_away` | public lemma | previously added; pinned at `lem:isLocalizedModule_comp_away` ✓ |
| `SectionCechModule.dDiff_exact` | public lemma | pinned at `lem:section_cech_module_exact` ✓ |

The first three are the actionable gaps; the rest are already covered.

---

## Blueprint adequacy for this file

- **Coverage**: 1 / 3 new public substantive declarations have a `\lean{}` blueprint pin (`sectionCech_homology_exact_of_affineOpen`). The other two — `isLocalizedModule_baseChange_away` and `dDiff_exact_of_affineCover` — are unmentioned by name. The route-B infrastructure (`isLocalizedModule_comp_away`, `dDiff_exact_of_localizationAway`, `sectionCechAbExact_loc`) is fully enumerated; the parallel route-B1 layer is not. 2 substantive declarations are unaccounted for.

- **Proof-sketch depth**: under-specified in two places.
  1. The blueprint proof of `lem:affine_cech_vanishing_general_seed` (lines 8802–8840) describes the proof via `Scheme.isoSpec` ("V ≅ Spec S … each D(g_i) corresponds to the distinguished open D_S(ḡ_i)"). The Lean proof bypasses `isoSpec` entirely and works algebraically via `IsBaseChange` + `IsAffineOpen.isLocalization_of_eq_basicOpen`. The two are mathematically equivalent, but a prover following the blueprint sketch would be led toward the scheme-theoretic path, which is substantially harder to mechanize.
  2. The `Algebra Γ(V) Γ(D a)` instance trap: this algebra instance is NOT synthesizable (it depends on the inclusion `D a → V`). The Lean proof (lines 2193–2198) must provide it explicitly as `((Spec R).presheaf.map (homOfLE hDaV).op).hom.toAlgebra`. The blueprint says "transported across the R-algebra iso Γ(D(s_σ)) ≃ₐ[R] Localization(powers(s̄_σ))" with no mention of the synthesizability issue. A prover encountering this for the first time would be blocked.

- **Hint precision**: loose for the route-B1 path. "Transitivity of base change for localised modules" (line 8830) is named in prose but not linked to a Lean lemma name. The analogous route-B "two-step away localisation localises at the product factor" is pinned precisely (`lem:isLocalizedModule_comp_away` → `AwayComparison.isLocalizedModule_comp_away`).

- **Generality**: The chapter's route-B1 proof sketch is technically at the right level of generality, but the asymmetric `\lean{}` coverage between route-B and route-B1 leaves the route-B1 infrastructure under-documented.

- **Recommended chapter-side actions**:
  1. **Add `lem:isLocalizedModule_baseChange_away`** block pinning `AlgebraicGeometry.isLocalizedModule_baseChange_away`, parallel to `lem:isLocalizedModule_comp_away`. Proof sketch: "`IsBaseChange S bc` is transitive (`IsBaseChange.comp`), and `isLocalizedModule_iff_isBaseChange` converts both directions."
  2. **Add `lem:section_cech_module_exact_of_affineCover`** block pinning `AlgebraicGeometry.SectionCechModule.dDiff_exact_of_affineCover`, parallel to `lem:section_cech_module_exact_of_localizationAway`. The proof sketch is the same ladder transport, with `isLocalizedModule_baseChange_away` in place of `isLocalizedModule_comp_away`.
  3. **Update `lem:affine_cech_vanishing_general_seed`**: (a) replace `isoSpec`-based proof description with the algebraic route, (b) remove `lem:isoSpec_scheme_mathlib` from `\uses`, (c) add `lem:isLocalizedModule_baseChange_away` and `lem:isLocalization_of_eq_basicOpen` to `\uses`, (d) add `sectionCech_homology_exact_of_affineCover` to the `\lean{...}` list, parallel to how `sectionCechAbExact_loc` is listed alongside `sectionCech_homology_exact_of_localizationAway` at `lem:affine_cech_vanishing_tilde_subcover`.
  4. **Add a `% NOTE:`** on the `Algebra Γ(V) Γ(D a)` synthesizability issue (explicit `.toAlgebra` from the restriction map, plus `IsScalarTower.of_algebraMap_eq`).

---

## Severity summary

- **must-fix-this-iter**: None. All six new declarations are axiom-clean, sorry-free, excuse-free, with correct signatures.

- **major**: Three public substantive declarations (`isLocalizedModule_baseChange_away`, `SectionCechModule.dDiff_exact_of_affineCover`, `sectionCech_homology_exact_of_affineCover`) have no `\lean{}` blueprint reference. These are direct route-B1 analogues of route-B declarations that ARE individually pinned, so the asymmetry is a documentation gap that will accumulate if left unaddressed. A blueprint-writing pass should add the three missing blocks (items 1–3 of recommended actions above).

- **minor** (×2):
  - The blueprint `\uses` for `lem:affine_cech_vanishing_general_seed` lists `lem:isoSpec_scheme_mathlib` as a dependency; the Lean proof does not use `isoSpec`. The `\uses` should be corrected.
  - The blueprint proof sketch omits the `Algebra Γ(V) Γ(D a)` non-synthesizability trap. Worth a `% NOTE:` to guide future maintainers.

**Overall verdict**: The six new declarations are mathematically correct, axiom-clean, and the top-level target `sectionCech_homology_exact_of_affineOpen` faithfully implements `lem:affine_cech_vanishing_general_seed` — the only blueprint `\lean{}`-pinned target this iteration. The chapter has major documentation asymmetry between the now-complete route-B1 infrastructure and the fully-enumerated route-B counterparts, and a minor inaccuracy in the `\uses` dependency list. No prover work is blocked.
