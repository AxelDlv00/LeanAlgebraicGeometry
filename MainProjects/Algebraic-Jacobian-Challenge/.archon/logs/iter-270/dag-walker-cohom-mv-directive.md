# DAG Walker Directive

## Slug
cohom-mv

## Seed
thm:Scheme_subsingleton_HModule_prime_supr_of_hasCechToHModuleIso_curve

## Strategy context
You are a child of the `cohom-rr` dag-walker, which is wiring the whole
Cohomology + RiemannRoch region into one dependency cone under the
Riemann--Roch genus-zero head. The Mayer--Vietoris chapter is the largest
single unwired cluster (~56 isolated nodes): it builds the Mayer--Vietoris
short-exact-sequence / long-exact-sequence machinery for the project's
`ModuleCat k`-valued sheaf cohomology `HModule`/`HModule_prime`, and the
Čech-to-HModule comparison that proves `H^1` vanishing on a curve.

## Depth / scope
**Your write domain is ONLY `blueprint/src/chapters/Cohomology_MayerVietoris.tex`.**
Do NOT edit any other chapter. You MAY (and should) add `\uses{}` edges that
point at labels living in OTHER chapters you do not edit — in particular the
`def:Scheme_HModule*`, `def:Scheme_cech*`, `def:Scheme_IsCechAcyclicCover`,
`thm:Scheme_*` declarations in `Cohomology_StructureSheafModuleK.tex` (a sibling
walker is wiring that file in parallel; the labels already exist on disk).

### CRITICAL MECHANICAL FACT (verified this iteration)
The leandag graph builder reads `\uses{...}` **only from the statement block**
(the `\begin{lemma/theorem/definition/...}` ... environment that carries the
`\label{}`), **NOT from the `\begin{proof}` block.** Many nodes here already
have a `\uses{}` inside their proof but show as isolated (`dep=0`) because the
statement block has none. Therefore:
- For every node, ensure the **statement block** (right after its `\label{}` /
  `\lean{}`) carries a `\uses{...}` listing every dependency its statement and
  proof actually invoke.
- If a `\uses{}` already exists only in the proof, copy it up to the statement
  (you may leave the proof copy in place; it is harmless).
- Read each block's statement + proof prose and add the edges the mathematics
  actually uses. The prose frequently names dependencies in `\texttt{...}` or
  with `\cref{...}`, and sometimes with the literal placeholder `REF` where a
  cross-reference was stripped — resolve those to the real `\label`.

### Your job
Walk every isolated node in `Cohomology_MayerVietoris.tex` and give its
statement block a complete `\uses{}`. The internal structure is a linear-ish
build: `toBiprod`/`fromBiprod` → `shortComplex` (f mono, g epi, exact,
shortExact) → `delta`/`sequence` → `sequenceIso` → `sequence_exact` →
`AffineCoverMVSquare` family → `finrank`/`module_finite` transfer →
`subsingleton_HModule(_prime)` vanishing → `cechToHModuleIso` /
`HasAffineCechAcyclicCover` heads. Wire each node to the prior nodes (and to the
`StructureSheafModuleK` defs) its proof relies on. `_curve` variants `\uses`
their non-`_curve` counterpart plus the curve hypotheses.

After editing, re-run
`archon dag-query node --node <label> --json` on several heads to confirm
`dep_count > 0`, and
`archon dag-query ancestors --node thm:Scheme_subsingleton_HModule_prime_supr_of_hasCechToHModuleIso_curve --json`
should return a non-empty cone.

## Constraints
- Do NOT add `\leanok`. Do NOT add `\mathlibok` unless a node genuinely
  re-exports a real named Mathlib declaration (most here are proved directly in
  Lean — just add `\uses{}`, do not touch their proof state).
- Do NOT invent mathematics or rewrite proofs. You are transcribing
  dependencies only.
- Keep valid LaTeX (balanced braces in `\uses{}`).
- Any node with a real statement but no `\lean{}` and not a `\begin{remark}`:
  add a placeholder `\lean{AlgebraicGeometry.TODO.<name>}`.

## References
None needed — these are project-internal constructions; do not cite external
sources unless a block already carries a `% SOURCE` comment you are extending.

## Report
Write to `.archon/task_results/dag-walker-cohom-mv.md` per the standard
DAG-walker report format.
