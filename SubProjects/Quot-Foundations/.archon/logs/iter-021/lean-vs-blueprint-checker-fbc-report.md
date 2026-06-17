# Lean ↔ Blueprint Check Report

## Slug
fbc

## Iteration
021

## Files audited
- Lean: `/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean`
- Blueprint: `/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Cohomology_FlatBaseChange.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.pushforwardBaseChangeMap}` (chapter: `def:pushforward_base_change_map`)
- **Lean target exists**: yes (line 79)
- **Signature matches**: yes — `g^*(f_* F) ⟶ f'_*((g')^* F)` via the `(g^*, g_*)`-adjunction transpose; type matches prose.
- **Proof follows sketch**: yes — body is `((pullbackPushforwardAdjunction g).homEquiv _ _).symm (...unit ≫ pushforwardComp ≫ pushforwardCongr ≫ pushforwardComp.inv...)`, matching the blueprint's "adjoint to the pushforward of the unit" description.
- **notes**: `\leanok` on statement; `\leanok` on proof block. No sorry. Clean.

### `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_stalkFunctor_map}` (`lem:modules_isIso_iff_stalk`)
- **Lean target exists**: yes (line 102)
- **Signature matches**: yes
- **Proof follows sketch**: yes — forwards by functor-maps-isos, converse by packaging as TopCat.Sheaf and applying the stalkwise criterion then reflecting isos.
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.Modules.isIso_of_isIso_app_of_isBasis}` (`lem:modules_isIso_of_isBasis`)
- **Lean target exists**: yes (line 128)
- **Signature matches**: yes
- **Proof follows sketch**: yes — reduces to stalkwise iso via injectivity over basis (from `stalkFunctor_map_injective_of_isBasis`) and surjectivity via `germ_exist_of_isBasis`.
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_app_affineOpens}` (`lem:modules_isIso_iff_affineOpens`)
- **Lean target exists**: yes (line 164)
- **Signature matches**: yes
- **Proof follows sketch**: yes — special case of `isIso_of_isIso_app_of_isBasis` with the affine basis.
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.globalSectionsIso_hom_comp_specMap_appTop}` (`lem:globalSectionsIso_hom_comp_specMap_appTop`)
- **Lean target exists**: yes (line 268)
- **Signature matches**: yes
- **Proof follows sketch**: yes — two `have` rewrites to `ΓSpecIso.inv` form, then `ΓSpecIso_inv_naturality`.
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.gammaPushforwardIso}` (`lem:gammaPushforwardIso`)
- **Lean target exists**: yes (line 288)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `restrictScalarsComp'App.symm ≪≫ restrictScalarsCongr hcomp ≪≫ restrictScalarsComp'App`, matching the "two towers reconciled by restriction-of-scalars composition identity" prose.
- **notes**: No sorry. Axiom-clean (route (b)).

### `\lean{AlgebraicGeometry.gammaPushforwardTildeIso}` (`lem:gammaPushforwardTildeIso`)
- **Lean target exists**: yes (line 313)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `gammaPushforwardIso ≪≫ restrictScalars.mapIso (tilde.toTildeΓNatIso.app M).symm`.
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.gammaPushforwardIsoAt}` (`lem:gammaPushforwardIsoAt`)
- **Lean target exists**: yes (line 331)
- **Signature matches**: yes — sections over arbitrary open `U`, with preimage `(Spec φ)⁻¹ U`.
- **Proof follows sketch**: yes — verbatim copy of `gammaPushforwardIso` construction with `⊤` replaced by `U`.
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.tildeRestriction_isLocalizedModule}` (`lem:tildeRestriction_isLocalizedModule`)
- **Lean target exists**: yes (line 483)
- **Signature matches**: yes
- **Proof follows sketch**: yes — constructs bijection `Γ(M^~,⊤) ≅ M` from `powers 1`-localization, uses triangle identity, concludes via `of_linearEquiv_right`.
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.IsLocalizedModule.powers_restrictScalars}` (`lem:powers_restrictScalars`)
- **Lean target exists**: yes (line 455)
- **Signature matches**: yes
- **Proof follows sketch**: yes — three `IsLocalizedModule` conditions checked directly using `algebraMap_submonoid`/scalar-tower.
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.fromTildeΓ_app_isIso_of_isLocalizedModule}` (`lem:fromTildeGamma_app_isIso_of_localized`)
- **Lean target exists**: yes (line 367)
- **Signature matches**: yes
- **Proof follows sketch**: yes — triangle identity `L ∘ j = ρ`, uniqueness of localizations gives `L = e`, hence bijective.
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso_of_isLocalizedModule}` (`lem:pushforward_spec_tilde_iso_conditional`)
- **Lean target exists**: yes (line 431)
- **Signature matches**: yes
- **Proof follows sketch**: yes — applies `Modules.isIso_of_isIso_app_of_isBasis` over basic opens using `fromTildeΓ_app_isIso_of_isLocalizedModule`, then assembles iso from `asIso fromTildeΓ ≪≫ tilde.functor.mapIso gammaPushforwardTildeIso`.
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso}` (`lem:pushforward_spec_tilde_iso`)
- **Lean target exists**: yes (line 538)
- **Signature matches**: yes — `(Spec φ)_* (tilde M) ≅ tilde (restrictScalars φ M)`.
- **Proof follows sketch**: yes — `algebraize [φ.hom]`, constructs `σ`/`ρ` as tilde restrictions, invokes `powers_restrictScalars` and `IsLocalizedModule.of_linearEquiv`-style transport as described in the three-movement blueprint proof.
- **notes**: No sorry. Axiom-clean.

### `\lean{AlgebraicGeometry.gammaPushforwardNatIso}` (`lem:gammaPushforwardNatIso`)
- **Lean target exists**: yes (line 667)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `NatIso.ofComponents` with components from `gammaPushforwardIso`; naturality by `ext x; rfl` (all constituents identity-on-elements).
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.pullback_spec_tilde_iso}` (`lem:pullback_spec_tilde_iso`)
- **Lean target exists**: yes (line 689)
- **Signature matches**: yes — `(Spec φ)^* (tilde M) ≅ tilde (extendScalars φ M)`.
- **Proof follows sketch**: yes — uniqueness-of-left-adjoints via `conjugateIsoEquiv` applied to `gammaPushforwardNatIso`.
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.pullback_fst_snd_specMap_tensor}` (`lem:pullback_fst_snd_specMap_tensor`)
- **Lean target exists**: yes (line 709)
- **Signature matches**: yes
- **Proof follows sketch**: yes — direct application of `pullbackSpecIso_inv_fst` / `pullbackSpecIso_inv_snd`.
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.base_change_mate_domain_read}` (`lem:base_change_mate_domain_read`)
- **Lean target exists**: yes (line 737)
- **Signature matches**: yes — `Γ(g^*(f_* tilde M)) ≅ extendScalars ψ (restrictScalars φ M)`.
- **Proof follows sketch**: yes — pushforward dict then pullback dict then `tilde.toTildeΓNatIso.symm`.
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.pullbackIsoEquivalenceOfIso}` (`lem:pullbackIsoEquivalenceOfIso`)
- **Lean target exists**: yes (line 753)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `Equivalence.mk` with unit/counit from `pullbackId`/`pullbackComp`/`pullbackCongr`.
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.pullback_isEquivalence_of_iso}` (`lem:pullback_isEquivalence_of_iso`)
- **Lean target exists**: yes (line 762)
- **Signature matches**: yes
- **Proof follows sketch**: yes — one-liner from `pullbackIsoEquivalenceOfIso`.
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.base_change_mate_codomain_read}` (`lem:base_change_mate_codomain_read`)
- **Lean target exists**: yes (line 773)
- **Signature matches**: yes — `Γ(f'_*(g')^* tilde M) ≅ restrictScalars inclR' (extendScalars inclA M)`.
- **Proof follows sketch**: yes — `pullback_fst_snd_specMap_tensor`, leg identification via `e = pullbackSpecIso`, then affine dicts.
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.base_change_mate_regroupEquiv}` (`lem:base_change_mate_regroupEquiv`)
- **Lean target exists**: yes (line 856)
- **Signature matches**: yes — `restrictScalars inclR' (extendScalars inclA M) ≅ extendScalars ψ (restrictScalars φ M)`.
- **Proof follows sketch**: partial — see notes.
- **notes**: No sorry; axiom-clean. The blueprint proof sketch says the R'-linear equivalence is supplied by `lem:base_change_regroup_linearEquiv` (from RegroupHelper.lean) using `Algebra.IsPushout.cancelBaseChange`. The actual Lean proof INLINES the construction using `TensorProduct.AlgebraTensorModule.cancelBaseChange` + `TensorProduct.comm` + a `TensorProduct.induction_on` `map_smul'` discharge, because the `Algebra.IsPushout.cancelBaseChange` route was blocked by the A-action diamond (documented in the in-file STATUS comment). The result is identical; the proof route diverges from the blueprint's sketch. **Minor** blueprint adequacy note: `\uses{lem:base_change_regroup_linearEquiv}` is stale — that helper is not invoked in the Lean proof.

### `\lean{AlgebraicGeometry.base_change_mate_unit_value}` (`lem:base_change_mate_unit_value`)
- **Lean target exists**: yes (line 987)
- **Signature matches**: yes — the composite through `tilde.toTildeΓNatIso`, `moduleSpecΓFunctor.map (unit …)`, and two dict isos equals `extendRestrictScalarsAdj.unit`.
- **Proof follows sketch**: yes — `unit_conjugateEquiv_symm` + `β.hom.naturality` + `reassoc_of% huce` + `hunitR` as the blueprint's "conjugate-unit coherence" route. The `set_option maxHeartbeats 4000000` reflects the large proof.
- **notes**: No sorry. Fully proved.

### `\lean{AlgebraicGeometry.base_change_mate_inner_value}` (`def:base_change_mate_inner_value`)
- **Lean target exists**: yes (line 1102)
- **Signature matches**: yes — `restrictScalars φ M ⟶ restrictScalars ψ (restrictScalars inclR' (extendScalars inclA M))`.
- **Proof follows sketch**: yes — `restrictScalars φ (extendRestrictScalarsAdj.unit) ≫ restrictScalarsCongr hring ≫ ...` transport via ring equation `inclA ∘ φ = inclR' ∘ ψ`.
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.pullbackPushforward_unit_comp}` (`lem:pullbackPushforward_unit_comp`)
- **Lean target exists**: yes (line 1144)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `unit_conjugateEquiv` + `conjugateEquiv_pullbackComp_inv` + `comp_unit_app` as described in the blueprint.
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.gammaMap_pushforwardComp_hom_eq_id}` (`lem:gammaMap_pushforwardComp_hom_eq_id`)
- **Lean target exists**: yes (line 1174), but declared `private`.
- **Signature matches**: yes
- **Proof follows sketch**: yes — `rfl` on `pushforwardComp.hom = 𝟙`.
- **notes**: `private` in Lean, but referenced as public `\lean{AlgebraicGeometry.gammaMap_*}` in the blueprint. Only used by superseded `fstar_reindex_legs` dead code; does not affect live proofs. **Minor** discrepancy.

### `\lean{AlgebraicGeometry.gammaMap_pushforwardComp_inv_eq_id}` (`lem:gammaMap_pushforwardComp_inv_eq_id`)
- **Lean target exists**: yes (line 1182), `private`.
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: Same private/public discrepancy as above. Minor.

### `\lean{AlgebraicGeometry.gammaMap_pushforwardCongr_hom}` (`lem:gammaMap_pushforwardCongr_hom`)
- **Lean target exists**: yes (line 1193), `private`.
- **Signature matches**: yes — yields `eqToHom (by rw [hfg])` rather than `𝟙`.
- **Proof follows sketch**: yes — `subst hfg; ext U; simp`.
- **notes**: Same private/public discrepancy. Minor.

### `\lean{AlgebraicGeometry.base_change_mate_codomain_read_legs}` (`lem:base_change_mate_codomain_read_legs`)
- **Lean target exists**: yes (line 1210)
- **Signature matches**: yes — parametrised by free legs `g', f'` with hypotheses `hfst`/`hsnd`.
- **Proof follows sketch**: yes — verbatim construction of `base_change_mate_codomain_read` with free legs.
- **notes**: No sorry. Both blueprint and Lean consistently mark this superseded/dead code retained pending removal.

### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs_unitExpand}` (`lem:base_change_mate_fstar_reindex_legs_unitExpand`)
- **Lean target exists**: yes (line 1273)
- **Signature matches**: yes
- **Proof follows sketch**: yes — inverts `pullbackPushforward_unit_comp` by post-composing with `g'_*(pullbackComp.hom)`.
- **notes**: No sorry. Both sides mark as superseded dead code.

### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs_gammaDistribute}` (`lem:base_change_mate_fstar_reindex_legs_gammaDistribute`)
- **Lean target exists**: yes (line 1304)
- **Signature matches**: yes — generalized to any functor `F`.
- **Proof follows sketch**: yes — `F.map_comp` via term-mode to dodge the instance diamond.
- **notes**: No sorry. Both sides mark as superseded dead code.

### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs}` (`lem:base_change_mate_fstar_reindex_legs`)
- **Lean target exists**: yes (line 1333)
- **Signature matches**: yes
- **Proof follows sketch**: partial — steps (i) and (ii) are done (`subst hfst/hsnd`, `gammaMap_pushforwardComp_inv_eq_id`, `gammaMap_pushforwardCongr_hom`), step (iii) mate-unwinding crux is `sorry` (line 1421). Both blueprint and Lean consistently mark this superseded/dead code.
- **notes**: The `sorry` is in dead/superseded code. The blueprint's "superseded" annotation and the Lean's `sorry` with route comments are consistent. Not a defect per directive.

### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex}` (`lem:base_change_mate_fstar_reindex`)
- **Lean target exists**: yes (line 1435)
- **Signature matches**: yes
- **Proof follows sketch**: partial — delegates to `base_change_mate_fstar_reindex_legs` which carries a sorry. Both sides consistently mark superseded.
- **notes**: Not a defect. Dead code.

### `\lean{AlgebraicGeometry.base_change_mate_gstar_transpose}` (`lem:base_change_mate_gstar_transpose`) — **KNOWN PARTIAL**
- **Lean target exists**: yes (line 1490)
- **Signature matches**: yes — full signature matches the blueprint's `% LEAN SIGNATURE` annotation precisely.
- **Proof follows sketch**: partial — the `rw [Functor.map_comp]` + `rw [Iso.inv_comp_eq, ← Iso.eq_comp_inv]` scaffold is in place (lines 1513–1520), factoring the goal into the correct shape. The `sorry` at line 1551 carries the genuine counit-conjugate crux.
- **notes**: Per directive, the sorry itself is a known issue. **Blueprint sketch adequacy assessment below.**

### `\lean{AlgebraicGeometry.base_change_mate_section_identity}` (`lem:base_change_mate_section_identity`)
- **Lean target exists**: yes (line 1576)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `unfold pushforwardBaseChangeMap; rw [Adjunction.homEquiv_counit]; exact base_change_mate_gstar_transpose`. The one-line proof correctly assembles the section identity from the counit factorization and Seam 3, as the blueprint prescribes.
- **notes**: Proof depends on `base_change_mate_gstar_transpose` which carries a sorry; not axiom-clean until Seam 3 is closed.

### `\lean{AlgebraicGeometry.base_change_mate_generator_trace}` (`lem:base_change_mate_generator_trace`)
- **Lean target exists**: yes (line 1605)
- **Signature matches**: yes — `IsIso` form as documented.
- **Proof follows sketch**: yes — `rw [base_change_mate_section_identity]; infer_instance`.
- **notes**: Transitively sorry-backed.

### `\lean{AlgebraicGeometry.pushforward_base_change_mate_cancelBaseChange}` (`lem:pushforward_base_change_mate_cancelBaseChange`)
- **Lean target exists**: yes (line 1642)
- **Signature matches**: yes — `IsIso (Γ α)` form as documented.
- **Proof follows sketch**: yes — conjugation: `D.hom ≫ (D.inv ≫ Γα ≫ C.hom) ≫ C.inv` with `hconj = base_change_mate_generator_trace`. Blueprint prescribes this exact conjugation assembly.
- **notes**: Transitively sorry-backed.

### `\lean{AlgebraicGeometry.base_change_map_affine_local}` (`lem:base_change_map_affine_local`)
- **Lean target exists**: yes (line 1681)
- **Signature matches**: yes — `IsPullback` + `[IsAffineHom f]` + `[F.IsQuasicoherent]` + hypothesis `H : ∀ U, IsIso (…).app U`.
- **Proof follows sketch**: yes — `(Modules.isIso_iff_isIso_app_affineOpens …).mpr H`. Clean single-line.
- **notes**: No sorry. This is the locality reduction.

### `\lean{AlgebraicGeometry.affineBaseChange_pushforward_iso}` (`lem:affine_base_change_pushforward`)
- **Lean target exists**: yes (line 1693)
- **Signature matches**: yes
- **Proof follows sketch**: partial — applies `base_change_map_affine_local` correctly, then sorry-stubs the per-affine-open identification (the multi-hundred-LOC affine reduction step, line 1724). Blueprint proof sketch describes this step in detail ("Step 2: restriction to U commutes with each building block").
- **notes**: `sorry` at line 1724 is an ongoing proof obligation, not a blueprint adequacy failure — the blueprint describes the obligation clearly.

### `\lean{AlgebraicGeometry.flatBaseChange_pushforward_isIso}` (`thm:flat_base_change_pushforward`)
- **Lean target exists**: yes (line 1733)
- **Signature matches**: yes — `[Flat g]`, `[QuasiCompact f]`, `[QuasiSeparated f]`, `[F.IsQuasicoherent]`.
- **Proof follows sketch**: sorry-stub (line 1746). Blueprint proof sketch is detailed (Čech-free reduction via `affineBaseChange_pushforward_iso` + `flat_preserves_equalizer_mathlib`).
- **notes**: `sorry` is an ongoing proof obligation. Blueprint sketch is adequate.

---

## Red flags

### Placeholder / suspect bodies
No `sorry`s on declarations the blueprint claims are proved (no `\leanok` on proof block for any sorry-carrying declaration). All `sorry`s are on declarations marked with statement-only `\leanok` (formalized but not proved) or on superseded/dead code. **No placeholder/suspect bodies constitute a defect.**

### Excuse-comments
None. The in-file comments annotating the `sorry` positions (e.g., lines 1538–1550, 1708–1724) are accurate route-status descriptions matching the blueprint's known-partial and dead-code markings — not "wrong but works for now" excuses.

### Axioms / Classical.choice on non-trivial claims
None found. All substantive declarations in the live proof path are axiom-clean per in-file STATUS comments.

---

## Unreferenced declarations (informational)

All substantive declarations in the Lean file have corresponding `\lean{...}` references in the blueprint. The three `private` lemmas (`gammaMap_*`) are referenced by the blueprint but declared private in Lean — see minor finding below.

No unreferenced declarations suggest missing blueprint blocks.

---

## Blueprint adequacy for this file

### `lem:base_change_mate_gstar_transpose` — adequacy assessment (per directive)

The proof sketch at lines 2048–2113 of the blueprint is **adequate** to guide the remaining sorry close:

1. **Specific Mathlib tool named**: `conjugateEquiv_counit_symm` — the counit companion to the `unit_conjugateEquiv` used in Seam 1. The exact adjunction setup is specified: `adjL = (tilde.adjunction R).comp (pullbackPushforwardAdjunction (Spec.map ψ))`, `adjR = (extendRestrictScalarsAdj ψ.hom).comp (tilde.adjunction R')`, `α = gammaPushforwardNatIso ψ`, so `(conjugateEquiv adjL adjR).symm α = pullback_spec_tilde_iso ψ`.

2. **Obstacle diagnosed**: The pullback dictionary `pullback_spec_tilde_iso ψ` is opaque (built via `conjugateIsoEquiv`), so the geometric counit cannot be simplified by `rfl` or definitional unfolding — abstract conjugate calculus is mandatory.

3. **Two sub-obligations isolated**:
   - (a) The inner `Γ_R(θ_in) = ρ` must be reproved inline (not cited from `base_change_mate_fstar_reindex`, which is sorry-backed). The Seam 1 result `base_change_mate_unit_value` (proved, axiom-clean) is the key ingredient.
   - (b) `extendScalars ψ ρ ≫ algebraic counit = regroupEquiv.inv` — both sides R'-linear, checked on generators `r' ⊗ m ↦ (1 ⊗ r') ⊗ m`.

4. **In-file route comments match blueprint**: Lines 1522–1550 of the Lean file name the same Mathlib lemma, describe the same adjunction data, diagnose the same inline-reproof requirement, and identify the same two sub-obligations as the blueprint.

**Verdict on chapter adequacy for `gstar_transpose`**: The chapter provides sufficient detail. The prover can close the sorry using `CategoryTheory.conjugateEquiv_counit_symm` with the specified adjunction data, reprove the inner reindex inline using `base_change_mate_unit_value`, and check the generator identity against `base_change_mate_regroupEquiv`.

### Overall coverage and adequacy

- **Coverage**: 40/40 project Lean declarations have a corresponding `\lean{...}` block in the chapter. (6 additional `\lean{...}` / `\mathlibok` blocks reference Mathlib-provided declarations not in this file.) All substantive declarations are covered.
- **Proof-sketch depth**: adequate. Every sorry-carrying proof has a prose sketch specific enough to identify the missing step. The superseded lemmas are explicitly marked and their obsolescence documented.
- **Hint precision**: precise. `\lean{...}` names match Lean declaration names exactly in all cases.
- **Generality**: matches need.
- **Recommended chapter-side actions**:
  1. Update `\uses{lem:base_change_regroup_linearEquiv, lem:isPushout_cancelBaseChange_mathlib}` in `lem:base_change_mate_regroupEquiv` to reflect the actual inline proof route via `TensorProduct.AlgebraTensorModule.cancelBaseChange` + `TensorProduct.comm` (or add a note that the route diverged from the sketch). **Minor** — the result is correct; only the `\uses{}` is stale.
  2. The three `gammaMap_*` lemmas are declared `private` in Lean; the blueprint names them publicly. Since they are dead code (only used by superseded `fstar_reindex_legs`), no action is blocking, but the blueprint could note they are project-internal / private.

---

## Severity summary

**Must-fix-this-iter**: none.

**Major**: none.

**Minor**:
1. `base_change_mate_regroupEquiv` (`lem:base_change_mate_regroupEquiv`): the `\uses{lem:base_change_regroup_linearEquiv}` dependency is stale — that helper is not invoked in the actual Lean proof. The proof uses an inline `cancelBaseChange`/`comm` route documented in the STATUS comment. No impact on correctness.
2. Three Γ-collapse lemmas (`gammaMap_pushforwardComp_hom_eq_id`, `gammaMap_pushforwardComp_inv_eq_id`, `gammaMap_pushforwardCongr_hom`) are declared `private` in Lean but referenced as public `\lean{AlgebraicGeometry.gammaMap_*}` in the blueprint. These are only in superseded/dead code paths; no impact on live proofs.

**Overall verdict**: The FlatBaseChange.lean / Cohomology_FlatBaseChange.tex pair is faithful and well-aligned. The single live sorry (`base_change_mate_gstar_transpose`) is correctly flagged as partial in both files, the blueprint's proof sketch is adequate to guide its close, and the Seam-2 dead code is consistently superseded in both. Two minor stale blueprint references exist but have no downstream impact.
