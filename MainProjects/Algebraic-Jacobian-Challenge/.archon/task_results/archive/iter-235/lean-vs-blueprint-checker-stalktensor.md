# Lean ↔ Blueprint Check Report

## Slug
stalktensor

## Iteration
235

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate/StalkTensor.lean`
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`, §`sec:tensorobj_stalk_tensor` (lines 1837–2011)

---

## Per-declaration

### `\lean{PresheafOfModules.stalkTensorIso}` (chapter: `\thm:stalk_tensor_commutation`)
- **Lean target exists**: no — `stalkTensorIso` is not declared anywhere in the file. The file ends with private `revBihom_germ_tmul` and a large comment block explaining the remaining gap.
- **Signature matches**: N/A — declaration absent.
- **Proof follows sketch**: N/A
- **notes**: The `% NOTE: forward-looking \lean{} pin — stalkTensorIso is NOT YET BUILT` annotation on the block is accurate: the iso is genuinely not assembled. No `\leanok` is present on this block, which is correct. However, the NOTE is **stale** about the iteration count (see Red Flags below).

### `\lean{PresheafOfModules.stalkTensorDesc}` (chapter: `\lem:stalk_tensor_desc_forward`)
- **Lean target exists**: yes — `PresheafOfModules.stalkTensorDesc` at line 133.
- **Signature matches**: yes — `TopCat.Presheaf.stalk (Monoidal.tensorObj A B).presheaf x ⟶ AddCommGrpCat.of Tgt`, where `Tgt = TensorProduct ↑(R.stalk x) ↑(stalk A.presheaf x) ↑(stalk B.presheaf x)`. This matches the blueprint's additive comparison map `(A ⊗ᵖ B).stalk x → A.stalk x ⊗_{R.stalk x} B.stalk x`.
- **Proof follows sketch**: yes — the colimit descent with `colimit.desc` over the open-neighbourhood diagram matches stages (i)–(ii) exactly: per-neighbourhood map `stalkTensorDescU` assembled via `TensorProduct.liftAddHom` from `stalkTensorBilin`, then descended through the filtered colimit. Germ characterisation `stalkTensorDesc_germ_tmul` matches the blueprint's `stalkTensorDesc(germ(a⊗b)) = germ a ⊗ germ b`.
- **notes**: `\leanok` is present on this block. Correct.

### `\lean{PresheafOfModules.stalkTensorLinearMap}` (chapter: `\lem:stalk_tensor_linear_map`)
- **Lean target exists**: yes — `PresheafOfModules.stalkTensorLinearMap` at line 188.
- **Signature matches**: yes — `(↑(TopCat.Presheaf.stalk (Monoidal.tensorObj A B).presheaf x) : Type u) →ₗ[↑(R.stalk x)] Tgt`, an `R.stalk x`-linear map. This matches the blueprint's "R.stalk x-linear packaging of the forward comparison map".
- **Proof follows sketch**: yes — linearity is checked on a germ `germ r` of a scalar `r : R(U)` via `germ_smul` and `stalkTensorDescU_smul`, after passing to a common neighbourhood `W := U ⊓ V`. This matches the blueprint's stage (iii) description: "on a germ germ_x r of a section r ∈ R(U) one checks stalkTensorDesc((germ_x r)·ξ) = (germ_x r)·stalkTensorDesc(ξ) on germs of simple tensors and extends by additivity."
- **notes**: `\leanok` is present on this block. The carrier-duality obstacle (CommRingCat vs RingCat) mentioned in the blueprint stage (iii) is handled in the Lean code via `erw` + `TensorProduct.smul_tmul'`, consistent with the blueprint's description. Correct.

---

## Red Flags

### Stale `% NOTE:` annotation (major — not a must-fix, but should be updated this iter by the review agent)

The `% NOTE:` annotation on `\lem:stalk_tensor_commutation` reads:

```
% NOTE: forward-looking \lean{} pin — `stalkTensorIso` is NOT YET BUILT
% (stages (iv) reverse map + (v) mutual-inversion bundle remain). As of
% iter-234 the highest stage landed is (iii) `stalkTensorLinearMap` (the
% R_x-linear forward map). No  is or should be on this block until
% the iso is assembled.
```

Two issues:

1. **Stale iteration count**: The NOTE says "As of iter-234 the highest stage landed is (iii)". This is now false: iter-235 has landed the stage (iv) private reverse-map infrastructure (`revInnerLeg`, `revInner`, `revOuterLeg`, `revBihom`, `revBihom_germ_tmul`), all axiom-clean. Stage (iv) is PARTIALLY done — the structural descent is built, but `revBihom_balanced` + `stalkTensorRev` remain.

2. **Typo**: "No  is or should be on this block" — the `\leanok` command is absent (clearly a copy-paste artifact where the LaTeX command was stripped). Should read "No `\leanok` is or should be on this block".

The core statement ("stalkTensorIso is NOT YET BUILT") remains correct, so this is not a must-fix. The review agent should update the NOTE to reflect the iter-235 state.

### No placeholder bodies, no `axiom`, no `:= sorry`
None found. All public and private declarations have substantive implementations.

---

## Unreferenced declarations (informational)

The following declarations in the Lean file have no `\lean{...}` pin in the blueprint:

**Stage (iv) private infrastructure (10 declarations):**
- `revInnerLeg` (private) — inner cocone leg
- `revInnerLeg_apply` (private) — evaluation of `revInnerLeg`
- `revInner` (private) — inner descent (B-stalk colimit)
- `germ_revInner` (private) — factorization through B-germ
- `revInner_germ` (private) — germ characterisation of inner descent
- `revOuterLeg` (private) — outer cocone leg
- `revOuterLeg_apply` (private) — evaluation of outer leg
- `revBihom` (private) — outer descent (A-stalk colimit)
- `germ_revBihom` (private) — factorization through A-germ
- `revBihom_germ_tmul` (private) — germ characterisation of additive bilinear comparison

All are `private` and are internal building blocks for the eventual public `stalkTensorRev` (which is not yet defined). Appropriate: the blueprint stage (iv) prose describes the mathematical construction without requiring the private helper names to be individually pinned.

**Helpers for public declarations (no pin needed):**
- `stalkTensorBilin`, `stalkTensorBilin_balanced` — internal to `stalkTensorDescU`
- `stalkTensorDescU`, `stalkTensorDescU_tmul`, `stalkTensorDescU_smul` — internal to `stalkTensorDesc`
- `germ_stalkTensorDesc`, `stalkTensorDesc_germ` — helpers for `stalkTensorDesc`
- `stalkTensorLinearMap_germ_tmul` — helper for `stalkTensorLinearMap`

None of these warrant new blueprint blocks.

---

## Directive-specific checks

### 1. Lean → Blueprint: faithfulness of stage (iv) implementation

The stage (iv) Lean code (private `revInnerLeg`/`revInner`/`revOuterLeg`/`revBihom` + germ characterisation `revBihom_germ_tmul`) faithfully implements the blueprint's described nested double-colimit reverse descent:

- Blueprint says: "descending first the A-variable out of {A(U)}_{U∋x} and then the B-variable out of {B(V)}_{V∋x}, passing to the common refinement U∩V to form the simple tensor and its germ."
- Lean: `revInner` descends the B-variable via `colimit.desc` over `(OpenNhds.inclusion x).op ⋙ B.presheaf` (for a fixed A-section `a`), and `revBihom` descends the A-variable via `colimit.desc` over `(OpenNhds.inclusion x).op ⋙ A.presheaf`. The common refinement is `U ⊓ V` throughout. The germ of `(a|_{U⊓V}) ⊗ (b|_{U⊓V})` is computed via explicit restriction maps and the section-level tensor. ✓

**No divergence** between stage (iv) Lean code and the blueprint prose.

### 2. Blueprint → Lean: adequacy of stage (iv) prose for the balancing obstacle

The blueprint stage (iv) says: "R_x-bilinearity reduces to the germ–scalar compatibility of (i)/(iii)." This is true at a high level, but the blueprint does NOT call out the specific technical obstacle the Lean hit when trying to prove `revBihom_balanced`:

> The `restrictScalars`/CommRingCat-vs-RingCat carrier-duality wall: `TensorProduct.smul_tmul` fails to synthesize a `DistribMulAction` defeq to the inferred `ModuleCat.instModuleCarrierObjRestrictScalars` because the section tensor is annotated over the `CommRingCat` carrier while the restriction map produces a `RingCat`-carrier module.

This obstacle is described in detail in the large in-file comment block in the Lean file (lines 397–420), but the blueprint has no corresponding annotation. The next prover round will need guidance on this specific technical point. However, the blueprint provides enough structural guidance for the nested colimit descent itself; the balancing proof is a sub-step that the blueprint sketch bundles into "R_x-bilinearity."

**Assessment**: The blueprint is adequate for the structural part of stage (iv), but under-specified for the balancing sub-step. This warrants a blueprint update for the next prover round.

### 3. Accuracy of the `% NOTE: forward-looking \lean{} pin` annotation

The core claim ("stalkTensorIso is NOT YET BUILT") is still accurate. The iso is genuinely not built. The `\lean{PresheafOfModules.stalkTensorIso}` forward pin is correct as a target declaration name.

The annotation is **stale** in the iter count and has a typo (see Red Flags above), but these are soft issues, not must-fixes.

### 4. Stage-(iii) pin correctness: `lem:stalk_tensor_linear_map` / `\lean{stalkTensorLinearMap}`

The pin is correct. `PresheafOfModules.stalkTensorLinearMap` exists, its signature matches, `\leanok` is present, and the declaration is axiom-clean. ✓

---

## Blueprint adequacy for this file

- **Coverage**: 2/2 public-declaration `\lean{...}` blocks are correctly matched (`stalkTensorDesc`, `stalkTensorLinearMap`). The forward-looking `stalkTensorIso` pin is correct but intentionally unlandable yet. All private stage-(iv) declarations are appropriately un-pinned (they're building blocks, not standalone results). The 10 private stage-(iv) declarations and ~8 helper declarations are all properly treated as unreferenced helpers.
- **Proof-sketch depth**: **partially under-specified** for stage (iv). The structural nested colimit descent is adequately described. The balancing condition and its `restrictScalars`/carrier-duality obstacle — which is the only current blocker for `revBihom_balanced` + `stalkTensorRev` — are not described in the blueprint; the blueprint only says "R_x-bilinearity reduces to the germ–scalar compatibility of (i)/(iii)", which is correct but omits the technical detail the Lean actually needed.
- **Hint precision**: **precise** for the two pinned declarations (`stalkTensorDesc`, `stalkTensorLinearMap`). The forward-looking `stalkTensorIso` pin names the correct target.
- **Generality**: matches need — the blueprint correctly scopes the construction to `PresheafOfModules (R ⋙ forget₂)` with varying ring.
- **Recommended chapter-side actions**:
  1. Update the `% NOTE:` on `\lem:stalk_tensor_commutation` to reflect iter-235 state: "As of iter-235, stage (iv) private reverse-map infrastructure (`revInnerLeg`/`revInner`/`revOuterLeg`/`revBihom`/`revBihom_germ_tmul`) is axiom-clean; the remaining gap is `revBihom_balanced` (the R_x-balancing of `revBihom`) and its consumer `stalkTensorRev`. Stage (v) is fully open."
  2. Fix the typo "No  is or should be on this block" → "No `\leanok` is or should be on this block."
  3. Optionally add a sentence to stage (iv) noting the carrier-duality sub-obstacle for the balancing proof: "The balancing `revBihom(r•a) b = revBihom a (r•b)` is proved by passing to germ generators over a common neighbourhood `W`, which reduces to the section-level identity `(A.map r' • a') ⊗ B.map b' = A.map a' ⊗ (B.map r' • b')` in the section tensor over `W⊓W`; the same `erw`/`smul_tmul'` recipe used for `stalkTensorDescU_smul` (stage (iii)) resolves the CommRingCat/RingCat carrier-duality obstacle at the section level."

---

## Severity summary

- **must-fix-this-iter**: none. No placeholder bodies, no unauthorized axioms, no excuse-comments on substantive declarations. The `stalkTensorIso` absence is intentional and correctly annotated.
- **major**: 1 — the `% NOTE:` on `lem:stalk_tensor_commutation` is stale (iter count + typo). The review agent should update it this iteration.
- **minor**: 1 — blueprint stage (iv) proof sketch does not describe the carrier-duality obstacle for `revBihom_balanced`; the next prover round would benefit from a blueprint addition.

**Overall verdict**: The stage-(iv) Lean code faithfully implements the blueprint's nested colimit reverse-map descent; the two public pinned declarations (`stalkTensorDesc`, `stalkTensorLinearMap`) are correct and axiom-clean; the sole residual blocker (`revBihom_balanced`) is correctly absent from the Lean file and the `stalkTensorIso` forward-pin annotation is accurate — but the annotation is stale on the iter count and has a typo (both addressable by the review agent this iter, not blocking).
