# Lean ↔ Blueprint Check Report

## Slug
ts-iter207

## Iteration
207

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj}` (`def:scheme_modules_tensorobj`)
- **Lean target exists**: yes (line 199)
- **Signature matches**: yes — takes `M N : X.Modules`, returns `X.Modules`; body lifts `PresheafOfModules.Monoidal.tensorObj (R := X.presheaf)` through `sheafification (R := X.ringCatSheaf)`, exactly as the blueprint describes.
- **Proof follows sketch**: yes — the definition encodes the blueprint's "sheafification of the presheaf-level tensor product on `X.presheaf`". Note: the definition deliberately uses the `CommRingCat`-valued `X.presheaf` for the presheaf tensor and the `RingCat`-valued `X.ringCatSheaf` for sheafification; this split is correctly reflected in the code.
- **notes**: Blueprint has `\leanok` on the statement block (correct — declaration exists).

---

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_functoriality}` (`lem:scheme_modules_tensorobj_functoriality`)
- **Lean target exists**: yes (line 215)
- **Signature matches**: yes — takes `f : M ⟶ M'`, `g : N ⟶ N'`, returns `tensorObj M N ⟶ tensorObj M' N'`; body uses `sheafification.map ∘ tensorHom` on the presheaf category.
- **Proof follows sketch**: yes — the bifunctoriality is inherited from `PresheafOfModules.Monoidal.tensorObj` via the sheafification functor, consistent with the blueprint's "morphism action inherited from `PresheafOfModules.Monoidal.tensorObj` under sheafification."
- **notes**: Blueprint has `\leanok` on the statement block (correct).

---

### `lem:restrictscalars_laxmonoidal` — **NO `\lean{...}` pin in the blueprint**
- **Lean target exists**: yes — three declarations implement this lemma:
  - `PresheafOfModules.restrictScalarsLaxε` (line 114, axiom-clean)
  - `PresheafOfModules.restrictScalarsLaxμ` (line 130, axiom-clean)
  - `PresheafOfModules.restrictScalarsLaxMonoidal` instance (line 147, axiom-clean)
- **Signature matches**: yes, for the instance. The blueprint requires `PresheafOfModules.restrictScalars φ` to be lax monoidal for φ a morphism of presheaves of *commutative* rings. The Lean instance is:
  ```
  (α : R ⋙ forget₂ CommRingCat RingCat ⟶ S ⋙ forget₂ CommRingCat RingCat) →
  (PresheafOfModules.restrictScalars α).LaxMonoidal
  ```
  where `R S : Cᵒᵖ ⥤ CommRingCat` — the `CommRingCat`-factoring hypothesis matches the prose. The `forget₂` in the arrow type is needed because `PresheafOfModules.restrictScalars` takes `RingCat`-level morphisms; this is correct.
- **Proof follows sketch**: yes — ε and μ are assembled sectionwise from `ModuleCat.restrictScalars (α.app X).hom`'s lax structure (`Functor.LaxMonoidal.ε/μ`), matching the blueprint's "sectionwise lift from `ModuleCat.restrictScalars f` is lax monoidal." The coherence axioms (μ_natural_left/right, associativity, unitalities) are proved sectionwise by forwarding to the `ModuleCat` instance — consistent with "no new diagram chase beyond transporting sectionwise coherence."
- **notes**: **Major finding** — the blueprint lemma block has no `\lean{...}` pin at all, and no `\leanok` marker. The three Lean declarations are axiom-clean and new this iteration. The review agent should add `\lean{AlgebraicGeometry.PresheafOfModules.restrictScalarsLaxMonoidal}` (or the instance name) and `\leanok` to the statement block of `lem:restrictscalars_laxmonoidal`.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_restrict_iso}` (`lem:tensorobj_restrict_iso`)
- **Lean target exists**: yes (line 330)
- **Signature matches**: yes — takes `f : Y ⟶ X` with `[IsOpenImmersion f]`, `M N : X.Modules`, returns `(tensorObj M N).restrict f ≅ tensorObj (M.restrict f) (N.restrict f)`.
- **Proof follows sketch**: **no** — Steps 1 and 2 of the blueprint proof are implemented (`restrictFunctorIsoPullback` and `sheafificationCompPullback` calls, lines 335–348), but Step 3 ends with `sorry` (line 367). The blueprint proof claims Step 3 ("the comparison map is the mate of pushforward") is closed by `leftAdjointOplaxMonoidal` given `(pushforward φ).LaxMonoidal` from `lem:restrictscalars_laxmonoidal`. This claim is false — see Red Flags below for the precise obstruction.
- **notes**: Blueprint has `\leanok` on statement block only (correct — declaration exists with sorry body). The proof block correctly lacks `\leanok`.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_isLocallyTrivial}` (`lem:tensorobj_preserves_locally_trivial`)
- **Lean target exists**: yes (line 380)
- **Signature matches**: yes — takes `hM : LineBundle.IsLocallyTrivial M`, `hN : LineBundle.IsLocallyTrivial N`, concludes `LineBundle.IsLocallyTrivial (tensorObj M N)`.
- **Proof follows sketch**: partial — the proof structure follows the blueprint (find common affine W, restrict trivialisations, chain isos through `tensorObj_restrict_iso → tensorObjIsoOfIso → tensorObj_unit_iso`). The chain at lines 391–393 is exactly the blueprint's "common affine open → restrict → iso chain." However, the proof is only sound modulo `tensorObj_restrict_iso` (which has a sorry body and is itself blocked).
- **notes**: Blueprint has `\leanok` on statement block (correct). Proof block lacks `\leanok` (correct — transitively sorry-bearing). The `restrictIsoUnitOfLE` helper (lines 284–306) is an axiom-clean auxiliary that makes this proof self-contained, and it is correctly NOT `\lean{}`-pinned (pure helper).

---

### `\lean{AlgebraicGeometry.Scheme.Modules.exists_tensorObj_inverse}` (`lem:tensorobj_inverse_invertible`)
- **Lean target exists**: yes (line 406)
- **Signature matches**: yes — takes `hL : LineBundle.IsLocallyTrivial L`, concludes `∃ Linv, LineBundle.IsLocallyTrivial Linv ∧ Nonempty (tensorObj L Linv ≅ SheafOfModules.unit X.ringCatSheaf)`. The designated unit `SheafOfModules.unit X.ringCatSheaf` matches the blueprint's `𝒪_X` (the "iter-206 flat-pivot" note in the docstring correctly explains why `MonoidalCategory`'s `𝟙_` is not used — the full monoidal instance is off the critical path).
- **Proof follows sketch**: N/A — body is `sorry`, blueprint proof sketch exists but is not yet implemented.
- **notes**: Blueprint has `\leanok` on statement block (correct). Proof block lacks `\leanok` (correct).

---

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjOnProduct}` (`lem:tensorobj_lift_onproduct`)
- **Lean target exists**: yes (line 418)
- **Signature matches**: yes — takes `L L' : LineBundle.OnProduct πC πT`, returns `LineBundle.OnProduct πC πT` via `tensorObj L.carrier L'.carrier` with `tensorObj_isLocallyTrivial`.
- **Proof follows sketch**: partial — the declaration delivers only the operation-closure on the subtype (that the tensor of two `OnProduct` objects is again one). The blueprint's `% NOTE` (lines 652–659) correctly documents this limitation: the remaining group-law data (unit-membership, dual/inverse, associativity/unit/commutativity isos) are separate items blocked on `tensorobj_restrict_iso`. The body is consistent with what the blueprint acknowledges the declaration provides.
- **notes**: Blueprint has `\leanok` on statement block (correct). Body is not a `sorry` — it calls `tensorObj_isLocallyTrivial` which is itself transitive on the sorry in `tensorObj_restrict_iso`.

---

### `\lean{AlgebraicGeometry.Scheme.PicSharp.addCommGroup_via_tensorObj}` (`thm:rel_pic_addcommgroup_via_tensorobj`)
- **Lean target exists**: yes (line 446)
- **Signature matches**: yes — returns `AddCommGroup (Quotient (RelPicPresheaf.preimage_subgroup πC πT))`.
- **Proof follows sketch**: N/A — body is `sorry`, consistent with the blueprint marking this as the iter-204+ closure target.
- **notes**: Blueprint has `\leanok` on statement block (correct). Proof block lacks `\leanok` (correct). The `@[implicit_reducible]` attribute and the `def`-vs-`instance` choice are consistent with the blueprint's note about avoiding an instance diamond with the existing `PicSharp.addCommGroup`.

---

## Red Flags

### Placeholder / suspect bodies
- `tensorObj_restrict_iso` at line 367: body ends in `sorry`. The sorry is **authorized** by the blueprint (statement block marked `\leanok`, proof block not). Not a new red flag — but see Blueprint Adequacy below.
- `exists_tensorObj_inverse` at line 410: `sorry` body. Authorized by blueprint.
- `addCommGroup_via_tensorObj` at line 449: `sorry` body. Authorized by blueprint.

### Excuse-comments — **NONE**.
The inline comments in `tensorObj_restrict_iso` (lines 349–366) are **not** excuse-comments: they are precise technical documentation of what is missing and why (`PresheafOfModules.pullback φ.hom` needs a `Monoidal` instance; the sectionwise ingredient exists but the presheaf-level lift does not). These are accurate and useful. No comment of the form "wrong but works for now" or "placeholder" appears.

### Axioms / `Classical.choice` on non-trivial claims — **NONE**.
All three new declarations (`restrictScalarsLaxε`, `restrictScalarsLaxμ`, `restrictScalarsLaxMonoidal`) are axiom-clean. Confirmed by the directive and consistent with the code (all proofs are by `ext1`, `exact`, and forwarding to `Functor.LaxMonoidal.*` — no `axiom`, no `Classical.choice`, no `native_decide`).

---

## Unreferenced declarations (informational)

| Declaration | Line | Disposition |
|---|---|---|
| `PresheafOfModules.restrictScalarsLaxε` | 114 | Implementation detail for `restrictScalarsLaxMonoidal`; could stay unpinned, but `lem:restrictscalars_laxmonoidal` needs a `\lean{}` pin for the **instance** |
| `PresheafOfModules.restrictScalarsLaxμ` | 130 | Same as above |
| `PresheafOfModules.restrictScalarsLaxMonoidal` | 147 | **Should be `\lean{}`-pinned** at `lem:restrictscalars_laxmonoidal` |
| `AlgebraicGeometry.Scheme.Modules.tensorObjIsoOfIso` | 250 | Pure helper for `tensorObj_isLocallyTrivial`; acceptable to omit |
| `AlgebraicGeometry.Scheme.Modules.tensorObj_unit_iso` | 266 | Used in `tensorObj_isLocallyTrivial`; acceptable helper |
| `AlgebraicGeometry.Scheme.Modules.restrictIsoUnitOfLE` | 284 | Helper for `tensorObj_isLocallyTrivial`; acceptable to omit |

---

## Blueprint adequacy for this file

- **Coverage**: 7/7 `\lean{...}`-pinned declarations have corresponding Lean targets. 3 additional declarations (`restrictScalarsLaxε/μ/Monoidal`) are present in Lean with no blueprint pin (see Major finding).
- **Proof-sketch depth**: **under-specified** / **incorrect** for `lem:tensorobj_restrict_iso`. All other proof sketches are either adequate (Steps 1–2 of `tensorobj_restrict_iso`) or consistent with the sorry status (the other pinned declarations). Details follow.
- **Hint precision**: **loose** for `lem:restrictscalars_laxmonoidal` (no `\lean{...}` at all). **Correct** for all 7 other pinned declarations.
- **Generality**: matches need for all declared items.

### Critical blueprint adequacy failure — `lem:tensorobj_restrict_iso` proof sketch and `% NOTE`

The `% NOTE` in the statement block of `lem:tensorobj_restrict_iso` (blueprint lines 390–400) asserts:

> "The SOLE remaining project-side ingredient is the sectionwise lax-monoidal instance of `lem:restrictscalars_laxmonoidal`. This is a bounded mathlib-build target (one sectionwise lax instance, ~40–90 LOC), not a multi-file wall: every other piece (the mate δ, the `comp`, the flat-exactness upgrade to an iso) is already in Mathlib."

**This claim is demonstrably false as of iter-207.** The lax instance (`restrictScalarsLaxMonoidal`) has now been built — axiom-clean, ~65 LOC. `tensorObj_restrict_iso` remains blocked. The actual remaining obstacles are:

**Obstacle 1 (RingCat/CommRingCat layer mismatch).** After Step 2 (`sheafificationCompPullback`), the proof goal involves `PresheafOfModules.pullback φ.hom` where `φ = f.toRingCatSheafHom` is a `RingCat`-level sheaf morphism. The `PresheafOfModules` monoidal structure (and `leftAdjointOplaxMonoidal`) is defined only for `CommRingCat`-valued presheaves. The δ-route's residual therefore lands at the `RingCat` layer, where there is no monoidal structure, not at the `CommRingCat` layer where `restrictScalarsLaxMonoidal` lives.

**Obstacle 2 (⋙-vs-forget₂ mismatch).** Even if one attempts to work at the `CommRingCat` level, composing `pushforward φ` with `restrictScalarsLaxMonoidal` requires matching the `⋙ forget₂` in `restrictScalarsLaxMonoidal`'s morphism type with the definitional unfolding of `pushforward`. Instance resolution does not unify these automatically (a `⋙`-vs-`forget₂` associativity mismatch), so `(pushforward φ).LaxMonoidal` is not discharged by inference after just providing `restrictScalarsLaxMonoidal`.

**Obstacle 3 (actual residual, as documented in the Lean file).** The actual residual identified by the prover in the Lean comments (lines 349–366) is that `PresheafOfModules.pullback φ.hom` needs to be a **strong monoidal** functor for the `PresheafOfModules.Monoidal.tensorObj` monoidal structure. This is the presheaf-level lift of `ModuleCat.extendScalars` being monoidal — the sectionwise fact exists in Mathlib (`ModuleCat.extendScalars` has monoidal structure), but the presheaf-level lift `(PresheafOfModules.pullback φ.hom).Monoidal` does not exist in Mathlib at `b80f227`. The blueprint's Step 3 proof ("the comparison map is the mate of pushforward / sole project-side ingredient is the lax instance") is therefore **incorrect as a proof route** — the actual route requires a separate and more substantial Lean development.

**Conclusion**: The blueprint's proof of `lem:tensorobj_restrict_iso` cannot be formalized as written. Step 3 and the `% NOTE` must be corrected to:
1. Acknowledge the `RingCat`/`CommRingCat` commutativity gap (and how to cross it, if a route exists);
2. Replace the "SOLE project-side ingredient is the lax instance" claim with an accurate description of the actual residual: either building `(PresheafOfModules.pullback φ.hom).Monoidal` (a non-trivial presheaf-level lift of `ModuleCat.extendScalars`), or identifying an alternative construction route entirely.

### Recommended chapter-side actions

1. **(Must-fix)** Correct `lem:tensorobj_restrict_iso`: rewrite the `% NOTE` and Step 3 of the proof to (a) remove the false "SOLE project-side ingredient" claim, (b) accurately describe the actual remaining obstacle (presheaf-level monoidal instance for `PresheafOfModules.pullback`), and (c) propose a corrected route or acknowledge the proof sketch needs redesign.

2. **(Major)** Add `\lean{AlgebraicGeometry.PresheafOfModules.restrictScalarsLaxMonoidal}` (and `\leanok`) to the statement block of `lem:restrictscalars_laxmonoidal` to reflect the axiom-clean Lean declaration built this iteration.

3. **(Minor)** Optionally add separate `\lean{}`-pins for `restrictScalarsLaxε` and `restrictScalarsLaxμ` under `lem:restrictscalars_laxmonoidal` or as helper-only footnotes, since they are named definitions (not anonymous) and a reader of the blueprint who looks up the proof would benefit from finding them.

---

## Severity summary

| Finding | Severity |
|---|---|
| Blueprint proof of `lem:tensorobj_restrict_iso` (Step 3 + `% NOTE`) falsely claims the lax instance is the "SOLE remaining project-side ingredient" — this is now demonstrated false, and the blueprint proof route cannot be formalized as written | **must-fix-this-iter** |
| `lem:restrictscalars_laxmonoidal` has no `\lean{...}` pin despite axiom-clean Lean declarations existing for it | **major** |
| 3 new Lean declarations (`restrictScalarsLaxε`, `restrictScalarsLaxμ`, `restrictScalarsLaxMonoidal`) are unreferenced in the blueprint | **major** (for the instance) / minor (for the helpers) |
| `tensorObj_restrict_iso`, `exists_tensorObj_inverse`, `addCommGroup_via_tensorObj` remain sorry-bearing | expected / authorized — not a red flag |

**Overall verdict**: The three axiom-clean lax-monoidal declarations built this iteration accurately implement `lem:restrictscalars_laxmonoidal` and faithfully follow the blueprint's proof sketch for that lemma; however, one must-fix-this-iter blueprint adequacy failure blocks downstream progress — the `% NOTE` and Step 3 of `lem:tensorobj_restrict_iso` contain a false claim that the lax instance is the sole remaining project-side ingredient, a claim now falsified by the prover's construction, and the blueprint proof of that lemma must be corrected before the next prover can make progress on the sorry.
