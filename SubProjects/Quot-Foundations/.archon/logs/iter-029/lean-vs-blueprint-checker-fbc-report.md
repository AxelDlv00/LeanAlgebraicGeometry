# Lean ↔ Blueprint Check Report

## Slug
fbc

## Iteration
029

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` (2024 lines)
- Blueprint: `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` (3187 lines)

---

## Directive confirmations

### CHECK 1 — De-privatization of 3 atoms: CONFIRMED

All three atoms are now declared **without** `private` in the Lean file:

| Declaration | Lean line | Visibility |
|---|---|---|
| `gammaMap_pushforwardComp_hom_eq_id` | 1174 | public (no `private` keyword) |
| `gammaMap_pushforwardComp_inv_eq_id` | 1182 | public (no `private` keyword) |
| `gammaMap_pushforwardCongr_hom` | 1193 | public (no `private` keyword) |

Blueprint `\lean{}` pins `AlgebraicGeometry.gammaMap_pushforwardComp_hom_eq_id`, `AlgebraicGeometry.gammaMap_pushforwardComp_inv_eq_id`, and `AlgebraicGeometry.gammaMap_pushforwardCongr_hom` now **resolve correctly** to public declarations in the `AlgebraicGeometry` namespace.

**Secondary finding (major):** The blueprint NOTE at lines 1541–1546 (immediately below `\lean{AlgebraicGeometry.gammaMap_pushforwardComp_hom_eq_id}`) still reads:
```
% NOTE: this atom and the two that follow (`gammaMap_pushforwardComp_inv_eq_id`,
% `gammaMap_pushforwardCongr_hom`) are declared `private` in Lean, so their real declaration names
% are mangled and do NOT match the public-form `\lean{}` pins above. The pins are kept in
% public form deliberately (they name the mathematical content); the pin-resolution mismatch is
% expected and is a prover-side de-privatisation matter, not a blueprint error — do not "fix" the
% pins here.
```
This NOTE is now **factually false**: the pins DO resolve, the names are NOT mangled, and there is NO mismatch. See Red Flags section.

### CHECK 2 — Docstring accuracy at ~1838 and ~1911: CONFIRMED ACCURATE, NOT LAUNDERING

**`base_change_mate_section_identity`** (~line 1847):
- Proof body: `unfold pushforwardBaseChangeMap` → `rw [Adjunction.homEquiv_counit]` → `exact base_change_mate_gstar_transpose ψ φ M`. **No inline `sorry`.**
- `base_change_mate_gstar_transpose` has `sorry` at line 1818 (known open).
- Docstring says "no inline `sorry`, transitively sorry-backed through `base_change_mate_gstar_transpose`" — **ACCURATE.**

**`pushforward_base_change_mate_cancelBaseChange`** (~line 1917):
- Proof body: `haveI hconj := base_change_mate_generator_trace ψ φ M` + `rw [heq]` + `infer_instance`. **No inline `sorry`.**
- Chain: this → `base_change_mate_generator_trace` → `base_change_mate_section_identity` → `base_change_mate_gstar_transpose` (sorry at 1818).
- Docstring says "no inline `sorry`, transitively sorry-backed through `base_change_mate_gstar_transpose`" — **ACCURATE.** This is a three-hop chain, not a one-hop chain, but the sorry dependency is correctly attributed.

### CHECK 3 — Blueprint adequacy for 4 known-open sorrys: ALL ADEQUATE

See Blueprint Adequacy section for details.

---

## Per-declaration

### `\lean{AlgebraicGeometry.pushforwardBaseChangeMap}` (def:pushforward_base_change_map)
- **Lean target exists**: yes — line 79
- **Signature matches**: yes — `(comm : g' ≫ f = f' ≫ g) (F : X.Modules) : pullback g (pushforward f F) ⟶ pushforward f' (pullback g' F)` matches the prose
- **Proof follows sketch**: N/A (definition, not a theorem)

### `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_stalkFunctor_map}` (lem:Modules_isIso_iff_isIso_stalkFunctor_map)
- **Lean target exists**: yes — line 102
- **Signature matches**: yes — isomorphism iff stalk functor maps are all isomorphisms
- **Proof follows sketch**: yes

### `\lean{AlgebraicGeometry.Modules.isIso_of_isIso_app_of_isBasis}` (lem:Modules_isIso_of_isIso_app_of_isBasis)
- **Lean target exists**: yes — line 128
- **Signature matches**: yes — isomorphism if stalk isomorphism holds on a basis
- **Proof follows sketch**: yes

### `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_app_affineOpens}` (lem:modules_isIso_iff_affineOpens)
- **Lean target exists**: yes — line 164
- **Signature matches**: yes — isomorphism iff sections over every affine open are isomorphisms
- **Proof follows sketch**: yes

### `\lean{AlgebraicGeometry.globalSectionsIso_hom_comp_specMap_appTop}` (lem:globalSectionsIso_hom_comp_specMap_appTop)
- **Lean target exists**: yes — line 268
- **Signature matches**: yes — naturality / global sections computation
- **Proof follows sketch**: yes

### `\lean{AlgebraicGeometry.gammaPushforwardIso}` (def:gammaPushforwardIso)
- **Lean target exists**: yes — line 288
- **Signature matches**: yes — tilde-Γ dictionary isomorphism for pushforward
- **Proof follows sketch**: N/A (definition)

### `\lean{AlgebraicGeometry.gammaPushforwardTildeIso}` (def:gammaPushforwardTildeIso)
- **Lean target exists**: yes — line 313
- **Signature matches**: yes
- **Proof follows sketch**: N/A

### `\lean{AlgebraicGeometry.gammaPushforwardIsoAt}` (def:gammaPushforwardIsoAt)
- **Lean target exists**: yes — line 331
- **Signature matches**: yes
- **Proof follows sketch**: N/A

### `\lean{AlgebraicGeometry.fromTildeΓ_app_isIso_of_isLocalizedModule}` (lem:fromTildeΓ_app_isIso_of_isLocalizedModule)
- **Lean target exists**: yes — line 367
- **Signature matches**: yes — isLocalizedModule hypothesis implies isIso of fromTildeΓ app
- **Proof follows sketch**: yes

### `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso_of_isLocalizedModule}` (lem:pushforward_spec_tilde_iso_of_isLocalizedModule)
- **Lean target exists**: yes — line 431
- **Signature matches**: yes
- **Proof follows sketch**: yes

### `\lean{AlgebraicGeometry.IsLocalizedModule.powers_restrictScalars}` (lem:IsLocalizedModule_powers_restrictScalars)
- **Lean target exists**: yes — line 455
- **Signature matches**: yes — LocalizedModule.powers_restrictScalars
- **Proof follows sketch**: yes

### `\lean{AlgebraicGeometry.tildeRestriction_isLocalizedModule}` (lem:tildeRestriction_isLocalizedModule)
- **Lean target exists**: yes — line 483
- **Signature matches**: yes — the tilde of the restriction is a localized module
- **Proof follows sketch**: yes

### `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso}` (lem:pushforward_spec_tilde_iso)
- **Lean target exists**: yes — line 538
- **Signature matches**: yes — axiom-clean pushforward tilde dictionary
- **Proof follows sketch**: yes

### `\lean{AlgebraicGeometry.gammaPushforwardNatIso}` (def:gammaPushforwardNatIso)
- **Lean target exists**: yes — line 667
- **Signature matches**: yes — natural iso between Γ∘pushforward and forgetScalars functors
- **Proof follows sketch**: N/A

### `\lean{AlgebraicGeometry.pullback_spec_tilde_iso}` (lem:pullback_spec_tilde_iso)
- **Lean target exists**: yes — line 689
- **Signature matches**: yes — pullback tilde dictionary
- **Proof follows sketch**: yes

### `\lean{AlgebraicGeometry.pullback_fst_snd_specMap_tensor}` (lem:pullback_fst_snd_specMap_tensor)
- **Lean target exists**: yes — line 709
- **Signature matches**: yes — identification of pullback cone legs in the Spec-of-tensor square
- **Proof follows sketch**: yes

### `\lean{AlgebraicGeometry.base_change_mate_domain_read}` (lem:base_change_mate_domain_read)
- **Lean target exists**: yes — line 737
- **Signature matches**: yes — Θ_src : Γ(g*(f*F̃)) ≅ R' ⊗_R M
- **Proof follows sketch**: N/A (def/iso construction)

### `\lean{AlgebraicGeometry.pullbackIsoEquivalenceOfIso}` (lem:pullbackIsoEquivalenceOfIso)
- **Lean target exists**: yes — line 753
- **Signature matches**: yes — pullback by an iso gives an equivalence
- **Proof follows sketch**: N/A (def)

### `\lean{AlgebraicGeometry.pullback_isEquivalence_of_iso}` (lem:pullback_isEquivalence_of_iso)
- **Lean target exists**: yes — line 762 (`instance`, not `theorem`; declaration name resolves correctly as instance in `AlgebraicGeometry` namespace)
- **Signature matches**: yes
- **Proof follows sketch**: yes

### `\lean{AlgebraicGeometry.base_change_mate_codomain_read}` (lem:base_change_mate_codomain_read)
- **Lean target exists**: yes — line 773
- **Signature matches**: yes — Θ_tgt : Γ(f'*(g')*F̃) ≅ (A ⊗_R R') ⊗_A M
- **Proof follows sketch**: N/A

### `\lean{AlgebraicGeometry.base_change_mate_regroupEquiv}` (lem:base_change_mate_regroupEquiv)
- **Lean target exists**: yes — line 856
- **Signature matches**: yes — R'-linear regrouping equiv (A ⊗_R R') ⊗_A M ≅ R' ⊗_R M
- **Proof follows sketch**: N/A

### `\lean{AlgebraicGeometry.base_change_mate_unit_value}` (lem:base_change_mate_unit_value)
- **Lean target exists**: yes — line 987
- **Signature matches**: yes — Seam 1, section-level value of inner unit
- **Proof follows sketch**: yes

### `\lean{AlgebraicGeometry.base_change_mate_inner_value}` (def:base_change_mate_inner_value)
- **Lean target exists**: yes — line 1102
- **Signature matches**: yes
- **Proof follows sketch**: N/A

### `\lean{AlgebraicGeometry.pullbackPushforward_unit_comp}` (lem:pullbackPushforward_unit_comp)
- **Lean target exists**: yes — line 1144
- **Signature matches**: yes
- **Proof follows sketch**: yes

### `\lean{AlgebraicGeometry.gammaMap_pushforwardComp_hom_eq_id}` (lem:gammaMap_pushforwardComp_hom_eq_id)
- **Lean target exists**: yes — line 1174, **NOW PUBLIC** (de-privatized this iter)
- **Signature matches**: yes — Γ(pushforwardComp hom) = id
- **Proof follows sketch**: yes
- **notes**: Pin now resolves; stale blueprint NOTE at lines 1541–1546 must be removed (see Red Flags).

### `\lean{AlgebraicGeometry.gammaMap_pushforwardComp_inv_eq_id}` (lem:gammaMap_pushforwardComp_inv_eq_id)
- **Lean target exists**: yes — line 1182, **NOW PUBLIC**
- **Signature matches**: yes — Γ(pushforwardComp inv) = id
- **Proof follows sketch**: yes
- **notes**: Same stale NOTE covers this; pin resolves.

### `\lean{AlgebraicGeometry.gammaMap_pushforwardCongr_hom}` (lem:gammaMap_pushforwardCongr_hom)
- **Lean target exists**: yes — line 1193, **NOW PUBLIC**
- **Signature matches**: partial — Lean result is `= eqToHom (by rw [hfg])`, not literally `= 𝟙 _`. However this is correct: when the hypothesis `hfg : f = g` is substituted, `eqToHom rfl = 𝟙 _` by `simp`; the Lean proof confirms this by `subst hfg`. Blueprint says "yields the identity morphism" — this is the mathematical content, so the mismatch is presentational, not substantive.
- **Proof follows sketch**: yes

### `\lean{AlgebraicGeometry.base_change_mate_codomain_read_legs}` (lem:base_change_mate_codomain_read_legs)
- **Lean target exists**: yes — line 1210
- **Signature matches**: yes
- **Proof follows sketch**: yes

### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs_unitExpand}` (lem:base_change_mate_fstar_reindex_legs_unitExpand)
- **Lean target exists**: yes — line 1273
- **Signature matches**: yes
- **Proof follows sketch**: yes

### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs_gammaDistribute}` (lem:base_change_mate_fstar_reindex_legs_gammaDistribute)
- **Lean target exists**: yes — line 1304
- **Signature matches**: yes
- **Proof follows sketch**: yes

### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs}` (lem:base_change_mate_fstar_reindex_legs)
- **Lean target exists**: yes — line 1335
- **Signature matches**: yes
- **Proof follows sketch**: partial — body has `sorry` at line 1446 (KNOWN OPEN; X.Modules instance diamond blocker; do not re-report)
- **notes**: Also serves as the `\lean{}` pin for narrative nodes `lem:base_change_mate_inner_unitReduce`, `lem:base_change_mate_inner_eCancel`, `lem:base_change_mate_inner_eCancel_assemble` — by design, those nodes have no dedicated Lean declarations.

### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex}` (lem:base_change_mate_fstar_reindex)
- **Lean target exists**: yes — line 1460
- **Signature matches**: yes
- **Proof follows sketch**: yes — body is a one-line delegation to `base_change_mate_fstar_reindex_legs`; transitively sorry-backed through `_legs`

### `\lean{AlgebraicGeometry.base_change_mate_inner_eCancel_eUnit}` (lem:base_change_mate_inner_eCancel_eUnit)
- **Lean target exists**: yes — line 1523
- **Signature matches**: yes
- **Proof follows sketch**: yes

### `\lean{AlgebraicGeometry.base_change_mate_inner_eCancel_pushforwardComp}` (lem:base_change_mate_inner_eCancel_pushforwardComp)
- **Lean target exists**: yes — line 1535
- **Signature matches**: yes
- **Proof follows sketch**: yes

### `\lean{AlgebraicGeometry.base_change_mate_inner_eCancel_pullbackComp}` (lem:base_change_mate_inner_eCancel_pullbackComp)
- **Lean target exists**: yes — line 1552
- **Signature matches**: yes
- **Proof follows sketch**: yes

### `\lean{AlgebraicGeometry.base_change_mate_gstar_generator_close}` (lem:base_change_mate_gstar_generator_close)
- **Lean target exists**: yes — line 1570
- **Signature matches**: yes
- **Proof follows sketch**: yes

### `\lean{AlgebraicGeometry.base_change_mate_inner_value_eq}` (lem:base_change_mate_inner_value_eq)
- **Lean target exists**: yes — line 1609
- **Signature matches**: yes — Seam A
- **Proof follows sketch**: yes

### `\lean{AlgebraicGeometry.base_change_mate_gstar_counit_transport}` (lem:base_change_mate_gstar_counit_transport)
- **Lean target exists**: yes — line 1647
- **Signature matches**: yes — Seam C
- **Proof follows sketch**: yes

### `\lean{AlgebraicGeometry.base_change_mate_gstar_transpose}` (lem:base_change_mate_gstar_transpose)
- **Lean target exists**: yes — line 1695
- **Signature matches**: yes — Seam 3, the principal crux
- **Proof follows sketch**: partial — body has `sorry` at line 1818 (KNOWN OPEN; gated on `_legs` eCancel; do not re-report)

### `\lean{AlgebraicGeometry.base_change_mate_section_identity}` (lem:base_change_mate_section_identity)
- **Lean target exists**: yes — line 1847
- **Signature matches**: yes
- **Proof follows sketch**: yes — proof matches blueprint prose exactly (unfold → counit form → Seam 3)
- **notes**: No inline `sorry`; transitively sorry-backed through `base_change_mate_gstar_transpose`. Docstring accurate.

### `\lean{AlgebraicGeometry.base_change_mate_generator_trace}` (lem:base_change_mate_generator_trace)
- **Lean target exists**: yes — line 1876
- **Signature matches**: yes — IsIso of the conjugated section-level map
- **Proof follows sketch**: yes — one-line corollary of section identity (as blueprint NOTE says)

### `\lean{AlgebraicGeometry.pushforward_base_change_mate_cancelBaseChange}` (lem:pushforward_base_change_mate_cancelBaseChange)
- **Lean target exists**: yes — line 1917
- **Signature matches**: yes — IsIso Γ(α) form (blueprint NOTE explains why IsIso rather than literal equality is formalized)
- **Proof follows sketch**: yes
- **notes**: No inline `sorry`; 3-hop transitive sorry dependency on `base_change_mate_gstar_transpose`. Docstring accurate.

### `\lean{AlgebraicGeometry.base_change_map_affine_local}` (lem:base_change_map_affine_local)
- **Lean target exists**: yes — line 1956
- **Signature matches**: yes — locality reduction: isIso reduces to affine-affine case
- **Proof follows sketch**: yes — sorry-free

### `\lean{AlgebraicGeometry.affineBaseChange_pushforward_iso}` (lem:affine_base_change_pushforward)
- **Lean target exists**: yes — line 1968
- **Signature matches**: yes — affine morphism + qcoh F ⟹ base-change map is iso
- **Proof follows sketch**: partial — body has `sorry` at line 1999 (KNOWN OPEN; restriction-compatibility step; do not re-report)

### `\lean{AlgebraicGeometry.flatBaseChange_pushforward_isIso}` (thm:flat_base_change_pushforward)
- **Lean target exists**: yes — line 2008
- **Signature matches**: yes — g flat + f qcqs + F qcoh ⟹ base-change map is iso
- **Proof follows sketch**: partial — body has `sorry` at line 2021 (KNOWN OPEN; Čech-equalizer strategy; do not re-report)

### `\mathlibok` entries (Mathlib-backed, no Archon proof obligation)

| Blueprint label | `\lean{...}` pin | Status |
|---|---|---|
| lem:pullbackSpecIso_mathlib | `AlgebraicGeometry.pullbackSpecIso` | `\mathlibok` ✓ |
| lem:cancelBaseChange_mathlib | `TensorProduct.AlgebraTensorModule.cancelBaseChange` | `\mathlibok` ✓ |
| lem:isPushout_cancelBaseChange_mathlib | `Algebra.IsPushout.cancelBaseChange` | `\mathlibok` ✓ |
| lem:unit_conjugateEquiv_mathlib | `CategoryTheory.unit_conjugateEquiv` | `\mathlibok` ✓ |
| lem:comp_unit_app_mathlib | `CategoryTheory.Adjunction.comp_unit_app` | `\mathlibok` ✓ |
| lem:conjugateEquiv_pullbackComp_inv_mathlib | `AlgebraicGeometry.Scheme.Modules.conjugateEquiv_pullbackComp_inv` | `\mathlibok` ✓ |
| lem:flat_preserves_equalizer_mathlib | `LinearMap.tensorEqLocusEquiv` | `\mathlibok` ✓ |

All `\mathlibok` declarations are correctly labelled; no Archon obligation remains for them.

---

## Red flags

### Stale blueprint NOTE (major)

**Location**: `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`, lines 1541–1546, inside `\begin{lemma}` block for `lem:gammaMap_pushforwardComp_hom_eq_id`.

**Content** (verbatim):
```tex
% NOTE: this atom and the two that follow (`gammaMap_pushforwardComp_inv_eq_id`,
% `gammaMap_pushforwardCongr_hom`) are declared `private` in Lean, so their real declaration names
% are mangled and do NOT match the public-form `\lean{}` pins above. The pins are kept in
% public form deliberately (they name the mathematical content); the pin-resolution mismatch is
% expected and is a prover-side de-privatisation matter, not a blueprint error — do not "fix" the
% pins here.
```

**Why it's a red flag**: Every claim in this NOTE is now false:
- The three declarations are **public** (no `private` keyword at lines 1174, 1182, 1193).
- Their names are **not mangled** — they are exactly the public forms named in the `\lean{}` pins.
- There is **no pin-resolution mismatch** — the pins resolve correctly.
- The NOTE says "do not fix the pins" — unnecessary, since the pins are already correct.

A future reader of this NOTE would be led to believe the pins are broken when they are not. The NOTE should be removed entirely (the de-privatization is complete and no record of the transition needs to be kept in the blueprint).

**Severity: major** (stale comment, not actively causing wrong code, but produces false belief about the formalization state).

**Recommended action**: The review agent should delete lines 1541–1546 from the blueprint.

No other red flags found:
- No `axiom` declarations
- No `:= True` or `:= rfl` on substantive claims
- No excuse-comments (`-- TODO replace`, `-- temporary`, `-- placeholder`, etc.)
- No `Classical.choice _` on non-trivial claims
- All 4 active `sorry`s are at known-open targets (directive)

---

## Unreferenced declarations (informational)

All substantive declarations in the Lean file have `\lean{}` coverage in the blueprint. No blueprint-unmonitored declarations requiring attention were found.

The three **blueprint-only narrative nodes** (`lem:base_change_mate_inner_unitReduce`, `lem:base_change_mate_inner_eCancel`, `lem:base_change_mate_inner_eCancel_assemble`) intentionally use `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs}` as their pin (the subsuming theorem). Each has an explicit blueprint NOTE explaining the no-dedicated-decl design. This is correct by design, not a gap.

---

## Blueprint adequacy for this file

- **Coverage**: 45/45 Archon `\lean{}` blocks have corresponding Lean declarations. 7 `\mathlibok` Mathlib pins are correctly labelled. 3 blueprint-only narrative nodes are mapped by design to a subsuming theorem. **Coverage: complete.**

- **Proof-sketch depth**: **adequate**. Every theorem has a `\begin{proof}` block in the blueprint with:
  - Named seams (Seam 1/A/B/C/3) cross-referenced by name in the Lean docstrings
  - Step-by-step recipe notes (verbatim LEAN SIGNATURE comments, RECIPE notes, mechanism NOTEs)
  - Explicit identification of the remaining obligations for known-open sorrys

- **Known-open sorry coverage** (not flagging, only assessing adequacy):
  - `base_change_mate_fstar_reindex_legs` (~1446): Blueprint provides a 3-step recipe (steps i/ii/iii), names the eCancel helpers, and has a mechanism NOTE identifying the `X.Modules` instance diamond and prescribing term-mode congruence surgery. **Adequate.**
  - `base_change_mate_gstar_transpose` (~1818): Blueprint provides a 4-step route (counit split → counit transport Seam C → inner value Seam A → generator close), cross-references all supporting lemmas, and has a mechanism NOTE about the nested-image vs composed-functor diamond requiring term-mode surgery. **Adequate.**
  - `affineBaseChange_pushforward_iso` (~1999): Blueprint proof for `lem:affine_base_change_pushforward` provides the full strategy (locality + section-level identification via `pushforward_base_change_mate_cancelBaseChange`); the sorry residual is in connecting `base_change_map_affine_local` to the iso form of the affine step. Inline Lean comment names the blocked step. **Adequate** — the open obligation is the sorry in `base_change_map_affine_local`'s restriction-compatibility proof, which is a known consequence of the `_legs` eCancel sorry; no additional blueprint prose is needed.
  - `flatBaseChange_pushforward_isIso` (~2021): Blueprint proof for `thm:flat_base_change_pushforward` is **very detailed** — Čech-free strategy, separated case (sheaf-condition equalizer + flatness commutes), quasi-separated Mayer–Vietoris induction, explicit identification with `LinearMap.tensorEqLocusEquiv`. **Adequate.**

- **Hint precision**: **precise**. `\lean{}` pins name exact declaration names; `\mathlibok` pins name exact Mathlib identifiers. No ambiguity left for the prover.

- **Generality**: **matches need**. No parallel API was written to compensate for blueprint under-generality.

- **Recommended chapter-side action**: Remove stale NOTE at lines 1541–1546 (see Red Flags). No other chapter-side changes needed.

---

## Severity summary

| Finding | Severity | Location |
|---|---|---|
| Stale NOTE at lines 1541–1546 claims 3 atoms are `private` with mangled names — now false | **major** | blueprint lines 1541–1546 |

No **must-fix-this-iter** findings.
No additional **minor** findings.

**Overall verdict**: All 45 `\lean{}` pins resolve to matching public declarations; 4 known-open sorrys have adequate blueprint coverage; both corrected docstrings are factually accurate and not laundering; the single finding is a stale blueprint comment (major, not blocking) that should be removed now that de-privatization is complete.
