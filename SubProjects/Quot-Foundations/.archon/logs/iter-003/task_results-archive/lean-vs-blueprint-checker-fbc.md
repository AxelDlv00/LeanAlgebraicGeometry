# Lean ↔ Blueprint Check Report

## Slug
fbc

## Iteration
002

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.pushforwardBaseChangeMap}` (chapter: `def:pushforward_base_change_map`)
- **Lean target exists**: yes (line 76)
- **Signature matches**: yes — `(comm : g' ≫ f = f' ≫ g) (F : X.Modules)` producing the canonical map `g^*(f_* F) ⟶ f'_*((g')^* F)`; blueprint's intended signature matches exactly.
- **Proof follows sketch**: yes — adjoint mate of unit, built via `pullbackPushforwardAdjunction` transpose and the four pseudofunctor isos. No sorry.
- **notes**: Complete. Blueprint description of the mate construction matches the four-term composite in the Lean body.

---

### `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_stalkFunctor_map}` (chapter: `lem:modules_isIso_iff_stalk`)
- **Lean target exists**: yes (line 99)
- **Signature matches**: yes — `IsIso φ ↔ ∀ x, IsIso (stalkFunctor Ab x . map (toPresheaf X . map φ))`.
- **Proof follows sketch**: yes — forward by functor, backward via `isIso_of_stalkFunctor_map_iso` + `reflects_iso`. No sorry.
- **notes**: Complete.

---

### `\lean{AlgebraicGeometry.Modules.isIso_of_isIso_app_of_isBasis}` (chapter: `lem:modules_isIso_of_isBasis`)
- **Lean target exists**: yes (line 125)
- **Signature matches**: yes — takes a `TopologicalSpace.Opens.IsBasis` witness, the per-basis-open `IsIso` hypothesis, concludes `IsIso φ`.
- **Proof follows sketch**: yes — reduces via `isIso_iff_isIso_stalkFunctor_map`, then splits into injectivity (via `stalkFunctor_map_injective_of_isBasis`) and surjectivity (via `germ_exist_of_isBasis`). No sorry.
- **notes**: Complete. Proof matches the blueprint's injectivity-from-basis and surjectivity-from-germ argument.

---

### `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_app_affineOpens}` (chapter: `lem:modules_isIso_iff_affineOpens`)
- **Lean target exists**: yes (line 161)
- **Signature matches**: yes.
- **Proof follows sketch**: yes — forward by `inferInstance`, backward by `isIso_of_isIso_app_of_isBasis` with `X.isBasis_affineOpens`. No sorry.
- **notes**: Complete.

---

### `\lean{AlgebraicGeometry.globalSectionsIso_hom_comp_specMap_appTop}` (chapter: `lem:globalSectionsIso_hom_comp_specMap_appTop`)
- **Lean target exists**: yes (line 265)
- **Signature matches**: yes — ring equation `gsR.hom ≫ (Spec φ).appTop = φ ≫ gsR'.hom`.
- **Proof follows sketch**: yes — `rfl` on `globalSectionsIso = ΓSpecIso.inv`, then `ΓSpecIso_inv_naturality`. No sorry.
- **notes**: Complete.

---

### `\lean{AlgebraicGeometry.gammaPushforwardIso}` (chapter: `lem:gammaPushforwardIso`)
- **Lean target exists**: yes (line 285)
- **Signature matches**: yes — `moduleSpecΓFunctor(R).obj ((Spec φ)_* N) ≅ restrictScalars φ (moduleSpecΓFunctor(R').obj N)`.
- **Proof follows sketch**: yes — element-free route (b): two `restrictScalarsComp'App` isos plus `restrictScalarsCongr hcomp`, where `hcomp` comes from `globalSectionsIso_hom_comp_specMap_appTop`. No sorry.
- **notes**: Complete. The verbose STATUS/UPDATE comments (lines 181–244) document the *resolved* carrier-wall history for a prior failed route (a); this is historical documentation, not an active red flag — the proof compiles sorry-free.

---

### `\lean{AlgebraicGeometry.gammaPushforwardTildeIso}` (chapter: `lem:gammaPushforwardTildeIso`)
- **Lean target exists**: yes (line 310)
- **Signature matches**: yes.
- **Proof follows sketch**: yes — `gammaPushforwardIso φ (tilde M) ≪≫ (restrictScalars φ).mapIso (tilde.toTildeΓNatIso.app M).symm`. No sorry.
- **notes**: Complete.

---

### `\lean{AlgebraicGeometry.gammaPushforwardIsoAt}` (chapter: `lem:gammaPushforwardIsoAt`)
- **Lean target exists**: yes (line 328)
- **Signature matches**: yes — open-indexed version; `Γ((Spec φ)_* N, U) ≅ restrictScalars φ (Γ(N, (Spec φ)⁻¹ U))`.
- **Proof follows sketch**: yes — verbatim copy of `gammaPushforwardIso` construction with `⊤` replaced by `U`. No sorry.
- **notes**: Complete. Blueprint also describes naturality in the open as a "remark" in the proof; the Lean proof of `pushforward_spec_tilde_iso` relies on this by a pointwise-`rfl` naturality square (`hsq` at line 624), which closes because every constituent of `gammaPushforwardIsoAt` is identity-on-elements.

---

### `\lean{AlgebraicGeometry.tildeRestriction_isLocalizedModule}` (chapter: `lem:tildeRestriction_isLocalizedModule`)
- **Lean target exists**: yes (line 480)
- **Signature matches**: yes.
- **Proof follows sketch**: yes — bijectivity of `toOpen ⊤`, triangle identity `toOpen_res`, then `of_linearEquiv_right`. No sorry.
- **notes**: Complete.

---

### `\lean{AlgebraicGeometry.IsLocalizedModule.powers_restrictScalars}` (chapter: `lem:powers_restrictScalars`)
- **Lean target exists**: yes (line 452)
- **Signature matches**: yes — checks all three `IsLocalizedModule` conditions.
- **Proof follows sketch**: yes — `map_units` via `IsScalarTower`, `surj` via algebraMapSubmonoid transport, `exists_of_eq` similarly. No sorry.
- **notes**: Complete.

---

### `\lean{AlgebraicGeometry.fromTildeΓ_app_isIso_of_isLocalizedModule}` (chapter: `lem:fromTildeGamma_app_isIso_of_localized`)
- **Lean target exists**: yes (line 364)
- **Signature matches**: yes.
- **Proof follows sketch**: yes — triangle identity `toOpen_fromTildeΓ_app`, uniqueness of localized module via `IsLocalizedModule.iso`, forces `L = e.toLinearMap`, concludes bijection. No sorry.
- **notes**: Complete.

---

### `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso_of_isLocalizedModule}` (chapter: `lem:pushforward_spec_tilde_iso_conditional`)
- **Lean target exists**: yes (line 428)
- **Signature matches**: yes — takes `hloc : ∀ a, IsLocalizedModule (powers a) (ρ a)`, produces `(Spec φ)_* (tilde M) ≅ tilde (restrictScalars φ M)`.
- **Proof follows sketch**: yes — `isIso_of_isIso_app_of_isBasis` over basic opens + `fromTildeΓ_app_isIso_of_isLocalizedModule`, then `asIso (fromTildeΓ _).symm ≪≫ tilde.functor.mapIso gammaPushforwardTildeIso`. No sorry.
- **notes**: Complete.

---

### `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso}` (chapter: `lem:pushforward_spec_tilde_iso`)
- **Lean target exists**: yes (line 535)
- **Signature matches**: yes — unconditional iso `(Spec φ)_* (tilde M) ≅ tilde (restrictScalars φ M)`.
- **Proof follows sketch**: yes — applies `pushforward_spec_tilde_iso_of_isLocalizedModule`; discharges `hloc` via `algebraize [φ.hom]`, `tildeRestriction_isLocalizedModule`, `powers_restrictScalars`, and the pointwise-`rfl` naturality square `hsq`. No sorry.
- **notes**: Complete. This is the most involved proof in the file and is sorry-free.

---

### `\lean{AlgebraicGeometry.pullback_spec_tilde_iso}` (chapter: `lem:pullback_spec_tilde_iso`)
- **Lean target exists**: yes (line 686)
- **Signature matches**: yes.
- **Proof follows sketch**: yes — uniqueness-of-left-adjoints via `conjugateIsoEquiv` applied to `gammaPushforwardNatIso`. No sorry.
- **notes**: Complete.

---

### `\lean{AlgebraicGeometry.base_change_map_affine_local}` (chapter: `lem:base_change_map_affine_local`)
- **Lean target exists**: yes (line 754)
- **Signature matches**: yes — type matches blueprint's "Intended formalized signature" exactly: takes `H : ∀ U, IsIso (.app U)`, proves `IsIso (pushforwardBaseChangeMap ...)`.
- **Proof follows sketch**: **partial**. The Lean proof is a one-liner (`(Modules.isIso_iff_isIso_app_affineOpens ...).mpr H`), which IS Step 3 of the blueprint's 3-step sketch. Steps 1–2 (identifying the restriction of `pushforwardBaseChangeMap` to a per-affine-open `U` with the base-change map of the affine–affine square) are NOT in the Lean body of `base_change_map_affine_local`; they are the sorry-blocked obligation in `affineBaseChange_pushforward_iso`. The blueprint's proof sketch treats those steps as internal to this lemma; the Lean factors them out to the caller.
- **notes**: The Lean factoring is mathematically valid — the Lean signature is identical to the blueprint's intended one — but the proof body does not cover the affine restriction-identification work the blueprint describes as belonging here. The missing work is clearly deferred (see code comment at lines 786–797 of `affineBaseChange_pushforward_iso`). **Major** divergence in proof content, not a signature error.

---

### `\lean{AlgebraicGeometry.pushforward_base_change_mate_cancelBaseChange}` (chapter: `lem:pushforward_base_change_mate_cancelBaseChange`)
- **Lean target exists**: yes (line 717)
- **Signature matches**: **partial** — the blueprint's "Intended formalized signature" states the equality `Θ_tgt ∘ Γ(α) ∘ Θ_src⁻¹ = cancelBaseChange⁻¹` (a propositional equality of `ModuleCat(R')`-morphisms), but the Lean decl only formalizes the `IsIso (Γ(α))` *corollary*. The `% NOTE:` in the blueprint chapter reconciles this: the equality form requires identifying `pullback.fst/snd` with Spec-of-tensor inclusions (`pullbackSpecIso`), which is the same plumbing blocking the proof; the `IsIso` form is non-vacuous and is exactly what `base_change_map_affine_local` consumes downstream. The note is **accurate**.
- **Proof follows sketch**: **no** — body is `:= by sorry`. The 4-step generator trace (unit unwinding, `f_*` application, `g^*`-adjunction transpose, `cancelBaseChange` identification) is fully described in the blueprint proof sketch but not implemented.
- **notes**: The `% NOTE:` and `\leanok` (statement-only) are consistent with Archon's marker vocabulary (statement formalized as sorry-bodied). The divergence (`IsIso` vs. equality) is **acceptable/faithful**: `IsIso Γ(α)` is a strictly weaker statement than the equality, but for the purpose of closing the affine case it is sufficient. The sorry itself is **must-fix-this-iter**.

---

### `\lean{AlgebraicGeometry.affineBaseChange_pushforward_iso}` (chapter: `lem:affine_base_change_pushforward`)
- **Lean target exists**: yes (line 766)
- **Signature matches**: yes — `IsPullback g' f' f g → [IsAffineHom f] → [F.IsQuasicoherent] → IsIso (pushforwardBaseChangeMap ...)`.
- **Proof follows sketch**: **partial** — the outer structure matches the blueprint (locality reduction via `base_change_map_affine_local`, then per-affine-open step). The first step is implemented. The per-affine-open step (line 797) is `:= sorry`, covering both the affine reduction (restricting the square to affine charts, identifying `f'`/`g'` with `Spec`-of-tensor inclusions via `pullbackSpecIso`) and the connection to `pushforward_base_change_mate_cancelBaseChange`. Code comments at lines 786–797 accurately describe what remains.
- **notes**: The residual sorry matches the blueprint's described "affine-reduction step" (the multi-hundred-LOC chart restriction + `pullbackSpecIso` identification). **Must-fix-this-iter**.

---

### `\lean{AlgebraicGeometry.flatBaseChange_pushforward_isIso}` (chapter: `thm:flat_base_change_pushforward`)
- **Lean target exists**: yes (line 806)
- **Signature matches**: yes — `[Flat g] → [QuasiCompact f] → [QuasiSeparated f] → [F.IsQuasicoherent] → IsIso ...`.
- **Proof follows sketch**: **no** — body is `:= by sorry`. Blueprint proof sketch (Čech-free equalizer argument) is not implemented. Code comment (lines 810–819) accurately summarizes the strategy (locality on S', sheaf-condition equalizer, flatness + `tensorEqLocusEquiv`). Blueprint acknowledges this needs Čech/Mayer–Vietoris infrastructure. **Must-fix-this-iter**.
- **notes**: Blueprint `\leanok` (statement block only) is consistent with sorry-bodied proof.

---

### `\lean{LinearMap.tensorEqLocusEquiv}` (chapter: `lem:flat_preserves_equalizer_mathlib`, `\mathlibok`)
- **Lean target exists**: N/A — Mathlib reference, no local obligation.
- **notes**: Correctly marked `\mathlibok`. No local declaration needed.

---

## Red flags

### Placeholder / suspect bodies

- `pushforward_base_change_mate_cancelBaseChange` (line 740): `:= by sorry`. Blueprint claims the 4-step generator trace (substantive computation). The `% NOTE:` and `\leanok` acknowledge this, but the sorry is a live blocker.
- `affineBaseChange_pushforward_iso` (line 797): sorry in the per-affine-open branch. The first reduction (via `base_change_map_affine_local`) is applied correctly, but the remaining goal — the affine chart restriction + connection to `pushforward_base_change_mate_cancelBaseChange` — is sorry.
- `flatBaseChange_pushforward_isIso` (line 819): `:= by sorry`. Entire flat base-change theorem unproven.

### Excuse-comments

None found. The lengthy STATUS/UPDATE comments at lines 181–244 document a *resolved* technical obstacle (carrier-wall, route (a) dead, route (b) executed); the proof of `gammaPushforwardIso` is sorry-free. The comments at lines 769–797 accurately describe what the sorry covers and do not excuse wrong code. No comment claims a placeholder is the real definition.

### Axioms / Classical.choice on non-trivial claims

None. No `axiom` declarations. No suspicious `Classical.choice` patterns.

---

## Unreferenced declarations (informational)

- `AlgebraicGeometry.gammaPushforwardNatIso` (line 664): not a `\lean{...}` blueprint node. The blueprint explicitly names it in prose as "a Lean-side helper ... no longer a separate blueprint node." Acceptable as an infrastructure helper.

All other Lean declarations (18 total) have corresponding `\lean{...}` blueprint blocks.

---

## Blueprint adequacy for this file

- **Coverage**: 18/18 Lean declarations have a corresponding `\lean{...}` block or are explicitly helper-only (`gammaPushforwardNatIso`). Coverage is complete.
- **Proof-sketch depth**: **adequate** for all completed declarations. The 4-step generator trace for `lem:pushforward_base_change_mate_cancelBaseChange` is exceptionally detailed (Steps 1–4 with element-level computations). The `lem:pushforward_spec_tilde_iso` proof sketch (three-movements for `hloc`) is sufficient to guide the formalization. The `lem:base_change_map_affine_local` proof sketch is over-specified relative to what the Lean version implements (3 steps where Lean uses 1 step + delegates the rest to the caller), but this is a factoring choice, not a blueprint failure.
- **Hint precision**: **precise** — all `\lean{...}` tags use fully qualified names that match the Lean declarations exactly (including the `Modules.` namespace, `IsLocalizedModule.powers_restrictScalars` etc.).
- **Generality**: **matches need** — no parallel APIs were written to compensate for an under-generalized blueprint.
- **`% NOTE:` on `lem:pushforward_base_change_mate_cancelBaseChange` accuracy**: The note is accurate on all three claims: (1) the Lean decl does prove `IsIso Γ(α)`; (2) this is what `lem:base_change_map_affine_local` consumes; (3) the equality form requires `pullbackSpecIso` plumbing that is the same crux blocking the proof. The divergence is acceptable-faithful: `IsIso Γ(α)` is weaker than the full equality but non-vacuous and sufficient for the downstream use.
- **Recommended chapter-side actions**:
  - None required for adequacy. If `pushforward_base_change_mate_cancelBaseChange` is ever upgraded to the full equality statement, update `lem:pushforward_base_change_mate_cancelBaseChange`'s "Intended formalized signature" section and remove the `% NOTE:` once the sorry is closed.
  - After `affineBaseChange_pushforward_iso` is fully proved, update `lem:base_change_map_affine_local`'s proof sketch to reflect the factoring: Steps 1–2 belong at the call site (`affineBaseChange_pushforward_iso`), not inside `base_change_map_affine_local` itself. The current sketch is slightly misleading about which steps live in which lemma.

---

## Severity summary

### must-fix-this-iter

1. **`pushforward_base_change_mate_cancelBaseChange` (line 717)**: sorry on a substantive declaration. The 4-step mate trace is described in the blueprint but not formalized. Blocks `affineBaseChange_pushforward_iso` entirely once the affine reduction is in place.
2. **`affineBaseChange_pushforward_iso` (line 766, sorry at 797)**: sorry on the per-affine-open branch. The affine chart restriction (`pullbackSpecIso` identification of `f'`/`g'`) is not done. Blocks the affine base-change lemma.
3. **`flatBaseChange_pushforward_isIso` (line 806)**: sorry on the full theorem. Needs Čech/Mayer–Vietoris infrastructure. Blocks the chapter's primary result.

### major

4. **`pushforward_base_change_mate_cancelBaseChange` signature**: `IsIso Γ(α)` vs. blueprint's `Θ_tgt ∘ Γ(α) ∘ Θ_src⁻¹ = cancelBaseChange⁻¹`. The `% NOTE:` reconciling this is accurate and the divergence is acceptable-faithful, but it weakens the formal content of the declaration relative to the blueprint statement. Should be upgraded to the equality once `pullbackSpecIso` plumbing is available.
5. **`base_change_map_affine_local` proof does not follow the blueprint's 3-step sketch**: the Lean proof is a one-liner (`mpr H`), corresponding only to Step 3 of the blueprint's proof. Steps 1–2 (the affine restriction identification that makes the per-U hypothesis applicable) are deferred to the sorry in `affineBaseChange_pushforward_iso`. Structurally sound but the blueprint's proof attribution is misleading.

### minor

6. **`gammaPushforwardNatIso`** has no dedicated blueprint node (mentioned in prose only). Worth promoting to a `\lean{...}`-pinned helper block if it becomes a dependency anchor for future declarations.
7. **Development-history comments** at lines 181–244 are verbose but accurate. Could be pruned once the `affineBaseChange_pushforward_iso` chain is closed.

**Overall verdict**: The chapter and Lean file are structurally aligned and the blueprint is adequate; 3 sorry-bodied declarations (`pushforward_base_change_mate_cancelBaseChange`, `affineBaseChange_pushforward_iso`, `flatBaseChange_pushforward_isIso`) are the live blockers, the `% NOTE:` on the IsIso-vs-equality divergence is accurate and acceptable, and all other declarations are sorry-free with proofs that faithfully follow their blueprint sketches.
