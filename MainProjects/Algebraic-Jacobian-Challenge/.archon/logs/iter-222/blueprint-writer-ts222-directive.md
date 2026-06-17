# Blueprint-writer directive — iter-222 — chapter `Picard_TensorObjSubstrate.tex`

## Scope (narrow — one block only)

Enrich the proof-side guidance of the lemma block `lem:internal_hom_eval` (the
evaluation/contraction `ev_M : M ⊗_R M^∨ → R`) in
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (currently lines ~2608–2655).
Do NOT touch any other block. Do NOT change the lemma *statement* or its `\lean{}` pin
(`\lean{PresheafOfModules.internalHomEval}` is the correct future target name and must stay).
Do NOT add or remove `\leanok`/`\mathlibok` markers.

## Why (the gap a per-file checker flagged)

The block's statement and `\lean{}` pin are correct, but the proof prose does not record
two things the formalization clearly needs, and that the iter-221 prover round established:

1. **The per-object piece is already in hand.** The contraction has already been built
   open-by-open as the Lean declaration `PresheafOfModules.internalHomEvalApp` (the
   `R(U)`-bilinear map `(M|_U) ⊗_{R(U)} (M|_U → R|_U) → R(U)`, `s ⊗ φ ↦ φ(s)`), together with
   supporting lemmas `evalLin`, `evalLin_add`, `evalLin_smul`. The ONLY remaining work to
   produce `internalHomEval` is assembling these per-object maps into a morphism of presheaves
   of modules by discharging the **naturality** square.

2. **The naturality square is a known, structural coherence step, not new mathematics.** It
   reduces to the identity `φ(s)|_V = (φ|_V)(s|_V)` (evaluate-then-restrict = restrict-both-
   then-evaluate). At the Lean level this is `PresheafOfModules.naturality_apply` applied to
   the restriction morphism, modulo the *same* `Over.map` pseudofunctor-coherence identifications
   (`map_id`/`map_comp` are propositional, not definitional) that the restriction-map block
   `lem:presheaf_internal_hom_restriction` already crossed: the restriction of `φ` inside
   `dual M` is defined through `Over.map`, so `(dual M).map f φ` is the further restriction of
   `φ`, and the naturality square commutes by functoriality of that further restriction.

## What to write

Add to the `lem:internal_hom_eval` block (you choose the cleanest LaTeX placement — a short
paragraph appended to the proof body, plus a one-line `% NOTE:` comment near the `\lean{}` pin):

- A `% NOTE:` comment, immediately after the `\lean{PresheafOfModules.internalHomEval}` line,
  recording that the per-object building block `PresheafOfModules.internalHomEvalApp` (the
  bilinear contraction over each open) is already built, so the remaining obligation for
  `internalHomEval` is exactly the naturality/assembly step, and `internalHomEval` is the
  correct future target name.

- In the proof body (after the existing sentence about `φ(s)|_V = (φ|_V)(s|_V)`), one or two
  sentences making the assembly explicit in project notation: the morphism is obtained as
  `Hom.mk` with app-component the per-open contraction; the naturality square reduces to the
  evaluate/restrict-commutation identity above, which holds because the restriction of a
  functional inside the dual is its further restriction along `Over.map` and further restriction
  is functorial — the same coherence pattern already used to make the internal-hom restriction
  maps functorial in `lem:presheaf_internal_hom_restriction`. Keep it mathematical prose; NO
  Lean tactic strings, NO declaration names beyond the `\mathtt{...}`-style object names already
  used in the chapter and the `% NOTE:` cross-reference.

## Out of scope (do NOT do)

- Do NOT modify `def:presheaf_dual`, `lem:internal_hom_isSheaf`, `lem:dual_isLocallyTrivial`,
  `rem:dual_discharges_inverse`, or any earlier/later block.
- Do NOT split or re-pin `lem:internal_hom_isSheaf` (the sub-step-4 split is deferred to a later
  iter; not this one).
- Do NOT add new `\begin{lemma}` blocks for the helpers — they are correctly unblueprinted
  helpers; only the `% NOTE:` cross-reference is wanted.
- Citation discipline: the existing `% SOURCE`/`% SOURCE QUOTE` lines are correct (Stacks
  "Modules on Ringed Spaces", §Internal Hom, tag area 01CM) — leave them; you are only adding
  proof-side assembly prose + the `% NOTE:`. No new source needed (references/** authorized only
  as a safety net).
