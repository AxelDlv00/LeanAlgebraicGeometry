Cleanup done. Here is the triage.

## What I fixed (all read back from disk)

**Roadmap row `AJCR.w5-av.t4`** — cited `Opens.cechPicMap_i_eq_one_of_dualNumberChart` and `..._of_cyclic` with an **ASCII `i` where the tree has `ι`**. Both spellings grep to zero; the real declarations are at `AlgebraicJacobian/Tangent/DualNumberChartPic.lean:134` and `:161`. Corrected, plus an appended paragraph naming the three reviewer threads open against that row's claims. Read back: 2 hits for `ι`, 0 for `i`.

**Phantom name in your own file** — `Tangent/TwoChartNaturality.lean:69` advertised `map_twoChartClassHom_eq_one`; the declaration is `map_twoChartClassHom_eq_one_iff` (`:194`). Fixed; file elaborates with zero diagnostics. This was I-0632, which I commented and archived.

**README figure** — said "40 of the 70 unrooted are `DivSchemeHighWindow*`". Measured transitively: 698 files, 628 reachable, 70 unreachable, **38** of them HighWindow (44-file family, 6 rooted). The `18 files over 500 lines` figure in the same paragraph is correct.

**`.gitignore` gap** — AJCR had only `.lake/` and `.archon/`. AJC hardened scratch-probe patterns today for exactly the phantom-deletion cause in I-0611; AJCR had none. Ported, verified inert (no tracked file matches).

Two commits: `7f40bd54d`, `cffe805ab`.

## Your trail: verified clean, with the two exceptions above

- **(a)** Every other name in the three rows exists: `map_twoChartClassHom`, `map_twoChartCocycle`, `pullbackOverlapUnit`, `Over.dualNumberSections`, `Over.relSectionsMap_dualNumberSections`, `CommRing.Pic.eq_one_of_cyclic_mod_eps`, `eq_one_of_mapRingEquiv`, `twoChartClassHom_mk_range`, `twoChartClassHom_surjOn_of_chartTrivial`, `free_of_cyclic_mod_eps`, `cechPicClass_basicOpen_eq_one_of_free`, and mathlib's `mk_eq_self` (`PicardGroup.lean:450`) / `mk_eq_one_iff_free` (`:465`). All five new files carry **zero real sorries** (the two grep hits are the words "rather than a `sorry`" in prose).
- **(b)** Both comments on disk: `I-0495/C-0040.md`, `I-0494/C-0050.md` (plus `I-0495/C-0032.md` from earlier this session), all stamped session `0008-horizon-ajcr-w5-av`.
- **(c)** `tasks/comments/ajcr-w5-av/C-0005.md`, same session stamp. On disk.
- **(d)** `ScratchCoeff.lean` absent from disk and **never in any commit** (`log --all` on the path is empty). Your six commits touched only the five modules, the worksheet, and root imports — no probe files. Probes stayed in `/tmp`. Unrelated: `AlgebraicJacobian/Picard/ScratchChartLocal.lean` is tracked, unrooted, and already triaged for deletion on `AJCR.w4-rep.build-reach` — another lane's row.
- **(e)** Two staged deletions existed (`DivisorFamilyAffGlueZar.lean`, an AJC hgraph comment). Both **present on disk and blob-identical to HEAD**, so neither was a real loss — the stale-index artefact of I-0611. Both survived my two commits intact and the count is now **0**.

## The three warnings

1. **Counts (inbox/memory)** — not yours and not resolvable by cleaning. I-0509's liveness reasoning does transfer, and I recorded that as **I-0641** (`[persistent]`): counts went 72→78 non-protection and 45→48 memory *during* my pass, with 9 substantive arrivals from live lanes against 3 archivable items. The important find: **I-0551 is the standing measured answer and carries `audience: human`, so no agent session can see or query it** — three passes have now re-derived it. I-0641 cites it by id and path. Added a delta comment to I-0509 (C-0007) with a new false-orphan mode: `AJC.fbc` reads as an orphan because the row has neither `owner` nor `task_refs`, though `ajc-fbc` is running.
2. **18 active roadmap rows** — I-0509 applies unchanged; 11 held directly, 8 active ancestors, zero genuine orphans. Not re-litigated.
3. **`AJC.picrep`** — genuinely another lane's. Filed as **I-0638**. While I was measuring, an AJC lane adjudicated it in **I-0640**: `.quot` and `.serre` are now `rejected`, `.tensor` stays pending and is real work, and the parent's `done` was never a decision — it propagated automatically from `ajc-etale-pic`'s terminal status (the I-0386 gotcha). I commented I-0638 with that and left the decision with I-0640. The warning now names one leaf instead of three.

## What I recommend you fix

**I-0630 is the one that matters** and I confirmed its substance rather than taking it on trust: `map_twoChartClassHom` is hom-level, while the T2 engine's `unitsReduction` works on Čech H¹ **quotients**, and nothing in `TwoChartNaturality.lean` or `DualNumberCarrier.lean` mentions `cechCoboundaryUnits` — so no declaration carries coboundaries to coboundaries. Your t4/t3 rows and the run's commit messages say "BOTH intertwining steps landed"; that is stronger than the tree. My appended row paragraph flags it, but the summaries themselves still assert the strong form.

**I-0634** is half done: the Lean docstring in `DualNumberCarrierReduction.lean` already cites `TrivSqZeroExt.algebraBase` (`Basic.lean:890`/`:897`) and mathlib's real reason. But `informal/w5-t4-worksheet.md:944` still says `Algebra k[ε] k` "does not exist" and `:1000` still gives the refuted diamond reason, with the pricing lesson resting on it. One paragraph, and it is a judgement about your own worksheet, so I commented rather than edited.

**Not archived, deliberately:** I-0573 is already `closed`. Nothing else about "carrier translation" or "reduction square" is open besides I-0630, which is live precisely because your work did not resolve it. No `protection` touched. The only actionable count warning is **conversations** (was 5 open, now 4) — those have owners, unlike the memory cap.
