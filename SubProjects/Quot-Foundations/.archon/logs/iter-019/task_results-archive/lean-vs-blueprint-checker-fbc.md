# Lean ↔ Blueprint Check Report

## Slug
fbc

## Iteration
018

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.pushforwardBaseChangeMap}` (def:pushforward_base_change_map)
- **Lean target exists**: yes
- **Signature matches**: yes — `(comm : g' ≫ f = f' ≫ g) (F : X.Modules) : pullback g (pushforward f F) ⟶ pushforward f' (pullback g' F)`, matches blueprint's "canonical morphism `g^*(f_*F) → f'_*((g')^*F)`"
- **Proof follows sketch**: yes — definition body is the adjoint-mate construction exactly as described
- **notes**: Clean definition, no sorry.

### `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_stalkFunctor_map}` (lem:modules_isIso_iff_stalk)
- **Lean target exists**: yes (line 102)
- **Signature matches**: yes
- **Proof follows sketch**: yes — forward via `Functor.map_isIso`, converse packages as `TopCat.Sheaf` and applies `isIso_of_stalkFunctor_map_iso`, reflecting back via `isIso_iff_of_reflects_iso`
- **notes**: No sorry. Matches blueprint proof sketch step-by-step.

### `\lean{AlgebraicGeometry.Modules.isIso_of_isIso_app_of_isBasis}` (lem:modules_isIso_of_isBasis)
- **Lean target exists**: yes (line 128)
- **Signature matches**: yes
- **Proof follows sketch**: yes — reduces to stalkwise iso, uses `stalkFunctor_map_injective_of_isBasis` and `germ_exist_of_isBasis` exactly as described
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_app_affineOpens}` (lem:modules_isIso_iff_affineOpens)
- **Lean target exists**: yes (line 164)
- **Signature matches**: yes
- **Proof follows sketch**: yes — instantiates the basis criterion with `X.isBasis_affineOpens`
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.globalSectionsIso_hom_comp_specMap_appTop}` (lem:globalSectionsIso_hom_comp_specMap_appTop)
- **Lean target exists**: yes (line 268)
- **Signature matches**: yes — `(StructureSheaf.globalSectionsIso ↑R).hom ≫ (Spec.map φ).appTop = φ ≫ (StructureSheaf.globalSectionsIso ↑R').hom`
- **Proof follows sketch**: yes — reduces to `ΓSpecIso_inv_naturality.symm`
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.gammaPushforwardIso}` (lem:gammaPushforwardIso)
- **Lean target exists**: yes (line 288)
- **Signature matches**: yes — `Γ_R((Spec φ)_* N) ≅ restrictScalars φ (Γ_{R'} N)`
- **Proof follows sketch**: yes — element-free `restrictScalarsComp'App` + `restrictScalarsCongr` route (b)
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.gammaPushforwardTildeIso}` (lem:gammaPushforwardTildeIso)
- **Lean target exists**: yes (line 313)
- **Signature matches**: yes
- **Proof follows sketch**: yes — specialises `gammaPushforwardIso` and applies `tilde.toTildeΓNatIso`
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.gammaPushforwardIsoAt}` (lem:gammaPushforwardIsoAt)
- **Lean target exists**: yes (line 331)
- **Signature matches**: yes — `Γ((Spec φ)_* N, U) ≅ restrictScalars φ (Γ(N, (Spec φ)⁻¹ U))`
- **Proof follows sketch**: yes — verbatim copy of `gammaPushforwardIso` construction with open changed
- **notes**: No sorry. Blueprint's prose remark on open-naturality (the key that drives the step-iii transport) is present in both the Lean docstring and the blueprint's proof section.

### `\lean{AlgebraicGeometry.fromTildeΓ_app_isIso_of_isLocalizedModule}` (lem:fromTildeGamma_app_isIso_of_localized)
- **Lean target exists**: yes (line 367)
- **Signature matches**: yes
- **Proof follows sketch**: yes — uses `toOpen_fromTildeΓ_app` triangle identity, then `IsLocalizedModule.iso` uniqueness
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso_of_isLocalizedModule}` (lem:pushforward_spec_tilde_iso_conditional)
- **Lean target exists**: yes (line 431)
- **Signature matches**: yes
- **Proof follows sketch**: yes — basis-local criterion + `fromTildeΓ_app_isIso_of_isLocalizedModule` + `gammaPushforwardTildeIso`
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.IsLocalizedModule.powers_restrictScalars}` (lem:powers_restrictScalars)
- **Lean target exists**: yes (line 455)
- **Signature matches**: yes — proves the three localized-module conditions for `f.restrictScalars R` from `IsLocalizedModule (Algebra.algebraMapSubmonoid A S) f`
- **Proof follows sketch**: yes
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.tildeRestriction_isLocalizedModule}` (lem:tildeRestriction_isLocalizedModule)
- **Lean target exists**: yes (line 483)
- **Signature matches**: yes
- **Proof follows sketch**: yes — bijectivity of `toOpen M ⊤` via `powers 1` trivial localization + triangle identity + `of_linearEquiv_right`
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso}` (lem:pushforward_spec_tilde_iso)
- **Lean target exists**: yes (line 538)
- **Signature matches**: yes — `(Spec φ)_*(tilde M) ≅ tilde(restrictScalars φ M)`
- **Proof follows sketch**: yes — the iter-240/241 route via `algebraize` + `algebraMapSubmonoid_powers` + `of_linearEquiv` exactly matches the blueprint's three-movement proof
- **notes**: No sorry. The `hloc` discharge follows the blueprint's movements (1)–(3) precisely.

### `\lean{AlgebraicGeometry.gammaPushforwardNatIso}` (lem:gammaPushforwardNatIso)
- **Lean target exists**: yes (line 667)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `NatIso.ofComponents` with `rfl` naturality
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.pullback_spec_tilde_iso}` (lem:pullback_spec_tilde_iso)
- **Lean target exists**: yes (line 689)
- **Signature matches**: yes — `(Spec φ)^*(tilde M) ≅ tilde(extendScalars φ M)`
- **Proof follows sketch**: yes — uniqueness-of-left-adjoints via `conjugateIsoEquiv` applied to `gammaPushforwardNatIso`
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.pullback_fst_snd_specMap_tensor}` (lem:pullback_fst_snd_specMap_tensor)
- **Lean target exists**: yes (line 709)
- **Signature matches**: yes — conjunction of the two `pullbackSpecIso_inv_fst`/`_inv_snd` identities
- **Proof follows sketch**: yes
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.base_change_mate_domain_read}` (lem:base_change_mate_domain_read)
- **Lean target exists**: yes (line 737)
- **Signature matches**: yes — `Γ_R'(g^*(f_*(tilde M))) ≅ extendScalars ψ (restrictScalars φ M)`
- **Proof follows sketch**: yes — push/pull dictionaries in sequence
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.pullbackIsoEquivalenceOfIso}` (lem:pullbackIsoEquivalenceOfIso)
- **Lean target exists**: yes (line 753)
- **Signature matches**: yes — equivalence with quasi-inverse `pullback (inv f)`
- **Proof follows sketch**: yes — unit/counit from `pullbackId`/`pullbackComp`/`pullbackCongr`
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.pullback_isEquivalence_of_iso}` (lem:pullback_isEquivalence_of_iso)
- **Lean target exists**: yes (line 762, as `instance pullback_isEquivalence_of_iso`)
- **Signature matches**: yes — `(pullback f).IsEquivalence` for `[IsIso f]`
- **Proof follows sketch**: yes
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.base_change_mate_codomain_read}` (lem:base_change_mate_codomain_read)
- **Lean target exists**: yes (line 773)
- **Signature matches**: yes — `Γ_R'(f'_*(g')^*(tilde M)) ≅ restrictScalars includeRight (extendScalars includeLeftRingHom M)`
- **Proof follows sketch**: yes — uses leg identification via `pullback_fst_snd_specMap_tensor`, iso-equivalence unit, push/pull dictionaries
- **notes**: No sorry. The `.1`/`.2` projection trick (vs `obtain`) noted in the Lean comment is for a tactic-level reason (avoids stuck `And.casesOn`); blueprint doesn't need to mention it.

### `\lean{AlgebraicGeometry.base_change_mate_regroupEquiv}` (lem:base_change_mate_regroupEquiv)
- **Lean target exists**: yes (line 856)
- **Signature matches**: yes — `restrictScalars includeRight (extendScalars includeLeftRingHom M) ≅ extendScalars ψ (restrictScalars φ M)`
- **Proof follows sketch**: yes — `comm ≪≫ cancelBaseChange ≪≫ comm` via `LinearEquiv.toModuleIso`, with `eT` bridge resolving the `A`-action diamond
- **notes**: No sorry. Fully proved including `map_smul'` by `TensorProduct.induction_on`.

### `\lean{AlgebraicGeometry.base_change_mate_unit_value}` (lem:base_change_mate_unit_value)
- **Lean target exists**: yes (line 987, with `set_option maxHeartbeats 4000000`)
- **Signature matches**: yes — stated in the blueprint with the explicit Lean signature quoted verbatim
- **Proof follows sketch**: yes — conjugate-unit calculus via `unit_conjugateEquiv_symm`; blueprint describes this correctly as "the abstract conjugate-unit coherence"
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.base_change_mate_inner_value}` (def:base_change_mate_inner_value)
- **Lean target exists**: yes (line 1102, as `noncomputable def`)
- **Signature matches**: yes — `restrictScalars φ M ⟶ restrictScalars ψ (restrictScalars inclR' (extendScalars inclA M))`, the `R`-linear map `m ↦ (1⊗1)⊗m`
- **Proof follows sketch**: yes — `restrictScalars φ` of the algebraic unit transported by `restrictScalarsComp'App`/`restrictScalarsCongr`
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.pullbackPushforward_unit_comp}` (lem:pullbackPushforward_unit_comp)
- **Lean target exists**: yes (line 1144)
- **Signature matches**: yes — the pseudofunctoriality identity
- **Proof follows sketch**: yes — applies `unit_conjugateEquiv` + `conjugateEquiv_pullbackComp_inv` + `comp_unit_app` exactly as the blueprint describes
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.gammaMap_pushforwardComp_hom_eq_id}` (lem:gammaMap_pushforwardComp_hom_eq_id)
- **Lean target exists**: yes (line 1174, marked `private`)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: No sorry. Declaration is `private` — the `\lean{AlgebraicGeometry.gammaMap_pushforwardComp_hom_eq_id}` hint in the blueprint names the qualified form but the declaration is actually inaccessible from outside the file under that name.

### `\lean{AlgebraicGeometry.gammaMap_pushforwardComp_inv_eq_id}` (lem:gammaMap_pushforwardComp_inv_eq_id)
- **Lean target exists**: yes (line 1182, marked `private`)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: Same `private` caveat as above.

### `\lean{AlgebraicGeometry.gammaMap_pushforwardCongr_hom}` (lem:gammaMap_pushforwardCongr_hom)
- **Lean target exists**: yes (line 1193, marked `private`)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `subst hfg`, `simp`
- **notes**: Same `private` caveat.

### `\lean{AlgebraicGeometry.base_change_mate_codomain_read_legs}` (lem:base_change_mate_codomain_read_legs)
- **Lean target exists**: yes (line 1210)
- **Signature matches**: yes — universally quantified over legs `g' f'` with cone-leg hypotheses `hfst`/`hsnd`
- **Proof follows sketch**: yes — verbatim construction of `base_change_mate_codomain_read`
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs}` (lem:base_change_mate_fstar_reindex_legs)
- **Lean target exists**: yes (line 1270, with `set_option maxHeartbeats 1600000`)
- **Signature matches**: yes — universally quantified over legs + commutativity hypothesis
- **Proof follows sketch**: **partial** — steps (i) and (ii) are fully executed (`subst hfst; subst hsnd`, Γ-collapse via `simp only [gammaMap_pushforwardComp_inv_eq_id, gammaMap_pushforwardCongr_hom]`, `rw [he, hinclA] at key`). Step (iii) is the outstanding `sorry` at line 1347.
- **notes**: **Expected/gated sorry** (the Seam-2 step-iii telescoping crux). The iter-018 Lean change adds `rw [he, hinclA] at key` which converts the leg-reindex lemma from `e`/`inclA` form to literal form so it can match the goal after `subst`.

### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex}` (lem:base_change_mate_fstar_reindex)
- **Lean target exists**: yes (line 1361)
- **Signature matches**: yes — the concrete instantiation at `g' = pullback.fst`, `f' = pullback.snd`
- **Proof follows sketch**: yes — `exact base_change_mate_fstar_reindex_legs … hfst hsnd …`; sorry-dependent via `_legs`
- **notes**: No direct sorry; carries the step-iii sorry transitively.

### `\lean{AlgebraicGeometry.base_change_mate_gstar_transpose}` (lem:base_change_mate_gstar_transpose)
- **Lean target exists**: yes (line 1416)
- **Signature matches**: yes — `Θ_src⁻¹ ≫ Γ(g^*(inner) ≫ ε_g) ≫ Θ_tgt = regroupEquiv.inv`
- **Proof follows sketch**: partial — `rw [Functor.map_comp]` (counit split step) is executed. The remaining crux (pullback-dictionary coherence / composed-adjunction counit-triangle) is the `sorry` at line 1451.
- **notes**: **Expected/gated sorry** (Seam 3 crux). Blueprint correctly identifies the required step as the counit-triangle identity for the composed adjunction, but doesn't specify the tactic route.

### `\lean{AlgebraicGeometry.base_change_mate_section_identity}` (lem:base_change_mate_section_identity)
- **Lean target exists**: yes (line 1476)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `unfold pushforwardBaseChangeMap; rw [Adjunction.homEquiv_counit]; exact base_change_mate_gstar_transpose ψ φ M`. Sorry-dependent.
- **notes**: One-line corollary of Seam 3 as described in the blueprint.

### `\lean{AlgebraicGeometry.base_change_mate_generator_trace}` (lem:base_change_mate_generator_trace)
- **Lean target exists**: yes (line 1505)
- **Signature matches**: yes — `IsIso(Θ_src⁻¹ ≫ Γ(α) ≫ Θ_tgt)`
- **Proof follows sketch**: yes — `rw [base_change_mate_section_identity]; infer_instance`. Sorry-dependent.
- **notes**: One-line corollary of the section identity as described in the blueprint.

### `\lean{AlgebraicGeometry.pushforward_base_change_mate_cancelBaseChange}` (lem:pushforward_base_change_mate_cancelBaseChange)
- **Lean target exists**: yes (line 1542)
- **Signature matches**: yes — `IsIso(Γ(pushforwardBaseChangeMap …))`
- **Proof follows sketch**: yes — conjugation assembly via `base_change_mate_generator_trace` + `simp [Category.assoc]`. Sorry-dependent.
- **notes**: No direct sorry; sorry-dependent via generator trace chain.

### `\lean{AlgebraicGeometry.base_change_map_affine_local}` (lem:base_change_map_affine_local)
- **Lean target exists**: yes (line 1581)
- **Signature matches**: yes — one-liner applying `Modules.isIso_iff_isIso_app_affineOpens`
- **Proof follows sketch**: yes
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.affineBaseChange_pushforward_iso}` (lem:affine_base_change_pushforward)
- **Lean target exists**: yes (line 1593)
- **Signature matches**: yes — `IsPullback g' f' f g → [IsAffineHom f] → [F.IsQuasicoherent] → IsIso(pushforwardBaseChangeMap …)`
- **Proof follows sketch**: partial — `apply base_change_map_affine_local` (locality reduction step) executed. The affine reduction step (restricting the cartesian square over each affine open to the affine–affine model) is the `sorry` at line 1624.
- **notes**: **Expected/gated sorry**. The affine-reduction (restriction-compatibility of `pushforwardBaseChangeMap`) is the multi-hundred-LOC build noted in the blueprint comment.

### `\lean{AlgebraicGeometry.flatBaseChange_pushforward_isIso}` (thm:flat_base_change_pushforward)
- **Lean target exists**: yes (line 1633)
- **Signature matches**: yes — `[Flat g] → [QuasiCompact f] → [QuasiSeparated f] → [F.IsQuasicoherent] → IsIso(pushforwardBaseChangeMap …)`
- **Proof follows sketch**: N/A (whole body is a sorry with the Čech strategy comment)
- **notes**: **Expected/gated sorry**. Needs Čech/affine-cover infrastructure for `SheafOfModules`, deferred to a later iteration per the blueprint note.

---

## Red flags

### Placeholder / suspect bodies

- `base_change_mate_fstar_reindex_legs` (line 1347): `:= sorry` for the step-iii telescoping crux. **Expected/gated** — annotated in the directive's Known Issues and in detailed Lean comments.
- `base_change_mate_gstar_transpose` (line 1451): `:= sorry` for the Seam-3 pullback-dictionary coherence. **Expected/gated**.
- `affineBaseChange_pushforward_iso` (line 1624): `:= sorry` for the affine-reduction / restriction-compatibility step. **Expected/gated**.
- `flatBaseChange_pushforward_isIso` (line 1646): `:= sorry`, entire proof deferred. **Expected/gated**.

All four sorries are explicitly called out in the directive's Known Issues. None carry excuse-comments; all have detailed explanatory scaffold comments describing what needs to be proved.

### Excuse-comments

None. The `-- REMAINING CRUX` and `-- PARTIAL` comments in the sorry-bearing proofs are explanatory scaffold notes (naming the remaining obligation), not excuse-comments in the problematic sense.

### Axioms / Classical.choice on non-trivial claims

None found.

---

## Unreferenced declarations (informational)

All substantive declarations in the Lean file have a corresponding `\lean{...}` reference in the blueprint. The three `private` lemmas (`gammaMap_pushforwardComp_hom_eq_id`, `gammaMap_pushforwardComp_inv_eq_id`, `gammaMap_pushforwardCongr_hom`) are referenced in the blueprint with their qualified names. Because they are `private`, the qualified `AlgebraicGeometry.*` names used in the `\lean{...}` hints are not the actual canonical Lean names (which are mangled/inaccessible). This is a minor cosmetic inconsistency — the mathematical intent is clear and the declarations are correctly identified.

---

## Blueprint adequacy for this file

### Coverage
37/37 Lean declarations (including `\mathlibok` anchors) have corresponding `\lean{...}` blocks in the chapter. 0 substantive unreferenced declarations.

### Proof-sketch depth
**Adequate overall, with one major gap for step-iii.**

- For the fully-proved declarations (everything up to and including `base_change_mate_unit_value` and `base_change_mate_codomain_read_legs`): proof sketches are at the right level of detail and match the Lean proofs.
- For Seam 2 step-iii (`base_change_mate_fstar_reindex_legs`): the blueprint step-iii prose says "the e-unit is invertible, hence an isomorphism absorbed into the codomain identification Θ_tgt" and "the reduction of the e-unit to an isomorphism absorbed into the codomain read is the mate-unwinding crux." The Lean comment (iter-018) reveals that:
  1. After `subst hfst/hsnd`, the goal's legs are LOCKED in the literal `(pullbackSpecIso).hom ≫ Spec.map includeLeft...` form, and `key = pullbackPushforward_unit_comp e.hom (Spec.map inclA) (tilde M)` does NOT match the goal as produced; it needs `rw [he, hinclA] at key` to convert to literal form.
  2. The resulting ~150-LOC cancellation — inverting `key` to expand `η_{g'}`, then cancelling `(Spec ιA)_*(η_e)` against `unit_iso.symm` inside `base_change_mate_codomain_read_legs`, and `g'_*(pullbackComp.hom)` against `pullbackComp(e,inclA).symm` inside `iso_g` — is not described in the blueprint's step-iii.
  
  The blueprint names the correct mathematical content but doesn't capture the literal-form conversion issue or the specific cancellation pattern. A prover working from the blueprint alone would not have the tactic insight that the `subst`-locked literal legs require `key` to be explicitly rewritten.

- For Seam 3 (`base_change_mate_gstar_transpose`): the blueprint proof sketch (counit split, conjugation via composed-adjunction counit-triangle identity) is correct and names the right ingredients (`gammaPushforwardNatIso`, `unit_conjugateEquiv`). The "how to execute the conjugation" is left to the prover but is at the standard level of blueprint abstraction.

### Hint precision
**Precise.** All `\lean{...}` hints name the correct Lean declarations. The `\mathlibok` hints name the correct Mathlib declarations. The three `private` lemma names are a cosmetic issue (see Unreferenced section) but the mathematical targets are identified correctly.

### Generality
**Matches need.** No generality mismatch found.

### Recommended chapter-side actions

1. **(Major — for step-iii closure)** In the proof of `lem:base_change_mate_fstar_reindex_legs`, expand step (iii) to document the iter-018 finding:
   - After `subst hfst; subst hsnd`, the legs are locked in literal form; the leg-reindex engine `key` (in `e`/`inclA` abbreviation form) must be converted to literal form before it can match the goal.
   - The cancellation pattern: `key` is inverted to express `η_{g'}` in terms of the affine unit; the trailing `(Spec ιA)_*(η_e)` and `g'_*(pullbackComp.hom)` factors cancel against `unit_iso.symm` and `pullbackComp(e, inclA).symm` respectively inside the construction of `base_change_mate_codomain_read_legs`.
   - Approximate size: ~150-LOC telescoping. Naming the factors explicitly in the blueprint would give the prover a map for the cancellation.

2. **(Minor)** Update the three `private` lemma `\lean{...}` hints to reflect their `private` status — either note they are project-internal helpers accessed by name within the file, or add a `% NOTE:` that the names in the hint are informal identifiers.

---

## Severity summary

- **must-fix-this-iter**: None. All sorries are expected/gated per the directive's Known Issues. All signatures match. No excuse-comments. No axioms on unauthorized claims.
- **major**: Blueprint adequacy gap for step-iii in `lem:base_change_mate_fstar_reindex_legs` — the literal-form conversion insight (`rw [he, hinclA] at key`) and the specific ~150-LOC cancellation pattern are not captured in the blueprint prose. A future prover attempting to close this sorry from the blueprint alone would lack the critical tactic insight discovered in iter-018.
- **minor**: Three `private` lemmas referenced via qualified names in `\lean{...}` hints (those names are not the actual Lean identifiers).

**Overall verdict:** The Lean file and blueprint are faithful to each other across all 37 declarations — signatures match, `\leanok` markers are correctly set, no wrong definitions or unauthorized axioms. The four expected/gated sorries are properly disclosed. The chapter has a major adequacy gap for the Seam-2 step-iii telescoping mechanism (literal-form conversion and cancellation pattern), discovered in iter-018, which the blueprint-writing subagent should address to guide the next prover toward closing that sorry.
