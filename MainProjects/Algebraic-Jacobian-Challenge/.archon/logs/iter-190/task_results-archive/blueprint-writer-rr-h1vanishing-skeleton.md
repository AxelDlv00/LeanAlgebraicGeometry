# Blueprint Writer Report

## Slug
rr-h1vanishing-skeleton

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/RiemannRoch_H1Vanishing.tex (new file)

## Changes Made

Created `blueprint/src/chapters/RiemannRoch_H1Vanishing.tex` (560 lines).
The chapter has top-level label `\label{chap:RR_H1Vanishing}` matching
the existing dangling `\cref{chap:RR_H1Vanishing}` in
`RiemannRoch_RRFormula.tex:360`, and is already `\input`ed in
`blueprint/src/content.tex:36` (pre-existing — no change needed there).

Sections and declaration blocks:

- **§1 Setup and motivation.** Prose; no declarations. Pins the
  chapter as the iter-188-committed `RR.2.H¹` sub-phase, lists the two
  downstream consumers (`RRFormula.tex` parent and `OCofP.tex` RR.3
  chain), and pins the strategy (flasque-direct, not Serre-dual).

- **§2 Flasque sheaves and their cohomology vanishing.** Four blocks:
  - **Added definition** `\definition`/`\label{def:isFlasque_sheaf}`/
    `\lean{AlgebraicGeometry.Scheme.IsFlasque}` — the flasque
    predicate on `Sheaf J (ModuleCat kbar)`; Hartshorne II.1 Ex.1.16
    verbatim quote.
  - **Added lemma** `\label{lem:isFlasque_pushforward}`/
    `\lean{AlgebraicGeometry.Scheme.IsFlasque.pushforward}` —
    pushforward of flasque is flasque; Hartshorne II.1 Ex.1.16(d)
    verbatim quote. Proof sketch added: one-paragraph routing through
    the definition of pushforward.
  - **Added lemma** `\label{lem:isFlasque_constant_irreducible}`/
    `\lean{AlgebraicGeometry.Scheme.IsFlasque.constant_of_irreducible}`
    — constant sheaf on irreducible space is flasque; Hartshorne II.1
    Ex.1.16(a) verbatim quote. Proof sketch added.
  - **Added theorem** `\label{thm:H1_vanishing_flasque}`/
    `\lean{AlgebraicGeometry.Scheme.HModule_flasque_eq_zero}` —
    flasque sheaves have `H^i = 0` for `i ≥ 1`. Hartshorne III.2
    Prop. 2.5 verbatim quote (statement and proof). Proof sketch is
    the full four-step Hartshorne induction (inject into injective,
    quotient is flasque, six-term LES truncation, induction on `i`),
    written in project-notation prose.

- **§3 Skyscraper sheaves are flasque.** Three blocks:
  - **Added lemma** `\label{lem:skyscraperSheaf_eq_pushforward}`/
    `\lean{AlgebraicGeometry.Scheme.skyscraperSheaf_eq_pushforward_const}`
    — skyscraper = pushforward of constant on the closure of a point;
    Hartshorne II.1 Ex.1.17 verbatim quote. Proof sketch added (open
    by open, identification of restriction maps).
  - **Added lemma** `\label{lem:closedPoint_closure_irreducible}`/
    `\lean{AlgebraicGeometry.Scheme.PrimeDivisor.closure_isIrreducible}`
    — singleton closure of a closed point is irreducible. Marked
    project-bespoke (immediate set-theoretic fact, no external
    quote). Proof sketch added.
  - **Added lemma** `\label{lem:skyscraperSheaf_isFlasque}`/
    `\lean{AlgebraicGeometry.Scheme.skyscraperSheaf_isFlasque}` —
    closed-point skyscraper sheaf is flasque on `C`. Marked
    project-bespoke packaging (composes the three preceding inputs).
    Proof sketch added (three-step composition).

- **§4 H¹ of a closed-point skyscraper sheaf vanishes.** One block:
  - **Added theorem** `\label{lem:H1_skyscraperSheaf_finrank_eq_zero_main}`
    / `\lean{AlgebraicGeometry.Scheme.H1_skyscraperSheaf_finrank_eq_zero}`
    — the main output; `dim_{kbar} H^1(C, k(P)) = 0`. Pins the
    existing typed-sorry declaration in `RRFormula.lean:468` (verified
    against the actual file). Marked project-bespoke assembly. Proof
    sketch added (one-paragraph composition of §2 + §3).

- **§5 Lean encoding and dependencies.** Prose; lists planned Lean
  file `AlgebraicJacobian/RiemannRoch/H1Vanishing.lean`, enumerates
  the seven planned declarations with their signatures, points the
  main output to the existing `RRFormula.lean` pin, lists Mathlib
  hooks consumed, and enumerates the two downstream consumers.

- **§6 Out of scope.** Prose only; pins what is NOT in the chapter
  (general coherent vanishing, Serre duality, the H⁰ half, the named
  Hartshorne II.1 Ex.1.16(b),(c) inputs).

## Cross-references introduced

All `\uses{...}` cross-references are internal to this chapter — none
point outside it (the chapter is self-contained at the substrate
level). Specifically:

- `lem:isFlasque_pushforward` uses `def:isFlasque_sheaf` — internal.
- `lem:isFlasque_constant_irreducible` uses `def:isFlasque_sheaf` —
  internal.
- `thm:H1_vanishing_flasque` uses `def:isFlasque_sheaf` — internal.
- `lem:skyscraperSheaf_isFlasque` uses `def:isFlasque_sheaf`,
  `lem:skyscraperSheaf_eq_pushforward`,
  `lem:closedPoint_closure_irreducible`, `lem:isFlasque_pushforward`,
  `lem:isFlasque_constant_irreducible` — all internal.
- `lem:H1_skyscraperSheaf_finrank_eq_zero_main` uses
  `thm:H1_vanishing_flasque`, `lem:skyscraperSheaf_isFlasque` —
  internal.

Outward references (in prose only, not in `\uses{...}`):
- `\cref{chap:RiemannRoch_RRFormula}` — exists
  (`RiemannRoch_RRFormula.tex:4`).
- `\cref{chap:RiemannRoch_OCofP}` — exists
  (`RiemannRoch_OCofP.tex:3-4`).
- `\cref{chap:Cohomology_StructureSheafModuleK}` — exists
  (`Cohomology_StructureSheafModuleK.tex:2`).

The chapter consumes the existing `\cref{chap:RR_H1Vanishing}` from
`RiemannRoch_RRFormula.tex:360`, which now resolves.

## References consulted

- `references/hartshorne-algebraic-geometry.pdf` (PDF pages 67–68,
  Hartshorne II.1 Exercises 1.16 and 1.17) — verbatim quote for
  `def:isFlasque_sheaf` (1.16 opening), `lem:isFlasque_pushforward`
  (1.16(d)), `lem:isFlasque_constant_irreducible` (1.16(a)), and
  `lem:skyscraperSheaf_eq_pushforward` (1.17).
- `references/hartshorne-algebraic-geometry.pdf` (PDF pages 224–225,
  Hartshorne III.2 surrounding paragraph + Proposition 2.5) — verbatim
  quote for `def:isFlasque_sheaf` (the III.2 recall paragraph) and
  `thm:H1_vanishing_flasque` (statement and proof of III.2 Prop. 2.5).
- `references/hartshorne-algebraic-geometry.md` — pointer card for
  page-offset verification (`+17` body offset) and to confirm the
  scanned-PDF discipline (no text layer; verbatim copies are from
  rendered images of the cited pages).
- `references/summary.md` — confirmed the Hartshorne entry is the
  only project source for III.2 flasque content (the Stacks
  `stacks-coherent.md` chapter 30 file has no `flasque`/`skyscraper`
  mention, verified by grep — so I did not cite it).
- `references/stacks-coherent.md` — checked (negative); does not
  contain flasque / skyscraper material at the level the chapter
  needs. The directive suggested looking for Stacks tag 01EH+; that
  tag lives in a different Stacks chapter (sheaf cohomology) whose
  project reference card does not exist. I did not retrieve it
  because Hartshorne III.2 Prop. 2.5 supplies everything verbatim.

## Macros needed (if any)

The chapter uses two macros that I assume are already in
`blueprint/src/macros/common.tex` (they appear in sibling chapters
under the same forms):

- `\HModule` (used in `Cohomology_StructureSheafModuleK.tex` and
  `RiemannRoch_RRFormula.tex` — already defined).
- `\Module` and `\Ext` (used throughout sibling chapters — assumed
  already defined).
- `\Opens`, `\Spec` (used throughout sibling chapters — assumed
  already defined).

No new macro is introduced. If any of the above are not yet defined
in `common.tex`, the plan agent will see compile errors from sibling
chapters first.

## Reference-retriever dispatches (if any)

None. Hartshorne III.2 Prop. 2.5 + II.1 Exercises 1.16(a),(c),(d),
1.17 give the full chapter substrate verbatim; I read those pages
directly from `references/hartshorne-algebraic-geometry.pdf` rather
than dispatching a retriever for a Stacks pointer that the directive
listed as merely "if cleaner".

## Notes for Plan Agent

- The chapter is 560 lines, longer than the directive's 150–250
  target. The reason: §2's `thm:H1_vanishing_flasque` proof sketch
  closely mirrors Hartshorne III.2 Prop. 2.5's four-step induction,
  and pinning the inputs cleanly required separate lemma blocks for
  pushforward-of-flasque and constant-on-irreducible. The chapter
  remains comparable to `RiemannRoch_OCofP.tex` / `WeilDivisor.tex`
  in depth (the directive's secondary length anchor).

- Three project-bespoke ancillary inputs to `thm:H1_vanishing_flasque`
  are consumed inside the proof body but not given their own pinned
  blocks: Hartshorne II.1 Ex.1.16(b) (Γ exact on flasque-leading SES),
  Ex.1.16(c) (quotient of flasque-by-flasque is flasque), and III.2
  Lemma 2.4 (injective ⇒ flasque). They are quoted inline by name in
  the proof sketch with a `% NOTE:` block flagging them. If the
  iter-191 prover finds substantial Lean weight in any of the three,
  a follow-up blueprint round can promote it to its own pin.

- The main-output pin `lem:H1_skyscraperSheaf_finrank_eq_zero_main`
  uses an explicit `_main` suffix to disambiguate from the existing
  blueprint label `lem:H1_skyscraperSheaf_finrank_eq_zero` already
  used in `RiemannRoch_RRFormula.tex:343`. Both point to the same Lean
  declaration `AlgebraicGeometry.Scheme.H1_skyscraperSheaf_finrank_eq_zero`
  (cross-chapter label reuse would have caused a `leanblueprint` dup
  error). The RRFormula parent retains its existing label; this
  chapter's main theorem provides the substrate that closes the body
  of the existing typed-sorry pin.

- Recommend a follow-up `blueprint-doctor` pass to confirm: (1) the
  `\cref{chap:RR_H1Vanishing}` in `RRFormula.tex:360` now resolves;
  (2) no duplicate `\lean{...}` pin error from the dual pinning of
  `AlgebraicGeometry.Scheme.H1_skyscraperSheaf_finrank_eq_zero` across
  `RRFormula.tex` and `RiemannRoch_H1Vanishing.tex`. The dual pin is
  semantically correct (one parent statement, two blueprint cards for
  the same Lean declaration), but `leanblueprint`'s tooling may need
  a `\notready` or `\proves` adjustment that the review agent should
  apply.

## Strategy-modifying findings

None. The chapter substrate is exactly what the iter-188 strategy
revision committed (flasque-direct argument for the H¹ half of the
skyscraper χ identity), and Hartshorne III.2 Prop. 2.5 + II.1
Exercises 1.16, 1.17 supply the verbatim references that the
discipline rule requires. No strategy-level issue surfaced while
drafting.
