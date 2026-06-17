# Iter-240 — objectives detail

## Lane 1 (CRITICAL PATH) — `Picard/TensorObjSubstrate.lean`, A.1.c substrate `IsInvertible.pullback` via **Route Z** [mathlib-build]

Recipe pivoted this iter (sectionwise-`extendScalars` is DEAD; see `analogies/pullback-monoidal.md`).
Blueprint: `Picard_TensorObjSubstrate.tex` § `sec:tensorobj_pullback_monoidality` (rewritten this iter).

**Build order (mathlib-build; no sorry pins; go as far as possible):**

1. **Phase 1 — `pullbackUnitIso` (`f^*𝒪_X ≅ 𝒪_Y`), the cheap half — PRIMARY target this iter.**
   - The Mathlib map `SheafOfModules.pullbackObjUnitToUnit f` is an iso on a Final chart via
     `SheafOfModules.instIsIsoPullbackObjUnitToUnitOfFinal` [verified present, mathlib-analogist ts240].
   - Globalize "iso on every affine chart ⇒ global iso" via the project's axiom-clean
     `isIso_of_isIso_restrict` (`TensorObjSubstrate.lean:567`).
   - Per-chart: factor `V.ι ≫ f` through `g = f.resLE U V` (`Opens.map g.base` Final via
     `final_of_representablyFlat`); the restricted comparison matches `pullbackObjUnitToUnit g`.
     This is literally the `i7` step of the proven `IsLocallyTrivial.pullback`
     (`LineBundlePullback.lean:156-193`) — REUSE its `i1…i7`/naturality chain
     (`pullbackComp`, `restrictFunctorIsoPullback`, `pullbackCongr`, `pullbackId`).
   - The one genuinely-new ingredient: the naturality lemma tying the restricted global
     `pullbackObjUnitToUnit` to the local `pullbackObjUnitToUnit g`. Build it axiom-clean.

2. **Phase 2 — `pullbackTensorIso` (`f^*(M⊗N) ≅ f^*M ⊗ f^*N`) — POINTWISE iso, attempt after Phase 1.**
   - **DESCOPED** (strategy-critic ts240 must-fix): `IsInvertible.pullback` consumes ONLY the pointwise iso
     at the witness pair — do NOT build the full `OplaxMonoidal f^*` instance / `CoreMonoidal.ofOplaxMonoidal`
     packaging (it needs a hand-built oplax structure — `leftAdjointOplaxMonoidal` is ABSENT — and is OFF-path).
   - No Mathlib pullback tensorator. Build a `pullbackObjTensorToTensor` comparison map (analogue of
     `pullbackObjUnitToUnit`); prove iso by the same finality chart-chase as Phase 1 (on a Final chart
     pullback is locally extension-of-scalars = strong monoidal in `ModuleCat`, local comparison = the
     `extendScalars` tensorator); globalize via `isIso_of_isIso_restrict`; take `pullbackTensorIso := asIso`
     of that pointwise comparison. The landed private brick `sheafifyTensorUnitIso` (~L884) is the RHS
     reconciliation it consumes after `SheafOfModules.sheafificationCompPullback`.

3. **`IsInvertible.pullback`** — once 1+2 land: composite `pullbackTensorIso⁻¹ ≫ f^*e ≫ pullbackUnitIso`
   on the existing witness (the Stacks `lemma-pullback-invertible` proof, already in the blueprint).

**Critic watch (progress-critic ts240):** if Phase 1 ALSO fails to close (≥3 helpers, no iso), consult
mathlib-analogist on the `pullbackObjUnitToUnit`/`pullbackComp`/`restrictFunctorIsoPullback` naturality
cluster before re-dispatch. Phase 1 is expected to close (it is a direct port of a proven chart-chase).

**FLAT-restriction fallback (recorded reversing signal):** if Phase 2 proves multi-iter-intractable,
fall back to a FLAT-restricted `IsInvertible.pullback` (the RPF maps `π_T`/base-changes are all flat) —
do NOT do this pre-emptively; only on a Phase-2 stall.

Do NOT touch the group-law section (done) or the deferred dual-bridge sorries
(`exists_tensorObj_inverse` L715, `addCommGroup_via_tensorObj` L1005).

## Lane 2 (engine, parallel) — `Cohomology/FlatBaseChange.lean`, close `affineBaseChange_pushforward_iso` [prove]

STUCK route pivot (progress-critic ts240 STUCK; this is NOT a verbatim re-dispatch — concrete new mechanism).
Blueprint: `Cohomology_FlatBaseChange.tex` `lem:pushforward_spec_tilde_iso` (+ this-iter natural-in-open note).

**The pivot (mathlib-analogist fbc-qc, verified live; see `analogies/fbc-qc.md`):**
1. **Carrier-wall fix:** discharge `hloc` using **`algebraize [φ.hom]`** — VERIFIED to run at the sorry
   (FlatBaseChange.lean:572). It installs the honest `Algebra ↑R ↑R'` + `IsScalarTower` instances that the
   project's own `IsLocalizedModule.powers_restrictScalars` (L452) requires. **Do NOT** use
   `letI := Module.compHom _ φ.hom` (the dead 4-iter mechanism — not consumed by `LinearMap.restrictScalars`).
2. **The naturality unblock:** upgrade `gammaPushforwardIsoAt` to be NATURAL in the open argument (the
   structure-sheaf restriction maps commute with the `{e_{D(a)}}` family) — this is upstream's
   `pushforwardCompModulesSpecToSheafIso`; it lets the per-`a` `hloc` follow from the `⊤`-level localization
   + naturality, instead of re-proving the section-level square `e₂∘ρ = restrictScalars σ ∘ e₁` by hand.
3. Feed the `{hloc(a)}` family to `pushforward_spec_tilde_iso_of_isLocalizedModule` (L395, axiom-clean) ⇒
   close `pushforward_spec_tilde_iso` ⇒ close `affineBaseChange_pushforward_iso` (L470).

**Do NOT attempt** the L492 sorry `flatBaseChange_pushforward_isIso` (deep Čech+flatness; documented).

**HARD reversing signal (progress-critic ts240 STUCK + iter-241 quality gate):** the sorry count MUST drop
this iter (close `pushforward_spec_tilde_iso`/`affineBaseChange_pushforward_iso`). If it stays flat AGAIN,
the next step is the Mathlib BUMP (#37189) — NOT another in-tree attempt — or user escalation. `algebraize`
is the verified mechanism; this is the concrete-idiom dispatch the STUCK corrective demanded.

## Mathlib-bump decision (recorded; NOT taken this iter)
Bumping Mathlib past 2026-05-31 (#37189) would collapse the FlatBaseChange affine close to ~3 lines
(`isIso_fromTildeΓ_pushforward`). DEFERRED: a project-wide bump mid-flight is disruptive (many lanes
in motion). The in-tree port via `algebraize` is owned by the project and not wasted by a future bump.
Revisit if iter-241 FlatBaseChange stays flat.
