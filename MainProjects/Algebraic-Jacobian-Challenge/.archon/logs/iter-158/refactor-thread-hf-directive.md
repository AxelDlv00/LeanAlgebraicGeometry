# Refactor directive — thread the collapse hypothesis `_hf` through the Rigidity-Lemma helpers

## File (sole write domain)
`AlgebraicJacobian/AbelianVarietyRigidity.lean`

## Background (why this refactor)
The iter-157 prover landed `rigidity_lemma` as "proven modulo one geometric sorry",
but TWO independent review subagents (`lean-auditor`, `lean-vs-blueprint-checker`)
found the decomposition **UNSOUND**. The two helper lemmas it delegates to —
`rigidity_eqOn_dense_open` (currently L81) and `rigidity_core` (L147) — **dropped the
collapse hypothesis** and are **FALSE as stated**:

- Counterexample (refutes both as written): `X = Y = Z = ℙ¹`-proxy over `kbar`,
  `f := fst : X ⊗ Y ⟶ X = Z`. All four instances (`IsProper X.hom`,
  `GeometricallyIrreducible (X⊗Y).hom`, `IsReduced (X⊗Y).left`, `IsSeparated Z.hom`)
  hold, yet `f = fst` is NOT independent of the `X`-coordinate, so
  `f = lift (toUnit (X⊗Y) ≫ x₀) (snd X Y) ≫ f` is false and there is no non-empty open
  of agreement. Mumford's Rigidity Lemma is simply false without the rigidifying
  hypothesis `f(X × {y₀}) = {z₀}`.

`rigidity_lemma`'s own conclusion `∃ g, f = snd ≫ g` IS true (it carries `y₀ z₀ _hf`),
but its proof **never consumes `_hf`** — the laundering tell. The genuine geometric
content (Mumford: "`y₀ ∉ G` *because* `f(X×{y₀}) = {z₀} ⊆ U`", making `V := Y∖G`
non-empty) was dropped when `_hf` was dropped.

## The fix (signature refactor — thread `_hf`; do NOT fill proofs)

The collapse data is, verbatim from `rigidity_lemma`'s current signature (L233–235):

```
    (y₀ : 𝟙_ (Over (Spec (.of kbar))) ⟶ Y)
    (z₀ : 𝟙_ (Over (Spec (.of kbar))) ⟶ Z)
    (_hf : lift (𝟙 X) (toUnit X ≫ y₀) ≫ f = toUnit X ≫ z₀)
```

Make exactly these three edits:

1. **`rigidity_eqOn_dense_open` (L81).** Add `y₀`, `z₀`, `_hf` (the three above) to its
   hypotheses, AFTER `(f : (X ⊗ Y) ⟶ Z)` and `(x₀ : … ⟶ X)`. Also bring its instance
   set up to the FULL set that `rigidity_core` carries — add
   `[GeometricallyIrreducible (X ⊗ Y).hom]`, `[IsReduced (X ⊗ Y).left]`,
   `[IsSeparated Z.hom]` alongside the existing `[IsProper X.hom]` — so the statement is
   true (adding instances + the collapse hypothesis only strengthens the antecedent,
   never makes a true statement false). The existential conclusion is unchanged. Body
   stays `sorry` (this is the genuine deferred geometry; do NOT attempt to prove it).

2. **`rigidity_core` (L147).** Add `y₀`, `z₀`, `_hf` to its hypotheses (same position,
   after `f` and `x₀`). In its PROOF, the call `rigidity_eqOn_dense_open f x₀` (≈L162)
   must now pass the threaded data: `rigidity_eqOn_dense_open f x₀ y₀ z₀ _hf` (match the
   argument order you chose in step 1). Everything else in the gluing proof
   (`irreducibleSpace_of_subsingleton`, `isDominant_ι`, `Over.OverMorphism.ext`,
   `ext_of_isDominant_of_isSeparated'`) is correct and stays verbatim.

3. **`rigidity_lemma` (L225).** Signature is ALREADY correct (it carries `y₀ z₀ _hf`) —
   do NOT change it. In its PROOF (L242), change `exact rigidity_core f x₀` to
   `exact rigidity_core f x₀ y₀ z₀ _hf` so `_hf` is genuinely consumed (this kills the
   dead-hypothesis lint). The rest of the proof (`refine ⟨…⟩; rw [← Category.assoc,
   rigidity_snd_lift]`) is correct and stays verbatim.

## Docstring hygiene (update the two re-signed lemmas)
The docstrings of `rigidity_eqOn_dense_open` and `rigidity_core` currently present the
dropped-`_hf` versions as "PROVEN modulo …" / "the sole remaining sorry" on a *false*
statement. Update them MINIMALLY to state that the lemma now carries the collapse
hypothesis `_hf : f(X × {y₀}) = {z₀}` (encoded `lift (𝟙 X) (toUnit X ≫ y₀) ≫ f =
toUnit X ≫ z₀`), which is exactly what makes Mumford's open `V := Y∖G` non-empty
(`y₀ ∉ G`). Keep them accurate and concise. Do NOT touch the docstrings of the three
deferred scaffolds (`morphism_P1_to_grpScheme_const`, `genusZero_curve_iso_P1`,
`rigidity_genus0_curve_to_grpScheme`). Do NOT edit any `.tex` file.

## Hard constraints
- `rigidity_eqOn_dense_open`, `rigidity_core`, `rigidity_lemma` are NOT in
  `archon-protected.yaml` — free to re-sign (verified by the plan agent).
- Do NOT fill the `rigidity_eqOn_dense_open` sorry; that is next iter's prover lane.
- Do NOT touch `rigidity_snd_lift` (sound, axiom-clean).
- No new axioms.

## Verification before you return
- `lake build` GREEN.
- Exactly four `sorry` in the file: `rigidity_eqOn_dense_open` (now honest, carries
  `_hf`) + the three known scaffolds. No new sorries elsewhere.
- `rigidity_lemma`'s proof now uses `_hf` (no dead-hypothesis warning on it).
- `lean_verify AlgebraicGeometry.rigidity_lemma` and `…rigidity_core` axiom set is
  `{propext, sorryAx, Classical.choice, Quot.sound}` (sorryAx only via the honest
  `rigidity_eqOn_dense_open`); `rigidity_snd_lift` stays `sorryAx`-free.

Report: the final signatures of the two re-signed lemmas, the build status, the axiom
check, and confirmation that `_hf` is consumed.
