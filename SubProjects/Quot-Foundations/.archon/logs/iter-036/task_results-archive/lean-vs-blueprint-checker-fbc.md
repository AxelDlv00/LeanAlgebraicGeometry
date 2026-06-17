# Lean ↔ Blueprint Check Report

## Slug
fbc

## Iteration
035

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`

---

## Per-declaration — `\lean{...}` blocks in the chapter

### `\lean{AlgebraicGeometry.pushforwardBaseChangeMap}` (def:pushforward_base_change_map)
- **Lean target exists**: yes (line 79)
- **Signature matches**: yes — canonical map `g^*(f_* F) ⟶ f'_*((g')^* F)` via adjunction transpose of the unit-then-reindex composite
- **Proof follows sketch**: yes (direct translation of the blueprint's adjoint-mate construction)
- **notes**: none

### `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_stalkFunctor_map}` (lem:modules_isIso_iff_stalk)
- **Lean target exists**: yes (line 102)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: none

### `\lean{AlgebraicGeometry.Modules.isIso_of_isIso_app_of_isBasis}` (lem:modules_isIso_of_isBasis)
- **Lean target exists**: yes (line 128)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: none

### `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_app_affineOpens}` (lem:modules_isIso_iff_affineOpens)
- **Lean target exists**: yes (line 164)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: none

### `\lean{AlgebraicGeometry.globalSectionsIso_hom_comp_specMap_appTop}` (lem:globalSectionsIso_hom_comp_specMap_appTop)
- **Lean target exists**: yes (line 268)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: none

### `\lean{AlgebraicGeometry.gammaPushforwardIso}` (lem:gammaPushforwardIso)
- **Lean target exists**: yes (line 288)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: none

### `\lean{AlgebraicGeometry.gammaPushforwardTildeIso}` (lem:gammaPushforwardTildeIso)
- **Lean target exists**: yes (line 313)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: none

### `\lean{AlgebraicGeometry.gammaPushforwardIsoAt}` (lem:gammaPushforwardIsoAt)
- **Lean target exists**: yes (line 331)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: none

### `\lean{AlgebraicGeometry.tildeRestriction_isLocalizedModule}` (lem:tildeRestriction_isLocalizedModule)
- **Lean target exists**: yes (line 483)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: none

### `\lean{AlgebraicGeometry.IsLocalizedModule.powers_restrictScalars}` (lem:powers_restrictScalars)
- **Lean target exists**: yes (line 455)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: none

### `\lean{AlgebraicGeometry.fromTildeΓ_app_isIso_of_isLocalizedModule}` (lem:fromTildeGamma_app_isIso_of_localized)
- **Lean target exists**: yes (line 367)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: none

### `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso_of_isLocalizedModule}` (lem:pushforward_spec_tilde_iso_conditional)
- **Lean target exists**: yes (line 431)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: none

### `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso}` (lem:pushforward_spec_tilde_iso)
- **Lean target exists**: yes (line 538)
- **Signature matches**: yes
- **Proof follows sketch**: yes (axiom-clean per docstring)
- **notes**: none

### `\lean{AlgebraicGeometry.gammaPushforwardNatIso}` (lem:gammaPushforwardNatIso)
- **Lean target exists**: yes (line 667)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: none

### `\lean{AlgebraicGeometry.pullback_spec_tilde_iso}` (lem:pullback_spec_tilde_iso)
- **Lean target exists**: yes (line 689)
- **Signature matches**: yes
- **Proof follows sketch**: yes (via `conjugateIsoEquiv`)
- **notes**: none

### `\lean{AlgebraicGeometry.pullback_fst_snd_specMap_tensor}` (lem:pullback_fst_snd_specMap_tensor)
- **Lean target exists**: yes (line 709)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: none

### `\lean{AlgebraicGeometry.base_change_mate_domain_read}` (lem:base_change_mate_domain_read)
- **Lean target exists**: yes (line 737)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: none

### `\lean{AlgebraicGeometry.pullbackIsoEquivalenceOfIso}` (lem:pullbackIsoEquivalenceOfIso)
- **Lean target exists**: yes (line 753)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: none

### `\lean{AlgebraicGeometry.pullback_isEquivalence_of_iso}` (lem:pullback_isEquivalence_of_iso)
- **Lean target exists**: yes (line 762)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: none

### `\lean{AlgebraicGeometry.base_change_mate_codomain_read}` (lem:base_change_mate_codomain_read)
- **Lean target exists**: yes (line 773)
- **Signature matches**: yes
- **Proof follows sketch**: partial — see Red Flags §Signature/description mismatch below
- **notes**: Blueprint prose and `\uses` for the sibling block `lem:base_change_mate_codomain_read_legs` describe the conj version, not this one; `base_change_mate_codomain_read` itself is correctly described.

### `\lean{AlgebraicGeometry.base_change_mate_codomain_read_legs}` (lem:base_change_mate_codomain_read_legs)
- **Lean target exists**: yes (line 1254)
- **Signature matches**: partial — **description mismatch**, see Red Flags
- **Proof follows sketch**: no — blueprint says pullback factor is `leftAdjointCompIso`; Lean uses `pullbackComp`
- **notes**: The blueprint prose for this block was updated to describe the conjugate-native form (`leftAdjointCompIso`, no leg-equality data), but the `\lean{...}` pin still points to the original form that uses `pullbackComp`. The sibling block `lem:base_change_mate_codomain_read_legs_conj` covers the actual conj version. The `\uses` on this block includes `lem:leftAdjointCompIso_mathlib` and `lem:conjugateEquiv_leftAdjointCompIso_inv_mathlib` which are NOT used by the pinned Lean decl. → See Red Flags.

### `\lean{AlgebraicGeometry.base_change_mate_regroupEquiv}` (lem:base_change_mate_regroupEquiv)
- **Lean target exists**: yes (line 856)
- **Signature matches**: yes (axiom-clean per docstring)
- **Proof follows sketch**: yes
- **notes**: none

### `\lean{AlgebraicGeometry.base_change_mate_unit_value}` (lem:base_change_mate_unit_value)
- **Lean target exists**: yes (line 987)
- **Signature matches**: yes (axiom-clean per docstring)
- **Proof follows sketch**: yes
- **notes**: none

### `\lean{AlgebraicGeometry.base_change_mate_inner_value}` (def:base_change_mate_inner_value)
- **Lean target exists**: yes (line 1102)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: none

### `\lean{AlgebraicGeometry.pullbackPushforward_unit_comp}` (lem:pullbackPushforward_unit_comp)
- **Lean target exists**: yes (line 1144)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: none

### `\lean{AlgebraicGeometry.pullbackComp_inv_eq_leftAdjointCompIso_inv}` (lem:pullbackComp_inv_eq_leftAdjointCompIso_inv)
- **Lean target exists**: yes (line 1181)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: none

### `\lean{AlgebraicGeometry.pullbackComp_eq_leftAdjointCompIso}` (lem:pullbackComp_eq_leftAdjointCompIso)
- **Lean target exists**: yes (line 1198)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: none

### `\lean{AlgebraicGeometry.gammaMap_pushforwardComp_hom_eq_id}` (lem:gammaMap_pushforwardComp_hom_eq_id)
- **Lean target exists**: yes (line 1218)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: none

### `\lean{AlgebraicGeometry.gammaMap_pushforwardComp_inv_eq_id}` (lem:gammaMap_pushforwardComp_inv_eq_id)
- **Lean target exists**: yes (line 1226)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: none

### `\lean{AlgebraicGeometry.gammaMap_pushforwardCongr_hom}` (lem:gammaMap_pushforwardCongr_hom)
- **Lean target exists**: yes (line 1237)
- **Signature matches**: partial — see Red Flags §Minor
- **Proof follows sketch**: yes (mathematically equivalent)
- **notes**: Blueprint says "yields the identity morphism", but Lean gives `= eqToHom (by rw [hfg])`. When `hfg : f = g` is substituted these are equal; the Lean statement is more precise.

### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs_unitExpand}` (lem:base_change_mate_fstar_reindex_legs_unitExpand)
- **Lean target exists**: yes (line 1317)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: none

### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs_gammaDistribute}` (lem:base_change_mate_fstar_reindex_legs_gammaDistribute)
- **Lean target exists**: yes (line 1348)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: none

### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs_link_distributeCollapse}` (lem:base_change_mate_fstar_reindex_legs_link_distributeCollapse)
- **Lean target exists**: yes (line 1377)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: none

### `\lean{AlgebraicGeometry.base_change_mate_codomain_read_legs_conj}` (lem:base_change_mate_codomain_read_legs_conj — conj-1a)
- **Lean target exists**: yes (line 1563)
- **Signature matches**: yes — uses `conjPullbackFactor` = `leftAdjointCompIso (pushforwardComp e (Spec ιA))`
- **Proof follows sketch**: yes
- **notes**: none

### `\lean{AlgebraicGeometry.base_change_mate_codomain_read_legs_conj_eq}` (lem:base_change_mate_codomain_read_legs_conj_eq — conj-1b)
- **Lean target exists**: yes (line 1594)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: none

### `\lean{AlgebraicGeometry.base_change_mate_reindex_conj_pullbackLeg}` (lem:base_change_mate_reindex_conj_pullbackLeg — conj-2b)
- **Lean target exists**: **no** — no declaration with this name exists in the file
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Blueprint block exists without `\leanok` (correctly unmarked). The `\uses` wiring cites `lem:conjugateEquiv_pullbackComp_inv_mathlib` (Mathlib), `lem:conjugateEquiv_leftAdjointCompIso_inv_mathlib` (Mathlib), and `lem:pullbackComp_eq_leftAdjointCompIso` (Lean exists, line 1198) — all citations point to existing decls. The block is gated on conj-2a's normal form; absence is expected. `\uses` wiring is honest.

### `\lean{AlgebraicGeometry.base_change_mate_reindex_conj_pushforwardCollapse}` (lem:base_change_mate_reindex_conj_pushforwardCollapse — conj-2c)
- **Lean target exists**: yes (line 1626)
- **Signature matches**: yes — bundles three atomic Γ-collapse lemmas
- **Proof follows sketch**: yes
- **notes**: none

### `\lean{AlgebraicGeometry.base_change_mate_reindex_conj_crossLayer}` (lem:base_change_mate_reindex_conj_crossLayer — conj-2d)
- **Lean target exists**: **no** — no declaration with this name exists in the file
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Blueprint block without `\leanok` (correctly unmarked). `\uses` cites `lem:base_change_mate_unit_value` (Lean exists), `lem:unit_conjugateEquiv_symm_mathlib` (Mathlib), `lem:conjugateEquiv_comp_mathlib` (Mathlib), `lem:gammaPushforwardIso` (Lean exists) — all valid. Gated on conj-2a's normal form. `\uses` wiring is honest.

### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs_conj}` (lem:base_change_mate_fstar_reindex_legs_conj — conj-2a)
- **Lean target exists**: yes (line 1647)
- **Signature matches**: yes
- **Proof follows sketch**: no — proof body is `:= sorry` (line 1700); proof block does NOT have `\leanok` in blueprint (correctly unmarked)
- **notes**: **This is the SINGLE residual FBC sorry**, precisely as documented in both the blueprint `% NOTE` comment and the directive. The blueprint correctly marks the statement `\leanok` (declaration exists) and leaves the proof block unmarked (proof open). No discrepancy between Lean and blueprint on this point.

### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs}` (lem:base_change_mate_fstar_reindex_legs — wrapper)
- **Lean target exists**: yes (line 1713)
- **Signature matches**: yes
- **Proof follows sketch**: yes — thin wrapper body `exact ... ▸ base_change_mate_fstar_reindex_legs_conj ...` is sorry-free; transitively sorry-backed through conj-2a
- **notes**: body has no inline sorry, as the directive confirms

### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex}` (lem:base_change_mate_fstar_reindex)
- **Lean target exists**: yes (line 1764)
- **Signature matches**: yes
- **Proof follows sketch**: yes — reduces to `base_change_mate_fstar_reindex_legs` by `exact`; transitively sorry-backed
- **notes**: none

### `\lean{AlgebraicGeometry.base_change_mate_inner_eCancel_eUnit}` (lem:base_change_mate_inner_eCancel_eUnit)
- **Lean target exists**: yes (line 1827)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: none

### `\lean{AlgebraicGeometry.base_change_mate_inner_eCancel_pushforwardComp}` (lem:base_change_mate_inner_eCancel_pushforwardComp)
- **Lean target exists**: yes (line 1839)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: none

### `\lean{AlgebraicGeometry.base_change_mate_inner_eCancel_pullbackComp}` (lem:base_change_mate_inner_eCancel_pullbackComp)
- **Lean target exists**: yes (line 1856)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: none

### `\lean{AlgebraicGeometry.base_change_mate_gstar_generator_close}` (lem:base_change_mate_gstar_generator_close)
- **Lean target exists**: yes (line 1874)
- **Signature matches**: yes
- **Proof follows sketch**: yes (axiom-clean per body)
- **notes**: none

### `\lean{AlgebraicGeometry.base_change_mate_inner_value_eq}` (lem:base_change_mate_inner_value_eq)
- **Lean target exists**: yes (line 1913)
- **Signature matches**: yes
- **Proof follows sketch**: yes — body is `exact base_change_mate_fstar_reindex ψ φ M`; sorry-free inline, transitively sorry-backed
- **notes**: none

### `\lean{AlgebraicGeometry.base_change_mate_gstar_counit_transport}` (lem:base_change_mate_gstar_counit_transport)
- **Lean target exists**: yes (line 1951)
- **Signature matches**: yes
- **Proof follows sketch**: yes (axiom-clean per body)
- **notes**: none

### `\lean{AlgebraicGeometry.base_change_mate_gstar_transpose}` (lem:base_change_mate_gstar_transpose)
- **Lean target exists**: yes (line 1999)
- **Signature matches**: yes
- **Proof follows sketch**: no — proof body has `:= sorry` at line 2122 (the Seam-3 crux after the conjugate-counit scaffold). Blueprint proof block expected to be unmarked (open).
- **notes**: Carries the second open sorry in the file. The Lean comment at line 2058–2122 gives a detailed recipe for closure; no excuse-comment ("wrong but works for now"), just a documented open obligation. The proof outline is coherent with the blueprint prose.

### `\lean{AlgebraicGeometry.base_change_mate_section_identity}` (lem:base_change_mate_section_identity)
- **Lean target exists**: yes (line 2151)
- **Signature matches**: yes
- **Proof follows sketch**: yes — body is `unfold pushforwardBaseChangeMap; rw [Adjunction.homEquiv_counit]; exact base_change_mate_gstar_transpose ψ φ M`; sorry-free inline, transitively sorry-backed
- **notes**: none

### `\lean{AlgebraicGeometry.base_change_mate_generator_trace}` (lem:base_change_mate_generator_trace)
- **Lean target exists**: yes (line 2180)
- **Signature matches**: yes
- **Proof follows sketch**: yes; sorry-free inline, transitively sorry-backed
- **notes**: none

### `\lean{AlgebraicGeometry.pushforward_base_change_mate_cancelBaseChange}` (lem:pushforward_base_change_mate_cancelBaseChange)
- **Lean target exists**: yes (line 2221)
- **Signature matches**: yes
- **Proof follows sketch**: yes; sorry-free inline, transitively sorry-backed
- **notes**: none

### `\lean{AlgebraicGeometry.base_change_map_affine_local}` (lem:base_change_map_affine_local)
- **Lean target exists**: yes (line 2260)
- **Signature matches**: yes — one-liner using locality criterion
- **Proof follows sketch**: yes (axiom-clean)
- **notes**: none

### `\lean{AlgebraicGeometry.affineBaseChange_pushforward_iso}` (blueprint: lem:affineBaseChange_pushforward_iso — in unread section)
- **Lean target exists**: yes (line 2272)
- **Signature matches**: yes
- **Proof follows sketch**: no — proof ends with `:= sorry` at line 2303 (the affine-reduction compatibility obligation: identifying `(pushforwardBaseChangeMap …).app U` with the affine–affine base-change map on the restricted square). The Lean comment explicitly describes the remaining multi-hundred-LOC obligation.
- **notes**: Open sorry; the Lean comment clearly describes it as a remaining build, not an excuse-comment.

### `\lean{AlgebraicGeometry.flatBaseChange_pushforward_isIso}` (blueprint lem for flat BC — in unread section)
- **Lean target exists**: yes (line 2312)
- **Signature matches**: yes
- **Proof follows sketch**: no — proof is `:= sorry` (line 2325) with a detailed Čech-cohomology roadmap comment; the infrastructure (finite affine cover, Čech complex for SheafOfModules) is Mathlib-absent
- **notes**: Open sorry; long-range obligation, not a shortcut.

---

## Red Flags

### Placeholder / suspect bodies

- `base_change_mate_fstar_reindex_legs_conj` at line 1700: `:= sorry`. Blueprint statement marked `\leanok` (correctly — statement exists), proof block NOT `\leanok` (correctly — proof open). **This is the SINGLE residual FBC sorry (as stated in directive and blueprint `% NOTE`).** Not a stealth sorry; fully tracked.

- `base_change_mate_gstar_transpose` at line 2122: `:= sorry`. This is the Seam-3 crux; carries the second open sorry in the file. Blueprint proof block should be unmarked.

- `affineBaseChange_pushforward_iso` at line 2303: `:= sorry`. Open obligation (affine-reduction compatibility).

- `flatBaseChange_pushforward_isIso` at line 2325: `:= sorry`. Open obligation (Čech-cohomology infrastructure absent).

### Signature/description mismatches

**`lem:base_change_mate_codomain_read_legs` (major):** The blueprint block at `lem:base_change_mate_codomain_read_legs` carries these problems:

1. **Title and prose** say the codomain read is "assembled as the composite-adjunction comparison `leftAdjointCompIso`" of the free legs `e`, `Spec ιA`. But the pinned Lean decl `base_change_mate_codomain_read_legs` (line 1254) assembles its pullback factor as `(Scheme.Modules.pullbackComp e.hom (Spec.map inclA)).symm.app`, NOT `leftAdjointCompIso`. The conj version (`base_change_mate_codomain_read_legs_conj`, line 1563) uses `conjPullbackFactor = leftAdjointCompIso …`. The blueprint description correctly describes `_conj`, not the decl it pins.

2. **`\uses` overshoot**: The block lists `lem:leftAdjointCompIso_mathlib` and `lem:conjugateEquiv_leftAdjointCompIso_inv_mathlib` as dependencies, but the actual pinned Lean decl `base_change_mate_codomain_read_legs` does NOT use either. These belong in the `\uses` of `lem:base_change_mate_codomain_read_legs_conj`.

The mismatch appears to be a consequence of the iter-034/035 re-encoding: the prose and `\uses` were updated to describe the conjugate-native form, but the `\lean{...}` pin was not updated to track the newly-introduced `_conj` decl. This confuses the dependency graph.

**`gammaMap_pushforwardCongr_hom` (minor):** Blueprint states the result as "yields the identity morphism" (`= id`). The Lean gives `= eqToHom (by rw [hfg])`. Mathematically these are equal (when `hfg` is substituted, `eqToHom rfl = 𝟙 _`), but the stated type of the Lean theorem is strictly more precise than the blueprint says.

### Excuse-comments
None. The open sorries all carry roadmaps or obstacle descriptions, not "this is wrong but works" disclaimers.

### Axioms / Classical.choice on substantive claims
None. Axiom declarations were not introduced.

---

## Unreferenced declarations (informational)

The following Lean declarations have **no `\lean{...}` reference** in the blueprint chapter. Per the directive these are coverage debt, not errors:

1. **`conjPullbackFactor`** (line 1489) — noncomputable def. Packages the `leftAdjointCompIso` factor for the conjugate-native read. Plays a key role as the sole structural difference between `_codomain_read_legs` and `_conj`. Should have a blueprint block given its centrality to the conjugate strategy.

2. **`conjPullbackFactor_eq_pullbackComp`** (line 1520) — theorem. Establishes `conjPullbackFactor = pullbackComp e.hom (Spec ιA)`, the bridge that makes conj-1b a `rfl`. Should be documented.

3. **`base_change_mate_codomain_read_legs_param`** (line 1427) — noncomputable def. The parametrized version of the codomain read (free `Pcomp` argument); the structural device allowing both `_legs` and `_conj` to be thin wrappers. Blueprint has no block for it.

4. **`base_change_mate_codomain_read_legs_eq_param`** (line 1536) — theorem. Proves `base_change_mate_codomain_read_legs = _param … (pullbackComp …)` by `rfl`; drives conj-1b. Blueprint has no block.

These four form the scaffolding of the conjugate re-encoding introduced in iter-034/035 and have no corresponding blueprint coverage. They are described in the inline `/-! Seam 2, conjugate chain ... -/` section comment (line 1413) but not as named `\begin{lemma}...\end{lemma}` blocks.

---

## Blueprint adequacy for this file

- **Coverage**: ~53 of ~57 Lean declarations have a corresponding `\lean{...}` block in the chapter. The 4 unreferenced declarations (above) are legitimately helpers, though at the junction complexity level they should ideally be documented. The two gated decls (conj-2b `_pullbackLeg`, conj-2d `_crossLayer`) have blueprint blocks but no Lean decls yet.
- **Proof-sketch depth**: **adequate** for all proved declarations. The blueprint provides detailed three-movement or conjugate-chain strategies for every major theorem. The open sorries are accompanied by explicit obstacle descriptions in both the blueprint (as `% NOTE` comments) and the Lean proof comments. No case where a prover would be left without guidance.
- **Hint precision**: **loose** for `lem:base_change_mate_codomain_read_legs` (described as using `leftAdjointCompIso` but pinned to the `pullbackComp` version — see Red Flags). All other hints are precise.
- **Generality**: matches need.
- **`\uses` wiring**:
  - `lem:base_change_mate_codomain_read_legs`: erroneously includes `lem:leftAdjointCompIso_mathlib` and `lem:conjugateEquiv_leftAdjointCompIso_inv_mathlib` — these belong on `lem:base_change_mate_codomain_read_legs_conj`.
  - `lem:base_change_mate_reindex_conj_pullbackLeg` and `lem:base_change_mate_reindex_conj_crossLayer`: `\uses` wiring is honest (all cited decls exist or are Mathlib). No false dependency.

**Recommended chapter-side actions:**
1. **Major fix**: Correct the prose and `\uses` of `lem:base_change_mate_codomain_read_legs` to describe what the Lean actually builds (variable-legs form using `pullbackComp`). Move `lem:leftAdjointCompIso_mathlib` and `lem:conjugateEquiv_leftAdjointCompIso_inv_mathlib` from its `\uses` to `lem:base_change_mate_codomain_read_legs_conj`'s `\uses`.
2. **Minor fix**: Add blueprint blocks for `conjPullbackFactor`, `conjPullbackFactor_eq_pullbackComp`, `base_change_mate_codomain_read_legs_param`, `base_change_mate_codomain_read_legs_eq_param` (the four coverage-debt helpers).
3. **Minor fix**: Sharpen `lem:gammaMap_pushforwardCongr_hom` to say the result is `eqToHom (proof that domains agree)` rather than "the identity morphism".

---

## Severity summary

### must-fix-this-iter
*None.* The two open sorries (`base_change_mate_fstar_reindex_legs_conj` and `base_change_mate_gstar_transpose`) are fully tracked — blueprint proof blocks are correctly unmarked and both the blueprint and the Lean carry explicit roadmaps. No silent sorry, no fake substantive claim. The other two sorries (`affineBaseChange_pushforward_iso`, `flatBaseChange_pushforward_isIso`) are known long-range obligations.

### major
1. **`lem:base_change_mate_codomain_read_legs` description/`\uses` mismatch**: Blueprint prose says `leftAdjointCompIso`, Lean uses `pullbackComp`. Two `\uses` entries (`lem:leftAdjointCompIso_mathlib`, `lem:conjugateEquiv_leftAdjointCompIso_inv_mathlib`) are wrong for this block and belong on `lem:base_change_mate_codomain_read_legs_conj`. Confuses the dependency graph for iter-036 planning.

### minor
1. `conjPullbackFactor` + `conjPullbackFactor_eq_pullbackComp` + `base_change_mate_codomain_read_legs_param` + `base_change_mate_codomain_read_legs_eq_param`: 4 Lean declarations with no blueprint block (coverage debt).
2. `lem:gammaMap_pushforwardCongr_hom`: Blueprint says "identity morphism"; Lean gives `eqToHom (by rw [hfg])` (more precise).
3. `lem:base_change_mate_reindex_conj_pullbackLeg` and `lem:base_change_mate_reindex_conj_crossLayer`: Blueprint blocks exist, Lean decls absent. Correctly tracked as unformalized. No action needed this iter (gated on conj-2a).

**Overall verdict:** The Lean file faithfully follows the blueprint for all proved declarations; the two open sorries are properly tracked and isolated in `base_change_mate_fstar_reindex_legs_conj` and `base_change_mate_gstar_transpose`. The one actionable finding is a **major** blueprint-side description/`\uses` mismatch on `lem:base_change_mate_codomain_read_legs` that should be corrected before iter-036 planning to avoid misleading the next prover round.
