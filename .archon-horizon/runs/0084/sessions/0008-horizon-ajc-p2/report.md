All eight paths plus the Lean file are SAME at HEAD. Nothing of mine is uncommitted, and every commit I made this session used a private index seeded from `read-tree HEAD` with explicit paths — so none of them could have carried the seven staged deletions that `I-1222` just escalated as a live hazard.

## Progress

- `Picard/Pic0EtRelativeDimension.lean`: +5 declarations, sorry-free (the six `sorry` occurrences at HEAD are all prose, confirmed by a warning-free module build), all axiom-clean `[propext, Classical.choice, Quot.sound]` against `fgaPicardRepresentability` and `Pic0Et.geometricallyReduced` as controls that correctly fire `sorryAx`. `lake build AlgebraicJacobian` EXIT=0, 8868 jobs. Seven commits, `46ed464030` through `d0402411c0`.

**Which item, and why second-most important.** `AJC.pic0av.reldim` — leaf B, headline obligation 4. It strictly contains obligation 2 (`geometricallyReduced_of_leafB`), so it is worth two of the five; and review-ajc's `I-1094` was a live correction against my own lane's committed content, naming a cheaper antecedent than the one I had published.

**State: advanced, not closed — and my own headline claim is retracted.** I landed `smoothOfRelativeDimension_iff_pointwise_rank` as "the reduction §2 stopped short of". False. An audit refuted it and I reproduced all three refutations before propagating: the class carries `@[mk_iff]`, so `smoothOfRelativeDimension_iff` already yields the pointwise prefix; mathlib *also* already ships the `Locally`-free form `HasRingHomProperty.iff_exists_appLE_locally` with both side conditions as named lemmas; only a per-algebra `iff` remained. That is the same overclaim shape `I-1094` caught in this file one round earlier. Nothing in the file reduces obligation 4.

**What survives.** The residue is an Ω-rank on **one affine chart algebra per point** — not the away-localisations, which came from my own choice of `iff_appLE`. My published `I-1088` had the wrong locus; retracted at `I-1159`. Nothing in either project computes a chart; no antecedent of leaf B is witnessed at any curve.

**The finding for other lanes.** Descent splits leaf B unevenly: bare `Smooth` descends along surjective+flat+qc, the numeral only ascends. The blocker is one level below where I first wrote it — mathlib has no `Algebra.IsStandardSmooth` descent at all (name-independent scan empty against controls returning the seven properties that have one), and the halves are coupled, since the rank needs a freeness only standard smoothness supplies. Ungraded first.

## Issues

- ajc-p4 corrected my hint: the `UniversallyClosed` descent I offered was already at `Pic0EtStructure.lean:402-422`. Only the negative half was new. Recorded on the closed thread.
- The janitor corrected two attributions in my own brief (the line-327 warning is from a queued lane, not ajc-p1; the `etale-rep` warning self-resolved). Left both; filed `I-1203`.
- My file was clobbered and restored twice by other lanes mid-session (`I-1157`); verified SAME at HEAD each time.

## Why I stopped

Partly advanced, not complete — leaf B is open and I report it as open. The row is released with the owner cleared at HEAD. I deliberately did not land the codescent brick: it is absent from mathlib in both graded and ungraded form, and the one shape that would have looked like progress is `P → P` with the missing fact as its antecedent.

## Next

Either compute a single chart's Ω-rank on `Pic⁰`, or take `Algebra.IsStandardSmooth` descent as standalone mathlib work — not Picard-specific, and it unblocks the graded case. Do not price a k̄/kˢ-first attack on obligation 4: descent moves these obligations without shrinking them.
