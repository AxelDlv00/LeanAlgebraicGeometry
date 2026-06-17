# Blueprint Writer Report

## Slug
modules-monoidal

## Status
COMPLETE

## Target chapter
`blueprint/src/chapters/Modules_Monoidal.tex`

## Changes Made

- **Renamed and rewrote** the remark formerly titled "Status of $W.\mathrm{IsMonoidal}$ and the stalks-level argument" — split into TWO remarks:
  - `\label{rem:W_IsMonoidal_content}` *Mathematical content of $W.\mathrm{IsMonoidal}$ and the stalks-level argument* — kept the stalks-level recipe + Mathlib-gap explanation + ruled-out alternative routes; **removed the stale closing claim** that the gap "does not block downstream consumers".
  - `\label{rem:W_IsMonoidal_load_bearing}` *Honest disclosure: $W.\mathrm{IsMonoidal}$ is load-bearing post-C1* — new dormancy→load-bearing transition paragraph mirroring the `\thm:nonempty_jacobianWitness` honest-accounting pattern of `Jacobian.tex`. Names the post-C1 consumer arc (`LineBundle`, `Pic`, `Pic.pullback`, `PicardFunctor`, `PicardFunctorAb`, Jacobian instances, `AbelJacobi.ofCurve`); discloses `sorryAx` will surface in `lean_verify` chains; reaffirms the gap is a named Mathlib gap, not a project-local proof obligation.

- **Added section** `\section{Braided (symmetric) structure}` (new third section, before "Invertible objects and line bundles") with three blocks:
  - **Theorem** `\thm:Modules_BraidedCategoryPresheaf` / `\lean{AlgebraicGeometry.Scheme.Modules.instBraidedCategoryPresheaf}` — the presheaf-side symmetric structure (no-content bridging registration). Proof sketch added (transport across the `ringCatSheaf.obj`/`sheaf.obj∘forget₂` definitional equality).
  - **Theorem** `\thm:Modules_BraidedCategory` / `\lean{AlgebraicGeometry.Scheme.Modules.instBraidedCategory}` — the sheaf-side braided structure, transported through the `LocalizedMonoidal` machinery. Proof sketch added (cites both inputs: presheaf-side symmetry + the load-bearing `instIsMonoidal_W`). Uses `\uses{thm:Modules_MonoidalCategory, thm:Modules_BraidedCategoryPresheaf}`.
  - **Remark** [No new mathematical content] — clarifies these are registrations, naming the C1 consumer chain `BraidedCategory → Skeleton.instCommMonoid → instCommGroupUnits`.

- **Revised** the paragraph after `def:Modules_Invertible` (former L72) — switched tense to past/perfect; named the iter-109 firing of C1; reported the `(Skeleton X.Modules)ˣ` target without `Shrink` (universe pinning succeeded); cross-referenced the load-bearing-disclosure remark.

- **Revised** the "Use in the project" section — replaced the old C1/C2/C3 bullets with:
  - **Step C1 (DONE, iter-109, Archon canonical).** Names the new target `LineBundle X := (Skeleton X.Modules)ˣ`, the ring-side analogue `CommRing.Pic`, the typeclass chain delivering `CommGroup`, and the new named-deferred gap `SheafOfModules.pullback_tensorObj` gating `Pic.pullback`.
  - **Step C2.** Describes the re-derivation of `PicardFunctor` / `PicardFunctorAb` over the new `LineBundle`, including the absorbed universe bumps (`Type u → Type (u+1)`; `AddCommGrpCat.{u} → AddCommGrpCat.{u+1}`).
  - **Step C3.** Representability deferred via the `JacobianWitness` exit policy in Chapter~\ref{chap:Jacobian}.

- **Revised** the "Formalization status" section — enumerated the five project-side instances now living in `AlgebraicJacobian/Modules/Monoidal.lean`:
  - `tensorObj`, `instMonoidalCategoryPresheaf`, `instMonoidalCategoryStruct`+`instMonoidalCategory`, `instBraidedCategoryPresheaf`+`instBraidedCategory` — all closed; and `instIsMonoidal_W` — body still `sorry` and now load-bearing post-C1. Replaced "active target of Phase~C step~C0" framing with "active proving target of iters 077--108 and now in place" + the dormancy→load-bearing transition statement.

## Cross-references introduced

- `\ref{rem:W_IsMonoidal_load_bearing}` cited in two places (the new C1 closing paragraph after `def:Modules_Invertible`, and the new Formalization-status closing paragraph). The target label is defined in the same chapter (this file).
- `\ref{rem:W_IsMonoidal_content}` cited in the new Formalization-status list. Defined in this same chapter.
- `\ref{chap:Picard_LineBundle}` cited from the new "Braided structure" section and from the rewritten "Use in the project" Step~C1 bullet. Exists in `blueprint/src/chapters/Picard_LineBundle.tex:2`.
- `\ref{chap:Picard_Functor}`, `\ref{chap:Picard_FunctorAb}` — both exist in their respective chapter files.
- `\ref{chap:Jacobian}` cited from the load-bearing-disclosure remark, the "Use in the project" Step~C3 bullet, and the Formalization-status section. Exists in `Jacobian.tex:2`.
- `\ref{chap:AbelJacobi}` cited from the load-bearing-disclosure remark (`AbelJacobi.ofCurve`). Exists in `AbelJacobi.tex:2`.
- `\ref{thm:nonempty_jacobianWitness}` cited from both the load-bearing-disclosure remark and the "Use in the project" Step~C3 bullet. Exists in `Jacobian.tex:103`.
- `\uses{thm:Modules_MonoidalCategory, thm:Modules_BraidedCategoryPresheaf}` on `thm:Modules_BraidedCategory` — both `\uses` targets live in this same chapter.

## Macros needed (if any)
None. All notation (`\mathrm`, `\mathcal`, `\mathtt`, `\Pic`, `\Hom`, `\Spec`, `\Sym`, `\Jac`) is either standard LaTeX or already in use elsewhere in this chapter / sibling chapters.

## Reference-retriever dispatches (if any)
None. The directive's references (`analogies/c1-route.md`, `STRATEGY.md`, the current `Modules/Monoidal.lean`, and `Jacobian.tex`) were sufficient. No external source needed.

## Notes for Plan Agent

- The chapter's existing `\section{Mathlib gap}` (around L117–130) is now slightly stale: it lists "The instance `MonoidalCategory X.Modules`" as missing, but Phase~C step~C0 has been built (sorry-conditional via `instIsMonoidal_W`). The directive did not call this section out, so I left it untouched, but a future writer round may want to retitle it (e.g. "Mathlib-gap accounting") and restructure as a 2-row table: gap × status × project disposition.
- The blueprint-side cross-link from `Picard_LineBundle.tex` back to this chapter's new `rem:W_IsMonoidal_load_bearing` (the formal post-C1 disclosure surface) is not yet in place. I cannot reach `Picard_LineBundle.tex` from my write-domain; a follow-on `blueprint-writer` for `picard-linebundle` would close the loop by adding `Remark~\ref{rem:W_IsMonoidal_load_bearing}` (Chapter~\ref{chap:Modules_Monoidal}) to its "load-bearing-deferral" paragraph.
- The `def:Modules_Invertible` block (L108–113 post-edit) is now redundant with the C1-realised `(Skeleton X.Modules)ˣ` definition that lives in `Picard_LineBundle.tex`. The chapter currently retains it as a math-side description of "what invertibility *means*" abstractly; this is still reasonable, but if the plan agent wants strict de-duplication, it could be folded into the new Braided-structure section as a short bullet ("the units of the monoid `Skeleton X.Modules`").
- The `\section{Mathlib gap}` second bullet currently reads "The invertibility predicate (Definition `def:Modules_Invertible`) and its API" — this framing predates the C1 firing and is now historically inaccurate (C1 took the `(Skeleton …)^×` route, not the bespoke-predicate route). Same scope note as above — flagged but not changed because the directive did not call it out.

## Strategy-modifying findings

None. The writer did not surface any strategy-level surprise. The C1 promotion's load-bearing transition for `instIsMonoidal_W` and the new `SheafOfModules.pullback_tensorObj` named-deferred gap are *already* in the strategy text (`analogies/c1-route.md` Decisions B and C); this chapter merely surfaces them in blueprint prose at the disclosure surface specified by the directive.
