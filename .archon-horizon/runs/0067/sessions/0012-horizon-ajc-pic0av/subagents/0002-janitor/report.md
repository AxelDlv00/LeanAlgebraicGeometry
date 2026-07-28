All four archives landed on disk; every standing protection and every human-addressed item is untouched. Here is the pass.

## Answers to your four warnings

**1. Roadmap active count (18 vs 8) — I-0509 still applies, verified not assumed.** I probed all eight `runs/*/process.json` pids with `kill -0`; all eight alive (`ajc-pic0av`, `ajc-fbc`, `ajc-albanese`, `ajc-rr`, `ajcr-cert-r2`, `ajcr-divrep`, `ajcr-charts`, `ajcr-w5-av`). 10 rows held directly, 7 active ancestors. **But the recipe as written flags one spurious leftover, `AJC.fbc`**: it has `owner: None`, yet live task `ajc-fbc` lists it in its `roadmap_refs` and its child carries `owner: ajc-fbc`. Cross on the **union** of `metadata.owner` and live tasks' `roadmap_refs` and the leftover is zero. Recorded as I-0509 C-0009 — this is the eighth consecutive "all legitimate", now with the method fixed.

**2. AJC.picrep / .tensor — the human route call has NOT been answered.** `I-0640` and `I-0605` both have **zero comments**, and there is no human-authored comment anywhere in the store after 12:00. Two of three children were resolved by `ajc-rr` at 14:54 (`.quot`/`.serre` → `rejected`), so the warning shrank from three children to one. `.tensor` is genuine open work ("prove the canonical pullback tensor comparison is an isomorphism…") under a `done` parent — exactly the question awaiting the human. Recorded as I-0638 C-0003; I touched no picrep row.

**3. AJC.jacobian.assembly — artefact, not a completion.** I checked the five obligations its summary names; all five exist as open statements at HEAD (`fgaPicardRepresentability` at `FGAPicRepresentability.lean:339`, `Pic0Et.geometricallyReduced` at `Pic0Et.lean:170`, `universallyClosed` at `Pic0AbelianVariety.lean:1326`, and the two leaves at `Jacobian.lean:407`/`:524`). The row's own summary states the mismatch is deliberate and must not be "fixed" — the parent is the assembly step, not a container. **I changed nothing on this row** (it is not yours either). The warning is the CLI's parent/child heuristic misreading a legitimate state.

**4. Inbox counts — I-0641/I-0551 hold.** Non-protection open **113 → 114**, memory **62 → 64**. I archived 4 and the fleet filed 7 during the pass (I-0650…I-0656). No standing protection archived.

## What I changed

- **Archived 4, each with a verification comment first** (per I-0609, state change then comment): **I-0532** (`degree` is a real definition at `IdentityComponent.lean:1702`, false clause retracted at both named sites), **I-0635** (superseded by I-0651 — `cech_flatBaseChange_oneLeaf` landed, residue went 2 sorries → 1), **I-0585** (correction landed at both `GroupSchemeSmoothAlgClosed.lean:50-66` and `Pic0AbelianVariety.lean:1164-1178`, and turned into the theorem `geometricallyReduced_of_isReduced_algebraicClosureBaseChange`), **I-0589** (superseded by I-0627, same lane, same finding, three hours apart).
- **Commit `99a9745e1`** (survives at HEAD, verified after two later commits): retracted the `topologicalKrullDim` pricing in `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/hgraph/nodes/40f8673046ce.md`, which still carried the whole paragraph your `5dca5e7cc` retracted in the Lean source — the I-0616 pattern at graph scale. Also re-measured the AJC README counts (257/153,196 → **264/155,729**).
- **I-0656** (new `[persistent]` memory): the stale-index repair method.

## The thing worth your attention

`I-0654` (from `ajc-rr`) warned that one file of yours was armed for silent revert. **It was five, and I repaired all five.** Crossing `diff --cached HEAD` against `diff HEAD` per path separates armed (index stale, disk matches HEAD) from another lane's live work (both differ): 9 stale entries, 5 armed, 4 not.

Armed: `Picard/Pic0Dimension.lean` (−13, yours), **`scripts/axiom-frontier.lean` (−16, the standing measurement record)**, and 176 lines across three AJCR worksheets (`spec-dd-r.md` −87, `w5-t4-worksheet.md` −61, `protocol-concurrent-lanes.md` −28). Cleared with `git reset -q HEAD -- <paths>` — non-destructive, touches no working file. Note for your own discipline: a private-index CAS commit is safe for *your* commit but leaves the shared index armed, and **your newly-landed files then join the armed set** — I had to clear my own two after committing.

## Your boundary maintenance

- **4 commits verified**, one file each, no probe files: `b9bfa997f`/`476236c3b` (`Picard/SchemeKrullDimStalk.lean`), `b653ef4d6` (`Picard/Pic0Dimension.lean`), `5dca5e7cc` (`Picard/IdentityComponent.lean`).
- **No probe file of yours reached HEAD.** `ls-tree HEAD` over the project returns only `scripts/axiom-frontier.lean` (legitimate). The 18 probe files on disk — including your `probe_pic0dim_r5.lean` — are all matched by `.gitignore` (`check-ignore` confirms both the `*Probe*.lean` and `/probe_*.lean` rules fire). Both `scratch_pic0dim*.lean` are gone.
- **Roadmap summaries landed intact, not truncated:** `AJC.pic0av` 1,910 chars / 30 lines, `AJC.pic0av.identity` 2,237 / 36, both ending on complete sentences and both naming the r5 commits.
- **`AJC.rr.principal` is still `done`, pin intact:** `pinned_commits: [8b654f78d, 768b6cbd4]`, both resolvable in the ledger, `owner: ajc-pic0av`.
- **Comments confirmed on disk:** I-0493 C-0089/C-0091/C-0094 (yours; C-0090/C-0092/C-0093/C-0095 are the sibling lanes), and task comment `ajc-pic0av/C-0009` at 16:25.

## Open items your work resolved that I left open, deliberately

**I-0587 is the live one and I kept it open with the concrete next action** (comment added). Your two valuative theorems are correct at `Pic0AbelianVariety.lean:1377`/`:1403`, but the finding is about the *docstrings* and they still overstate: `:1341` says the route "needs no quasi-projectivity vocabulary at all" and `:1400` says it "replaces that residue". `grep interprovable` over the file returns two hits, both the `geometricallyReduced` correction at `:1173`/`:1222` — **nothing at the valuative site**. Mathlib carries the criterion as an equality (`UniversallyClosed.eq_valuativeCriterion`), so `Existence` and the open `universallyClosed` sorry at `:1326` are interprovable given the already-proved `QuasiCompact`. One paragraph, in the shape your file already uses at `:1164`.

Also left open, correctly: **I-0531** (the duplicate `Scheme.one_le_coheight_of_ne_genericPoint` is still live — `WeilDivisor.lean:163` and `Milne33TransportLocal.lean:66`), **I-0533**, **I-0535**, **I-0627**, and **I-0645** (`audience: human`, outage repaired and verified — mathlib at `fabf563a7c9`, 8,176 oleans — but a prior pass deliberately left it for the human).

I did not start a competing build.
