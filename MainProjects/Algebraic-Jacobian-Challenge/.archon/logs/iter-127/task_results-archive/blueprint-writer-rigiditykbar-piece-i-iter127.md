# Blueprint Writer Report

## Slug
rigiditykbar-piece-i-iter127

## Status
COMPLETE

## Target chapter
`blueprint/src/chapters/RigidityKbar.tex`

## Changes Made

### 1. Bullet (i) of `\section{The shared cotangent-vanishing Mathlib pile}` rewritten as a one-line pointer
- **Revised** the long-prose bullet at the former L66 (the `\item[(i)]` line of the piece-(i)–(iv) `itemize`) into a compact summary that:
  - States the conclusion (`\Omega_{G/k}` is free of rank `\dim G` for a smooth proper geometrically irreducible group scheme `G` over a base field `k`, **no algebraic-closure hypothesis**, per the iter-127 over-k commitment),
  - Lists the proposed target names (`AlgebraicGeometry.GrpObj.omega_free`, `AlgebraicGeometry.GrpObj.omega_rank_eq_dim`),
  - Points at the new sub-section via `\cref{subsec:RigidityKbar_piece_i_decomposition}`,
  - Preserves the 800–1500 LOC estimate and the iter-126-analogist's cost rationale at one-sentence resolution,
  - Switches the group-scheme variable name from `A` to `G` for consistency with the `GrpObj` namespace (matches the analogist's recommendations and the new sub-section's prose),
  - Replaces "mulRight-globalisation" with "shear-iso globalisation" per the iter-127 over-k risk register.

### 2. New `\subsection{Piece (i): sub-lemma decomposition for iter-128+ build}` inserted
- **Added subsection** `\label{subsec:RigidityKbar_piece_i_decomposition}`, placed after the piece-(i)-(iv) `itemize` (former L79 `\end{itemize}`) and before the "Honest pile cost" paragraph. Structure:
  - **Framing paragraph (3 paragraphs)**: introduces the (i.a) → (i.b) → (i.c) decomposition, explicitly re-asserts the iter-127 over-k commitment ("All three sub-steps are stated over an arbitrary base field $k$ … working functorially throughout"), names sub-step (i.a) as the natural first target for the iter-128+ prover lane, and pins notation (`k`, `G : Over (Spec k)`, identity section `\eta_G`).
  - **5 `\begin{lemma}` blocks**, each carrying `\lean{AlgebraicGeometry.GrpObj.<name>}` hints, `\uses{...}` cross-references, `\notready` markers, and informal-but-rigorous proof sketches:
    1. **(i.a)** `lem:GrpObj_lieAlgebra` → `\lean{AlgebraicGeometry.GrpObj.lieAlgebra}` — defines `\mathfrak g^\vee := \eta_G^* \Omega_{G/k}` as a finitely generated free `k`-module, with proof sketch via regularity of `\mathcal O_{G, \eta_G}` and `\mathfrak m / \mathfrak m^2`.
    2. **(i.a)** `lem:GrpObj_lieAlgebra_finrank` → `\lean{AlgebraicGeometry.GrpObj.lieAlgebra_finrank_eq_dim}` — rank lemma `\finrank_k \mathfrak g = \dim G`; `\uses{lem:GrpObj_lieAlgebra}`.
    3. **(i.b)** `lem:GrpObj_mulRight_globalises` → `\lean{AlgebraicGeometry.GrpObj.mulRight_globalises_cotangent}` — the shear-iso globalisation `\Omega_{G/k} \cong \pr_1^*(\eta_G^* \Omega_{G/k})`; `\uses{lem:GrpObj_lieAlgebra}`. The lemma statement contains a dedicated **"Iter-127 over-k risk register"** paragraph that explicitly mandates the functorial shear-iso formulation `\sigma = \langle \pr_1, \mu \rangle : (a,b) \mapsto (a, a \cdot b)` and forbids pointwise translation by closed / `\bar k`-rational points (with reference to Mathlib's `pointEquivClosedPoint` as the alg-closure-using counterpart). Proof sketch builds `\sigma^{-1}` from `\GrpObj` data only (`\iota` + `\mu` + projections), verifies invertibility from associativity + left-inverse axioms, and restricts along `\langle \mathrm{id}_G, \eta_G\rangle` to get the displayed iso.
    4. **(i.c)** `lem:GrpObj_omega_free` → `\lean{AlgebraicGeometry.GrpObj.omega_free}` — `\Omega_{G/k}` is a free `\mathcal O_G`-module; `\uses{lem:GrpObj_lieAlgebra, lem:GrpObj_mulRight_globalises}`.
    5. **(i.c)** `lem:GrpObj_omega_rank_eq_dim` → `\lean{AlgebraicGeometry.GrpObj.omega_rank_eq_dim}` — rank of `\Omega_{G/k}` equals `\dim G`; `\uses{lem:GrpObj_omega_free, lem:GrpObj_lieAlgebra_finrank}`.
  - **Closing `\begin{remark}`** `rem:piece_i_first_target` — restates that sub-step (i.a) is the natural first target for the iter-128+ prover lane (smallest signature surface, no scheme-level globalisation, exact rank value), and notes (i.b) + (i.c) can stage to separate prover lanes once (i.a) lands.

### Chapter delta size
+101 lines inserted (one large insertion + a small rewrite of the piece-(i) bullet). Within the directive's 30–60 line target by approximately 1.7×; the slight overshoot reflects the 5-lemma decomposition (1 lemma each for the two named (i.a) targets, 1 for (i.b), 2 for the two named (i.c) targets) that the directive's named-target list requires, plus a remark.

### Out-of-scope items NOT touched
- Chapter introduction's "Iter-127 over-k commitment" paragraph (already handled by the inline plan-agent edit per directive).
- `\section{Statement}` and its `\thm{thm:rigidity_over_kbar}` (out of scope).
- Pieces (ii), (iii), (iv) bullets — unchanged.
- Chapter filename and `\label{chap:RigidityKbar}` — unchanged.
- No `\leanok` or `\mathlibok` markers added (the deterministic `sync_leanok` phase handles those).
- No Lean proof bodies, tactics, or any Lean-syntactic prose.

## Cross-references introduced

| New label | `\uses` outgoing | Targets |
|---|---|---|
| `lem:GrpObj_lieAlgebra` | (none) | New decl, root of (i.a) sub-chain. |
| `lem:GrpObj_lieAlgebra_finrank` | `lem:GrpObj_lieAlgebra` | Verify the `lem:` label exists — it does (defined in the same subsection above). |
| `lem:GrpObj_mulRight_globalises` | `lem:GrpObj_lieAlgebra` | Same. |
| `lem:GrpObj_omega_free` | `lem:GrpObj_lieAlgebra, lem:GrpObj_mulRight_globalises` | Both defined above. |
| `lem:GrpObj_omega_rank_eq_dim` | `lem:GrpObj_omega_free, lem:GrpObj_lieAlgebra_finrank` | Both defined above. |
| `rem:piece_i_first_target` | `lem:GrpObj_lieAlgebra, lem:GrpObj_lieAlgebra_finrank` | Both defined above. |
| `subsec:RigidityKbar_piece_i_decomposition` | (referenced from bullet (i) via `\cref`) | Defined in this same chapter. |

All proofs additionally carry `\uses{...}` lines on the cross-chapter side (none here — the proofs reference only sibling lemmas in the same subsection), so the dependency graph closes within this subsection.

## Macros needed
None. All macros used (`\Spec`, `\Over`, `\finrank`, `\notready`, `\genus`) are already defined in `blueprint/src/macros/{common,print}.tex` per a grep check. The `\notready` macro is defined as a no-op in `print.tex` (line 18) — the directive's requirement to add `\notready` markers per lemma is satisfied.

## Reference-retriever dispatches
None. The directive supplied all needed references (`analogies/cotangent-vanishing-pile.md` iter-126, `analogies/cotangent-vanishing-pile-over-k.md` iter-127, the existing chapter content, and the `Mathlib/AlgebraicGeometry/Group/Smooth.lean` / `Group/Abelian.lean` line ranges); no fresh source needed.

## Notes for Plan Agent

1. **Variable-name divergence between the new sub-section and the chapter's `\section{Statement}`.** The new sub-section uses `G` for the abstract group scheme (matches the `GrpObj` namespace and the iter-126/127 analogist convention). The existing `\section{Statement}` and the Lean scaffold (`AlgebraicJacobian/RigidityKbar.lean:81`) use `A` for the rigidity-specific group scheme. This is consistent — the sub-section's abstract `G` instantiates to the chapter's `A` at use site — but a future blueprint-writer pass could either (a) standardise on `G` chapter-wide (would touch `\section{Statement}` and `\section{Proof decomposition}`, neither of which are in this round's scope), or (b) add a single sentence at the top of the subsection saying "in the C.2.d application, $G = A$". I chose neither — both are out of this directive's scope. Flagging for the plan agent's awareness.

2. **The new `lem:GrpObj_mulRight_globalises` Lean target name** (`AlgebraicGeometry.GrpObj.mulRight_globalises_cotangent`) is my best fit between the analogist's prose ("mulRight-globalises") and the label `\uses` syntax mandated in the directive (`lem:GrpObj_mulRight_globalises`). The directive did not specify a Lean target for sub-step (i.b) — only the label. If the iter-128+ prover lane prefers a different Lean name (e.g. `GrpObj.shear_globalises_cotangent` or `GrpObj.omega_isPullback_of_lieAlgebra`), the `\lean{...}` hint should be updated then.

3. **Sub-step (i.a) is structured as two lemma blocks** (`lieAlgebra` definition + `lieAlgebra_finrank_eq_dim` rank), because the directive named two distinct Lean targets for (i.a). The first one is technically a definition rather than a lemma, but the directive mandated `\begin{lemma}` blocks, and `\begin{lemma}` with a free-module-of-rank-d existence statement is a valid surrogate.

## Strategy-modifying findings

None. The over-k commitment was already made by the iter-127 strategy-critic-consult chain; the analogists' (iter-126 + iter-127) per-piece naming and decomposition recommendations carried verbatim into the new sub-section. No surprises during drafting that require updating STRATEGY.md.
