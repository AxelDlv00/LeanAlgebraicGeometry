# Effort Breaker Report

## Slug
tq-rect2

## Target
`def:tautological_quotient` (Lean `AlgebraicGeometry.Grassmannian.tautologicalQuotient`),
chapter `Picard_GrassmannianQuot.tex` — the single remaining `sorry` is the
glueLift overlap-compatibility condition (GrassmannianQuot.lean:1973).

## Status
COMPLETE — the overlap gap is re-expressed as a 5-block `\uses`-linked chain, cut along
the prover's 4 seams. Every `\uses{}` resolves; all 5 new nodes appear in the DAG.

## Effort before → after
- target `effort_local`: unchanged at 1896 (it is a pinned Lean node carrying the `sorry`;
  its proof obligation is now *delegated* to `lem:gr_tautologicalQuotient_overlap`, which the
  prover formalizes instead — the target body becomes a `glueLift` call whose overlap field is
  that lemma). The decomposition moves the work off the monolithic `sorry`, not the node's
  raw token-effort score.
- sub-lemmas added: 5 (1 def + 4 lemmas).

## Chain added (target ← overlap ← {transpose, matrixEndRect API})
- `def:gr_matrixEndRect` `\lean{…matrixEndRect}` — rectangular `d×r` matrix homomorphism
  `O_S^r → O_S^d` (biproduct-assembled from `scalarEnd` entries); `u^I = matrixEndRect(X^I)`.
  (effort ≈ small; `\uses{def:gr_scalarEnd}`)
- `lem:gr_matrixEndRect_pullback` `\lean{…matrixEndRect_pullback}` — pullback-naturality
  `p^*(matrixEndRect M) = Q_d⁻¹ ∘ matrixEndRect(p♯M) ∘ Q_r`; same skeleton as the square
  `lem:gr_matrixEnd_pullback`, one `scalarEnd_pullback` per entry over two biproducts.
- `lem:gr_matrixEndRect_comp` `\lean{…matrixEndRect_comp}` — square-after-rectangular
  `matrixEndRect(M) ∘ matrixEnd(N) = matrixEndRect(N·M)` (order convention mirrors
  `lem:gr_matrixEnd_comp`: Lean `matrixEndRect M ≫ matrixEnd N = matrixEndRect (N * M)`).
- `lem:gr_tautologicalQuotientComponent_transpose`
  `\lean{…tautologicalQuotientComponent_transpose}` — adjunction transposition: the glueHom
  descent condition ⇔ pullback-level identity `g_{IJ} ∘ f_IJ^* u^I = (t_IJ ≫ f_JI)^* u^J`.
  `\uses{lem:gr_homEquiv_conjugateEquiv_app, lem:conjugateEquiv_pullbackComp_inv_mathlib,
  lem:gr_pullbackFreeIso, def:modules_pullbackComp, …}` — **wires the previously ISOLATED node
  `lem:gr_homEquiv_conjugateEquiv_app` into the chain** (directive requirement).
- `lem:gr_tautologicalQuotient_overlap` `\lean{…tautologicalQuotient_overlap}` — assembly
  lemma consuming pieces 1–3 + the Cells matrix core: transport both legs by
  `matrixEndRect_pullback`, collapse `g_{IJ} ∘ f_IJ^* u^I = matrixEndRect((X^I_J)⁻¹·X^I)` by
  `matrixEndRect_comp`, rewrite by `(X^I_J)⁻¹X^I = X^J`
  (`lem:gr_universalMatrix_map_transitionPreMap` / `lem:gr_imageMatrix_map_eq`, Cells chapter),
  match `(t_IJ ≫ f_JI)^* u^J`.
- Target `def:tautological_quotient`: `\uses{…, lem:gr_tautologicalQuotient_overlap}` added;
  prose now states the overlap field is `lem:gr_tautologicalQuotient_overlap` and routes the
  matrix identity through the rectangular API + transpose.

## Suggested forward `\lean{}` names (namespace `AlgebraicGeometry.Grassmannian`)
- `matrixEndRect`, `matrixEndRect_pullback`, `matrixEndRect_comp`,
  `tautologicalQuotientComponent_transpose`, `tautologicalQuotient_overlap`.
  All consistent with the existing square `matrixEnd*` API. None scaffolded yet — the plan
  agent should scaffold these 5 (keyword on the SAME line as the `.lean` filename, per the
  scaffold-keyword memo).

## Order-convention note for the prover
`matrixEnd_comp` is Lean `matrixEnd M ≫ matrixEnd N = matrixEnd (N * M)` (diagram order,
contravariant in the product). The rectangular analogue is therefore
`matrixEndRect M ≫ matrixEnd N = matrixEndRect (N * M)` (M : d×r, N : d×d, N*M : d×r).
`chartQuotientMap` is literally `matrixEndRect` of `universalMatrix` (same `biproduct.matrix
(fun i' p => scalarEnd (M p i'))` shape, just source-indexed by `Fin r`) — so piece 1's def
should be a copy of `chartQuotientMap`/`matrixEnd` with the source index set generalised, and
`chartQuotientMap = matrixEndRect (…universalMatrix…)` is a definitional/`rfl`-level bridge the
prover will want as a private helper.

## Still hard (re-break candidates)
- `lem:gr_tautologicalQuotient_overlap` (effort ≈ 1943) is the heaviest of the five — it is
  the assembly that threads the transpose + two pullback transports + the Cells rewrite. If the
  prover stalls, re-dispatch the breaker to split it further: (4a) the `g_{IJ} ∘ f_IJ^* u^I =
  matrixEndRect((X^I_J)⁻¹·X^I)` collapse, and (4b) the `(X^I_J)⁻¹X^I = X^J` rewrite + RHS-leg
  identification, as two named sub-lemmas. Left as one block for now since pieces 1–3 already
  carry the transport/composition machinery.

## Could not decompose (strategy items)
- None. The mathematics is conserved: every gap the original one-line `sorry` crossed
  (rectangular pullback, rectangular composition, adjunction transpose, matrix core) is covered
  by exactly one `L_i`.

## References consulted
- No external source reads needed — the math core is already cited in the target (Nitsure §1,
  quote present in the block). All new blocks are project-bespoke transport infrastructure and
  `\uses` the cited parents + the Cells matrix facts (no new `% SOURCE QUOTE:` required).

## Notes for dispatcher
- Cross-chapter `\uses` used and verified present: `lem:gr_universalMatrix_map_transitionPreMap`,
  `lem:gr_imageMatrix_map_eq`, `def:gr_universal_matrix` (Cells);
  `lem:conjugateEquiv_pullbackComp_inv_mathlib` (FlatBaseChange).
- LaTeX balance verified (def 16/16, lemma 40/40, proof 43/43).
- No new macros needed.
