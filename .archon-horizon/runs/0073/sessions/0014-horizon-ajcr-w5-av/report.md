All verified at the advanced HEAD `4fba60bb5`: 7/7 modules byte-identical, all 7 root imports present, nothing armed on my paths. Threads acknowledged.

## Summary

Closed **T4's entire residue**: clause (iii) of the tangent/H¹ comparison — open since r3 — plus both of its named consumer inputs, plus the chart-level instantiation, plus the last geometric input, which turned out not to be needed. Seven new sorry-free modules, ten commits, `lake build` **9275 jobs EXIT=0**, zero warnings attributable to me.

The through-line: **all four items had been priced by a *correct* piece of reading that searched in this project's own vocabulary, or accepted a predecessor's chosen statement as the content.**

## Progress

- `Tangent/ChartClassNaturality.lean` (new, 0 sorries): `Opens.cechPicClass_map`, the square §6.17 named as T4's last statement. Its leftover `CommRingCat` goal — which r3 measured at **>1.6M heartbeats without finishing** — *is* mathlib's `Hom.resLE_app_top`, stated for `topIso` where we spell `ιTop`. Three rewrites at the default budget.
- `Tangent/PicEpsKernelTrivial.lean` (new, 0 sorries): a `Pic A[ε]` class trivial along `ε ↦ 0` is trivial. The `fst`-versus-quotient crossing is `rfl`; three docstrings had described it without writing it.
- `Tangent/ChartTrivialityGeo.lean` (new, 0 sorries): **(iii-c2-aff-geo)**. Four lines given those two; the `hcyc` binder is now produced, not assumed.
- `Tangent/EpsZeroSurjective.lean` (new, 0 sorries): `Spec.map (ε ↦ 0)` surjective on points over an **arbitrary commutative ring** — not the predicted one-point-space argument over a field, which would have pinned the lemma to `k`.
- `Tangent/TwoChartHonest.lean` (new, 0 sorries): the two chart conditions carried as separate obligations for three sessions are symptoms of one fact; non-emptiness was never an input, the empty scheme being affine.
- `Tangent/EpsChartSquare.lean` (new, 0 sorries): the `hsq` instantiation. `relSectionsMap` *is* `relCurveMap.appLE` by definition, so this was three quarters landed.
- `Tangent/TwoChartHonestGenus.lean` (new, 0 sorries): a degenerate two-chart cover has `H¹ = 0`, so `g ≠ 0` replaces `¬ IsAffine C.left`. Two `resHom` lemmas, not Serre vanishing.
- `informal/w5-t4-worksheet.md`: §§6.27–6.29 (worksheet-first, binding on T4). Roadmap `.t4` **done**, `.t3`/parent rewritten, all read back from disk.

## Issues

- **I over-priced a landed item into three records mid-session**: having drawn the lesson, I filed `hsq` as "a successor should START here" into two roadmap rows and memory **without probing it**. Corrected at all three sites (I-0729 by appended comment, not silent edit).
- **I committed a false diagnosis and refuted it myself**: a bare `lean` call omits `maxSynthPendingDepth = 3`, and the resulting errors looked exactly like an import-set conflict. Retracted at both sites; `ajcr-charts`' in-file `set_option` fix adopted and verified.
- **`ajcr-charts` then sharpened my rule and caught a gap in my own application of it** — I supplied three of four options only on the command line, and their linter point found my two `show` warnings in the root build. Fixed and verified against a control.
- **The LSP could not see a nine-error namespace mistake** (a new module importing another new module reports only "imports out of date"). Caught by the kernel check.
- **Both subagents stalled** (I-0677, occurrences 11–12) at **195 bytes**, not the 187 every prior report cites — filed as a possible discriminator. **No independent fresh-context review was obtained**; I ran the checklist myself, so `.t4 = done` rests on my own verification.

## Why I stopped

**Partly advanced, not complete**; no terminal status set, so the task returns to the queue. T4 is done, Wave 5 is not: T3's assembly, T5's numeral, S1/S3 remain, and P1 stays DD-gated and untouched as instructed.

## Next

T3 has no comparison-side blocker left — every input is landed, rooted and axiom-clean, so the ε-kernel statement can be assembled directly. Reach T5 only once T3 hands it the **semilinear** comparison (`AddEquiv` + intertwining across `κ(e) ≃+* k`); `finrank` does not transport along a bare bijection, and the `.t5` row records that trap. `¬ IsAffine C.left` is off the critical path but unproved; I-0729 holds its route and honest price.
