Cleanup pass complete. Report follows.

## What I changed

**Docs (1 commit, `7e708ef85`)** — `MainProjects/Algebraic-Jacobian-Challenge-Rebuild/README.md`: its build-reachability paragraph claimed *73 of 715 modules unreachable from the root, 38 of them the `DivSchemeHighWindow*` family*. Transitive re-measurement at HEAD: **20 of 728**, and HighWindow is now fully rooted. Residue is 17 `Picard/` modules (`DivSchemeRedesign*` + `EntryIdeal`, `Pic0ThetaCocycle`, `ScratchChartLocal`) plus the three `Tangent/Probe*`. Verified identical at HEAD by content; index clean after, re-crossed twice.

**Inbox** — `I-0697` archived (armed deletion on `Pic0ChartOpenImmersionCriterion.lean`, independently confirmed clear at a third HEAD; its durable content is already in `I-0656`/`I-0701`). Comments added to `I-0667` (re-measured, still live), `I-0713` (second-lane confirmation, still armed), `I-0708` (third-lane confirmation, both mismatches unchanged). All four writes read back from the on-disk store per `I-0609`.

## Task 1 — armed stale-index deletions

Applied I-0701 first: every read re-taken at least twice, 6–8s apart. Over the pass the index re-armed **six times** with different contents; the set is stable-per-read but regenerates within minutes (matches `I-0656` C-0002).

**Cleared (yours, disk byte-identical to HEAD in both cases):** `AlgebraicJacobian/Picard/DivisorFamilyAffSeedGate.lean`, `AlgebraicJacobian.lean`. Your earlier clears had *not* held — both re-armed after you cleared them.

**Reported, not cleared** (all disk == HEAD, so nothing lost yet):

| path | armed as | owning commit |
|---|---|---|
| `AJCR/AlgebraicJacobian/Picard/DivisorFamilyAffAwayRep.lean` | 0/109 D | `745bcd90d` (`ajcr-charts`) — persists across 3 HEADs, ~40 min; already `I-0713` |
| `AJCR/informal/spec-dd-r.md` | 0/140 | `aff551b70` (your own lane, transient — gone by next read) |
| `AJCR/informal/w4-datc-worksheet.md` | 0/22 | `0e0e84641` (`ajcr-charts`) |
| `AJCR/Picard/Pic0ChartUnivReduce.lean` | M | `cf26fb010` (`ajcr-charts`) |
| `AJC/.../ExtensionUniformity.lean`, `FiberBound.lean`, `scripts/ajcrr-genusfieldinvariance-axioms.lean` | M / D | `f5809bb8b`, `ca88857e8` (`ajc-rr`) |
| `.archon-horizon/roadmap/items/AJC.rr.yaml`, `inbox/local/{items,history}/I-0712.*` | M / D | `ca88857e8`, `ajc-rr` inbox writes |

**Your write set is clean now** (staged=0, disk==HEAD for all three paths).

## Task 2 — commits landed by content

Ledger-enumerated, not from your list. All three commits are ancestors of HEAD and **every touched path is content-identical to HEAD** — nothing differs, nothing absent. `AlgebraicJacobian.lean` at HEAD carries both your imports (lines 576, 577). No other lane's import line was lost: I checked the seven other commits that touched the root file today and all seven added lines survive. Sorry census on both new modules: **one hit, docstring prose** (`AffSeedSection.lean:27`), no terms. All ten advertised declarations exist.

Disk currently shows `AlgebraicJacobian.lean` +3 lines vs HEAD — `ajcr-divrep`'s uncommitted `DivRepChartClassUniv*` imports, additions only. Not a loss.

## Task 3 — inbox

**Already resolved before I arrived:** `I-0675` is archived (not live). **`I-0667` is still live and I did not archive it** — I re-measured and both figures moved *up*: 51 chart-typed consumer files (was 49), 38 `partition₀/₁` hits over 12 files (was 33/11). The extra 4 are in `DivisorFamilyAffPartitionAudit.lean`, which names the fields in order to prove the widened closure avoids them, so it inflates the text count without being debt. Widened names outside the `AffSeed*`/`Aff*` family: still exactly one file. What ADDENDUM 11 changed is the *pricing*, not the count — so the item stays open, now actionable.

**No memory item of your lane is superseded by ADDENDUM 9/10.** `I-0676`, `I-0711`, `I-0507` are all method lessons with live instances at HEAD; `I-0625` forbids archiving on age when a rule has a live instance. Counts: team-visible open non-protection **111** (was 142 as your session reported), memory **76**; store-wide 144/86. Per the standing answers `I-0641`/`I-0551`, these caps triage by lane liveness — 7 live pids filing 3-4 lessons each is the fleet's steady state, not hoarding. Archiving to hit 30 would delete verified content.

## Task 4 — roadmap (report only, nothing flipped)

**Active count 19 / 7 live pids.** Applied `I-0509`'s cross on the union of `owner`, `task_refs` and each running task's `roadmap_refs`: **12 held directly, 7 active ancestors, zero orphans.** Warning is expected at this fleet size — tenth consecutive "all legitimate". Both parent/child mismatches are unowned AJC rows, already `I-0708`, unchanged; the only tasks reaching them (`ajc-truth`, `ajc-optimize`) are queued.

**Rows I think are wrong, all yours:**

- **`...certificate.widen-decision` (done)** — its summary still reads *"DECIDED 2026-07-27: choose R1, coordinate twists"* and *"audits reject R2"*. Human protection `I-0492` reversed exactly that on 2026-07-28. A `done` row whose text advocates the forbidden route is the `I-0616` failure mode.
- **`...certificate.twist-atlas` (pending)** — its summary is a build plan for the outer twist atlas at `twistedP1Map π M`. `I-0492` clause 1 forbids GL₂/Aut(ℙ¹) work and says no consumer may be written against it. Should probably be `rejected` or carry a deprioritised note like `p1-aut` does.
- **`...certificate` (active)** — summary is accurate against HEAD as far as it goes, but see below.

## Needs your decision

1. **`I-0715` (filed minutes ago, on your three commits) contradicts your row summary.** A reviewer's two EXIT=0 probes show `hWle : W ≤ (D.localEquations hD).cover.opens z₀` at a *seed* forces `supportLocus ⊆ relPinnedChart C R π (D.side z₀)`, because `cover.opens = D.piece` by `rfl` and `piece_le` lands in the pinned chart — so the gate's hypothesis set is **empty for every straddling divisor**, the payoff case of R2. I verified both source facts (`DivSchemeFamily.lean:98` and `:351`) and that `hWle` is a hypothesis of every declaration in both new files. Your row summary and ADDENDUM 11 §11.4(a) call this residue a limit on the claim, not a breach; the reviewer says `hWle` *is* the containment. This is yours to adjudicate — it may retract the "producer from geometry" headline.
2. **`I-0674` C-0001 is still open and still unfixed at all three sites** — "no converse can exist" / "no transformation back can exist" at `DivRepGlobalAffLift.lean:36` and `spec-dd-r.md:1511-1513`. (The wording at `DivisorFamilyAffFunctorCompare.lean:33-36` reads "no natural transformation back", same defect.) Non-surjectivity of `DivFamZar.toAff` refutes a *section*, not the existence of some `divFunctorAff ⟹ divFunctor`. Lean source plus binding spec, so outside janitor scope.
3. **`DivisorFamilyAffAwayRep.lean` (109 lines, `ajcr-charts`) is still armed** and has survived three HEAD advances. Not mine or yours to clear, but any broad-pathspec commit in the workspace publishes the deletion.
