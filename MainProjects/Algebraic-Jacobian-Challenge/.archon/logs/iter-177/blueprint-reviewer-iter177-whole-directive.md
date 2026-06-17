# blueprint-reviewer — iter-177 whole-blueprint audit

You are dispatched at the start of iter-177's plan phase.

Per your descriptor: **read the whole blueprint** under
`blueprint/src/chapters/*.tex` and report a per-chapter checklist
(`complete: true|false|partial`, `correct: true|false|partial`,
`must-fix-this-iter` items, soft notes).

## Scope

All 27 chapters in `blueprint/src/chapters/`. Pay particular attention
to:

1. **3 deferred file-skeletons being scaffolded this iter**:
   - `Albanese_AlbaneseUP.tex` covers `Albanese/AlbaneseUP.lean` (NEW iter-177)
   - `Albanese_CodimOneExtension.tex` covers `Albanese/CodimOneExtension.lean` (NEW iter-177)
   - `RiemannRoch_RationalCurveIso.tex` covers `RiemannRoch/RationalCurveIso.lean` (NEW iter-177)

   These are blueprint-doctor live findings: each chapter declares
   `% archon:covers` against a .lean file that doesn't exist yet.
   This iter's plan is to land the file-skeleton lanes, which fixes
   the doctor finding. Confirm the chapters have the level of detail
   needed to drive a file-skeleton dispatch (clear `\lean{...}` pins,
   substantive non-tautological type sketches).

2. **`AbelianVarietyRigidity.tex`** — has the documentary-drift
   informational item from iter-176; flag if anything has hardened
   since.

3. **`Picard_RelativeSpec.tex`** — review noted iter-176 added
   `% NOTE (iter-176 review)` annotations documenting placeholder-body
   discharge in three proof blocks. Confirm whether the chapter is
   still adequate to drive a *substantive-body* iter-177 lane
   (vs. continuing on the placeholder bodies).

4. **`RiemannRoch_OCofP.tex`** — Lane K landed iter-176 but the build
   is BROKEN (4 errors due to a parallel signature-change race with
   Lane D). The chapter pins are correct; the bug is in the Lean
   file's missing `[IsLocallyNoetherian C.left]` instance binders.
   Confirm the chapter doesn't need updating to reflect the new
   `order` signature.

5. **`RiemannRoch_WeilDivisor.tex`** — `order` body landed iter-176
   axiom-clean. Confirm the chapter and Lean are still in sync.

## Returns

Per your descriptor:

- One per-chapter row with `complete: true|false|partial`,
  `correct: true|false|partial`, must-fix-this-iter items.
- Per-chapter `\lean{...}` pin → Lean declaration mapping verification.
- **HARD GATE clearance assertion** for each chapter that backs a
  prover lane this iter (those are: GmScaling [AVR], OCofP, WeilDivisor,
  RelativeSpec, RelPicFunctor, plus the 3 new file-skeleton chapters).

The 8 prover lanes this iter (so you know what to gate):

1. `OCofP.lean` BUILD-FIX → `RiemannRoch_OCofP.tex`
2. `GmScaling.lean` GM-AXIOM → `AbelianVarietyRigidity.tex` (consolidated)
3. `WeilDivisor.lean` body → `RiemannRoch_WeilDivisor.tex`
4. `RelativeSpec.lean` body upgrade → `Picard_RelativeSpec.tex`
5. `RelPicFunctor.lean` body → `Picard_RelPicFunctor.tex`
6. `Albanese/CodimOneExtension.lean` (NEW skeleton) → `Albanese_CodimOneExtension.tex`
7. `Albanese/AlbaneseUP.lean` (NEW skeleton) → `Albanese_AlbaneseUP.tex`
8. `RiemannRoch/RationalCurveIso.lean` (NEW skeleton) → `RiemannRoch_RationalCurveIso.tex`

## Output destination

`task_results/blueprint-reviewer-iter177-whole.md`.
