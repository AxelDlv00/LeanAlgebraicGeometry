# Recommendations for the next plan iteration (iter-062)

## Review-subagent findings (no must-fix-this-iter; all 3 majors are next-iter blueprint actions)
- **lean-auditor `iter061`** → 0 must-fix / 0 major / 2 minor. Both files clean; all 5 new decls
  genuine, all sorries honest, no excuse-comments, no kernel-soundness trap. Report:
  `task_results/lean-auditor-iter061.md`.
  - MINOR: `CechSectionIdentification.lean:723` `set_option synthInstance.maxHeartbeats 800000 in` is
    attached to the `sorry`-bodied `pushPull_sigma_iso` — a no-op until the proof lands (harmless).
  - MINOR: `OpenImmersionPushforward.lean:42–49` `isZero_of_faithful_preservesZeroMorphisms` is a
    verbatim copy from `CechAugmentedResolution.lean` (import-constraint duplication, low priority).
- **lvb-csi** → 1 MAJOR (blueprint adequacy), 0 must-fix. `task_results/lean-vs-blueprint-checker-csi.md`.
  - **MAJOR (HIGH for Route A):** `lem:pushPull_binary_coprod_prod`'s proof sketch is under-specified —
    it omits the two Lean blockers the prover hit (the `toPresheaf ⋙ evaluation` instance trap +
    the Ab→ModuleCat `isLimitOfReflects` bridge). **Action: blueprint-writer add a `% NOTE:` to that
    proof block documenting the `SheafOfModules.evaluation V` route** (reduce via
    `Scheme.Modules.Hom.isIso_iff_isIso_app`; reflect `isProductOfDisjoint` through
    `forget₂ (ModuleCat R) Ab`). This converts the prover handoff into durable guidance — do it BEFORE
    the next CSI prover round. Confirms iter-056 AUGMENTED fix for Stubs 5/6 is intact on both sides.
- **lvb-openimm** → 2 MAJOR (blueprint adequacy), 0 must-fix. `task_results/lean-vs-blueprint-checker-openimm.md`.
  - **MAJOR (HIGH for Route B):** `lem:pushforward_iso_preserves_qcoh` prescribes the HARDER quadruple
    route (`pushforward_commutes_restriction` + `pushforwardPushforwardEquivalence`); the prover found
    the simpler single-hom `pullback ψ_r` route. **Action: blueprint-writer retarget that proof sketch
    to the `pullback ψ_r` route and DEMOTE/decouple `lem:pushforward_commutes_restriction` from its
    `\uses`** (it is bypassed). Do this BEFORE a prover attempts `hqc`, else the prover implements ~100
    LOC of unnecessary plumbing.
  - **MAJOR (coverage):** `pushforward_iso_qcoh_of_slice_qcoh` (non-private, built this iter) has NO
    blueprint node — add one (suggested `lem:pushforward_iso_qcoh_of_slice_qcoh`) feeding
    `lem:pushforward_iso_preserves_qcoh`, bundling `coversTop_preimage_of_iso` into its `\lean{}`.

## ⚠️ TOP PRIORITY — both active routes are now genuinely STUCK on the PARTIAL×K metric; do NOT just re-dispatch

The progress-critic flagged BOTH routes CHURNING entering iter-061. The planner executed the prescribed
correctives (effort-break CSI, mathlib-analogist OpenImm) and dispatched both provers anyway. **Both
returned PARTIAL with ZERO sorry movement.** That is the predicted CHURNING outcome — the correctives
did not convert. Re-dispatching the same lanes a 5th/3rd time without a *structural* change is the exact
failure this loop guards against. Concrete structural actions per lane below.

### Route A — CSI Stub 2 (`isIso_coprodDecompMap`): the difficulty is a precise INSTANCE TRAP, not math
- **Status:** PARTIAL×4. L1 (`isIso_modules_of_toPresheaf`) + 2 helpers landed; the L2 base case
  `isIso_coprodDecompMap` is blocked on `toPresheaf ⋙ evaluation` not getting a composite
  `PreservesLimitsOfShape` instance (the codomain is the `TopCat.Presheaf Ab` def-wrapper).
- **The FIX is known and concrete** (prover `/- Handoff -/` block + KB Proof Pattern): switch the
  reduction functor from `Scheme.Modules.toPresheaf ⋙ (evaluation _ Ab).obj V` to the single
  `SheafOfModules.evaluation V` (lands in `ModuleCat`, has a DIRECT `PreservesLimitsOfShape` instance,
  `.../Sheaf/Limits.lean:85`); reduce via `Scheme.Modules.Hom.isIso_iff_isIso_app`; reflect the
  `TopCat.Sheaf.isProductOfDisjoint` Ab-limit into `ModuleCat` through `forget₂ (ModuleCat) Ab` with
  `isLimitOfReflects`. Then ~60–100 LOC of `isProductOfDisjoint` cone-matching (opens
  `inl''ᵁinl⁻¹V`/`inr''ᵁinr⁻¹V`; ⊥/sup = `coprodPresheafObjIso` `h₁`/`h₂`; legs match via
  `restrictAdjunction_unit_app_app` `rfl`).
- **Recommended action:** this is a *single concrete leaf* with a known fix — one more `mathlib-build`
  prover round dispatched ONLY at `isIso_coprodDecompMap` with the `SheafOfModules.evaluation` directive
  baked in is justified (the trap was diagnosed, not just hit). **BUT** if it stalls again on the
  `isProductOfDisjoint` cone bookkeeping, do NOT re-throw — `effort-breaker` the cone-matching into
  (a) the disjoint-preimage geometric fact and (b) the sectionwise leg identification, exactly the
  finer cut the iter-061 effort-breaker pre-flagged.

### Route B — OpenImm `hqc`: the `of_coversTop` reduction is DONE; the residual is ONE Mathlib-absent hom `ψ_r`
- **Status:** PARTIAL. The reduction half landed axiom-clean (`coversTop_preimage_of_iso` +
  `pushforward_iso_qcoh_of_slice_qcoh`). The lone residual is the cross-ring slice structure-sheaf
  ring hom `ψ_r` (~100–150 LOC, genuinely novel — Mathlib does only the same-ring `bind` slice).
- **Two prerequisite plan actions BEFORE a prover round:**
  1. **`effort-breaker` on the `ψ_r` construction** — split into (a) the underlying ring hom restricting
     `φ.hom.toRingCatSheafHom` to `Over W`, (b) the `postEquiv.inverse` `Over.map (unitIso.inv)`
     coherence adjustment, (c) the comparison iso + `Presentation.map` transport. This is a ≥100 LOC
     novel construction — it should NOT enter a prover undeocomposed (same lesson as Stub 1's multi-iter
     stall).
  2. **`blueprint-writer` on `lem:pushforward_iso_preserves_qcoh`** — re-state it to the prover's SIMPLER
     `SheafOfModules.pullback ψ_r` route (one left-adjoint hom + unit iso `pullbackObjUnitToUnit` +
     comparison iso), NOT the current `pushforwardPushforwardEquivalence` `eqv/φ_r/ψ_r/H₁/H₂` quadruple.
     The blueprint currently prescribes the harder recipe; the prover found the single-hom route is
     enough. (`analogies/pushforward-commutes-restriction.md` has the mathlib-analogist's `bind`
     template — reconcile it with this simpler route.)
- The `of_coversTop` reduction (`pushforward_iso_qcoh_of_slice_qcoh`) is the right scaffold; keep it.

## Coverage debt — `archon dag-query unmatched` (4 live `lean_aux` + dead `affine`)
The planner should author blueprint entries (review agent does not write informal prose):
- **`AlgebraicGeometry.coprodDecompMap`** (private def, CechSectionIdentification.lean) — binary
  disjoint-cover comparison map `M ⟶ inl_*(M.restrict inl) ⨯ inr_*(M.restrict inr) = prod.lift (units)`.
  Bundle into `lem:pushPull_binary_coprod_prod`'s `\lean{}`.
- **`AlgebraicGeometry.isIso_prodLift_of_isLimit`** (private, CechSectionIdentification.lean) — general
  categorical fact `IsLimit (BinaryFan.mk α β) → IsIso (prod.lift α β)`; relies on `prodIsProd` +
  `conePointUniqueUpToIso_hom_comp`. Bundle into the same `\lean{}`.
- **`AlgebraicGeometry.coversTop_preimage_of_iso`** (private, OpenImmersionPushforward.lean) —
  cover-transport along a scheme iso. Bundle into the new node below.
- **`AlgebraicGeometry.pushforward_iso_qcoh_of_slice_qcoh`** (NON-private, OpenImmersionPushforward.lean)
  — needs its OWN blueprint node: iso-pushforward qcoh reduces to per-slice qcoh over a
  preimage-transported cover, via `IsQuasicoherent.of_coversTop` + `coversTop_preimage_of_iso`.
  Suggested label `lem:pushforward_iso_qcoh_of_slice_qcoh`, feeding `lem:pushforward_iso_preserves_qcoh`.
- `AlgebraicGeometry.CechAcyclic.affine` — DEAD (the `CechAcyclic:110` sorry on the abandoned route);
  carry-over, no action (or formally retire it).

## Throughput watch (from the planner's own iter-061 Risks)
Both phases have now EXCEEDED their original `Iters left` estimates and both produced no sorry movement
this iter. Per the planner's stated trigger ("if Stub 2 / `hqc` do NOT close iter-061, revise estimates
again"), the planner should re-estimate iter-062 and consider whether Route B is approaching OVER_BUDGET.
Neither route is mathematically blocked (both have concrete, named next steps) — the concern is purely
the iter-count, which argues for the *structural* actions above (effort-break + blueprint-rewrite) over
another bare re-dispatch.

## Reusable proof patterns discovered (full detail in PROJECT_STATUS Knowledge Base)
- Module-sheaf iso-by-reflection: `isIso_of_reflects_iso φ (Scheme.Modules.toPresheaf X)`.
- `IsLimit (BinaryFan.mk α β) → IsIso (prod.lift α β)` via `conePointUniqueUpToIso_hom_comp`; feed
  `prod.lift_fst`/`prod.lift_snd` to `simpa` explicitly (bare `simpa` does not reduce).
- The `toPresheaf ⋙ evaluation` instance trap and its `SheafOfModules.evaluation V` fix.
- `IsQuasicoherent.of_coversTop` reduction: pass `M` EXPLICITLY + scope `maxHeartbeats` bumps for the
  doubly-sliced `HasSheafify` synthesis.

## Do-NOT-retry (carry-over, still valid)
- OpenImm tilde route (circular); `pullback`-preserves-qcoh / `pushforward≅pullback`-for-iso (Mathlib-absent).
- CSI Stubs 5/6 must stay on the AUGMENTED `D'_aug` target (iter-056 finding).
- No `Functor.rightDerived ≅ Ext` lemma exists (iter-059).
