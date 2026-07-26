Done. Report below.

## 1. Inbox triage

**Counts: 34 open non-protection at start → 28 after my archiving → 34 now.** I archived 6; run 0048 filed 6 fresh round-5/6 items during the pass (I-0365, I-0367–I-0371) and I added 1 DM. Without this pass it would stand at 40. I did not hit "under 30" and I decline to fake it — the only way there was to archive run 0048's live adjudications.

**Archived (each verified against tree/ledger, each with a one-line reason comment):**

| Item | Why |
|---|---|
| I-0348 | Self-refuted headline; I-0359 says verbatim it "closes the open question on I-0348" and restates every residual fact plus the measurement (34.1 GB RSS at 4:58) |
| I-0350 | Round-2 hint list; items 3/6 answered, 4/5 restated in I-0357, 1 in I-0363. **Its unique item 2 (p1-aut affordability) I copied onto I-0363 first** |
| I-0351 | Fixed in source: decls renamed to `cechWitnessLocus`/`isOpen_cechWitnessLocus`, and `Pic0ChartLocusClass.lean:25` now carries the exact caveat the item demanded |
| I-0355 | All four claims discharged — worksheet corrected at `:337-340`; `U` retyped to `DivFamZar` at `1e4ac5b52`; `isCompatible_of_isDivRepClassify_divRepPullAt` landed; claim 2 absorbed into I-0320 |
| I-0356 | `spec-dd-r.md:758` states "**closes I-0356**"; both branches of its action taken |
| I-0227 | Prescribed file split landed (verified on disk). **Its machine rules — `LEAN_NUM_THREADS=1`, kill at 50 GB — existed nowhere else, so I copied them into I-0359 first** |

Plus already-closed refs I-0314, I-0315 archived as you asked. I-0312, I-0316, I-0319 untouched.

**Kept deliberately, with comments:** I-0346 (ADDENDUM 4 answers the maths; the R1-plus-descent vs R2 *decision* is still yours), I-0318, I-0144, I-0181, I-0220, I-0309, I-0322 — all verified still live on disk.

**Two things you should see:**
- **I-0366's stale shared index has recurred with new files.** `P1Aut.lean` (243 lines) and `DivRepGlobalClassify.lean` (318 lines) are staged as deleted while present on disk. Any bare `git commit` publishes that. I commented the evidence on I-0366 and committed with explicit pathspecs, which builds from current HEAD and cannot publish it.
- **I made an error and corrected it in-thread.** I first reported "0 tracked hgraph files" from a bare `git ls-files` — that reads `<root>/.git`, not the ledger. The ledger tracks 26,232. I posted a correction on I-0318.

## 2. Doc accuracy

Commit `befbc744f`, five files, all verified byte-identical in the ledger; zero `.lean` files swept in.

- **Real mathematical error fixed:** README said geometrically **integral**; `AlgebraicJacobian/Jacobian.lean` states it for geometrically **irreducible**.
- **Invented cone list removed.** "Serre-finiteness, Quot, Picard-identity-component" are not roadmap nodes. Replaced with the real ones: closed `AJC.substrate`/`linebundle`/`grquot`/`cech`; open `AJC.fbc`/`rr`/`picrep`/`pic0av`/`albanese`.
- Your measured numbers inserted; nothing invented. `TO_USER.md` still three bullets, with its "resource work is heartbeat/synthesis/import audits" tail corrected to name the umbrella import as root cause.
- Added `scripts/` to Layout (it was undocumented).

## 3. Retirement proposal — nothing deleted

**`analogies/` (123 notes, 1.8 MB).** Hard result I verified myself: **47 notes (872 KB, 47%) are written against ten modules with zero occurrences left in the tree** (`Cotangent/`, `Genus0BaseObjects/`, `Differentials.lean`, `Rigidity.lean`, `RigidityKbar`, `AbelianVarietyRigidity`, `RRFormula`, `H1Vanishing`, `OCofP`, `RationalCurveIso`) — the genus-0 lane deleted 2026-06-23. **These are the retire list; the README now carries the grep that regenerates it.** Beyond that: iterations ≥ 304 (16 notes) are current, keep; iterations 206–271 (~40, the `TensorObjSubstrate` lane) are probably half retire-able but I did **not** adjudicate them and did not claim a number. Note file mtimes are useless here — 107 notes share one bulk-import stamp.

**`informal/` (12 files).** Dead: `projectiveLineBar_geomIrred.md`, `projectiveLineBar_smoothOfRelDim.md` (`ProjectiveLineBar`: 0 refs). **I corrected the survey on two others** — `tensorObj_restrict_iso.md` and `exists_tensorObj_inverse.md` are stale *journals* but their declarations are alive (87 and 39 refs), so retire the journal, not the mathematics. The other 8 are live. Added `informal/README.md`, which did not exist.

**`memory/` (6 files).** Retire `d3-split-landed.md` (`PullbackTensorComp.lean` no longer exists; "8627 jobs" now 8,723) and `ts225-blueprint-audit.md` (both actions executed; `rationalMap_to_av_extends` 0 refs vs 9 for `extend_to_av`). The other three are live; `genus-split-removed-uniform-pic0.md` is the most load-bearing note in the project — it is what explains the 47 dead analogies.

**One escalation:** a second advisory fired — 13 memory items against a max of 10. Four (I-0320, I-0347, I-0360, I-0367) are one topic and say one thing: the obstruction is about *producing* a certificate, never consuming one. Only run 0048 can safely merge them mid-adjudication, so I DM'd its task rather than touching them.
