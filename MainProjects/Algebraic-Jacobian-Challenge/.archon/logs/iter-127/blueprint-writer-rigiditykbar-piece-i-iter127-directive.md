# Blueprint Writer Directive

## Slug
rigiditykbar-piece-i-iter127

## Iter
127

## Chapter to edit
`blueprint/src/chapters/RigidityKbar.tex`

## Strategy context (the slice that matters)

The project is mid-execution on milestone M2 (the genus-stratified body decomposition of `nonempty_jacobianWitness`). Iter-127 strategic update: the iter-127 over-k analogist (`analogies/cotangent-vanishing-pile-over-k.md`) returned OK_OVER_K on all three active pieces of the shared cotangent-vanishing pile, **adopting the over-k variant**. M2.c (Galois descent of morphism equality) and M2.c.aux (`geomIrred.exists_kalg_pt`) are DROPPED, saving 7–13 iter / 500–900 LOC. The iter-126 scaffold's Lean signature is k-agnostic; only docstrings/variable names/blueprint prose need updating.

Iter-128 MUST dispatch a prover lane on a piece-(i) sub-lemma per the iter-126 progress-critic META-PATTERN TRIPWIRE (3 consecutive plan-phase-only iters at iter-127 would flip to CHURNING). iter-127 plan-agent committed to staging this target by dispatching a blueprint-writer this iter to add a prover-ready piece-(i) sub-lemma decomposition.

## Required edits to `RigidityKbar.tex`

You are extending `\section{The shared cotangent-vanishing Mathlib pile}` (label `sec:RigidityKbar_shared_pile`) — currently at lines 58–82 of the file — with a prover-ready sub-lemma decomposition of piece (i) (group-scheme cotangent triviality). The shape of the piece-(i) build is documented in `analogies/cotangent-vanishing-pile.md` (iter-126) and updated in `analogies/cotangent-vanishing-pile-over-k.md` (iter-127):

- **Step (i.a)**: define the Lie algebra of a `GrpObj` over a field `k` as the cotangent at the identity: `(η[G])^* Ω_{G/k}` is a finitely generated free `k`-module of rank `dim G`. The natural target name (per iter-126 analogist) is `AlgebraicGeometry.GrpObj.lieAlgebra` (or `GrpObj.cotangentAtIdentity`); the rank lemma is `GrpObj.lieAlgebra_finrank_eq_dim` (or similar).
- **Step (i.b)**: construct left-invariant translations via `GrpObj.mulRight` (which exists in Mathlib `b80f227` per the iter-126 analogist; used in `Mathlib/AlgebraicGeometry/Group/Smooth.lean:50-51`). The translations globalise the Lie-algebra-at-identity to a frame on `Ω_{G/k}`. **Important per iter-127 over-k analogist risk register**: the globalisation must be formulated **functorially via the shear iso** `(a, b) ↦ (a, a · b)` (a scheme map over any base), NOT via pointwise translation requiring `k̄`-rational points.
- **Step (i.c)**: from the frame, conclude `Ω_{G/k}` is `Module.Free` of rank `dim G`. Target names: `AlgebraicGeometry.GrpObj.omega_free` and `AlgebraicGeometry.GrpObj.omega_rank_eq_dim`.

You must:

1. **Add a new sub-section** `\subsection{Piece (i): sub-lemma decomposition for iter-128+ build}` within `\section{The shared cotangent-vanishing Mathlib pile}` (after the existing bullet-list of pieces (i)-(iv)). Provide informal-but-rigorous proof sketches for sub-steps (i.a) → (i.b) → (i.c), each rendered as a `\begin{lemma} ... \end{lemma}` block with:
   - A statement that names the Lean target via `\lean{AlgebraicGeometry.GrpObj.<name>}`. Choose names following the project's `GrpObj.*` namespace convention. Use the iter-126 analogist's recommendations as the default: `GrpObj.lieAlgebra` (or `cotangentAtIdentity`), `GrpObj.lieAlgebra_finrank_eq_dim`, `GrpObj.omega_free`, `GrpObj.omega_rank_eq_dim`.
   - A `\uses{...}` cross-reference graph: sub-step (i.b) `\uses{lem:GrpObj_lieAlgebra}`, sub-step (i.c) `\uses{lem:GrpObj_mulRight_globalises}`, etc.
   - A `\notready` marker (since the body is not yet formalised; the iter-128 prover lane will fire on at least sub-step (i.a) and the marker will be removed once the prover closes the body).
2. **Update the existing bullet (i) at L63–64** to point to the new sub-section: replace the prose decomposition with a one-line summary plus `\cref{subsec:RigidityKbar_piece_i_decomposition}` (or similar label).
3. **Apply the iter-127 over-k framing**: replace any prose mentioning "over `k̄`" or "abelian variety over an algebraically closed field" with "over a base field `k`" in piece (i)'s decomposition. The cotangent triviality argument runs over any base field per the iter-127 over-k analogist verdict; sub-step (i.b) must explicitly mention the functorial shear-iso formulation (NOT pointwise translation).
4. **Add a one-sentence remark** noting that sub-step (i.a) is the natural first target for the iter-128+ prover lane (it has the simplest signature: a `k`-vector-space-of-rank-`dim G` claim about the cotangent at the identity).

**Out of scope**:
- Do NOT edit the over-`k̄` framing in the chapter introduction or in `\section{Statement}` (those are being handled in a separate inline plan-agent edit; you do NOT touch them).
- Do NOT add `\leanok` markers anywhere (the deterministic `sync_leanok` phase handles those).
- Do NOT change anything in piece (ii), piece (iii), or piece (iv); those remain as-is.
- Do NOT rename the chapter file or `\label{chap:RigidityKbar}` (the rename is deferred to iter-128+).
- Do NOT speculate on Lean tactics or proof bodies; the prover writes those.

## References

- `analogies/cotangent-vanishing-pile.md` (iter-126 over-`k̄` analogist; per-piece scoping).
- `analogies/cotangent-vanishing-pile-over-k.md` (iter-127 over-k analogist; the OK_OVER_K verdict + risk register).
- `Mathlib/AlgebraicGeometry/Group/Abelian.lean:128-145` and `Group/Smooth.lean:38-60` (the existing `GrpObj` Mathlib infrastructure the project consumes).
- `AlgebraicJacobian/Rigidity.lean:91+` for `Scheme.Over.ext_of_eqOnOpen` (the iter-125 refactor; consumed by C.2.b but NOT by piece (i) directly).

## Output / report

Per the descriptor: write to `task_results/blueprint-writer-rigiditykbar-piece-i-iter127.md` with the chapter delta summary + the new sub-section content + any strategy-modifying findings (we don't expect any; the over-k commitment was made by the strategy-critic-consult chain).

## Acceptance criteria

- New sub-section is added to `RigidityKbar.tex` with at least 3 `\begin{lemma}` blocks (sub-steps i.a, i.b, i.c) each carrying `\lean{...}` hints with proposed Lean target names and `\uses{...}` cross-references.
- The first lemma (sub-step i.a) is sufficiently precise for the iter-128 prover lane to open the Lean scaffold on it.
- Bullet (i) at L63–64 of the existing chapter content is updated to point at the new sub-section.
- Over-k framing (functorial shear iso for globalisation, NOT pointwise translation) is explicitly stated in sub-step (i.b).
- Estimated chapter delta: ~30–60 lines added.
