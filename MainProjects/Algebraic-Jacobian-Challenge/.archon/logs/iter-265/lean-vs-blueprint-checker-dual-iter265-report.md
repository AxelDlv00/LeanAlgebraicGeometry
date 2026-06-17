# Lean ↔ Blueprint Check Report

## Slug
dual-iter265

## Iteration
265

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean`
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`
  (section `lem:slice_dual_transport`, ~L5780)

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.sliceDualTransport}` (chapter: `lem:slice_dual_transport`)
- **Lean target exists**: yes (DualInverse.lean:275)
- **Signature matches**: yes — `∀ (f : Y ⟶ X) [IsOpenImmersion f] (M : X.Modules) (V : (Opens Y)ᵒᵖ)`, returns `(pushforward β).obj (dual M.val)).obj V ≅ (dual (pushforward β).obj M.val)).obj V`, matching the blueprint statement.
- **Proof follows sketch**: partial — `map_add'` (field 2) and `map_smul'` (field 3) are closed and match the blueprint's three-step procedure (identify module presentations, match scalars by β-naturality ring identity, apply change-of-rings compatibility). `naturality` (field 1), `invFun` (field 4), `left_inv` (field 5), `right_inv` (field 6) remain `sorry`.
- **notes**: `\leanok` on the statement block is appropriate per project conventions (sorry present). The 4 open sorry fields are not masked — inline comments document exactly what each sorry requires.

### `\lean{AlgebraicGeometry.Scheme.Modules.dualUnitRingSwap}` (chapter: `lem:slice_dual_transport` leg-B)
- **Lean target exists**: yes (DualInverse.lean:193)
- **Signature matches**: yes — `restrictScalars (f.appIso W').inv.hom (𝟙_X(fW')) ⟶ 𝟙_Y(W')`, = `inv(ε(restrictScalars(f.appIso W').inv.hom))`, matching the blueprint's formula at L5837: `inv(ε(restrictScalars g))` with `g = (f.appIso W).inv.hom`.
- **Proof follows sketch**: yes (axiom-clean)
- **notes**: closed, axiom-clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.isIso_ε_restrictScalars_appIso}` (chapter: `lem:slice_dual_transport` leg-B iso)
- **Lean target exists**: yes (DualInverse.lean:179)
- **Signature matches**: yes — `IsIso (Functor.LaxMonoidal.ε (ModuleCat.restrictScalars (Scheme.Hom.appIso f W').inv.hom))`, matching the blueprint's claim at L5842-5843.
- **Proof follows sketch**: yes (axiom-clean)
- **notes**: closed, axiom-clean.

### `\lean{PresheafOfModules.dualUnitIsoGen}` (chapter: `lem:slice_dual_transport` leg-B unit)
- **Lean target exists**: yes (DualInverse.lean:126)
- **Signature matches**: yes — `PresheafOfModules.dual 𝟙_ ≅ 𝟙_`, the evaluation-at-1 iso, matching the blueprint's gloss at L5844-5846.
- **Proof follows sketch**: yes (axiom-clean)
- **notes**: closed, axiom-clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.image_preimage_of_le}` (chapter: `lem:slice_dual_transport` inverse)
- **Lean target exists**: yes (DualInverse.lean:799)
- **Signature matches**: yes — `W.ι ''ᵁ (W.ι ⁻¹ᵁ V) = V` for `V ≤ W`, matching L5853-5856.
- **Proof follows sketch**: yes (axiom-clean)
- **notes**: closed, axiom-clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.dual_restrict_iso}` (chapter: `lem:dual_restrict_iso`)
- **Lean target exists**: yes (DualInverse.lean:587)
- **Signature matches**: yes — `(dual M).restrict f ≅ dual (M.restrict f)`, matching `lem:dual_restrict_iso`.
- **Proof follows sketch**: partial — Steps 1–3 and H1 are in place; Step-4 assembles via `sliceDualTransport` but the `isoMk` naturality square (L617-619) is a `sorry`, reflecting that `sliceDualTransport.naturality` is not yet proved.
- **notes**: `\leanok` on statement block is appropriate (sorry present).

---

## Red flags

### MUST-FIX — Blueprint invFun codomain swap direction is wrong

**Location**: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`, L5861–5863.

**The blueprint says**:
> "it uses the ε-codomain swap ε(restrictScalars β_{W''}) itself (not inv ε)"

**What the Lean code actually requires** (documented in DualInverse.lean:464–478, the iter-265 direction-fix NOTE):
> The codomain swap is `dualUnitRingSwapHom = inv(ε(restrictScalars(f.appIso P).hom.hom))` — i.e. `inv ε` of the `.hom`-direction functor.

**Why the blueprint is wrong** (two layers):

1. **Wrong ring iso direction.** β = whiskerRight α (forget₂ CommRingCat RingCat) uses α_U = (f.appIso U).inv. In the invFun, the reindexing uses `restrictScalars (f.appIso P).hom.hom` (the `.hom` direction, because we map a Y-section back to an X-section). So `restrictScalars β_{W''}` (using `.inv.hom`) and `restrictScalars (f.appIso P).hom.hom` (using `.hom.hom`) are DIFFERENT functors.

2. **Wrong ε direction.** With the correct `.hom`-direction functor `restrictScalars(f.appIso P).hom.hom`:
   - `ε(restrictScalars(f.appIso P).hom.hom)` maps `𝟙_X(fP) → restrictScalars(f.appIso P).hom.hom(𝟙_Y(P))` (the wrong target type for the invFun codomain)
   - `inv ε (restrictScalars(f.appIso P).hom.hom)` maps `restrictScalars(f.appIso P).hom.hom(𝟙_Y(P)) → 𝟙_X(fP)` (the correct target type)
   - `dualUnitRingSwapHom f P` is exactly the latter (`inv ε` of `.hom`-direction), and is what the Lean recipe uses.

**Fix required**: update L5861–5863 to read approximately:
> "it uses the ε-codomain swap **`inv(ε(restrictScalars (f.appIso W'').hom.hom))`** (i.e. `inv ε` of the `.hom`-direction functor **`dualUnitRingSwapHom`**); the direction change (`.hom` not `.inv`) is because the invFun maps Y-sections back to X-sections, requiring the opposite ring iso direction."

Replace the parenthetical "(not `inv ε`)" — which has the direction backwards — with the correct statement "(not `ε` of the `.inv`-direction β)".

**Severity**: **must-fix-this-iter** (mathematical error in the blueprint's proof sketch; required by the plan agent's gate rules since the prover is about to implement the invFun based on this prose).

---

### `restrictScalarsLaxε` — VERIFIED TO EXIST (not a flag)

The directive asked whether `PresheafOfModules.restrictScalarsLaxε` exists. It **does** exist at `PresheafInternalHom.lean:290`, in the `PresheafOfModules` namespace, declared axiom-clean. The blueprint's reference to it at L5937–5941 (`\mathtt{PresheafOfModules.restrictScalarsLax}\varepsilon`) is **correct**. The `% NOTE:` comment on L5935–5936 is appropriate documentation. No flag.

---

## Unreferenced declarations (informational)

New iter-265 declarations without `\lean{...}` blueprint annotations:

| Declaration | Line | Status | Significance |
|---|---|---|---|
| `dualUnitRingSwapInv` | L208 | axiom-clean | Direct helper (`ε` itself, inverse direction); feeds `left_inv`/`right_inv`. Minor gap — should get `\lean{}` annotation once invFun is assembled. |
| `isIso_ε_restrictScalars_appIso_hom` | L237 | axiom-clean | Companion to `isIso_ε_restrictScalars_appIso` for the `.hom`-direction functor. Major gap — should get a `\lean{}` annotation alongside `dualUnitRingSwapHom`. |
| `dualUnitRingSwapHom` | L249 | axiom-clean | The invFun leg-B swap; the direct counterpart to `dualUnitRingSwap`. Major gap — once invFun is built this becomes a primary referenced atom and needs a `\lean{}` tag in the blueprint's inverse-direction description. |
| `dualUnitRingSwapInv_comp_dualUnitRingSwap` | L217 | axiom-clean | `@[simp]` cancellation lemma. Helper, no annotation needed. |
| `dualUnitRingSwap_comp_dualUnitRingSwapInv` | L225 | axiom-clean | `@[simp]` cancellation lemma. Helper, no annotation needed. |
| `unitDualSectionEquiv` | L84 | axiom-clean | Section-level building block for `dualUnitIsoGen`; acceptable unlabeled helper. |
| `homLocalSection` | L718 | axiom-clean | Referenced in blueprint prose as "the `homLocalSection` pattern" but has no `\lean{}` tag. Minor gap. |
| `topSectionToHom` / `topSectionToHom_app` / `image_preimage_of_le` | L775/788/799 | axiom-clean | `image_preimage_of_le` has a `\lean{}` tag (L5855). The others are unlabeled helpers. |
| `presheafDualUnitIso` | L626 | axiom-clean | Thin wrapper; acceptable. |
| `dual_unit_iso` | L637 | axiom-clean | Blueprint §B references it in the proof sketch of `dual_isLocallyTrivial`; no standalone block but it feeds the chain. Minor gap. |
| `homOfLocalCompat` | L876 | axiom-clean | Blueprint `lem:sheafofmodules_hom_of_local_compat` — HAS a blueprint block (~L5592), but the checker saw no `\lean{}` tag for it in the section scanned. Should be verified in a full chapter audit. |

---

## Blueprint adequacy for this file

- **Coverage**: The `lem:slice_dual_transport` block (L5780–5946) covers the main target and sub-lemmas `dualUnitRingSwap`, `isIso_ε_restrictScalars_appIso`, `dualUnitIsoGen`, `image_preimage_of_le`. The 4 new iter-265 helper declarations (`dualUnitRingSwapInv`, `isIso_ε_restrictScalars_appIso_hom`, `dualUnitRingSwapHom`, two simp lemmas) are not yet referenced; the two load-bearing ones (`dualUnitRingSwapHom`, `isIso_ε_restrictScalars_appIso_hom`) need future `\lean{}` tags once invFun is built.

- **Proof-sketch depth**: **adequate for the closed fields** (`map_add'`, `map_smul'`); the three-step procedure (L5881–5917) is detailed and was sufficient to guide the prover to close both. **Incorrect for `invFun`** — the prose says `ε` not `inv ε` (see must-fix above). `naturality` and `left_inv`/`right_inv` have sufficient sketch depth once the must-fix is landed.

- **Hint precision**: **partially loose** — the `\lean{}` tag for the inverse's codomain swap helper is absent (it should be `\lean{AlgebraicGeometry.Scheme.Modules.dualUnitRingSwapHom}` once the must-fix prose is corrected). All other `\lean{}` tags are precise.

- **Generality**: matches need.

- **Recommended chapter-side actions** (for a blueprint-writer pass):
  1. **MUST-FIX**: Correct L5861–5863: replace "ε(restrictScalars β_{W''}) itself (not inv ε)" with "inv(ε(restrictScalars (f.appIso W'').hom.hom))" and add `\lean{AlgebraicGeometry.Scheme.Modules.dualUnitRingSwapHom}` inline.
  2. **MAJOR**: Add `\lean{AlgebraicGeometry.Scheme.Modules.dualUnitRingSwapHom}` and `\lean{AlgebraicGeometry.Scheme.Modules.isIso_ε_restrictScalars_appIso_hom}` to the inverse-direction prose once the blueprint prose is corrected.
  3. **MINOR**: Add `\lean{AlgebraicGeometry.Scheme.Modules.dualUnitRingSwapInv}` alongside `dualUnitRingSwap` to document the full inv/hom pair.
  4. **MINOR**: Add `\lean{AlgebraicGeometry.Scheme.Modules.dual_unit_iso}` in the `dual_isLocallyTrivial` three-step chain description.

---

## Severity summary

| Finding | Location | Severity |
|---|---|---|
| Blueprint invFun codomain swap says "ε itself (not inv ε)" but correct is "inv ε" of `.hom`-direction | blueprint L5861–5863 | **must-fix-this-iter** |
| `dualUnitRingSwapHom` and `isIso_ε_restrictScalars_appIso_hom` missing `\lean{}` annotations | blueprint (invFun section) | **major** (needed once invFun lands) |
| `dualUnitRingSwapInv`, `dual_unit_iso` missing `\lean{}` annotations | blueprint | **minor** |
| `sliceDualTransport` fields 1,4,5,6 remain `sorry` | Lean | N/A — expected partial state, not a red flag |

**Overall verdict**: The blueprint has one mathematical error in the invFun prose (the codomain swap direction, must-fix-this-iter); `restrictScalarsLaxε` exists and is correctly referenced; all `\lean{...}`-tagged declarations exist with matching signatures; no fake statements or axioms introduced.
