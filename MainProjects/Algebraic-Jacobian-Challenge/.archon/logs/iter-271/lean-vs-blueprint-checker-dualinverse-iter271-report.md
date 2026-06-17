# Lean ↔ Blueprint Check Report

## Slug
dualinverse-iter271

## Iteration
271

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean`
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.sliceDualTransport}` (chapter: `lem:slice_dual_transport`)
- **Lean target exists**: yes
- **Signature matches**: yes — `(TopologicalSpace.Opens ↥Y)ᵒᵖ → Iso` between the two pushforward-dual section values, assembled via `LinearEquiv.toModuleIso`; matches blueprint statement
- **Proof follows sketch**: partial — `map_add'` (iter-263) and `map_smul'` (iter-264) are closed; `naturality`, `left_inv`, and `right_inv` remain `sorry`; `invFun` is wired to `sliceDualTransportInv` (which also carries `sorry`s)
- **notes**: Blueprint proof correctly warns (line 5871-5872) that the naturality square has two parts: the thin-poset base-morphism part (`Subsingleton.elim`, discharges index uniqueness only) and the genuine ε-naturality obligation (separate, not discharged by `Subsingleton.elim`). The Lean comment at L444-445 matches this split exactly. `\leanok` on statement block is correct (sorry present). No proof-block `\leanok` is correct (proof not closed).

### `\lean{AlgebraicGeometry.Scheme.Modules.dual_restrict_iso}` (chapter: `lem:dual_restrict_iso`)
- **Lean target exists**: yes
- **Signature matches**: yes — `(dual M).restrict f ≅ dual (M.restrict f)` for `f : Y ⟶ X`, `[IsOpenImmersion f]`, `M : X.Modules`; matches blueprint
- **Proof follows sketch**: partial — Steps 1–3 and H1 are executed in code; the final `isoMk` naturality square at L674 is one `sorry`; the actual content of `sliceDualTransport` (its `invFun`/`naturality`) feeds transitively through `PresheafOfModules.isoMk`
- **notes**: Blueprint `\leanok` on statement block is correct (sorry present). No proof-block `\leanok` is correct. No over-claim: the sorry is acknowledged inline in the Lean and reflected by the absence of a proof-block `\leanok` in the blueprint.

### `\lean{AlgebraicGeometry.Scheme.Modules.dual_isLocallyTrivial}` (chapter: `lem:dual_isLocallyTrivial`)
- **Lean target exists**: yes
- **Signature matches**: yes — `LineBundle.IsLocallyTrivial L → LineBundle.IsLocallyTrivial (dual L)`; matches blueprint
- **Proof follows sketch**: partial transitively — the three-step chain `dual_restrict_iso ≪≫ (dualIsoOfIso eL).symm ≪≫ dual_unit_iso` (L759) is assembled and compiles, matching the blueprint's three-step chain exactly; it inherits the `dual_restrict_iso` residual, which is a transitive sorry, not a direct one in this declaration
- **notes**: Blueprint `\leanok` on statement is correct. No direct sorry in this body; the transitive dependency is the honest state.

### `\lean{AlgebraicGeometry.Scheme.Modules.dual_unit_iso}` (chapter: `lem:dual_unit_iso`)
- **Lean target exists**: yes
- **Signature matches**: yes — `dual (SheafOfModules.unit Y.ringCatSheaf) ≅ SheafOfModules.unit Y.ringCatSheaf`; matches blueprint
- **Proof follows sketch**: yes — closed axiom-clean; uses `presheafDualUnitIso` (evaluation-at-1) sheafified and composed with the sheafification counit; matches blueprint proof sketch exactly
- **notes**: Blueprint `\leanok` on statement block is correct. Proof is closed; proof block lacks `\leanok` but that is managed by `sync_leanok`, not this checker.

### `\lean{AlgebraicGeometry.Scheme.Modules.dualUnitRingSwap}` (proof of `lem:slice_dual_transport`)
- **Lean target exists**: yes (L193-200)
- **Signature matches**: yes — `inv(ε(restrictScalars (f.appIso W').inv.hom))` at `CommRingCat` level; matches blueprint's `codomainMap := inv(ε(restrictScalars g))` with `g = (f.appIso W).inv.hom`
- **Proof follows sketch**: yes — axiom-clean, one-liner
- **notes**: Referenced by name in blueprint proof (line 5899). ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.isIso_ε_restrictScalars_appIso}` (proof of `lem:slice_dual_transport`)
- **Lean target exists**: yes (L179-184)
- **Signature matches**: yes
- **Proof follows sketch**: yes — axiom-clean
- **notes**: ✓

### `\lean{PresheafOfModules.dualUnitIsoGen}` (proof of `lem:slice_dual_transport`)
- **Lean target exists**: yes (L126-160)
- **Signature matches**: yes — `PresheafOfModules.dual 𝟙_ ≅ 𝟙_` for general `R₀`; matches blueprint
- **Proof follows sketch**: yes — closed axiom-clean
- **notes**: ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.dualUnitRingSwapHom}` (proof of `lem:slice_dual_transport`, inverse paragraph)
- **Lean target exists**: yes (L249-256)
- **Signature matches**: yes — `inv(ε(restrictScalars (f.appIso W').hom.hom))`, the `.hom`-direction `inv ε`; matches blueprint lines 5921-5922
- **Proof follows sketch**: yes — axiom-clean
- **notes**: The blueprint's corrected description (lines 5921-5925) says "the *inverse* of ε in the *hom*-direction... *not* ε of the inv-direction β"; the Lean uses `CategoryTheory.inv (Functor.LaxMonoidal.ε (ModuleCat.restrictScalars (Scheme.Hom.appIso f W').hom.hom))`. **MATCH confirmed**. ε-direction correction is accurate in both blueprint and Lean. ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.isIso_ε_restrictScalars_appIso_hom}` (proof of `lem:slice_dual_transport`, inverse paragraph)
- **Lean target exists**: yes (L237-242)
- **Signature matches**: yes
- **Proof follows sketch**: yes — axiom-clean
- **notes**: ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.image_preimage_of_le}` (proof of `lem:slice_dual_transport`)
- **Lean target exists**: yes (L854-857)
- **Signature matches**: yes
- **Proof follows sketch**: yes — axiom-clean
- **notes**: ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.presheafDualUnitIso}` (proof of `lem:dual_unit_iso`)
- **Lean target exists**: yes (L681-685) — alias of `PresheafOfModules.dualUnitIsoGen` at `R₀ := Y.presheaf`
- **Signature matches**: yes
- **Proof follows sketch**: yes — axiom-clean, one-liner alias
- **notes**: ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.homOfLocalCompat}` (chapter: `lem:sheafofmodules_hom_of_local_compat`)
- **Lean target exists**: yes (L931-1100)
- **Signature matches**: yes — signature matches blueprint including the sectionwise-overlap `hf` form (iter-254 re-sign)
- **Proof follows sketch**: yes — closed axiom-clean; two-step gluing + linearity promotion via `homMk`; blueprint proof sketch matches
- **notes**: CLOSED since iter-256. No sorry. ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.homLocalSection}` (chapter: `lem:scheme_modules_hom_local_section`)
- **Lean target exists**: yes (L773-822)
- **Signature matches**: yes
- **Proof follows sketch**: yes — naturality via `Subsingleton.elim` on thin-poset hom-sets, closed axiom-clean
- **notes**: ✓

---

## Red flags

### Placeholder / suspect bodies

- `sliceDualTransportInv` at L309: `app` field is `:= sorry`. The surrounding comment (L279-308) explicitly documents the residual as a genuine ~100-LOC instance-delicate build, not a hidden claim. The blueprint's "Inverse." paragraph accurately describes the construction; the sorry is the documented open work. **Not a misleading placeholder** — but the declaration is substantive enough to warrant a `\lean{}` tag (see Unreferenced Declarations below).

- `sliceDualTransportInv` at L310: `naturality` field is `:= sorry`. Same status.

- `sliceDualTransport` at L447: `naturality` field is `:= sorry`. Documented residual (ε-naturality of `restrictScalars`).

- `sliceDualTransport` at L541, L543: `left_inv`/`right_inv` are `:= sorry`. Explicitly marked as blocked on the `invFun` residuals, which is accurate.

- `dual_restrict_iso` at L674: one `sorry` (the `isoMk` naturality square). Documented as dependent on `sliceDualTransport`'s concrete body.

None of these are opaque placeholder bodies: every `sorry` is accompanied by a precise residual statement, and the blueprint does not claim any of them closed.

### Excuse-comments

None found. In-file comments accurately describe residual obligations without excusing incorrect code.

### Axioms / Classical.choice on non-trivial claims

None found. All declarations verified via Lean comments to be axiom-clean up to their explicit `sorry` residuals.

---

## Unreferenced declarations (informational)

The following declarations in the Lean file have no `\lean{...}` entry in the blueprint:

| Declaration | Line | Assessment |
|---|---|---|
| `PresheafOfModules.unitDualSectionEquiv` | L84 | Helper for `dualUnitIsoGen` — acceptable internal helper |
| `PresheafOfModules.dualUnitIsoGen` | L126 | **Has `\lean{}`** in blueprint proof body (line 5905) ✓ |
| `dualUnitRingSwapInv` | L208 | Helper (the ε-forward direction); cancel lemmas confirm it is purely the "section of `dualUnitRingSwap`" — helper-only |
| `dualUnitRingSwapInv_comp_dualUnitRingSwap` | L217 | Cancel `@[simp]` helper — not substantive standalone |
| `dualUnitRingSwap_comp_dualUnitRingSwapInv` | L225 | Cancel `@[simp]` helper — not substantive standalone |
| **`sliceDualTransportInv`** | **L273** | **SUBSTANTIVE — see below** |
| `presheafDualUnitIso` | L681 | **Has `\lean{}`** in blueprint proof body (line 6237) ✓ |
| `topSectionToHom` | L830 | Implementation helper for `homOfLocalCompat`'s gluing — acceptable |
| `topSectionToHom_app` | L843 | Implementation helper — acceptable |

### `sliceDualTransportInv` — 1-to-1 coverage debt

`AlgebraicGeometry.Scheme.Modules.sliceDualTransportInv` (L273-310) is a **top-level named `def`** extracted this iteration (iter-271) to resolve a binder-metavar issue that blocked progress on the `invFun` field of `sliceDualTransport`. It has the following characteristics:
- Non-trivial signature: takes `f`, `M`, `V`, `β` (explicit), `ψ` and returns a section of the dual pushforward
- Non-trivial body (blueprint-described inverse construction with documented residuals `sorry`s)
- Called from `sliceDualTransport`'s `invFun` field at L538
- The blueprint's "Inverse." paragraph (lines 5907-5928) describes its construction in substantial detail, mentioning `dualUnitRingSwapHom` (its codomain swap) and `image_preimage_of_le` (its down-set coverage)

**However, the declaration has no `\lean{AlgebraicGeometry.Scheme.Modules.sliceDualTransportInv}` entry in the blueprint.** The "Inverse." paragraph treats the construction as the `invFun` field of `sliceDualTransport`, not as a standalone named declaration. Since the extraction is a Lean implementation artifact (binder-metavar unsticking), the mathematical content belongs to `lem:slice_dual_transport`'s statement of the isomorphism; nevertheless, as a top-level def it needs a `\lean{}` pointer for 1-to-1 coverage.

---

## Blueprint adequacy for this file

- **Coverage**: 13/13 `\lean{...}`-referenced declarations traced. One substantive unreferenced declaration (`sliceDualTransportInv`). Helper-only unreferenced: 6 (all acceptable). Substantive unreferenced: 1 (flagged above).

- **Proof-sketch depth**: **adequate**. The blueprint proof of `lem:slice_dual_transport` (lines 5870-5999) is unusually detailed:
  - Precisely describes the two distinct parts of the naturality obligation (thin-poset base morphism vs. genuine ε-naturality square) and warns that `Subsingleton.elim` alone does not discharge part (b)
  - Precisely describes the three-step additivity/linearity verification (identify module structures, match scalars by β-naturality, apply change-of-rings compatibility)
  - Precisely describes the inverse construction including the `.hom`-direction ε codomain swap vs the `.inv`-direction
  - References `PresheafOfModules.restrictScalarsLaxε` as the closing tool for the ε-naturality step
  - The blueprint adequately guided the formalization.

- **Hint precision**: **precise**. All `\lean{...}` hints name the correct fully-qualified Lean declarations, and the prose pins the relevant Mathlib predicates (`InternalHom`, `LaxMonoidal.ε`, `restrictScalars`) with enough precision.

- **Generality**: **matches need**. The blueprint treats `sliceDualTransport` at the right level of generality (per-V linear isomorphism, for general open immersion `f` and module `M`).

- **Recommended chapter-side actions**:
  1. **Add `\lean{AlgebraicGeometry.Scheme.Modules.sliceDualTransportInv}` inside the "Inverse." paragraph** of `lem:slice_dual_transport`'s proof body, directly after the sentence describing the codomain swap `dualUnitRingSwapHom` (around line 5922). Since `sliceDualTransportInv` is the `invFun` extracted top-level rather than a separate mathematical result, it does NOT need its own `\lemma`/`\definition` block — a `\lean{}` inline reference within the existing "Inverse." paragraph suffices, matching the style of `\lean{AlgebraicGeometry.Scheme.Modules.dualUnitRingSwapHom}` already present there.

---

## Severity summary

| Finding | Severity | Location |
|---|---|---|
| `sliceDualTransportInv` has no `\lean{}` blueprint reference | **major** | Blueprint line ~5928 (Inverse. paragraph), Lean L273 |
| All `sorry` residuals in `sliceDualTransport`/`dual_restrict_iso` are documented and acknowledged | no-finding | — |
| Blueprint ε-direction for invFun (`.hom`-direction `dualUnitRingSwapHom`) matches Lean exactly | no-finding | — |
| `dual_restrict_iso` blueprint carries no over-claim | no-finding | — |

**Overall verdict**: One major finding — `sliceDualTransportInv` has no `\lean{}` entry in the blueprint (coverage debt introduced by the iter-271 extraction); all other declarations check out with accurate signatures, consistent sorry states, and no over-claims. Blueprint adequacy for this file is high.
