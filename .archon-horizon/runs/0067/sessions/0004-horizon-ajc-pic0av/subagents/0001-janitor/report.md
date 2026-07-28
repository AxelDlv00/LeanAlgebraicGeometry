Cleanup done. Report:

## Archived (2 items, both memory, both absorbed rather than dropped)

- **I-0488** → absorbed into **I-0483**. Same lane, same sixth domain-shrinking bug in the `\leanok`-honesty check, filed 73 minutes apart; I-0483's own C-0001 already carried the bug. Its two sharper rules (compare domain *sizes* before reporting agreement; assert reconciliation identities per measurement, not per family) are now a comment on I-0483.
- **I-0476** → consumed twice over. Its finding is binding policy now (protection I-0491 clause 3 names the same three sorry-free AJCR files and orders sessions to read them), and its one explicit action item is done: it closed asking for the AJCR étale layer to be mentioned in AJC prose where it had "zero hits" — re-grepped at HEAD, all three targets carry it (`README.md:154-157`, `TO_USER.md:23`, `informal/pic-representability-campaign.md:334-335`).

Nothing else met the bar. I archived no `protection`, no `conversation`, and left I-0493/I-0495 open.

## Comments added, items kept open (4)

- **I-0411** — verdict unchanged, pointers refreshed. Its C-0007 cited the smoothness/properness sorries at `:806`/`:826`; at HEAD `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/Pic0AbelianVariety.lean` carries three sorry terms at `:709`, `:991`, `:1083`, and run 0067 *reduced* rather than closed both obligations (`geometricallyReduced` `:1003` feeds `smooth` `:1023`; `universallyClosed` `:1095` feeds `proper` `:1106`).
- **I-0065** — one clause stale: it calls Milne 3.3 "the only remaining sorry" in `CodimOneExtension.lean`. It is proved and moved (`Albanese/Milne33.lean:80`, `:247`); the whole Albanese tree is sorry-free except `AlbaneseUP.lean` (6 sorries). The prohibition it exists for is untouched.
- **I-0220** — `RelCurveCollapse.lean` still 752 lines, but the population changed: 15 files over 500 in AJCR, only 4 over 600, and six sitting at 501-503. The actionable debt is the top four, not "fourteen files".
- **I-0387** — added the roadmap-cap analogue (below), since it is the same "cap unreachable by design" argument.

## Reported, not fixed

**AJC.jacobian.assembly should stay `pending`.** I-0411 is right and I verified it at source, not from the item: the witness is not packaged while `Pic⁰` smoothness and properness both route through live sorries. `done` would be a false claim. The warning is intentional and should be expected to fire on every `roadmap list`.

**The 13 active roadmap rows are not 13 pieces of deferred work.** Six are unowned ancestor rows whose children hold the work: `AJC.jacobian`, `AJCR.jacobian`, `AJCR.w4-rep`, `AJCR.w4-rep.datum`, `AJCR.w4-rep.datum.dat-d`, `AJCR.w4-rep.datum.dat-d.ddr`. The other seven are owned by live teams (`ajc-pic0av` ×3, `ajc-etale-pic`, `ajcr-cert-r2`, `ajcr-divrep`, `ajcr-w5-av`) — all other teams' rows, so I changed nothing. So the cap is a leaf count applied to a subtree-inclusive total; marking an ancestor `pending` under an active child just produces the inversion the same command warns about (two such inversions already exist: `AJC.picrep` pending over active `.rational-point`, `AJCR.w5-av` pending over active `.t5`). Nothing here is deferred work masquerading as active. `AJC.maintenance` dropped out during my pass by its owner's action, 14 → 13.

**Duplicate memory clusters flagged, not merged.** The hbump/χ-ledger family — I-0447, I-0470, I-0480, plus I-0442's modes (g)/(h) — is four open items about one refutation at four vintages, already cross-linked by earlier passes with an explicit "both kept" note; merging needs the ajc-rr lane's judgement. Separately, I-0497, I-0498, I-0499 are three same-day memories from the Pic⁰ smooth/reduced/proper cluster and are on track to become the next such family.

## Warnings that remain intentionally

Memory 20 → 21 and non-protection 31 during the pass: four teams filed I-0502 through I-0509 while I worked, which is the churn I-0387 documents. The CLI list also shows 32 open against 52 in the store — 16 items are hidden from this team by the `audience: human` + different-filing-team filter (I-0481, I-0505). A janitor cannot triage what it cannot list, so those 16 are a hard floor on the count from my side.
