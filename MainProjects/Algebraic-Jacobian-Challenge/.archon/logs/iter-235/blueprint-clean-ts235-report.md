# Blueprint-clean report — iter-235 (ts235)

**Chapter:** `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`
**New block:** `lem:stalk_tensor_linear_map` (inserted ~line 2038, between
`lem:stalk_tensor_desc_forward` and `lem:islocallyinjective_whiskerleft_via_stalk`)

---

## Findings

### 1. No `\leanok` / `\mathlibok` — PASS

Confirmed: the new block carries neither marker. No accidental
`\leanok` was present in the file as submitted; the writer's note that it
was removed is correct in outcome.

### 2. Lean leakage — FOUND AND FIXED

The last sentence of the new lemma's prose (original lines 2060-2063)
named two internal Lean helper declarations in `\mathtt{...}` inline
math:
- `\(\mathtt{stalkTensorDescU\_smul}\)` — a helper `smul`-bridge lemma,
  not pinned in the blueprint with a `\lean{}` statement.
- `\(\mathtt{stalkTensorLinearMap\_germ\_tmul}\)` — a helper germ
  characterisation lemma, likewise unpinned.

These are Lean implementation details that are not declared blueprint
objects, and naming them inline constitutes Lean leakage. The sentence
also contained "CommRingCat/RingCat carrier-duality bridge", which
refers to the Lean type-system distinction rather than a mathematical
concept.

**Fix applied:** The sentence "The linearity check passes through the
CommRingCat/RingCat carrier-duality bridge … used downstream in the
stage-(v) inversion check." was removed. The mathematical content it
described (germ-tensor characterisation) is already captured by the
displayed equation immediately preceding it; the stage-context sentence
("This is the stage-(iii) landing … direct input to stage (iv)") was
retained.

### 3. SOURCE QUOTE on `lem:stalk_tensor_commutation` — INTACT

Verbatim Stacks SOURCE QUOTE at lines 1870-1883 (the
`lemma-stalk-tensor-product` verbatim block) is byte-intact and was not
touched by the edit.

### 4. `% NOTE:` annotations on `stalkTensorIso` pin — INTACT

The pre-existing build-state NOTE comments at lines 1854-1865 on the
`lem:stalk_tensor_commutation` block (covering the stage status, the
absent `\leanok`, and the helper ladder) were not modified.

### 5. No new citation gaps

The new block is correctly Archon-original (no `% SOURCE` is required or
expected). No reference-retriever spawn was needed.

---

## Summary of edits

| Change | Location | Action |
|--------|----------|--------|
| Remove Lean-leaking last sentence of `lem:stalk_tensor_linear_map` prose | lines 2060-2063 (old) | Deleted |

Net file delta: 5 lines removed. No other edits.

**Outcome: PASS — chapter is blueprint-pure.**
