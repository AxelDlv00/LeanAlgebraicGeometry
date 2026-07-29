Everything is landed and verified. The workspace is hand-off clean: board released, seam sorry count unchanged at one, probe files gone, reverted paragraph restored.

## Progress

- `Picard/PicEtSubcanonical.lean` (new, 441 lines, 8 declarations, all axiom-clean `[propext, Classical.choice, Quot.sound]`, no `sorryAx`): claimed and repriced `AJC.picrep.etale-rep`, the reviewer-nominated obligation sitting above every other lane's target.
  - `subcanonical_etaleTopology` — the étale topology is subcanonical. Mathlib v4.31 has this instance for pro-étale only; `Subcanonical.of_le` along `etaleTopology_le_proetaleTopology` gives it in one line. Re-checked against I-0978's stricter test (a failing `infer_instance` is not an absence): the only étale `Subcanonical` declaration of any kind in the index is now mine.
  - `picSharp_representableBy_picEt_transport` — the same scheme representing `picSharp` represents `picEt`, with **no** rational-point hypothesis. `hasPicSchemeEt_of_picSharp_representability` discharges the seam's clause (1) verbatim; clause (2) follows *unconditionally*, stronger than the seam's own `HasRationalPoint C → IsIso`.
  - `not_representableBy_picSharp_of_not_isIso_picEtComparison` — if the comparison fails for a curve, **no** scheme represents `picSharp` there (`X` universally quantified, so the existential is refuted, not just the pinned witness).
- `Picard/FGAPicRepresentability.lean`: rewrote the "eleventh item" paragraph. Seam sorry count unchanged at 1.
- `hgraph/nodes/84527adee34e.md`: restored the reviewer's 21-line paragraph that my own earlier commit silently reverted, and repaired the `\leanok` escaping it had mangled.
- Removed 12 scratch probe files my lane leaked into the ledger, including two duplicate `Subcanonical` instances that were outranking the library declaration in `horizon search`.

## Issues

**What I claimed and why it was most important.** The board row and seam docstring held that the campaign's `picSharp` endpoint cannot reach the sorry's `picEt` without a rational point, making étale representability an *additional unpriced obligation* possibly needing a headline restatement — a human specification decision. That was a direction confusion: Kleiman 2.5 derives the comparison *from* a section with no hypothesis on the presheaf, but the comparison **is** the sheafification unit, invertible exactly when its source is already a sheaf, which representability supplies. No supplementary theorem is needed.

**Its state now: advanced, not closed.** The seam sorry is untouched and no antecedent is witnessed for any curve. What changed is the shape of the remaining work — restate campaign G3/G4 to descend `picEt`, which is bounded, rather than face an unpriced specification decision.

**Three errors, and one was mine.** I filed I-0960 claiming Kleiman's source was absent from the workspace after grepping only a §4 excerpt; the full 6613-line paper was in `references/kleiman-picard-src/`. Withdrawn. Worse, believing it unavailable, I *hedged* the conclusion instead of checking it — and the check was decisive: Kleiman's counterexample is a smooth plane conic over ℝ, exactly this project's binders. The reviewer's Zariski-sheaf mechanism (and its replacement citation) failed in the same slot and are withdrawn; I caught the third error, that "the functors differ, so `Pic_{X/ℝ}` is not representable" is Kleiman's *sentence* but not his *proof*, which is now the theorem above. **The §3 transport survived every pass unchanged — every correction hit the prose above it.**

**Residue, precisely stated.** "G3/G4 target a false statement" rests on exactly one unformalised fact: that `picEtComparison` genuinely fails for that conic (Kleiman's `φ*O(1)`, via `h⁰` on `ℙ¹_ℂ` and flat base change). §4's theorems are the interface it plugs into.

## Why I stopped

The claimed item is fully advanced and released (`owner ''`, `pending`) with its repricing at HEAD, verified with `git show HEAD:` rather than the worktree — my first release write was reverted by a concurrent sweep and needed re-landing. `lake build AlgebraicJacobian` EXIT=0, 8852 jobs. A `work-reviewer` pass audited the work and found the one real defect I acted on.

## Next

The conic non-iso witness is the highest-value follow-up: it converts "G3/G4 are unprovable" from a quotation into a theorem. Two process defects are worth a human's attention — concurrent integrate sweeps reverted three separate lanes' work this round (mine included, I-0972/I-0987), and the commit guard cannot distinguish a deliberate removal from index pollution (I-0986).
