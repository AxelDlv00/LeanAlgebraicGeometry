Cleanup pass complete. Here is what I found, changed, and deliberately left.

## The headline: this warning cannot be cleared by cleaning, and five passes before me already said so

Your inbox warning is structural, not backlog. I measured the arrival rate rather than just the total:

| | start of my pass | end |
|---|---|---|
| store open, non-protection | 55 | 63 |
| open `memory` | 21 | 28 |
| CLI-visible open | 41 | 47 |

**Fourteen items arrived from other lanes while I worked** (I-0543 through I-0556, from `ajc-rr`, `ajc-pic0av`, `ajc-fbc`, `ajcr-w5-av`), each a substantive unresolved finding. I archived two. At eight live lanes running fresh-context reviews *designed* to produce findings, a janitor pass makes the number go up — that is arithmetic.

Note the store/CLI gap (63 vs 47): the CLI cannot see 16 open items. That is the already-filed filter defect (I-0505, I-0489), and it means no cleanup pass can fully reconcile the warning against what it can read.

## What I changed

**Inbox — 2 archived, 6 items given verified comments.**

- **I-0437 archived** (B3 headlines fire at no datum). Resolved at HEAD: `Adelic.instHasRigidPushforwardOfCurve` at `RigidPushforwardGammaBaseChange.lean:256` is a real instance for every curve with the three challenge hypotheses. Its `FiberH1Vanishing` observation still holds — no producer at HEAD — but the discharge routes through the Γ-base-change identity, not fibrewise H¹, so a producerless predicate nobody needs to produce is not a defect.
- **I-0552 archived into I-0509**, with its arrival-rate rule preserved as a comment. It was filed 20 minutes before my pass by the run-0074 janitor and reached I-0509's conclusion for the inbox cap; two persistent memories for one lesson.
- Re-verified and commented (all left open): **I-0501** (both main projects lack `hgraph/config.yaml`; I extracted the exact two-line fix from `sync.py:load_config` but did not write it — arming sync would land I-0472's phantom nodes in a frontier eight lanes read), **I-0539** (`exists_affAdaptation` and `isCertifiedAff_of_deg` still zero hits), **I-0144** (both `overSpecMap` variants still present), **I-0538** (the picrep decision now has no live addressee), **I-0509**.
- **Filed I-0556** — a memory on the divergence I found in the workspace's own shape: ninety inbox comments dated today identify as janitor/hygiene passes. The advisory caps are workspace-global, so one warning dispatches one janitor per lane, and runs 0067/0068/0072/0073/0074 each independently re-derived the same liveness cross and reached the same verdict four times running. Three passes filed the same structural conclusion as new items (I-0387, I-0551, I-0552). The rule: read an item's recent comments before re-triaging it, and answer a global warning by naming the pass that already answered it.

**Docs — committed as `8c81984fd`, plus AJC README changes that another lane swept into `931edf36b`.**

The AJC README's axiom-frontier section described a state two decisions old. It named `instHasPicScheme` and `pullback_preservesFiniteLimits` as the two sorry-bodied instances leaking through synthesis; **neither is an instance at HEAD**. `instHasPicScheme` no longer exists, and the flat-pullback sorry now sits in the named theorem `pullback_preservesMonomorphisms`. The one remaining synthesis leak is `instHasPicSchemeEt`, whose body cites `fgaPicardRepresentability`. The Navigation entry also still listed `Pic0Et.smooth`/`proper` among the five obligations, which the same file's body corrects to `geometricallyReduced`/`universallyClosed`.

I also trimmed two long duplications to pointers (the eight-mode axiom-cleanliness catalogue → I-0442, the leanok-audit post-mortem → I-0483), and added a warning box: **I-0545 reports that audit's positive control has gone stale**, so its published "zero proof-level defects" currently proves nothing. Leaving a clean verdict standing unqualified would have been the misleading option.

Counts re-derived, not copied: AJC 210 modules / 140,213 lines / 28 sorry terms in 11 modules / 81 bare-Mathlib imports; AJCR 663 files, 594 reachable, 69 unrooted, 17 sorry terms in 3 modules (the third carrier, `Picard/DivRepAffPullClause.lean`, was unnamed in the snapshot).

`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/README.md`, `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/README.md`, `/home/axel/LeanAlgebraicGeometry-Horizon/roadmap.md`

## Your three roadmap warnings

**`AJC.jacobian.assembly` — intended state, preserved, and I strengthened the trace.** I did not touch its status. Its *summary*, though, was stale in a way that undercut the very reasoning you asked me to protect: it still listed `Pic0.smooth`/`Pic0.proper` as obligations and a "LEAF A (rational point)" as a distance to close — a statement I-0491 clause 1 says is false and must be deleted, never proved. I rewrote the summary to the five post-decision obligations and made the deliberate mismatch explicit in capitals ("THIS ITEM STAYS OPEN WITH ITS ONLY CHILD DONE — that status mismatch is deliberate and must not be 'fixed'. The parent is the assembly step, not a container"). The distances to leaves B and C, and the I-0446 retraction, are kept verbatim. This is a row owned by `ajc-etale-pic`, now `done`; flagging clearly since it is not mine.

**`AJC.picrep` done over three pending children — recorded, not touched.** I commented on I-0538 rather than acting. Worth knowing: I-0543 has since established that this `done` was **not a decision at all**. It propagated automatically from `ajc-etale-pic`'s terminal task status into all four rows of its `roadmap_refs` at 06:04:16 — the same mechanism that overrode `AJC.jacobian.assembly` three minutes after that lane wrote down that it must not close. So the "parent is premature" reading now has the strongest evidence, but reopening it is a route decision (the etale rewire may genuinely bypass Quot/Serre/tensor) and not a hygiene call.

**17 active rows — all legitimate, zero orphans.** Fifth consecutive run of I-0509's liveness method: 12 held directly by a running lane, 3 the `AJCR.w4-rep → .datum → .dat-d → .ddr` spine above two live leaves, and `AJC.jacobian`/`AJCR.jacobian` the two permanently-active north stars. `AJCR.w5-av.t4` is unowned but is live `ajcr-w5-av`'s worksheet-first row. Nothing should be demoted.

Also present and left alone: **task queue at 13 vs cap 12** — 8 running lanes plus 5 queued (`T16`, `rebuild`, `ajc-optimize`, `ajc-truth`, `ajcr-w4-rep-free`). Every queued task points at roadmap rows, and I-0386/I-0543 document that a terminal task status silently rewrites those rows. Retiring one to hit the cap risks corrupting a live lane's critical path, so I left all five.

## What I deliberately left, and why

- **I-0491 and I-0074** — standing protections, untouched.
- **I-0493** — the human-owned AJC team thread. I had to open it (your commit hook blocks on unread conversations), so **it is now marked read for the `ajc-albanese` team**; four new replies had landed, latest being `ajc-rr` flagging that `ajc-pic0av`'s `CurveDivisorIndexBridge.lean` landed in `RiemannRoch/`. Not archived; closure is the human's.
- **I-0506, I-0507, I-0539** — one R2 finding at three depths, all three kept. `ajcr-cert-r2` is live on exactly this lane, and the siblings carry line-level evidence (`DivSchemeCertZarSep.lean:84-135`) that I-0539 does not restate. Collapsing them mid-flight would take evidence from the lane holding the work.
- **I-0511, I-0514, I-0515, I-0531** — verified still live at HEAD. `def divRepPull` still absent; the nine advertised chart declarations still grep to ≤2 hits; `Scheme.one_le_coheight_of_ne_genericPoint` still declared twice (`Milne33TransportLocal.lean:66` and `RiemannRoch/WeilDivisor.lean:149`).
- **I-0220** — `RelCurveCollapse.lean` still 752 lines against a 500 limit, 15 files over. Unchanged since filing; AJCR source, not mine to split.
- **I-0354, I-0365, I-0367** — already scoped to `ajcr-w4-rep-free`'s private inbox by an earlier pass; correctly invisible to AJC lanes.
- **I-0489, I-0502, I-0505, I-0543, I-0546, I-0551** — all `--to human`, awaiting decisions only a human can make.

One process note worth flagging: `inbox comment` has **no `--agent` flag** (it is `--author`), and rejects agent comments over 1200 characters. Three of my comments were rejected on length before I trimmed them; in one case the `archive` in the same command line had already succeeded while the comment failed, so I-0437 was briefly archived without its explanation. I backfilled it. Worth knowing before a pass batches archive-plus-comment.
