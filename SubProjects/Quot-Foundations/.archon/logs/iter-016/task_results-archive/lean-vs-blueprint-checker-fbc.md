# Lean ↔ Blueprint Check Report

## Slug
fbc

## Iteration
015

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.pushforwardBaseChangeMap}` (chapter: `def:pushforward_base_change_map`)
- **Lean target exists**: yes
- **Signature matches**: yes — `(comm : g' ≫ f = f' ≫ g) (F : X.Modules) : pullback g (pushforward f F) ⟶ pushforward f' (pullback g' F)` matches prose (adjoint mate of the `f_*(unit)` composite).
- **Proof follows sketch**: yes — built as `((pullbackPushforwardAdjunction g).homEquiv _ _).symm` applied to the unit-plus-pseudofunctor-coherence composite, exactly as described.
- **notes**: Fully proved, no sorry.

### `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_stalkFunctor_map}` (`lem:modules_isIso_iff_stalk`)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes — forward direction via `Functor.map_isIso`, reverse via `TopCat.Presheaf.isIso_of_stalkFunctor_map_iso`, then reflects through `Scheme.Modules.toPresheaf`.
- **notes**: Fully proved, no sorry.

### `\lean{AlgebraicGeometry.Modules.isIso_of_isIso_app_of_isBasis}` (`lem:modules_isIso_of_isBasis`)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes — reduces to stalkwise isomorphism via `lem:modules_isIso_iff_stalk`, then proves injectivity via `stalkFunctor_map_injective_of_isBasis` and surjectivity via `germ_exist_of_isBasis`.
- **notes**: Fully proved, no sorry.

### `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_app_affineOpens}` (`lem:modules_isIso_iff_affineOpens`)
- **Lean target exists**: yes
- **Signature matches**: yes — `IsIso φ ↔ ∀ U : X.affineOpens, IsIso (φ.app U)`.
- **Proof follows sketch**: yes — applies `Modules.isIso_of_isIso_app_of_isBasis` with `X.isBasis_affineOpens`.
- **notes**: Fully proved, no sorry.

### `\lean{AlgebraicGeometry.globalSectionsIso_hom_comp_specMap_appTop}` (`lem:globalSectionsIso_hom_comp_specMap_appTop`)
- **Lean target exists**: yes
- **Signature matches**: yes — ring equation `gsR.hom ≫ (Spec.map φ).appTop = φ ≫ gsR'.hom`.
- **Proof follows sketch**: yes — reduces to `Scheme.ΓSpecIso_inv_naturality`.
- **notes**: Fully proved, no sorry.

### `\lean{AlgebraicGeometry.gammaPushforwardIso}` (`lem:gammaPushforwardIso`)
- **Lean target exists**: yes
- **Signature matches**: yes — `moduleSpecΓFunctor (R := R) ((pushforward (Spec.map φ)) N) ≅ (restrictScalars φ.hom) (moduleSpecΓFunctor (R := R') N)`.
- **Proof follows sketch**: yes — element-free route via `restrictScalarsComp'App` × 2 and `globalSectionsIso_hom_comp_specMap_appTop`.
- **notes**: Fully proved, no sorry.

### `\lean{AlgebraicGeometry.gammaPushforwardTildeIso}` (`lem:gammaPushforwardTildeIso`)
- **Lean target exists**: yes
- **Signature matches**: yes — specialises `gammaPushforwardIso` to `N = tilde M`, composes with `tilde.toTildeΓNatIso`.
- **Proof follows sketch**: yes — one-line composition.
- **notes**: Fully proved, no sorry.

### `\lean{AlgebraicGeometry.gammaPushforwardIsoAt}` (`lem:gammaPushforwardIsoAt`)
- **Lean target exists**: yes
- **Signature matches**: yes — `Γ((Spec φ)_* N, U) ≅ restrictScalars φ (Γ(N, (Spec φ)⁻¹U))`.
- **Proof follows sketch**: yes — same construction as `gammaPushforwardIso` with arbitrary open replacing `⊤`.
- **notes**: Fully proved, no sorry.

### `\lean{AlgebraicGeometry.fromTildeΓ_app_isIso_of_isLocalizedModule}` (`lem:fromTildeGamma_app_isIso_of_localized`)
- **Lean target exists**: yes
- **Signature matches**: yes — `IsLocalizedModule (Submonoid.powers a) ρ → IsIso (N.fromTildeΓ.app (basicOpen a))`.
- **Proof follows sketch**: yes — triangle identity `L ∘ j = ρ`, uniqueness of localizations forces `L = e`, hence bijective.
- **notes**: Fully proved, no sorry.

### `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso_of_isLocalizedModule}` (`lem:pushforward_spec_tilde_iso_conditional`)
- **Lean target exists**: yes
- **Signature matches**: yes — conditional form with `hloc` hypothesis, yields `(Spec φ)_* (tilde M) ≅ tilde (restrictScalars φ M)`.
- **Proof follows sketch**: yes — applies `Modules.isIso_of_isIso_app_of_isBasis` over basic opens using `fromTildeΓ_app_isIso_of_isLocalizedModule`, then assembles the iso.
- **notes**: Fully proved, no sorry.

### `\lean{AlgebraicGeometry.IsLocalizedModule.powers_restrictScalars}` (`lem:powers_restrictScalars`)
- **Lean target exists**: yes
- **Signature matches**: yes — `IsLocalizedModule (algMap A S) f → IsLocalizedModule S (f.restrictScalars R)`.
- **Proof follows sketch**: yes — checks three `IsLocalizedModule` conditions by transporting along `algMap`.
- **notes**: Fully proved, no sorry.

### `\lean{AlgebraicGeometry.tildeRestriction_isLocalizedModule}` (`lem:tildeRestriction_isLocalizedModule`)
- **Lean target exists**: yes
- **Signature matches**: yes — `IsLocalizedModule (Submonoid.powers b) (Γ(tilde M, ⊤) → Γ(tilde M, D(b)))`.
- **Proof follows sketch**: yes — uses bijectivity of `toOpen ⊤` and triangle identity to transport from `toOpen (D b)`.
- **notes**: Fully proved, no sorry.

### `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso}` (`lem:pushforward_spec_tilde_iso`)
- **Lean target exists**: yes
- **Signature matches**: yes — `(Spec φ)_* (tilde M) ≅ tilde (restrictScalars φ M)`.
- **Proof follows sketch**: yes — discharges `hloc(a)` via `algebraize [φ.hom]`, `tildeRestriction_isLocalizedModule`, `powers_restrictScalars`, and `gammaPushforwardIsoAt`-naturality; then calls the conditional form.
- **notes**: Fully proved, no sorry.

### `\lean{AlgebraicGeometry.gammaPushforwardNatIso}` (`lem:gammaPushforwardNatIso`)
- **Lean target exists**: yes
- **Signature matches**: yes — natural iso `(Spec φ)_* ⋙ Γ_R ≅ Γ_{R'} ⋙ restrictScalars φ`.
- **Proof follows sketch**: yes — `NatIso.ofComponents` from `gammaPushforwardIso`, naturality by `ext; rfl`.
- **notes**: Fully proved, no sorry.

### `\lean{AlgebraicGeometry.pullback_spec_tilde_iso}` (`lem:pullback_spec_tilde_iso`)
- **Lean target exists**: yes
- **Signature matches**: yes — `(Spec φ)^* (tilde M) ≅ tilde (extendScalars φ M)`.
- **Proof follows sketch**: yes — uniqueness-of-left-adjoints via `conjugateIsoEquiv` using `gammaPushforwardNatIso`.
- **notes**: Fully proved, no sorry.

### `\lean{AlgebraicGeometry.pullbackSpecIso}` (`lem:pullbackSpecIso_mathlib`)
- **Lean target exists**: yes (Mathlib)
- **Signature matches**: yes — marked `\mathlibok`.
- **Proof follows sketch**: N/A (Mathlib)
- **notes**: Correct dependency anchor.

### `\lean{TensorProduct.AlgebraTensorModule.cancelBaseChange}` (`lem:cancelBaseChange_mathlib`)
- **Lean target exists**: yes (Mathlib)
- **Signature matches**: yes — marked `\mathlibok`.
- **Proof follows sketch**: N/A (Mathlib)
- **notes**: Correct dependency anchor.

### `\lean{Algebra.IsPushout.cancelBaseChange}` (`lem:isPushout_cancelBaseChange_mathlib`)
- **Lean target exists**: yes (Mathlib)
- **Signature matches**: yes — marked `\mathlibok`.
- **Proof follows sketch**: N/A (Mathlib)
- **notes**: Correct dependency anchor.

### `\lean{AlgebraicGeometry.pullback_fst_snd_specMap_tensor}` (`lem:pullback_fst_snd_specMap_tensor`)
- **Lean target exists**: yes
- **Signature matches**: yes — conjunction asserting both cone-leg identifications via `pullbackSpecIso.inv`.
- **Proof follows sketch**: yes — calls `pullbackSpecIso_inv_fst` and `pullbackSpecIso_inv_snd` directly.
- **notes**: Fully proved, no sorry.

### `\lean{AlgebraicGeometry.base_change_mate_domain_read}` (`lem:base_change_mate_domain_read`)
- **Lean target exists**: yes
- **Signature matches**: yes — `Γ_R'(g^*(f_*(tilde M))) ≅ extendScalars ψ (restrictScalars φ M)`.
- **Proof follows sketch**: yes — composes pushforward dictionary, pullback dictionary, and tilde–Γ unit.
- **notes**: Fully proved, no sorry.

### `\lean{AlgebraicGeometry.pullbackIsoEquivalenceOfIso}` (`lem:pullbackIsoEquivalenceOfIso`)
- **Lean target exists**: yes
- **Signature matches**: yes — produces `Y.Modules ≌ X.Modules` from `f : X ⟶ Y` with `[IsIso f]`.
- **Proof follows sketch**: yes — assembles unit/counit from `pullbackComp`, `pullbackCongr`, `pullbackId`.
- **notes**: Fully proved, no sorry.

### `\lean{AlgebraicGeometry.pullback_isEquivalence_of_iso}` (`lem:pullback_isEquivalence_of_iso`)
- **Lean target exists**: yes (`instance`)
- **Signature matches**: yes — `(pullback f).IsEquivalence` from `[IsIso f]`.
- **Proof follows sketch**: yes — one-line corollary.
- **notes**: Fully proved, no sorry.

### `\lean{AlgebraicGeometry.base_change_mate_codomain_read}` (`lem:base_change_mate_codomain_read`)
- **Lean target exists**: yes
- **Signature matches**: yes — `Γ_R'(f'_*(g')^*(tilde M)) ≅ restrictScalars includeRight (extendScalars includeLeft M)`.
- **Proof follows sketch**: yes — uses `pullback_fst_snd_specMap_tensor` to identify legs, then chains `pullbackCongr`, `pushforwardCongr`, the `pullbackSpecIso`-adjunction unit, and the two affine dictionaries.
- **notes**: Fully proved, no sorry.

### `\lean{AlgebraicGeometry.base_change_mate_regroupEquiv}` (`lem:base_change_mate_regroupEquiv`)
- **Lean target exists**: yes
- **Signature matches**: yes — `restrictScalars includeRight (extendScalars includeLeft M) ≅ extendScalars ψ (restrictScalars φ M)`.
- **Proof follows sketch**: yes — uses identity bridge `eT` for the A-action diamond, then `cancelBaseChange` (Mathlib) and `TensorProduct.comm`; the long `map_smul'` proof by `TensorProduct.induction_on` matches the blueprint's description of the A-action diamond resolution.
- **notes**: Fully proved, no sorry.

### `\lean{AlgebraicGeometry.base_change_mate_inner_value}` (`def:base_change_mate_inner_value`)
- **Lean target exists**: yes
- **Signature matches**: yes — `R`-linear map `restrictScalars φ M ⟶ restrictScalars ψ (restrictScalars inclR' (extendScalars inclA M))`.
- **Proof follows sketch**: yes — `restrictScalars φ` of the algebraic unit transported via `restrictScalarsComp'App` and `restrictScalarsCongr hring`.
- **notes**: Fully proved, no sorry.

### `\lean{AlgebraicGeometry.base_change_mate_unit_value}` (`lem:base_change_mate_unit_value`)
- **Lean target exists**: yes
- **Signature matches**: yes — equates the section-reading of the geometric adjunction unit with `(extendRestrictScalarsAdj inclA).unit.app M`.
- **Proof follows sketch**: yes — uses `conjugateIsoEquiv`, `unit_conjugateEquiv_symm`, `gammaPushforwardTildeIso` factorization.
- **notes**: Fully proved, no sorry. Proof required `set_option maxHeartbeats 4000000`.

### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex}` (`lem:base_change_mate_fstar_reindex`)
- **Lean target exists**: yes
- **Signature matches**: yes — LHS signature elaboration-checked, matches blueprint's LEAN SIGNATURE annotation exactly.
- **Proof follows sketch**: **no** — proof body has `sorry` at line 1197. A scaffold was added this iter (leg identification via `hfst`/`hsnd`, `Functor.map_comp` decomposition), but the core crux — transporting the `pullback.fst`-unit to the affine `Spec inclA`-unit via `conjugateEquiv_pullbackComp_inv` + `unit_conjugateEquiv` across the iso leg `e.hom` — is unresolved.
- **notes**: **must-fix-this-iter** — blueprint claims a substantive proof, body is `:= sorry`.

### `\lean{AlgebraicGeometry.base_change_mate_gstar_transpose}` (`lem:base_change_mate_gstar_transpose`)
- **Lean target exists**: yes
- **Signature matches**: yes — matches blueprint's LEAN SIGNATURE annotation.
- **Proof follows sketch**: **no** — proof body has `sorry` at line 1242. The counit factorization split (`rw [Functor.map_comp]`) is in place, but the pullback-dictionary coherence step — identifying the conjugated `g^*(inner)` factor as `extendScalars ψ ∘ ρ` via `pullback_spec_tilde_iso` + counit naturality over the generic pullback square — is unresolved.
- **notes**: **must-fix-this-iter** — blueprint claims a substantive proof, body is `:= sorry`. This sorry propagates transitively to `base_change_mate_section_identity`, `base_change_mate_generator_trace`, and `pushforward_base_change_mate_cancelBaseChange`.

### `\lean{AlgebraicGeometry.base_change_mate_section_identity}` (`lem:base_change_mate_section_identity`)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: partial — the proof correctly chains `unfold pushforwardBaseChangeMap; rw [Adjunction.homEquiv_counit]; exact base_change_mate_gstar_transpose ψ φ M`, which is the blueprint's one-line reduction. The proof has no direct `sorry` but depends on `base_change_mate_gstar_transpose` (Seam 3, sorry), so it is **transitively unproved**.
- **notes**: Statement is correctly formalized. Once Seam 3 closes, this closes automatically.

### `\lean{AlgebraicGeometry.base_change_mate_generator_trace}` (`lem:base_change_mate_generator_trace`)
- **Lean target exists**: yes
- **Signature matches**: yes — `IsIso (Θ_src⁻¹ ≫ Γ(α) ≫ Θ_tgt)` corollary form.
- **Proof follows sketch**: partial — `rw [base_change_mate_section_identity]; infer_instance` is the correct one-line closure. Transitively sorry through `base_change_mate_section_identity` → Seam 3.
- **notes**: Will close once Seam 3 closes.

### `\lean{AlgebraicGeometry.pushforward_base_change_mate_cancelBaseChange}` (`lem:pushforward_base_change_mate_cancelBaseChange`)
- **Lean target exists**: yes
- **Signature matches**: yes — `IsIso (Γ(pushforwardBaseChangeMap …))` in the affine–affine case.
- **Proof follows sketch**: yes (structurally) — assembles `IsIso` by conjugation from `base_change_mate_generator_trace`. Transitively sorry through Seam 3.
- **notes**: Will close once Seam 3 closes.

### `\lean{AlgebraicGeometry.base_change_map_affine_local}` (`lem:base_change_map_affine_local`)
- **Lean target exists**: yes
- **Signature matches**: yes — `[IsAffineHom f] → [F.IsQuasicoherent] → (∀ U, IsIso …) → IsIso …`.
- **Proof follows sketch**: yes — one-line `(Modules.isIso_iff_isIso_app_affineOpens …).mpr H`.
- **notes**: Fully proved, no sorry.

### `\lean{AlgebraicGeometry.affineBaseChange_pushforward_iso}` (`lem:affine_base_change_pushforward`)
- **Lean target exists**: yes
- **Signature matches**: yes — `[IsAffineHom f] → [F.IsQuasicoherent] → IsIso (pushforwardBaseChangeMap …)`.
- **Proof follows sketch**: **no** — proof has `sorry` at line 1415. The locality reduction step (`apply base_change_map_affine_local`) is in place, but the per-affine-open **affine reduction** — identifying `(pushforwardBaseChangeMap …).app U` with the affine–affine base-change map on the restricted square (naturality of adjunction transpose + pushforward-commutes-with-restriction) — is unresolved. The comment explicitly notes this is "multi-hundred-LOC build."
- **notes**: **must-fix-this-iter** — blueprint claims a substantive proof, body is `:= sorry`.

### `\lean{AlgebraicGeometry.flatBaseChange_pushforward_isIso}` (`thm:flat_base_change_pushforward`)
- **Lean target exists**: yes
- **Signature matches**: yes — `[Flat g] → [QuasiCompact f] → [QuasiSeparated f] → [F.IsQuasicoherent] → IsIso (pushforwardBaseChangeMap …)`.
- **Proof follows sketch**: **no** — proof body is `:= sorry` at line 1437. The blueprint's Čech-free strategy (finite equalizer + affine lemma + flatness) is outlined in the comment but not implemented. Requires Čech/affine-cover infrastructure for `SheafOfModules`.
- **notes**: **must-fix-this-iter** — blueprint claims a substantive theorem, body is `:= sorry`.

### `\lean{LinearMap.tensorEqLocusEquiv}` (`lem:flat_preserves_equalizer_mathlib`)
- **Lean target exists**: yes (Mathlib)
- **Signature matches**: yes — marked `\mathlibok`.
- **Proof follows sketch**: N/A (Mathlib)
- **notes**: Correct dependency anchor.

---

## Red flags

### Placeholder / suspect bodies

- `base_change_mate_fstar_reindex` at line 1197: body ends with `:= sorry`. Blueprint `lem:base_change_mate_fstar_reindex` claims a substantive proof (pseudofunctor reindex via conjugate-adjunction coherence). **must-fix-this-iter**.
- `base_change_mate_gstar_transpose` at line 1242: body ends with `:= sorry`. Blueprint `lem:base_change_mate_gstar_transpose` claims a substantive proof (pullback-dictionary coherence for the `g^*`-transpose). **must-fix-this-iter**.
- `affineBaseChange_pushforward_iso` at line 1415: body ends with `:= sorry`. Blueprint `lem:affine_base_change_pushforward` claims a substantive proof (affine base change). **must-fix-this-iter**.
- `flatBaseChange_pushforward_isIso` at line 1437: body ends with `:= sorry`. Blueprint `thm:flat_base_change_pushforward` claims the main theorem. **must-fix-this-iter**.

**Transitive sorry-pollution chain:**
`base_change_mate_gstar_transpose` (sorry) → `base_change_mate_section_identity` → `base_change_mate_generator_trace` → `pushforward_base_change_mate_cancelBaseChange`. All three latter declarations have no direct `sorry` but are axiom-polluted until Seam 3 closes.

### Excuse-comments

- `FlatBaseChange.lean:1159–1183` (inside `base_change_mate_fstar_reindex`): comment block "PARTIAL (iter-015): the leg-identification scaffold and the Γ-image split are now in place… The remaining (genuine crux) is…" describes the proof as incomplete. Attached to a sorry-carrying declaration.
- `FlatBaseChange.lean:1227–1241` (inside `base_change_mate_gstar_transpose`): comment block "REMAINING (the genuine crux): the pullback-dictionary coherence…" describes the proof as incomplete. Attached to a sorry-carrying declaration.
- `FlatBaseChange.lean:1391–1415` (inside `affineBaseChange_pushforward_iso`): comment block "WHAT REMAINS HERE (the AFFINE REDUCTION, 'obligation 1')…" describes the sorry as covering a multi-hundred-LOC build.

(These are workflow-appropriate for an iterative project but satisfy the red-flag definition for sorry-bearing declarations.)

### Module-level status notes (informational, not red flags)
Lines 184–246 (`/-! ## Project-local Mathlib supplement — affine tilde dictionary -/`) contain detailed iteration-history prose (route (a) dead, route (b) executed, iter-236 pivot). These are documentation of past obstruction resolution, not excuses for current wrong code; the declarations they document (`gammaPushforwardIso` etc.) are fully proved. Not classified as red flags.

---

## Unreferenced declarations (informational)

All 31 declarations in the Lean file are `\lean{...}`-referenced in the blueprint. There are no substantive orphan declarations.

The `pullbackIsoEquivalenceOfIso` and `pullback_isEquivalence_of_iso` pair appear as helpers within the codomain-read computation; both are properly `\lean{...}`-pinned in the blueprint.

---

## Blueprint adequacy for this file

- **Coverage**: 31/31 Lean declarations have a corresponding `\lean{...}` block in the chapter. 0 unreferenced substantive declarations; 0 unreferenced helpers. Excellent coverage.

- **Proof-sketch depth**: **under-specified** for Seams 2 and 3. Details:

  - *Seam 2 (`lem:base_change_mate_fstar_reindex`)*: The blueprint correctly names the ingredients (identify legs via `pullback_fst_snd_specMap_tensor`, read the unit as the algebraic unit via `lem:base_change_mate_unit_value`, pseudofunctor coherences "merely rebracket"). However, it does not explain the `conjugateEquiv_pullbackComp_inv` + `unit_conjugateEquiv` (Mates) mechanism that formally relates the `pullback.fst`-unit to the `Spec inclA`-unit when the legs differ by the iso `e.hom`. The Lean comment (iter-015 PARTIAL) documents exactly this gap: "the remaining genuine crux is the unit reindex across the iso leg `e.hom`." The blueprint sketch is mathematically correct but insufficiently granular for formalization: a prover who followed the sketch step-by-step would not know which conjugation lemma to apply, in what form, and how to handle the composite-adjunction coherence `pullbackComp e.hom (Spec inclA)`.

  - *Seam 3 (`lem:base_change_mate_gstar_transpose`)*: The blueprint correctly names the counit factorization (Mathlib `homEquiv_counit`) and says conjugating by `Θ_src`, `Θ_tgt` "replaces `g^* = (Spec ψ)^*` of a tilde with extension of scalars along `ψ`." However, `g^*` in the Seam 3 goal is applied to the *output of `inner`* (a non-tilde module), not directly to a tilde. The actual coherence needed — using `pullback_spec_tilde_iso` and counit naturality to identify the conjugated `g^*(inner)` factor as `extendScalars ψ ∘ ρ` over the generic pullback square — is "Mathlib-absent mate-unwinding" (Lean comment). The blueprint sketch does not explain how to transport `pullback_spec_tilde_iso` (a statement about tilde modules) to the non-tilde context arising after `inner` is composed. A prover following the sketch could not derive the formal coherence without additional Mathlib API investigation.

  - All other proof sketches are **adequate**: the Γ-fragment isos, the three `IsLocalizedModule` helpers, the affine tilde dictionaries, the domain/codomain reads, the regrouping equivalence, and the unit-value computation all have sufficiently detailed prose (including element-level descriptions and explicit Mathlib lemma citations) to guide formalization.

- **Hint precision**: **precise**. Every `\lean{...}` pin names an existing declaration. The blueprint's LEAN SIGNATURE annotations (inline comments in the chapter for the more complex declarations) match the actual Lean signatures. No wrong-predicate or renamed-target issues found.

  One minor cross-file note: `lem:base_change_mate_regroupEquiv` lists `\uses{lem:base_change_regroup_linearEquiv}` in both the statement and proof blocks, but no declaration named `base_change_regroup_linearEquiv` appears in `FlatBaseChange.lean`. This is likely a reference to a helper in the imported `RegroupHelper.lean`; the blueprint-doctor would catch any broken `\uses{}` link. The `FlatBaseChange.lean` proof inlines the construction without a named intermediate. Informational — not a pin error for this file.

- **Generality**: **matches need**. All definitions are at the universe-polymorphic level appropriate for the project.

- **\leanok markers**: Correctly applied throughout. All sorry-carrying declarations have `\leanok` on their statement blocks (declaration exists) and **no** `\leanok` on their proof blocks (proof not closed). This is consistent with project conventions. No incorrect proof-block `\leanok` found.

- **Recommended chapter-side actions**:
  1. **Seam 2 expansion** (`lem:base_change_mate_fstar_reindex` proof): Add a step explaining how `pullback.fst = e.hom ≫ Spec inclA` forces the use of `conjugateEquiv_pullbackComp_inv` (or the equivalent `pullbackComp`-vs-`unit` coherence from Mates theory) to transport the generic-square unit to the affine unit. Name the specific Mathlib lemma (`CategoryTheory.unit_conjugateEquiv` or the relevant `Scheme.Modules.pullbackComp` + conjugation form). Explain why the three `pushforwardComp`/`pushforwardCongr` factors are transparent on Γ (cite `pushforwardComp_hom_app_app = 𝟙`, `pushforwardCongr_hom_app_app = eqToHom`).
  2. **Seam 3 expansion** (`lem:base_change_mate_gstar_transpose` proof): Add a step explaining how to apply `pullback_spec_tilde_iso` when `g^*` is not directly applied to a tilde. The relevant coherence is the counit naturality of the `pullback ⊣ pushforward` adjunction combined with `pullback_spec_tilde_iso` to rewrite the `g^*` factor in the composite. Name the specific naturality/coherence lemma.

---

## Severity summary

| Finding | Severity |
|---------|----------|
| `base_change_mate_fstar_reindex`: `:= sorry` on substantive claim (Seam 2) | **must-fix-this-iter** |
| `base_change_mate_gstar_transpose`: `:= sorry` on substantive claim (Seam 3) | **must-fix-this-iter** |
| `affineBaseChange_pushforward_iso`: `:= sorry` on substantive claim (FBC-A) | **must-fix-this-iter** |
| `flatBaseChange_pushforward_isIso`: `:= sorry` on substantive claim (FBC-B) | **must-fix-this-iter** |
| Seam 2 blueprint proof sketch under-specified (missing conjugation mechanism) | **must-fix-this-iter** (blocks prover from closing Seam 2) |
| Seam 3 blueprint proof sketch under-specified (missing counit-naturality mechanism) | **must-fix-this-iter** (blocks prover from closing Seam 3) |
| Excuse-comments on sorry-carrying proofs (`PARTIAL`, `REMAINING`, `WHAT REMAINS HERE`) | **major** (workflow-appropriate but satisfy red-flag definition) |
| `base_change_regroup_linearEquiv` referenced in `\uses{}` but not pinned in this file | **minor** (likely in `RegroupHelper.lean`; cross-file matter) |
| `base_change_mate_section_identity`, `_generator_trace`, `pushforward_base_change_mate_cancelBaseChange`: transitively sorry through Seam 3 | informational (will auto-resolve once Seam 3 closes) |

**Overall verdict**: The Lean file faithfully follows the blueprint (all signatures match, all `\lean{...}` pins are live), but 4 declarations carry direct `sorry`s (Seams 2–3 and FBC-A/B), and the blueprint's proof sketches for Seams 2 and 3 are insufficiently detailed to guide a prover to close them — both sketches correctly identify the mathematical content but omit the conjugate-equivalence/counit-naturality machinery that is the actual formalization crux.
