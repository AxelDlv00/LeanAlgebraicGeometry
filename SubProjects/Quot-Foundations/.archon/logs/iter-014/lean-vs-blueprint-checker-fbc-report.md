# Lean ↔ Blueprint Check Report

## Slug
fbc

## Iteration
014

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.pushforwardBaseChangeMap}` (chapter: def:pushforward_base_change_map)
- **Lean target exists**: yes
- **Signature matches**: yes — `(comm : g' ≫ f = f' ≫ g) (F : X.Modules) : g^*(f_* F) ⟶ f'_*((g')^* F)` matches prose exactly
- **Proof follows sketch**: yes — body is `((pullbackPushforwardAdjunction g).homEquiv _ _).symm` applied to `f_*(unit) ≫ pushforwardComp ≫ pushforwardCongr ≫ pushforwardComp.inv`, exactly the "adjoint to f_* applied to the (g')-unit" construction described
- **notes**: definition is sorry-free and complete

### `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_stalkFunctor_map}` (chapter: lem:modules_isIso_iff_stalk)
- **Lean target exists**: yes (line 102)
- **Signature matches**: yes — `φ : M ⟶ N` iso iff stalk maps are isos for every `x : X`
- **Proof follows sketch**: yes — forward direction via `Functor.map_isIso`, reverse by packaging as `TopCat.Sheaf` and applying `TopCat.Presheaf.isIso_of_stalkFunctor_map_iso`, then reflecting isos
- **notes**: sorry-free; `\leanok` in statement and proof blocks

### `\lean{AlgebraicGeometry.Modules.isIso_of_isIso_app_of_isBasis}` (chapter: lem:modules_isIso_of_isBasis)
- **Lean target exists**: yes (line 128)
- **Signature matches**: yes — basis-local iso criterion; takes `hB : IsBasis (range B)` and `h : ∀ i, IsIso (φ.app (B i))`
- **Proof follows sketch**: yes — reduces to stalkwise iso via injectivity-from-basis and surjectivity-via-germ
- **notes**: sorry-free

### `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_app_affineOpens}` (chapter: lem:modules_isIso_iff_affineOpens)
- **Lean target exists**: yes (line 164)
- **Signature matches**: yes — iso iff iso on all affine opens
- **Proof follows sketch**: yes — one line delegating to `isIso_of_isIso_app_of_isBasis` with `X.isBasis_affineOpens`
- **notes**: sorry-free

### `\lean{AlgebraicGeometry.globalSectionsIso_hom_comp_specMap_appTop}` (chapter: lem:globalSectionsIso_hom_comp_specMap_appTop)
- **Lean target exists**: yes (line 268)
- **Signature matches**: yes — the ring square `gs_R ≫ (Spec φ).appTop = φ ≫ gs_R'`
- **Proof follows sketch**: yes — reduces to `Scheme.ΓSpecIso_inv_naturality` after unfolding `globalSectionsIso` as `ΓSpecIso.inv`
- **notes**: sorry-free

### `\lean{AlgebraicGeometry.gammaPushforwardIso}` (chapter: lem:gammaPushforwardIso)
- **Lean target exists**: yes (line 288)
- **Signature matches**: yes — `Γ_R((Spec φ)_* N) ≅ restrictScalars φ (Γ_{R'} N)` for arbitrary `N`
- **Proof follows sketch**: yes — element-free route (b): two `restrictScalarsComp'App` + `restrictScalarsCongr` using `globalSectionsIso_hom_comp_specMap_appTop`
- **notes**: sorry-free

### `\lean{AlgebraicGeometry.gammaPushforwardTildeIso}` (chapter: lem:gammaPushforwardTildeIso)
- **Lean target exists**: yes (line 313)
- **Signature matches**: yes — `Γ_R((Spec φ)_* (tilde M)) ≅ restrictScalars φ M`
- **Proof follows sketch**: yes — specialises `gammaPushforwardIso` to `N = tilde M` then composes with `tilde.toTildeΓNatIso`
- **notes**: sorry-free

### `\lean{AlgebraicGeometry.gammaPushforwardIsoAt}` (chapter: lem:gammaPushforwardIsoAt)
- **Lean target exists**: yes (line 331)
- **Signature matches**: yes — open-indexed version; `Γ((Spec φ)_* N, U) ≅ restrictScalars φ (Γ(N, (Spec φ)⁻¹ U))`
- **Proof follows sketch**: yes — identical construction to `gammaPushforwardIso` with top replaced by `U`; naturality noted in proof body
- **notes**: sorry-free; blueprint proof sketch explicitly notes "copies that of lem:gammaPushforwardIso verbatim"

### `\lean{AlgebraicGeometry.IsLocalizedModule.powers_restrictScalars}` (chapter: lem:powers_restrictScalars)
- **Lean target exists**: yes (line 455)
- **Signature matches**: yes — `f : M →ₗ[A] N` exhibits `N` as `algebraMapSubmonoid A S`-localization implies `f.restrictScalars R` exhibits `N` as `S`-localization
- **Proof follows sketch**: yes — three conditions (`map_units`, `surj`, `exists_of_eq`) each transported along `algebraMap R A` via `IsScalarTower`
- **notes**: sorry-free

### `\lean{AlgebraicGeometry.tildeRestriction_isLocalizedModule}` (chapter: lem:tildeRestriction_isLocalizedModule)
- **Lean target exists**: yes (line 483)
- **Signature matches**: yes — restriction `Γ(tilde M, ⊤) → Γ(tilde M, D(b))` is a `powers b`-localization
- **Proof follows sketch**: yes — shows `toOpen ⊤` is bijective (localization at `powers 1`), applies triangle identity `toOpen ⊤ ≫ res = toOpen D(b)`, wraps as `of_linearEquiv_right`
- **notes**: sorry-free

### `\lean{AlgebraicGeometry.fromTildeΓ_app_isIso_of_isLocalizedModule}` (chapter: lem:fromTildeGamma_app_isIso_of_localized)
- **Lean target exists**: yes (line 367)
- **Signature matches**: yes — if `restriction Γ(N,⊤) → Γ(N,D(a))` is `powers a`-localization, then `fromTildeΓ N` is iso on `D(a)`
- **Proof follows sketch**: yes — triangle identity gives `L ∘ j = ρ`; uniqueness of localized modules forces `L = e.toLinearMap` for iso `e`; hence bijective
- **notes**: sorry-free

### `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso_of_isLocalizedModule}` (chapter: lem:pushforward_spec_tilde_iso_conditional)
- **Lean target exists**: yes (line 431)
- **Signature matches**: yes — conditional form: if `hloc` holds for every `a : R`, then `(Spec φ)_* (tilde M) ≅ tilde (restrictScalars φ M)`
- **Proof follows sketch**: yes — uses `fromTildeΓ_app_isIso_of_isLocalizedModule` over basic opens via `isIso_of_isIso_app_of_isBasis`, then `gammaPushforwardTildeIso`
- **notes**: sorry-free

### `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso}` (chapter: lem:pushforward_spec_tilde_iso)
- **Lean target exists**: yes (line 538)
- **Signature matches**: yes — unconditional `(Spec φ)_* (tilde M) ≅ tilde (restrictScalars φ M)`
- **Proof follows sketch**: yes — calls `pushforward_spec_tilde_iso_of_isLocalizedModule`; discharges `hloc(a)` via `algebraize [φ.hom]` + `tildeRestriction_isLocalizedModule` + `powers_restrictScalars` + `gammaPushforwardIsoAt` naturality (`ext x; rfl`)
- **notes**: sorry-free. Long STATUS comments (iter-234/236/240/241) in the module preamble are pre-disclosed as known stale.

### `\lean{AlgebraicGeometry.gammaPushforwardNatIso}` (chapter: lem:gammaPushforwardNatIso)
- **Lean target exists**: yes (line 667)
- **Signature matches**: yes — `pushforward (Spec φ) ⋙ Γ_R ≅ Γ_{R'} ⋙ restrictScalars φ` as a NatIso
- **Proof follows sketch**: yes — `NatIso.ofComponents` from `gammaPushforwardIso`, naturality by `ext x; rfl`
- **notes**: sorry-free

### `\lean{AlgebraicGeometry.pullback_spec_tilde_iso}` (chapter: lem:pullback_spec_tilde_iso)
- **Lean target exists**: yes (line 689)
- **Signature matches**: yes — `(Spec φ)^* (tilde M) ≅ tilde (extendScalars φ.hom M)` for `M : ModuleCat R`
- **Proof follows sketch**: yes — uniqueness-of-left-adjoints via `conjugateIsoEquiv` applied to `gammaPushforwardNatIso`
- **notes**: sorry-free

### `\lean{AlgebraicGeometry.pullback_fst_snd_specMap_tensor}` (chapter: lem:pullback_fst_snd_specMap_tensor)
- **Lean target exists**: yes (line 709)
- **Signature matches**: yes — identifies `pullback.fst/snd (Spec.map φ) (Spec.map ψ)` with `Spec` of the two tensor inclusions (via `pullbackSpecIso`)
- **Proof follows sketch**: yes — one pair of lines using `pullbackSpecIso_inv_fst/snd` after setting up algebra instances
- **notes**: sorry-free; the statement is a conjunction, correctly capturing both legs

### `\lean{AlgebraicGeometry.base_change_mate_domain_read}` (chapter: lem:base_change_mate_domain_read)
- **Lean target exists**: yes (line 737)
- **Signature matches**: yes — `Γ_{R'}(g^*(f_* tilde M)) ≅ extendScalars ψ (restrictScalars φ M)` (Θ_src)
- **Proof follows sketch**: yes — `pushforward_spec_tilde_iso` then `pullback_spec_tilde_iso` then `tilde.toTildeΓNatIso.symm`
- **notes**: sorry-free

### `\lean{AlgebraicGeometry.pullbackIsoEquivalenceOfIso}` (chapter: lem:pullbackIsoEquivalenceOfIso)
- **Lean target exists**: yes (line 753)
- **Signature matches**: yes — `pullback f` is one half of an equivalence `Y.Modules ≌ X.Modules`
- **Proof follows sketch**: yes — unit/counit assembled from `pullbackId`, `pullbackCongr`, `pullbackComp`
- **notes**: sorry-free

### `\lean{AlgebraicGeometry.pullback_isEquivalence_of_iso}` (chapter: lem:pullback_isEquivalence_of_iso)
- **Lean target exists**: yes (line 762, as `instance`)
- **Signature matches**: yes — `[IsIso f] : (pullback f).IsEquivalence`
- **Proof follows sketch**: yes — one line extracting the equivalence from `pullbackIsoEquivalenceOfIso`
- **notes**: sorry-free

### `\lean{AlgebraicGeometry.base_change_mate_codomain_read}` (chapter: lem:base_change_mate_codomain_read)
- **Lean target exists**: yes (line 773)
- **Signature matches**: yes — `Γ_{R'}(f'_*(g')^* tilde M) ≅ restrictScalars includeRight (extendScalars includeLeft M)` (Θ_tgt)
- **Proof follows sketch**: yes — identifies legs via `pullback_fst_snd_specMap_tensor` then chains `pullback_spec_tilde_iso + pushforward_spec_tilde_iso` after working through `pullbackSpecIso`
- **notes**: sorry-free; proof is the most involved helper in the file; matches the Stacks "X' = Spec(A ⊗ R')" description

### `\lean{AlgebraicGeometry.base_change_mate_regroupEquiv}` (chapter: lem:base_change_mate_regroupEquiv)
- **Lean target exists**: yes (line 852)
- **Signature matches**: yes — bundled R'-linear iso `restrictScalars includeRight (extendScalars includeLeft M) ≅ extendScalars ψ (restrictScalars φ M)`, i.e. `(A⊗R')⊗_A M ≅ R'⊗_R M`
- **Proof follows sketch**: yes — mathematical core is `comm ≪≫ TensorProduct.congr eT ≪≫ cancelBaseChange ≪≫ comm` (route (a)); `eT` is the identity A-linear bridge resolving the `A`-action diamond; `map_smul'` closed by `TensorProduct.induction_on`
- **notes**: sorry-free; STATUS comment "iter-011, route (a) executed" is stale cross-project history but not misleading

### `\lean{AlgebraicGeometry.base_change_mate_unit_value}` (chapter: lem:base_change_mate_unit_value) — **THIS ITER'S TARGET**
- **Lean target exists**: yes (line 983)
- **Signature matches**: yes — the blueprint provides an explicit elaborated Lean signature hint (blueprint lines 1342–1357) and the Lean declaration matches it exactly: equality of two `ModuleCat A` morphisms from `M` to `restrictScalars inclA (extendScalars inclA M)`, where LHS is the tilde-Γ round-trip reading of the geometric adjunction unit and RHS is `(extendRestrictScalarsAdj inclA.hom).unit.app M`
- **Proof follows sketch**: **yes — mathematical content matches**; see detailed analysis below
- **notes**: sorry-free, axiom-clean (`{propext, Classical.choice, Quot.sound}`); `\leanok` present in both statement and proof blocks; `set_option maxHeartbeats 4000000` is a performance annotation only, not a correctness concern

**Detailed Seam-1 content analysis.** The blueprint proof sketch (lem:base_change_mate_unit_value) states:

> "The geometric adjunction (Spec ι_A)^* ⊣ (Spec ι_A)_* transports, under the tilde dictionaries, to the algebraic extension/restriction adjunction. The dictionaries being the comparison isomorphisms of these adjunctions, naturality identifies the two units."

The Lean proof executes exactly this:
- `adjL = (tilde.adjunction R_A).comp (pullbackPushforwardAdjunction (Spec.map inclA))` — the geometric adjunction bracketed with tilde/Γ
- `adjR = (extendRestrictScalarsAdj inclA.hom).comp (tilde.adjunction R_X)` — the algebraic adjunction bracketed with tilde/Γ
- `β = gammaPushforwardNatIso inclA` — the right-adjoint comparison natural isomorphism (the tilde dictionary on the right)
- `hpullinv`: `pullback_spec_tilde_iso.inv = (conjugateEquiv adjL adjR).symm β.hom` — verifies the pullback dictionary IS the comparison isomorphism, so the two adjunctions are related by conjugation
- `huce = unit_conjugateEquiv_symm adjL adjR β.hom M` — the abstract conjugate-unit coherence: the unit of `adjL` equals the conjugation of the unit of `adjR` through `β`
- Claim A uses the tilde adjunction right-triangle identity to show that `Γ(pushforward_spec_tilde_iso) ≫ tilde.Γ.unit = gammaPushforwardTildeIso`
- `hgPTI` expresses `gammaPushforwardTildeIso` in terms of `β.hom` at tilde objects
- Final assembly applies β-naturality and `huce` to chain to `hunitR` (the algebraic unit `η_M`)

The proof is the conjugate-unit coherence argument the blueprint describes. The intermediate moves (Claim A via the right-triangle, β-naturality) are implementation details of that abstract argument, not a different proof strategy.

### `\lean{AlgebraicGeometry.base_change_mate_inner_value}` (chapter: def:base_change_mate_inner_value)
- **Lean target exists**: yes (line 1098)
- **Signature matches**: yes — R-linear map `restrictScalars φ M ⟶ restrictScalars ψ (restrictScalars inclR' (extendScalars inclA M))`, i.e. `m ↦ (1⊗1)⊗m`
- **Proof follows sketch**: yes — built as `(restrictScalars φ).map (extendRestrictScalarsAdj inclA.hom).unit ≫ [change-of-rings transport via hring]`, exactly the blueprint description
- **notes**: sorry-free; the `hring` computation verifying `inclA ∘ φ = inclR' ∘ ψ` is correct ring arithmetic

### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex}` (chapter: lem:base_change_mate_fstar_reindex)
- **Lean target exists**: yes (line 1140)
- **Signature matches**: yes — statement correctly identifies the LHS with `base_change_mate_inner_value` via `gammaPushforwardTildeIso` and `gammaPushforwardIso`
- **Proof follows sketch**: N/A — honest typed `sorry` at line 1170 (Seam 2, pre-disclosed in directive)
- **notes**: `\leanok` is in the statement block (correct: sorry present), not the proof block (correct: proof open). The inline comment accurately describes the intended mathematical steps.

### `\lean{AlgebraicGeometry.base_change_mate_gstar_transpose}` (chapter: lem:base_change_mate_gstar_transpose)
- **Lean target exists**: yes (line 1180)
- **Signature matches**: yes — correctly states the Seam 3 equation: the `(g^*⊣g_*)`-transpose reading equals `(base_change_mate_regroupEquiv ψ φ M).inv`
- **Proof follows sketch**: partial — `rw [Functor.map_comp]` reduces to the pullback-dictionary coherence, then `sorry` (Seam 3, pre-disclosed)
- **notes**: one genuine tactic before the sorry; the `rw` step is correct (splits Γ(g^*(inner) ≫ ε_g) into two factors by Functor.map_comp)

### `\lean{AlgebraicGeometry.base_change_mate_section_identity}` (chapter: lem:base_change_mate_section_identity)
- **Lean target exists**: yes (line 1240)
- **Signature matches**: yes — `Θ_src.inv ≫ Γ(pushforwardBaseChangeMap ...) ≫ Θ_tgt = (base_change_mate_regroupEquiv ...).inv`
- **Proof follows sketch**: yes — `unfold pushforwardBaseChangeMap; rw [Adjunction.homEquiv_counit]; exact base_change_mate_gstar_transpose ψ φ M` is exactly the "counit factorization reduces to Seam 3" step described in the blueprint; proof is sorry-free structurally (sorry propagates from Seam 3)
- **notes**: `\leanok` in statement block (correct); `\leanok` in proof block — the proof *body* is correct and complete modulo Seam 3 upstream

### `\lean{AlgebraicGeometry.base_change_mate_generator_trace}` (chapter: lem:base_change_mate_generator_trace)
- **Lean target exists**: yes (line 1269)
- **Signature matches**: yes — `IsIso (Θ_src.inv ≫ Γ(α) ≫ Θ_tgt)` formalization of the generator trace IsIso corollary
- **Proof follows sketch**: yes — `rw [base_change_mate_section_identity]; infer_instance` (one line); blueprint says this is a one-line `rw` + `infer_instance`
- **notes**: sorry-free structurally (relies on `base_change_mate_section_identity` which propagates Seam 3 sorry)

### `\lean{AlgebraicGeometry.pushforward_base_change_mate_cancelBaseChange}` (chapter: lem:pushforward_base_change_mate_cancelBaseChange)
- **Lean target exists**: yes (line 1306)
- **Signature matches**: yes — `IsIso (Γ(pushforwardBaseChangeMap ...))` in the affine-affine model
- **Proof follows sketch**: yes — conjugation argument `Γα = D.hom ≫ (D.inv ≫ Γα ≫ C.hom) ≫ C.inv` with `base_change_mate_generator_trace` supplies the inner IsIso
- **notes**: sorry-free structurally (Seam 2/3 propagate upstream); the NOTE comment in blueprint correctly describes this as the `IsIso (Γ(α))` corollary form

### `\lean{AlgebraicGeometry.base_change_map_affine_local}` (chapter: lem:base_change_map_affine_local)
- **Lean target exists**: yes (line 1345)
- **Signature matches**: yes — takes `IsPullback`, `[IsAffineHom f]`, `[F.IsQuasicoherent]`, and per-affine-open hypothesis `H`; applies locality criterion
- **Proof follows sketch**: yes — one line `(Modules.isIso_iff_isIso_app_affineOpens ...).mpr H`; blueprint says "only content beyond the bare criterion is the identification..."; the Lean proof records the locality step cleanly
- **notes**: sorry-free. Blueprint proof elaboration (Steps 1–3) describes the intended reduction in detail; the Lean currently formalizes the trivial direction (the locality criterion itself, given H). The step identifying `(pushforwardBaseChangeMap ...).app U` with the affine-affine map is deferred to `affineBaseChange_pushforward_iso`.

### `\lean{AlgebraicGeometry.affineBaseChange_pushforward_iso}` (chapter: lem:affine_base_change_pushforward)
- **Lean target exists**: yes (line 1357)
- **Signature matches**: yes — `IsPullback → [IsAffineHom f] → [F.IsQuasicoherent] → IsIso (pushforwardBaseChangeMap ...)`
- **Proof follows sketch**: N/A — honest typed `sorry` at line 1388 (FBC-B deferred, pre-disclosed)
- **notes**: proof body correctly applies `base_change_map_affine_local` and explains the remaining obligation (affine reduction over each chart U); sorry is on the second obligation

### `\lean{AlgebraicGeometry.flatBaseChange_pushforward_isIso}` (chapter: thm:flat_base_change_pushforward)
- **Lean target exists**: yes (line 1397)
- **Signature matches**: yes — `IsPullback → [Flat g] → [QuasiCompact f] → [QuasiSeparated f] → [F.IsQuasicoherent] → IsIso (pushforwardBaseChangeMap ...)`
- **Proof follows sketch**: N/A — honest typed `sorry` at line 1410 (FBC-B deferred, pre-disclosed)
- **notes**: proof comment accurately describes the intended Čech-free argument for i=0

---

## Red flags

No red flags beyond the pre-disclosed seam sorries.

### Placeholder / suspect bodies
None beyond pre-disclosed seams:
- `base_change_mate_fstar_reindex` (line 1170): `:= sorry` — Seam 2, pre-disclosed
- `base_change_mate_gstar_transpose` (line 1215): sorry after one correct tactic — Seam 3, pre-disclosed
- `affineBaseChange_pushforward_iso` (line 1388): sorry — FBC-B deferred, pre-disclosed
- `flatBaseChange_pushforward_isIso` (line 1410): sorry — FBC-B deferred, pre-disclosed

### Excuse-comments
None. The STATUS comments in the preamble (lines 184–247, referencing iter-234/236/240/241) are historical engineering notes explaining a resolved route — not excuses for wrong code. They are pre-identified as stale in the directive.

The STATUS comment at line 841 (`iter-011, route (a) executed`) in `base_change_mate_regroupEquiv` is accurate and not misleading (the definition is fully proved, no sorry).

### Axioms / Classical.choice on non-trivial claims
None. `base_change_mate_unit_value` uses `{propext, Classical.choice, Quot.sound}` — the standard Lean 4 axiom set, present universally. No `axiom` declarations introduced by the project.

---

## Unreferenced declarations (informational)

All declarations in the Lean file are referenced by a `\lean{...}` block in the blueprint. No unreferenced declarations.

---

## Blueprint adequacy for this file

### Coverage
34/34 Lean declarations have a corresponding `\lean{...}` block in the blueprint (3 are `\mathlibok` Mathlib references; the remainder are project declarations). **Coverage: complete.**

### Proof-sketch depth: **adequate overall, with one minor observation**

The proof sketch for `lem:base_change_mate_unit_value` (the principal target of this iter) is two sentences in the blueprint proof body:

> "The geometric adjunction … transports, under the tilde dictionaries … to the algebraic extension/restriction adjunction. The dictionaries being the comparison isomorphisms of these adjunctions, naturality identifies the two units."

The Lean proof required several intermediate moves not named in the sketch:
1. **Claim A**: that `Γ(pushforward_spec_tilde_iso) ≫ tilde.Γ.unit = gammaPushforwardTildeIso` (needed the right-triangle identity of the tilde adjunction)
2. **β-naturality**: that `β.hom.app (tilde …) ≫ restrictScalars.map (Γ unit⁻¹) = gammaPushforwardTildeIso.hom` (connecting γ_pushforward to β)
3. The specific `unit_conjugateEquiv_symm` coherence as the Lean realization of "naturality identifies the two units"

These are not independent mathematical ideas — they are the unfolding of the abstract "conjugate-adjunction unit" principle. The blueprint sketch is mathematically correct and names the right concepts, but a prover working from it cold would face non-trivial elaboration work. The proof succeeded, so the sketch was not fatally under-specified.

For the remaining seam targets (`base_change_mate_fstar_reindex`, `base_change_mate_gstar_transpose`) the blueprint proof sketches are appropriately detailed (explicitly naming the steps: leg identification via `pullback_fst_snd_specMap_tensor`, Seam 1 application, pseudofunctor rebracket, counit-factorization, `pullback_spec_tilde_iso` coherence).

### Hint precision: **precise**
All `\lean{...}` hints name declarations whose signatures match the prose. The blueprint for `lem:base_change_mate_unit_value` includes an explicit multi-line Lean signature comment (lines 1342–1357 of the blueprint), which is precise and elaboration-checked.

### Generality: **matches need**
All declarations are at the correct level of generality for the project's use. No parallel API was written outside blueprint scope.

### Recommended chapter-side actions
One minor recommendation:
- **`lem:base_change_mate_unit_value` proof sketch**: expand by one paragraph naming (a) the Claim A step (right-triangle of tilde adjunction: `Γ(pushforward_spec_tilde_iso) ≫ tilde.Γ.unit = gammaPushforwardTildeIso`), (b) the β-naturality step (connecting β.hom at a tilde object to `gammaPushforwardTildeIso`), and (c) the specific Lean coherence used (`unit_conjugateEquiv_symm`). The current sketch correctly captures the mathematical idea but leaves the intermediate coherences implicit; making them explicit would make the sketch a reliable proof guide for Seam iterations.

---

## Severity summary

- **must-fix-this-iter**: 0 findings
- **major**: 0 findings
- **minor**: 1 finding
  - Blueprint proof sketch for `lem:base_change_mate_unit_value` (Seam 1) is mathematically correct but sparse relative to the actual Lean proof structure; three intermediate steps (Claim A, β-naturality, and the specific `unit_conjugateEquiv_symm` lemma) are implicit. The proof succeeded under the current sketch, so this is not a blocking issue.

**Overall verdict**: The file is in good shape — `base_change_mate_unit_value` is now sorry-free with mathematical content fully matching the chapter's Seam-1 sketch; the three remaining seam sorries are openly-disclosed scaffolding; no signature mismatches, no fake statements, no unauthorized axioms; blueprint coverage is complete (34/34 declarations referenced).
