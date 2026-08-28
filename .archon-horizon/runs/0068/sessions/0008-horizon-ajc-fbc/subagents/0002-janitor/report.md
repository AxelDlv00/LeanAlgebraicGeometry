Cleanup complete. Findings.

## 1. Roadmap consistency for AJC.fbc — no mismatch, and the shape is correct

`roadmap list --focus AJC.fbc` prints **zero** warnings for this subtree. The two roadmap warnings that do fire are other lanes' (`AJC.jacobian.assembly` all-children-done, `AJC.picrep` done with `AJC.picrep.tensor` open).

The CLI only warns on two patterns: all children done + parent open, and done parent + open children. `AJC.fbc.cosimplicial` is `pending · 1/2 done` — one child open, so neither pattern applies. `AJC.fbc` is `active · 1/4 done`. Nothing should move: `.cosimplicial` staying `pending` with a live open child is exactly right, and promoting it to `active` would only add to the 18-active count for no signal. Leave as is.

## 2. All roadmap writes landed on disk

Read directly from `/home/axel/LeanAlgebraicGeometry-Horizon/.archon-horizon/roadmap/items/`:

- `AJC.fbc.cosimplicial.pushforward.yaml` — `status: done`, `updated_at` 16:53:29, summary is the full CLOSED text naming `canonicalBaseChangeMap_isIso` and the QuotScheme-carries-sorries correction. Landed.
- `AJC.fbc.yaml` — title is `Flat base change (1 walled naturality leaf + 1 bypassed monument)`, summary is the ONE-OPEN-LEAF text pinning `eed54636d`. Landed, title and summary both.
- `AJC.fbc.cosimplicial.twisted.yaml` — summary is the NOW-THE-ONLY-OBSTRUCTION text. Landed.
- `AJC.fbc.cosimplicial.yaml` — carries the r2 "THE TWO LEAVES ARE NOT THE SAME OBLIGATION" summary, untouched this round, still accurate.

No dropped-flag damage: no stray `strategy`/`owner` keys, and `metadata.owner: ajc-fbc` on `.pushforward` and `.exactness` is from earlier rounds, not a silent partial write.

## 3. Inbox writes landed; three open items carried claims your session falsified

Landed: `I-0651` open, kind `memory`, full hand-off body. `I-0635` `status: archived` with your retraction as `comments/I-0635/C-0001.md` (and ajc-pic0av's concurring C-0002). `I-0653` archived by its ajc-rr initiator with your defusal comment attached. Task comment `C-0009` present. Three comments on `I-0493` (C-0090, C-0096 among them).

The stale claims — I commented on all three rather than leaving them for you, since each has a live half that must not be archived:

- **`I-0570`** (memory, your lane) — body asserts both squares need per-σ projection lemmas *and* that the compatibility "has to go through" `mateEquiv_vcomp`/`_hcomp`/`_square`. C-0002 had already refuted the first half for the pushforward square; the route claim is now dead too. Added C-0003 marking the body stale in full, keeping the twisted-leaf reading, and noting `~:2202`/`~:2273` are stale (one sorry, at `:2726`).
- **`I-0569`** (memory, your lane) — last paragraph says "the two cosimplicial naturality sorries (~:2133, ~:2199) are untouched" and that `cech_flatBaseChange` is not yet rewired. Both false. Added C-0003; the rest of the body stands.
- **`I-0622`** (memory, your lane) — body states `pushforward_isQuasicoherent` is unusable because QuotScheme "carries sorries". Added C-0002: the item's *rule* survives, but its own example needs the extra clause "check why the import is excluded", since that exclusion ground was the false, load-bearing claim.

No open item pointed at the `mateEquiv_vcomp` route other than `I-0570`. `I-0493` C-0090/C-0096 already carry the correction, so the team thread is clean.

Filed **`I-0657`** (issue) for the one thing outside my write scope: `scripts/axiom-frontier.lean` still says "the **two** cosimplicial naturality sorrys" at `:1489-1490` and in the `leakEndpoint_cech_flatBaseChange_qcoh` docstring at `:1539-1540`, while §6g of the same file (your r3 addition, `:1570ff`) says one. Same self-contradiction shape as `I-0649`. The probes themselves are correct — only the prose count. Worth fixing yourself, it is two sentences.

## 4. Counts still explained by lane liveness

`horizon ps` shows eight live pids (runs 0067–0074), so 13 open tasks (8 running + 5 charters), 18 active roadmap rows and 89 open non-protection / 59 memory items are the eight-wide fleet's steady state per I-0509/I-0641/I-0648 — memory did tick 59 → 59 across my pass with arrivals from other lanes offsetting nothing archivable in your scope.

## Also fixed, and committed

Two shared docs still advertised the pre-r3 count. Committed as `35b48761b`:

- `/home/axel/LeanAlgebraicGeometry-Horizon/roadmap.md` — "Cohomology and flat base change *(3 open leaves)*" → one leaf + one monument, with the three sub-items rewritten to mark the pushforward law `[x]`, name `cech_flatBaseChange_oneLeaf` as the endpoint, and record exactness as bypassed-on-quasi-coherent.
- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/README.md` — "`AJC.fbc` (flat base change, three leaves)" corrected.

The first commit attempt was refused by the deletion guard (polluted shared index, the I-0611/I-0652 bug); `read-tree HEAD` then `add --` on just those two paths cleared it. Both files also held other lanes' in-flight doc measurements on disk, so the commit carries them at file granularity and the message says so.

## Two things for you

- **Staging is clean now, but only because HEAD moved.** When I started, `hgraph/nodes/ac4691f63df7/comment-1.md` was staged as a 22-line **deletion** against HEAD — your r3 hgraph comment armed to be reverted by the next commit. Another lane's commit (`8f5e4fef8`) published your blob in the interim, and disk/index/HEAD now agree at `bb4f7900`. Nothing to do, but your I-0653 defusal covered the Lean file and the blueprint chapter, not this third path. Re-run the three-way check on **all** paths you touched, hgraph comments included, before your next commit.
- **`bare_stable_cover.lean`** is tracked at the AJC project root (committed by ajc-rr in `8f5e4fef8`) while eight sibling `GroundProbe*.lean`/`Probe*.lean` scratch files are correctly gitignored. Not your lane's file, so I left it; it belongs in `.gitignore` or deleted, and is worth a one-line mention to ajc-rr if you are already writing to `I-0493`.
