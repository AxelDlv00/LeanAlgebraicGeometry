# Recommendations for the next plan iteration (post iter-303)

## CRITICAL

### 1. SYSTEMIC coherence-hypothesis defect across 7 declarations in FlatteningStratification.lean
The prover flagged `genericFlatness`, but `lean-vs-blueprint-checker`
(`.archon/task_results/lean-vs-blueprint-checker-flattening303.md`) found the defect is
**systemic: 7 must-fix declarations** all take a sheaf input `F : X.Modules` with **no
coherence hypothesis**, so their `sorry` bodies are unprovable (generic flatness is
false for arbitrary quasi-coherent sheaves):
`genericFlatness`, `flatLocusStratification`, `flatLocusReduction`, `flatLocusAssembly`,
`flatteningStratification`, `flatteningStratification_universal`,
`flatteningStratification.ofCurve`.

**Root cause + required fix:** Mathlib has **no `IsCoherentSheaf` for `Scheme.Modules`**,
so the planner must first **define a project-local coherence predicate** (an
affine-local `Module.FinitePresentation` quantifier) and add it to all seven signatures.
None are in `archon-protected.yaml`, so the planner can re-sign. Do **not** send a prover
at any of these seven until the predicate exists and the signatures carry it. I added a
`% NOTE:` to the `thm:generic_flatness` blueprint block; the blueprint itself is also
inadequate here (specifies `\F` coherent in prose but gives no Lean typeclass guidance —
the direct cause of all seven defects), so this needs a **blueprint-writer** pass on
`Picard_FlatteningStratification.tex` to specify the coherence predicate, in tandem with
the re-sign.

Secondary (major) issues from the same report, to fold into the re-sign:
- **`LocallyOfFiniteType` vs `FiniteType`**: Lean uses the weaker `LocallyOfFiniteType`;
  blueprint says finite-type. Either justify it suffices (quasi-compactness from
  noetherian `S`) or add `[QuasiCompact p]`.
- **Conclusion incompleteness**: `flatteningStratification` drops the Hilbert-polynomial
  labelling + closure-of-strata (Nitsure (i)/(iii)); `flatteningStratification_universal`
  encodes only the forward direction of the universal property.

## HIGH

### 2. ENGINE `pushPullMap_comp` — STOP retrying erw/congr on the pentagon (5th iter on this pole)
The kernel-`whnf` wall is genuinely gone (real progress), but the residual pullback
pseudofunctor pentagon is **defeq-not-syntactic** and every direct tactic was tried and
failed this iter: `rw`/`reassoc_of%`/`pseudofunctor_associativity` (no match), `erw`
(whnf-unfolds `pullbackComp` mate → explodes), `congr 1` (HEq), and the assembled
`rawPushPullMap_comp` **kernel-times-out even at `maxHeartbeats 4000000`**. Both the
wrapper and the reduction lemma are currently **commented out** (4 axiom-clean bricks
remain live: `rawPushPullMap`, `pushPullMap_eq_raw`, `pushPull_unit_comp`,
`pushforwardComp_hom_app_id`).

Do a **structural change before the next prover attempt**, per the prover's own in-file
analysis (lines 464–477). Two candidates:
  - (a) **Reformulate the pentagon via the adjunction transpose**
    (`(pullbackPushforwardAdjunction _).homEquiv`) so it becomes a `pullback`-side
    identity provable by `pseudofunctor_associativity` without touching the
    strict-pushforward defeq wall.
  - (b) Add a **strictness-aware `@[simp]` normal form** for `pushforward (a ≫ b)` so
    the lead peel is syntactic.
Recommended correctives: **`mathlib-analogist` (cross-domain-inspiration mode)** —
"how does Mathlib discharge a pseudofunctor-associativity pentagon when the cells carry
non-syntactic instances?" — and/or **`effort-breaker`** on the pentagon to split it at
the four `pullbackComp` cells. This is a CHURNING-watch pole: it made real progress this
iter, but it is the 5th iter without closure; require a structural change, not another
tactic-grind round.

### 3. DUAL `sliceDualTransportInv` — continue, naturality is now reachable
`app` is **closed** (1 sorry eliminated, 6→5). The next pieces are genuinely unblocked:
  - reverse-component **naturality** (thin-poset square over `(Over fV)ᵒᵖ`; `app` is now
    an explicit 4-leg composite — close leg-by-leg);
  - then `left_inv`/`right_inv` round-trips (now reachable);
  - then the forward `sliceDualTransport.hom` and `dual_restrict_iso` Step-4 `isoMk`
    naturality.
This lane is **CONVERGING** — keep the prover on it. Note the load-bearing
`hβ` β-compatibility hypothesis pattern (discharge at the call site via
`Iso.hom_inv_id` for `β = whiskerRight (f.appIso).inv`).

## MEDIUM

### 4. Lane 2 (D3′ `TensorObjSubstrate.lean`) — reconcile objective with reality
The objective's named tensor-iso nodes (`jw_ismonoidal`, `pullback0_tensor_iso`,
`pullback_tensor_iso_loctriv`, `pullback_compatible_with_tensorobj`,
`stalk_tensor_commutation_naturality_right`) **have no Lean declaration** — they are
blueprint statements only. Either scaffold them (lean-scaffolder) or de-scope the lane.
The actual D3′ tail is a project-local 6-step mate calculus over Mathlib-absent
coherence; only one incremental forward step landed this iter. Consider `effort-breaker`
on the D3′ tail or pausing the lane until the ENGINE pentagon technique is settled (the
two share the strict-pushforward / pullbackComp defeq problem).

### 5. 1-to-1 coverage debt — blueprint the 9 new `lean_aux` helpers
`archon dag-query unmatched` reports **9 prover-created helpers with no blueprint
entry** (all axiom-clean, no sorry). The planner should author blueprint stubs
(statement + `\lean{}` + `\uses{}`) so they re-enter the dependency graph:
  - `AlgebraicGeometry.rawPushPullMap` (CechHigherDirectImage.lean) — scheme-level
    push–pull map, over-triangle as free hyp; deps: `pushforward`/`pullback`,
    `pullbackPushforwardAdjunction`, `pushforwardComp`, `pullbackComp`.
  - `AlgebraicGeometry.pushPullMap_eq_raw` — `rfl` bridge `pushPullMap = rawPushPullMap`.
  - `AlgebraicGeometry.pushPull_unit_comp` — composite-unit decomposition (mate).
  - `AlgebraicGeometry.pushforwardComp_hom_app_id` — pushforward strictness
    (`pushforwardComp.hom.app = 𝟙` by `rfl`).
  - `AlgebraicGeometry.Scheme.Modules.unitRelabelSwap` (DualInverse.lean) — `inv ε` for
    the `X.presheaf.map (eqToHom …)` section-ring relabel.
  - `AlgebraicGeometry.Scheme.Modules.isIso_ε_restrictScalars_presheafMap` — ε iso for
    the bijective section-ring relabel (phrased at the CommRingCat carrier).
  - `AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_finite`
    (FlatteningStratification.lean) — deps: `FinitePresentation.exists_free_localizedModule_powers`.
  - `AlgebraicGeometry.GenericFreeness.exists_flat_localizationAway_of_finite` — deps:
    the above + `Module.Flat.of_free`.
  - `AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_moduleFinite` —
    deps: `finitePresentation_of_finite` + the free-localization lemma.

## MEDIUM (from lean-auditor, `.archon/task_results/lean-auditor-iter303.md` — 0 must-fix, 6 major, 6 minor)

### 6. DualInverse.lean — move 86–100 line planning-comment blocks to the blueprint
Two proof bodies in `TensorObjSubstrate/DualInverse.lean` carry 86–100-line
planning-comment blocks. These belong in the blueprint chapter, not inline — they bloat
the Lean and rot. Planner/blueprint-writer should migrate the mathematical content into
`Picard_TensorObjSubstrate.tex` and trim the Lean comments to a one-line pointer.

### 7. `maxHeartbeats` CI-fragility watch
- `pullbackEtaUnitSquare` (TensorObjSubstrate.lean:1787) carries `maxHeartbeats 3200000`
  (16× default) — flagged by the auditor as CI-fragility; the `φ'`-`letI` spelling chain
  is the documented culprit. This iter ADDED more: `pushPullMap_eq_raw` needs
  `maxHeartbeats 1000000` and the commented-out `rawPushPullMap_comp` needed 4000000 and
  still kernel-timed-out. The accumulation of high-heartbeat options is a systemic smell
  tied to the strict-pushforward / `pullbackComp` defeq problem (same root as HIGH 2).
  Track; a structural fix to the defeq wall would remove several of these at once.

## LOW / housekeeping

- **`\leanok` staleness**: `sync_leanok-state.json` records `iter: 271` (< 303). The
  deterministic sync may not have run on the current tree, so some `\leanok` markers
  could be stale. Not raised as CRITICAL per the review protocol — flagging the
  ambiguity for the planner; the next `sync_leanok` pass will reconcile.
- Three Čech theorems in CechHigherDirectImage.lean (`CechAcyclic.affine`,
  `cech_computes_higherDirectImage`, `cech_flatBaseChange`) remain `sorry` — all are
  documented as **Mathlib-absent** (spectral sequences / affine base change for
  `Scheme.Modules`). Not low-hanging; do not assign without a Mathlib-gap plan.

## Blocked — do NOT re-assign without structural change
- `genericFlatness` proof — blocked on its own defective signature (see CRITICAL 1).
- `pushPullMap_comp` via tactic-grind — blocked on defeq-not-syntactic pentagon + kernel
  timeout (see HIGH 2); needs reformulation first.
- D3′ tail named tensor-iso nodes — blocked: no Lean decls exist (see MEDIUM 4).
