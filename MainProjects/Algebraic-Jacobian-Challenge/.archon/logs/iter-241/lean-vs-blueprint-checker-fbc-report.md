# Lean ↔ Blueprint Check Report

## Slug
fbc

## Iteration
241

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.pushforwardBaseChangeMap}` (chapter: `def:pushforward_base_change_map`)
- **Lean target exists**: yes (L76)
- **Signature matches**: yes — `(comm : g' ≫ f = f' ≫ g) (F : X.Modules) : pullback(g).obj(pushforward(f).obj F) ⟶ pushforward(f').obj(pullback(g').obj F)`, matching `g^*(f_* F) ⟶ f'_*((g')^* F)`
- **Proof follows sketch**: yes — adjoint-transpose of `(pushforward f).map (unit F) ≫ pushforwardComp ≫ pushforwardCongr ≫ pushforwardComp.inv`; blueprint describes exactly this construction
- **Notes**: Declaration is fully axiom-clean and sorry-free. ✓

### `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_stalkFunctor_map}` (chapter: `lem:modules_isIso_iff_stalk`)
- **Lean target exists**: yes (L99–116)
- **Signature matches**: yes — `IsIso φ ↔ ∀ x, IsIso ((stalkFunctor Ab x).map ((toPresheaf X).map φ))`
- **Proof follows sketch**: yes — packages the underlying presheaves as `TopCat.Sheaf` and applies the stalkwise criterion; matches blueprint prose exactly
- **Notes**: axiom-clean. ✓

### `\lean{AlgebraicGeometry.Modules.isIso_of_isIso_app_of_isBasis}` (chapter: `lem:modules_isIso_of_isBasis`)
- **Lean target exists**: yes (L125–153)
- **Signature matches**: yes — `(hB : IsBasis (range B)) (φ : M ⟶ N) (h : ∀ i, IsIso (φ.app (B i))) : IsIso φ`
- **Proof follows sketch**: yes — reduces to stalkwise bijectivity via `lem:modules_isIso_iff_stalk`, then uses `stalkFunctor_map_injective_of_isBasis` + `germ_exist_of_isBasis`
- **Notes**: axiom-clean. ✓

### `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_app_affineOpens}` (chapter: `lem:modules_isIso_iff_affineOpens`)
- **Lean target exists**: yes (L161–166)
- **Signature matches**: yes — `IsIso φ ↔ ∀ U : X.affineOpens, IsIso (φ.app U)`
- **Proof follows sketch**: yes — special case of `lem:modules_isIso_of_isBasis` over the affine-opens basis
- **Notes**: axiom-clean. ✓

### `\lean{AlgebraicGeometry.globalSectionsIso_hom_comp_specMap_appTop}` (chapter: `lem:globalSectionsIso_hom_comp_specMap_appTop`)
- **Lean target exists**: yes (L265–271)
- **Signature matches**: yes — `(globalSectionsIso R).hom ≫ (Spec.map φ).appTop = φ ≫ (globalSectionsIso R').hom`; blueprint states `gs_R ∘ (Spec φ)^#_top = φ ∘ gs_{R'}`
- **Proof follows sketch**: yes — routes via `ΓSpecIso_inv_naturality` after identifying `globalSectionsIso = ΓSpecIso.inv`
- **Notes**: axiom-clean. ✓

### `\lean{AlgebraicGeometry.gammaPushforwardIso}` (chapter: `lem:gammaPushforwardIso`)
- **Lean target exists**: yes (L285–302)
- **Signature matches**: yes — `(moduleSpecΓFunctor (R := R)).obj (pushforward (Spec.map φ)).obj N ≅ (restrictScalars φ.hom).obj ((moduleSpecΓFunctor (R := R')).obj N)`
- **Proof follows sketch**: yes — element-free; both sides peel by `rfl` to nested `restrictScalars` towers; reconciled by `restrictScalarsComp'App` × 2 + `eqToIso` from `globalSectionsIso_hom_comp_specMap_appTop`
- **Notes**: axiom-clean. ✓

### `\lean{AlgebraicGeometry.gammaPushforwardTildeIso}` (chapter: `lem:gammaPushforwardTildeIso`)
- **Lean target exists**: yes (L310–316)
- **Signature matches**: yes — `(moduleSpecΓFunctor (R := R)).obj (pushforward (Spec.map φ)).obj (tilde M) ≅ (restrictScalars φ.hom).obj M`
- **Proof follows sketch**: yes — `gammaPushforwardIso φ (tilde M) ≪≫ (restrictScalars φ.hom).mapIso (toTildeΓNatIso.app M).symm`
- **Notes**: axiom-clean. ✓

### `\lean{AlgebraicGeometry.gammaPushforwardIsoAt}` (chapter: `lem:gammaPushforwardIsoAt`)
- **Lean target exists**: yes (L328–349)
- **Signature matches**: yes — sections of `(Spec φ)_* N` over `U` ≅ `restrictScalars φ.hom` of sections of `N` over `(Spec.map φ).base⁻¹ U`
- **Proof follows sketch**: yes — same construction as `gammaPushforwardIso` with evaluation open changed from `⊤` to `U`; the switch from `eqToIso` to `(restrictScalarsCongr hcomp).app SecN` (the iter-241 refactor) is an implementation detail not breaking the mathematical match
- **Notes**: axiom-clean. ✓

### `\lean{AlgebraicGeometry.tildeRestriction_isLocalizedModule}` (chapter: `lem:tildeRestriction_isLocalizedModule`)
- **Lean target exists**: yes (L480–526)
- **Signature matches**: yes — `IsLocalizedModule (Submonoid.powers b) ((modulesSpecToSheaf.obj (tilde M)).val.map (homOfLE le_top).op).hom`
- **Proof follows sketch**: yes — uses triangle identity `toOpen_fromTildeΓ_app`, bijectivity of `toOpen M ⊤` (localization at `powers 1 = ⊤`), then `LinearEquiv.eq_comp_toLinearMap_symm`
- **Notes**: axiom-clean. ✓

### `\lean{AlgebraicGeometry.IsLocalizedModule.powers_restrictScalars}` (chapter: `lem:powers_restrictScalars`)
- **Lean target exists**: yes (L452–471)
- **Signature matches**: yes — `[IsLocalizedModule (algMap A S) f] : IsLocalizedModule S (f.restrictScalars R)`; blueprint describes the exact converse of `IsLocalizedModule.of_restrictScalars`
- **Proof follows sketch**: yes — three conditions of `IsLocalizedModule` checked using `algebraMap_smul` / scalar tower
- **Notes**: axiom-clean. ✓

### `\lean{AlgebraicGeometry.fromTildeΓ_app_isIso_of_isLocalizedModule}` (chapter: `lem:fromTildeGamma_app_isIso_of_localized`)
- **Lean target exists**: yes (L364–408)
- **Signature matches**: yes — `[IsLocalizedModule (powers a) ρ] : IsIso (N.fromTildeΓ.app (basicOpen a))`
- **Proof follows sketch**: yes — triangle identity `L ∘ j = ρ` + uniqueness of localized modules (via `IsLocalizedModule.ext`) gives `L = e` (the canonical iso between the two localizations)
- **Notes**: axiom-clean. ✓

### `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso_of_isLocalizedModule}` (chapter: `lem:pushforward_spec_tilde_iso_conditional`)
- **Lean target exists**: yes (L428–443)
- **Signature matches**: yes — `(hloc : ∀ a, IsLocalizedModule (powers a) ρ_a) : (pushforward (Spec.map φ)).obj (tilde M) ≅ tilde ((restrictScalars φ.hom).obj M)`
- **Proof follows sketch**: yes — applies `fromTildeΓ_app_isIso_of_isLocalizedModule` for each `a`, uses basis-local criterion, then composes counit inverse with `tilde.mapIso (gammaPushforwardTildeIso)`
- **Notes**: axiom-clean. ✓

### `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso}` (chapter: `lem:pushforward_spec_tilde_iso`)
- **Lean target exists**: yes (L535–650)
- **Signature matches**: yes — `(pushforward (Spec.map φ)).obj (tilde M) ≅ tilde ((restrictScalars φ.hom).obj M)`
- **Proof follows sketch**: **partial match** (see detailed note)
- **Notes**: The proof is sorry-free and axiom-clean as of iter-241. Mathematical content matches the blueprint's three movements. However, there is a **narrative divergence** on movement (2): the blueprint proof block's `\uses{}` references `lem:gammaPushforwardIsoAt_naturality` (a standalone labeled lemma at blueprint L306–372) as if the Lean proof invokes a separate declaration. In actuality, the naturality square (`hsq : ρ ≫ e₂.hom = e₁.hom ≫ Gmor`) is proved **inline** at L624–638 via `ext x; rfl` — no standalone `AlgebraicGeometry.gammaPushforwardIsoAt_naturality` declaration exists. The `\leanok` on the proof block (L551) is correctly placed.

### `\lean{AlgebraicGeometry.affineBaseChange_pushforward_iso}` (chapter: `lem:affine_base_change_pushforward`)
- **Lean target exists**: yes (L658–682)
- **Signature matches**: yes — `(h : IsPullback g' f' f g) [IsAffineHom f] (F : X.Modules) [F.IsQuasicoherent] : IsIso (pushforwardBaseChangeMap f g f' g' h.w F)`
- **Proof follows sketch**: **no** — Lean proof only executes step 1 (the affine-open locality reduction via `Modules.isIso_iff_isIso_app_affineOpens`) and then `sorry`. The blueprint's steps 2–3 (full-faithfulness of tilde reframe; identification with `cancelBaseChange`) are not yet formalized.
- **Notes**: sorry at L682 is **authorized** — blueprint statement block has `\leanok` (meaning at least a sorry), proof block correctly has no `\leanok`. The sorry comment at L668–681 gives a clear roadmap; this is not an excuse-comment for wrong code. The open obligation is now: (a) a pullback-of-tilde dictionary (analogue of `pushforward_spec_tilde_iso` for pullback), and (b) connecting `pushforwardBaseChangeMap` (adjoint-transpose) to `cancelBaseChange`.

### `\lean{AlgebraicGeometry.flatBaseChange_pushforward_isIso}` (chapter: `thm:flat_base_change_pushforward`)
- **Lean target exists**: yes (L691–704)
- **Signature matches**: yes — `(h : IsPullback g' f' f g) [Flat g] [QuasiCompact f] [QuasiSeparated f] (F : X.Modules) [F.IsQuasicoherent] : IsIso (pushforwardBaseChangeMap f g f' g' h.w F)`
- **Proof follows sketch**: **no** — documented `sorry` only; full proof needs Čech-cohomology / affine-cover infrastructure absent from Mathlib
- **Notes**: sorry at L704 is **authorized** — blueprint statement block has `\leanok`, proof block correctly has no `\leanok`. The sorry comment (L695–703) clearly documents the deferred strategy. Not a red flag.

---

## Red flags

### Standalone blueprint lemma with no Lean declaration (major)

**`lem:gammaPushforwardIsoAt_naturality`** (blueprint L306–372): This is a fully-written standalone lemma in the blueprint with `\label{lem:gammaPushforwardIsoAt_naturality}` but:
- **No `\lean{...}` pin** — no corresponding Lean declaration name is given
- **No `\leanok` marker** on either the statement or proof block — correctly indicating it is unformalized as a standalone decl
- The content (the naturality square `ρ ≫ e₂ = e₁ ≫ Gmor`) is **inlined** in `pushforward_spec_tilde_iso` (L624–638) and proved by `ext x; rfl`
- The proof block of `lem:pushforward_spec_tilde_iso` includes `lem:gammaPushforwardIsoAt_naturality` in its `\uses{}` list (L554), which is technically correct (the content is used) but creates a dependency the blueprint-doctor will flag: the reference target is an unformalized standalone block

This creates an inconsistency: the `\uses{}` dependency chain from `pushforward_spec_tilde_iso`'s proof to `lem:gammaPushforwardIsoAt_naturality` is valid mathematically but creates an apparent unresolved dependency from blueprint-doctor's perspective (no `\leanok` on the target, no `\lean{...}` pin). The review agent should add a `% NOTE:` on `lem:gammaPushforwardIsoAt_naturality` explaining the naturality is proved inline (via `ext x; rfl`) in `pushforward_spec_tilde_iso`, and/or remove the standalone lemma block in favor of an inline prose remark.

### Historical workflow comments in Lean docstring (minor)

Lines L181–244 of the Lean file are a multi-paragraph historical STATUS comment embedded in a module docstring — they describe the iter-234 carrier-wall failure and the iter-236 route-(b) success. While not excuse-comments (they are accurate history, and the UPDATE paragraph documents the working route), they are stale relative to the current completed proof. A code-audit subagent could flag them, but they do not affect correctness.

---

## Unreferenced declarations (informational)

Every substantive declaration in the Lean file has a matching `\lean{...}` pin in the blueprint. No unreferenced substantive declarations. ✓

---

## Blueprint adequacy for this file

### Coverage
15/15 Lean declarations have a corresponding `\lean{...}` block in the chapter. No substantive unreferenced declarations.

One blueprint block (`lem:gammaPushforwardIsoAt_naturality`) is unformalized as a standalone decl and has no `\lean{}` pin — its content is inlined. This counts as a blueprint→Lean gap.

### Proof-sketch depth
**Partially adequate.** Specifically:

- **`pushforward_spec_tilde_iso`** — the three-movement sketch (L556–733) is detailed and accurate for the now-closed proof. The `eqToIso → restrictScalarsCongr` refactor (iter-241) is a Lean implementation detail not visible in the blueprint prose; the mathematical steps match. ✓
- **`affineBaseChange_pushforward_iso`** — **under-specified** for the still-open obligations. The blueprint correctly identifies the strategy (locality reduction, then full-faithfulness of tilde, then `cancelBaseChange`), but it does NOT describe:
  1. How to formalize the pullback-of-tilde dictionary (the pullback analogue of `pushforward_spec_tilde_iso`), which is required to identify `(g')^* F` as `tilde ((R' ⊗_R A) ⊗_A M)` at the section level
  2. How to connect `pushforwardBaseChangeMap` (built as an adjoint transpose) to the concrete `cancelBaseChange` map from `TensorProduct.AlgebraTensorModule`
  
  The `% NOTE` comment (L812–819) in the blueprint correctly identifies `pushforward_spec_tilde_iso` as the next target (now done), but the proof sketch does not give enough detail for the remaining Lean formalization work. A blueprint-writing agent should expand the proof sketch for `lem:affine_base_change_pushforward` with: the explicit tilde-pullback dictionary statement, the identification strategy for `pushforwardBaseChangeMap` ↔ `cancelBaseChange`, and the specific Lean API (`TensorProduct.AlgebraTensorModule.cancelBaseChange`) to invoke.

- **`flatBaseChange_pushforward_isIso`** — the proof sketch (L1006–1064) is adequate as a mathematical roadmap but correctly deferred; the Čech-cohomology prerequisite is honestly documented as absent.

### Hint precision
**Precise** for all 13 formalized declarations. `\lean{...}` names resolve correctly to declarations of matching signature. The one imprecision is the absence of a `\lean{...}` pin on `lem:gammaPushforwardIsoAt_naturality`.

### Generality
**Matches need** — all formalized declarations are at the generality level the project requires.

### Recommended chapter-side actions (for blueprint-writing agent)
1. **`lem:gammaPushforwardIsoAt_naturality`**: Add `% NOTE: content is proved inline in pushforward_spec_tilde_iso via ext x; rfl (no standalone Lean decl); the \uses{} reference from pushforward_spec_tilde_iso's proof block is mathematically correct but this block should not be expected to receive \leanok separately.` OR demote to a prose remark inside `lem:gammaPushforwardIsoAt`'s proof block and remove the standalone label (updating the `\uses{}` list accordingly).
2. **`lem:affine_base_change_pushforward` proof sketch**: Expand with explicit guidance on (a) the pullback-of-tilde dictionary needed (analogous to `pushforward_spec_tilde_iso` but for `pullback`), and (b) the identification of `pushforwardBaseChangeMap` with `cancelBaseChange` at the categorical/section level.

---

## Severity summary

- **must-fix-this-iter**: None. No wrong signatures, no unauthorized sorries, no excuse-comments, no axioms.
- **major**:
  1. `lem:gammaPushforwardIsoAt_naturality` (blueprint L306–372) has no `\lean{}` pin and no `\leanok`; its content is inlined in `pushforward_spec_tilde_iso` (Lean L624–638). The `\uses{}` reference to it from `lem:pushforward_spec_tilde_iso`'s proof block is mathematically accurate but will confuse blueprint-doctor and future readers. A `% NOTE:` annotation or structural fix is needed.
  2. `lem:affine_base_change_pushforward` proof sketch is under-specified for the remaining open obligations (pullback-of-tilde dictionary + `cancelBaseChange` connection).
- **minor**:
  1. Historical STATUS block in the Lean module docstring (L181–244) is stale post-proof-closure; could be trimmed.
  2. The blueprint's proof narrative for `lem:pushforward_spec_tilde_iso` uses `lem:gammaPushforwardIsoAt_naturality` as if invoking a separate declaration, while the Lean proof closes the naturality square inline.

**Overall verdict**: The `pushforward_spec_tilde_iso` closure is correctly reflected — the proof block has `\leanok`, the signature matches, and the mathematical steps in the Lean proof align with the blueprint's three-movement sketch. The two remaining sorries (`affineBaseChange_pushforward_iso`, `flatBaseChange_pushforward_isIso`) are authorized and correctly marked. The principal issue requiring attention before the next prover iteration is the dangling `lem:gammaPushforwardIsoAt_naturality` standalone block (no `\lean{}` pin, content inlined, stale `\uses{}` dependency) which the review agent should annotate.
