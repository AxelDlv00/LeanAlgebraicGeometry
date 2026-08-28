Hygiene pass complete. Findings in your priority order.

## 1. The standing count warnings: leave them, but one cap is now genuinely actionable

I read I-0509, I-0641 and I-0556 first. The "partly intentional" justification still holds for memory and non-protection, and I did not re-derive the liveness cross beyond recording a delta (I-0556 rule 1). But two things changed, and one is a correction to the standing answer.

**Store-wide counts, before → after my pass:**

| kind | before | after | cap |
|---|---|---|---|
| memory | 177 | 178 | 10 |
| info | 41 | 37 | 4 |
| conversation | 71 | 68 | 8 |
| issue | 246 | 249 | 30 (agg.) |
| open non-protection | 537 | 533 | 30 |

Memory and issues rose while I worked — the arrival pressure I-0641 describes, at 10 live lanes. Note the CLI reports the team-visible set (168 memory / 26 info / 410 non-protection at my final re-run) while the store holds more; per I-0641 C-0003 those are different sets, not drift.

**The correction: the `info` cap IS reachable, and no prior pass said so.** I-0838's claim protocol makes info items arrive in *verifiable pairs* — a CLAIM naming a roadmap row is demonstrably consumed the moment its own lane files the RELEASE on that same row. That is a mechanical archive rule, unlike memory. I archived 5 such pairs:

- I-1194 (superseded by I-1246, `bot-refute`), I-1206 (by I-1268, `etale-rep.galois`), I-1211 (by I-1255, `chart-u-aff`), I-1189 (by I-1187, `abel-widened`), **I-1249 — your own CLAIM, superseded by your I-1306 release.**

Each got a comment naming the superseding item before archiving; the RELEASE carries the do-not-redo content, so nothing was lost. The remaining 37 info items are unpaired: still-held claims, and per-round reviewer verdicts addressed to the human (I-1188, I-1243, I-1209, I-1266). I did **not** archive those verdict chains — I checked, and they are per-round reports from live lanes to the human on a standing question, not duplicates. Not mine to close.

I also archived 3 orphaned conversations, each a self-resolving "nothing lost" collision notice with both initiator and recipient retired, re-verified at HEAD: I-0755 (axiom-frontier.lean now zero uncommitted delta), I-0813 (`DivisorFamilyAffThetaTyping.lean` present in the tree), I-0818 (the pic0av row content intact).

I did not touch any of the 6 open protections.

## 2. Your housekeeping is consistent — and the file ajc-p4 reverted is safe

- **Roadmap row** `AJC.picrep.etale-rep.descent-assembly`: `status: active`, `pinned_commits: [f64de9d18d]`, comment `C-0001.md` present **at HEAD, not just on disk**, disk == HEAD. Owner is now cleared (`None`) — your lane filed the release I-1306 while I was working. Active-with-owner-cleared is exactly what I-0838's release step prescribes, so this is correct, not drift.
- **Your Lean file**: `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/PicEtDescentAssembly.lean` is 333 lines, HEAD md5 == disk md5. ajc-p4's repair commit `77914d6630` landed and is intact. Their claim in I-1298 checks out.
- **Your 3 archives were genuinely consumed.** I-0843 is the human's round-open `--owner`-cleared notice (its 9 siblings went to the other lanes; 3 already archived), I-1179 and I-1180 are work-reviewer defect threads you started and acted on. All three had you as a correct closer.
- **One open thread needs you**: I-1298, ajc-p4's unread DM about the reversion. It says "nothing needed from you unless you disagree that HEAD is now correct." HEAD *is* correct — I verified it independently above. A one-line acknowledgement closes it; ajc-p4 owns archival. I left it unread rather than consuming it on your behalf. As you noted, I-1256 and I-1290 belong to their initiators (I-1290's `started_by` is `task:ajc-p2` — that one is yours to close, and its content is self-resolved).

## 3. `AJC.picrep` has been corrected at HEAD

The reviewer did the work. At HEAD the row reads `active · 20/30 done`, not `done`, carrying review-ajc's route-correction summary and an explicit "REOPENED active by review-ajc 2026-07-29 (was `done`, which was wrong in the strongest available sense)". Disk == HEAD, no pending diff.

The deliverable claim is also now honest rather than merely deleted: `instHasPicScheme` exists in no `.lean` declaration, and the AJC README plus `Jacobian.lean:388` both say so explicitly, naming the successor `picSchemeOfHasRationalPoint` as a theorem. So the "advertised deliverable does not exist" defect is closed at both ends.

**And the whole board is clean**: I enumerated parent/child status in both directions across every row — zero done-parents-with-open-children, zero all-children-done-parents-left-open. Fourteen passes in, the collection whose count warning fires is the most internally consistent it has been. I recorded that on I-0509 with the recommendation to stop re-running the liveness cross.

I-0640's "one needs you" is answered as a by-product: `AJC.picrep.tensor` is `pending` under a now-`active` parent, which is consistent.

## 4. Other hygiene debt

**Fixed directly** (commit `5a9d664a81`, two paths, verified — see below):
- `/home/axel/LeanAlgebraicGeometry-Horizon/README.md` cited `I-0472` for the hgraph-scanner defect, but that item is **archived while the defect is unfixed** (its body documents three ghosts that regenerate on resync). Rewrote the sentence to state the defect and mark the reproduction as archived; `I-0501` is still open and correctly cited.
- `/home/axel/LeanAlgebraicGeometry-Horizon/rev_probe_p3h.lean` — a scratch Lean probe at the workspace root, untracked *and* unignored, so any lane doing a broad `add` would commit it. It is another live lane's in-flight scratch, so I did not delete or move it; I added a narrow `/*probe*.lean` ignore rule (verified with `check-ignore`) pointing at the session `probes/` convention that already exists under `.archon-horizon/runs/0082/.../probes/`.

**Recorded, not fixed** — a real finding on I-0751, whose orphan set grew 4 → 19 since it was filed. The sharper diagnosis is upstream of any janitor: **33 of 68 open conversations have no participant other than the initiator.** They are self-addressed reviewer findings filed as `conversation` when `issue` or `memory` was the right kind. A one-participant thread has no reply to wait for, so it can *never* reach the lifecycle's close condition — it is structurally unclosable. Re-kinding those 33 would drop the cap-8 warning to roughly the 39 live-lane threads with no information lost. That is a human/CLI-owner call, not a janitor sweep.

**Not mine to touch, worth naming in your report:** the shared index currently has **8 armed staged deletions of files present both at HEAD and on disk**, and two are this round's actual proof output — `MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/PicEtSeparated.lean` (ajc-p1's just-landed brick) and `MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0ChartCoverageThreshold.lean`. This is worse than the single coordination file I-1300 reported. Also note I-1309 and I-1325: the fresh-private-index discipline was reproduced as *insufficient* — I-1325 measured a commit whose diff touched only `.archon-horizon/` that still deleted 46 lines of another lane's proof file, with the author's own path-hash check passing. That strengthens your I-1291 proposal: the post-commit `--stat` read is the only check that catches it.

**Commit safety, as you asked.** I used `GIT_INDEX_FILE` on a fresh mktemp path, `read-tree HEAD`, added only `README.md` and `.gitignore`, and confirmed the staged set was exactly those two. Post-commit, `show --stat` on my own commit lists exactly `.gitignore` and `README.md` and nothing else — none of the 8 armed deletions rode along. I then hashed both paths HEAD-vs-disk (match) and confirmed `5a9d664a81` is still an ancestor of HEAD, so nobody has reverted it. Task/roadmap/protection state I did not modify.
