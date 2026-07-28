All four review questions are answered. Filed as I-0490.

## Verdict per claim

**A. The central measurement — CONFIRMED, both lines, including the domain.**

I rebuilt the extractor from scratch with a different algorithm (followed `\input` from `content.tex` rather than globbing `chapters/`; parsed environments into a full tree at *all* depths rather than top-level only; matched `\end` by searching down the stack and reporting misnesting) and a separately-written `collectAxioms` metaprogram. Exact agreement:

```
proof-level    : 1078 marks / 1073 pins = 930 public + 143 private, missing 0, sorryAx 0  [1078 nodes... identity OK]
statement-level: 1567 marks / 1560 pins = 1372 public + 188 private, missing 0, sorryAx 34 across 34 nodes
```

Domain cross-checks that would have caught a repeat of the six prior bugs: 1803 statement nodes carrying `\label`+`\lean`, 2469 raw `\leanok` tokens, 1561 distinct pins, 0 nested-deeper-than-top-level statements (so the script's top-level-only walk loses nothing), and 0 misnested/unclosed environments. I widened `ENVS` to include the abbreviated forms (`dfn`, `thm`, `cor`, `rmk`, `prp`, `lem`, `sbscor`, `ex`) as a candidate seventh bug — all 30 occurrences are inside `%`-comment source citations, so the count is unaffected. The 34/34 node-disjointness holds: `badnodes ∩ proofnodes = ∅`, and no pin carries both a proof-level mark and `sorryAx`.

The "eleven" diagnosis is exactly right. Intersecting the 34 with the probe's own 126 names yields precisely 11, and I can name the 23 that fall outside.

**B. The private-pin claim — CONFIRMED, and non-vacuous.** `#print axioms` on the control errors with `Unknown constant` (so the old "undecidable" bound really was a fact about the probe); `collectAxioms` decides all 188 with mean |axioms| ≈ 3. Exactly one private pin carries `sorryAx`, and it is the named control. Only 1 of 188 has an empty axiom set, so the lane is not silently returning nothing.

**C. The Pic0.smooth reduction — CONFIRMED, and if anything understated.** I verified by elaboration, not reading. `Over.mk (Pic0Scheme C).hom` does accept the `GrpObj` from `Pic0.grpObj C` after `obtain`, with no repackaging. `GeometricallyReduced (Pic0Scheme C).hom` fails `infer_instance` and `exact?`; `GeometricallyIntegral`, `IsReduced (Pic0Scheme C).left`, and plain `Smooth` all fail to synthesize too, so no side route exists. The claimed circularity is real — `Smooth.geometricallyReduced` at `AlgebraicJacobian/Curve/GeometricallyReduced.lean:143` is the converse and the only producer in either project (workspace search returns 10 hits; every other is mathlib base-change plumbing or the low-priority `GeometricallyIntegral → GeometricallyReduced`, which needs the unavailable hypothesis). No Cartier theorem exists anywhere in mathlib's `AlgebraicGeometry`, so the char-0 escape is not available today.

Stronger than claimed: the reduction is an *equivalence*, and I proved it sorry-free and axiom-clean at `Pic0.smooth`'s own hypotheses.

```
'GRProbe4.smooth_iff_geomRed' depends on axioms: [propext, Classical.choice, Quot.sound]
```

So "entire remaining content" is literally accurate, not merely a sufficient condition.

**D. Route/scope discipline — CONFIRMED.** All 40 project files touched lie inside the write set. No `RigidPushforward*`, no `RiemannRoch/*`, no `Picard/Pic0AbelianVariety.lean`. The only Lean deletions across the seven commits are in `scripts/axiom-frontier.lean`; no mathematics was removed. Grepping every added and removed line for `sheafif|étale|etale|rational.point|HasRationalPoint` returns nothing, so neither branch of I-0372 was chosen. The new FGA-chapter prose is grounded: every label it cites resolves, and `rem:representability_is_conditional` does say what the new sentence attributes to it.

**E. Verification honesty — CONFIRMED on every figure I checked.** `lake build AlgebraicJacobian` green, "Build completed successfully (8746 jobs)". Probe exit 0, 126 probed / 84 clean / 42 sorryAx. 26 carriers over 11 modules, and by resolving each carrier back to its declaration keyword, **exactly two are instances** (`pullback_preservesFiniteLimits`, `instHasPicScheme`) — the §2 list of 24 names matches my build output item for item, so 24 + 2 = 26 reconciles. Reachability: 98 of 187 from `AlgebraicJacobian.Jacobian`, 0 unrooted. Blueprint: two lualatex passes, exit 0 both, 0 errors, 0 undefined refs, 0 multiply-defined labels, 625 pages, 746 overfull boxes. Sync: 1941/4656/6751 with 33 pin warnings, 7 naming `TODO.` placeholders.

## The one defect I found (filed as I-0490)

The hgraph resync ran at 07:27 (commit `93feb6bf4`); `Jacobian.lean`'s leaf-B docstring was rewritten at 07:36 (commit `3b6954c3e`); no sync ran after. Re-running sync changes 21 node files — 19 timestamp-only, and 2 genuinely stale against the Lean source:

- `MainProjects/Algebraic-Jacobian-Challenge/hgraph/nodes/995dd64e229a.md` — its `docstring:` field still ends at "presupposes an obligation rather than reducing one", omitting the whole Pic0.smooth correction.
- `MainProjects/Algebraic-Jacobian-Challenge/hgraph/nodes/1993fa64db68.md` — body slice truncated before the new docstring block.

This is narrow (no published figure moves, and the 33/7 warning counts are unchanged by the re-run) but it is precisely a Lean-vs-graph disagreement, which is this task's own subject matter. Distinct from node `8b4d723fc7f5`, whose staleness is genuinely by construction and correctly documented. I reverted my own sync writes and the blueprint artifacts; the ledger and worktree are as you left them.

## Answers to the four questions

The work is converging, and this session is the first on this task where the numbers survived adversarial re-derivation by an independent toolchain. Converting the recipe into `scripts/leanok-audit.sh` with the reconciliation identity asserted *per mark position* plus a positive control is the right structural response to the six-bug history — running it, I got byte-identical output including the per-file breakdown. Blueprint, Lean, roadmap, and task status agree, with the single exception above. Durable findings are recorded where they belong (I-0487, node `44929083d4cf`, roadmap comments on both refs), not buried in prose; I spot-checked the sibling-project claim in I-0487 and `AbelianVariety/Translation.lean` does contain `pointTranslationIso` and `mem_smoothLocus_iff_of_comp_eq` as described.

Highest-value next action: run the sync with the explicit `--blueprint`/`--lean` paths and commit the two node updates, then write the report. It is one command, it closes the only disagreement I found, and leaving it means the next session inherits a graph that contradicts the Lean source on exactly the declaration this session's mathematical finding is about.

One caution for the final report, since it bears on how the Pic0.smooth result should be phrased: the axiom frontier genuinely did not move, and the honest framing is the one already in TO_USER.md and the roadmap comment — the obligation's shape changed, nothing was discharged. `Pic0.smooth` is still `sorry` and 26 is still 26.
