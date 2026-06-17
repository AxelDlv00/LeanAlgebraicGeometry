# Blueprint Reviewer Directive

## Slug
iter175-whole

## Strategy snapshot

End-state: zero inline `sorry`, kernel-only axioms for Christian Merten's
Jacobian challenge. Spine = pointed vs. unpointed. Witness OBJECT `J` is
real on both arms; vacuity touches only the `∀ P` Albanese field for
unpointed `C`.

Two routes:
- **Route A (positive-genus arm)**: `J := Pic⁰_{C/k}` per Kleiman §4–§5 +
  Nitsure §5 + Milne III §6.
- **Route C (genus-0 arm)**: `J := Spec k` (trivial); content is rigidity
  over `k̄` plus genus-0 ⟹ `≅ ℙ¹` (Hartshorne IV.1.3.5 via in-tree RR.1–RR.4).

Full STRATEGY.md `## Phases & estimations` table follows so you can identify
unstarted phases:

| Phase | Status | Iters left | LOC | Key Mathlib needs |
|---|---|---|---|---|
| A.1.a — `RelativeSpec` | chapter LANDED; file-skeleton open | ~3–5 | ~200–400 | RelativeSpec functor |
| A.1.b — `LineBundle.Pullback` | chapter LANDED; gated | ~2–4 | ~200–400 | LB pullback |
| A.1.c — `RelPic functor` | chapter LANDED iter-174 | ~2–4 | ~300–500 | ét-sheafification |
| A.2.a — Flattening stratification | chapter LANDED iter-174 | ~8–14 | ~1200–2000 | Stacks 052H |
| A.2.b — Quot scheme | chapter LANDED iter-174 | ~10–17 | ~1500–2500 | Grassmannian; QuotScheme |
| A.2.c — FGA Pic_{C/k} assembly | chapter LANDED iter-174 | ~4–7 | ~600–800 | wires above |
| A.3 — Pic⁰ identity + degree | per-sub-phase in Jacobian.tex | ~5–8 | ~600–900 | GroupScheme.IdentityComponent |
| A.4.a — Lemma 3.3 codim-1 + Weil-div surface API | chapter LANDED iter-174 | ~13–20 | ~1500–2500 | codim-1; Weil-divisor surface |
| A.4.b — Auslander–Buchsbaum | chapter LANDED iter-174 | ~4–7 | ~500–700 | depth / proj.dim |
| A.4.c — Thm 3.2 rational-map-extension | chapter LANDED iter-174 | ~5–8 | ~600–900 | bundles A.4.a + A.4.b |
| A.4.d — Albanese UP via Sym^g | chapter LANDED iter-174; Sym^g re-dispatch THIS iter | ~5–10 | ~500–900 | Sym^g of schemes |
| Genus-0 rigidity — gmScalingP1 body | structural pivot THIS iter | ~3–6 | ~100–170 | chart-bridge pivot |
| Genus-0 RR.1 — Weil divisors | file-skeleton landed; body-fill open | ~3–6 | ~300–500 | divisors at scheme level |
| Genus-0 RR.2 — RR formula | chapter LANDED; file-skeleton landed iter-174 | ~3–5 | ~400–600 | finite-rank cohomology + Euler-char |
| Genus-0 RR.3 — O_C(P) global sections | chapter LANDED iter-174 | ~3–5 | ~400–600 | invertible sheaf at point |
| Genus-0 RR.4 — rational ⟹ ≅ℙ¹ | chapter LANDED iter-174 | ~3–5 | ~400–600 | Proj.fromOfGlobalSections |
| genusZeroWitness body + k̄→k descent | gated | 3–5 | 350–850 | terminal cluster on Spec k |
| nonempty_jacobianWitness genus-stratified body | gated | 1 | <50 | by_cases h : genus C = 0 |

## Routes

Two routes. Route A (FGA Picard) for positive genus is mandatory. Route C
(Milne §I.3 rigidity) for genus-0.

## References

- references/abelian-varieties.md → .pdf: Milne — Rigidity Thm 1.1; Thm 3.2;
  cube §I.5; Albanese UP §III.6 (Prop 6.1/6.4).
- references/kleiman-picard.md → .pdf/.tex: Kleiman, "The Picard scheme" —
  Route A source.
- references/nitsure-hilbert-quot.md → .pdf/.tex: Nitsure, "Construction of
  Hilbert and Quot Schemes" — Route A engine.
- references/hartshorne.pdf: Hartshorne — RR / curves / II.6 divisors /
  IV.1 RR-formula.
- references/stacks-*.md → .tex: Stacks varieties, fields, algebra,
  cohomology, constructions.
- references/mumford-abelian-varieties.md → .pdf: Mumford — alternative.

## Focus areas

Particular attention to:

1. **The 10 iter-174 NEW chapters** — Picard_FlatteningStratification.tex,
   Picard_RelPicFunctor.tex, Picard_QuotScheme.tex,
   Picard_FGAPicRepresentability.tex, Albanese_CodimOneExtension.tex,
   Albanese_AuslanderBuchsbaum.tex, Albanese_Thm32RationalMapExtension.tex,
   Albanese_AlbaneseUP.tex, RiemannRoch_OCofP.tex,
   RiemannRoch_RationalCurveIso.tex. These chapters' files are about to
   open as file-skeleton lanes THIS iter (or iter-176 for A.4.a/A.4.d/RR.4
   which are deferred). Each needs HARD GATE clearance (complete + correct
   + no must-fix-this-iter) for its file-skeleton lane to open.
2. **Albanese_AlbaneseUP.tex** specifically — per iter-174 a4d-albanese
   writer's strategy-modifying finding, the chapter's moduli sub-lemmas
   (Poincaré bundle / autoduality `J ≅ J^∨`) need to be retired and
   replaced by Sym^g sub-lemmas (`lem:symmetric_product_av_map`,
   `lem:symmetric_product_to_jacobian`, `lem:descent_through_birational_sigma`).
   The iter-175 plan-phase is dispatching a writer (`blueprint-writer a4d-sym-g`)
   to do this re-write. Please assess whether the chapter as it stands
   (after the writer's iter-175 edit) is HARD-GATE-CLEAR for its
   file-skeleton lane.
3. **Picard_FGAPicRepresentability.tex** — blueprint-doctor flagged 2
   malformed `\uses{}` annotations (empty arguments). Writer
   `fgapic-empty-uses-fix` is closing these THIS plan-phase. Please verify
   they are closed in the chapter's final state.
4. **RiemannRoch_RationalCurveIso.tex** — blueprint-doctor flagged a
   broken `\uses{cor:nonconstant_function_genus_zero}`. Writer
   `rr-broken-uses-fix` is closing it THIS plan-phase. Please verify.
5. **AbelianVarietyRigidity.tex** consolidated chapter (covers
   AbelianVarietyRigidity.lean, Genus0BaseObjects.lean, RigidityLemma.lean).
   Lane A iter-175 prover targets the post-G0BO-split Genus0BaseObjects
   sub-files; the chapter must still pin the substantive helpers (writer
   `g0bo-helper-pins` is adding 2 missing pins). Please verify the
   chapter cleanly covers the post-split file layout.
6. **RiemannRoch_WeilDivisor.tex** — writer `weildivisor-doc-updates` is
   landing iter-174 LVB MAJOR fixes (junk-branch convention on `ofClosedPoint`
   + `def:order_at_point` Lean-signature-scope paragraph for the next-iter
   `RationalMap.order` body lane).

## Known issues

The following are already known and acted on this plan-phase:

- `Picard_FGAPicRepresentability.tex` empty `\uses{}` × 2 — writer dispatched.
- `RiemannRoch_RationalCurveIso.tex` broken `\uses{cor:nonconstant_function_genus_zero}` — writer dispatched.
- `AbelianVarietyRigidity.tex` missing pins for `homogeneousLocalizationAwayIso_algebraMap` + `gmScalingP1_chart_PLB_eq` — writer dispatched.
- `Albanese_AlbaneseUP.tex` Sym^g re-dispatch — writer dispatched.
- `RiemannRoch_WeilDivisor.tex` junk-branch convention + RationalMap.order spec — writer dispatched.
- `Picard_RelativeSpec.tex` stale `\leanok` markers on proof blocks at L127/L418 — flagged for iter-175 sync_leanok investigation; please verify whether your reading triggers them as must-fix or whether deferral is acceptable.
- 10 chapter-coverage gaps where chapters cover non-existent `.lean` files — informational; resolves THIS iter as file-skeleton lanes scaffold the files.
