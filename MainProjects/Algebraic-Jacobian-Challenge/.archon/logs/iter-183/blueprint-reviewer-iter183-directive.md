# Blueprint Reviewer Directive

## Slug
iter183

## Iter
183

## Scope

Whole-blueprint audit. Per-chapter completeness + correctness checklist.
The HARD GATE per-file dispatch rule below MUST run on every chapter
that backs an iter-183 prover lane (basenames below) and emit a
`complete: true / correct: true` verdict for that file's prover lane
to fire.

## Iter-183 prover lanes (HARD GATE check needed)

| Lane | File | Chapter (per `% archon:covers` or 1:1 slug) |
|---|---|---|
| Lane A | `AlgebraicJacobian/RiemannRoch/OCofP.lean` | `RiemannRoch_OCofP.tex` |
| Lane B | `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean` | `AbelianVarietyRigidity.tex` (consolidated `% archon:covers`) |
| Lane D | `AlgebraicJacobian/Picard/RelativeSpec.lean` | `Picard_RelativeSpec.tex` |
| Lane E | `AlgebraicJacobian/AbelianVarietyRigidity.lean` | `AbelianVarietyRigidity.tex` |
| Lane F | `AlgebraicJacobian/Picard/QuotScheme.lean` | `Picard_QuotScheme.tex` |
| Lane G | `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean` | `Albanese_AuslanderBuchsbaum.tex` |
| Lane H | `AlgebraicJacobian/RiemannRoch/RRFormula.lean` | `RiemannRoch_RRFormula.tex` |
| Lane I | `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean` | `RiemannRoch_RationalCurveIso.tex` |
| Lane K (NEW) | `AlgebraicJacobian/RiemannRoch/OcOfD.lean` | `RiemannRoch_OcOfD.tex` |
| Lane M (NEW) | `AlgebraicJacobian/Albanese/CoheightBridge.lean` | `Albanese_CoheightBridge.tex` (writing this iter plan-phase) |

## Specific items to verify

1. **NEW chapter `RiemannRoch_OcOfD.tex`** (landed iter-182 plan-phase) — this is a
   first audit. Verify the chapter has clear `\lean{...}` pins for the
   declarations that Lane K will scaffold this iter (`WeilDivisor.sheafOf`,
   `sheafOf_zero`, `sheafOf_singlePoint`, `sheafOf_ses_single_add`), citation
   discipline (`% SOURCE:` + `% SOURCE QUOTE:`), and adequate proof sketches.

2. **NEW chapter `Albanese_CoheightBridge.tex`** (writing this iter plan-phase via
   blueprint-writer `coheightbridge-skeleton`) — if it lands before you do, audit
   it for Lane M's file-skeleton lane. Otherwise, name it as a must-write-next-iter
   chapter under `## Unstarted-phase blueprint proposals`.

3. **Iter-182 writer-edited chapters**:
   - `RiemannRoch_RationalCurveIso.tex` (Pin 2/3 prose by writer `ratcurveiso-pin3-prose`)
   - `RiemannRoch_OCofP.tex` (toFunctionField pin added by same writer)
   Confirm prose tracks the iter-182 plan-phase `pin2-sig-strengthen`
   refactor: Pin 2 binds `D = φ^*[∞]` + `deg = Module.finrank K(ℙ¹) K(C)`.

4. **iter-181 HARD GATE history** — every chapter in the table above had
   `complete: true / correct: true` at iter-181 close. Re-verify; flag any
   regression.

## Strategy context (minimum needed)

The project's two arms:
- **Genus-0 arm (Route C, Milne §I.3)** — chart-bridge cocycle (Lane B) +
  AVR open-immersion residual (Lane E); RR.1–RR.4 chain (Lanes A, H, I) +
  OcOfD opening (Lane K).
- **Positive-genus arm (Route A, FGA Picard)** — RelativeSpec (Lane D),
  QuotScheme (Lane F PIVOT), Auslander–Buchsbaum (Lane G); CoheightBridge
  scaffold lane (Lane M) unblocks downstream codim-1 work.

No new routes opened. Strategy unchanged from iter-181/182.

## Expected output

Per-chapter checklist with `complete: true|false|partial` and
`correct: true|false|partial` for every chapter under
`blueprint/src/chapters/`. Plus the standard `## Unstarted-phase
blueprint proposals` section for any STRATEGY.md phase row with no
blueprint coverage.

The plan agent will read your `## Per-chapter checklist` to apply the
HARD GATE per-file rule on iter-183 prover dispatch.

## Out of scope

- The deterministic blueprint-doctor flagged `RiemannRoch_OcOfD.tex` covers
  `OcOfD.lean` which does not yet exist — this is the iter-182 chapter
  pre-creation of the Lane K file. Don't flag it as a doctor regression
  in your report; the Lane K dispatch this iter creates the file.

- iter-178 `Albanese_AlbaneseUP.tex` standing-deferral chapter has 7
  pinned typed sorries; it is iter-200+ work, so audit but expect
  `partial: true / correct: true` (chapter prose ahead of code).
