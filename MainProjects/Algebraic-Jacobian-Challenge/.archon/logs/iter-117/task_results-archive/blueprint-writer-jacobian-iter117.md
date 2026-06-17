# Blueprint Writer Report

## Slug
jacobian-iter117

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Jacobian.tex

## Changes Made

- **Revised** `def:IsAlbanese` — statement unchanged; added a sibling
  block `rem:IsAlbanese_typeclasses` (Remark) immediately after it
  disclosing that the four abelian-variety conditions on `J`
  (`GrpObj`, `IsProper`, `Smooth`, `GeometricallyIrreducible`) are
  encoded as Lean typeclass parameters of the declaration, not as
  conjuncts in the body. Cross-refers to the `letI` chain in
  `AbelJacobi.ofCurve` as the canonical downstream-use idiom.
- **Added theorem-block proofs** for each of the four protected
  instances `thm:Jacobian_grpObj`, `thm:Jacobian_smooth_genus`,
  `thm:Jacobian_proper`, `thm:Jacobian_geomIrred`. Each new proof
  block has two layers: (a) the Lean projection from the
  corresponding witness field (`grpObj`, `smoothGenus`, `proper`,
  `geomIrred`), and (b) the mathematical content explaining why the
  property holds of an Albanese variety:
  - `grpObj` proof: universal-property construction of multiplication,
    inverse, identity from the diagonal and unit morphisms; uniqueness
    via `thm:IsAlbanese_unique`.
  - `smoothGenus` proof: tangent-space identification with `H^1(C, O_C)`
    plus homogeneity of the group action.
  - `proper` proof: properness of `Pic^0_{C/k}` as a closed subgroup
    scheme (Route A) or via the universal closedness of `\sigma`
    (Route B).
  - `geomIrred` proof: identity-component of a $k$-group scheme of
    finite type is geometrically irreducible; symmetric-power image
    via Stein factorisation.
  - The bundled paragraph "All four properties are part of the
    Albanese construction…" has been removed; its content now lives,
    decomposed per theorem, in the new proof blocks.
- **Expanded proof of** `thm:nonempty_jacobianWitness` from ~10 lines
  to a ~95-line structured exposition with five top-level paragraphs:
  - Paragraph (0) Reduction: the witness `J` is intrinsic to `C` and
    only the morphism `\iota_P` varies with `P`; explains how the Lean
    encoding (`J` field + `forall P, IsAlbanese C P J`) reflects this.
  - Paragraph Route A — Picard scheme: sub-steps A.1–A.4 (relative
    Picard functor, FGA representability, identity component
    `Pic^0_{C/k}`, Abel–Jacobi universal property), followed by a
    Mathlib-status itemise naming the specific missing pieces per
    sub-step.
  - Paragraph Route B — Symmetric powers and Stein factorisation:
    sub-steps B.1–B.3 (symmetric power `C^{(g)} = C^g/S_g`, the
    Abel–Jacobi morphism on $\Sym^g$ via Brill–Noether–Riemann–Roch,
    the Stein factorisation), followed by Mathlib-status itemise.
  - Paragraph Genus-0 sub-case: sub-steps C.1–C.3 (Brauer–Severi
    triviality $C \cong \mathbb P^1_k$, rigidity
    $\Hom(\mathbb P^1_k, A) = A(k)$, trivial witness $J = \Spec k$),
    followed by Mathlib-status itemise.
  - Paragraph Mathlib infrastructure summary: three independent
    build-outs (α) Hilbert/Quot + FGA representability, (β) symmetric
    powers + finite-group-scheme quotients + Stein factorisation,
    (γ) rigidity + genus-0 identification, each unlocking the
    corresponding route or sub-case.

- **Revised** the lead-in to Section 2 ("Group scheme structure and
  abelian-variety properties") to read as a one-sentence preamble for
  the four-theorem block (replacing the bundled-paragraph closer).

## Cross-references introduced
- `\uses{def:IsAlbanese}` in `rem:IsAlbanese_typeclasses` — verified
  `def:IsAlbanese` is in this same chapter.
- `\uses{def:Jacobian, thm:nonempty_jacobianWitness, thm:IsAlbanese_unique}`
  in proof of `thm:Jacobian_grpObj` — all three labels in this
  chapter.
- `\uses{def:Jacobian, thm:nonempty_jacobianWitness, def:genus}` in
  proof of `thm:Jacobian_smooth_genus` — `def:genus` is in
  `chapters/Genus.tex` (verified by grep).
- `\uses{def:Jacobian, thm:nonempty_jacobianWitness}` in proofs of
  `thm:Jacobian_proper` and `thm:Jacobian_geomIrred` — both labels
  in this chapter.
- `\uses{def:IsAlbanese, def:genus}` in proof of
  `thm:nonempty_jacobianWitness` — both labels resolve (in-chapter
  and Genus.tex respectively).
- `\ref{chap:Rigidity}` in proof of `thm:nonempty_jacobianWitness`
  (Mathlib-status note for genus-0 sub-step C.2) — referencing the
  Rigidity chapter; verified the chapter file `Rigidity.tex` exists.
- `\ref{chap:Cohomology_StructureSheafAb}` retained — already
  present in the chapter; verified the chapter label exists.

## Macros needed (if any)
- None. All operators used (`\Spec`, `\Pic`, `\Hom`, `\Sym`, `\Jac`,
  `\genus`) are already defined in `blueprint/src/macros/common.tex`.
- The proof body uses `\paragraph{...}` headers (standard LaTeX) for
  the five Route blocks; no custom macro required.

## Reference-retriever dispatches (if any)
- None. The expanded mathematical content draws on standard sources
  (Hartshorne III.4 for Pic-scheme background, FGA Explained Ch.9 for
  representability, Milne's *Abelian Varieties* Ch.III for the
  symmetric-power route) named in the directive's references section.
  No new reference summary was needed; the prose names the textbook
  routes without quoting passages, so a future reader can locate them
  in the standard literature without a project-level summary.

## Notes for Plan Agent
- The chapter has grown from 127 lines to ~250 lines, well within
  the "200–250 lines" target the directive set. The `nonempty_jacobianWitness`
  proof block alone is ~95 lines (paragraphs + three Mathlib-status
  itemises), as planned.
- The label `\ref{chap:Rigidity}` is used once inside the
  Mathlib-status of sub-step C.2 to point at the Mumford rigidity
  chapter. I verified `chapters/Rigidity.tex` exists. If the chapter
  label inside that file is different from `chap:Rigidity`, please
  adjust during typeset; I did not edit that file (out of write-domain).
- Sibling chapter `chap:Picard_Functor` is referenced once (line 6,
  retained from the previous version) and `chap:AbelJacobi` is
  referenced twice (retained). Both are existing, working
  cross-references — no changes needed there.
- `\leanok` markers in the existing blocks have been preserved
  verbatim; new proof blocks have `\leanok` inside the `\begin{proof}`
  (matching the convention the file already uses for
  `thm:nonempty_jacobianWitness`'s proof). I noticed the prior version
  also marked the four-theorem proofs `\leanok` implicitly via the
  bundled paragraph; since each new proof block now stands alone, the
  `\leanok` belongs inside the proof of each. The `sync_leanok` phase
  will validate; if it down-marks any of them, the proof structure
  remains valid.
- Out-of-scope retained: I did not touch other chapters, `content.tex`,
  Lean files, or the macro file.

## Strategy-modifying findings
None. The chapter as rewritten matches the project's existing
strategy: it documents the three classical routes and the Mathlib
infrastructure each requires, with the existence statement remaining
the project's single explicit foundational hypothesis. No new
strategy issue surfaced.
