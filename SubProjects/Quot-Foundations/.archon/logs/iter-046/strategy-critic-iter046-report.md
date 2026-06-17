# Strategy Critic Report

## Slug
iter046

## Iteration
046

## Routes audited

### Route: FBC (affine iso + globalization)

- **Goal-alignment**: PASS — FBC is one of the three named goal legs; the route ends at `thm:flat_base_change_pushforward`.
- **Mathematical soundness**: PASS — affine reduction to `regroupEquiv` (done) + section-mate via composite-adjunction conjugate chain is a standard mate-of-adjunctions argument; the Čech-free `H⁰`-equalizer globalization is correct (flat `−⊗B` preserves finite equalizers).
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no — FBC-A1 is PARKED but carries a concrete timeline (2–4 iters), a decided route (factored `conjugateEquiv_symm_comp` leg-chain, not monolithic β), and the three per-layer legs are axiom-clean. This is bounded parking with a plan, not an indefinite deferral or goal weakening.
- **Effort honesty**: reasonable, with a caveat — the residual is described as "structurally-known... mechanical transport." The route has a documented history of a one-shot/monolithic attempt that walled, and a separate "affine tilde-transport" framing that the strategy itself records as funnelling back to the *same* `_legs_conj` crux. The recurring "only mechanical work remains" framing for FBC should be treated with skepticism until the keystone discharge actually compiles; the multi-hundred-LOC φ/ψ Spec-layer transport is real work, not a footnote.
- **Parallelism under-exploited**: no, but note an inconsistency: FBC-B is tagged ACTIVE while its *completion* is "gated on FBC-A iso," and FBC-A1 (which produces that iso) is PARKED. FBC-B can only do scaffold/eqLocus prep (already done) until A1 lands, so its ACTIVE status overstates available throughput.
- **Verdict**: SOUND

### Route: GF (generic flatness, geometric wrapper)

- **Goal-alignment**: PASS — wraps the done algebraic core `genericFlatnessAlgebraic` to the goal's `thm:generic_flatness`.
- **Mathematical soundness**: PARTIAL — see below. The overall dévissage (pass to affine noetherian domain, finite affine cover, per-patch algebraic form, conclude on `D(∏fⱼ)`) is correct, and the G1 locality half via `Module.Finite.of_localizationSpan` (verified to exist) is sound. The concern is the **base-case framing**: "`SheafOfModules.IsFiniteType` generating-sections epi ⟹ Γ-level module surjectivity, via stalk=LocalizedModule + epi⟺stalkwise-epi." A bare *stalkwise-epi ⟹ global-section-epi* step is FALSE in general — global-section surjectivity holds here only because, on an affine with quasi-coherent kernel, `Γ` is exact (Serre `H¹=0` / the affine qcoh≃Mod equivalence is exact). The one-line framing elides the load-bearing hypothesis.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no — the base case is named, framed, and slated for effort-break-then-prove this iter with an estimate (3–5 iters). It is on the critical path and the strategy treats it as such.
- **Phantom prerequisites**: none. `Module.Finite.of_localizationSpan` VERIFIED; `SheafOfModules.IsFiniteType` is a real Mathlib structure the route consumes.
- **Effort honesty**: reasonable.
- **Parallelism under-exploited**: no.
- **Verdict**: CHALLENGE — the base-case proof must route through affine-qcoh exactness of `Γ`, not a bare stalkwise-epi step; and it should first check whether the **already-built gap1/gap2 affine qcoh≃Mod descent** (`Scheme.Modules.*`, `isLocalizedModule_basicOpen`) discharges the base case by exact-functor transport (sheaf-epi ↦ module-epi across an equivalence) far more cheaply than a fresh stalk=LocalizedModule build. The reference index names tag **01PB** (`lemma-finite-type-module`: `M̃` finite-type ⟺ `M` finite) as the intended backing — this is the clean statement of the base case, and its proof content is exactly the affine-qcoh exactness argument, not a stalkwise-epi shortcut.

### Route: QUOT (Hilbert poly → Quot functor → Grassmannian → representability)

- **Goal-alignment**: PASS — covers all four goal decls (`hilbert_polynomial`, `quot_functor`, `grassmannian_scheme`, `grassmannian_representable`).
- **Mathematical soundness**: PASS — graded-Hilbert-function encoding via `existsUnique_hilbertPoly` (VERIFIED, `[CharZero]`) + done rationality engine; GR-cells/glue/sep/proper done; representability via functor-of-points + RelativeSpec. Standard FGA construction.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: partially — see Infrastructure-deferral findings (SNAP / `def:sectionGradedRing` tensor powers).
- **Phantom prerequisites**: none verified-missing; `existsUnique_hilbertPoly` VERIFIED. Open Qs Q1 (Serre `m≫0` agreement; "Hartshorne II.5.17" flagged unverified) and Q4 (RelativeSpec tag uncertainty) are honestly fenced, not assumed.
- **Effort honesty**: under-counted at SNAP — see findings. QUOT-repr's 6–12 iter / ~400–1000+ LOC range is appropriately wide and honest.
- **Parallelism under-exploited**: yes — the SNAP blueprint (a plan-side authoring task, `Picard_SectionGradedRing.tex`) gates the entire longest serial chain to representability yet is not started. It can and should be authored in parallel with the current GF / QUOT-defs prover lanes rather than waiting for them to clear.
- **Verdict**: CHALLENGE — decompose SNAP and start its blueprint now (parallelism + effort honesty); the sequencing itself is correct.

## Format compliance

- **Size**: 130 lines / 14,664 bytes — **over budget** (14.3 KB > ~12 KB ceiling; line count fine).
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Completed`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in canonical order.
- **Per-iter narrative detected**: yes — pervasive `iter-NNN` tags outside the `## Completed` Iters cell. Representative: `"iter-045: keystoneAdjR/keystoneBeta/huce all built axiom-clean"` (Phases Risks cell), `"gap2 DONE (iter-044). G1 LOCALITY half DONE iter-045"`, `"G1-core DONE iter-042"`, `"gap2 FULLY CLOSED iter-044"` (Routes + Mathlib-gaps prose). The ledger exemption covers only the Completed table's Iters column; these are in active-table cells and route prose.
- **Accumulation detected**: no — completed phases are correctly in `## Completed` (10 rows, within bound); no excised routes lingering.
- **Table discipline**: FAIL (drift) — `## Phases & estimations` Risks cells carry multi-sentence prose (e.g. the FBC-A1 and GF-geo Risks cells run ~3–4 sentences each), violating "one short line per cell." This prose bloat is the main driver of the over-budget byte count.
- **Format verdict**: DRIFTED

## Infrastructure-deferral findings

### Deferred: SNAP — `SheafOfModules` tensor powers `L_s^{⊗m}` + lax-monoidal `Γ` (`def:sectionGradedRing`)

- **Required by goal**: yes — it is the prerequisite to *state* `def:hilbert_polynomial`, which gates `def:quot_functor` and `thm:grassmannian_representable`. The final theorem does not hold without it.
- **Current plan for building it**: marked "NEXT (needs blueprint)" — no `Picard_SectionGradedRing.tex` chapter yet, and no decomposition into concrete sub-phases (the monoidal-structure build vs. the lax-monoidal-`Γ` build vs. the power-series assembly are not separated).
- **Timeline**: present but optimistic — 2–4 iters / ~120–300 LOC for net-new monoidal category infrastructure on `SheafOfModules` plus a lax-monoidal global-sections functor (both Mathlib-absent). Comparable net-new builds in `## Completed` ran far larger: GradedHilbertSerre (9 iters / ~1290 LOC), GF-alg (9 iters / ~900 LOC). A from-scratch monoidal/lax-monoidal layer at a fraction of those looks under-counted.
- **Verdict**: CHALLENGE — author the blueprint chapter this iter (a plan-side task, parallelizable with prover lanes), decompose into sub-phases, and re-estimate against the realized LOC of the comparable completed net-new builds.

## Alternative routes (suggested)

### Alternative: GF base case via exact-functor transport across the existing qcoh≃Mod equivalence

- **What it looks like**: Instead of a fresh `stalk = LocalizedModule` + `epi ⟺ stalkwise-epi` construction, reuse the gap1/gap2 affine descent (`Scheme.Modules.*`, `isLocalizedModule_basicOpen`) which already identifies `Γ(F, Spec B)` with a `B`-module and is (or extends to) an exact equivalence on quasi-coherent sheaves. A sheaf epimorphism `O^I ↠ F` on the affine patch transports to a module epimorphism `B^I ↠ Γ(F)` by functoriality/exactness of the equivalence; finite `I` then gives `Module.Finite`. This is exactly the content of Stacks **01PB**.
- **Why it might be cheaper or sounder**: it avoids re-deriving stalkwise machinery, reuses infrastructure already proved axiom-clean, and routes the surjectivity through a *correct* mechanism (exactness of `Γ` on affine qcoh) rather than the in-general-false stalkwise-epi ⟹ global-epi step.
- **What the current strategy may have rejected**: the GF-G1 memory notes a "global compHom Module instance LOOPS" dead end, suggesting the clean equivalence route hit instance-resolution friction. That is a real obstacle — but it argues for a *local/basic-open-scoped* transport (which gap2 already operates in), not for abandoning equivalence-transport in favour of a fresh stalk build.
- **Severity of the omission**: major

## Prerequisite verification

- `Polynomial.existsUnique_hilbertPoly`: VERIFIED (`Mathlib.RingTheory.Polynomial.HilbertPoly`, carries `[CharZero F]` — matches Q3).
- `Module.Finite.of_localizationSpan`: VERIFIED (`Mathlib.RingTheory.Localization.Finiteness`, `Localization.Away`/`LocalizedModule.Away` signature — matches GF locality reduction).

## Must-fix-this-iter

- Route GF: CHALLENGE — base-case proof must route through affine-qcoh exactness of `Γ` (kernel quasi-coherent ⟹ `H¹=0`), NOT a bare stalkwise-epi ⟹ global-epi step which is false in general. Before committing the multi-piece stalk build, check whether the already-proved gap1/gap2 qcoh≃Mod descent discharges the base case via exact-functor transport (cf. Stacks 01PB). Update STRATEGY or rebut in plan.md.
- Route QUOT / Infrastructure-deferral (SNAP): CHALLENGE — `def:sectionGradedRing` tensor powers + lax-monoidal `Γ` is required by the goal, has no blueprint and no sub-phase decomposition, and is estimated at a fraction of comparable net-new builds. Author the blueprint and decompose this iter (parallel with prover lanes); re-estimate.
- Format: DRIFTED — strip `iter-NNN` tags from active-table cells and route/gaps prose (keep bare "DONE"; the iter ledger lives only in the `## Completed` Iters column), and collapse the multi-sentence Phases `Risks` cells to one short line each. This brings the file back under the ~12 KB ceiling. Move any historical detail to the iter sidecar.

## Overall verdict

The strategy is fundamentally sound: all three legs are goal-aligned, the two load-bearing Mathlib prerequisites (`existsUnique_hilbertPoly`, `of_localizationSpan`) are verified present, and reference uncertainty (Q1, Q4) is honestly fenced rather than assumed away. Parking FBC-A1 is defensible — it blocks no other route and carries a concrete timeline and a decided (factored, non-monolithic) discharge route, so it is bounded parking, not goal weakening. Two strategic items must be addressed this iter. First, the GF base case is framed via a stalkwise-epi step that is mathematically incomplete: global-section surjectivity on the affine patch follows from exactness of `Γ` on quasi-coherent sheaves (Stacks 01PB), and the existing gap1/gap2 qcoh≃Mod descent likely discharges it by exact-functor transport more cheaply than a fresh stalk build — the planner must either re-route through that exactness or rebut. Second, the strategy defers SNAP (`def:sectionGradedRing` tensor powers + lax-monoidal `Γ`), which is required for the stated goal — it gates the entire Hilbert-polynomial → Quot → representability chain — yet has no blueprint, no sub-phase decomposition, and an estimate well below comparable net-new builds; its blueprint is a plan-side task that should be started in parallel now. Format has DRIFTED (over the byte ceiling, pervasive per-iter `iter-NNN` narrative outside the ledger column, and multi-sentence table cells) and should be restructured in place.
