# Lean ↔ Blueprint Check Report

## Slug
stalktensor

## Iteration
233

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate/StalkTensor.lean`
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`, §`sec:tensorobj_stalk_tensor`

---

## Per-declaration

### `\lean{PresheafOfModules.stalkTensorIso}` (chapter: `\lem:stalk_tensor_commutation`)
- **Lean target exists**: **no** — `PresheafOfModules.stalkTensorIso` is entirely absent from
  `StalkTensor.lean`. The file instead contains the building-block forward map
  `stalkTensorDesc` and supporting lemmas, none of which bears the pinned name.
- **Signature matches**: N/A (target absent).
- **Proof follows sketch**: N/A (target absent).
- **notes**: The blueprint block has a `% NOTE (iter-233)` annotation (lines 1823–1829)
  explicitly documenting this: the block is intentionally unmarked (no `\leanok`), and the
  annotation accurately states that only the forward comparison map is formalized. The gap is
  tracked; no `\leanok` is claimed. This is managed absence, not a missed formalization.

---

## Unreferenced declarations (informational)

The Lean file contains seven declarations not referenced by any `\lean{...}` in the blueprint:

| Declaration | Kind | Concern |
|---|---|---|
| `stalkTensorBilin` | def | Building block for `stalkTensorDescU`; deserves a blueprint sub-entry (see adequacy) |
| `stalkTensorBilin_balanced` | lemma | Helper; may warrant a blueprint mention |
| `stalkTensorDescU` | def | Per-neighborhood map; the proof sketch names nothing at this level |
| `stalkTensorDescU_tmul` | simp lemma | Computational unfolding; helper |
| `stalkTensorDesc` | def | **Substantive** — the forward comparison map. The proof sketch references this concept but pins only the final `stalkTensorIso`. Deserves its own `\lean{}` entry or at minimum a named sub-step in the proof sketch. |
| `germ_stalkTensorDesc` | lemma | Colimit-ι factorization; deserves a blueprint mention |
| `stalkTensorDesc_germ_tmul` | simp lemma | Germ characterization; key computational lemma worth naming in the blueprint |

The most notable unreferenced declaration is `stalkTensorDesc` — the forward comparison map
`(A ⊗ᵖ B).stalk x ⟶ A_x ⊗_{R_x} B_x`. It is the deliverable of this iteration and does not
appear under any `\lean{...}` pin in the blueprint. A second `\lean{}` entry for
`PresheafOfModules.stalkTensorDesc` (marked partial / scaffold) would make the chapter's
coverage of the in-progress work machine-readable.

---

## Red flags

### Placeholder / suspect bodies
None. All seven declarations are axiom-clean (no `:= sorry`, no suspect bodies).

### Excuse-comments
None. The file header note ("The full isomorphism `PresheafOfModules.stalkTensorIso`
additionally requires …") is an accurate, non-excusing handoff description, not an
excuse-comment.

### Axioms / Classical.choice on non-trivial claims
None.

---

## Special question (a): Is the blueprint block adequately detailed to guide building the full iso?

**Verdict: under-specified for the remaining engineering steps.**

The proof sketch (lines 1865–1891) correctly identifies the key idea — the stalk is a
filtered colimit over neighbourhoods, the tensor product commutes with filtered colimits,
and the ground ring colimits to the stalk ring — and correctly cites `lem:stalk_linear_map`
(d.1) as the ingredient. This is mathematically complete at the informal-math level.

However, the sketch is inadequate as engineering guidance for the three remaining steps
the NOTE identifies:

1. **R_x-linearity of `stalkTensorDescU`** (`stalkTensorDescU_smul`): The blueprint does
   not describe the CommRingCat/RingCat carrier-duality obstacle. The current `stalkTensorDescU`
   lands in `AddCommGrpCat.of Tgt` (abelian-group morphism), and upgrading it to an `R_x`-linear
   map requires plumbing between the `R.obj (op U)` action on sections and the `R.stalk x`
   action on the target. The proof sketch says nothing about this.

2. **Reverse map construction**: The sketch says "the canonical map
   `A_x ⊗_{R_x} B_x → (A ⊗ᵖ B)_x` is an isomorphism" — but it does not describe how to
   build this map in Lean. It should be built from the universal property of the tensor product
   (or from `stalk_linear_map`) as a nested colimit descent, but neither strategy is spelled
   out. Note also that the sketch describes the map in the **opposite direction** from the
   Lean-side `stalkTensorDesc`: the sketch calls `A_x ⊗ B_x → (A ⊗ B)_x` the "canonical"
   one (from d.1/stalk maps), while the Lean builds `(A ⊗ B)_x → A_x ⊗ B_x` as the
   "forward" map. Both directions are part of the same iso, but the directional asymmetry
   could confuse a prover approaching the reverse-map step.

3. **Bijectivity / inversion argument**: The sketch asserts isomorphism by a
   "tensor of filtered colimits over the colimit ring" identification but does not name
   the Lean/Mathlib lemmas that close this. In particular, Mathlib's API for
   "tensor product commutes with filtered colimits over the colimit ring" in the
   varying-ring setting is absent (this is exactly why d.2 is the Mathlib-absent
   ingredient), so a prover cannot simply cite `TensorProduct.filteredColimit_comm`.

**Recommended additions to the proof sketch:**
- Name the sub-steps: (i) `stalkTensorDesc` (forward additive map, done), (ii)
  `stalkTensorDescU_smul` (R_x-linearity, needed), (iii) reverse map via the
  universal property of `A_x ⊗_{R_x} B_x` as a Lean colimit, (iv) mutual inversion
  on germs.
- Clarify which direction is built first and why.
- Note the CommRingCat/RingCat carrier-duality obstacle on the linearity step.

---

## Special question (b): Does the Lean faithfully implement the forward half?

**Verdict: yes, with one minor typing note.**

The Lean file constructs `stalkTensorDesc : (Monoidal.tensorObj A B).presheaf.stalk x ⟶ AddCommGrpCat.of Tgt`
via a two-level construction:
1. Per-neighborhood bilinear map `stalkTensorBilin` → descended via `TensorProduct.liftAddHom`
   to `stalkTensorDescU` at the section level.
2. Colimit descent to the stalk via `colimit.desc` with naturality verified by
   `tensorObj_map_tmul` + `germ_res_apply`.

This matches the mathematical content of the blueprint's proof sketch: the canonical map
is built from the germ maps (blueprint's "stalk comparison from `lem:stalk_linear_map`"), and
it factors through the sectionwise tensor. The computation `stalkTensorDesc_germ_tmul`
(germ of a ⊗ b maps to germ a ⊗ germ b) correctly captures the universal-property
characterization.

**Minor typing note**: `stalkTensorDesc` lands in `AddCommGrpCat.of Tgt` (abelian group
morphism), not in an `R_x`-linear map. This is intentional and correctly described in the
file header: the R_x-linear packaging is the remaining step. It is not a mismatch with the
blueprint since the blueprint doesn't pin a declaration for the additive-map stage.

**No signature mismatch** on the pinned declaration (since it doesn't exist yet and the
block is unmarked).

---

## Special question (c): Is the `% NOTE (iter-233)` annotation accurate?

**Verdict: yes, substantially accurate.**

The annotation at lines 1823–1829 states:
- "only the FORWARD comparison map is formalized so far, `PresheafOfModules.stalkTensorDesc : (A ⊗ᵖ B).stalk x ⟶ A_x ⊗_{R_x} B_x` (axiom-clean, with germ characterisations ...)" — **correct**.
- "The pinned full iso `stalkTensorIso` does NOT yet exist" — **correct**.
- "blocked on `stalkTensorDescU_smul` (CommRingCat/RingCat carrier-duality plumbing) ⟹ `R_x`-linear map ⟹ a reverse map via nested colimit descent (~150–250 LOC)" — **correct** as a blocking chain identification; the LOC estimate is plausible.
- "Hence this block stays unmarked" — **correct**; the block has no `\leanok`.

One small imprecision: the annotation says `stalkTensorDesc : (A ⊗ᵖ B).stalk x ⟶ A_x ⊗_{R_x} B_x`
but the actual Lean type is `⟶ AddCommGrpCat.of Tgt`, not an `R_x`-linear map. This is a
minor description slip (the additive-group codomain vs. the module target), but it does not
mislead in a harmful way since the NOTE itself lists `stalkTensorDescU_smul` as the next
step (i.e., the upgrade to R_x-linear is explicitly flagged as missing).

---

## Blueprint adequacy for this file

- **Coverage**: 0/7 Lean declarations have a `\lean{...}` block in the chapter. However, 6 of
  the 7 are appropriately helper-level (bilin, balanced, descU, descU_tmul, germ_desc,
  desc_germ_tmul). The one substantive declaration `stalkTensorDesc` deserves a named
  `\lean{...}` sub-entry or at minimum a proof-sketch sub-step label.
- **Proof-sketch depth**: **under-specified** — the informal argument is correct but the
  remaining engineering sub-steps (R_x-linearity, reverse map, inversion) are unnamed.
- **Hint precision**: **loose** — the only `\lean{}` hint pins the complete iso
  `stalkTensorIso` (absent), with no intermediate pin for the forward map `stalkTensorDesc`
  (present and axiom-clean). A prover approaching this file fresh would not know whether
  to build a one-shot iso or a staged construction.
- **Generality**: matches need (both the blueprint and Lean work in full generality over
  `PresheafOfModules`, not just over schemes).

**Recommended chapter-side actions** (for a blueprint-writing subagent):
1. Add a named sub-step or separate `\lean{PresheafOfModules.stalkTensorDesc}` entry
   (marked with a partial annotation) pinning the forward additive comparison map.
2. Expand the proof sketch with named sub-steps: (i) per-neighborhood bilinear map, (ii)
   descent to section-level map, (iii) R_x-linearity packaging, (iv) reverse map via
   universal property / colimit descent, (v) mutual inversion on germs.
3. Clarify the direction convention (which direction is "forward" vs. "reverse") to avoid
   the current ambiguity where the sketch calls the A_x ⊗ B_x → (A ⊗ B)_x direction
   "canonical" while the Lean builds the other direction first.
4. Note the CommRingCat/RingCat carrier-duality obstacle on step (iii) so future provers
   can anticipate it.

---

## Severity summary

- **major**: The pinned `\lean{PresheafOfModules.stalkTensorIso}` declaration is absent from
  the Lean file. Correctly tracked by the NOTE and block left unmarked; not a silent failure,
  but the chapter's sole `\lean{...}` pin remains unformalized.
- **major**: Blueprint proof sketch is under-specified for the remaining engineering steps
  (R_x-linearity, reverse map, inversion). A prover starting from the sketch would have
  insufficient guidance for steps (iii)–(v).
- **minor**: `stalkTensorDesc` (the forward map, the iteration's deliverable) has no `\lean{}`
  pin in the blueprint, making the in-progress partial formalization invisible to tooling.
- **minor**: Direction convention in the proof sketch (A_x ⊗ B_x → (A ⊗ B)_x called
  "canonical") conflicts with Lean's choice of "forward" direction.

**No must-fix-this-iter findings**: the NOTE annotation is accurate, the block is correctly
unmarked, all present declarations are axiom-clean, and the gap is managed, not hidden.

**Overall verdict**: The Lean forward-map construction is faithful to the blueprint intent
and axiom-clean; the sole `\lean{...}` target (`stalkTensorIso`) is correctly absent and
documented as partial; the blueprint proof sketch is under-specified for completing the
remaining reverse-map and iso-bundling steps — **2 major, 2 minor findings, 0 must-fix-this-iter**.
