# Blueprint Writer Report

## Slug
rigiditykbar-isalgclosed

## Status
COMPLETE

All four required edits (statement block, KDM correction, constants collapse, over-k
reconciliation) plus the (S3.*) descope markers were applied. Chapter remains valid
LaTeX (all real environments balanced; see "LaTeX validity" below).

## Target chapter
blueprint/src/chapters/RigidityKbar.tex

## Changes Made

### Edit 1 — `thm:rigidity_over_kbar` statement + framing
- **Revised** chapter intro sentence (`\chapter` lead-in): "over an arbitrary base
  field $k$ (no algebraic closure assumed)" → "over an algebraically closed base
  field $\bar k$ of characteristic zero", with descent to general $k$ flagged as a
  separate downstream step.
- **Replaced** the `\paragraph{Iter-127 over-k commitment.}` block with a new
  `\paragraph{Iter-152 alg-closed pivot.}`: records the pivot, the two KDM
  counterexamples ($B=k\times k$, $B=\mathbb Q(\sqrt 2)/\mathbb Q$) and which joint
  hypothesis excludes each, the collapse of `constants_integral_over_base_field`, and
  the downstream descent via `AlgebraicGeometry.Flat.epi_of_flat_of_surjective`. States
  the signature now carries `[IsAlgClosed kbar] + [CharZero kbar]`.
- **Revised** the `\theorem` statement prose (`thm:rigidity_over_kbar`): "Let $\bar k$
  be a field …" → "Let $\bar k$ be an algebraically closed field of characteristic zero
  (Lean: `[IsAlgClosed kbar]` + `[CharZero kbar]`) …", noting the hypotheses match the
  existing docstring and are required by the curve-side chain. `\lean{}` hint unchanged
  (`AlgebraicGeometry.rigidity_over_kbar`); `\leanok` markers untouched.

### Edit 2 — `lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero` (KDM)
- **Replaced** the iter-151 "THIS LEMMA IS FALSE AS STATED" `% NOTE` with a corrected
  `% NOTE` that records WHY both hypotheses are needed: keeps the two counterexamples,
  states `[IsDomain B]` kills CE1 and `[IsAlgClosed k]` kills CE2, and warns against
  re-weakening. (Per directive: removed the false-as-stated flag, added the
  geometric-content rationale so it is not silently re-lost.)
- **Corrected** the statement: now "$k$ algebraically closed field of characteristic
  zero (`[Field k] [IsAlgClosed k] [CharZero k]`)" and "$B$ a finite-type standard-smooth
  $k$-algebra of relative dimension $n$ that is an integral domain (`[Algebra.FiniteType
  k B]`, `[Algebra.IsStandardSmoothOfRelativeDimension n k B]`, `[IsDomain B]`)".
- **Replaced** the proof's "(C.d) transfer step / (S5.a) / (S5.b)" prose (which closed a
  FALSE goal) with the corrected field-of-fractions argument (FT.1)–(FT.3): $K=\mathrm{
  Frac}(B)$ separably generated; $k$ algebraically closed in $K$; $\ker d_{K/k}=$
  relative algebraic closure $=k$. Kept the reusable polynomial-ring helpers (C.a)–(C.c)
  and reframed them as the free-layer building blocks.
- **Added** a `% NOTE` flagging the residual content: the precise Mathlib lemma for
  "$\ker d_{K/k}=$ relative algebraic closure for a separable extension" should be
  confirmed by the prover; if absent, assemble from separating-transcendence-basis
  freeness of $\Omega_{K/k}$ (the (C.a)–(C.c) helpers are the building blocks).
- **Revised** the "Closure end state and ordering" paragraph to the alg-closed reading
  and marked the superseded (p1)/(p2) blocks as not-on-critical-path (they targeted the
  bare, now-false, statement). Updated one stale iter-151-writer `% NOTE` that referenced
  the deleted (C.d).

### Edit 3 — `lem:constants_integral_over_base_field`
- **Added** to the statement block an "Iter-152 alg-closed pivot" note: conclusion
  (`RingHom.range (appTop.hom) = ⊤`) unchanged, but the proof now assumes `[IsAlgClosed
  k]` (invoked only with $k=\bar k$).
- **Replaced** the entire proof body (path-(a) 7-step chain (a)–(g) + path-(b)
  4×(S3.*) NOTE) with the COLLAPSED 3-step proof:
  (1) `IsReduced` + `GeometricallyIrreducible` ⟹ $X$ integral ⟹ $\Gamma$ a field
  (`isField_of_universallyClosed`);
  (2) properness ⟹ `appTop` finite (`finite_appTop_of_universallyClosed`), so $\Gamma$
  a finite field extension of $k$;
  (3) `IsAlgClosed.algebraMap_bijective_of_isIntegral` ⟹ bijective ⟹ `range = ⊤`.
- **Pruned** the `\uses{lem:S3_sep_1…, lem:S3_sep_2…, lem:S3_pi_1…, lem:S3_pi_2…}` from
  the proof block (now no `\uses`). Trimmed the Mathlib-status / Literature notes to the
  3-step hooks; kept Stacks 0BUG / Hartshorne III.5.2 references.

### (S3.*) descope markers (all four blocks live in THIS chapter)
- **Added** a "DESCOPED under the alg-closed pivot — general-over-k Mathlib-PR fodder,
  not on the M2.a critical path" `% NOTE` to each of the four statement blocks
  (`lem:S3_sep_1…`, `lem:S3_sep_2…`, `lem:S3_pi_1…`, `lem:S3_pi_2…`). Labels and
  statements retained (not deleted). The (S3.pi.1)/(S3.pi.2) notes also record that the
  iter-150 HYBRID-DEFERRED disposition is now resolved YES.

### Edit 4 — over-k framing reconciliation
- **Revised** the "Use in the project" M2.b genus-0 witness bullet: rigidity is now
  established over $\bar k$ and the constancy conclusion descends to general $k$ via
  `AlgebraicGeometry.Flat.epi_of_flat_of_surjective` (detailed descent → genus-0 witness
  chapter).
- **Revised** the two piece-(i) cross-references to the renamed "Iter-127 over-k
  commitment" section: pointed them at "Iter-152 alg-closed pivot" and clarified the
  group-scheme cotangent-triviality piece is genuinely intrinsic over a general base
  (no alg-closure needed there); only the curve-side $\mathrm df=0\Rightarrow$ constancy
  chain needs $\bar k$ algebraically closed.

## Cross-references introduced
- `\cref{lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero}` and
  `\cref{lem:constants_integral_over_base_field}` added in the `thm:rigidity_over_kbar`
  statement note — both exist in this chapter.
- No new `\uses{}` edges added; one set of `\uses{}` (the four S3.* edges) was PRUNED
  from `lem:constants_integral_over_base_field`'s proof block.

## References consulted
- None opened this session for verbatim citation. Per the directive, the corrected KDM
  argument is project-bespoke mathematics (no external source named) and the Mathlib
  anchor `IsAlgClosed.algebraMap_bijective_of_isIntegral` needs no `% SOURCE:` block.
  All pre-existing `% SOURCE QUOTE:` blocks were left untouched; I added no new ones, so
  no citation-discipline obligation was incurred. (Existing Stacks 00T7 / 0BUG / 02KH /
  035U / 04QM / 0BUG quotes in untouched or trimmed blocks remain as they were.)

## Macros needed (if any)
- None. No new LaTeX commands introduced.

## LaTeX validity
- Real environments balanced: itemize 19/19, proof 23/23, lemma 20/20, theorem 4/4,
  remark 3/3. `enumerate` greps as 13 begin / 11 end, but the 2-unit gap is entirely
  truncated verbatim Stacks quotes inside `%` comments (the 4 REAL `\begin{enumerate}`
  at lines 120/1730/1890/2279 match the 4 REAL `\end{enumerate}` at 124/1734/1894/2283).
  Pre-existing; not introduced by these edits.

## Reference-retriever dispatches (if any)
- None.

## Notes for Plan Agent
- **KDM `\uses` left as-is.** The KDM statement/proof still `\uses{lem:chart_algebra_
  isPushout_of_affine_product, lem:KaehlerDifferential_constants_in_chart_of_proper_curve}`.
  The corrected (FT) argument no longer consumes the chart-of-proper-curve constants
  helper (only the superseded (p1) char-$p$ block did), but I left the edge to avoid
  orphaning a still-referenced lemma. Consider pruning `lem:KaehlerDifferential_constants
  _in_chart_of_proper_curve` from KDM's `\uses` if the superseded (p1) block is later
  deleted.
- **Lean signature change is downstream work.** The corrected KDM and the alg-closed
  `constants` lemma require the Lean declarations to actually carry `[IsAlgClosed k]` +
  `[IsDomain B]` (KDM) and `[IsAlgClosed k]` (constants). Those are `.lean` edits outside
  my write-domain; flagging so a prover lane picks them up. The `archon-protected.yaml`
  status of `rigidity_over_kbar` / KDM signatures should be checked before a prover
  re-signs them (signature change couples to the user-gated `[IsAlgClosed kbar]` decision
  noted in the directive as already endorsed).
- **Cross-chapter:** the directive notes ChartAlgebraS3.tex hosts (S3.*) prose in some
  framings — in THIS chapter the four (S3.*) lemma blocks live locally and were marked
  DESCOPED here. If a parallel ChartAlgebraS3.tex copy exists, a separate writer should
  apply the same descope marker there. The genus-0 witness chapter must host the
  $\bar k\to k$ descent detail (Flat.epi_of_flat_of_surjective) referenced from the
  "Use in the project" bullet.
- **Superseded (p1)/(p2) blocks retained.** They are large and now describe routes to a
  false bare statement; I kept them as auditable records (clearly marked SUPERSEDED /
  not-critical-path). If chapter length is a concern, they are safe to delete in a future
  cleanup since the live argument is (C.a)–(C.c)+(FT).

## Strategy-modifying findings
None. The pivot was already endorsed (strategy-critic SOUND, progress-critic STUCK→pivot)
and the directive's joint-hypothesis soundness argument holds up: the chapter now reflects
it without surfacing any new strategy-level contradiction.
