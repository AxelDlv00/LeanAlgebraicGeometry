# Lean ↔ Blueprint Check Report

## Slug
stalktensor

## Iteration
234

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate/StalkTensor.lean`
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`, §`sec:tensorobj_stalk_tensor` (lines 1835–2068)

---

## Per-declaration

### `\lean{PresheafOfModules.stalkTensorIso}` (chapter: `lem:stalk_tensor_commutation`, line 1853)

- **Lean target exists**: **no** — `PresheafOfModules.stalkTensorIso` is not defined anywhere in `StalkTensor.lean`. The file ends at stage (iii); stages (iv) and (v) remain unbuilt.
- **Signature matches**: N/A (declaration absent)
- **Proof follows sketch**: N/A (declaration absent)
- **notes**: The lemma block carries no `\leanok`, so no false completion is claimed. The NOTE comments inside the block (lines 1855–1860) correctly enumerate the partial-build status: stages (i)–(ii) assembled, (iii) done (`stalkTensorDescU_smul`), (iv)/(v) still outstanding. The `sync_leanok` phase will correctly leave this block unmarked. However, the `\lean{}` pin is a forward-looking target, not a current declaration — documented below as a major finding.

### `\lean{PresheafOfModules.stalkTensorDesc}` (chapter: `lem:stalk_tensor_desc_forward`, line 2013)

- **Lean target exists**: **yes** — `stalkTensorDesc` is defined at Lean line 133.
- **Signature matches**: **yes** — blueprint: "additive comparison map `(A ⊗ᵖ B).stalk x → A.stalk x ⊗_{R.stalk x} B.stalk x`"; Lean: `TopCat.Presheaf.stalk (Monoidal.tensorObj A B).presheaf x ⟶ AddCommGrpCat.of Tgt` where `Tgt` is exactly the `R.stalk x`-tensor product. Match is faithful.
- **Proof follows sketch**: **yes** — the blueprint sketch (stages i–ii: bilinear map, TensorProduct.liftAddHom descent, colimit.desc cocone, germ characterisation on simple tensors) matches the Lean proof structure: `stalkTensorBilin` + `TensorProduct.liftAddHom` → `stalkTensorDescU`; then `colimit.desc` with the cocone checked by `TensorProduct.induction_on` (zero/tmul/add) → `stalkTensorDesc`; germ characterisation by `stalkTensorDesc_germ_tmul`.
- **notes**: `\leanok` present on statement block (line 2010). ✓

### Stages (iii) output: `stalkTensorLinearMap` (no standalone `\lean{}` block)

- **Lean target exists**: yes — `stalkTensorLinearMap` is defined at Lean line 188.
- **Blueprint coverage**: **absent** — `stalkTensorLinearMap` is mentioned by name in the stage (iii) prose within the proof of `lem:stalk_tensor_commutation` (line 1946) and in the NOTE comment (line 1858), but there is **no standalone blueprint lemma block** with `\lean{PresheafOfModules.stalkTensorLinearMap}`. Compare: `stalkTensorDesc` (stages i–ii output) has its own block `lem:stalk_tensor_desc_forward`. The stage (iii) primary landing (`stalkTensorLinearMap`) does not.
- **Signature check (against prose)**: The stage (iii) prose says the forward map is upgraded to "an `R.stalk x`-linear map". Lean signature: `(↑(TopCat.Presheaf.stalk (Monoidal.tensorObj A B).presheaf x) : Type u) →ₗ[↑(R.stalk x)] Tgt`. This matches.
- **Proof follows sketch**: **yes** — blueprint describes: check `stalkTensorDesc((germ r) · ξ) = (germ r) · stalkTensorDesc(ξ)` via germ-representative argument (pass to common neighbourhood `W = U ⊓ V`, use `germ_res_apply` to rewrite, then apply `PresheafOfModules.germ_smul` + `stalkTensorDescU_smul`). Lean proof uses exactly this: `germ_exist` twice, `inf_le_left`/`inf_le_right` for the common neighbourhood, `germ_res_apply`-based rewrites for `hr`/`hz`, then `germ_smul (Monoidal.tensorObj A B)` + `stalkTensorDesc_germ` + `stalkTensorDescU_smul`. Carrier-duality (`erw` absorbing the `CommRingCat`/`RingCat` discrepancy) is handled inside `stalkTensorDescU_smul` rather than inline in `stalkTensorLinearMap`, which is cleaner than the blueprint's prose implied but mathematically identical.
- **notes**: See major finding below.

### `stalkTensorLinearMap_germ_tmul` (no blueprint reference)

- **Lean target exists**: yes — defined at Lean line 218 as a `@[simp]` lemma.
- **Blueprint coverage**: not separately referenced. The germ formula `stalkTensorLinearMap(germ(a ⊗ b)) = germ a ⊗ germ b` is noted in the stage (iii) prose as inherited from stage (ii), and stage (v) prose (`stalkTensorDesc_germ_tmul`) relies on the same formula. No must-fix concern; this is a legitimate helper.
- **Proof follows sketch**: **yes** — one-liner delegating to `stalkTensorDesc_germ_tmul`. Correct.

---

## Red flags

### Placeholder / suspect bodies
None. All four new declarations (`stalkTensorDescU_smul`, `stalkTensorDesc_germ`, `stalkTensorLinearMap`, `stalkTensorLinearMap_germ_tmul`) have full non-sorry proofs.

### Excuse-comments
None. The module-level doc and per-declaration doc-strings accurately state what has been built and what remains outstanding ("the full isomorphism `PresheafOfModules.stalkTensorIso` additionally requires the reverse map and their mutual inversion on germs — see the handoff in `task_results`"). This is informative, not excuse-giving.

### Axioms / Classical.choice on non-trivial claims
None detected. File uses only `noncomputable` (from `TensorProduct`/`colimit`), which is expected and not a classical-choice concern.

---

## Unreferenced declarations (informational)

The following declarations in `StalkTensor.lean` have no `\lean{...}` pin in the blueprint. Most are helpers:

| Declaration | Role | Flag? |
|---|---|---|
| `stalkTensorBilin` (line 66) | stage (i) building block; named in stage (i) prose | no |
| `stalkTensorBilin_balanced` (line 77) | internal helper for `liftAddHom`; not in prose | no |
| `stalkTensorDescU` (line 89) | stage (i) descent; named in stage (i) prose | no |
| `stalkTensorDescU_tmul` (line 94) | @[simp] characterisation, helper | no |
| `stalkTensorDescU_smul` (line 109) | stage (iii) section-level core; named in NOTE comment | **see major finding** |
| `germ_stalkTensorDesc` (line 156) | @[reassoc] helper; used inside `stalkTensorLinearMap` | no |
| `stalkTensorDesc_germ_tmul` (line 163) | @[simp]; named in stage (ii) prose | no |
| `stalkTensorDesc_germ` (line 175) | convenience wrapper; not named in prose | no |
| `stalkTensorLinearMap` (line 188) | stage (iii) primary output | **see major finding** |
| `stalkTensorLinearMap_germ_tmul` (line 218) | @[simp] germ characterisation | no |

---

## Blueprint adequacy for this file

- **Coverage**: 1/10 substantive declarations have a dedicated `\lean{...}` block with their own lemma label (`stalkTensorDesc` → `lem:stalk_tensor_desc_forward`). The other declarations are either named in prose, in NOTE comments, or helpers. The main issue is that `stalkTensorLinearMap` — the principal stage (iii) delivery, this iteration's key landing — lacks a dedicated block.
- **Proof-sketch depth**: **adequate for stages (iv)/(v)**. The blueprint's stage (iv) prose (lines 1962–1979) describes the nested colimit descent, the representative approach (`a ∈ A(U)`, `b ∈ B(V)`, refine to `U ∩ V`), well-definedness from filteredness, and R_x-bilinearity from (i)/(iii). This is detailed enough to guide a formalization. Stage (v) (lines 1981–1995) names the key tactic (`TensorProduct.induction_on`), the key lemma (`stalkTensorDesc_germ_tmul` for forward composite, `stalk_hom_ext` for backward), and the bundling step. This is sufficient guidance.
- **Hint precision**: **loose on `stalkTensorLinearMap`** — the stage (iii) prose names the declaration and describes the linearity check, but the absence of a standalone `\lean{...}` block means there is no blueprint-enforced contract on the signature. The signature is recoverable from the prose, but it is not pinned.
- **Generality**: matches need — the blueprint correctly sets up the varying-ring context (`R : (Opens X)^op → CommRingCat`, `A B : PresheafOfModules (R ⋙ forget₂ _ _)`) matching the Lean variable declarations exactly.
- **Recommended chapter-side actions** (for a blueprint-writing subagent):
  1. **[major, this iter]** Add a standalone `\begin{lemma}...\end{lemma}` block for `stalkTensorLinearMap` — call it e.g. `lem:stalk_tensor_linearmap` — with `\lean{PresheafOfModules.stalkTensorLinearMap}` and the signature: "`stalkTensorLinearMap : (A ⊗ᵖ B).stalk x →ₗ[R.stalk x] A.stalk x ⊗_{R.stalk x} B.stalk x`". This mirrors the `lem:stalk_tensor_desc_forward` pattern for the stage (iii) advancement. The block should note that this is the stage (iii) landing and the direct input to stage (iv).
  2. **[major, this iter]** The `\lean{PresheafOfModules.stalkTensorIso}` pin in `lem:stalk_tensor_commutation` currently names a not-yet-existing declaration. This is correctly unformalized (no `\leanok`), and the NOTE comments track the build state. To avoid any ambiguity in the `sync_leanok` phase (which will look up `stalkTensorIso` and not find it), consider temporarily splitting the `\lean{}` pin: point the statement block at `stalkTensorLinearMap` as the current partial implementation and keep `stalkTensorIso` only once stages (iv)/(v) are built. Alternatively add a `% NOT YET BUILT` annotation immediately after the `\lean{}` line so the intent is unambiguous to any reader.
  3. **[minor]** `stalkTensorLinearMap_germ_tmul` (the @[simp] germ-formula for the linear map) is worth a one-line mention in the `lem:stalk_tensor_linearmap` block, as it will be the primary tool for the stage (v) inversion check.

---

## Severity summary

**Must-fix-this-iter**: None — no sorry placeholders, no excuse-comments, no axioms, no weakened-wrong definitions, no false `\leanok` markers.

**Major (2 findings)**:

1. **`\lean{PresheafOfModules.stalkTensorIso}` in `lem:stalk_tensor_commutation` targets a non-existent declaration.** The lemma block has no `\leanok`, so no false proof-completion is claimed; the NOTE comments correctly track the partial state. But the `\lean{}` pin is a forward-pointing target not yet in the Lean file. Recommend: either temporarily redirect the pin to `stalkTensorLinearMap` (the current highest-stage delivery) or annotate with `% NOT YET BUILT`. The `sync_leanok` phase will handle this correctly (no `\leanok` to add/remove), but a human reader of the blueprint could be confused.

2. **`stalkTensorLinearMap` (stage (iii) primary delivery, this iter's principal new declaration) has no standalone `\lean{...}`-pinned blueprint block.** It is named in prose and in NOTE comments, but not given its own lemma label. Given that `stalkTensorDesc` (stages i–ii) has `lem:stalk_tensor_desc_forward`, the stage (iii) advancement deserves a parallel `lem:stalk_tensor_linearmap` block. Without it, the `sync_leanok` phase has nothing to mark when stage (iii) is definitively closed, and a prover working from the blueprint cannot navigate directly to the stage (iii) target.

**Minor (1 finding)**:

3. `stalkTensorLinearMap_germ_tmul` (@[simp] germ characterisation for the linear packaging) is unmentioned by name in the blueprint. It is a helper but a useful one for the stage (v) inversion; noting it in a future `lem:stalk_tensor_linearmap` block would aid the stage (v) prover.

---

**Overall verdict**: The four new stage-(iii) declarations are axiom-clean, proof-complete, and their mathematical content faithfully matches the blueprint prose — the Lean side is sound. Two major blueprint-side actions are needed: create a `lem:stalk_tensor_linearmap` block for `stalkTensorLinearMap`, and resolve the forward-pointing `\lean{stalkTensorIso}` pin on `lem:stalk_tensor_commutation`. — 10 declarations checked, 0 red flags (code), 2 major blueprint-side gaps.
