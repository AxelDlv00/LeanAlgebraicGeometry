# Mathlib Analogist Report

## Mode
api-alignment

## Slug
engine252

## Iteration
252

## Question
A.2.c Quot-scheme embedding needs `IsInvertible M ⟹ M coherent, locally free 𝒪-module of
rank 1` (Stacks `lemma-invertible-is-locally-free-rank-1`), `M : Scheme.Modules X`,
`IsInvertible M := ∃ N, Nonempty (M ⊗ N ≅ 𝟙_)`. (Q1) Does Mathlib already carry this or the
`Module.Invertible`/`Projective`/finite-loc-free/`FinitePresentation` machinery composing into it?
(Q2) Same Mathlib-absent finite-presentation spreading-out as the FORWARD bridge, or a cheaper
coherence statement? (Q3) Realistic LOC/iter band + build sketch.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| 1. Mathlib carries invertible⟹loc-free-rank-1 for sheaves? | NEEDS_MATHLIB_GAP_FILL (sheaf level; ring level complete) | informational |
| 2. Same Mathlib-scale spreading-out as forward bridge? | DIVERGE_INTENTIONALLY — factor; route via `IsLocallyTrivial`, build only the cheap half | informational |
| 3. Cost band + sketch | ~120–250 LOC / ~3–6 iters from loc-triv (NOT Mathlib-scale) | informational |

## Answers to the three sub-questions

**Q1 — Mathlib coverage.** The statement is COMPLETE at the **ring** level and ABSENT at the
**sheaf** level.
- Present (ring): `Mathlib.RingTheory.PicardGroup` — `Module.Invertible.instProjective`,
  `…instFinite`, `…finrank_eq_one`, `…of_isLocalization`, `CommRing.Pic.mk_eq_one_iff_free`;
  compose with `Module.finitePresentation_of_projective` (`…Module.FinitePresentation`) for full
  finite-projective-rank-1.
- Present (sheaf vocabulary, but NOT linked to invertibility): `SheafOfModules.IsFiniteType`
  (`…Sheaf.Generators`), `SheafOfModules.IsFinitePresentation` / `QuasicoherentData.IsFinitePresentation`
  (`…Sheaf.Quasicoherent`), `SheafOfModules.IsQuasicoherent`, `SheafOfModules.free`/`ιFree`
  (`…Sheaf.Free`).
- **Verified ABSENT** (LSP, no hits): `SheafOfModules.IsLocallyFree` (no such predicate at all);
  any "invertible sheaf ⟹ loc-free rank 1" at `SheafOfModules`/`Scheme.Modules`; any map from the
  sheaf-level `IsInvertible` to any coherence predicate; any stalk-iso⟹nbhd-iso spreading-out for
  `SheafOfModules`. `IsInvertible` supplies no finite-presentation datum for `M` as a sheaf.

**Q2 — same hard spreading-out, or cheaper?** BOTH, depending on the entry point — the statement
factors:
- HARD half `IsInvertible ⟹ M finitely presented (loc-triv)` = the **same** Mathlib-absent
  finite-presentation spreading-out iter-245 priced for the forward bridge. The ring-level
  spreading-out engine (`Module.isOpen_freeLocus`, `…basicOpen_subset_freeLocus_iff`,
  `…freeLocus_eq_univ` in `…Spectrum.Prime.FreeLocus`) **requires `[Module.FinitePresentation]`
  as a hypothesis**, which `IsInvertible` cannot produce — genuine chicken-and-egg, Mathlib-scale,
  off-path.
- CHEAP half `IsLocallyTrivial ⟹ coherent loc-free rank 1`: on each chart `M|_U ≅ 𝒪_U`
  (rank-1 free, definitional); coherence = `SheafOfModules.IsFinitePresentation` assembled from the
  trivialising cover via `QuasicoherentData`; rank-1 and flatness are chart-local. No spreading-out,
  no Mathlib gap.
- **Cost-collapsing fact**: the embedding's input is a `Pic⁰_{C/k}` point, i.e. an object of the
  RPF representing scheme whose carrier is `IsLocallyTrivial` (`OnProduct = {M // IsLocallyTrivial M}`;
  `exists_tensorObj_inverse` returns a loc-triv witness). The consumer NEVER needs the `IsInvertible`
  entry point, so the HARD half is never crossed. The risk is real only for the literal statement;
  it is retired by the carrier the project already chose.

**Q3 — cost band + sketch.**
- Forced from `IsInvertible` (NOT recommended): Mathlib-scale, ~300–600 LOC of new sheaf
  finite-presentation spreading-out, or a typed-`sorry` pin.
- From `IsLocallyTrivial` (recommended; real cost): **~120–250 LOC / ~3–6 iters.**
  - C1 cover extraction: pointwise `IsLocallyTrivial` → indexed affine cover + per-chart iso
    (~30–60). **Chief unknown**: discharge the `J.over X` site instances
    (`HasWeakSheafify`/`WEqualsLocallyBijective`/`HasSheafCompose`) `QuasicoherentData` requires for
    `X.ringCatSheaf` — check in the lane's first iter.
  - C2 per-chart free presentation from `M|_U ≅ 𝒪_U = free {*}` via `SheafOfModules.free`/`ιFree`
    (~30–60).
  - C3 assemble `M.IsFinitePresentation` via `QuasicoherentData` + `IsFinitePresentation.mk`;
    `IsFiniteType` free via `instIsFiniteTypeOfIsFinitePresentation` (~30–60).
  - C4 rank-1/flat records + Quot-point wrapper (~20–40).
  - No Mathlib-scale gap on this route; the only bespoke piece is C1's cover→`QuasicoherentData`
    adaptor (project-local plumbing).

## Informational
- The literal `IsInvertible ⟹ …` verdict is NEEDS_MATHLIB_GAP_FILL but the gap is upstream and,
  crucially, **off the critical path** — the carrier choice (RPF = `IsLocallyTrivial`) means it
  need never be built. This is consistent with `analogies/invertible-loctriv-bridge.md` (iter-245),
  which ruled the forward bridge Mathlib-scale and off-path; the directive's construction is the
  same bridge wearing a coherence hat.
- "Coherent" → on the noetherian Quot base `S` (`IsLocallyNoetherian`/`LocallyOfFiniteType`),
  coherent = finite-type = finite-presentation; Mathlib's `SheafOfModules.IsFinitePresentation` is
  the correct proxy (no standalone `IsCoherent` predicate is needed or present).
- Engine prover lane in parallel with the substrate is SAFE on the loc-triv half; do NOT open a
  lane on the `IsInvertible` entry point.

## Persistent file
- `analogies/engine252.md` — full cost band, decomposition, build sketch, verified present/absent
  Mathlib pieces.

Overall verdict: the A.2.c Quot-embedding coherence row should be re-estimated at ~120–250 LOC /
~3–6 iters (NOT Mathlib-scale), built as `IsLocallyTrivial M ⟹ IsFinitePresentation` fed from the
RPF/Pic⁰ loc-triv carrier; the literal `IsInvertible ⟹ loc-free-rank-1` is the same off-path
Mathlib-scale spreading-out from iter-245 and must NOT be built.
