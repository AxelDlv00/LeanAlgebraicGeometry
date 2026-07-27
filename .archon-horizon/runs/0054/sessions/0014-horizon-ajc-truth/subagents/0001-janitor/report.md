My two new items pushed the count back up by 2. Net accounting is clear.

## Report

**Inbox counts (store-truth, not `list` — see the defect below)**

| | before | after |
|---|---|---|
| open non-protection | 41 (brief) → **36** (measured at my start) | **38** |
| memory | 20 | 21 |
| conversation | 3 | 1 |

My actions removed 5; I then filed 2 new items, plus 1 arrived from elsewhere. Net visible drain 36→33 on the triageable set.

**Completed** (resolved, kept visible)
- `I-0473` — the three-dishonest-`\leanok` claim. Your retraction comment was present and verified; `complete`, not archive, so the title cannot be read as a live defect. Added a conclusion comment recording the real numbers (998 marks / 1073 pins / 891 probed / 0 leaking) and that nothing is owed to the Pic0 cone owner.
- `I-0475` — Ground's three doc-vs-measurement drifts, all three verified fixed at HEAD: roadmap yaml now 126/84/42 with the 187-vs-188 denominator convention stated in-node, `README.md:39` and `:67` both 8,746, orphan node `ec8b704f9994.md` gone.
- `I-0463` — `ajc-rr`'s two asks discharged: root imports at `AlgebraicJacobian.lean:227-228`, root-path axiom measurement published as probe §6f.

**Archived**
- `I-0474` — conversation `ajc-truth` initiated to broadcast the retracted audit; closed with the withdrawal stated on the thread where it was published, and the request to `ajc-rr` explicitly cancelled.
- `I-0479` — memory, strict subset of `I-0480` (same lane, filed 6 min apart). Both payloads restated verbatim in a consolidation comment on `I-0480`.

**Corrected**
- `I-0406` — its last comment was still propagating the retracted "there were THREE" claim. Withdrew it; the memory's convention is now confirmed rather than qualified.

**Left open deliberately**
- `I-0074` — protection, never archived.
- `I-0391` — human-initiated conversation, human owns closure.
- `I-0480`/`I-0470` — survivors of the hbump family; different subjects (conclusion vs. method), both live.
- `I-0452`/`I-0472` — the hgraph declaration-regex defect. Already mutually cross-referenced with `I-0472` as designated survivor; both are Horizon tooling, outside any project write set. Not consolidated further because they are opposite faces (too strict on real names / too permissive on prose) and a fixer needs both.
- `I-0441` — 58 declarations across the three adelic modules vs 54 referencing nodes; partially addressed, not clearly closed.
- `I-0220` (500-line rule, now 14 files), `I-0181` (citation debt), `I-0083`, `I-0319`, `I-0357`, `I-0437` — real, actionable, nobody's current task.
- All 21 memories individually still live.

**(3) Roadmap — the warning is correct to leave; `done` would be wrong.** Verified at source rather than trusting the six prior confirmations on `I-0411`: `Pic0AbelianVariety.lean` has `sorry` bodies at **:806** and **:826** (`Pic0.smooth`, `Pic0.proper`), and `Jacobian.lean` has three of its own at **:318, :361, :437** — drifted from the earlier comments' :303/:341/:417, so the file moved while the obligations did not. The parent is "package the final Jacobian witness"; its only child is *reachability*, which was never the packaging. I did not flip the status and did not add child rows (shape is a scoping call for the cone owner; `I-0386`'s gotcha applies). Recorded the five remaining obligations on `I-0411` as a seventh verification.

**(4) Task queue — clean.** No warning. Only `ajc-truth` is `running` and I did not touch it. No orphaned statuses. `AJCR.w4-rep`/`T15`/`workspace-all` cancelled, `T12` failed — all terminal and consistent.

**(1) `I-0387` — I agree with the thesis, with one sharpening.** Posted my count (255 roadmap rows, 902 Lean files, ~380k lines). Added that `memory` has **no natural terminal state at all** — a durable dead end stays true forever — so the recommendation should be to stop capping memory by open count rather than merely scale it. Also noted a seventh churn mechanism: sessions 0010 and 0012 drained items and ended without reports, so real work was invisible.

**New finding — filed, and it is the substantive one from this pass**

`inbox list` returns **32** items while the warning on the same command counts **36**. The warning is right. Five open items are counted but invisible to every agent: not returned at any `--limit`, and `inbox show <id>` prints **nothing while exiting 0**.

One of them is **`I-0372`, addressed to you, scoped to this project: "DECISION NEEDED: the rational-point hypothesis, and the blueprint describing an abandoned route."** It asks whether to étale-sheafify the Picard functor or accept a theorem strictly weaker than the challenge asks, says nothing above it on the Picard path is safe until settled, and `I-0411` cites it as the blocker on `AJC.jacobian.assembly`. Every agent reasoning about the Jacobian headline is reasoning around an item it cannot read. I found it only by parsing the YAML store.

Likely mechanism: `--to human` items appear restricted to the filing team (`I-0372` filed by `ajc-optimize`, `I-0346` by `ajcr-w4-rep-free`; your visible `I-0387` was filed by `ajc-truth`). None has an `owner` set, and nothing in the `horizon-inbox` skill describes this. The other three are `-Rebuild`-scoped — arguably hidden correctly, but still counted, which is the same defect from the other side.

- `I-0481` (`--to human`) — the defect, with the measurement and the five ids.
- `I-0482` (memory, persistent) — the durable rule: reconcile a health warning's count against the store before believing either. Generalised to the pattern shared with `#print axioms` halting at 100, the `\leanok` join's restricted domain, and unrooted modules contributing zero jobs — **a tool reporting success over a domain smaller than the one it claimed.**

Corollary added to `I-0387`: those five cannot be archived, completed, or commented on by any agent, so they are a **permanent floor** under the count that no cleanup pass can lower.

**Warnings still standing after my pass**
1. `38 open non-protection (max 30)` — chosen; see `I-0387`, and 5 of the 38 are untriageable per `I-0481`.
2. `21 open memory (max 10)` — chosen; each individually live.
3. `AJC.jacobian.assembly: every sub-item is done` — chosen, seventh verification on `I-0411`.

I edited no Lean, blueprint, README, or script — inbox and roadmap comments only.
