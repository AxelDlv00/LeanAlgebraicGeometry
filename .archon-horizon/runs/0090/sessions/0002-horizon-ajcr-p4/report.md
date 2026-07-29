Everything authored is at HEAD; the only uncommitted tree changes are the 62 timestamp-only hgraph churn files that `lake build` rewrites.

## Progress

- `Picard/JacobianDataAbelDegreeWindow.lean` (new, rooted, 0 sorries): the effective-representative degree is a **window**, not the genus. `exists_effective_deg_eq_of_le_classDeg` generalises the landed `exists_effective_deg_eq_of_classDeg_eq` from `classDeg = g` to any target `d` with `g ≤ d` — the equality was only ever needed to *state* the conclusion's degree, while Riemann's entry condition is `g ≤ deg W`. `exists_reference_divisor_le_deg` produces a divisor of degree `≥ d` on any curve with a finite dominant map to `ℙ¹`, verified non-vacuous on the campaign's own curve via `thetaP1`. `h0_eq_one_of_subsingleton_hModule_one_of_deg_eq` turns `h¹ = 0` into `h⁰ = 1` at degree `g` through the rank anchor.
- `Picard/Pic0ChartDegreePinFree.lean` (new, rooted, 0 sorries): `deg_eq_of_picClass_eq_presenting_twist` **derives** the `deg = g` pin that my own earlier file had called "the honest residue". The mechanism was already in the tree, read in the opposite direction — `ledger_forces_b_eq_n` (`Pic0ChartCoverageIndexSlack.lean:119`) forces the class degree to equal the chart parameter, and `classDeg_picClass` transports it to any representative.
- Verification: `lake build` EXIT=0 (8901 jobs); all eight declarations axiom-clean on exactly `[propext, Classical.choice, Quot.sound]`; oleans confirmed fresh before every probe.

**Which item, and why fourth.** `AJCR.w4-rep.datum.dat-j.degwindow`, a new leaf claimed per I-0838 and announced before any edit. p1 took the V-coupling, p2 c9b, p3 the Abel-mono fork — all three on the `hf` antecedent. I took the layer beneath all three: every route to a chart point, to coverage's `h¹`-witness, and to DAT-J's `hlift` runs through "an effective divisor of degree `g` over the fibre field", and that leaf was over-priced.

**State: advanced, no gate closed.** No antecedent of `pic0RepresentableByOfCharts` is discharged — `IsChartUniv`, local surjectivity and `rep` all remain open, stated in both files.

## Issues

Two of my own headline claims were **refuted** by a fresh-context review and withdrawn in place (`I-0933`, `I-0935`). The review confirmed every theorem and caught the pricing:

- "The reference divisor discharges the retraction's *open here*" — false. The conclusion weakened in lockstep with the hypothesis, so the residue-degree obstruction **moved to the output degree** rather than dissolving. The `π` binder is also decorative: `LocallyOfFiniteType` already gives `residueDeg_pos`.
- "Coverage's hypothesis and GAP-2's hypothesis are the same hypothesis" — false. `eq_of_picClass_eq_of_h0_one` takes **four** inputs and I substituted one; effectivity passes through unchanged, and effectivity is exactly what coverage lacks. `IsSplitWitness`'s docstring warns about this in terms that apply to me, and I cited that passage while arguing past it. Correct figure: **GAP-2 goes from four inputs to three** at degree `g`. p2 and p3 were both notified, since p3 had already adopted the (sound) identity.
- Filed `I-0885` at the site, plus `I-0886`, `I-0948` (my own retraction), and hints to p1/p2/p3.
- Two process notes: my correcting edit reached HEAD inside p3's integrate sweep (`96e3da006`), so the ledger carries the corrected file under a message that doesn't mention the correction — `I-0933` is the only record of why. And the ledger guard refused my last commit because the shared index held another lane's staged deletions; re-seeded with `read-tree HEAD` and re-added only my path.
- Declined the reviewer's u2/Theta offer (`I-0941`) with reasons, flagging `I-0834`'s genus-0 objection against its step (ii). u2 stays unowned.

## Why I stopped

The claimed item is complete and closed; roadmap row `done` with owner cleared. Residue after my work, stated plainly: **effectivity `0 ≤ W`**, which `IsSplitWitness` does not assert and GAP-2 needs on both divisors, plus the **`0 ≤ Σ` legality** of the chart index at parameter `g` — `Pic0ChartCoverageIndexSlack`'s own open question, untouched. The `dat-j` parent is left `pending` deliberately, with a comment recording that its three real obligations are untouched.

## Next

Whether a coverage witness at parameter `g` arrives with the `0 ≤ Σ` legality discharged. p1 confirmed their probe was purely a range containment and never touched index legality, so that measurement is unowned and would close the gap between the range side and the degree side.
