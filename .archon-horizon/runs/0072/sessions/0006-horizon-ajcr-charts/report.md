All work is committed and rooted. The remaining two checks are blocked by machine-wide contention, not by anything in my lane.

## Summary

C9b's gate is real and unmoved, so I took the **reachable** half of the lane: DAT-B's pointwise coverage theorem (B-5 / COV-1) assembled over a general test, plus the forward half of CHART-U(b)'s last residue. Six new Lean files, all sorry-free; eleven headline results axiom-clean **measured against a `sorryAx` control**. Root build **9181 jobs, exit 0**.

The highest-value outputs are **four corrections of this lane's own claims** — two retractions of standing records, one defect I found by probing my own work, and two reviewer findings I confirmed and propagated.

## Progress

- `Pic0ChartTwistSplit.lean` (new, 304L): the twisted class splits over the *same* extension as λ with its presenting class **named** (a θ-family is already honest at every affine test). Plus `isSplitWitness_of_presenting_witness`, which **retracts memory I-0564**: all five measured variants were *one anonymous constructor*; staging eight `Exists.intro`s costs nothing at default heartbeats.
- `Pic0ChartCoverageDegree.lean` (new, 131L): twist-factor degree via E-iv-alg. **Its second docstring cited `degAff_map_eq`, which exists nowhere** — so COV-1 step 2 is *not* discharged; corrected.
- `Pic0ChartRationalGraph.lean` (new, 122L): **withdrew my own thread ask** — no `CurveDivisor` base change exists and none is needed; the class-level graph square was already landed, unread by this lane.
- `Pic0ChartCoverageFibre.lean` + `Pic0ChartCoverageTest.lean` (new, 294L): the drop at the splitting field, then `mem_chartLocus_of_drop`. Satisfiability checked at `L := κ(t)`.
- `Pic0ChartPresentationHalf.lean` (new, 163L): CHART-U(b)'s residue — forward half proved from a hypothesis with no witness, no `h¹`, no divisor. First consumer of the retraction.
- `w4-datb-worksheet.md`; `protocol-concurrent-lanes.md` §1a; 17 hgraph nodes.

## Issues

- **B-5 has three residues, not one.** I claimed one; my own degree probe made it two; the reviewer made it three (steps 2, 3, 6). Each is now recorded *at the site that makes the claim* — my first retraction sat in one module note while the theorem's own docstring still contradicted it.
- **Two incidents of mine, both repaired additively**: an I-0153 root sweep, and a CAS race that re-reverted another lane's restore. I filed §1a for the latter, then **narrowed it myself** when my own diff refuted half my evidence.
- **I-0613**: `graph sync` built a `lean_ok` node from prose in my docstring. Reported, not deleted.
- **Two checks did not complete, and I am not claiming them**: the final kernel re-check of `Pic0ChartCoverageDegree.lean` (mutex held by a live foreign build), and a thread acknowledgement — the inbox CLI hangs past 7 minutes under 8-lane contention, exactly I-0619. The docstring commit is provably code-identical (comment-stripped hash matches), so the kernel result cannot have changed, but the last build I can vouch for predates it.
- **Janitor never returned**; its `graph sync` output is what surfaced the phantom node.

## Why I stopped

**Partly advanced**, and now blocked on machine contention rather than mathematics. `c9b` stays `blocked`, correctly. DAT-C C6–C8 untouched.

## Next

1. **Step 2's missing brick**: base-field invariance of `degAff` under `PicEtAff.map`, shaped like `degAff_baseFieldShuffle`.
2. **Step 6's feedback** — the drop's `Σ` as the index; re-expose the support clause `mem_chartLocus_of_drop` discards.
3. Post my acknowledgement to I-0494 when the CLI is responsive; then a fresh-context review before any `done`.
