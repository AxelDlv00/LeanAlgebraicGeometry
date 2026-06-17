# Blueprint Writer Report

## Slug
fga-sorry-order

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_FGAPicRepresentability.tex

## Changes Made
- **Added section** `\section{Sorry-by-sorry closure order}`
  (`\label{sec:fga_pic_sorry_closure_order}`) — new section inserted
  between the existing `\section{Lean encoding}` and
  `\section{Out of scope}`. Roughly 500 lines of structured prose.
- **Added seven subsections**, one per sorry in the Lean file. Each
  subsection records the five-point checklist required by the
  directive (location, mathematical content, Mathlib prerequisites,
  Route C substrate dependency, closure-order rank):
  - `\subsection{Sorry 1 --- \texttt{instHasPicSharp} (L149)}`
    (`\label{subsec:sorry_has_pic_sharp}`) — Rank 2 (depends on A.1.c
    sibling chapter; no Riemann--Roch substrate).
  - `\subsection{Sorry 2 --- \texttt{instHasDivFunctor} (L176)}`
    (`\label{subsec:sorry_has_div_functor}`) — Rank 2 (depends on
    A.2.b sibling chapter).
  - `\subsection{Sorry 3 --- \texttt{instHasAbelMap} (L294)}`
    (`\label{subsec:sorry_has_abel_map}`) — Rank 2 (depends on
    Sorries 1 and 2; no Riemann--Roch substrate).
  - `\subsection{Sorry 4 --- \texttt{smoothProperQuotient} body
    (L354)}` (`\label{subsec:sorry_smooth_proper_quotient}`) —
    Rank 2 (substantial Mathlib gap on EGA IV 8.11.5 +
    Altman--Kleiman descent; recommended first attempt under the
    carrier-soundness probe).
  - `\subsection{Sorry 5 --- \texttt{instHasPicScheme} (L236)}`
    (`\label{subsec:sorry_has_pic_scheme}`) — Rank 3 (load-bearing
    on Route C via $m$-regularity / Serre vanishing).
  - `\subsection{Sorry 6 --- \texttt{instPicSharpRepresentable}
    (L409)}` (`\label{subsec:sorry_pic_sharp_representable}`) —
    Rank 3 (full assembly; inherits Sorry 5's Riemann--Roch
    dependency).
  - `\subsection{Sorry 7 --- \texttt{instPicSchemeGroupObject}
    (L465)}` (`\label{subsec:sorry_pic_scheme_group_object}`) —
    Rank 3 (Route C-independent in itself, but depends on Sorry 6).
- **Added closure-order summary subsection**
  `\subsection{Closure-order summary}`
  (`\label{subsec:fga_pic_closure_order_summary}`) — partitions the
  seven sorries into rank-1/rank-2/rank-3 tiers, identifies Sorry 4
  as the recommended first attempt under the carrier-soundness
  probe, Sorries 1/2/3 as the second tier gated on sibling chapters,
  and Sorries 5/6/7 as held until Route C re-engagement.

## Cross-references introduced
- `\cref{chap:Picard_RelPicFunctor}` — A.1.c sibling chapter for the
  étale-sheafified relative Picard functor (used in Sorries 1, 7).
- `\cref{chap:Picard_QuotScheme}` — A.2.b sibling chapter for the
  Quot/Hilbert engine (used in Sorries 2, 5).
- `\cref{chap:Picard_LineBundlePullback}` — A.1.b sibling chapter
  for the line-bundle pullback and relative Picard quotient (used in
  Sorry 7).
- `\cref{lem:line_bundle_quot_correspondence}` — in-chapter
  cross-reference (used in Sorry 3 and §subsec:sorry_has_div_functor).
- `\cref{thm:fga_pic_representability}` — in-chapter cross-reference
  (used in Sorries 5, 6).
- `\cref{lem:smooth_proper_quotient}` — in-chapter cross-reference
  (used in Sorry 4 and §subsec:fga_pic_closure_order_summary).
- `\cref{thm:relative_pic_quotient_well_defined}` — A.1.b cross-ref
  (used in Sorry 7).
- `\cref{thm:pullback_natural}` — A.1.b cross-ref (used in Sorry 7).
- `\cref{thm:pic_is_group_scheme}` — in-chapter cross-ref (used in
  Sorry 7).

All `\cref` targets are pre-existing in this chapter or in sibling
chapters that are already linked from earlier sections of this same
chapter (no new uncovered targets introduced).

## References consulted
- `references/summary.md` — index of all project sources; used to
  identify Kleiman / Nitsure / Milne / Mumford / Hartshorne as the
  five primary references cited by the directive and to confirm
  their local files exist.
- `references/kleiman-picard.md` — pointer card; confirmed §4
  Thm. `th:main` (L2155), Lem. `lm:qt` (L2368),
  Cor. `cor:algsch` (L2686) line ranges for the citations already
  present in the chapter; the new sorry-by-sorry section re-uses the
  existing in-chapter verbatim quotes rather than introducing new
  ones, so no fresh quote extraction was needed.
- `references/kleiman-picard-src/kleiman-picard.tex`, lines
  1266--1382 (§2 "The several Picard functors", including
  Def. `df:Pfs` at L1311 and Thm. `th:cmp` at L1384) — verified the
  relative Picard functor definition and the étale sheafification
  reference used in Sorries 1, 5, 6.
- `references/nitsure-hilbert-quot.md` — pointer card; confirmed
  §2 "Castelnuovo--Mumford Regularity" (PDF p.9) and §5
  "Construction of Quot Schemes" (PDF p.23) line/page references
  used in Sorries 2 and 5 for the Mathlib-gap analysis.
- `references/abelian-varieties.md` (Milne) — pointer card;
  confirmed §III.6 Prop 6.1 (Albanese universal property) is in
  scope as a downstream consumer but not directly cited in the new
  section (Albanese / Pic⁰ are sibling-chapter material, not in
  this chapter's scope).

No new verbatim `% SOURCE QUOTE:` blocks were written in the new
section: the five-point checklist for each sorry is a
project-bespoke analysis (closure-order ranking, Mathlib prerequisite
status, Route C substrate dependency) and references existing
in-chapter verbatim quotes (Kleiman §3 Def. `dfn:Abel` +
Thm. `th:repDiv`; §4 Thm. `th:main` + Cor. `cor:algsch` +
Lem. `lm:qt`; §2 Def. `df:Pfs`; §4 Def. `df:Psch`) rather than
introducing duplicate quote blocks. Each subsection cites the
relevant in-chapter declaration via `\cref{...}` so the
project-notation restatement is traceable back to its verbatim
source.

## Macros needed (if any)
None. The new section uses only macros already in use in the rest
of the chapter (`\Pic`, `\Hilb`, `\Quot`, `\Sch`, `\Spec`, `\cref`,
etc.).

## Reference-retriever dispatches (if any)
None. All references cited by the directive are present in the
local `references/` tree and the new section is project-bespoke
analysis layered on top of the existing in-chapter quotes.

## Notes for Plan Agent

### Directive line/identifier mismatch at L354

The directive labels L354 as "free `sorry` ... `Functor.IsRepresentable`
body for `representable` (the main A.2.c representability theorem)".
Reading the Lean file at the cited line shows that L354 is in fact
the `sorry` body of `smoothProperQuotient` (the theorem at L341
returning `P.IsRepresentable`), **not** of `representable`. The
declaration `representable` (L396) is a `noncomputable def` that
extracts via `Classical.choice` from
`PicSharpRepresentable.has_representable`; the sorry that backs it
lives in the typeclass instance `instPicSharpRepresentable` at
L408--409.

The blueprint section was written to match the **file's actual
structure** rather than the directive's attribution, because the
mathematical content of the L354 sorry (Altman--Kleiman descent of a
flat-and-proper equivalence relation) is structurally different from
the four-step FGA assembly that the directive ascribes to it. The
file's seven sorries are still:
- 1 free sorry: L354 (smoothProperQuotient body),
- 6 `⟨sorry⟩` instance bodies: L149, L176, L236, L294, L409, L465.
The directive's identifier label for L354 is the only mismatch.

### Carrier triviality at typeclass level

Four of the six `⟨sorry⟩` instances (Sorries 1, 2, 3, 7) have
typeclass body that unfolds to `Nonempty (some non-empty type)` —
trivially satisfied by any inhabitant of the type (e.g.\ a constant
functor, the zero natural transformation, etc.). This means the
typeclasses do **not** carry the semantic content their names
suggest: `HasPicSharp C` does not actually assert that the chosen
functor is the étale-sheafified relative Picard functor, only that
some presheaf of types exists. The new section flags this in each
subsection: closing the sorry to a tautological witness satisfies
the carrier-soundness probe (consumers under typeclass
quantification remain kernel-clean) but blocks downstream
mathematical use.

If the iter-198 review-phase abort verdict on the carrier-soundness
probe deems the typeclass abstraction unsound, the plan agent may
want to strengthen the typeclass bodies to require the specific
semantic witness (e.g.\ `HasPicSharp` should require a
`Functor.RepresentableBy`-style identification with a project-pinned
`PicSharp` rather than just `Nonempty`). This is a strategy-level
question and is recorded in "Strategy-modifying findings" below.

### Sibling-chapter pin lag

Sorries 1 and 2 cite the sibling chapters
`Picard_RelPicFunctor.tex` (A.1.c, `\lean{PicSharp}`) and
`Picard_QuotScheme.tex` (A.2.b, `\lean{divFunctor}`,
`\lean{QuotScheme}`) as the gating constraint. The new section
assumes those sibling chapters will land their Lean pins in a future
iteration but does not prescribe their structure beyond the names
already pinned by the `\lean{...}` hints. If the sibling-chapter
pins change name, the closure recipes for Sorries 1 and 2 will need
to be updated.

## Strategy-modifying findings

### Typeclass-level carrier triviality vs. semantic carrier soundness

The carrier-soundness refactor of iter-196 placed the six
representability carriers as `Prop`-valued typeclasses whose bodies
are `Nonempty (some type)` quantifications. For four of the six
(Sorries 1, 2, 3, 7) the typeclass body is **logically trivial**: it
can be discharged by a constant / zero witness that has nothing to
do with the named carrier (Pic^♯, Div, Abel map, group-object
structure). Only Sorries 5 and 6 (HasPicScheme and
PicSharpRepresentable) carry semantically non-trivial typeclass
bodies, because they quantify over a specific scheme `X` and over a
`RepresentableBy` witness that ties the functor and the scheme
together.

**Implication for STRATEGY.md.** The carrier-soundness probe's
soundness claim ("consumers quantifying over the typeclasses remain
kernel-clean") is technically correct, but its **strategic** value
is degraded: a downstream Route A consumer that quantifies over
`[HasPicSharp C]` and obtains a `picSharp C` via `Classical.choice`
gets a presheaf that is not actually committed to being the
étale-sheafified relative Picard functor. The downstream consumer
cannot prove anything mathematically interesting about this
`picSharp C` without further hypotheses tying it to the intended
semantic object.

The strategy may want to consider, in the iter-198 review-phase or
the next plan-phase strategy update, whether to:
1. Strengthen the four "trivial" typeclass bodies to require a
   semantic identification with the project-pinned sibling-chapter
   objects (when those pins land). This would re-couple the carriers
   but make downstream Route A consumers actually usable.
2. Accept the carrier-soundness probe as a purely structural device
   and document that no downstream mathematical claims can be made
   under `[HasPicSharp C]` quantification alone; consumers must
   additionally postulate the semantic identification as a separate
   typeclass.
3. Defer the question until the sibling chapters land, at which
   point the trivial typeclass bodies can be replaced with concrete
   re-export instances (which is what the existing Lean docstrings
   anticipate).

This is **not** a request to re-architect the probe (which the
directive explicitly forbids) but a flag that the carrier-soundness
abort verdict in iter-198 should distinguish between
"structurally sound carriers" (true for all six) and "semantically
meaningful carriers" (true for only Sorries 5 and 6 as currently
phrased). The blueprint section as written documents this
distinction for iter-199+ provers without altering the Lean code.
