Hygiene pass done. Three items closed, three cross-link notes filed, roadmap question answered without touching the row.

## What I archived/completed

- **I-0384** (memory) → archived as a near-duplicate of **I-0460**. Both answer "can AJCR's Riemann-Roch lane port into AJC?" with the same verdict (not portable, rederivation only); I-0460 is strictly better — it surveys all three cluster-P items, names the AJCR declarations it checked, and establishes the sharper fact that AJCR proves extension uniformity only at $D=0$. The two findings unique to I-0384 (the "adelic form is sometimes cheaper" asymmetry, and that extension uniformity in AJC is not yet *statable* because no base-changed cover exists) are copied into I-0460 as a comment first, so nothing was lost. This is the only memory I touched.
- **I-0443** (conversation, `ajc-gate`) → concluded and closed. Its sole addressee is a `done` task with no live run, so it has no reachable recipient; it was an announcement, not a decision request; and its content was consumed by `ajc-truth` and folded into I-0442/I-0412. I passed `inbox complete`, but the CLI records the result as `archived` — worth knowing that `complete` and `archive` land on the same on-disk status here, so "keep it visible in the resolved record" is not actually achievable via that flag.
- **I-0448** (conversation, `ajc-truth`) → archived. The audit request `ajc-rr` filed was answered in full, then corrected by the answerer; the residual work has its own live homes (I-0453 for the docstrings, I-0449 for evidence, I-0463 for root imports). Leaving it open would duplicate I-0453's action item.

Nothing else was defensibly closable. I checked the old issues at source rather than trusting their prose: I-0083's three FBC sorries are still live (`CechHigherDirectImageUnconditional.lean:162`, `:1634`, `:1705`), I-0220's `RelCurveCollapse.lean` is still 752 lines, I-0144's duplicate `overSpecMap` pair still exists at both sites, I-0181's Stacks `07BV` citation is still in `CodimOneStalkRegularity.lean:74`. I-0387 is a standing complaint that these very caps are unreachable at this workspace size — which my numbers below support.

## Open conversations and why each stays

- **I-0453** (`ajc-truth` → `ajc-rr`) — pending on *you*: repair five docstrings that publish a false cost for `hbump`. Left open per your instruction and because it is the live action item; your correction posts here.
- **I-0463** (`ajc-rr` → `ajc-truth`) — pending on `ajc-truth`: add `Adelic.ChiUnconditional` and `Adelic.UniformChartVanishing` to the root roll-up, which `ajc-rr` cannot edit. Also carries your I-0449 correction.
- **I-0464** (`ajc-rr` → `ajc-gate`) — pending on `ajc-gate`, which is a `done` task with no live run. Structurally unanswerable, same defect as I-0443; I left it open because it is 20 minutes old and its recipient may be relaunched. If it is still open next pass it should be re-kinded to `info`.
- **I-0391** (human → all three teams) — human-started, so closure is the human's. Nine team reports so far; `ajc-rr` owes this session's findings.

**I-0449 and I-0456 were already `archived` before I started** (both at 20:07–20:10, by the run-0054 janitor). They remain fully readable and I touched neither. Your corrections can still reference them, but be aware they will not show in a default `inbox list` — if you want them visible while the correction is live, consider `unread`/re-filing a pointer rather than assuming a reader lands on them.

## Roadmap finding: AJC.jacobian.assembly

**Marking it done would be wrong. Something genuinely remains, and I verified it at source rather than from the item's prose.** In `Picard/Pic0AbelianVariety.lean`, `Scheme.Pic0.smooth` (`:800`) and `Scheme.Pic0.proper` (`:820`) both have `sorry` bodies (`:806`, `:826`), and `Jacobian.lean` carries three more of its own at `:303`, `:341`, `:417`. The row is "Package the final Jacobian witness"; the witness is not packaged. Its one `done` child, `reachability`, only measured what is *reachable* from the headline, which is a different claim.

The mismatch is deliberate and already documented at the row's own summary and across four prior janitor confirmations on **I-0411**. I added a fifth verification there with refreshed line numbers (the run-0053 pointers had drifted 25–110 lines) and **changed no status** — the row is outside your task's cone, as you said. The honest repair is "add what remains": child rows for the I-0372 rational-point decision, for `Pic0.smooth`/`Pic0.proper`, and for leaves B and C. `Pic0.smooth` and `Pic0.proper` belong to no task and are the nearest unowned work under the headline. Note that leaf A is a **gap marker, not an obligation** — `hasRationalPoint_of_curve` is false as stated, so it must be replaced by an owner decision, never proved.

No task warnings fire. `AJC.jacobian.assembly` is the workspace's only roadmap consistency warning.

## Duplicate clusters flagged

I consolidated none of these (all are genuinely distinct claims) but annotated them so a future session reads one item instead of four:

- **Docstring/existence-evidence cluster** — I-0349 (prose is no evidence a declaration exists), I-0439 (converse: prose saying a gate is open is no evidence it still is), I-0458 (the method — regex traps, and how grep and the graph scanner are wrong *together* on universe-binder names, per I-0452), I-0406 (blueprint `\leanok` at statement vs proof position). Read-order note filed on **I-0458**.
- **hbump lesson pair** — I-0447 (a gap can live in a quantifier) and archived I-0456 (non-vacuity is the wrong question for a hypothesis equivalent to its conclusion). Note filed on **I-0447**, including an explicit warning that the "refuted off the cover overlap" framing is under revision this session and the cluster must **not** be consolidated until your correction lands.
- **I-0461/I-0462** (filed by `ajc-truth` at 20:16) are a deliberate companion pair on the leaf-A slice, not accidental duplicates. I-0461's claim that the obligation count is five rather than four strengthens the case for leaving `assembly` open.

## Final count

Open non-protection: **42 → 44**. My actions removed 3; the live sibling run filed 5 during the pass (I-0461 through I-0465). Memory: 24 → 24 (I-0384 archived, I-0465 filed). Protection: 1, untouched — **I-0074 remains open**.

The caps are not reachable by cleanup at this workspace size while three teams file concurrently, which is precisely what **I-0387** documents. I would treat the count warning as a known-intentional condition and stop dispatching janitor passes against it; the remaining open set is load-bearing, and the next real reduction comes from teams closing their own threads (I-0464's dead recipient, and I-0391 once the human consumes it).
