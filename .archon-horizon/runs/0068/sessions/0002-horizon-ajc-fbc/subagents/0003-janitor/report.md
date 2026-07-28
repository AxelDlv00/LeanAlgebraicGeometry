Hygiene pass complete. Here is what I found and did.

## Counts, before → after

| Measure | Start of pass | End of pass |
|---|---|---|
| Inbox `list` items | 42 | 42 |
| Inbox `list` warnings | 2 (26 memory, 40 non-protection) | **none** |
| Store open (ground truth) | 66 | 60 |
| Store non-protection | 62 | 57 |
| Store memory | 31 | 24 |
| Roadmap active | 15 | 15 (deliberate — all verified live) |
| Open tasks | 14 | 13 |

The `list`-visible count did not fall because nine of my archives were items `list` cannot see (see the filter defect below), and because six other lanes filed 13 new items during the pass. The store is the number that moved.

## Archived, with reason

- **I-0528** — exact duplicate of I-0527, same lane, two minutes apart. Diffed the bodies: differences are typographic. Kept the earlier id.
- **I-0523** — resolved. Said the etale rewire lived only in the working tree; commit `c71ce05b8` carries all three AJC seam files with a matching diff, and both of its HEAD probes now come out the other way.
- **I-0524** — fixed. The dropped `[HasPicSchemeEt C]` binder is restored at `Picard/Pic0Et.lean:81-86` by commit `91fc0017f`. I did not re-run the axiom probe (needs a build of another lane's file) and said so on the item.
- **I-0504** — conversation concluded; both participants said so, README and roadmap fixes landed.
- **I-0518** — consolidated into I-0522 (same incident, two angles, 6 minutes apart). Preserved its two unique contributions: why the inline caveat failed to prevent the overstatement, and its two cheap checks.
- **I-0481** — consolidated into I-0505, its own escalation. Re-measured the filter while doing so.
- **I-0372** — the human answered it (`C-0006`, etale-sheafify); the decision lives on as protection I-0491, and I verified all four clauses at HEAD.
- **I-0387** — superseded. Its thesis (caps unreachable at this scale) is right but its numbers are stale and the actionable half moved to I-0505.
- **I-0521** — the review it asked for happened: I-0541 confirms all three checks pass at source. Noted that this is *not* a clean bill of health for the lane (I-0506/0539/0540/0542 stand).

## Left deliberately

I-0491, I-0074, I-0492 (protections); I-0493, I-0494, I-0495 (human-started threads); I-0502, I-0505, I-0489 (open requests for human decisions); I-0510, I-0511 (unanswered DMs to a live lane); I-0083, I-0220, I-0319, I-0437, I-0441, I-0472, I-0501 (still-true findings — I refreshed I-0083's inventory rather than archiving); all persistent memories; every item filed by a live lane in the last hour.

## AJC.jacobian.assembly verdict

**Do not mark it done, and the warning should stay.** More importantly, I found why it changed: at `06:04:16` task `ajc-etale-pic` was set `done`, which silently rewrote all four rows in its `roadmap_refs` — including flipping this node to `done` three minutes after its owner wrote on I-0493 *"I own AJC.jacobian.assembly and I am NOT marking it done."* That is the I-0386 gotcha, third occurrence, and the memory's mitigation cannot work here because a task's terminal status is its last action.

I restored it to `pending` with a roadmap comment. I verified the owner's reasoning independently: `picardJacobianWitness` carries `sorryAx` through five open obligations, and the sorry counts are 3 in `Picard/Pic0AbelianVariety.lean`, 2 in `Picard/Pic0Et.lean`, 1 in `Picard/FGAPicRepresentability.lean`, 3 in `Picard/IdentityComponent.lean`, 4 in `Jacobian.lean`. Two lanes independently proposed the same real fix — add the five obligations as child rows — which is another team's subtree, so I reported it rather than doing it.

`AJC.picrep` was flipped by the same event and now warns for three open children. I left it: whether the Quot lane is retired or paused is a route decision. Run 0074's janitor had already raised it with the right owner as I-0538.

## Active roadmap: all 15 legitimate

Eight rows held directly by a running task, seven active ancestors of those (the `AJCR.w4-rep → .datum → .dat-d → .ddr` spine accounts for four on its own). **Zero stale-active.** The 13→15 growth is two new lanes claiming their spines. Recorded on I-0509, adding one refinement to its method: walk descendants, not just immediate children, or `AJC.jacobian` gets mislabelled stale.

## Filed

- **I-0543** (issue, to human) — the task-status/roadmap propagation defect, with the live evidence and three suggested fixes. The propagation already writes a `synced from task …` note into roadmap history but prints nothing, so surfacing it is cheap.
- Cross-referenced it to I-0538 so the two do not get merged; they divide cleanly into "what the subtree should say" versus "the tool overwrote a decision."

## Docs fixed

`/home/axel/LeanAlgebraicGeometry-Horizon/roadmap.md` — corrected six stale counts against the tree (AJCR 17→16 sorries in 2 of 656 modules; AJC 202→204 modules, 191→193 sorry-free; umbrella imports 66 of 185 → 77 of 204; heartbeat overrides 199→200); rewrote the Final-Jacobian-witness bullet, which still described assembling a witness that is already built and did not mention the binding I-0491 decision; added the R2 landed-but-unmigrated state to Wave 4 and removed its self-contradicting "live gate" phrasing.

`/home/axel/LeanAlgebraicGeometry-Horizon/README.md` — added the arbitrary-base-field/étale-sheafified statement to the AJC route description. All relative links resolve.

## One thing worth your attention

The inbox filter defect is worse than reported: **21 of 60 open items are invisible to `inbox list`**, up from 5 when first filed. Hidden right now are protection I-0492 (a *binding* constraint), and two of the four live coordination threads (I-0494, I-0495). The pattern is that an item with an empty audience but a `scope.projects` naming another project is hidden — scope appears to be read as audience. Practical consequence: no janitor pass driven by `inbox list` can reconcile the health warnings, which is why I worked against the store directly. Measurement is on I-0505.
