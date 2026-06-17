# Lean ↔ Blueprint Check Report

## Slug
stalktensor-ts236

## Iteration
236

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate/StalkTensor.lean`
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (§ `sec:tensorobj_stalk_tensor`)

---

## Per-declaration

### `\lean{PresheafOfModules.stalkTensorIso}` (chapter: `\thm:stalk_tensor_commutation`)

- **Lean target exists**: yes (`noncomputable def stalkTensorIso`, line 505)
- **Signature matches**: yes — the Lean declaration is

  ```lean
  noncomputable def stalkTensorIso :
      (↑(TopCat.Presheaf.stalk (Monoidal.tensorObj A B).presheaf x) : Type u)
        ≃ₗ[↑(R.stalk x)] Tgt
  ```

  where `Tgt = TensorProduct ↑(R.stalk x) ↑(stalk A.presheaf x) ↑(stalk B.presheaf x)`.
  This is exactly an `R.stalk x`-linear equivalence `(A ⊗ᵖ B).stalk x ≃ A.stalk x ⊗_{R.stalk x} B.stalk x`.
  The blueprint statement (§ `lem:stalk_tensor_commutation`) says: "canonical isomorphism of
  `(R ∘ forget_2).stalk x`-modules" between those two objects.  The scalar ring in the Lean
  `≃ₗ` is `R.stalk x` (the CommRingCat stalk); the blueprint prose says `R.stalk x` in the
  narrative and `(R ∘ forget_2).stalk x` in the formal statement — these are the same type
  after the forget₂ coercion, consistent with the variable declaration
  `A B : PresheafOfModules.{u} (R ⋙ forget₂ _ _)`.  No mismatch.

- **Proof follows sketch**: yes — the five stages described in the blueprint proof match the
  Lean construction precisely:
  - Stage (i): `stalkTensorBilin` (lines 66–73) + `stalkTensorBilin_balanced` (lines 77–84) ✓
  - Stage (ii): `stalkTensorDescU` (lines 89–92), `stalkTensorDesc` (lines 133–151) +
    `stalkTensorDesc_germ_tmul` (lines 163–171) ✓
  - Stage (iii): `stalkTensorLinearMap` (lines 188–213) using `germ_smul` +
    `stalkTensorDescU_smul` (lines 109–130) to handle the CommRingCat/RingCat carrier wall ✓
  - Stage (iv): nested colimit descent `revInnerLeg`/`revInner`/`revOuterLeg`/`revBihom`
    (lines 232–453), with `revBihom_balanced` proved at stalk level (not section level) exactly
    as the blueprint warns (lines 427–453) ✓
  - Stage (v): `stalkTensorIso.left_inv` / `.right_inv` (lines 512–540) via
    `TensorProduct.induction_on` on germ generators ✓

- **notes**:
  - Axiom check for `PresheafOfModules.stalkTensorIso` returns
    `{propext, Classical.choice, Quot.sound}` — standard Lean axioms only, no extra sorry-axiom.
    The declaration is fully axiom-clean.
  - The blueprint's `% NOTE (iter-236)` comment at line 1854 correctly records this status.
  - The statement block of `lem:stalk_tensor_commutation` does **not** carry a `\leanok` marker
    (even though the declaration exists and is sorry-free). The proof block at line 1898 **does**
    carry `\leanok`. This inconsistency is a pending `sync_leanok` gap — see Minor findings below.

---

### `\lean{PresheafOfModules.stalkTensorDesc}` (chapter: `\lem:stalk_tensor_desc_forward`)

- **Lean target exists**: yes (`noncomputable def stalkTensorDesc`, line 133)
- **Signature matches**: yes — `stalk (Monoidal.tensorObj A B).presheaf x ⟶ AddCommGrpCat.of Tgt`
  (additive map to `A.stalk x ⊗_{R.stalk x} B.stalk x`). Blueprint says "canonical natural
  additive comparison map" with germ characterisation `germ(a ⊗ b) ↦ germ a ⊗ germ b`. ✓
- **Proof follows sketch**: N/A — blueprint does not give a separate proof body for this partial
  lemma; the construction follows from the colimit cocone construction in `stalkTensorIso`.
- **notes**: Blueprint statement block has `\leanok` (consistent); proof block also `\leanok`. ✓

---

### `\lean{PresheafOfModules.stalkTensorLinearMap}` (chapter: `\lem:stalk_tensor_linear_map`)

- **Lean target exists**: yes (`noncomputable def stalkTensorLinearMap`, line 188)
- **Signature matches**: yes —
  `(stalk (Monoidal.tensorObj A B).presheaf x : Type u) →ₗ[↑(R.stalk x)] Tgt`.
  Blueprint says "`R.stalk x`-linear map" upgrading `stalkTensorDesc`. ✓
- **Proof follows sketch**: N/A — no separate proof body in blueprint; proof is inline.
- **notes**: Blueprint has `\leanok` on both statement and proof blocks. ✓

---

## Red flags

*None.*

No `sorry` bodies anywhere in the file. No `:= True`, `:= rfl` on non-trivial claims,
no `axiom` declarations, no excuse-comments (`-- TODO replace`, `-- temporary`, `-- wrong`).
All `axiom` usage belongs to the Lean kernel axioms `{propext, Classical.choice, Quot.sound}`.

---

## Unreferenced declarations (informational)

The following public declarations have no `\lean{...}` pin in the blueprint chapter:

| Declaration | Lines | Nature |
|---|---|---|
| `stalkTensorBilin` | 66 | Building block for `stalkTensorDescU`; named in proof narrative |
| `stalkTensorBilin_balanced` | 77 | Balancing lemma; used internally |
| `stalkTensorDescU` | 89 | Per-neighbourhood descent; named in proof narrative (stage i) |
| `stalkTensorDescU_tmul` | 94 | @simp characterisation; helper |
| `stalkTensorDescU_smul` | 109 | Scalar compatibility; named in step (iii) narrative |
| `germ_stalkTensorDesc` | 156 | Factorisation lemma; used in proofs |
| `stalkTensorDesc_germ_tmul` | 163 | @simp germ characterisation; named in proof narrative (steps ii, v) |
| `stalkTensorDesc_germ` | 175 | Element form of above; helper |
| `stalkTensorLinearMap_germ_tmul` | 218 | @simp germ characterisation; helper |
| **`stalkTensorRev`** | **459** | **Public reverse map; described in stage (iv) narrative but not pinned** |
| `stalkTensorRev_germ_tmul` | 465 | Germ characterisation of reverse map; used in `stalkTensorIso` |

Declarations marked `private` (lines 232–496: `revInnerLeg`, `revInner`, `revOuterLeg`,
`revBihom`, `revBihom_balanced_germ`, `revBihom_balanced`, `germ_tensorObj_map_tmul`, and
their helpers) are correctly private and do not need blueprint pins.

`stalkTensorRev` is the most notable: it is public, non-trivial, directly consumed by
`stalkTensorIso`, and fully described in the stage-(iv) prose. A dedicated `\lean{...}` pin
would improve chapter completeness.

---

## Blueprint adequacy for this file

- **Coverage**: 3/3 primary Lean declarations have `\lean{...}` pins
  (`stalkTensorIso`, `stalkTensorDesc`, `stalkTensorLinearMap`).
  Unreferenced: ~8 helper lemmas (acceptable as named internals), 1 substantive public
  declaration (`stalkTensorRev`, see above).

- **Proof-sketch depth**: **adequate**. The blueprint's five-stage proof sketch is unusually
  detailed: it names exact Lean declarations at each stage, explicitly warns about the
  wrong approach for stage (iv) balancing (section-level vs. stalk-level), identifies the
  CommRingCat/RingCat carrier-duality obstacle and its resolution, and describes the exact
  germ-generator checking strategy for stage (v). A prover following only the blueprint would
  arrive at the Lean construction as written.

- **Hint precision**: **precise**. All three `\lean{...}` hints name the correct declarations
  with matching namespaces. No predicate ambiguity.

- **Generality**: **matches need**. The blueprint correctly scopes the result to
  `PresheafOfModules (R ⋙ forget₂ _ _)` over a topological space, which is exactly the
  project setting for the structure presheaf.

- **Recommended chapter-side actions**:
  - Add a `\begin{lemma}...\lean{PresheafOfModules.stalkTensorRev}...\end{lemma}` block
    documenting the reverse map's type and germ characterisation (currently only described in
    the proof narrative). **Minor** — not blocking.
  - Once `sync_leanok` runs, the statement block of `lem:stalk_tensor_commutation` will
    receive its `\leanok` marker. No agent action needed.
  - The `% NOTE (iter-236)` comment in the statement block of `lem:stalk_tensor_commutation`
    records the axiom-clean status accurately; the review agent may leave or consolidate it.

---

## Severity summary

### Minor

1. **Missing `\leanok` on statement block of `lem:stalk_tensor_commutation`** (line 1850).
   The proof block carries `\leanok` and the Lean declaration is axiom-clean, but the statement
   block has no marker. This is a `sync_leanok` pending gap, not a code defect — `sync_leanok`
   will add it on next run. No agent should touch `\leanok` directly.

2. **`stalkTensorRev` (public, non-trivial, line 459) has no blueprint pin.** The reverse map
   is substantive and named in the proof narrative but lacks a dedicated `\begin{lemma}...\lean{...}` block. Low-impact since it is fully described in the prose.

3. **Several public germ-characterisation lemmas** (`stalkTensorDesc_germ_tmul`,
   `stalkTensorLinearMap_germ_tmul`, `stalkTensorRev_germ_tmul`) are not blueprint-pinned.
   These are @simp lemmas used in the `stalkTensorIso` proof; promoting them to blueprint
   blocks would improve traceability.

### No must-fix or major findings.

**Overall verdict**: PASS — `PresheafOfModules.stalkTensorIso` is axiom-clean (`{propext,
Classical.choice, Quot.sound}`) with type exactly matching the blueprint statement
(`R.stalk x`-linear equivalence `(A ⊗ᵖ B).stalk x ≃ A.stalk x ⊗_{R.stalk x} B.stalk x`),
not a fake/placeholder, with proof following the blueprint's five-stage sketch; all three
blueprint-pinned declarations exist and have correct signatures; 3 minor findings, 0 blocking.
