# Lean ↔ Blueprint Check Report

## Slug
fbcglobal-iter034

## Iteration
034

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/FlatBaseChangeGlobal.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`

---

## Per-declaration

The blueprint chapter covers both `FlatBaseChange.lean` and `FlatBaseChangeGlobal.lean`
(header: `% archon:covers ... FlatBaseChangeGlobal.lean`). The relevant `\lean{}`-pinned
blocks for the declarations in this file are in the "Flat base change for the pushforward"
section and the "A-linear equalizer presentation (FBC-B build-ahead)" subsection.

### `\lean{AlgebraicGeometry.Scheme.exists_finite_affineCover_inter_isQuasiCompact}` (`lem:finite_affine_cover_qcqs`)
- **Lean target exists**: yes
- **Signature matches**: yes. Blueprint: quasi-compact + quasi-separated scheme → finite affine cover with quasi-compact pairwise intersections. Lean: `[CompactSpace X] [QuasiSeparatedSpace X]` → `∃ s : Set X.affineOpens, s.Finite ∧ ⊔ᵢ∈ s (i : X.Opens) = ⊤ ∧ ∀ U ∈ s, ∀ V ∈ s, IsCompact (U ∩ V)`. Typeclasses and existential are correct translations.
- **Proof follows sketch**: yes. Blueprint: affine opens form basis, quasi-compactness extracts finite subcover, quasi-separatedness gives quasi-compact intersections. Lean routes through `isCompact_iff_finite_and_eq_biUnion_affineOpens` (finite subcover) and `quasiSeparatedSpace_iff_forall_affineOpens` (compact overlaps). Mathematical content matches.
- **notes**: None.

### `\lean{AlgebraicGeometry.Modules.gammaIsLimitSheafConditionFork}` (`lem:gamma_finite_equalizer`)
- **Lean target exists**: yes
- **Signature matches**: partial. Blueprint prose says "for a finite affine cover of a quasi-compact quasi-separated scheme". Lean declaration is strictly more general: takes ANY open family `U : ι → X.Opens` over ANY scheme with no QCQS/finite/affine hypotheses, returning `IsLimit (fork M.presheaf U)`. The blueprint itself notes this gap in a `% NOTE` at line 3289–3293.
- **Proof follows sketch**: yes. The body `((isSheaf_iff_isSheafEqualizerProducts M.presheaf).mp M.isSheaf U).some` is exactly the application of `isSheaf_iff_isSheafEqualizerProducts` the blueprint description invokes.
- **notes**: More-general-than-prose is acceptable; the NOTE in the chapter acknowledges it. Not a problem.

### `\lean{AlgebraicGeometry.Modules.exists_finite_affineCover_isLimit_sheafConditionFork}` (`lem:gamma_finite_equalizer_cover`)
- **Lean target exists**: yes
- **Signature matches**: yes. Blueprint: "there exists a finite affine open cover whose sheaf-condition fork is a limit." Lean: `∃ (ι : Type u) (_ : Finite ι) (U : ι → X.Opens), (∀ i, IsAffineOpen (U i)) ∧ (⨆ i, U i = ⊤) ∧ (∀ i j, IsCompact ((U i : Set X) ∩ (U j : Set X))) ∧ Nonempty (IsLimit (fork M.presheaf U))`. Matches.
- **Proof follows sketch**: yes. Blueprint: combine `finite_affine_cover_qcqs` with `gamma_finite_equalizer`. Lean: `obtain ⟨s, hs, hcov, hqc⟩ := X.exists_finite_affineCover_inter_isQuasiCompact; ... ⟨Modules.gammaIsLimitSheafConditionFork M _⟩`. Correct.
- **notes**: None.

### `\lean{AlgebraicGeometry.Modules.gammaCoverRestrictScalars}` (`lem:gamma_amodule_restriction`)
- **Lean target exists**: **no**. This declaration is absent from `FlatBaseChangeGlobal.lean`. The Lean file instead implements the A-module structure on sections via the `groundRing`/`rhoU`/`gammaModA` infrastructure, not through a declaration named `gammaCoverRestrictScalars`.
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: **Must update blueprint pin.** The planned declaration name does not exist. See "Blueprint adequacy" section below.

### `\lean{AlgebraicGeometry.Modules.gammaCoverResMapsALinear}` (`lem:gamma_alinear_res_maps`)
- **Lean target exists**: **no**. Absent from `FlatBaseChangeGlobal.lean`. The A-linear restriction maps exist in the file as `leftRes` and `rightRes`, but under different names and with a different design (project-local `LinearMap` over `groundRing X`, not a statement that Mathlib's `SheafConditionEqualizerProducts.leftRes`/`rightRes` are A-linear).
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: **Must update blueprint pin.** Blueprint says "the maps `SheafConditionEqualizerProducts.leftRes/rightRes` are A-linear." The Lean instead defines its own A-linear `leftRes`/`rightRes`; Mathlib's maps are not mentioned. Architectural divergence.

### `\lean{AlgebraicGeometry.Modules.gammaEqLocusIso}` (`lem:gamma_eqLocus_iso`)
- **Lean target exists**: **no**. Absent from `FlatBaseChangeGlobal.lean`. The corresponding result is `gammaTopEquivEqLocus`, but under a different name.
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: **Must update blueprint pin.** The closest Lean declaration is `gammaTopEquivEqLocus` (a `LinearEquiv` over `groundRing X`). The blueprint planned `gammaEqLocusIso` consuming `gammaCoverRestrictScalars`/`gammaCoverResMapsALinear`, but the Lean instead used the custom `groundRing`/`gammaResA`/`leftRes`/`rightRes` infrastructure.

### `\lean{AlgebraicGeometry.baseChange_sheafConditionFork_tensorIso}` (`lem:base_changed_equalizer_diagram`)
- **Lean target exists**: **no**. Absent from `FlatBaseChangeGlobal.lean`. The corresponding result `baseChangeGammaEquiv` does not bear this name and has a different signature (it is a `LinearEquiv` rather than a natural isomorphism of the whole fork diagram).
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Blueprint pins a declaration about base-changing the entire sheaf-condition fork diagram; the Lean instead proved `baseChangeGammaEquiv` which directly gives the module-level equivalence `B ⊗_A Γ(M, ⊤) ≃ₗ[B] eqLocus(B ⊗ leftRes, B ⊗ rightRes)`. Both establish the same mathematical content via different packaging.

---

## Red flags

None found.

### Placeholder / suspect bodies
None. Every declaration in the file has a substantive proof/definition body:
- `gammaIsLimitSheafConditionFork`: unwraps `isSheaf_iff_isSheafEqualizerProducts`.
- `gammaTopEquivEqLocus`: uses `LinearEquiv.ofBijective` with injectivity from `TopCat.Sheaf.eq_of_locally_eq'` and surjectivity from `TopCat.Sheaf.existsUnique_gluing'`.
- `baseChangeGammaEquiv`: composites `gammaTopEquivEqLocus` with `LinearMap.tensorEqLocusEquiv`.
- All helper lemmas have complete proofs.

### Excuse-comments
None. Comments in the file are docstrings explaining the mathematical content; none excuse wrong or incomplete code.

### Axioms / Classical.choice on non-trivial claims
None. The `axiom` in the grep output is from a docstring ("`TopCat.Sheaf.existsUnique_gluing'`"), not a Lean `axiom` declaration.

---

## Unreferenced declarations (informational)

The following 15 declarations in `FlatBaseChangeGlobal.lean` have **no** `\lean{}` reference in the blueprint. They fall into two groups:

**Infrastructure helpers** (acceptable as private/auxiliary, but substantive enough that their absence from the blueprint leaves the prover without guidance):
- `groundRing` (abbrev, line 103): `A = Γ(X, ⊤)` as `CommRing`.
- `rhoU` (def, line 107): structure-sheaf restriction `A → Γ(X, U)` as a ring hom.
- `gammaModA` (abbrev, line 114): `Γ(M, U)` as an `A`-module via `restrictScalars`.
- `rhoU_comp` (theorem, line 120): transitivity of the `A`-algebra structures.
- `gammaResAHom` (def, line 132): structure-sheaf restriction as `A`-module morphism.
- `gammaResA` (def, line 141): same, as an `A`-linear map.
- `gammaResA_apply` (simp theorem, line 144): computation rule for `gammaResA`.
- `gammaResA_comp` (theorem, line 151): functoriality of `gammaResA`.
- `leftRes` (def, line 163): A-linear left restriction leg `∏_i Γ(M, U_i) → ∏_{p} Γ(M, U_{p.1} ⊓ U_{p.2})`.
- `rightRes` (def, line 169): A-linear right restriction leg.
- `toCover` (def, line 174): A-linear `Γ(M, ⊤) → ∏_i Γ(M, U_i)`.
- `leftRes_toCover` (theorem, line 181): global sections land in the `eqLocus`.
- `toCoverEqLocus` (def, line 189): `toCover` corestricted to `eqLocus`.

**Substantive declarations** (should have blueprint blocks):
- `gammaTopEquivEqLocus` (def, line 203): the A-linear iso `Γ(M, ⊤) ≃ₗ[A] eqLocus(leftRes, rightRes)`. This is the mathematical content of the planned `lem:gamma_eqLocus_iso` block, but under a different name and richer infrastructure.
- `baseChangeGammaEquiv` (def, line 241): the key FBC-B payoff — `B ⊗_A Γ(M, ⊤) ≃ₗ[B] eqLocus(B ⊗ leftRes, B ⊗ rightRes)`. This declaration has no blueprint block at all. It composites `gammaTopEquivEqLocus` with `LinearMap.tensorEqLocusEquiv` and represents the completed module-level FBC-B result.

---

## Blueprint adequacy for this file

### Coverage
- 3 / 3 blueprint-pinned declarations that exist in the Lean file are properly verified.
- 4 blueprint-pinned declarations (`gammaCoverRestrictScalars`, `gammaCoverResMapsALinear`, `gammaEqLocusIso`, `baseChange_sheafConditionFork_tensorIso`) do NOT exist in the Lean file — the file implemented a different architecture.
- 15 Lean declarations have no `\lean{}` reference in the blueprint.

### Proof-sketch depth
**Under-specified for the new infrastructure.** The FBC-B build-ahead subsection (line 3353–3484) is the blueprint prose covering what `FlatBaseChangeGlobal.lean` was meant to implement, but:
1. It does not mention `groundRing`, `rhoU`, `gammaModA`, `gammaResA` at all — these are the load-bearing A-module structure layer the Lean needed to write.
2. It describes `leftRes`/`rightRes` as the Mathlib `SheafConditionEqualizerProducts` maps made A-linear, but the Lean needed to define new A-linear maps directly (different objects altogether).
3. `gammaTopEquivEqLocus` has no proof sketch in the blueprint — the prover had to derive the `LinearEquiv.ofBijective` approach using `eq_of_locally_eq'` and `existsUnique_gluing'` independently (confirmed by memory entry `fbcb-modulecat-over-a-eqlocus-techniques`).
4. `baseChangeGammaEquiv` has no blueprint block whatsoever.

### Hint precision
**Wrong** for three blocks: `\lean{Modules.gammaCoverRestrictScalars}`, `\lean{Modules.gammaCoverResMapsALinear}`, `\lean{Modules.gammaEqLocusIso}`. All three `\lean{}` pins name declarations that do not exist. The closest actual declarations are `gammaModA` (for restrict-scalars packaging), `leftRes`/`rightRes` (for A-linear maps), and `gammaTopEquivEqLocus` (for the eqLocus iso).

### Generality
**Too narrow / misaligned** for `lem:base_changed_equalizer_diagram`. The blueprint plans a result about base-changing the entire fork diagram (`baseChange_sheafConditionFork_tensorIso`), while the Lean implemented a module-level equivalence (`baseChangeGammaEquiv`) that is the ultimate consumer. The planned diagram result is not needed once `baseChangeGammaEquiv` is available directly.

### Recommended chapter-side actions
1. **Update `\lean{}` pins** in `lem:gamma_amodule_restriction`, `lem:gamma_alinear_res_maps`, `lem:gamma_eqLocus_iso`, `lem:base_changed_equalizer_diagram` to reflect actual Lean declaration names.
2. **Add a new blueprint block for `gammaTopEquivEqLocus`** (the A-linear iso `Γ(M, ⊤) ≃ₗ[A] eqLocus(leftRes, rightRes)`) — this is the key intermediate result between the sheaf condition and the FBC-B payoff.
3. **Add a new blueprint block for `baseChangeGammaEquiv`** — this is the completed module-level flat-base-change result for the `H⁰` case and the FBC-B payoff.
4. **Add a prose section describing the `groundRing`/`rhoU`/`gammaModA`/`gammaResA` infrastructure** (or at minimum acknowledge that the Lean builds a custom A-module layer rather than using `SheafConditionEqualizerProducts` directly). The current blueprint prose would not have guided a prover to this architecture.
5. **Update `lem:gamma_alinear_res_maps`** to note that the Lean defines its own A-linear `leftRes`/`rightRes` (as `LinearMap` values over `groundRing X`) rather than showing Mathlib's `SheafConditionEqualizerProducts.leftRes/rightRes` are A-linear.

---

## Severity summary

- **must-fix-this-iter**: None. No placeholder bodies, no sorries, no axioms, no wrong signatures for existing blueprint-pinned declarations.

- **major** (3 items):
  1. `\lean{Modules.gammaCoverRestrictScalars}` (`lem:gamma_amodule_restriction`): declaration does not exist; blueprint pin is broken.
  2. `\lean{Modules.gammaCoverResMapsALinear}` (`lem:gamma_alinear_res_maps`): declaration does not exist; blueprint pin is broken.
  3. `\lean{Modules.gammaEqLocusIso}` (`lem:gamma_eqLocus_iso`): declaration does not exist; `gammaTopEquivEqLocus` is the closest match but under a different name and architecture.

- **minor** (2 items):
  1. `baseChangeGammaEquiv` is a substantive FBC-B payoff declaration with no blueprint block.
  2. The 13 infrastructure helpers (`groundRing`, `rhoU`, `gammaModA`, etc.) collectively constitute a custom A-module layer the blueprint does not describe; each is individually minor, but together they represent a significant prover-invented infrastructure gap.

**Overall verdict**: The Lean file is axiom-clean with no placeholder bodies and three properly-verified blueprint-pinned declarations, but the FBC-B build-ahead subsection's three planned declaration names (`gammaCoverRestrictScalars`, `gammaCoverResMapsALinear`, `gammaEqLocusIso`) do not exist — the Lean instead built a richer `groundRing`/`rhoU`/`gammaModA`/`gammaTopEquivEqLocus`/`baseChangeGammaEquiv` architecture that the blueprint did not anticipate; **3 blueprint pins need updating (major) and 2 substantive declarations need new blueprint blocks (minor)**.
