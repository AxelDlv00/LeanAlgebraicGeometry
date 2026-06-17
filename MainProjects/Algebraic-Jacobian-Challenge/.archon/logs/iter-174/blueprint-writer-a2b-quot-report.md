# Blueprint Writer Report

## Slug
a2b-quot

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_QuotScheme.tex (NEW)

## Changes Made

Created the chapter from scratch with `% archon:covers AlgebraicJacobian/Picard/QuotScheme.lean`. Eight declaration blocks landed (1 main theorem, 1 sibling theorem on flat base change, 3 definitions, 4 lemmas), each with a verbatim `% SOURCE QUOTE:` from a local `references/` file.

- **Added definition** `\definition`/`\label{def:hilbert_polynomial}`/`\lean{AlgebraicGeometry.Scheme.hilbertPolynomial}` — per-fiber Hilbert polynomial $\Phi_{\mathcal{F},s}(m) = \chi(\mathcal{F}|_{X_s} \otimes L_s^{\otimes m})$ on a proper-support, $S$-flat coherent sheaf; locally constant by flatness.
- **Added definition** `\definition`/`\label{def:quot_functor}`/`\lean{AlgebraicGeometry.Scheme.QuotFunctor}` — the functor $\Quot^{\Phi,L}_{E/X/S} : (\mathrm{Sch}/S)^{op} \to \mathbf{Set}$, with the three conditions (coherent, $T$-flat, fiberwise Hilbert polynomial $\Phi$) and the kernel-equivalence quotient.
- **Added definition** `\definition`/`\label{def:grassmannian_scheme}`/`\lean{AlgebraicGeometry.Scheme.Grassmannian}` — the relative Grassmannian functor $\mathrm{Grass}(V, d) = \Quot^{d,\mathcal{O}_S}_{V/S/S}$ of rank-$d$ locally free quotients.
- **Added theorem** `\theorem`/`\label{thm:grassmannian_representable}`/`\lean{AlgebraicGeometry.Scheme.Grassmannian.representable}` — smooth projective $S$-scheme of relative dimension $d(r-d)$, with tautological quotient and Plücker embedding into $\mathbb{P}_S(\bigwedge^d V)$. Proof sketch summarises the 5-step Nitsure §1 construction (gluing affine charts, separatedness, valuative-criterion properness, universal quotient, Plücker embedding).
- **Added theorem** `\theorem`/`\label{thm:quot_representable}`/`\lean{AlgebraicGeometry.Scheme.QuotScheme}` — **main statement.** Representability by a projective $S$-scheme with universal quotient. Hilbert scheme = $E = \mathcal{O}_X$ special case. Proof sketch in 4 named steps (boundedness, Grassmannian embedding, locally closed via flattening stratification, valuative-criterion upgrade to closed embedding), each delegated to a sub-lemma in the next section.
- **Added lemma** `\lemma`/`\label{lem:quot_reduction_to_pi_star_W}` — twist-shift isomorphism + surjection-induces-closed-embedding, reducing the general case to the universal case $X = \mathbb{P}_S(V)$, $E = \pi^* W$.
- **Added lemma** `\lemma`/`\label{lem:quot_boundedness}` — uniform Castelnuovo–Mumford $m$-regularity bound across all fibers, propagating to the locally-free direct images and surjective canonical maps.
- **Added lemma** `\lemma`/`\label{lem:quot_alpha_injective}` — Grassmannian embedding $\alpha : \Quot \to \mathrm{Grass}(W \otimes \mathrm{Sym}^r V, \Phi(r))$ is injective on $T$-points.
- **Added lemma** `\lemma`/`\label{lem:quot_valuative_criterion}` — DVR valuative criterion of properness via torsion-free image construction.
- **Added theorem** `\theorem`/`\label{thm:flat_base_change_cohomology}`/`\lean{AlgebraicGeometry.flatBaseChangeCohomology}` — Stacks 02KH (flat base change of $R^i f_*$), recorded as a named statement so the Lean encoding can cite it directly.
- **Added Lean encoding section** (`sec:quot_lean_encoding`) breaking the construction into three phases (Hilbert polynomial / Grassmannian / Quot scheme) + a cohomology-base-change paragraph + a dependencies summary.
- **Added Out-of-scope section** explicitly listing what this chapter does NOT cover (flattening stratification, Hilbert as a separate chapter, Castelnuovo–Mumford theorem, semi-continuity, Snapper's Lemma, Mathlib bridges, projective-space identifications, Hironaka counterexample, group-scheme refinement, $\Pic^0$).

## Cross-references introduced

- `\uses{def:hilbert_polynomial}` in `def:quot_functor` — same chapter; verify ✓.
- `\uses{def:grassmannian_scheme}` in `thm:grassmannian_representable` — same chapter; verify ✓.
- `\uses{def:quot_functor, def:grassmannian_scheme, thm:grassmannian_representable, thm:flattening_stratification_exists}` in `thm:quot_representable` — the last lives in `Picard_FlatteningStratification.tex` (verified the label exists at line 198 of that file).
- `\uses{lem:quot_boundedness, lem:quot_alpha_injective, lem:quot_valuative_criterion}` in proof of `thm:quot_representable` — same chapter.
- `\uses{thm:flat_base_change_cohomology}` in proof of `lem:quot_boundedness` — same chapter.
- `\cref{chap:Picard_RelativeSpec}` (A.1.a, on disk) — verified.
- `\cref{chap:Picard_FlatteningStratification}` (A.2.a, written this iter) — verified.
- `\cref{chap:Picard_FGAPicRepresentability}` (A.2.c, on disk, references this chapter back) — verified.
- `\cite{nitsure-hilbert-quot}` — one use in prose of `lem:quot_boundedness`; this bibkey is already used by `Picard_FlatteningStratification.tex` line 24, so the bibliography entry exists.

## References consulted

- `references/summary.md` — index of all local sources; used to identify Nitsure as the primary source for Quot construction.
- `references/nitsure-hilbert-quot.md` — confirmed retrieval status, section→page map (§1 L287, §5 L2154), file layout.
- `references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex` — verbatim quotes:
  - L287–L500 + L546–L599 — §1 Hilbert/Quot functor definition, Hilbert polynomial stratification, Grassmannian as Quot.
  - L773–L930 — §1 "Construction of Grassmannian" sub-section (5 steps).
  - L2154–L2542 — §5 "Construction of Quot Schemes" (main existence theorems + reduction + $m$-regularity + Grassmannian embedding + flattening stratification + valuative criterion).
- `references/stacks-coherent.md` — confirmed tag 02KH (flat base change cohomology) location.
- `references/stacks-coherent.tex` L947–L970 — verbatim quote for `thm:flat_base_change_cohomology`.
- `references/hartshorne-algebraic-geometry.md` — checked: III.5.2 (the polynomial-eventually result) is NOT covered by this card (only III.5.1 is). The Hartshorne PDF is scanned-image with no text layer, so a verbatim `% SOURCE QUOTE:` from Hartshorne is not feasible without page-image inspection. **Workaround:** the verbatim quote in `def:hilbert_polynomial` is taken from Nitsure §1 (which proves the same property via Snapper's Lemma); Hartshorne III.5.2 is cited in prose as the textbook reference.
- `blueprint/src/chapters/Picard_RelativeSpec.tex` — read in full to mirror the chapter template (STRATEGY NOTE block, `% archon:covers` line, citation-discipline pattern, Lean encoding section structure, out-of-scope itemize).
- `blueprint/src/chapters/Picard_FGAPicRepresentability.tex` — read first 80 lines to verify that this chapter's expected label `chap:Picard_QuotScheme` is referenced via `\cref{chap:Picard_QuotScheme}` (it is, on line 7) and that the Hilbert scheme is consumed as `\Hilb_{C/k} = \Quot_{\mathcal{O}_C/C/k}` (it is, lines 44–46).
- `blueprint/src/chapters/Picard_FlatteningStratification.tex` — `grep`-checked labels; confirmed `\label{thm:flattening_stratification_exists}` (line 198) and `\cite{nitsure-hilbert-quot}` (line 24) both exist.
- `blueprint/src/macros/common.tex` — checked which mathops are already declared (`\Spec`, `\Sch`, `\Pic`, `\Hom`); `\Quot`, `\Hilb`, `\Div`, `\Grass`, `\Picz` are NOT declared (and sibling chapter Picard_FGAPicRepresentability also uses them undeclared — consistent project style; flagged below).

## Macros needed (if any)

These macros are used in the new chapter and are also used by sibling chapters (e.g.\ `Picard_FGAPicRepresentability.tex`, `Picard_FlatteningStratification.tex`) **without being declared** in `macros/common.tex`. Adding them is out of my write-domain:

- `\Quot` — used pervasively as `\Quot^{\Phi,L}_{E/X/S}`. Suggested: `\DeclareMathOperator{\Quot}{Quot}`.
- `\Hilb` — used as `\Hilb^{\Phi,L}_{X/S}`, `\Hilb_{C/k}`. Suggested: `\DeclareMathOperator{\Hilb}{Hilb}`.
- `\Div` — used in strategy comment and Lean-encoding paragraph as `\Div_{C/k}`. Suggested: `\DeclareMathOperator{\Div}{Div}` (note: `\div` collides with the built-in division operator, so the operator name `\Div` is intentional).
- `\Picz` — used in strategy comment as `\Picz`. Suggested: `\newcommand{\Picz}{\Pic^0}`.

Pure-math symbols `\mathbb{P}`, `\mathbb{A}`, `\bigwedge`, `\mathrm{Sym}`, `\mathrm{Grass}` are used directly (no new macros needed).

## Reference-retriever dispatches (if any)

None. All source quotes were taken from local files already in `references/`. The one place where the directive named a source not covered by the local files (Hartshorne III.5.2 for the polynomial-eventually property) was worked around by using Nitsure §1 (which covers the same statement verbatim via Snapper's Lemma) for the `% SOURCE QUOTE:` and citing Hartshorne III.5.2 in the visible `\textit{Source: ...}` line as a textbook secondary reference — see explanation under "References consulted". Dispatching a retriever to render Hartshorne III.5.2 from the scanned PDF would have been ~30 minutes of page-image extraction for a single-sentence quote that Nitsure already provides in equivalent form; the workaround keeps the citation discipline intact without retrieval overhead.

## Notes for Plan Agent

1. **Grassmannian-scheme sub-build — STRONG recommendation to split into its own chapter `Picard_GrassmannianScheme.tex` (writer iter-175+).** The directive flagged this and I concur. Reasons:
   - The Grassmannian construction is a self-contained, substantial piece (5 named sub-sections in Nitsure §1: gluing affine charts, separatedness, properness via valuative criterion, universal quotient, Plücker embedding) — currently squeezed into one theorem-with-large-proof block (`thm:grassmannian_representable`) in §3 of this chapter.
   - Mathlib carries no scheme-level Grassmannian at the pinned commit (only a linear-algebra Grassmannian as a finite-rank-quotient variety), so this is a load-bearing project-side prerequisite, not a black-boxable input.
   - Splitting unblocks the iter-175 prover lane: the Grassmannian sub-build can proceed in parallel with the rest of the Quot-scheme assembly (boundedness, flattening application, valuative-criterion upgrade), since the Quot proof only consumes the representability *statement*, not its internals.
   - Suggested split: keep `def:grassmannian_scheme` and `thm:grassmannian_representable` *statements* here as references (with `\uses{...}` pointers); move the proof-sketch and the five Nitsure-§1 sub-steps to `Picard_GrassmannianScheme.tex`. Strategic-budget estimate ~300–600 LOC, ~3–5 iters for the new chapter.

2. **Castelnuovo–Mumford $m$-regularity theorem** is consumed by `lem:quot_boundedness` as a black box (a "uniform $m$ exists" extractor). The proof lives in Nitsure §2. For Lean encoding this is a project-side sub-build (~200–400 LOC, ~2–4 iters). Consider scoping into its own chapter `Picard_CastelnuovoMumford.tex` (iter-176+), or accepting it as a `sorry`-able input with a `% NOTE:` deferral marker on the consuming lemma's body.

3. **Semi-continuity + base change (Nitsure §3)** — the `thm:flat_base_change_cohomology` statement is here (Stacks 02KH), but the *full* base-change-for-flat-sheaves machinery used in `lem:quot_boundedness` and `lem:quot_alpha_injective` (semi-continuity, cohomology-and-base-change for higher direct images of locally free flat families) is a Mathlib bridge if available at the pinned commit, project-side sub-build otherwise. The Picard_RelativeSpec chapter does not cover this. Suggest the plan agent scope a brief Mathlib-status check (akin to the iter-167 Lane A status scan) before the prover lane fires on `QuotScheme.lean`.

4. **Snapper's Lemma** — the polynomial-eventually property of $m \mapsto \chi(\mathcal{F} \otimes L^{\otimes m})$ is a Mathlib-status question. The graded Euler-characteristic infrastructure is partial in Mathlib (`Polynomial.numericalPolynomial` and adjacent), but Snapper's Lemma per se is a project-side sub-build. Project-side proof is a short induction on the dimension of the support; ~50–150 LOC.

5. **Hartshorne III.5.2 source-quote workaround** — see "References consulted". The verbatim quote in `def:hilbert_polynomial` is from Nitsure §1, not Hartshorne III.5.2. If a strict-Hartshorne-citation policy is preferred, dispatch a retriever (`pdf-image render` slug) to inspect Hartshorne page 228 (PDF p.245) and produce a card `references/hartshorne-III-5.md` with the verbatim III.5.2 statement. I judged this not worth the cost given the Nitsure equivalent is already in-project.

6. **Sibling-chapter inconsistency I spotted but did NOT fix** — `Picard_FGAPicRepresentability.tex` line 7 references `\cref{chap:Picard_QuotScheme}` (the label I created in this chapter), so the cross-reference now resolves. No fix needed; just noting that the FGA chapter was already expecting this chapter to exist.

7. **Cross-cutting Lean target naming** — I used `AlgebraicGeometry.Scheme.QuotScheme` (singular, matching `AlgebraicGeometry.Scheme.RelativeSpec`). If the project convention is `Quot` (matching the math notation), the plan agent can update the `\lean{...}` hints in this chapter (and align with the new Lean file's naming) without changing the prose.

## Strategy-modifying findings

None. The chapter content matches the directive and the surrounding strategy (Route A.2.b, gated on A.2.a + A.1.a, consumed by A.2.c). The Grassmannian sub-build emerging as a sub-prerequisite (item 1 above) is a *blueprint-organisational* finding, not a strategy-level change: the strategy already anticipated "Mathlib has no Grassmannian scheme" per the directive's load-bearing FGA piece flag.
