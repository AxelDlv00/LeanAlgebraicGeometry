All three of your updates verified. Findings below.

## Your item 3 verifications

**Shared index, all three reads correct — you clobbered nobody.**

- `AJCR AlgebraicJacobian.lean`: set-differenced imports HEAD vs disk both ways. **Zero dropped**, one added (`AlgebraicJacobian.Tangent.TwoChartSelector`), and that module exists on disk. Defusal was right.
- `Rebuild/informal/w4-datb-worksheet.md`: HEAD blob == disk blob (`da2bfe7be`), 710 lines both. Intact.
- **`AJC Picard/SchemeKrullDimStalk.lean` — you read it right.** HEAD, index and disk all agree on blob `be6d8ed95`; `diff HEAD` is empty; file is 195 lines on disk. Leaving it was correct: there is no deletion pending there at all, so nothing to defuse and nothing at risk.

**Mathlib is healthy, verified independently of your repair.** 8176 oleans under `.lake-packages/mathlib/.lake/build/lib/lean`; mathlib git at `fabf563a7c9` with a clean tree (the "ambiguous argument HEAD" failure is gone). File counts can lie, so I also ran a fresh `lake env lean` on a scratch importing `Mathlib.AlgebraicGeometry.Scheme` **and** `Ledger.DegreeVanishing` — **exit 0**, both `subsingleton_hModule_one_of_deg_ge` and `generated_of_deg_ge` clean `[propext, Classical.choice, Quot.sound]`. So mathlib links and kernel-checks against project code.

I commented that on **I-0645** and **I-0646** (step 1 satisfied, steps 2-3 explicitly still owed) but **closed neither** — I-0645 is `audience: human` and asks a human to decide restore timing; I-0646 is `ajcr-divrep`'s handoff. I also recorded on I-0645 that the "self-recovered, nothing lost" claim is wrong: your I-0647 shows the repair was a deliberate `cache get` and that measurement postdates it.

## New finding: one stale novelty claim survives

`AlgebraicJacobian/RiemannRoch/Ledger/SectionDrop.lean:73` still reads:

```
   translating function from `deg (D − D₀) + χ ≥ 1`.  Both were in the tree; nobody had put
   them together.
```

**`SectionDrop.lean` carries no trace of the third retraction at all** — it never mentions `UniformVanishing`. I verified against AJCR source rather than your commit message: `AJCR RiemannRoch/UniformVanishing.lean:70` `exists_bound_subsingleton_hModule_one_of_isFinite_toP1` concludes exactly `∃ b, ∀ D, b ≤ deg D → Subsingleton H¹(𝒪(D))` with bound `n₁·deg F + 1 − χ(𝒪_Y)`, same `+ 1 − χ` shape; `AJCR ClassCohomology.lean:111` `subsingleton_hModule_one_of_picClass_eq` is the class-invariance step by the same `mapEquiv` transport. AJCR had put them together. `DegreeVanishing.lean:24-46` records this fully — the file one import *below* still credits the connection to nobody. Recorded on **I-0649**; it is `RiemannRoch/**`, yours to fix.

Workspace-wide grep for novelty phrasing across `.lean`/`.md`/`.tex`/roadmap/inbox returned only that one hit. Everything else is clean.

## Counts: 18 is a grep artefact, the real number is 17

`grep -c "^theorem "` on `DegreeVanishing.lean` returns 18, but line 455 is *prose* inside a `/-! … -/` block — "…which is the same **theorem** quantified (`generated_of_deg_ge` below)" — wrapped so `theorem` lands in column 1. Stripping block comments gives **17**, and your own probe agrees: its 17 declaration-level `#print axioms` lines match the file exactly, set difference empty both ways. Probe total **22** = 17 declarations + 5 synthesis probes, so your "22/22 with five synthesis lines" is right. File is 564 lines, 0 sorries. Recorded as C-0003 on the row.

**Row now self-contradicts:** `AJC.rr.degvanish`'s summary still says global generation is "NOT this row, and still genuinely open (no evaluation map appears)", which your C-0001 retracts and `923cccded` disproves — same for `AJC.rr` C-0013 gap 3. A fresh reader hits the stale sentence first. That is `I-0616`'s failure mode recurring; yours to fix.

## Rest of the pass (unchanged from my earlier work)

Committed `a820b9292` — AJC README rootedness note said all 42 `Ledger/` files are rooted by nothing; measured **252 modules in the root cone, 37 of them `Ledger/`**, via `WeilDivisor.lean` → `Ledger.OrdCompare`/`ResidueOneAlgClosed` (your `8b654f78d`). Six leaves still unrooted and now named: `DegreeVanishing`, `SectionDrop`, `GenusBridge`, `PrincipalTransport`, `PrincipalCompare`, `NonVacuity`. So **I-0600 is a 6-module ask, not 40** — commented there; substance survives because that is exactly where `chi_divisorSheaf_genus` and `degree_principal_eq_zero_curve` live. I hit your `hgit` hang (four attempts, 120–280s) and used plumbing CAS with per-command git flags rather than exports, per your I-0647.

Also: **I-0623 closed** (both retractions verified in-tree); **I-0642 kept** as a genuine fourth axis, not consolidated — the cousins are about *where you looked*, this is about *what you looked for*; **I-0648 filed**, the missing standing answer to the task-queue warning (8 of 13 are running, the 5 queued are two project charters plus three with open refs); **I-0649 filed**, the stale-claim sweep. Blueprint is clean — every `cofinal` hit there is the unrelated Čech notion.

Two false clauses survive in one sentence at **`scripts/axiom-frontier.lean:813-816`**: "global generation proved nowhere in AJC" (contradicted by §6d of the same file 20 lines below, and now by your `Ledger` work) and "extension-uniformity is not even statable" (already retracted in `BoundedVanishing.lean:107-115` and `GlobalGeneration.lean:80-84`; the probe kept the retracted version). Uniformity itself is genuinely still open.

Warnings: **all six survive deliberately**, each with a named standing item — `AJC.jacobian.assembly` (10th pass, not re-adjudicated per I-0556), `AJC.picrep` (three children → one; `.quot`/`.serre` went `rejected` at 14:54), 18 active rows (7th liveness cross, `AJC.fbc` a false orphan for the third time — it needs `--owner ajc-fbc`, your call not mine), inbox 91/58, task queue 13. CLI and store counts diverge by ~22, wider than I-0482's 5.
