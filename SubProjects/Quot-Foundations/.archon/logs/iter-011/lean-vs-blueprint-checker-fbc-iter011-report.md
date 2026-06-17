# Lean ↔ Blueprint Check Report

## Slug
fbc-iter011

## Iteration
011

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.pushforwardBaseChangeMap}` (chapter: `def:pushforward_base_change_map`)
- **Lean target exists**: yes (line 79)
- **Signature matches**: yes — `g^*(f_* F) ⟶ f'_*((g')^* F)` built as adjunction-transpose of `f_*(unit)` composed with pseudofunctoriality isos; matches blueprint definition verbatim
- **Proof follows sketch**: yes — term-mode construction matches blueprint description
- **notes**: `\leanok` on statement in blueprint; no proof block in blueprint (definition, not theorem) — appropriate

### `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_stalkFunctor_map}` (chapter: `lem:modules_isIso_iff_stalk`)
- **Lean target exists**: yes (line 102)
- **Signature matches**: yes — `IsIso φ ↔ ∀ x, IsIso (stalkFunctor.map (toPresheaf.map φ))`
- **Proof follows sketch**: yes — forward: functor preserves isos; backward: package as `TopCat.Sheaf`, apply stalkwise criterion, reflect iso
- **notes**: `\leanok` on both statement and proof blocks ✓

### `\lean{AlgebraicGeometry.Modules.isIso_of_isIso_app_of_isBasis}` (chapter: `lem:modules_isIso_of_isBasis`)
- **Lean target exists**: yes (line 128)
- **Signature matches**: yes
- **Proof follows sketch**: yes — reduces to stalkwise via `isIso_iff_isIso_stalkFunctor_map`; injectivity and surjectivity from basis
- **notes**: `\leanok` on both blocks ✓

### `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_app_affineOpens}` (chapter: `lem:modules_isIso_iff_affineOpens`)
- **Lean target exists**: yes (line 164)
- **Signature matches**: yes
- **Proof follows sketch**: yes — special case of basis-local criterion with affine opens as basis
- **notes**: `\leanok` on both blocks ✓

### `\lean{AlgebraicGeometry.globalSectionsIso_hom_comp_specMap_appTop}` (chapter: `lem:globalSectionsIso_hom_comp_specMap_appTop`)
- **Lean target exists**: yes (line 268)
- **Signature matches**: yes — `gsR.hom ≫ (Spec.map φ).appTop = φ ≫ gsR'.hom`
- **Proof follows sketch**: yes — `ΓSpecIso_inv_naturality`
- **notes**: `\leanok` on both blocks ✓

### `\lean{AlgebraicGeometry.gammaPushforwardIso}` (chapter: `lem:gammaPushforwardIso`)
- **Lean target exists**: yes (line 288)
- **Signature matches**: yes
- **Proof follows sketch**: yes — element-free route (b): `restrictScalarsComp'App` × 2 + `eqToIso`
- **notes**: `\leanok` on both blocks ✓

### `\lean{AlgebraicGeometry.gammaPushforwardTildeIso}` (chapter: `lem:gammaPushforwardTildeIso`)
- **Lean target exists**: yes (line 313)
- **Signature matches**: yes
- **Proof follows sketch**: yes — specialise `gammaPushforwardIso` to `N = tilde M` and compose with `toTildeΓNatIso`
- **notes**: `\leanok` on both blocks ✓

### `\lean{AlgebraicGeometry.gammaPushforwardIsoAt}` (chapter: `lem:gammaPushforwardIsoAt`)
- **Lean target exists**: yes (line 331)
- **Signature matches**: yes — open-indexed version `Γ((Spec φ)_* N, U) ≅ restrictScalars φ (Γ(N, (Spec φ)⁻¹ U))`
- **Proof follows sketch**: yes — identical construction to `gammaPushforwardIso` with `U` in place of `⊤`
- **notes**: `\leanok` on both blocks ✓

### `\lean{AlgebraicGeometry.tildeRestriction_isLocalizedModule}` (chapter: `lem:tildeRestriction_isLocalizedModule`)
- **Lean target exists**: yes (line 483)
- **Signature matches**: yes
- **Proof follows sketch**: yes — triangle identity + bijectivity of `toOpen M ⊤`
- **notes**: `\leanok` on both blocks ✓

### `\lean{AlgebraicGeometry.IsLocalizedModule.powers_restrictScalars}` (chapter: `lem:powers_restrictScalars`)
- **Lean target exists**: yes (line 455)
- **Signature matches**: yes — converse of `IsLocalizedModule.of_restrictScalars`
- **Proof follows sketch**: yes — checks three conditions; uses `algebraMapSubmonoid` identification
- **notes**: `\leanok` on both blocks ✓

### `\lean{AlgebraicGeometry.fromTildeΓ_app_isIso_of_isLocalizedModule}` (chapter: `lem:fromTildeGamma_app_isIso_of_localized`)
- **Lean target exists**: yes (line 367)
- **Signature matches**: yes
- **Proof follows sketch**: yes — triangle identity, uniqueness of localized modules, `IsLocalizedModule.ext`
- **notes**: `\leanok` on both blocks ✓

### `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso_of_isLocalizedModule}` (chapter: `lem:pushforward_spec_tilde_iso_conditional`)
- **Lean target exists**: yes (line 431)
- **Signature matches**: yes
- **Proof follows sketch**: yes — basis-local criterion + `fromTildeΓ_app_isIso_of_isLocalizedModule`; compose with `gammaPushforwardTildeIso`
- **notes**: `\leanok` on both blocks ✓

### `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso}` (chapter: `lem:pushforward_spec_tilde_iso`)
- **Lean target exists**: yes (line 538)
- **Signature matches**: yes — `(Spec φ)_*(tilde M) ≅ tilde (restrictScalars φ M)`
- **Proof follows sketch**: yes — the three-movement proof (D(a)-level iso, naturality square, transport via `powers_restrictScalars`) is formalized exactly
- **notes**: `\leanok` on both blocks ✓; proof is the longest in the file and follows the blueprint's three-movement outline faithfully

### `\lean{AlgebraicGeometry.gammaPushforwardNatIso}` (chapter: `lem:gammaPushforwardNatIso`)
- **Lean target exists**: yes (line 667)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `NatIso.ofComponents`; naturality is pointwise `rfl`
- **notes**: `\leanok` on both blocks ✓

### `\lean{AlgebraicGeometry.pullback_spec_tilde_iso}` (chapter: `lem:pullback_spec_tilde_iso`)
- **Lean target exists**: yes (line 689)
- **Signature matches**: yes — `(Spec φ)^*(tilde M) ≅ tilde (extendScalars φ M)`
- **Proof follows sketch**: yes — uniqueness-of-left-adjoints via `conjugateIsoEquiv` and `gammaPushforwardNatIso`
- **notes**: `\leanok` on both blocks ✓

### `\lean{AlgebraicGeometry.pullback_fst_snd_specMap_tensor}` (chapter: `lem:pullback_fst_snd_specMap_tensor`)
- **Lean target exists**: yes (line 709)
- **Signature matches**: yes — conjunction of `pullbackSpecIso_inv_fst` and `pullbackSpecIso_inv_snd` forms
- **Proof follows sketch**: yes — direct application of Mathlib companions with definitional bridge
- **notes**: `\leanok` on both blocks ✓

### `\lean{AlgebraicGeometry.base_change_mate_domain_read}` (chapter: `lem:base_change_mate_domain_read`)
- **Lean target exists**: yes (line 737)
- **Signature matches**: yes
- **Proof follows sketch**: yes — pushforward dict then pullback dict, no leg identification needed
- **notes**: `\leanok` on both blocks ✓

### `\lean{AlgebraicGeometry.pullbackIsoEquivalenceOfIso}` (chapter: `lem:pullbackIsoEquivalenceOfIso`)
- **Lean target exists**: yes (line 753)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `Equivalence.mk` with pullback pseudofunctor coherences
- **notes**: `\leanok` on both blocks ✓

### `\lean{AlgebraicGeometry.pullback_isEquivalence_of_iso}` (`instance`, chapter: `lem:pullback_isEquivalence_of_iso`)
- **Lean target exists**: yes (line 762, declared as `instance`)
- **Signature matches**: yes
- **Proof follows sketch**: yes — corollary of `pullbackIsoEquivalenceOfIso`
- **notes**: `\leanok` on both blocks ✓

### `\lean{AlgebraicGeometry.base_change_mate_codomain_read}` (chapter: `lem:base_change_mate_codomain_read`)
- **Lean target exists**: yes (line 773)
- **Signature matches**: yes — codomain reads as `(A ⊗_R R') ⊗_A M` via leg identification
- **Proof follows sketch**: yes — `pullback_fst_snd_specMap_tensor` then two affine dicts; uses `pullback_isEquivalence_of_iso` for the unit iso
- **notes**: `\leanok` on both blocks ✓

### `\lean{AlgebraicGeometry.base_change_mate_regroupEquiv}` (chapter: `lem:base_change_mate_regroupEquiv`) — **iter-011 focus**
- **Lean target exists**: yes (line 852)
- **Signature matches**: yes — `restrictScalars (includeRight) (extendScalars (includeLeftRingHom) M) ≅ extendScalars ψ (restrictScalars φ M)`; tensor-order convention note in blueprint aligns with `A ⊗[R] R'` Lean orientation ✓
- **Proof follows sketch**: **partial** — the mathematical result is correct and sorry-free, but the proof path diverges from the blueprint's stated decomposition (see Red Flags §)
- **notes**: Blueprint proof says the `R'`-linear equivalence is "supplied by the standalone geometry-free helper `lem:base_change_regroup_linearEquiv`", with the `A`-action diamond resolved by an identity bridge `eT`. The actual Lean proof does use an `eT` bridge but does NOT call `base_change_regroup_linearEquiv` — it discharges `map_smul'` by `TensorProduct.induction_on` inline. The Lean docstring explains the blocker: `Algebra.IsPushout.cancelBaseChange` (the route the helper wraps) is blocked by the diamond at the `exact`/ascription boundary. `\leanok` is correct in both blueprint blocks (decl is sorry-free).

### `\lean{AlgebraicGeometry.base_change_mate_section_identity}` (chapter: `lem:base_change_mate_section_identity`) — **iter-011 focus, renamed**
- **Lean target exists**: yes (line 984, renamed from `base_change_mate_generator_trace_eq`)
- **Signature matches**: yes — exact match with the blueprint's `% LEAN SIGNATURE` comment (lines 1397–1411 of the chapter):
  ```
  (base_change_mate_domain_read ψ φ M).inv ≫
    (moduleSpecΓFunctor R').map (pushforwardBaseChangeMap …) ≫
    (base_change_mate_codomain_read ψ φ M).hom
    = (base_change_mate_regroupEquiv ψ φ M).inv
  ```
- **Proof follows sketch**: N/A — proof body has a single `sorry` at the per-generator node; the blueprint proof is not formalized
- **notes**: Blueprint statement block has `\leanok` (decl with sorry present) ✓; proof block has no `\leanok` (consistent with sorry) ✓. Docstring is honest (see below).

### `\lean{AlgebraicGeometry.base_change_mate_generator_trace}` (chapter: `lem:base_change_mate_generator_trace`)
- **Lean target exists**: yes (line 1023)
- **Signature matches**: yes — `IsIso (Θ_src⁻¹ ≫ Γ(α) ≫ Θ_tgt)` corollary form, matching the `% NOTE` in the blueprint
- **Proof follows sketch**: yes — one-line `rw [base_change_mate_section_identity]; infer_instance`, exactly as the blueprint `% NOTE` describes
- **notes**: `\leanok` on both blocks ✓

### `\lean{AlgebraicGeometry.pushforward_base_change_mate_cancelBaseChange}` (chapter: `lem:pushforward_base_change_mate_cancelBaseChange`)
- **Lean target exists**: yes (line 1060)
- **Signature matches**: yes — `IsIso (Γ(α))` corollary form as described in blueprint's `% NOTE (iter-002)`
- **Proof follows sketch**: yes — conjugation chain `D.hom ≫ (D.inv ≫ Γα ≫ C.hom) ≫ C.inv`, using `base_change_mate_generator_trace` for the conjugate
- **notes**: `\leanok` on both blocks ✓; the sorry chain propagates through `base_change_mate_section_identity → base_change_mate_generator_trace → pushforward_base_change_mate_cancelBaseChange`; each layer is properly wrapped and `\leanok`-marked (statement only) correctly

### `\lean{AlgebraicGeometry.base_change_map_affine_local}` (chapter: `lem:base_change_map_affine_local`)
- **Lean target exists**: yes (line 1099)
- **Signature matches**: yes — locality reduction `(∀ U, IsIso(…app U)) → IsIso(…)`
- **Proof follows sketch**: yes — one-line application of `Modules.isIso_iff_isIso_app_affineOpens`
- **notes**: `\leanok` on both blocks ✓

### `\lean{AlgebraicGeometry.affineBaseChange_pushforward_iso}` (chapter: `lem:affine_base_change_pushforward`)
- **Lean target exists**: yes (line 1111)
- **Signature matches**: yes — `IsPullback g' f' f g → [IsAffineHom f] → [F.IsQuasicoherent] → IsIso (pushforwardBaseChangeMap …)`
- **Proof follows sketch**: partial — the first step (apply locality criterion + `base_change_map_affine_local`) is done; the `sorry` covers the affine reduction proper (restriction-compatibility of `pushforwardBaseChangeMap` over affine charts), which the blueprint describes as "Step 2" of the proof
- **notes**: Blueprint statement block has `\leanok` ✓; proof block has no `\leanok` ✓ (sorry present). Docstring is honest (see below).

### `\lean{AlgebraicGeometry.flatBaseChange_pushforward_isIso}` (chapter: `thm:flat_base_change_pushforward`)
- **Lean target exists**: yes (line 1151)
- **Signature matches**: yes — `[Flat g] → [QuasiCompact f] → [QuasiSeparated f] → [F.IsQuasicoherent] → IsIso (…)`
- **Proof follows sketch**: N/A — proof is entirely `sorry`; blueprint proof is detailed Mayer–Vietoris induction sketch, marked out-of-scope
- **notes**: Blueprint statement block has `\leanok` ✓; proof block has no `\leanok` ✓. Docstring is honest: "deferred to a later iteration... Needs the (missing) Čech-cohomology / affine-cover infrastructure."

---

## Red Flags

### Placeholder / suspect bodies

- `base_change_mate_section_identity` (line 1011): body closes with `:= sorry` after `ext x`. The sorry is at the per-generator mate-unwinding node. **The declaration's statement is substantive** (it is what the affine close depends on via `base_change_mate_generator_trace`), and the blueprint correctly marks the statement with `\leanok` but not the proof — so this is accurately tracked. The sorry is not hidden.

- `affineBaseChange_pushforward_iso` (line 1142): proof body closes with `sorry` after the locality reduction. The sorry covers the affine-reduction step (restricting `pushforwardBaseChangeMap` over an affine chart), documented as Mathlib-absent multi-hundred-LOC work.

- `flatBaseChange_pushforward_isIso` (line 1164): proof body is entirely `sorry`. Out-of-scope for this iter.

None of the above are "overclaiming" sorries — each is in a declaration where the blueprint's proof block has no `\leanok`.

### Proof-path divergence in `base_change_mate_regroupEquiv`

The blueprint proof of `lem:base_change_mate_regroupEquiv` (lines 1318–1363) states:

> "The underlying R'-linear equivalence is supplied, already as a bundled LinearEquiv over R', by the standalone geometry-free helper Lemma~\ref{lem:base_change_regroup_linearEquiv}, whose construction is now the natively R'-linear pushout-cancellation equivalence `Algebra.IsPushout.cancelBaseChange`."

This describes a proof that calls `base_change_regroup_linearEquiv` (from `RegroupHelper.lean`) as a sub-lemma. The actual Lean proof does **not** call `base_change_regroup_linearEquiv` anywhere. The function `base_change_regroup_linearEquiv` is imported (via `import AlgebraicJacobian.Cohomology.RegroupHelper`) but is absent from the proof body.

The Lean docstring explains the blocker: the natively-`R'`-linear `Algebra.IsPushout.cancelBaseChange` route is "blocked by the same `A`-action diamond at the `exact`/ascription boundary." The proof instead discharges `map_smul'` by `TensorProduct.induction_on` inline, with explicit `erw` / `change` / `congrArg` handling of the zero and `tmul` cases.

Both approaches produce the same `R'`-linear iso and both are sorry-free. The mathematical content matches. But the proof path described in the blueprint does not match the actual Lean proof.

### Excuse-comments (none)
No comments of the form "wrong but works", "temporary", "placeholder" were found. All sorry-bearing declarations have honest documentation.

---

## Unreferenced declarations (informational)

All 23 project-local declarations in `FlatBaseChange.lean` have corresponding `\lean{...}` references in the blueprint chapter or in the cross-chapter `Cohomology_RegroupHelper.tex`. No substantive declaration is unreferenced.

- The lengthy `STATUS` comments embedded in the docstrings of `pushforward_spec_tilde_iso` and `base_change_mate_regroupEquiv` are documentation artifacts from prior iterations. They do not introduce new declarations or `sorry`s.

---

## Blueprint adequacy for this file

- **Coverage**: 23/23 project-local declarations have a corresponding `\lean{...}` block in the chapter (directly or via the companion `Cohomology_RegroupHelper.tex`). Helper count: 0 unattached substantive declarations.
- **Proof-sketch depth**: **under-specified** for one block. See below.
- **Hint precision**: **precise** — every `\lean{...}` hint names the correct declaration and matches the formalized signature. The tensor-order convention note on `lem:base_change_mate_regroupEquiv` accurately records the `A ⊗[R] R'` vs. `R' ⊗[R] A` orientation difference.
- **Generality**: matches need

### Under-specification: `lem:base_change_mate_section_identity`

The blueprint proof (lines 1439–1478) describes the mathematical argument correctly:
1. By `R'`-linear hom-extensionality, check on generators `1 ⊗ m`.
2. "By construction, `Γ(θ)` read through the two tilde dictionaries is `LinearMap.lTensor R' η_M`; on `1 ⊗ x` it returns `(1 ⊗ 1) ⊗ x`."
3. This matches `regroup⁻¹` on generators.

Step 2 contains the entire proof obligation that remains — the **mate-unwinding coherence**: how to formally trace `(moduleSpecΓFunctor R').map (pushforwardBaseChangeMap (Spec.map φ) (Spec.map ψ) pullback.snd pullback.fst …)` through the definitions of `pushforwardBaseChangeMap` (an adjunction transpose) and the two reads `Θ_src`, `Θ_tgt`. The blueprint says "by construction" without providing:
- How `moduleSpecΓFunctor.map` of the adjunction transpose interacts with the unit of the `((g')^*, (g')_*)`-adjunction
- What specific Lean lemmas name the relevant naturality squares
- How the concrete pullback legs `pullback.fst`/`pullback.snd` interact with the tilde dictionaries after `pullback_fst_snd_specMap_tensor`

The Lean sorry comment (lines 998–1010) identifies this gap precisely: "The residual mate-unwinding coherence over the generic pullback square `pullback (Spec.map φ) (Spec.map ψ)` is Mathlib-absent; it is the single outstanding obligation." The blueprint provides the correct destination but not the route.

**Recommended chapter-side action**: Expand the proof sketch for `lem:base_change_mate_section_identity` with explicit movements tracing `moduleSpecΓFunctor.map (pushforwardBaseChangeMap …)` through the adjunction-transpose definition and the two dictionary isos. In particular, state which step uses the interaction of `pullbackPushforwardAdjunction.unit` with `moduleSpecΓFunctor`, and how `pullback_fst_snd_specMap_tensor` bridges the generic legs to the `Spec`-of-tensor-inclusions form needed by the dictionaries.

### Under-specification: `lem:base_change_mate_regroupEquiv` proof

The blueprint's stated proof path (calling `base_change_regroup_linearEquiv`) is blocked in the actual formalization. The blueprint should be updated to reflect the inline-induction route, noting the diamond blocker and the `TensorProduct.induction_on` approach, so that future provers understand why the one-liner does not work.

---

## Severity summary

**Must-fix-this-iter**: none.

**Major findings**:

1. **Proof-path divergence in `base_change_mate_regroupEquiv`** (`lem:base_change_mate_regroupEquiv`): the blueprint proof states the `R'`-linear equivalence is supplied by `base_change_regroup_linearEquiv`, but the Lean proof builds it inline (the helper is imported but never called). The mathematical result is correct and sorry-free; the blueprint description of the proof is misleading. A blueprint-writing pass should update the proof sketch to reflect the actual inline-induction route and document the diamond blocker.

2. **Section-identity proof sketch under-specified** (`lem:base_change_mate_section_identity`): the blueprint correctly identifies that the conjugated map equals `regroup⁻¹`, but provides no formalization path for the mate-unwinding coherence that remains as a `sorry`. A blueprint-writing pass should expand the proof sketch with concrete movements for tracing `Γ(pushforwardBaseChangeMap)` through the adjunction transpose and the two tilde-dictionary isos.

**Minor findings**: none beyond the two majors above.

**Overall verdict**: `fbc-iter011` is technically sound — the `base_change_mate_regroupEquiv` rebuild is sorry-free and `base_change_mate_section_identity` correctly captures the blueprint's section-identity framing, with the remaining `sorry` and both downstream sorries honestly documented — but two major blueprint-adequacy issues exist: the proof sketch for `base_change_mate_regroupEquiv` describes a route that was blocked and not taken, and the section-identity proof sketch is too thin to guide closing the crux `sorry`.
