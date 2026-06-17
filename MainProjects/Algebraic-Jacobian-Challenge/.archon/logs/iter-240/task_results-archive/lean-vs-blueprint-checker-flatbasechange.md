# Lean ↔ Blueprint Check Report

## Slug
flatbasechange

## Iteration
239

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.pushforwardBaseChangeMap}` (chapter: `def:pushforward_base_change_map`)
- **Lean target exists**: yes (line 76)
- **Signature matches**: yes — `pullback g (pushforward f F) ⟶ pushforward f' (pullback g' F)`, adjoint to the unit composite
- **Proof follows sketch**: yes — adjoint to `(pushforward f).map (unit.app F) ≫ pushforwardComp ≫ pushforwardCongr ≫ pushforwardComp.inv`, matching the blueprint description
- **notes**: No sorry. Statement has `\leanok`. ✓

---

### `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_stalkFunctor_map}` (chapter: `lem:modules_isIso_iff_stalk`)
- **Lean target exists**: yes (line 99)
- **Signature matches**: yes — iff between `IsIso φ` and stalkwise isomorphism at every point
- **Proof follows sketch**: yes — packages underlying Ab-presheaves as `TopCat.Sheaf`, applies `isIso_of_stalkFunctor_map_iso`, reflects back via `toPresheaf`
- **notes**: No sorry. Statement has `\leanok`. ✓

---

### `\lean{AlgebraicGeometry.Modules.isIso_of_isIso_app_of_isBasis}` (chapter: `lem:modules_isIso_of_isBasis`)
- **Lean target exists**: yes (line 125)
- **Signature matches**: yes — indexed family of opens `B : ι → X.Opens` with `IsBasis (range B)`, elementwise iso implies global iso
- **Proof follows sketch**: yes — reduces to stalkwise via `isIso_iff_isIso_stalkFunctor_map`, then injectivity/surjectivity from `germ_exist_of_isBasis` and section-level isomorphism over each basic open
- **notes**: No sorry. Statement has `\leanok`. ✓

---

### `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_app_affineOpens}` (chapter: `lem:modules_isIso_iff_affineOpens`)
- **Lean target exists**: yes (line 161)
- **Signature matches**: yes — iff between `IsIso φ` and `∀ U : X.affineOpens, IsIso (φ.app U)`
- **Proof follows sketch**: yes — special case of `isIso_of_isIso_app_of_isBasis` with `X.isBasis_affineOpens`
- **notes**: No sorry. Statement has `\leanok`. ✓

---

### `\lean{AlgebraicGeometry.globalSectionsIso_hom_comp_specMap_appTop}` (chapter: `lem:globalSectionsIso_hom_comp_specMap_appTop`)
- **Lean target exists**: yes (line 265)
- **Signature matches**: yes — `(globalSectionsIso R).hom ≫ (Spec.map φ).appTop = φ ≫ (globalSectionsIso R').hom`
- **Proof follows sketch**: yes — unfolds via `ΓSpecIso` and applies `ΓSpecIso_inv_naturality`
- **notes**: No sorry. Statement has `\leanok`. ✓

---

### `\lean{AlgebraicGeometry.gammaPushforwardIso}` (chapter: `lem:gammaPushforwardIso`)
- **Lean target exists**: yes (line 285)
- **Signature matches**: yes — `moduleSpecΓFunctor.obj (pushforward (Spec.map φ) N) ≅ (restrictScalars φ.hom).obj (moduleSpecΓFunctor.obj N)`
- **Proof follows sketch**: yes — element-free route (b): two `restrictScalarsComp'App` collapses + `eqToIso` from `globalSectionsIso_hom_comp_specMap_appTop`
- **notes**: No sorry. Statement has `\leanok`. ✓

---

### `\lean{AlgebraicGeometry.gammaPushforwardTildeIso}` (chapter: `lem:gammaPushforwardTildeIso`)
- **Lean target exists**: yes (line 310)
- **Signature matches**: yes — specialises to `N = tilde M`, composes with `tilde.toTildeΓNatIso`
- **Proof follows sketch**: yes — one-liner: `gammaPushforwardIso φ (tilde M) ≪≫ (restrictScalars φ.hom).mapIso (toTildeΓNatIso.app M).symm`
- **notes**: No sorry. Statement has `\leanok`. ✓

---

### `\lean{AlgebraicGeometry.IsLocalizedModule.powers_restrictScalars}` (chapter: `lem:powers_restrictScalars`)
- **Lean target exists**: yes (line 452)
- **Signature matches**: yes — `[IsLocalizedModule (algebraMapSubmonoid A S) f] → IsLocalizedModule S (f.restrictScalars R)`, converse of `of_restrictScalars`
- **Proof follows sketch**: yes — three defining conditions (`map_units`, `surj`, `exists_of_eq`) using scalar-tower compatibility
- **notes**: No sorry. Statement has `\leanok`. ✓

---

### `\lean{AlgebraicGeometry.fromTildeΓ_app_isIso_of_isLocalizedModule}` (chapter: `lem:fromTildeGamma_app_isIso_of_localized`)
- **Lean target exists**: yes (line 364)
- **Signature matches**: yes — `[IsLocalizedModule (powers a) ρ] → IsIso (fromTildeΓ N).app (basicOpen a)`, where `ρ` is the restriction map
- **Proof follows sketch**: yes — triangle identity `L ∘ₗ j = ρ`, uniqueness via `IsLocalizedModule.ext`, yields bijectivity of `L = e.toLinearMap`
- **notes**: No sorry. Statement has `\leanok`. ✓

---

### `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso_of_isLocalizedModule}` (chapter: `lem:pushforward_spec_tilde_iso_conditional`)
- **Lean target exists**: yes (line 428)
- **Signature matches**: yes — takes `hloc : ∀ a, IsLocalizedModule (powers a) (restriction map of pushforward)` and builds the object iso
- **Proof follows sketch**: yes — `isIso_of_isIso_app_of_isBasis` over basic opens with `fromTildeΓ_app_isIso_of_isLocalizedModule`, then `(asIso fromTildeΓ).symm ≪≫ tilde.mapIso (gammaPushforwardTildeIso …)`
- **notes**: No sorry. Statement has `\leanok`. ✓

---

### `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso}` (chapter: `lem:pushforward_spec_tilde_iso`)
- **Lean target exists**: yes (line 535)
- **Signature matches**: yes — `(pushforward (Spec.map φ)).obj (tilde M) ≅ tilde ((restrictScalars φ.hom).obj M)`
- **Proof follows sketch**: partial — movements (1) and (3) described in the chapter match the Lean strategy; **movement (2) is inaccurate** (see Red Flags below)
- **notes**: Body has `sorry` at line 572 (the `hloc` discharge). Blueprint statement block is missing `\leanok` despite sorry-bearing decl existing — likely a sync_leanok timing miss this iter (minor). More critically: the proof block over-describes movement (2) without acknowledging the carrier-wall obstacle.

---

### `\lean{AlgebraicGeometry.affineBaseChange_pushforward_iso}` (chapter: `lem:affine_base_change_pushforward`)
- **Lean target exists**: yes (line 580)
- **Signature matches**: yes — `[IsAffineHom f] → [F.IsQuasicoherent] → IsIso (pushforwardBaseChangeMap … F)`
- **Proof follows sketch**: N/A (body is sorry; blueprint `% NOTE:` correctly identifies it as "in progress", blocked on `pushforward_spec_tilde_iso`)
- **notes**: Sorry at line 604. Statement has `\leanok` ✓. Proof block correctly has no `\leanok`.

---

### `\lean{AlgebraicGeometry.flatBaseChange_pushforward_isIso}` (chapter: `thm:flat_base_change_pushforward`)
- **Lean target exists**: yes (line 613)
- **Signature matches**: yes — `[Flat g] → [QuasiCompact f] → [QuasiSeparated f] → [F.IsQuasicoherent] → IsIso (pushforwardBaseChangeMap … F)`
- **Proof follows sketch**: N/A (documented sorry; blueprint `% NOTE:` explicitly says "deferred")
- **notes**: Sorry at line 626. Statement has `\leanok` ✓. Proof block correctly has no `\leanok`.

---

## Red flags

### Placeholder / suspect bodies

- `pushforward_spec_tilde_iso` at line 535–572: body is `apply pushforward_spec_tilde_iso_of_isLocalizedModule … ; intro a ; … ; sorry`. The `sorry` is the `hloc` discharge. The blueprint claims a specific proof route (movements 1–3) that is partially realizable but CURRENTLY BLOCKED by the carrier-instance wall described in the Lean comment. The blueprint's statement block does not have `\leanok` and the proof block does not have `\leanok`, so technically no false completeness claim is made — but see Blueprint Adequacy section for the misleading movement (2) issue.

- `affineBaseChange_pushforward_iso` at line 580: sorry. Correctly flagged as in-progress in blueprint `% NOTE:`.

- `flatBaseChange_pushforward_isIso` at line 613: sorry. Correctly flagged as deferred in blueprint `% NOTE:`.

*(No must-fix-this-iter: the sorry-bearing decls are the documented open obligations, and the blueprint does not mark their proofs as `\leanok`.)*

---

## Unreferenced declarations (informational)

### `AlgebraicGeometry.gammaPushforwardIsoAt` (line 328) — **MAJOR: should be pinned**

This declaration is the `D(a)`-level (arbitrary-open) generalization of `gammaPushforwardIso`. It is the Lean realization of the `e_{D(a)}` isomorphism described in movement (1) of the `lem:pushforward_spec_tilde_iso` proof sketch. The blueprint explicitly says "construct an R-linear isomorphism `e_{D(a)}`" in that proof, but provides no `\lean{}` pin for the Lean decl that implements it.

**Should the chapter pin it?** Yes — it deserves its own lemma block, with `\lean{AlgebraicGeometry.gammaPushforwardIsoAt}` and a label such as `\label{lem:gammaPushforwardIsoAt}`. Best placement: immediately after `lem:gammaPushforwardIso` (of which it is a generalization) and before `lem:gammaPushforwardTildeIso`, with a `\uses{lem:globalSectionsIso_hom_comp_specMap_appTop}` dependency. The block should note that its construction is *identical* to `gammaPushforwardIso` (same two `restrictScalarsComp'App` collapses, same ⊤-level ring equation) with only the evaluation open changed.

**Could it be covered by `lem:gammaPushforwardIso`?** No. `gammaPushforwardIso` is specifically the ⊤-open case (it uses `moduleSpecΓFunctor`, which evaluates at `⊤`). `gammaPushforwardIsoAt` evaluates at an arbitrary open `U` and uses `modulesSpecToSheaf`, which is a different functor. These are distinct decls with different types; a `\lean{}` pin on `lem:gammaPushforwardIso` does not cover `gammaPushforwardIsoAt`.

### `AlgebraicGeometry.tildeRestriction_isLocalizedModule` (line 480) — **MAJOR: should be pinned**

This declaration establishes that for `M : ModuleCat R'` and `b : R'`, the structure-sheaf restriction map `Γ(M^~, ⊤) → Γ(M^~, D(b))` is a localization at `Submonoid.powers b`. It is the `R'`-side localization input that movement (3) of the `pushforward_spec_tilde_iso` proof requires ("the target `Γ(M^~, D(φa)) = M[1/φa]` is canonically the `powers(φa)`-localization").

**Should a block pin it?** Yes. It is a substantive lemma whose formal statement is non-trivial (the proof goes through the tilde-localization map `toOpen`, triangle identity `toOpen_res`, and `IsLocalizedModule.of_linearEquiv_right`). Best placement: after `lem:powers_restrictScalars` and before `lem:fromTildeGamma_app_isIso_of_localized` — both it and `powers_restrictScalars` are "ring-change inputs" for the `hloc` discharge. Suggested label: `\label{lem:tildeRestriction_isLocalizedModule}` with `\uses{}` empty (it only depends on Mathlib tilde infrastructure).

---

## Blueprint adequacy for this file

- **Coverage**: 11/13 Lean declarations have a corresponding `\lean{...}` block (plus `\leanok` markers consistent with sorry states). Unreferenced declarations: 2 substantive (flagged above: `gammaPushforwardIsoAt`, `tildeRestriction_isLocalizedModule`).
- **Proof-sketch depth**: **under-specified** for the open obligation (`pushforward_spec_tilde_iso`), adequate for all closed lemmas.
  - **Specific issue — blueprint movement (2) is wrong/misleading**: The `lem:pushforward_spec_tilde_iso` proof sketch describes movement (2) as requiring a "D(a)-level ring equation" that is "the D(a)-shadow of `globalSectionsIso_hom_comp_specMap_appTop`", distinct from the ⊤-level equation. But the Lean implementation of `gammaPushforwardIsoAt` uses the **same** ⊤-level equation (`globalSectionsIso_hom_comp_specMap_appTop`) for all opens. This works because `modulesSpecToSheaf` restricts scalars uniformly along the global-sections ring map at `⊤`, not along a D(a)-level map. The blueprint comment in the Lean file explicitly says: "Because `modulesSpecToSheaf` forgets to the *global* section ring uniformly …, the construction is *identical* to that of `gammaPushforwardIso`." Movement (2) as written would send a prover hunting for a D(a)-level ring equation that is neither needed nor provable in this framework.
  - **Specific issue — carrier wall obstacle absent from blueprint**: The Lean `pushforward_spec_tilde_iso` sorry body includes an extensive REMAINING OBSTACLE comment (lines 562–571) describing a carrier-instance wall: the naturality square between `e_⊤` and `e_{D(a)}` requires an `R`-module structure on `R'`-side sections via `Module.compHom _ φ.hom` that is not a synthesizable instance and clashes with the `modulesSpecToSheaf`-supplied `R`-action. The blueprint's proof sketch for movement (3) ("Transporting that localization property back across the linear equivalence `e_{D(a)}`") is written as though this transport is routine. No `% NOTE:` in the proof block warns of this obstacle.
- **Hint precision**: **loose** for `gammaPushforwardIsoAt` and `tildeRestriction_isLocalizedModule` (prose describes them but no `\lean{}` pins exist). All 11 pinned decls have precise matching signatures.
- **Generality**: matches need for all pinned decls. `gammaPushforwardIsoAt` is correctly at the right generality (arbitrary open, `modulesSpecToSheaf`); `gammaPushforwardIso` is the ⊤-specialization, not a generalization — the file has both at the right levels.
- **Recommended chapter-side actions** (for a blueprint-writing subagent):
  1. Add a new lemma block for `\lean{AlgebraicGeometry.gammaPushforwardIsoAt}` (label `lem:gammaPushforwardIsoAt`) after `lem:gammaPushforwardIso`, noting it is the arbitrary-open generalization and that its construction is *identical* to `gammaPushforwardIso` (same ⊤-level ring equation, same `restrictScalarsComp'App` route) with only the evaluation open changed.
  2. Add a new lemma block for `\lean{AlgebraicGeometry.tildeRestriction_isLocalizedModule}` (label `lem:tildeRestriction_isLocalizedModule`) between `lem:powers_restrictScalars` and `lem:fromTildeGamma_app_isIso_of_localized`.
  3. Correct movement (2) of the `lem:pushforward_spec_tilde_iso` proof: remove the claim that a D(a)-level ring equation is needed. The correct description is: `e_{D(a)}` is constructed by `gammaPushforwardIsoAt φ (tilde M) (basicOpen a)`, which uses the existing ⊤-level `lem:globalSectionsIso_hom_comp_specMap_appTop` unchanged.
  4. Add a `% NOTE:` in the proof block of `lem:pushforward_spec_tilde_iso` documenting the carrier-instance wall obstacle: the naturality square `e_{D(a)} ∘ ρ = (restrictScalars φ σ) ∘ e_⊤` cannot be proved without an explicit `R`-module structure on `R'`-side sections that is not synthesizable from `modulesSpecToSheaf`'s global-ring action; the open route is `IsLocalizedModule.of_linearEquiv` applied to both `e_⊤` and `e_{D(a)}` to avoid naming the intermediate `R`-action.
  5. (Minor) The statement block of `lem:pushforward_spec_tilde_iso` is missing `\leanok` despite a sorry-bearing decl existing — sync_leanok should pick this up automatically, but check if the decl was added after the last sync run.

---

## Severity summary

| Finding | Severity |
|---|---|
| `gammaPushforwardIsoAt` (line 328): substantive new decl implementing blueprint movement (1) `e_{D(a)}`; no `\lean{}` pin | **major** |
| `tildeRestriction_isLocalizedModule` (line 480): substantive new decl for `R'`-side localization input (movement 3); no `\lean{}` pin | **major** |
| Blueprint movement (2) for `lem:pushforward_spec_tilde_iso` describes a non-existent D(a)-level ring equation; actual Lean uses only ⊤-level equation | **major** |
| Carrier-instance wall obstacle (lines 562–571 in Lean) blocking the `hloc` sorry entirely absent from blueprint proof sketch | **major** |
| Missing `\leanok` on `lem:pushforward_spec_tilde_iso` statement block despite sorry-bearing decl at line 535 (likely sync_leanok timing miss) | **minor** |
| `lem:pushforward_spec_tilde_iso` proof text is written as a complete argument with no visible incompleteness signal in rendered output | **minor** |

**Overall verdict**: Ten of thirteen `\lean{}`-pinned declarations are sorry-free and consistent with their blueprint blocks; the two iter-239 helper decls (`gammaPushforwardIsoAt`, `tildeRestriction_isLocalizedModule`) are unpinned despite driving the open `hloc` obligation, and the blueprint's movement (2) in the proof sketch for `lem:pushforward_spec_tilde_iso` describes a D(a)-level ring equation that neither exists nor is needed, misdirecting any prover who follows it literally — 4 major findings, 2 minor, 0 must-fix-this-iter.
