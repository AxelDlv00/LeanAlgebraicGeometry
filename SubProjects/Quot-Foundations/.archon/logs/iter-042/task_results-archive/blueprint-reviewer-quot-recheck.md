# Blueprint Review Report

## Slug
quot-recheck

## Iteration
042 (fast-path re-review)

## Per-chapter

### blueprint/src/chapters/Picard_QuotScheme.tex
- **complete**: true
- **correct**: true
- **notes**:
  - G1-core (`lem:qcoh_affine_section_localization`) — verified prover-ready; see Top-level summaries for full analysis.
  - gap2 (`lem:qcoh_section_localization_basicOpen`) — verified prover-attemptable; see Top-level summaries.
  - Isolated `lem:annihilator_localization_eq_map`: **keep** — proved/axiom-clean, intentionally standalone pending downstream characterization block (reverse inclusion for the annihilator sheaf on affine opens). Blueprint NOTE explains.

### blueprint/src/chapters/Cohomology_RegroupHelper.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_GrassmannianCells.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_RelativeSpec.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_FlatteningStratification.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `lem:gf_qcoh_fintype_finite_sections` and `lem:gf_flat_locality_assembly` still have `\lean{}` pins but no Lean decl (GF geometric bridge, the current GF prover objective). No change from prior audit.
  - `thm:generic_flatness` carries sorry gated on the two bridges. This is expected and correct.

### blueprint/src/chapters/Cohomology_FlatBaseChange.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - The fbc-tilde writer (this iter) added `lem:gammaPushforwardNatIso` (leanok, `\lean{AlgebraicGeometry.gammaPushforwardNatIso}`, not in `unmatched_lean` — decl exists) and `lem:pushforward_base_change_mate_sections_direct` (no leanok yet, new tilde-transport prover target, correctly in `unmatched_lean`). The `archon:covers` directive now includes `FlatBaseChangeGlobal.lean`.
  - 4 sorry conjugate-chain nodes unchanged: `lem:base_change_mate_gstar_transpose` (root), `lem:base_change_mate_section_identity`, `lem:pushforward_base_change_mate_cancelBaseChange`, `lem:affine_base_change_pushforward`. The tilde-transport route provides an alternative proof path for `cancelBaseChange` not yet formalized.
  - `lem:pushforward_base_change_mate_cancelBaseChange` proof block now routes through the new tilde-transport route (`lem:pushforward_base_change_mate_sections_direct`) instead of the conjugate calculus. The statement is unchanged.
  - The `lem:pushforward_base_change_mate_sections_direct` block is the NEW FBC prover target. Its `\uses{}` covers all prerequisites (all `\leanok`/`\mathlibok`). Prover-ready.
  - Note: this chapter's FBC prover lane must be re-cleared by the next full blueprint review before dispatching a prover at `lem:pushforward_base_change_mate_sections_direct`. The present fast-path review is scoped to QuotScheme only.

---

## Top-level summaries

### G1-core gate verification

**`lem:qcoh_affine_section_localization` → `AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen_of_isQuasicoherent`**

Confirmed **prover-ready**:

1. **Statement** (lines 2735–2764): Clear and correct. Let `M` be quasi-coherent on `Spec R`, `f ∈ R`. Then `Γ(M,⊤) → Γ(M,D(f))` is `IsLocalizedModule (powers f)` over `R`. Cites Stacks 01HA; `% SOURCE QUOTE:` verbatim present; `\textit{Source: ...}` visible line present.

2. **`% NOTE: the Lean decl does NOT yet exist`** — preserved exactly at lines 2740–2748. ✓

3. **`\uses{}`** (statement block, lines 2738–2739):
   - `lem:qcoh_affine_isIso_fromTildeΓ` (gap1): **axiom-clean** in Lean — `AlgebraicGeometry.Scheme.Modules.isIso_fromTildeΓ_of_isQuasicoherent` verified `{propext, Classical.choice, Quot.sound}`.
   - `lem:isLocalizedModule_restrict_of_isIso_fromTildeΓ`: **axiom-clean** — `AlgebraicGeometry.isLocalizedModule_restrict_of_isIso_fromTildeΓ` verified `{propext, Classical.choice, Quot.sound}`.
   - `lem:isLocalization_basicOpen_mathlib`: `\mathlibok` anchor for `AlgebraicGeometry.IsAffineOpen.isLocalization_basicOpen` — **confirmed in Mathlib** (`Mathlib.AlgebraicGeometry.AffineScheme`).

4. **Proof** (lines 2769–2783): One-line application: gap1 gives `IsIso M.fromTildeΓ` → affine engine `isLocalizedModule_restrict_of_isIso_fromTildeΓ` delivers all 3 `IsLocalizedModule` fields at once. The proof `\uses` additionally cites `lem:isIso_fromTildeΓ_iff_isLocalizedModule_restrict` (axiom-clean, for the interderivability remark only — does not create a cycle).

5. **Lean formalization path**: Literally `isLocalizedModule_restrict_of_isIso_fromTildeΓ M.fromTildeΓ (isIso_fromTildeΓ_of_isQuasicoherent hqc)` per writer note. One line, no new ingredient.

**Verdict: GATE CLEARS for G1-core prover dispatch.**

---

### gap2 gate verification

**`lem:qcoh_section_localization_basicOpen` → `AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen`**

Confirmed **prover-attemptable**:

1. **Statement** (lines 2476–2521): Clear and correct. Let `X` be a scheme, `M` quasi-coherent, `U ⊆ X` affine open, `f ∈ Γ(X,U)`. Then (1) `Γ(X,D(f))` is the localization of `Γ(X,U)` away from `f` (Mathlib); (2) `M(U) → M(D(f))` is `IsLocalizedModule(powers f)` over `Γ(X,U)`.

2. **`% NOTE: the pinned Lean decl ... does NOT yet exist`** — preserved at lines 2482–2494. ✓

3. **`\uses{}`** (statement block, lines 2479–2481): `lem:isLocalization_basicOpen_mathlib`, `lem:qcoh_affine_section_localization` (G1-core), `lem:qcoh_affine_isIso_fromTildeΓ`, `lem:isLocalizedModule_restrict_of_isIso_fromTildeΓ`. Dependency order is correct.

4. **Proof** (lines 2523–2564):
   - Part (1): delegates to `lem:isLocalization_basicOpen_mathlib` (Mathlib). ✓
   - Part (2): **single-chart transport** (NOT cover-and-glue). U affine → canonical iso `φ: U ≅ Spec Γ(X,U)` (Mathlib) → push `M|_U` to quasi-coherent `M'` on `Spec Γ(X,U)` → apply G1-core → transport `IsLocalizedModule` back via the affine iso on sections.
   - **Remaining ingredient** explicitly flagged (lines 2555–2564): "the chapter does not yet package the transport of the `IsLocalizedModule` predicate across the affine identification `φ`... the sole genuinely new piece the prover must supply on top of G1-core — a single-chart affine-isomorphism transport, NOT a cover-and-glue." This is honest.

5. **Transport infrastructure available**: `IsLocalizedModule.linearEquiv` confirmed in Mathlib (`Mathlib.Algebra.Module.LocalizedModule.Basic`, `\mathlibok` at `lem:isLocalizedModule_linearEquiv_mathlib`). `IsLocalizedModule.linearMap_ext` confirmed (`\mathlibok` at `lem:isLocalizedModule_linearMap_ext_mathlib`). The affine identification uses Mathlib's `IsAffine.isoSpec`-family.

6. **Proof `\uses{}`** (line 2524) lists `lem:isLocalization_basicOpen_mathlib, lem:qcoh_affine_section_localization`. The `\mathlibok` transport anchors (`IsLocalizedModule.linearEquiv` etc.) are not listed in the proof `\uses{}`. These are all Mathlib-backed and already complete; their absence is a soon-severity wire-up, not must-fix.

**Verdict: GATE CLEARS for gap2 prover dispatch.** The single new ingredient is a one-step `IsLocalizedModule`-across-affine-iso transport; all Mathlib tools are present.

---

### Three reconciled pin blocks (A1–A3)

All three stale `\lean{}` pins confirmed removed:

- `lem:composite_immersion_flocus_basicOpen` (line 4344): no `\lean{}` pin; `% NOTE: no standalone Lean decl pins this block; its content is absorbed inline into section_localization_hfr_basicOpen`. Real mathematical claims now point at new B2/B3 blocks. `\uses{}` correct. ✓
- `lem:gamma_image_iso_semilinear_top` (line 4378): no `\lean{}` pin; `% NOTE: absorbed inline into section_localization_hfr_aux`. `\uses{}` correct. ✓
- `lem:flocus_section_scalar_tower` (line 4406): no `\lean{}` pin; `% NOTE: absorbed inline into section_localization_hfr_aux`. `\uses{}` correct. ✓

---

### Four new helper blocks (B1–B4)

All four confirmed present with correct `\lean{}`/`\uses{}`, and **none appear in `unmatched_lean`** (their Lean decls exist):

- `lem:image_basicOpen_of_affine` (line 4431): `\lean{AlgebraicGeometry.Scheme.Modules.image_basicOpen_of_affine}`. Statement clear; proof cites `basicOpen_eq_of_affine` + `Scheme.image_basicOpen` (Mathlib, abstract `j`). No `\uses{}` needed (standalone geometry fact). ✓
- `lem:compositeBasicOpenImmersion_image_basicOpen` (line 4452): `\lean{...compositeBasicOpenImmersion_image_basicOpen}`. `\uses{lem:image_basicOpen_of_affine, def:composite_basic_open_immersion}`. ✓
- `lem:image_basicOpen_eq_inf` (line 4468): `\lean{...image_basicOpen_eq_inf}`. `\uses{lem:image_basicOpen_of_affine}`. Cites `Scheme.basicOpen_res` (Mathlib). ✓
- `lem:section_localization_hfr_aux` (line 4489): `\lean{...section_localization_hfr_aux}`. Full `\uses{}` covering the 8 constituent lemmas; proof explicitly records the opaque-`j` load-bearing implementation lesson (heartbeat boundary). ✓

---

### Dependency & isolation findings

- **`leandag build --json`**: `unknown_uses: []` — no broken `\uses{}` anywhere in the blueprint. ✓
- **`unmatched_lean` for QuotScheme neighbourhood**: `lem:qcoh_affine_section_localization` and `lem:qcoh_section_localization_basicOpen` correctly appear (their Lean decls don't yet exist — they are the new targets). All four B-block helpers are NOT in `unmatched_lean` (their decls exist). ✓
- **`isolated: 2`** (unchanged from prior audit):
  - `lem:annihilator_localization_eq_map` (QuotScheme): **keep** — proved/axiom-clean, pending downstream characterization block.
  - `lem:gr_de...` (GrassmannianCells): **keep** — pre-existing orphan, proved, harmless (per prior audit).

---

## Severity summary

**QuotScheme hard gate: CLEARS.**

Soon-severity (non-blocking):
- `Picard_QuotScheme.tex` / `lem:qcoh_section_localization_basicOpen` proof `\uses{}`: missing entries for `lem:isLocalizedModule_linearEquiv_mathlib` and `lem:isLocalizedModule_linearMap_ext_mathlib` (the `IsLocalizedModule`-transport tools used in the affine-iso step). Both are `\mathlibok` Mathlib nodes — already complete. Wire-up when gap2 closes. **soon** — does not block prover dispatch since upstream nodes are fully proved.

Informational:
- `Cohomology_FlatBaseChange.tex`: fbc-tilde writer introduced `lem:pushforward_base_change_mate_sections_direct` (new FBC prover target, no leanok) and `lem:gammaPushforwardNatIso` (leanok, decl exists). Full FBC re-audit deferred to next mandatory blueprint-reviewer dispatch before FBC prover goes at the tilde-transport route.

**Overall verdict**: `Picard_QuotScheme.tex` is `complete: true`, `correct: true`, no must-fix-this-iter finding. Both G1-core (`isLocalizedModule_basicOpen_of_isQuasicoherent`) and gap2 (`isLocalizedModule_basicOpen`) prover targets are gate-clear for dispatch this iter. G1-core is a one-line corollary of the axiom-clean gap1 + affine engine; gap2 is a single-chart transport requiring one new `IsLocalizedModule`-across-iso packaging step with all Mathlib tools present.
