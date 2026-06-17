# Lean ↔ Blueprint Check Report

## Slug
fbc-iter008

## Iteration
008

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.pushforwardBaseChangeMap}` (def:pushforward_base_change_map)
- **Lean target exists**: yes (line 79)
- **Signature matches**: yes — canonical morphism `g^*(f_* F) ⟶ f'_*((g')^* F)`, constructed as the `(g^*, g_*)`-adjunction transpose of `f_*(unit)` composed with pushforward pseudofunctoriality. Matches blueprint exactly.
- **Proof follows sketch**: yes — definition body implements the adjoint-mate construction described in the blueprint.
- **notes**: No sorry; clean.

### `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_stalkFunctor_map}` (lem:modules_isIso_iff_stalk)
- **Lean target exists**: yes (line 102)
- **Signature matches**: yes — `IsIso φ ↔ ∀ x : X, IsIso (stalkFunctor_map …)`.
- **Proof follows sketch**: yes — forward direction uses functor image; reverse direction packages into `TopCat.Sheaf`, applies `isIso_of_stalkFunctor_map_iso`, then reflects back. Matches blueprint.
- **notes**: No sorry; proof-block `\leanok` not present in blueprint (correct — proof is substantive, not trivial).

### `\lean{AlgebraicGeometry.Modules.isIso_of_isIso_app_of_isBasis}` (lem:modules_isIso_of_isBasis)
- **Lean target exists**: yes (line 128)
- **Signature matches**: yes — `IsBasis (range B) → IsIso φ → (∀ i, IsIso (φ.app (B i))) → IsIso φ`.
- **Proof follows sketch**: yes — reduces to stalkwise iso via `isIso_iff_isIso_stalkFunctor_map`, then proves injectivity/surjectivity using `germ_exist_of_isBasis`. Matches blueprint.
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_app_affineOpens}` (lem:modules_isIso_iff_affineOpens)
- **Lean target exists**: yes (line 164)
- **Signature matches**: yes — `IsIso φ ↔ ∀ U : X.affineOpens, IsIso (φ.app U)`.
- **Proof follows sketch**: yes — specializes `isIso_of_isIso_app_of_isBasis` to the affine-opens basis.
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.globalSectionsIso_hom_comp_specMap_appTop}` (lem:globalSectionsIso_hom_comp_specMap_appTop)
- **Lean target exists**: yes (line 268)
- **Signature matches**: yes — `gs_R.hom ≫ (Spec.map φ).appTop = φ ≫ gs_R'.hom`, commutative ring square.
- **Proof follows sketch**: yes — reduces to `ΓSpecIso_inv_naturality`.
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.gammaPushforwardIso}` (lem:gammaPushforwardIso)
- **Lean target exists**: yes (line 288)
- **Signature matches**: yes — `moduleSpecΓFunctor R obj ((pushforward Spec.map φ) obj N) ≅ (restrictScalars φ.hom) obj (moduleSpecΓFunctor R' obj N)`.
- **Proof follows sketch**: yes — route-(b) element-free construction via `restrictScalarsComp'App` twice + `restrictScalarsCongr`. Matches blueprint.
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.gammaPushforwardTildeIso}` (lem:gammaPushforwardTildeIso)
- **Lean target exists**: yes (line 313)
- **Signature matches**: yes — specializes `gammaPushforwardIso` to `N = tilde M`, then composes with `toTildeΓNatIso`.
- **Proof follows sketch**: yes.
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.gammaPushforwardIsoAt}` (lem:gammaPushforwardIsoAt)
- **Lean target exists**: yes (line 331)
- **Signature matches**: yes — sections of pushforward over `U ≅ restrictScalars φ (sections of N over preimage U)`.
- **Proof follows sketch**: yes — identical construction to `gammaPushforwardIso` with evaluation open `U` instead of `⊤`. Naturality-in-U documented as a prose remark, not a separate Lean lemma.
- **notes**: No sorry. Blueprint and Lean agree the naturality-in-U is structural (pointwise `rfl`).

### `\lean{AlgebraicGeometry.fromTildeΓ_app_isIso_of_isLocalizedModule}` (lem:fromTildeGamma_app_isIso_of_localized)
- **Lean target exists**: yes (line 367)
- **Signature matches**: yes — given `IsLocalizedModule (powers a) ρ`, the counit section map `L` over `D(a)` is an iso.
- **Proof follows sketch**: yes — triangle identity gives `L ∘ j = ρ`; uniqueness of localized modules forces `L = ej⁻¹.trans eρ`, hence bijective.
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.IsLocalizedModule.powers_restrictScalars}` (lem:powers_restrictScalars)
- **Lean target exists**: yes (line 455)
- **Signature matches**: yes — for `f : M →ₗ[A] N` a localization at `algMapSubmonoid A S`, the scalar restriction `f.restrictScalars R` is a localization at `S`.
- **Proof follows sketch**: yes — checks three conditions (`map_units`, `surj`, `exists_of_eq`) by transporting along `s ↦ algebraMap s`.
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.tildeRestriction_isLocalizedModule}` (lem:tildeRestriction_isLocalizedModule)
- **Lean target exists**: yes (line 483)
- **Signature matches**: yes — restriction `Γ(M̃, ⊤) → Γ(M̃, D(b))` is `IsLocalizedModule (powers b)`.
- **Proof follows sketch**: yes — injectivity from `toOpen ⊤` being a bijection, triangle identity `toOpen ⊤ ≫ res = toOpen D(b)`, then `of_linearEquiv_right`.
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso_of_isLocalizedModule}` (lem:pushforward_spec_tilde_iso_conditional)
- **Lean target exists**: yes (line 431)
- **Signature matches**: yes — conditional: given `hloc`, produces `(Spec.map φ)_* (tilde M) ≅ tilde (restrictScalars φ M)`.
- **Proof follows sketch**: yes — applies `fromTildeΓ_app_isIso_of_isLocalizedModule` over the basis, uses `isIso_of_isIso_app_of_isBasis`.
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso}` (lem:pushforward_spec_tilde_iso)
- **Lean target exists**: yes (line 538)
- **Signature matches**: yes — `(Spec.map φ)_* (tilde M) ≅ tilde (restrictScalars φ M)` unconditionally.
- **Proof follows sketch**: yes — discharges `hloc(a)` via `algebraize [φ.hom]`, `tildeRestriction_isLocalizedModule`, `powers_restrictScalars`, and the open-naturality square of `gammaPushforwardIsoAt` (naturality is the `rfl` identity on elements). Movements (1)-(3) of the blueprint proof are faithfully implemented.
- **notes**: No sorry. The blueprint's movement-(2) (open-naturality square for `D(a) ⊆ ⊤`) is discharged in the Lean by `ext x; rfl` (the KEY INSIGHT comment at line 639), confirming the blueprint's claim that it's a naturality-of-identity result.

### `\lean{AlgebraicGeometry.gammaPushforwardNatIso}` (lem:gammaPushforwardNatIso)
- **Lean target exists**: yes (line 667)
- **Signature matches**: yes — natural iso `pushforward (Spec.map φ) ⋙ moduleSpecΓFunctor R ≅ moduleSpecΓFunctor R' ⋙ restrictScalars φ`.
- **Proof follows sketch**: yes — components are `gammaPushforwardIso φ N`; naturality by `ext x; rfl`.
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.pullback_spec_tilde_iso}` (lem:pullback_spec_tilde_iso)
- **Lean target exists**: yes (line 689)
- **Signature matches**: yes — `(Spec.map φ)^* (tilde M) ≅ tilde (extendScalars φ M)`.
- **Proof follows sketch**: yes — uniqueness-of-left-adjoints route via `conjugateIsoEquiv` applied to `gammaPushforwardNatIso`.
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.pullbackSpecIso}` (lem:pullbackSpecIso_mathlib)
- **Lean target exists**: yes (Mathlib)
- **Signature matches**: yes (`\mathlibok`).
- **Proof follows sketch**: N/A (Mathlib-provided).
- **notes**: Blueprint correctly marks `\mathlibok`.

### `\lean{TensorProduct.AlgebraTensorModule.cancelBaseChange}` (lem:cancelBaseChange_mathlib)
- **Lean target exists**: yes (Mathlib)
- **Signature matches**: yes (`\mathlibok`).
- **Proof follows sketch**: N/A.
- **notes**: Blueprint correctly marks `\mathlibok`.

### `\lean{AlgebraicGeometry.pullback_fst_snd_specMap_tensor}` (lem:pullback_fst_snd_specMap_tensor)
- **Lean target exists**: yes (line 709)
- **Signature matches**: yes — paired `And` statement: `pullbackSpecIso.inv ≫ pullback.fst = Spec.map inclA` and `pullbackSpecIso.inv ≫ pullback.snd = Spec.map inclR'`.
- **Proof follows sketch**: yes — delegates to `pullbackSpecIso_inv_fst` and `pullbackSpecIso_inv_snd`.
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.base_change_mate_domain_read}` (lem:base_change_mate_domain_read)
- **Lean target exists**: yes (line 737)
- **Signature matches**: yes — `Γ(g^*(f_* M̃)) ≅ extendScalars ψ (restrictScalars φ M)`.
- **Proof follows sketch**: yes — applies `pushforward_spec_tilde_iso` then `pullback_spec_tilde_iso`, composes with `toTildeΓNatIso`.
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.pullbackIsoEquivalenceOfIso}` (lem:pullbackIsoEquivalenceOfIso)
- **Lean target exists**: yes (line 753)
- **Signature matches**: yes — `Y.Modules ≌ X.Modules` via `pullback f` and `pullback (inv f)`.
- **Proof follows sketch**: yes — assembles unit/counit from `pullbackId`, `pullbackCongr`, `pullbackComp`.
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.pullback_isEquivalence_of_iso}` (lem:pullback_isEquivalence_of_iso)
- **Lean target exists**: yes (line 762, as `instance`)
- **Signature matches**: yes — `(pullback f).IsEquivalence` for `[IsIso f]`.
- **Proof follows sketch**: yes — wraps `pullbackIsoEquivalenceOfIso`.
- **notes**: No sorry. Blueprint notes the corollary that the adjunction unit is a natural iso; the `IsEquivalence` instance implies this in Lean.

### `\lean{AlgebraicGeometry.base_change_mate_codomain_read}` (lem:base_change_mate_codomain_read)
- **Lean target exists**: yes (line 773)
- **Signature matches**: yes — `Γ(f'_*(g')^* M̃) ≅ restrictScalars inclR' (extendScalars inclA M)` where `inclA`, `inclR'` are the tensor inclusions.
- **Proof follows sketch**: yes — uses `pullback_fst_snd_specMap_tensor` to identify the cone legs, then chains `pullback_spec_tilde_iso` and `pushforward_spec_tilde_iso` through the `pullbackSpecIso` iso.
- **notes**: No sorry. The `unit_iso` (adjunction unit is an iso because `e.hom` is an iso of schemes) is covered by `pullback_isEquivalence_of_iso`.

### `\lean{AlgebraicGeometry.base_change_mate_regroupEquiv}` (lem:base_change_mate_regroupEquiv)
- **Lean target exists**: yes (line 854)
- **Signature matches**: yes — `(restrictScalars inclR'.toRingHom (extendScalars inclA M)) ≅ (extendScalars ψ (restrictScalars φ M))`.
- **Proof follows sketch**: partial — generator computation (`tmul` branch) and `R'`-additivity (`add` branches) are proven; two `zero` branches (`r' • 0 = 0`) carry `sorry` due to `SMulZeroClass` synthesis failure through opaque object instances.
- **notes**: **2 sorries** at lines 951 and 960, pre-excused per directive as known issue. The blueprint documents the route-(b) fix adequately: use `LinearEquiv.toModuleIso (base_change_regroup_linearEquiv ↑M)` from a separate compiled module (the Lean docstring at lines 851-853 confirms this works across import boundaries). Blueprint `\uses{lem:base_change_regroup_linearEquiv}` is in place; the helper is in `RegroupHelper.lean`. Blueprint is adequate for this fix.

### `\lean{AlgebraicGeometry.base_change_mate_unit_value}` (lem:base_change_mate_unit_value)
- **Lean target exists**: **no** — declaration absent from the Lean file.
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Blueprint has `\lean{AlgebraicGeometry.base_change_mate_unit_value}`, clear informal prose (unit η' on generators: `m ↦ (1⊗1)⊗m`), and `\uses{lem:base_change_mate_codomain_read, lem:pullback_spec_tilde_iso}`. **No `% LEAN SIGNATURE` block.** Pre-excused per directive as "not formalized this iter." Assessed under Blueprint adequacy below.

### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex}` (lem:base_change_mate_fstar_reindex)
- **Lean target exists**: **no** — absent from the Lean file.
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Blueprint has `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex}`, prose describes `f_*` applied to the unit leaving elements unchanged while pseudofunctor reindexes the target. **No `% LEAN SIGNATURE` block.** Pre-excused per directive. Assessed below.

### `\lean{AlgebraicGeometry.base_change_mate_gstar_transpose}` (lem:base_change_mate_gstar_transpose)
- **Lean target exists**: **no** — absent from the Lean file.
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Blueprint has `\lean{AlgebraicGeometry.base_change_mate_gstar_transpose}`, prose gives the extension-of-scalars transpose formula `û(r'⊗m) = r'·u(m)`. **No `% LEAN SIGNATURE` block.** Pre-excused per directive. Assessed below.

### `\lean{AlgebraicGeometry.base_change_mate_generator_trace_eq}` (lem:base_change_mate_generator_trace_eq)
- **Lean target exists**: yes (line 1000)
- **Signature matches**: yes — `(domain_read ψ φ M).inv ≫ Γ(pushforwardBaseChangeMap ...) ≫ (codomain_read ψ φ M).hom = (regroupEquiv ψ φ M).inv`. In function-composition notation this is `Θ_tgt ∘ Γα ∘ Θ_src⁻¹ = regroup⁻¹`, matching the blueprint.
- **Proof follows sketch**: partial — `ext x` reduces to per-generator identity; the three-step mate-trace (steps A/C/B of the blueprint proof) is then `sorry`. Blueprint proof explicitly chains `unit_value`, `fstar_reindex`, `gstar_transpose` as `\uses`, all three of which are unformalized. The proof body correctly uses `ext` for the reduction the blueprint describes, but the core sorry blocks the conclusion.
- **notes**: **1 sorry** at line 1028. This sorry is downstream of the three missing sub-lemmas.

### `\lean{AlgebraicGeometry.base_change_mate_generator_trace}` (lem:base_change_mate_generator_trace)
- **Lean target exists**: yes (line 1040)
- **Signature matches**: yes — `IsIso (domain_read.inv ≫ Γα ≫ codomain_read.hom)`.
- **Proof follows sketch**: yes — `rw [base_change_mate_generator_trace_eq]; infer_instance`. A one-liner that correctly chains from the generator equation to the `IsIso` conclusion. Proof is syntatically sorry-free but **transitively sorry** through `generator_trace_eq`.
- **notes**: The blueprint note (iter-003) explicitly anticipated this structure. No direct red flag; the transitive sorry is documented.

### `\lean{AlgebraicGeometry.pushforward_base_change_mate_cancelBaseChange}` (lem:pushforward_base_change_mate_cancelBaseChange)
- **Lean target exists**: yes (line 1077)
- **Signature matches**: yes — `IsIso (Γ(pushforwardBaseChangeMap ...))` in the affine-affine model.
- **Proof follows sketch**: yes — conjugation route: `Γα = D.hom ≫ (D.inv ≫ Γα ≫ C.hom) ≫ C.inv`, then `haveI hconj := base_change_mate_generator_trace`, then `infer_instance`. Syntatically sorry-free but **transitively sorry** through `generator_trace`.
- **notes**: The blueprint note (iter-002, iter-003) correctly describes the formalized signature as the `IsIso` corollary rather than the literal equality. Consistent.

### `\lean{AlgebraicGeometry.base_change_map_affine_local}` (lem:base_change_map_affine_local)
- **Lean target exists**: yes (line 1116)
- **Signature matches**: yes — `IsPullback g' f' f g → [IsAffineHom f] → [F.IsQuasicoherent] → (∀ U, IsIso (map.app U)) → IsIso map`.
- **Proof follows sketch**: yes — one-liner `(isIso_iff_isIso_app_affineOpens ...).mpr H`. Clean, no sorry.
- **notes**: The locality reduction itself is complete. The gap is in how the per-`U` goal is discharged in `affineBaseChange_pushforward_iso`.

### `\lean{AlgebraicGeometry.affineBaseChange_pushforward_iso}` (lem:affine_base_change_pushforward)
- **Lean target exists**: yes (line 1128)
- **Signature matches**: yes — `IsPullback g' f' f g → [IsAffineHom f] → [F.IsQuasicoherent] → IsIso (pushforwardBaseChangeMap f g f' g' h.w F)`.
- **Proof follows sketch**: partial — applies `base_change_map_affine_local` correctly (first reduction). The per-affine-open goal `IsIso ((pushforwardBaseChangeMap ...).app U)` remains open (`sorry` at line 1159): the affine reduction step (identifying `map.app U` with the affine-affine map via restriction-compatibility) is not yet formalized.
- **notes**: **1 sorry** at line 1159. This is the "obligation 1" (affine reduction) of the blueprint's `lem:base_change_map_affine_local` proof: the blueprint describes it as "definitional plus the naturalities (a)-(c)" but the Lean comment characterizes it as a "multi-hundred-LOC build" (restriction-compatibility of `pushforwardBaseChangeMap`). See Blueprint adequacy section.

### `\lean{AlgebraicGeometry.flatBaseChange_pushforward_isIso}` (thm:flat_base_change_pushforward)
- **Lean target exists**: yes (line 1168)
- **Signature matches**: yes — `IsPullback → [Flat g] → [QuasiCompact f] → [QuasiSeparated f] → [F.IsQuasicoherent] → IsIso (pushforwardBaseChangeMap …)`.
- **Proof follows sketch**: no — body is `sorry` (line 1181), with a comment sketch (locality on `S'`, Čech-free equalizer argument, flatness commutes with equalizer via `LinearMap.tensorEqLocusEquiv`).
- **notes**: **1 sorry** at line 1181. The proof strategy in the comment matches the blueprint's Mayer–Vietoris induction. The blueprint proof is detailed; the sorry is due to missing Čech/sheaf-condition equalizer infrastructure.

### `\lean{LinearMap.tensorEqLocusEquiv}` (lem:flat_preserves_equalizer_mathlib)
- **Lean target exists**: yes (Mathlib)
- **Signature matches**: yes (`\mathlibok`).
- **Proof follows sketch**: N/A.
- **notes**: Blueprint correctly marks `\mathlibok`.

---

## Red flags

### Placeholder / suspect bodies

- **`base_change_mate_generator_trace_eq`** (line 1028): `sorry` in the tactic proof body — the three-step mate-trace is unproven. This sorry is directly downstream of the three unformalized sub-lemmas (`unit_value`, `fstar_reindex`, `gstar_transpose`). Pre-signaled in the directive as the prover-reported blocker.

- **`affineBaseChange_pushforward_iso`** (line 1159): `sorry` for the affine reduction (restriction-compatibility of `pushforwardBaseChangeMap`). Not pre-excused by the directive.

- **`flatBaseChange_pushforward_isIso`** (line 1181): `sorry` for the full flat base change proof. Not pre-excused.

- **`base_change_mate_regroupEquiv`** (lines 951, 960): two `sorry`s in the `zero` branches of `TensorProduct.induction_on` — pure `r' • 0 = 0` bookkeeping blocked by opaque `Module R'` instances. **Pre-excused per directive.**

### Missing `\lean{}`-referenced declarations

Three declarations are referenced by `\lean{...}` blocks in the blueprint but are entirely absent from the Lean file:
- `AlgebraicGeometry.base_change_mate_unit_value` (lem:base_change_mate_unit_value)
- `AlgebraicGeometry.base_change_mate_fstar_reindex` (lem:base_change_mate_fstar_reindex)
- `AlgebraicGeometry.base_change_mate_gstar_transpose` (lem:base_change_mate_gstar_transpose)

These were not formalized this iter per the directive. They are the direct blocker for closing `base_change_mate_generator_trace_eq`.

---

## Unreferenced declarations (informational)

All 27 declarations in the Lean file have corresponding `\lean{...}` references in the blueprint. There are no unreferenced declarations.

---

## Blueprint adequacy for this file

### Coverage
27/27 Lean declarations have a corresponding `\lean{...}` block. The 3 missing sub-lemmas have `\lean{...}` blocks in the blueprint but are unformalized on the Lean side — the blueprint side is not missing them, they just weren't dispatched to a prover this iter.

### Proof-sketch depth: **partially under-specified**

**Well-specified (all closed or near-closed declarations):**

The proof sketches for the tilde-dictionary cluster (`pushforward_spec_tilde_iso`, `pullback_spec_tilde_iso`, `gammaPushforwardIso`, etc.) are detailed and sufficient — the Lean proofs follow them faithfully with no mathematical deviation. The route-(b) element-free construction, the `restrictScalarsComp'App` trick, and the open-naturality-as-`rfl` observation are all adequately described.

The blueprint proof of `lem:base_change_mate_regroupEquiv` is adequate for the route-(b) fix (documented in Lean docstring): use `LinearEquiv.toModuleIso (base_change_regroup_linearEquiv ↑M)` from a separately compiled module. The `\uses{lem:base_change_regroup_linearEquiv}` dependency anchor is in place.

**Under-specified (three mate-trace sub-lemmas):**

`lem:base_change_mate_unit_value`, `lem:base_change_mate_fstar_reindex`, and `lem:base_change_mate_gstar_transpose` all have `\lean{...}` hints and clear informal prose but **no `% LEAN SIGNATURE` blocks**. This is a formalization blocker because:

1. *`unit_value`*: The prose says η' "reads through Θ_tgt as m ↦ (1⊗1)⊗m." But the exact Lean statement type is under-determined: is it an equality of morphisms in `ModuleCat R'`? A pointwise identity? An equation involving `Θ_tgt.hom.comp` applied to a specific `functor.map`? The correct form must type-check against `base_change_mate_codomain_read`'s Iso type, which is a composite of several noncomputable defs — without pinning the statement, a prover could produce an incompatible type.

2. *`fstar_reindex`*: The prose describes `f_* = restrictScalars φ` leaving elements unchanged and pseudofunctor reindexing the target. The Lean statement must express this as an equation between morphisms involving `pushforwardComp` and `pushforwardCongr`, but the exact shape of the equation (which side carries Iso arrows vs. morphism equality) is not specified.

3. *`gstar_transpose`*: The prose gives the adjunction-transpose formula `û(r'⊗m) = r'·u(m)`. The exact Lean statement must pin: (a) the specific adjunction (`extendRestrictScalarsAdj` vs. `pullbackPushforwardAdjunction`), (b) whether it is a pointwise identity on module elements or an equality of `homEquiv`-transported morphisms, and (c) which module structures are made explicit.

Without `% LEAN SIGNATURE` blocks, the prover cannot determine whether these sub-lemmas should be stated as:
- Equalities `f = g` in `ModuleCat R'`
- Pointwise equalities `∀ x, f x = g x`
- Commutativity squares `Θ.hom ∘ map = map' ∘ Θ'.hom`
- or `congr` lemmas for `moduleSpecΓFunctor.map`

The fact that the three sub-lemmas must chain cleanly into the `ext x`-reduced goal of `base_change_mate_generator_trace_eq` makes their exact type signatures critical.

**Under-specified for `affineBaseChange_pushforward_iso` (affine reduction step):**

The blueprint proof of `lem:affine_base_change_pushforward` describes the restriction-compatibility step (Steps 1-3 of the proof of `lem:base_change_map_affine_local`) as "definitional plus the naturalities (a)-(c); it introduces no obligation beyond them." The Lean file characterizes this same step as a "multi-hundred-LOC build for the unconditional general theorem" requiring the restriction-compatibility of `pushforwardBaseChangeMap` (which is Mathlib-absent). The blueprint does not have a named sub-lemma with a signature for this step — it treats it as a consequence of "naturality of adjunction transpose + pushforward commutes with restriction." This underestimates the Lean effort significantly.

### Hint precision: **adequate for closed declarations; absent for three sub-lemmas**

All formalized declarations have `\lean{...}` hints that pin the correct declaration name and namespace (`AlgebraicGeometry.*`). No wrong Mathlib predicate errors detected.

For the three missing sub-lemmas, `\lean{}` hints exist (naming the intended declarations) but the precise Lean signature is not pinned. This is the precision failure.

### Generality: **matches need** for all formalized declarations.

### Recommended chapter-side actions

1. **Add `% LEAN SIGNATURE` blocks to all three of:**
   - `lem:base_change_mate_unit_value`
   - `lem:base_change_mate_fstar_reindex`
   - `lem:base_change_mate_gstar_transpose`

   For `unit_value`, the signature should pin that the statement is an equality of morphisms in `ModuleCat R'`, the LHS is `(base_change_mate_codomain_read ψ φ M).hom.comp (moduleSpecΓFunctor.map ((pullbackPushforwardAdjunction (pullback.fst Spec.map φ Spec.map ψ)).unit.app (tilde M)))`, and the RHS is the module map `fun m => ((1 : A) ⊗ₜ (1 : R')) ⊗ₜ[A] m` (with explicit universe and algebra instances).

   For `fstar_reindex`, pin that the statement is a commutativity square involving `pushforwardComp`, `pushforwardCongr`, and the unit assignment.

   For `gstar_transpose`, pin the statement as an element-level equality `(extendRestrictScalarsAdj ψ.hom).homEquiv.toFun u = fun (r' ⊗ m) => r' • u m` with explicit source/target.

2. **Add a named sub-lemma for the affine reduction step** in `affineBaseChange_pushforward_iso`: the restriction-compatibility of `pushforwardBaseChangeMap` (that `(map …).app U = map of the restricted square`) should be isolated as a named lemma with a `% LEAN SIGNATURE` block. The blueprint currently describes it as "definitional plus naturalities" inside the proof of `lem:base_change_map_affine_local`, but the Lean implementation indicates it is a substantial standalone obligation.

---

## Severity summary

| Finding | Severity |
|---|---|
| `base_change_mate_unit_value` absent from Lean (blueprint `\lean{}` unrealized) | **must-fix-this-iter** (blueprint chapter under-specified, prover needs `% LEAN SIGNATURE` before next dispatch) |
| `base_change_mate_fstar_reindex` absent from Lean | **must-fix-this-iter** (same reason) |
| `base_change_mate_gstar_transpose` absent from Lean | **must-fix-this-iter** (same reason) |
| `base_change_mate_generator_trace_eq`: sorry in core per-generator identity (line 1028) | **must-fix-this-iter** (directly blocked by the three missing sub-lemmas above; fixing the sub-lemmas unblocks this) |
| `affineBaseChange_pushforward_iso`: sorry for affine reduction (line 1159); blueprint underestimates Lean effort | **must-fix-this-iter** (sorry on a substantive claim; requires either a named sub-lemma for restriction-compatibility or significant proof work) |
| `flatBaseChange_pushforward_isIso`: sorry for full proof (line 1181) | **must-fix-this-iter** (placeholder body on the project's headline theorem) |
| `base_change_mate_regroupEquiv`: 2 zero-branch sorries (lines 951, 960) | **must-fix-this-iter** (sorry on non-trivial branches) — **pre-excused per directive as known issue; route-(b) fix is documented and blueprint-adequate** |
| Blueprint under-specifies affine-reduction step (no named sub-lemma; blueprint says "definitional" where Lean says "multi-hundred-LOC") | **major** (not a wrong mathematical claim, but a precision gap that will block the next prover) |

**Overall verdict:** The Lean file faithfully formalizes the tilde-dictionary cluster and all support lemmas (27 declarations, 0 unreferenced), with the expected sorry pattern at the three open obligations (`generator_trace_eq`, `affineBaseChange_pushforward_iso`, `flatBaseChange_pushforward_isIso`); the chapter is adequately specified for all closed or near-closed declarations but is critically under-specified for the three mate-trace sub-lemmas (`unit_value`, `fstar_reindex`, `gstar_transpose`) — each needs a `% LEAN SIGNATURE` block before the next prover dispatch can reliably formalize and chain them into `generator_trace_eq`. — 32 declarations checked (27 Lean, 3 Mathlib, 3 absent), 5 non-pre-excused sorry sites.
