All committed and verified. Board and prose are corrected at HEAD.

## Progress

- **Board (the brief's known-wrong items): all already fixed by earlier rounds — verified, not redone.** `AJC.picrep` is `active` not `done`, `AJC.rr` `active`, the duplicate `sepclosed-point` row `rejected`, and the three parent/child warnings are gone (checked with `git show HEAD:`, not the worktree). `instHasPicScheme` re-confirmed absent from every `.lean` declaration position — 26 hits at HEAD, all prose. What was *not* fixed: **four rows carried stale `FGAPicRepresentability.lean` line anchors (347, 371-390, 377) that all land mid-docstring** — the theorem head is 757, the sorry 765. One of them reproduced the defect *inside the paragraph announcing it had fixed a stale anchor*. All four de-lined to declaration names.
- **`Picard/FGAPicRepresentability.lean`, `Jacobian.lean`, `Picard/PicEtSheaf.lean`, blueprint chapter: the withdrawn Zariski-sheaf reason and the withdrawn "FALSE" overclaim were still live at four sites** — including the headline file (both errors in one sentence) and the sheaf file, which asserted it of `relPresheaf` *by name*, the exact functor the correction turns on. The 2026-07-29 pass had grepped the retracted *citation*; these state the same proposition in other words. Fixed; issue I-1352.
- **The route question, answered from the source rather than the board.** Kleiman `th:main` L2155-L2166 states clause (1)'s conclusion verbatim, no rational-point hypothesis, and its proof runs the Abel map from `Div` — representable on the **Hilbert** scheme by `th:repDiv`, not Quot — descended by `lm:qt`. So the board's "the docstring's prescription is simply wrong" is right about which route AJC *chose* and wrong about what the sorry *needs*. AJC has two routes and has priced one. I-1360, board C-0044, seam docstring corrected.
- **Dead consumers: 74 legacy / 27 Et reproduced independently, blast radius newly measured at 17 of 318 modules** — narrow in count, total in route position (the whole Pic0/Albanese/Jacobian spine; the Čech/Grassmannian/Quot/RiemannRoch substrate is import-disjoint).
- **Organisation: nothing costs a lane.** `GenericFlatnessGeometric`'s `QuotScheme` import is genuinely load-bearing (declarations at :809/:811/:833 invoke `QuotScheme` lemmas), so the last standing refactor candidate should be dropped, not kept as hygiene. I-1355.
- **Delegated, not taken:** vacuity/self-projection census (I-1356/57/58) routed to `ajc-p1` and `ajc-p2`; both accepted, and `ajc-p1` went further than proposed by deleting the unused binders outright.

## Issues

**A fresh-context audit I asked to refute me found three defects in my own work this session, all corrected where published:**
1. **"Clause (1) is a theorem in the literature" was too strong.** `th:main` assumes *projective*; AJC's binders are smooth/proper/geometrically-integral. The bridge is classical and formalised **nowhere** in AJC — three sites assert it as prose. I checked the theorem's conclusion word by word and never its hypotheses. (I-1385.)
2. **I introduced a new overclaim while fixing an old one:** cited `picSharp_isSheaf_zariski_of_representableBy` for an unconditional Zariski-separatedness claim, when it carries a `rep` hypothesis and proves the converse. Third wrong citation in that slot; second from a reviewer warning someone else about it.
3. **My 27 is a lower bound** — the signature-only method this board prescribes is blind to `variable` blocks, which gate ~46 further declarations in three files (two of which say so in prose while scoring zero). Real Et-gated surface ≈73, so "27 vs 74" overstates the migration asymmetry.

Kernel checks: the three edited Lean files each `lake env lean` EXIT=0 with only pre-existing sorries. **No full `lake build` was run** — docstring-only edits, verified per-file.

The shared index holds 10 staged deletions / 1982 deletion lines at session end (19 D / 858 earlier — the counts move independently, so watching only staged-D reads as improving). All 10 verified present at HEAD *and* on disk; nothing lost. Eight commits, each through a fresh private index with pre- and post-commit checks; one hit the deletion guard correctly (stale read-tree, 29 untouched files) and one hit `cannot lock ref HEAD` — both fixed by re-seeding, never by the override flag.

## Why I stopped

Objective complete for a reviewer lane, and this is the run's last round. I proved nothing and took no prover's work. One subagent (the route lens) stalled without returning; I had already settled its central question directly from the Kleiman source, so nothing was lost, and the other returned three findings I routed to the lanes that own the files.

## Next

**The one decision for a human, filed as I-1364:** price Hilbert-vs-Grassmannian for `Div^d` before another round commits four lanes to the D′ cluster. The projectivity bridge is owed on *both* routes and paid on neither, which makes it a shared input rather than a switching cost — so the comparison is cheaper than it looks and is the highest-leverage unpriced question on this project.
