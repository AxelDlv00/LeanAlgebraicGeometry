# Blueprint-writer directive — bw253b (progress-critic CHURNING corrective)

## Chapter to edit (ONLY this file)
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

## Single task
**Expand the PROOF of the helper lemma `lem:sheafify_tensor_unit_iso_natural`**
(`\lean{AlgebraicGeometry.Scheme.Modules.sheafifyTensorUnitIso_hom_natural}`), which the prior writer
(bw253) added this iter as a statement-only stub. The progress-critic flagged that "mechanical
bookkeeping remains" is not a prover-executable specification: the chapter must carry the explicit
element-level argument so the next prover executes rather than re-derives. You are adding a
`\begin{proof}...\end{proof}` (mathematical prose, textbook level) to that lemma block.

## The mathematics to write (this is the proof of the fourth D1′ square at the helper level)

`sheafifyTensorUnitIso` is the unit/tensor reconciliation natural iso used to build the sheaf-level
comparison `pullbackTensorMap` (`lem:pullback_tensor_map`). Its naturality square in the two module
arguments is verified by descending TWICE and then checking a bilinear identity on pure tensors:

1. **Descend to sections.** By extensionality of presheaf-of-modules morphisms, the square commutes
   iff it commutes componentwise over each open `U` — an equality of `\mathcal{O}_X(U)`-linear maps
   out of `(M \otimes_X N)(U)`.

2. **Descend to elements.** By extensionality of `\ModuleCat`-morphisms, two `\mathcal{O}_X(U)`-linear
   maps out of `(M \otimes_X N)(U)` agree iff they agree on every element. Because both composites are
   `\mathcal{O}_X(U)`-linear (in particular additive), it suffices to check agreement on the
   generating **pure tensors** `m \otimes n` (`m \in M(U)`, `n \in N(U)`): the zero element and
   additivity (sums of pure tensors) cases are formal — both composites send `0 \mapsto 0` and respect
   addition — so by the universal property of the tensor product (`TensorProduct` induction on the
   element) the pure-tensor case suffices.

3. **The pure-tensor identity is the conjunction of two single-argument unit-naturalities.** On a pure
   tensor `m \otimes n`, the comparison's value factors as the tensor of the two single-argument legs.
   The square therefore reduces to the two independent naturality squares of the **sheafification unit**
   `\eta` (the unit `\mathbf{1} \Rightarrow (\text{sheafify})\circ(\text{inclusion})` of the
   sheafification adjunction), one per tensor argument:
   - first argument, evaluated at `m`:
     `\eta_{M'} \circ (\text{sheafify of the induced map}) = (\text{the induced map}) \circ \eta_M`;
   - second argument, evaluated at `n`: the analogous identity.
   Each holds simply because `\eta` is a natural transformation (its naturality square commutes by
   definition). Tensoring the two evaluated identities gives the pure-tensor equality; bilinearity
   (step 2) extends it to all of `(M \otimes_X N)(U)`, proving the square.

## Lean signposts (acceptable as "the formalization proceeds via …" pointers — NOT tactic strings)
You may name, as landmarks (no tactic blocks, no `simp only [...]`/`erw [...]` fragments):
- `PresheafOfModules.Hom.ext` (step 1 descent), `ModuleCat.hom_ext` + `TensorProduct` induction
  (step 2 descent), the sheafification-unit naturality `\eta = (\text{sheafificationAdjunction}).\text{unit}`
  (step 3), and that the identity-restriction strip `restrictScalarsId_map` reconciles the carrier
  spelling before reading off the unit naturality. Keep these to brief parenthetical pointers; the body
  is mathematical prose.

## Constraints
- This is Archon-bespoke formalization engineering — **no `% SOURCE:` / `% SOURCE QUOTE:` lines**.
- **Do NOT touch `\leanok`/`\mathlibok` markers** (sync owns `\leanok`; review owns `\mathlibok`).
- Edit ONLY the `lem:sheafify_tensor_unit_iso_natural` block (add its proof). Do not touch any other
  block, including the parent `lem:pullback_tensor_map_natural` (bw253 already corrected its sketch to
  cross-reference this helper).
- Keep the proof's `\uses{}` honest: it depends on `lem:sheafify_tensor_unit_iso` (the iso being shown
  natural) / the sheafification unit; do not introduce a cycle by `\uses`-ing the parent D1′ lemma.

## Report
Confirm the proof body added to `lem:sheafify_tensor_unit_iso_natural`, that it is math-pure (no tactic
strings), and that no markers were touched.
