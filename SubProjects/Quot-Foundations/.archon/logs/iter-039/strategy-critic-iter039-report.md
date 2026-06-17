# Strategy Critic Report

## Slug
iter039

## Iteration
039

## Routes audited

### Route: FBC (flat base change of `f_* F`, i=0)

- **Goal-alignment**: PASS — `IsIso pushforwardBaseChangeMap` (affine, Stacks 02KH pt 2) + qcoh globalization is exactly `lem:affine_base_change_pushforward` / `thm:flat_base_change_pushforward`.
- **Mathematical soundness**: PASS — the conjugate-iso framing is coherent; `conjugateEquiv adjL adjR` of `gammaPushforwardNatIso` carries the module content `regroupEquiv` (DONE), and the residual is a real coherence identity, not a hand-wave.
- **Sunk-cost reasoning detected**: yes — see Sunk-cost flags. The KEEP justification leans materially on "the proof-free conjugate read is already built … so NO refactor cascade is owed," which is a *cost-already-paid* argument, not a *this-is-the-cheapest-remaining-path* argument.
- **Infrastructure-deferral detected**: no (the hard work is being attempted this iter as a prover round, not deferred) — but see the *pivot-depth* concern below: the conjugate read may **reformulate** the same coherence obligation (canonical map ≡ abstract iso) one layer down rather than reduce it. That is the substantive risk, and the strategy asserts rather than demonstrates that the conjugate side is genuinely more tractable.
- **Phantom prerequisites**: none. `CategoryTheory.conjugateEquiv` and its iso family (`conjugateEquiv_iso`, `_id`, `_adjunction_id`, …) are confirmed in Mathlib `Adjunction.Mates`. The named atoms `conjugateEquiv_leftAdjointCompIso_inv` / `conjugateEquiv_pullbackComp_inv` / `unit_conjugateEquiv_symm` are **project-side** lemmas being assembled (they do not appear in Mathlib), and the strategy lists them under "Key Mathlib needs" — a mislabel, but not a phantom: they are obligations the prover builds, not infra assumed to pre-exist.
- **Effort honesty**: reasonable — A1 `~80–150`/1–3 iters, A2 `~200–500`/3–6, FBC-B `~120–300`/2–4 are consistent with a Mathlib-absent qcoh-locality build.
- **Verdict**: CHALLENGE

The route is *not* a dead-end on the merits — the math is sound, the Mathlib prereqs exist, and the residual `_legs_conj` is decomposed into concrete named atoms (conj-2b/conj-2d/reframing), which is exactly the mathlib-contributor decomposition my checklist wants. What is missing, after a multi-iter stall on the mate coherence (Status: STUCK), is **(a) a kill-criterion** — the row says "1–3 iters" open-endedly with no stated trigger for declaring the conjugate route structurally dead and falling back, and **(b) demonstrated (not asserted) intractability of the abandoned element-`ext` path**. Mathlib's own `conjugateEquiv_adjunction_id` shows mate components unwind to concrete `α.app (R.obj c) ≫ counit.app c` composites, i.e. element-level computation of the transpose is not *obviously* hopeless; the strategy's stated reason for abandoning `FlatBaseChange.lean:2097` ("the transpose-definition forces the mate form; no module-level bypass") is an assertion. A fresh reader cannot tell from the prose whether element-`ext` was abandoned because it is provably intractable or because the conjugate read was further along. The planner must either record concrete evidence that element-`ext` is dead, or carry a kill-criterion (e.g. "if `_legs_conj` does not close in N iters, reopen element-`ext`/escalate").

### Route: GF (generic flatness)

- **Goal-alignment**: PASS — algebraic core `genericFlatnessAlgebraic` DONE (axiom-clean per Completed table); geometric wrapper `genericFlatness` re-signed with `[IsQuasicoherent]`+`[IsFiniteType]`.
- **Mathematical soundness**: PASS — affine-open + finite-cover + per-patch algebraic form + `V=D(∏fⱼ)` is the standard Nitsure §4 globalization.
- **Parallelism under-exploited**: yes — G3 (per-patch freeness on a finite cover ⟹ flatness over `Γ(S,U)`, via `flat_of_isLocalized_maximal`) does **not** depend on gap1; only G1 (finite sections on affine) bottoms at gap1. The strategy serializes the entire GF-geo phase behind gap1 ("dispatch deferred until gap1 lands"), which idles the G3 sub-build that could be authored in parallel.
- **Verdict**: SOUND (with the parallelism note above as a throughput improvement, not a blocker).

### Route: QUOT (Hilbert polynomial / Quot functor / Grassmannian)

- **Goal-alignment**: PASS — `def:hilbert_polynomial` via `Polynomial.existsUnique_hilbertPoly` (verified `[Field][CharZero]`) + `lem:gradedHilbertSerre_rational` (DONE); Quot/Grassmannian defs + representability cover the stated nodes.
- **Mathematical soundness**: PASS — gap1 keystone (`IsQuasicoherent M → IsIso M.fromTildeΓ`) is well-decomposed (C/P1/D-cover/`gammaPullbackTopIso`/bridges I+II all DONE; residual = build `σ_V` + prove `gammaPullbackImageIso.hom` is `σ_V`-semilinear). The shared-infra identification (gap1 = common bottom of GF-G1 ∩ QUOT, build once QUOT-side) is correct and good planning.
- **Infrastructure-deferral detected**: no, with one watch-item — `def:sectionGradedRing` (SheafOfModules tensor powers) is "owed regardless" and deferred behind gap1, but it has a concrete trigger (gap1 lands), the Mathlib monoidal infra it needs is **verified present** (`PresheafOfModules.monoidalCategory`/`symmetricCategory`, `Sheaf` monoidal), and the strategy already downscoped it ("smaller build than first scoped"). Acceptable deferral, not a goal weakening.
- **Verdict**: SOUND.

## Format compliance

- **Size**: 148 lines / ~11 KB — within budget (~250 lines / ~12 KB), though near the byte ceiling.
- **Headings**: PASS — `## Goal` → `## Phases & estimations` → `## Completed` → `## Routes` → `## Open strategic questions` → `## Mathlib gaps & new material`, exact canonical order.
- **Per-iter narrative detected**: borderline-no — no bare "last iter"/"iter-NNN pivot" phrasing in prose (Completed `Iters` cells `022`/`011`/… are the allowed ledger). But the Risks/Routes/Q2 prose carries heavy *process* narrative ("two PIVOTs evaluated and rejected", "The feared re-cut cascade is ALREADY neutralized", "Next FBC prover round targets these", "Element-`ext` … remain abandoned"). This is decision-history that reads as a litigation transcript and belongs in iter sidecars.
- **Accumulation detected**: yes — **GR-proper is still a live row in the active `## Phases & estimations` table** (line 25, Status "ACTIVE (E4)") and is referenced as having a live target in `## Routes` ("E3-full the live target", line 96) and in `## Open strategic questions` Q-area. Per this iter's own premise GR-proper is COMPLETE (`isProper`/`lem:gr_proper` axiom-clean). A completed phase must MOVE to `## Completed`. The table row and the Routes line are also **internally inconsistent** (table: "E1/E2/E3-ratio-core + E3-full DONE … Live target = E4"; Routes: "E3-ratio-core DONE and E3-full the live target") — stale duplicate frontiers that must be reconciled to a single Completed entry.
- **Table discipline**: FAIL — the `## Phases & estimations` Risks cells are not "one short line." The FBC-A1 Risks cell is a ~10-line multi-clause paragraph; FBC-A2, FBC-B, QUOT-defs Risks cells are each multi-sentence. The canonical skeleton requires one short line per cell; long prose belongs in `## Routes`.
- **Format verdict**: DRIFTED

## Sunk-cost flags

- `the feared re-cut cascade is ALREADY neutralized: the proof-free conjugate read is built … so NO refactor cascade is owed` — Why this is sunk-cost: it argues for KEEP by pointing to scaffolding already constructed, not by showing the conjugate proof is the *cheapest remaining* path to `IsIso`. Recommendation: reframe on the merits — state the kill-criterion under which the conjugate route is abandoned, and the concrete reason element-`ext` is provably intractable (mate components *do* unwind via `conjugateEquiv_adjunction_id`, so "intractable" needs evidence, not assertion).

## Prerequisite verification

- `Polynomial.existsUnique_hilbertPoly`: VERIFIED (`Mathlib.RingTheory.Polynomial.HilbertPoly`, `[Field F][CharZero F]`).
- `CategoryTheory.conjugateEquiv` (+ `conjugateEquiv_iso`/`_id`/`_adjunction_id`/`_symm_iso`): VERIFIED (`Mathlib.CategoryTheory.Adjunction.Mates`).
- `PresheafOfModules.monoidalCategory` / `PresheafOfModules.symmetricCategory`: VERIFIED (`Mathlib.Algebra.Category.ModuleCat.Presheaf.Monoidal`) — SNAP tensor-power infra exists.
- `conjugateEquiv_leftAdjointCompIso_inv` / `conjugateEquiv_pullbackComp_inv` / `unit_conjugateEquiv_symm`: project-side atoms, not Mathlib (correctly so; flag is only the "Key Mathlib needs" mislabel).
- Mathlib pushforward flat-base-change for qcoh sheaves: absent — confirms FBC is genuine project work, not a missed alias.

## Must-fix-this-iter

- Route FBC: CHALLENGE — add to STRATEGY.md (or rebut in plan.md) a concrete **kill-criterion** for the conjugate route and **evidence** that element-`ext` is provably intractable (not merely "forces the mate form"). Address the pivot-depth concern: state why the conjugate `_legs_conj` is a *reduction* of the canonical-map-≡-iso coherence rather than a *reformulation* of it.
- Format: DRIFTED — (1) MOVE the completed GR-proper row out of `## Phases & estimations` into `## Completed` and delete its now-stale "live target" references in `## Routes`/`## Open strategic questions`, reconciling the E3-full-vs-E4 inconsistency; (2) collapse the oversized Risks cells (esp. FBC-A1) to one short line each, relocating the prose to `## Routes`.
- GF parallelism (minor): G3 (freeness⟹flatness) is gap1-independent and can be authored in parallel with gap1 rather than serialized behind it.

## Overall verdict

The strategy is structurally sound: the dependency spine is correct (gap1 is the shared keystone bottom of both GF-G1 and QUOT and is rightly the highest-leverage active target; GF-geo and QUOT-repr correctly sit behind it; estimates are honest against comparable Completed rows; no phantom Mathlib prerequisites — `existsUnique_hilbertPoly`, `conjugateEquiv`, and the PresheafOfModules monoidal infra are all verified present). No infrastructure-deferral findings: `def:sectionGradedRing` is deferred but with a trigger and verified-present Mathlib infra, and gap1's residual is concretely decomposed. The two actionable items are (1) FBC carries a genuine CHALLENGE — not because the route is mathematically dead (it is sound and well-decomposed), but because after a multi-iter stall the strategy lacks a kill-criterion and justifies KEEP partly on sunk scaffolding while asserting rather than demonstrating that the abandoned element-`ext` path is intractable; the planner must supply a fallback trigger and intractability evidence before the next FBC prover round, or rebut. (2) The document is DRIFTED: the completed GR-proper phase still occupies the active phase table with a stale, self-inconsistent "live target," and several Risks cells have ballooned into paragraphs — both must be fixed in-place this iter.
