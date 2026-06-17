# Progress Critic Report

## Slug
iter054

## Iteration
054

## Routes audited

### Route 1: P5a-resolution — `CechAugmentedResolution.lean` (`cechAugmented_exact`)

- **Sorry trajectory**: Theorem non-existent through iter-052 (the prior critic used "sorry count inapplicable" framing). In iter-053: file scaffolded with 1 stub sorry, prover ran same iter, 1 sorry remains. Net: 1 sorry in, 1 sorry out — no closure.
- **Helper accumulation**: +6 (iter-051), +3 (iter-052), +2 (iter-053) = 11 helpers across 3 active prover iters; named target never closed.
- **Prover dispatch pattern**: iter-051 PARTIAL, iter-052 PARTIAL, iter-053 PARTIAL. Three consecutive PARTIAL statuses.
- **Recurring blockers**: Three distinct blockers across three iters — "no SheafOfModules.stalk" (iter-051, resolved), "import cycle" (iter-052, resolved by relocation), "F-valued prepend-i_fix contracting homotopy + categorical↔combinatorial (mapHomologicalComplex↔depDiff) identification" (iter-053, open). No single phrase recurs ≥2 times. But the iter-053 blocker is structurally related to the open gap in `CechAcyclic.lean` (L1 bridge: CechComplex terms ↔ combinatorial depDiff complex) — same category of identification, different level (section-complex vs. localized-module complex).
- **Avoidance patterns**: none. Dispatched every active iter; no off-critical-path reclassification.
- **Prover status pattern**: PARTIAL → PARTIAL → PARTIAL (3 consecutive).
- **Throughput**: Strategy estimates ~1–2 iters left, entered phase iter-052/053, elapsed ~1 iter. ON_SCHEDULE by the raw count, but the tripwire is convergence, not schedule.
- **Verdict**: **CHURNING**

**Reason**: The CHURNING rule's second clause applies verbatim: "PARTIAL prover status ≥3 of last K iters." This clause has no structural-change exception. The prior critic (iter-053 report) set the tripwire explicitly: "If iter-053 returns a third PARTIAL, the planner must escalate regardless of the structural argument above." That condition is now met.

The sorry is well-characterized — the proof scaffold is essentially complete and the residual is one crisp gap — but the gap requires infrastructure that the prover cannot build speculatively: (a) an F-agnostic section-level contracting homotopy connecting the section complex's differentials to the `depDiff` signature, and (b) the categorical↔combinatorial identification that lets the homotopy close `IsZero (GV.mapHomologyIso' ...)`. Neither can be produced by `sorry`-scaffolding deeper and hoping; the blueprint Step 3/4 must name the exact Lean mechanism before the prover attempts it.

- **Primary corrective**: **Blueprint expansion** — Step 3/4 of the `lem:cech_augmented_resolution` blueprint chapter must be expanded to specify: (a) what Lean declaration implements the prepend-i_fix contracting homotopy at the section level (i.e., which form of `CombinatorialCech.combHomotopy` / `FreePresheafComplex` applies here, and under what conditions it gives `dh + hd = id` at the HomologicalComplex level); (b) how the identification `mapHomologicalComplex↔depDiff` is obtained (whether via an explicit iso in FreePresheafComplex.lean or a defeq fold). The blueprint expansion should also note whether this bridge can be extracted as a shared helper usable by both `CechAugmentedResolution` and `CechAcyclic` (both need a categorical↔combinatorial identification, though at different levels), to avoid redundant build work.
- **Secondary correctives**: After blueprint expansion, re-dispatch as mathlib-build. Do NOT assign another plain mathlib-build round before the blueprint expansion is complete.

---

### Route 2: P5a-consumer — `OpenImmersionPushforward.lean` (`_acyclic`, `_comp`)

- **Sorry trajectory**: 2 stub sorries scaffolded in iter-053, 2 sorries remain after prover pass. First prover iter.
- **Helper accumulation**: +1 axiom-clean private (`isAffineHom_of_affine_separated`) in iter-053.
- **Prover dispatch pattern**: iter-053 PARTIAL (first dispatch). 1 iter of data.
- **Recurring blockers**: none — single iter.
- **Avoidance patterns**: none.
- **Prover status pattern**: PARTIAL (1 iter).
- **Throughput**: Strategy estimates ~2–3 iters left, entered phase iter-053, elapsed 1 iter. ON_SCHEDULE.
- **Verdict**: **UNCLEAR** — too fresh to assess (1 prover iter).

**Structural watch note**: the residual sorry in `higherDirectImage_openImmersion_acyclic` is a handed-off gap: after reducing via `higherDirectImage_iso_sheafify_presheafHomology` (which IS fully proved, 0 sorries in `HigherDirectImagePresheaf.lean`), the prover needs to show the sheafification of `V ↦ Hᵠ((j_* I•)(V))` is zero. The path (affine basis → `j⁻¹V` affine → `affine_serre_vanishing` → locally-zero sheafification) has all ingredients proved (`affine_serre_vanishing` has 0 sorries in `AffineSerreVanishing.lean`). The "bridge (1)" the planner identifies as upstream is NOT a missing declaration in `HigherDirectImagePresheaf.lean` (which is complete) but rather the functional identification of `(j_* I•)(V)` with `I•(j⁻¹V)` — the sections-of-pushforward defeq. This may be a `rfl`/`dsimp`/`change` plus a `congr` rather than a genuine new declaration. The prover may have been too quick to hand it off.

The planner's re-scope ("build bridge (1) FIRST inside the consumer") is correct strategy — but bridge (1) may require less work than its "upstream-deferred hand-off" framing suggests, given that the pushforward is defined as restriction of sections. A Lean prover pass should be able to close this with the right `simp` lemma about `Scheme.Modules.pushforward` sections.

**Signature re-sign note**: the planner proposes re-signing `_comp` from `Nonempty (A ≅ B)` to a canonical `A ≅ B`. This declaration is NOT in `archon-protected.yaml` (only `cech_computes_higherDirectImage` is protected), so the re-sign is allowed. However, if any downstream file or future prover has already been written against the `Nonempty` signature, re-signing will break it. The planner should verify no consumer has hardcoded the `Nonempty` form before authorizing the re-sign.

---

## PROGRESS.md dispatch sanity

- **File count**: 2 (cap: default 10)
- **Ready but not dispatched**: `CechAcyclic.lean` has 1 open sorry and a referenced blueprint chapter (`lem:cech_acyclic_affine` in `Cohomology_CechHigherDirectImage.tex`), but its L1 blocker (CechComplex↔localized-module identification) is the same category of bridge as Route 1's residual — dispatching it without resolving the shared foundational infrastructure first would likely yield a third PARTIAL in CechAcyclic as well. Exclusion is reasonable.
- **Over the cap**: no
- **Under-dispatch finding**: no — the 2-file proposal is appropriate given Route 1's CHURNING verdict mandates blueprint expansion before any prover round (the actual prover re-dispatch for Route 1 is contingent on that expansion completing). Route 2 is the only live prover lane this iter.
- **Iter-over-iter trend**: 2 → 2 (stable), within cap, not growing while churning.
- **Verdict**: OK — file count 2 within cap 10, no under-dispatch finding given Route 1's blueprint-expansion prerequisite.

---

## Must-fix-this-iter

- **Route 1 (`CechAugmentedResolution.lean`)**: CHURNING — primary corrective: **Blueprint expansion** (Step 3/4 of `lem:cech_augmented_resolution` chapter). Blueprint expansion MUST precede any prover re-dispatch for this file. Why: 3 consecutive PARTIAL statuses; the residual requires naming the exact Lean mechanism for the section-level contracting homotopy and the categorical↔combinatorial identification before the prover can proceed. Dispatching another mathlib-build round without this specification will yield a fourth PARTIAL.

---

## Informational

**Route 2 — bridge (1) tractability**: the "upstream hand-off" framing may be overstated. All required upstream declarations (`higherDirectImage_iso_sheafify_presheafHomology`, `affine_serre_vanishing`, `isZero_presheafToSheaf_obj_of_isLocallyBijective`) are fully proved. The remaining gap is the sections-of-pushforward identification `(j_* I•)(V) ≅ I•(j⁻¹V)`, which may be defeq or near-rfl given the definition of `Scheme.Modules.pushforward`. The prover should attempt the gap explicitly rather than handing it off again. If it is NOT a defeq but requires a new lemma, that lemma likely belongs in `HigherDirectImagePresheaf.lean` as the natural completion of its own docstring's "remaining hand-off" note.

**Shared bridge risk**: both Route 1 (section-level homotopy) and `CechAcyclic.lean` (localized-module homotopy) need a bridge connecting the abstract `HomologicalComplex` differentials to the combinatorial `depDiff`/`combDifferential` signature. If the blueprint expansion for Route 1 resolves this in the section-complex context, the same work may close the `CechAcyclic` L1 gap with minor adaptation. The blueprint writer should check whether a shared helper (e.g., in `FreePresheafComplex.lean`) can serve both, before the Route 1 prover builds it privately.

---

## Overall verdict

One route CHURNING (Route 1, 3 consecutive PARTIALs, explicit prior-critic tripwire triggered), one route UNCLEAR (Route 2, single prover iter, PARTIAL). The iter's live prover lane is Route 2 only; Route 1 must receive blueprint expansion before its next prover round. The planner's proposed direction (blueprint expansion for Route 1 before re-dispatch, re-scope Route 2 to build bridge (1) first) is correct — this report confirms CHURNING for Route 1 and places it in must-fix so the planner cannot skip the blueprint step and assign another helper round. No avoidance patterns detected. Dispatch is OK: 2-file proposal within cap, CechAcyclic.lean's exclusion is justified given the shared foundational bridge dependency.
