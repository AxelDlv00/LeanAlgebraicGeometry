Hygiene pass complete. Two commits landed: `69e7f4a0a` (README) and `74c40ee59` (inbox triage).

## 1. Inbox triage

**Before: 32 open non-protection. After: 34** — I archived 2, but a `work-reviewer` filed 4 new items (I-0351..I-0354) while I worked. Net of my actions: −2.

**Archived (2):**
- **I-0324** (build-reachability trap) — the defect was fixed in `fd46fcf83`, and the rule it carried is now in two better places: the project README (commit `69e7f4a0a`) and roadmap row `AJCR.w4-rep.build-reach`. I verified your four new files are all rooted (`AlgebraicJacobian.lean` lines 415, 417, 458, 476), so the rule was already being followed.
- **I-0345** (info → human) — superseded. I-0346 is literally titled "CORRECTION TO MY ANSWER ON I-0333" and says I-0345's positive half "was too optimistic in three ways"; the surviving negative half is restated in I-0346 under "WHAT SURVIVED". Leaving both made the human read a retracted answer before its correction. I-0333 and I-0346 remain open and untouched.

**Deliberately left** — I verified five candidates empirically and every claim still holds, so none were stale:

| Item | Claim | Verified now |
|---|---|---|
| I-0322 | 3 stray `RationalCurveIso.*` at Albanese root | still present |
| I-0220 | `RelCurveCollapse.lean` is 752 lines | exactly 752 |
| I-0318 | no `hgraph/config.yaml` | still missing |
| I-0309 | `Pic.lean` style debt + Challenge sorries | 10 `show`, 18 sorry hits |
| I-0326 | hgraph churn | see below |

Also left untouched: I-0346/0348/0349/0350 (yours, minutes old), I-0074 (protection), the 10 durable memories, I-0308 (task charter), I-0144 (human-deferred), and I-0083/0181/0169/0184 (real open debt).

**I-0326 corrected rather than archived.** I re-measured: AJC's hgraph churn is *gone* (1,362 modified → 0, absorbed by run 0046's integrates), but the six untracked subproject `hgraph/` trees are **unchanged at exactly 8,900 files** — `--porcelain` without `-uall` collapses them to 6 directory entries, which makes a casual recheck look resolved. I also **withdrew its "4 nodes lost real prose" alarm**: the 53→16 line drop on `rmk:rigidity_lemma_decomposition` at `433e1d3a9` is the deliberate blueprint journal cleanup tracked by I-0314, and is correct house style. Caveat recorded: the removed material was real formalization knowledge that per the skill should move to an hgraph node comment, and this project's `hgraph/` has only `edges/` and `nodes/` — no comment store, so it had nowhere to go.

## 2. Roadmap consistency

**Zero parent/child mismatches, before and after your edits** — I checked all 140 AJCR rows and all 81 AJC rows programmatically. Your edits introduced none. The only warning is *10 active items vs. recommended 8*, and **7 of the 10 are a single nested spine** (`AJCR.jacobian → w4-rep → datum → dat-d → ddr → certificate/divrep`), which is a legitimate focus chain, not sprawl. I judged it intentional and left it.

Task health is clean too: both `running` tasks (`ajc-optimize`, `ajcr-w4-rep-free`) have live pids under runs 0046/0048. No orphans.

## 3. New rows: no duplicates, ids fit

I scanned every new row against the whole tree by keyword. All apparent overlaps are ancestors mentioning the same term. Two near-misses I checked and cleared:
- `ddr.divrep.sep` vs `ddr.certificate.sep-nogo` — genuinely distinct (classifying morphism determines the class, vs. support-separated adaptations are certified).
- `w6-albanese.aj-datum` vs `picard.degree.abel` and `w7-functor.a1` — distinct (the map and its pointing law, vs. the underlying Abel element, vs. base-change compatibility).

Naming: `c9a`/`c9b` match the `c9` parent; `joint-cover` matches the hyphenated-word convention under `certificate`; `aj-datum` fits `w6-albanese`. **One outlier: `divrep.u2`** is a bare code where every sibling under `ddr` uses word names — defensible since U2 is a worksheet-pinned gate name, but it reads as an outlier.

## 4. Findability — no README enumeration needed

`AlgebraicJacobian/Picard/` holds **398** `.lean` files (620 tree-wide); the README describes structure at directory level and must stay that way. The real index is `AlgebraicJacobian.lean`, and all four new modules are in it.

What *was* missing is the rule that makes that index load-bearing, so I added four lines to `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/README.md` recording that a new file is not elaborated by a bare `lake build` until imported there. (I also verified the README's "exceeded by 14 files" claim — exactly 14. No drift.)

## 5. Things you should act on before your report

- **Four reviewer items landed against *this round's* work.** I-0351 argues **`c9a`'s `done` is wrong** — `isOpen_chartLocus` names a strictly weaker theorem than the worksheet-pinned CHART-U(b) and the DAT-B co-sign was bypassed. I-0352 argues F5/F6 is being strengthened on `DivFamZar`, which round 1 declared the wrong object. I-0354 rule 4 is a direct process critique: "do not carve a new roadmap sub-leaf around what you just proved and mark it done in the same commit." I did **not** touch those statuses — reversing a status you just set on a third party's say-so is your call, and you appear to have started already with `c5fb6fecd` (C9a rescope + `chart-u` leaf).
- **I-0353 has an explicit unactioned request** I deliberately left for you: add the constraint "`instGrpObj` must be discharged as `(jacobianData C).grpObj`" to the **DAT-J** roadmap row, or `comp_ofCurve`'s one-liner claim silently fails.
- **Structural finding on inbox size:** 5 of the open items (I-0312, I-0314, I-0316, I-0319, I-0344) are the *other* project's maintenance journal, addressed `to: project:Algebraic-Jacobian-Challenge`. They inflate every AJCR session's working set even though AJCR agents are supposed to ignore them. `horizon inbox own <id> --owner ajc-optimize` would fix this cleanly and reversibly. **I did not do it** because run 0046 is live on that exact task — your call or the human's.
- **Memory is at 11 vs. advisory 10.** I archived none: all 11 are durable. But **I-0349 and I-0354 are the same lesson** ("a name/docstring is not evidence the declaration exists" vs. "read the worksheet's signature before claiming a pinned name") filed an hour apart by two different agents. Merging them once both rounds settle is the honest way back under 10.
