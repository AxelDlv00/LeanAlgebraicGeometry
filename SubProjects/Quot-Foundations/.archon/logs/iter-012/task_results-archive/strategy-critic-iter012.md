# Strategy Critic Report

## Slug
iter012

## Iteration
012

## Routes audited

### Route: FBC (flat base change, i=0)

- **Goal-alignment**: PASS — direct-on-sections affine lemma + Čech-degree-0/1 equalizer globalization closes `lem:affine_base_change_pushforward` + `thm:flat_base_change_pushforward` without higher cohomology, staying inside the Čech-independent leg.
- **Mathematical soundness**: PARTIAL — the section-identity route is plausible and its core infra is verified, but the route description is internally contradictory about whether the adjoint-mate work survives (see below).
- **Sunk-cost reasoning detected**: no — "regroupEquiv CLOSED" is a status record, not a justification-by-prior-effort.
- **Infrastructure-deferral detected**: yes — the three mate identities (unit-value / fstar-reindex / gstar-transpose) are the hardest prerequisite both before and after the claimed pivot; see Infrastructure-deferral findings.
- **Phantom prerequisites**: none — `Algebra.IsPushout.cancelBaseChange` (+ `cancelBaseChange_tmul : 1 ⊗ₜ[A] m ↦ 1 ⊗ₜ[R] m`) and `Module.Flat.ker_lTensor_eq` both VERIFIED.
- **Effort honesty**: reasonable — `~120–280` LOC / 2–3 iters for the residual three sub-lemmas + restriction-compat is consistent with the scope.
- **Verdict**: CHALLENGE — reconcile the "tower dropped" vs. "tower is the residual work" contradiction.

### Route: GF (generic flatness)

- **Goal-alignment**: PASS — algebraic core `genericFlatnessAlgebraic` + geometric wrapper over an affine cover matches `thm:generic_flatness` / `thm:generic_flatness_algebraic`.
- **Mathematical soundness**: PASS — the `Nat.strong_induction_on d` that *generalizes the base domain `A`* (so the IH typechecks at the reindexed base `A_g`) is exactly the right shape for Nitsure §4; shared-universe `(A N : Type u)` is the correct constraint to make the reindex re-enter the motive.
- **Phantom prerequisites**: none — `IsNoetherianRing.induction_on_isQuotientEquivQuotientPrime` VERIFIED in `Mathlib.RingTheory.Ideal.AssociatedPrime.Finiteness`.
- **Effort honesty**: reasonable.
- **Verdict**: SOUND.

### Route: QUOT (Quot functor, Grassmannian, Hilbert polynomial)

- **Goal-alignment**: PASS — predicate-first build + graded-Hilbert-function encoding closes the four QUOT goal nodes while staying Čech-independent (pinning to `M = im(Sᴺ → ⊕ₘ Γ(F⊗Lᵐ))` correctly avoids the left-exactness/`H¹` defect).
- **Mathematical soundness**: PASS — the `dim_κ M_m = dim_κ Γ(F_s⊗L_s^m)` for `m≫0` argument legitimately decouples `Φ_s` from `H¹`.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: yes — the forward annihilator characterization is deferred to the `isIso_fromTildeΓ_of_isQuasicoherent` gradient lane with no concrete iter estimate and no named downstream consumer; see findings.
- **Phantom prerequisites**: none — `IdealSheafData` VERIFIED (`Mathlib.AlgebraicGeometry.IdealSheaf.Basic`); `Polynomial.existsUnique_hilbertPoly` VERIFIED; `ModuleCat.tilde` / `Scheme.Modules` / `SheafOfModules.IsQuasicoherent` VERIFIED. The graded Hilbert–Serre rationality lemma is correctly recorded as Mathlib-ABSENT (no `hilbertSeries`-of-graded-module hit) → project-new material.
- **Effort honesty**: reasonable, with one caveat — QUOT-repr `~400–1000+` LOC / 6–12 iters honestly reflects the deepest target; the `?`-free estimates elsewhere are credible.
- **Parallelism under-exploited**: no — the strategy explicitly notes the four QUOT files import only Mathlib and are authorable in parallel with FBC-A/GF-alg.
- **Verdict**: CHALLENGE — name the forward-characterization consumer and confirm the bridge lands before it is needed; investigate a shorter local route before committing to the global-presentation detour.

## Format compliance

- **Size**: 140 lines / 11939 bytes — within budget (~250 lines / ~12 KB), but the byte count is within ~350 bytes of the ceiling; trimming verbose cells (below) restores headroom.
- **Headings**: PASS — `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material` in canonical order. `## Completed` omitted; defensible since no full *phase* has closed (only sub-results: regroupEquiv, P1 predicates).
- **Per-iter narrative detected**: no — `DONE` / `NEXT` / `CLOSED` are status tags, not iteration narrative.
- **Accumulation detected**: no completed phase sits in the active table; sub-results noted inline in still-active rows are acceptable.
- **Table discipline**: FAIL (minor) — several `## Phases & estimations` cells are multi-clause run-ons rather than "one short line", e.g. the QUOT-defs Risks cell ("annihilator/schematicSupport/HasProperSupport DONE; NEXT = rank-r local-freeness predicate; forward-char gated on the tilde bridge; re-sign of the 4 stubs follows") and the FBC-A Risks cell. The data is correct but should be compressed.
- **Format verdict**: DRIFTED

## Infrastructure-deferral findings

### Deferred: the three FBC adjoint-mate identities (unit-value / fstar-reindex / gstar-transpose)

- **Required by goal**: yes — they are the residual content of `lem:affine_base_change_pushforward`, a goal node.
- **Current plan for building it**: the Phases table assigns them as the FBC-A residual ("effort-broken into 3 sub-lemmas: unit-value / fstar-reindex / gstar-transpose"). The Routes prose simultaneously claims they are "superseded ... dropped." These two statements are in direct contradiction.
- **Timeline**: concrete (2–3 iters) per the table.
- **Verdict**: CHALLENGE — this is rule-7 pattern #1 (a pivot that renames rather than solves). The parent's abstract adjoint-mate *tower* (categorical packaging via `pullbackPushforwardAdjunction` unit + pushforward pseudofunctor coherence) was discarded, but the *same three mate identities* reappear one altitude lower as section-level sub-lemmas. The hardest prerequisite is unchanged across the pivot. The pivot may still be a net win *if* the concrete `lTensor`/`tmul` versions are genuinely cheaper to discharge than the abstract categorical versions — but the strategy ASSERTS supersession instead of JUSTIFYING the relocation. Planner must either (a) state on merits why the section-level mate identities are strictly easier than the abstract tower, or (b) drop the "superseded/dropped" framing and acknowledge the three identities persist at a more concrete altitude.

### Deferred: forward annihilator characterization `(annihilator F).ideal U = Module.annihilator Γ(X,U) Γ(F,U)`

- **Required by goal**: partially — NOT required for the four QUOT stub re-signs (P1 DONE bridge-free, P2 proceeds independently) nor for the SNAP Hilbert-polynomial work (which uses `dim_κ M_m`, not the annihilator). The only plausible consumer is `thm:grassmannian_representable` / the Quot functor's universal property when verifying a concrete family's support conditions — and that phase is BLOCKED, 6–12 iters out.
- **Current plan for building it**: the bridge `lem:qcoh_section_localization_basicOpen`, gated on the `isIso_fromTildeΓ_of_isQuasicoherent` sub-build, flagged as a multi-iter Mathlib-gradient lane.
- **Timeline**: vague — "multi-iter ... pursue as a Mathlib-gradient lane", no iter estimate.
- **Verdict**: CHALLENGE — the deferral is *safe for the current frontier* (no live consumer), so this is not a REJECT. But the strategy never NAMES the eventual consumer or confirms the gradient lane will converge before QUOT-repr's other prerequisites do. If the lane stalls it silently becomes QUOT-repr's long pole. Planner must name the consumer and confirm the sequencing, or accept the lane onto the critical path with an estimate.

## Alternative routes (suggested)

### Alternative: derive `qcoh_section_localization_basicOpen` locally, bypassing the global ≅-tilde iso

- **What it looks like**: the consumer is a *local* fact — for a quasicoherent `F` on affine `Spec R` and `f ∈ R`, the restriction `F(Spec R) → F(D(f))` exhibits `F(D(f))` as `F(Spec R)_f`. Rather than first proving the *global* object-level iso `F ≅ tilde(Γ F)` (the `isIso_fromTildeΓ_of_isQuasicoherent` sub-build), obtain the basic-open localization directly from the cover-local quasicoherent presentation + the structure-sheaf localization + the sheaf condition. The project already has `fromTildeΓ_app_isIso_of_isLocalizedModule`, and Mathlib's `ModuleCat.tilde` (in the same `Scheme.Modules` framework) is defined so its basic-open sections ARE the localization by construction.
- **Why it might be cheaper or sounder**: proving a whole-affine object-level iso to extract a single-basic-open fact is a heavier hammer than the consumer needs. A local derivation may sidestep the global-presentation gluing entirely (the exact step the strategy flags as the hard, Mathlib-absent piece).
- **What the current strategy may have rejected**: unclear — the strategy reasons "to get `IsLocalizedModule` on sections you need `F ≅ tilde(Γ F)`, which needs the global presentation," but does not record whether a localize-on-one-basic-open argument was tried. It may be genuinely circular (identifying restriction-with-localization IS the local content of the iso), in which case the detour is justified.
- **Severity of the omission**: minor — off the critical path; worth a bounded search budget (check for a direct `Scheme.Modules`/quasicoherent basicOpen-localization lemma) before committing iters to the global-presentation sub-build.

## Prerequisite verification

- `Algebra.IsPushout.cancelBaseChange` (+ `cancelBaseChange_tmul`, `cancelBaseChange_symm_tmul`): VERIFIED
- `Module.Flat.ker_lTensor_eq`: VERIFIED (`Mathlib/RingTheory/Flat/Equalizer.lean`)
- `IsNoetherianRing.induction_on_isQuotientEquivQuotientPrime`: VERIFIED (`Mathlib.RingTheory.Ideal.AssociatedPrime.Finiteness`)
- `Polynomial.existsUnique_hilbertPoly`: VERIFIED (`Mathlib/RingTheory/Polynomial/HilbertPoly.lean`)
- `AlgebraicGeometry.Scheme.IdealSheafData`: VERIFIED (`Mathlib.AlgebraicGeometry.IdealSheaf.Basic`) — `.ofIdeals`/`.subscheme` members not individually probed, but the DONE-and-axiom-clean status is the deterministic sync's compiled assertion, which I take at face value
- `ModuleCat.tilde` / `AlgebraicGeometry.Scheme.Modules` / `SheafOfModules.IsQuasicoherent`: VERIFIED
- graded Hilbert–Serre rationality (`dim_κ Mₙ` of a f.g. graded module = rational series): MISSING from Mathlib — correctly recorded as project-new `lem:gradedHilbertSerre_rational`

## Must-fix-this-iter

- Route FBC: CHALLENGE — STRATEGY.md is internally contradictory: the Routes prose says the 3 adjoint-mate sub-lemmas are "superseded/dropped" while the Phases table makes the *same 3 sub-lemmas* the FBC-A residual. Reconcile, and justify on merits why the section-level mate identities are cheaper than the abstract tower (or admit the tower was relocated, not eliminated).
- Route QUOT: infrastructure-deferral CHALLENGE — the forward annihilator characterization is deferred to an estimate-free Mathlib-gradient lane with no named consumer. Name the consumer (likely QUOT-repr) and confirm the lane converges before it is needed, or put it on the critical path with an iter estimate.
- Alternative (local `qcoh_section_localization_basicOpen`): minor omission — spend a bounded search confirming no direct `Scheme.Modules` basicOpen-localization lemma exists before committing iters to the global-presentation `isIso_fromTildeΓ_of_isQuasicoherent` detour.
- Format: DRIFTED — compress the multi-clause Risks cells in `## Phases & estimations` to one short line each; the file is within ~350 bytes of the 12 KB ceiling.

## Overall verdict

The strategy is mathematically sound on its three live routes and rests on verified Mathlib infrastructure — every named prerequisite (`cancelBaseChange`, `ker_lTensor_eq`, the Noetherian prime-filtration induction, `existsUnique_hilbertPoly`, `IdealSheafData`, `ModuleCat.tilde`) checks out, and the one absent piece (graded Hilbert–Serre rationality) is honestly booked as project-new material. Two challenges must be addressed before the iter ends. First, the FBC pivot is presented as dropping the parent's adjoint-mate tower, but the strategy defers the same three mate identities (unit-value / fstar-reindex / gstar-transpose) — the hardest prerequisite is identical before and after, so the pivot renames the problem unless the planner justifies that the concrete section-level versions are strictly cheaper than the abstract tower. Second, the strategy defers the forward annihilator characterization to an estimate-free gradient lane, which is required (partially) for the goal's representability node but has no named consumer and no concrete timeline — safe for now, but the planner must name the consumer and confirm sequencing rather than leaving it as an open-ended Mathlib dependency. Format is DRIFTED (correct skeleton, but over-long table cells and a byte count near the 12 KB ceiling).
