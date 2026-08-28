Task marked done. All six commits are in the ledger with my task trailer.

## Summary

Executed the human decision of 2026-07-28 (protection I-0491): the Jacobian headline is stated over an arbitrary field with no rational-point binder, and the étale-sheafified relative Picard functor is what gets represented. All five deliverables landed, Ground-reviewed, task set `done`.

The central claim is **confirmed mechanically**, not by docstring: `picardJacobianWitness` and `Jacobian` carry exactly `[SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]`, `HasRationalPoint` and `HasPicScheme` are both non-synthesizable from those, and a 6,242-constant walk of the headline cone found no rational-point constant.

## Progress
- `Picard/PicEtSheaf.lean`: NEW, 262 lines, sorry-free. The étale-sheafified functor `Pic_{(C/k)ét}` with its sheaf property **proved** (`picEt_isSheaf_forget`, axiom-clean). Site is mathlib's `Scheme.etaleTopology` localised at `Spec k` via `GrothendieckTopology.over` — the slice-topology transport I predicted would be "real work" was already in mathlib.
- `Picard/FGAPicRepresentability.lean`: `fgaPicardRepresentability` — the obligation restated for `picEt`, no rational-point binder, one named sorry. `instHasPicScheme` deleted as an *instance*; survives as the sorry-free theorem `picSchemeOfHasRationalPoint`.
- `Picard/Pic0Et.lean`: NEW. `Pic0SchemeEt`; `grpObj`/`geometricallyIrreducible`/`locallyOfFiniteType`/`isSeparated` proved and axiom-clean; `smooth`/`proper` are assemblies over one residue each.
- `Jacobian.lean`: `hasRationalPoint_of_curve` **deleted** (false as stated). Witness reassembled on `Pic0SchemeEt`. Both conditional witnesses kept, relabelled.
- `Albanese/AlbaneseUP.lean`: one-line consumer repair.
- `scripts/axiom-frontier.lean`: probes the new seam; new `HeadlineBinders` section is a regression test that stops compiling if a rational-point binder returns.
- Blueprint / README / TO_USER / hgraph: all re-aimed to "decided", including a blueprint lemma that was pinned to the now-deleted declaration.

**Measured before/after**: 126 probed / 85 clean → 147 / 95. Obligation count **five before, five after** — the deliverable is that none is a false statement now.

## Issues
Two defects Ground caught that I had not:
- Two commits recorded diffs unrelated to their messages (concurrent index re-seed). HEAD briefly didn't build. Repaired in `c71ce05b8`; I posted the detection recipe and two other lanes then found the same race in their own commits.
- `Pic0Et` omitted the gate binder, so the instance fired at elaboration and four "PROVED unconditionally" docstrings reported `sorryAx`. Fixed in `91fc0017f`; all five now clean. This is a synthesis leak the project's "zero sorry-bodied instances" census cannot see — filed as memory I-0530.

The **root** build currently fails on another lane's in-flight `Cohomology/` edit; `lake build AlgebraicJacobian.Jacobian` is green at 8,657 jobs.

## Why I stopped
Objective fully complete. `AJC.jacobian.assembly` stays open deliberately — it's the assembly step, and five true obligations remain, two of them in the Albanese cone. Rationale recorded on the node so the recurring consistency warning isn't re-litigated.
