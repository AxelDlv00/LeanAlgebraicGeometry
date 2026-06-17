# Lean ↔ Blueprint Check Report

## Slug
fbc-iter012

## Iteration
012

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`

---

## Per-declaration

Below, every `\lean{...}` block in the chapter is checked. Mathlib-backed declarations (`\mathlibok`) are listed for completeness but not audited for proof.

---

### `\lean{AlgebraicGeometry.pushforwardBaseChangeMap}` (chapter: `def:pushforward_base_change_map`)
- **Lean target exists**: yes (line 79, `noncomputable def`)
- **Signature matches**: yes — domain `(pullback g).obj ((pushforward f).obj F)`, codomain `(pushforward f').obj ((pullback g').obj F)`, commutativity witness `comm : g' ≫ f = f' ≫ g`. Blueprint prose matches exactly.
- **Proof follows sketch**: yes — the adjunction-transpose-of-unit construction matches the blueprint description.
- **notes**: statement block `\leanok` in blueprint; proof body complete (no sorry).

---

### `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_stalkFunctor_map}` (chapter: `lem:modules_isIso_iff_stalk`)
- **Lean target exists**: yes (line 102, `theorem`)
- **Signature matches**: yes — `IsIso φ ↔ ∀ x : X, IsIso (stalkFunctor … x).map ((toPresheaf X).map φ)`.
- **Proof follows sketch**: yes — forward uses functor functoriality; backward packages the presheaves and invokes `TopCat.Presheaf.isIso_of_stalkFunctor_map_iso` then reflects via `isIso_iff_of_reflects_iso`.
- **notes**: both statement and proof blocks have `\leanok`; proof body has no sorry.

---

### `\lean{AlgebraicGeometry.Modules.isIso_of_isIso_app_of_isBasis}` (chapter: `lem:modules_isIso_of_isBasis`)
- **Lean target exists**: yes (line 128, `theorem`)
- **Signature matches**: yes — `IsBasis (Set.range B)` + per-basic-open `IsIso (φ.app (B i))` → `IsIso φ`.
- **Proof follows sketch**: yes — reduces to stalkwise isomorphism via `isIso_iff_isIso_stalkFunctor_map`, proves injectivity by `stalkFunctor_map_injective_of_isBasis`, surjectivity by `germ_exist_of_isBasis`.
- **notes**: both statement and proof `\leanok`; no sorry.

---

### `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_app_affineOpens}` (chapter: `lem:modules_isIso_iff_affineOpens`)
- **Lean target exists**: yes (line 164, `theorem`)
- **Signature matches**: yes — `IsIso φ ↔ ∀ U : X.affineOpens, IsIso (φ.app U)`.
- **Proof follows sketch**: yes — forward by `inferInstance`; backward calls `Modules.isIso_of_isIso_app_of_isBasis` with `isBasis_affineOpens`.
- **notes**: both statement and proof `\leanok`; no sorry.

---

### `\lean{AlgebraicGeometry.globalSectionsIso_hom_comp_specMap_appTop}` (chapter: `lem:globalSectionsIso_hom_comp_specMap_appTop`)
- **Lean target exists**: yes (line 268, `theorem`)
- **Signature matches**: yes — `(globalSectionsIso ↑R).hom ≫ (Spec.map φ).appTop = φ ≫ (globalSectionsIso ↑R').hom`. Blueprint says "gs_R ∘ (Spec φ)^♯_⊤ = φ ∘ gs_R'".
- **Proof follows sketch**: yes — reduces to `Scheme.ΓSpecIso_inv_naturality`.
- **notes**: both statement and proof `\leanok`; no sorry.

---

### `\lean{AlgebraicGeometry.gammaPushforwardIso}` (chapter: `lem:gammaPushforwardIso`)
- **Lean target exists**: yes (line 288, `noncomputable def`)
- **Signature matches**: yes — `(moduleSpecΓFunctor (R := R)).obj ((pushforward (Spec.map φ)).obj N) ≅ (restrictScalars φ.hom).obj ((moduleSpecΓFunctor (R := R')).obj N)`.
- **Proof follows sketch**: yes — element-free route (b) via `restrictScalarsComp'App` × 2 + `restrictScalarsCongr hcomp` where `hcomp` comes from `globalSectionsIso_hom_comp_specMap_appTop`.
- **notes**: both statement and proof `\leanok`; no sorry.

---

### `\lean{AlgebraicGeometry.gammaPushforwardTildeIso}` (chapter: `lem:gammaPushforwardTildeIso`)
- **Lean target exists**: yes (line 313, `noncomputable def`)
- **Signature matches**: yes — specialises to `N = tilde M`, uses `tilde.toTildeΓNatIso`.
- **Proof follows sketch**: yes — one-line composition of `gammaPushforwardIso φ (tilde M)` with `(restrictScalars φ.hom).mapIso (tilde.toTildeΓNatIso.app M).symm`.
- **notes**: both statement and proof `\leanok`; no sorry.

---

### `\lean{AlgebraicGeometry.gammaPushforwardIsoAt}` (chapter: `lem:gammaPushforwardIsoAt`)
- **Lean target exists**: yes (line 331, `noncomputable def`)
- **Signature matches**: yes — the open-indexed version at arbitrary `U`; target is `(modulesSpecToSheaf.obj (pushforward …)).val.obj (op U) ≅ (restrictScalars φ.hom).obj ((modulesSpecToSheaf.obj N).val.obj (op (preimage U)))`.
- **Proof follows sketch**: yes — identical construction to `gammaPushforwardIso` with `U` in place of `⊤`.
- **notes**: both statement and proof `\leanok`; no sorry.

---

### `\lean{AlgebraicGeometry.tildeRestriction_isLocalizedModule}` (chapter: `lem:tildeRestriction_isLocalizedModule`)
- **Lean target exists**: yes (line 483, `lemma`)
- **Signature matches**: yes — `IsLocalizedModule (Submonoid.powers b) ((modulesSpecToSheaf.obj (tilde M)).val.map (homOfLE …).op).hom`.
- **Proof follows sketch**: yes — establishes bijectivity of `toOpen M ⊤` via `powers 1`-localization, then uses the triangle identity.
- **notes**: both statement and proof `\leanok`; no sorry.

---

### `\lean{AlgebraicGeometry.IsLocalizedModule.powers_restrictScalars}` (chapter: `lem:powers_restrictScalars`)
- **Lean target exists**: yes (line 455, `lemma`)
- **Signature matches**: yes — `IsLocalizedModule (algebraMapSubmonoid A S) f → IsLocalizedModule S (f.restrictScalars R)`. Blueprint prose matches.
- **Proof follows sketch**: yes — checks three `IsLocalizedModule` axioms by transporting along `s ↦ algebraMap A s`.
- **notes**: both statement and proof `\leanok`; no sorry.

---

### `\lean{AlgebraicGeometry.fromTildeΓ_app_isIso_of_isLocalizedModule}` (chapter: `lem:fromTildeGamma_app_isIso_of_localized`)
- **Lean target exists**: yes (line 367, `lemma`)
- **Signature matches**: yes — `[IsLocalizedModule (powers a) (restriction)]` → `IsIso (Hom.app N.fromTildeΓ (basicOpen a))`. Blueprint: "counit from-tilde-Γ restricts to an iso on D(a)".
- **Proof follows sketch**: yes — triangle identity L∘j=ρ, uniqueness of localized modules gives L=e, bijectivity.
- **notes**: both statement and proof `\leanok`; no sorry.

---

### `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso_of_isLocalizedModule}` (chapter: `lem:pushforward_spec_tilde_iso_conditional`)
- **Lean target exists**: yes (line 431, `noncomputable def`)
- **Signature matches**: yes — conditional on `hloc : ∀ a, IsLocalizedModule (powers a) (restriction)`, gives `(pushforward (Spec.map φ)).obj (tilde M) ≅ tilde ((restrictScalars φ.hom).obj M)`.
- **Proof follows sketch**: yes — applies `isIso_of_isIso_app_of_isBasis` over basic opens using `fromTildeΓ_app_isIso_of_isLocalizedModule`, then composes with `gammaPushforwardTildeIso`.
- **notes**: both statement and proof `\leanok`; no sorry.

---

### `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso}` (chapter: `lem:pushforward_spec_tilde_iso`)
- **Lean target exists**: yes (line 538, `noncomputable def`)
- **Signature matches**: yes — `(pushforward (Spec.map φ)).obj (tilde M) ≅ tilde ((restrictScalars φ.hom).obj M)`. Unconditional form.
- **Proof follows sketch**: yes — calls `pushforward_spec_tilde_iso_of_isLocalizedModule` and discharges `hloc` by the three-movement strategy (e₁/e₂ iso, naturality square, transport via `powers_restrictScalars`), using `algebraize`.
- **notes**: both statement and proof `\leanok`; no sorry.

---

### `\lean{AlgebraicGeometry.pullbackSpecIso}` (chapter: `lem:pullbackSpecIso_mathlib`)
- **Lean target exists**: yes (Mathlib)
- **Signature matches**: `\mathlibok` — not audited.

---

### `\lean{TensorProduct.AlgebraTensorModule.cancelBaseChange}` (chapter: `lem:cancelBaseChange_mathlib`)
- **Lean target exists**: yes (Mathlib)
- **Signature matches**: `\mathlibok` — not audited.

---

### `\lean{Algebra.IsPushout.cancelBaseChange}` (chapter: `lem:isPushout_cancelBaseChange_mathlib`)
- **Lean target exists**: yes (Mathlib)
- **Signature matches**: `\mathlibok` — not audited.

---

### `\lean{AlgebraicGeometry.pullback_fst_snd_specMap_tensor}` (chapter: `lem:pullback_fst_snd_specMap_tensor`)
- **Lean target exists**: yes (line 709, `theorem`)
- **Signature matches**: yes — `And` of two equations identifying `pullback.fst` and `pullback.snd` with `Spec` of the tensor inclusions after `pullbackSpecIso.inv`.
- **Proof follows sketch**: yes — directly applies `pullbackSpecIso_inv_fst` and `pullbackSpecIso_inv_snd`.
- **notes**: both statement and proof `\leanok`; no sorry.

---

### `\lean{AlgebraicGeometry.gammaPushforwardNatIso}` (chapter: `lem:gammaPushforwardNatIso`)
- **Lean target exists**: yes (line 667, `noncomputable def`)
- **Signature matches**: yes — natural isomorphism `pushforward (Spec.map φ) ⋙ moduleSpecΓFunctor (R := R) ≅ moduleSpecΓFunctor (R := R') ⋙ restrictScalars φ.hom`.
- **Proof follows sketch**: yes — `NatIso.ofComponents` with `gammaPushforwardIso`; naturality is `ext x; rfl`.
- **notes**: both statement and proof `\leanok`; no sorry.

---

### `\lean{AlgebraicGeometry.pullback_spec_tilde_iso}` (chapter: `lem:pullback_spec_tilde_iso`)
- **Lean target exists**: yes (line 689, `noncomputable def`)
- **Signature matches**: yes — `(pullback (Spec.map φ)).obj (tilde M) ≅ tilde ((extendScalars φ.hom).obj M)`.
- **Proof follows sketch**: yes — uniqueness-of-left-adjoints via `conjugateIsoEquiv` + `gammaPushforwardNatIso`.
- **notes**: both statement and proof `\leanok`; no sorry.

---

### `\lean{AlgebraicGeometry.base_change_mate_domain_read}` (chapter: `lem:base_change_mate_domain_read`)
- **Lean target exists**: yes (line 737, `noncomputable def`)
- **Signature matches**: yes — `(moduleSpecΓFunctor R').obj ((pullback (Spec.map ψ)).obj ((pushforward (Spec.map φ)).obj (tilde M))) ≅ (extendScalars ψ.hom).obj ((restrictScalars φ.hom).obj M)`.
- **Proof follows sketch**: yes — chains `pushforward_spec_tilde_iso`, `pullback_spec_tilde_iso`, and the tilde-Γ unit.
- **notes**: both statement and proof `\leanok`; no sorry.

---

### `\lean{AlgebraicGeometry.base_change_mate_codomain_read}` (chapter: `lem:base_change_mate_codomain_read`)
- **Lean target exists**: yes (line 773, `noncomputable def`)
- **Signature matches**: yes (note: uses `A ⊗[R] R'` orientation per documented convention, equivalent to `R' ⊗_R A` up to `TensorProduct.comm`; blueprint documents this in `% NOTE (iter-003)`).
- **Proof follows sketch**: yes — uses `pullback_fst_snd_specMap_tensor`, `pullback_spec_tilde_iso`, `pushforward_spec_tilde_iso`, and pulls the module through `pullbackSpecIso` via `pullbackIsoEquivalenceOfIso`.
- **notes**: both statement and proof `\leanok`; no sorry.

---

### `\lean{AlgebraicGeometry.pullbackIsoEquivalenceOfIso}` (chapter: `lem:pullbackIsoEquivalenceOfIso`)
- **Lean target exists**: yes (line 753, `noncomputable def`)
- **Signature matches**: yes — `Y.Modules ≌ X.Modules` for `f : X ⟶ Y` with `[IsIso f]`.
- **Proof follows sketch**: yes — assembles from `pullbackId`, `pullbackCongr`, `pullbackComp`.
- **notes**: both statement and proof `\leanok`; no sorry.

---

### `\lean{AlgebraicGeometry.pullback_isEquivalence_of_iso}` (chapter: `lem:pullback_isEquivalence_of_iso`)
- **Lean target exists**: yes (line 762, `instance`)
- **Signature matches**: yes — `(pullback f).IsEquivalence` for `[IsIso f]`.
- **Proof follows sketch**: yes — extracts from `pullbackIsoEquivalenceOfIso`.
- **notes**: both statement and proof `\leanok`; no sorry.

---

### `\lean{AlgebraicGeometry.base_change_mate_regroupEquiv}` (chapter: `lem:base_change_mate_regroupEquiv`)
- **Lean target exists**: yes (line 852, `noncomputable def`)
- **Signature matches**: yes — `(restrictScalars includeRight.toRingHom).obj ((extendScalars includeLeftRingHom).obj M) ≅ (extendScalars ψ.hom).obj ((restrictScalars φ.hom).obj M)`.
- **Proof follows sketch**: yes — uses `TensorProduct.AlgebraTensorModule.cancelBaseChange` as the underlying equivalence, with an identity `A`-linear bridge `eT` for the diamond, packaged by `LinearEquiv.toModuleIso`. The doc comment states "fully proved, no sorry" and the proof has no sorry.
- **notes**: both statement and proof `\leanok`; no sorry.

---

### `\lean{AlgebraicGeometry.base_change_mate_unit_value}` (chapter: `lem:base_change_mate_unit_value`)
- **Lean target exists**: yes (line 980, `theorem`)
- **Signature matches**: yes — the exact Lean signature is pinned in a `% LEAN SIGNATURE` comment in the blueprint and the Lean declaration matches it.
- **Proof follows sketch**: N/A — `:= sorry` at line 1010. Blueprint proof block has NO `\leanok`. **Expected outstanding obligation.**
- **notes**: Statement `\leanok` in blueprint; proof not `\leanok`; sorry matches.

---

### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex}` (chapter: `lem:base_change_mate_fstar_reindex`)
- **Lean target exists**: yes (line 1061, `theorem`)
- **Signature matches**: yes — LHS is `Θisrc.inv ≫ Γ(inner) ≫ Θitgt.hom`, RHS is `base_change_mate_inner_value ψ φ M`. Pinned by `% LEAN SIGNATURE` comment in blueprint.
- **Proof follows sketch**: partial — one `rw [Functor.map_comp]` step landed, then `:= sorry` at line 1091. Blueprint proof NOT `\leanok`. **Expected outstanding obligation.**
- **notes**: `rw [Functor.map_comp]` at line 1124 (it's in the `base_change_mate_gstar_transpose` proof — let me re-check). Actually line 1091 is the sorry for `base_change_mate_fstar_reindex`. The `rw [Functor.map_comp]` at 1124 is in `base_change_mate_gstar_transpose`. For Seam 2: the entire proof body is `:= sorry` (only the comment documents the intended approach). Consistent with blueprint.

---

### `\lean{AlgebraicGeometry.base_change_mate_gstar_transpose}` (chapter: `lem:base_change_mate_gstar_transpose`)
- **Lean target exists**: yes (line 1101, `theorem`)
- **Signature matches**: yes — exact signature pinned in blueprint's `% LEAN SIGNATURE` comment.
- **Proof follows sketch**: partial — `rw [Functor.map_comp]` (the "PARTIAL: split Γ(g^*(inner) ≫ ε_g)" step) is completed, then `:= sorry` at line 1136 for the genuine crux. Blueprint proof NOT `\leanok`. **Expected outstanding obligation.**
- **notes**: The partial progress (`rw [Functor.map_comp]`) matches the blueprint's own "PARTIAL" annotation.

---

### `\lean{AlgebraicGeometry.base_change_mate_section_identity}` (chapter: `lem:base_change_mate_section_identity`)
- **Lean target exists**: yes (line 1161, `theorem`)
- **Signature matches**: yes — `(base_change_mate_domain_read ψ φ M).inv ≫ Γ(pushforwardBaseChangeMap …) ≫ (base_change_mate_codomain_read ψ φ M).hom = (base_change_mate_regroupEquiv ψ φ M).inv`.
- **Proof follows sketch**: yes — `unfold pushforwardBaseChangeMap; rw [Adjunction.homEquiv_counit]; exact base_change_mate_gstar_transpose ψ φ M`. Proof body is complete (no sorry in this declaration); relies on sorry'd `base_change_mate_gstar_transpose`.
- **notes**: Blueprint marks proof as `\leanok` (the proof body is complete); this is correct by Archon convention. Transitive sorry through dependency is expected.

---

### `\lean{AlgebraicGeometry.base_change_mate_generator_trace}` (chapter: `lem:base_change_mate_generator_trace`)
- **Lean target exists**: yes (line 1190, `theorem`)
- **Signature matches**: yes — `IsIso (…domain_read.inv ≫ Γ(pushforwardBaseChangeMap …) ≫ …codomain_read.hom)`.
- **Proof follows sketch**: yes — `rw [base_change_mate_section_identity]; infer_instance`. Proof complete; no sorry in this declaration.
- **notes**: Blueprint marks proof `\leanok`. Correct.

---

### `\lean{AlgebraicGeometry.pushforward_base_change_mate_cancelBaseChange}` (chapter: `lem:pushforward_base_change_mate_cancelBaseChange`)
- **Lean target exists**: yes (line 1227, `theorem`)
- **Signature matches**: yes — `IsIso ((moduleSpecΓFunctor R').map (pushforwardBaseChangeMap (Spec.map φ) (Spec.map ψ) …))`.
- **Proof follows sketch**: yes — conjugates via `base_change_mate_domain_read`/`base_change_mate_codomain_read`, invokes `base_change_mate_generator_trace`. No sorry.
- **notes**: Blueprint marks proof `\leanok`. Correct.

---

### `\lean{AlgebraicGeometry.base_change_map_affine_local}` (chapter: `lem:base_change_map_affine_local`)
- **Lean target exists**: yes (line 1266, `theorem`)
- **Signature matches**: yes — `(∀ U : S'.affineOpens, IsIso ((pushforwardBaseChangeMap …).app U)) → IsIso (pushforwardBaseChangeMap …)` under `[IsAffineHom f]` and `[F.IsQuasicoherent]`.
- **Proof follows sketch**: yes — one-line: `(Modules.isIso_iff_isIso_app_affineOpens …).mpr H`.
- **notes**: Blueprint marks proof `\leanok`. Correct.

---

### `\lean{AlgebraicGeometry.affineBaseChange_pushforward_iso}` (chapter: `lem:affine_base_change_pushforward`)
- **Lean target exists**: yes (line 1278, `theorem`)
- **Signature matches**: yes — `[IsAffineHom f]`, `[F.IsQuasicoherent]`, cartesian `IsPullback` → `IsIso (pushforwardBaseChangeMap …)`.
- **Proof follows sketch**: partial — `apply base_change_map_affine_local`; then `intro U` succeeds; then `:= sorry` for the affine-reduction step (restricting to the affine chart and identifying `(pushforwardBaseChangeMap …).app U` with the affine–affine version). Blueprint proof NOT `\leanok`. **Expected outstanding obligation.**
- **notes**: The blueprint explicitly documents this as "obligation 1" and references `informal/affineBaseChange_pushforward_iso.md`.

---

### `\lean{LinearMap.tensorEqLocusEquiv}` (chapter: `lem:flat_preserves_equalizer_mathlib`)
- **Lean target exists**: yes (Mathlib)
- **Signature matches**: `\mathlibok` — not audited.

---

### `\lean{AlgebraicGeometry.flatBaseChange_pushforward_isIso}` (chapter: `thm:flat_base_change_pushforward`)
- **Lean target exists**: yes (line 1318, `theorem`)
- **Signature matches**: yes — `[Flat g]`, `[QuasiCompact f]`, `[QuasiSeparated f]`, `[F.IsQuasicoherent]` → `IsIso (pushforwardBaseChangeMap …)`. Matches blueprint's statement.
- **Proof follows sketch**: `:= sorry`. Blueprint proof NOT `\leanok`. **Expected outstanding obligation.**
- **notes**: The Lean doc comment gives the full proof strategy (Čech-free equalizer argument); this is documentation, not an excuse-comment.

---

## Red flags

### Placeholder / suspect bodies

All sorries are in proof bodies of `theorem`/`lemma` declarations whose blueprint proof blocks are NOT marked `\leanok`. No sorry occurs on a definitional body (no `def` has `:= sorry`). No `:= True`, `:= rfl` on non-trivial claims, no `Classical.choice` on substantive statements.

The five declarations carrying sorry:
- `base_change_mate_unit_value` (line 1010) — blueprint proof not `\leanok`
- `base_change_mate_fstar_reindex` (line 1091) — blueprint proof not `\leanok`
- `base_change_mate_gstar_transpose` (line 1136) — blueprint proof not `\leanok`
- `affineBaseChange_pushforward_iso` (line 1309, inside `intro U` branch) — blueprint proof not `\leanok`
- `flatBaseChange_pushforward_isIso` (line 1331) — blueprint proof not `\leanok`

**None of these are must-fix-this-iter under the severity rules**, because in every case the blueprint proof block is NOT marked `\leanok`. The sorries are explicitly anticipated.

### Excuse-comments

None found. The extensive `STATUS`, `STRATEGY`, `REMAINING`, `PARTIAL`, and `PIVOT` comments in the Lean file are honest development records (documenting prior failed routes and the chosen successful route), not "we use a wrong definition for now" disclaimers.

### Axioms / Classical.choice on non-trivial claims

No `axiom` declarations. The proof of `tildeRestriction_isLocalizedModule` uses `Classical.choice` implicitly via Lean's `obtain`, which is standard and authorized for this type of argument.

---

## Unreferenced declarations (informational)

One Lean declaration has no `\lean{...}` blueprint block:

- **`base_change_mate_inner_value`** (line 1019, `noncomputable def`): A helper that packages the canonical `R`-linear map `m ↦ (1 ⊗ 1) ⊗ m` in the exact `restrictScalars` form needed by `base_change_mate_fstar_reindex`. The blueprint mentions it by name in the `% LEAN SIGNATURE` comment of `lem:base_change_mate_fstar_reindex` and in the prose of `lem:base_change_mate_gstar_transpose`, but does not give it a dedicated `\begin{lemma}` block. This is an internal helper; its omission from the blueprint is acceptable.

No other Lean declarations are unreferenced that would suggest they should have blueprint blocks.

---

## Blueprint adequacy for this file

- **Coverage**: 30 out of 31 Lean declarations have a corresponding `\lean{...}` block in the chapter (31st being the helper `base_change_mate_inner_value`, acceptably unreferenced). Three Mathlib declarations are referenced as `\mathlibok`. Coverage is excellent.

- **Proof-sketch depth**: **adequate**. The blueprint provides:
  - Detailed proof sketches for all fully-proved declarations.
  - Explicit `% LEAN SIGNATURE` comments pinned against the real Lean types for the three seam lemmas (`lem:base_change_mate_unit_value`, `lem:base_change_mate_fstar_reindex`, `lem:base_change_mate_gstar_transpose`), confirmed to have been elaboration-checked.
  - Multi-paragraph "STRATEGY" blocks in the Lean doc comments (not blueprint prose, but prover-generated) documenting the approach for outstanding obligations.
  - The `% NOTE` blocks accurately document the tensor-order convention and the proof decomposition.

- **Hint precision**: **precise**. Every `\lean{...}` reference resolves to a real declaration in the Lean file with a matching signature. No stale or wrong hints found.

- **Generality**: **matches need**. The blueprint defines things at the right level of generality for the Lean formalization. No parallel API was written because the blueprint was too narrow.

- **One minor adequacy issue — dangling `\uses` reference**: The `\begin{lemma}` block for `lem:base_change_mate_regroupEquiv` carries `\uses{lem:base_change_regroup_linearEquiv, lem:isPushout_cancelBaseChange_mathlib}`. The label `lem:base_change_regroup_linearEquiv` does not appear as a `\begin{lemma}` or `\begin{definition}` block anywhere in this chapter, and no Lean declaration by that name exists in the file. The functionality it was intended to capture (the geometry-free `R'`-linear equivalence) is subsumed directly into `base_change_mate_regroupEquiv` via `Algebra.IsPushout.cancelBaseChange` (which is `\mathlibok`). This is a dangling `\uses` edge — **minor**.

- **Recommended chapter-side actions**:
  - Either add a `\begin{lemma}\label{lem:base_change_regroup_linearEquiv}\mathlibok ... \end{lemma}` stub aliasing `Algebra.IsPushout.cancelBaseChange`, or remove `lem:base_change_regroup_linearEquiv` from the `\uses` of `lem:base_change_mate_regroupEquiv`.

---

## Severity summary

- **must-fix-this-iter**: none.

  All five sorry-carrying declarations (`base_change_mate_unit_value`, `base_change_mate_fstar_reindex`, `base_change_mate_gstar_transpose`, `affineBaseChange_pushforward_iso`, `flatBaseChange_pushforward_isIso`) have blueprint proof blocks without `\leanok`. By the severity rules, a sorry in a declaration the blueprint does NOT claim is proved is not a must-fix finding. No signature mismatches, no axioms, no weakened definitions, no excuse-comments.

- **major**: none.

- **minor**:
  - Dangling `\uses` reference `lem:base_change_regroup_linearEquiv` in `lem:base_change_mate_regroupEquiv` — the label is never defined in the chapter and has no Lean counterpart. Blueprint-doctor should flag this; a one-line fix in the `.tex` resolves it.

**Overall verdict**: The Lean file faithfully follows the blueprint — all signatures match, all sorry placements are consistent with the blueprint's `\leanok` accounting, no fake definitions or axioms were introduced, and the blueprint is detailed enough to guide formalization of the outstanding obligations (three seam lemmas + the affine-reduction step in `affineBaseChange_pushforward_iso`). — 34 declarations checked (31 Lean + 3 Mathlib stubs), 0 red flags, 1 minor blueprint-side dangling reference.
