Everything verified. Here is the report.

## What I found and changed

**1. `AJC.jacobian.assembly` — the warning is still correct to leave, but every previous justification for it was stale.** Seven prior janitor passes (recorded on `I-0411`) justified leaving the row open by citing `Scheme.Pic0.smooth` and `Scheme.Pic0.proper` as `sorry`-bodied. At HEAD both are *proved assemblies*:

```
theorem smooth … := smooth_of_geometricallyReduced C (geometricallyReduced C)   -- :1005
theorem proper … := proper_of_universallyClosed C (universallyClosed C)         -- :1088
```

The obligations moved one level down, to geometric reducedness of Pic⁰ (Cartier in char 0, H²(C,𝒪_C)=0 in char p) and universal closedness. `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/Pic0AbelianVariety.lean` has exactly three real `sorry` bodies (`:709`, `:991`, `:1083`) against ten grep hits. `Jacobian.lean` still carries three of its own (`:318`, `:361`, `:453`), and leaf A is now *deleted* rather than pending — `hasRationalPoint_of_curve` no longer exists as a declaration, and the gate is restated as `Scheme.fgaPicardRepresentability` (`FGAPicRepresentability.lean:339`) with no rational-point binder. **Status left `pending` deliberately**; I recorded the re-measured evidence as a comment on the row so the next pass cites the right obligations. No other parent/child mismatch exists (255 rows checked against the store).

**2. Milestone/active focus — deliberate, and it is not a milestone problem.** Only three milestone labels exist (`w4-gate`, `w4-tail`, `ajc-optimize`), each with one active row. The warning is about *active items*: 14 at the start, and 13 of them are two ancestor spines plus the leaves their live lanes hold (`AJCR.jacobian → w4-rep → datum → dat-d → ddr → certificate/divrep` is one path, five of the rows). Demoting an ancestor would misreport where the campaigns are. Left as-is; the warning's own second clause invites this.

**3. Docs — one real correctness fix.** `/home/axel/LeanAlgebraicGeometry-Horizon/roadmap.md:66-73` still told readers the Wave-4 lane was on "a coordinate twist of `π` (needs `Aut(ℙ¹)`)" — route R1, which binding human decision **I-0492 forbids building**. Rewritten to record R2, mark `…certificate.p1-aut` deprioritised-not-rejected, and note `I-0346` closed. The file also carried another lane's uncommitted AJC edits, so I staged a surgically-patched blob containing only my hunk and left theirs in the worktree.

**4. Inbox — 36 → 29 listed, memory 23 → 16.** Archived as consumed (each with a reason comment): `I-0181` (both citation debts resolved by file/node deletion), `I-0357` (claim 2 falsified — w5-av is 10/16 with a live owner and briefing), `I-0476` and `I-0469` (consumed by protection `I-0491`). Consolidated one-lesson-per-row: `I-0503`→`I-0362`, `I-0496`+`I-0500`→`I-0349`, `I-0470`+`I-0447`→`I-0480` (nine rows on the `hbump` refutation now one), `I-0452`→`I-0472`. The remaining 16 memories are each live — the cap is genuinely unreachable at this workspace size, as `I-0387` argues.

**5. Task queue — 18 → 14.** Cancelled `T2`, `T9`, `T10`, `T11`: each superseded by a running lane holding the same objective *and* the roadmap refs these lack. `T9` also stated its goal for a curve with a k-rational point, the binder `I-0491` removes. `roadmap_refs` was empty on all four, so per `I-0386` no roadmap row could be rewritten. No orphaned `running`: all eight live runs map to live pids.

## Escalated rather than fixed

**`I-0505` (to human) — a binding protection can be invisible to the session it binds.** The inbox filter hides **16 of 52** open items from a cross-project caller, and one is `I-0491` itself: the `--kind protection` query and the synchronizer banner both report *two* active protections when there are **three**. The hidden one forbids proving a specific false statement. Suggested fix: never scope-filter `kind: protection`. I also updated `I-0482` with the re-measured gap (its body said five) and the store-parse workaround.

**`I-0504` (hint to `ajc-etale-pic`)** — their deliverable (5) has two open targets: `MainProjects/Algebraic-Jacobian-Challenge/README.md:113-118` still titled "Open decision" and saying the étale choice "is an open decision for the project owner". I did not edit it; README repair is explicitly their deliverable.

**`I-0472`** — both graph-scanner defects reproduce live at HEAD (phantom node `d19eaa0edf99` regenerates; `toSheaf_preservesFiniteColimits` still unindexed). Measured 35 stale nodes in AJC, **257** in AJCR. Noted that pruning is not a fix, since `…pins.graph-stale-prune` is marked `done` and the phantoms returned.

## Left alone deliberately

Protections `I-0492`, `I-0074`, `I-0491` (all three verified open and unmodified), the live AJCR thread `I-0494`, every AJCR lane's roadmap rows including your `chart-u`/`c9b`/`dat-b`/`dat-c` — I found no inconsistency in yours. No Lean file touched, `AlgebraicJacobian.lean` untouched, no lake lock taken.

Committed as `c014c283f` via the CAS recipe; `show --stat` touches only my paths with zero file deletions, and I ran the section-1b index repair afterwards (39 staged deletions → 0, each worktree copy verified byte-identical to HEAD first). One snag worth knowing: a concurrent CLI writer reverted `I-0504`'s kind in the worktree *after* my commit, which the 1b verification caught before the reset — I re-applied it. Another lane has since committed on top (`32823e7b1`) and my roadmap hunk survives.
