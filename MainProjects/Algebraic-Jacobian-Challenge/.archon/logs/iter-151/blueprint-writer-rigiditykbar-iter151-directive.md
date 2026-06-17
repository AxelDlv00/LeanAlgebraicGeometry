# Blueprint Writer Directive

## Slug
rigiditykbar-iter151

## Target chapter
blueprint/src/chapters/RigidityKbar.tex

## Strategy context
This chapter backs `AlgebraicJacobian/RigidityKbar.lean` and (in its
"Chart-algebra piece (ii) first-class decomposition" subsection)
`AlgebraicJacobian/Cotangent/ChartAlgebra.lean`. The active Route-C prover lane
this iter targets the KDM lemma
`lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero`. The iter-151
blueprint review flagged its proof prose `complete: partial`: the first-class
prose still describes the ABANDONED routes (p2 = BR.1–BR.5 via
`Differential.ContainConstants`, and the p1 char-p route), while the LIVE Lean
route — HYBRID route (C) — exists only inside a `% NOTE` comment. A prover
directed at "the BR.5 transfer step" per the blueprint is pointed at a route the
Lean dropped. This round makes route (C) first-class prose so the chapter
matches the Lean. This is the gate-clearing must-fix for the KDM prover lane.

## Required content

### 1. (MUST-FIX) Add a first-class route-(C) sub-block "(BR.5′)" to the KDM proof
Inside the proof of `lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero`,
promote the live HYBRID route (C) from its `% NOTE` (around L2278–2324) into
first-class prose, parallel in style to the existing (p1.a)–(p1.f) / (BR.1)–(BR.5)
itemisations. Keep the abandoned (p1)/(p2) routes but clearly mark them as
superseded alternatives; route (C) is the live one. Route (C) reads:

- **(C.a) FREE-CASE.** Over `k` of characteristic 0, if the universal Kähler
  derivation `D` kills `f ∈ MvPolynomial σ k` (i.e. `D f = 0`), then
  `f ∈ (MvPolynomial.C).range` (f is a constant). Proof: `D f = 0` forces every
  partial `pderiv i f = 0` (via the explicit free basis
  `KaehlerDifferential.mvPolynomialBasis` with `repr (D f) i = pderiv i f`); the
  coefficient identity `coeff (u - single i 1) (pderiv i f) = coeff u f · (u i)`
  for `u i ≥ 1` then forces every non-constant coefficient to vanish in char 0.
- **(C.b) Standard-smooth presentation.** Extract a `SubmersivePresentation P`
  from `Algebra.IsStandardSmoothOfRelativeDimension`, giving a surjective
  `k`-algebra map `π : MvPolynomial ι k → B` (`Algebra.IsStandardSmooth.out` +
  `Generators.algebraMap_surjective`).
- **(C.c) Lift + functoriality.** Lift `b ∈ B` to `bTilde ∈ P.Ring`;
  functoriality `KaehlerDifferential.map_D` turns the hypothesis `D_B b = 0` into
  `(map k k P.Ring B)(D_A bTilde) = 0`, i.e. `D_A bTilde ∈ ker(map)`.
- **(C.d/transfer step — the residual `sorry`).** Modify `bTilde` to some `α`
  with `algebraMap P.Ring B α = b` (same `π`-image) AND `D_A α = 0`, then apply
  (C.a). The kernel `ker(map k k P.Ring B)` is (by
  `KaehlerDifferential.ker_map_of_surjective`) the `P.Ring`-submodule generated
  by `{D r : r ∈ I}` (`I = ker π`) plus `I·Ω`; the `D(I)` part is absorbed by a
  Leibniz modification of `bTilde`, leaving the `I·Ω` part. Two closure paths:
  **(S5.a)** explicit `ker_map_of_surjective` + `Finsupp.linearCombination`
  unfolding + Leibniz iteration (~30 LOC); **(S5.b)** abstract bypass via
  `Algebra.FormallySmooth.subsingleton_h1Cotangent` (~10–20 LOC).

State plainly that (C.a)–(C.c) are closed in Lean and the residual `sorry` is
exactly the (C.d) transfer step.

### 2. Retarget dangling `references/*.md` pointers in `% NOTE` comments
Several `% NOTE` render-fix comments cite local files that DO NOT EXIST on disk:
`references/stacks-0334.md`, `stacks-0BJF.md`, `stacks-05DH.md`,
`stacks-0BUG.md`, `stacks-07F4.md`, `hartshorne-ag.md`,
`literature-crosscheck-iter149.md`. Retarget every such pointer to the bundled
genuine sources that exist: `references/stacks-{varieties,fields,algebra,coherent}.tex`
(see the tag map below). Drop pointers to `literature-crosscheck-iter149.md`
entirely (that file was a fabrication, removed).

### 3. Add verbatim source-citation blocks (scope: ~6 highest-value declarations)
For the chart-algebra piece (ii) lemmas that already carry `\emph{Literature.}`
blocks, upgrade them to the full citation discipline: add `% SOURCE:` (tag +
bundled file) and `% SOURCE QUOTE:` (VERBATIM statement copied from the bundled
`.tex`, character-for-character, no paraphrase) and a visible
`\textit{Source: Stacks Tag <tag>.}` line. Prioritise:
- The (BR.*) standard-smooth basis lemmas ← read `references/stacks-algebra.tex`:
  Lemma 10.137.6 / Tag 00T7 (near **L37259**), specifically part (2) "`Ω_{S/R}`
  free on `dx_{c+1},…,dx_n`".
- (S3.sep.1)/(S3.sep.2)/(S3.pi.1)/(S3.pi.2) if they appear in this chapter ←
  the varieties/coherent/fields tags per the map below (same tags as the
  ChartAlgebraS3 chapter; do not duplicate effort if a parallel writer is also
  covering them — cite here only the instances that live in THIS chapter).
- `thm:rigidity_over_kbar` derives from **Mumford, _Abelian Varieties_, Ch. II
  §4** — this source is PAYWALLED and NOT in `references/`. Do NOT fabricate a
  quote. Add only `% SOURCE: Mumford, Abelian Varieties, Ch. II §4 (verbatim
  text not yet retrieved — paywalled, no open copy)` and a visible
  `\textit{Source: Mumford, Abelian Varieties, II §4.}` line, no `% SOURCE QUOTE:`.

Tag → bundled file map:
- 035U/04QM/056T/0BUG → `references/stacks-varieties.tex`
- 09HD/030K → `references/stacks-fields.tex`
- 00T7 → `references/stacks-algebra.tex` (L37259)
- 02KH → `references/stacks-coherent.tex` (L948)

## Out of scope
- Do NOT edit any other chapter (`ChartAlgebraS3.tex`, `Jacobian.tex`, etc. are
  handled by parallel writers).
- Do NOT add or remove `\leanok` / `\mathlibok` markers.
- Do NOT change Lean `\lean{...}` hints, lemma signatures, or the math of any
  closed proof. Do NOT touch the genus-0 / Mayer–Vietoris (β-core) prose.
- Do NOT fabricate any quote. If a named source file is absent, flag it
  `(verbatim text not yet retrieved)` rather than writing recalled text.

## References
- `references/stacks-algebra.tex` — Tag 00T7 / Lemma 10.137.6 at L37259.
- `references/stacks-varieties.tex` — Tags 035U, 04QM, 056T, 0BUG.
- `references/stacks-coherent.tex` — Tag 02KH at L948.
- `references/stacks-fields.tex` — Tags 09HD, 030K.
- `references/summary.md` — tag → file index.

## Expected outcome
The KDM proof block describes the live route (C) as first-class (BR.5′) prose
(matching the Lean), the residual `sorry` is identified as the (C.d) transfer
step with its two closure paths, all `% NOTE` reference pointers target bundled
files that exist, and ~6 high-value declarations carry verbatim `% SOURCE QUOTE:`
blocks copied from the genuine Stacks sources (with Mumford honestly flagged as
not-yet-retrieved).
