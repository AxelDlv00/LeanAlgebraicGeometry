# Strategy Critic Report

## Slug
ts240

## Iteration
240

## Routes audited

### Route: A.1.c.SubT — group law via tensor-invertibility carrier (DONE)

- **Verdict**: SOUND — the carrier pivot (`IsInvertible M := ∃N, M⊗N≅𝒪`, inverse = membership witness) is the correct call; it deletes the dual-object manufacture from the critical path and `picCommGroup` is reported axiom-clean. Nothing to flag.

### Route: A.1.c — relative Picard functor on `IsInvertible` (Route Z pullback)

- **Goal-alignment**: PASS — `IsInvertible.pullback` is the genuine substrate prerequisite for `OnProduct`/`functorial`; the relative functor is required by the goal.
- **Mathematical soundness**: PARTIAL — Phase 1 (unit iso by globalizing the proven chart-chase) is sound and well-supported. Phase 2's *packaging* is mis-scoped (see below); the *mathematical content* (tensor comparison iso by finality) is correct.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no — the hard prerequisite (`pullbackObjTensorToTensor`) is named, owned by the project, and given a concrete two-phase plan with an iter estimate. The pivot from the dead sectionwise recipe to Route Z is a *real* route change (different construction), not a renamed-same-gap deferral.
- **Phantom prerequisites**: none. `SheafOfModules.pullbackObjUnitToUnit`, `instIsIsoPullbackObjUnitToUnitOfFinal` (both `Mathlib.Algebra.Category.ModuleCat.Sheaf.PullbackFree`) and `Functor.CoreMonoidal.ofOplaxMonoidal` (via `ofOplaxMonoidal_μIso`, `Mathlib.CategoryTheory.Monoidal.Functor`) all VERIFIED present. `Adjunction.leftAdjointOplaxMonoidal` correctly identified as ABSENT.
- **Effort honesty**: under-counted on two specific points (below); the `~0/it` velocity on an "ACTIVE" row is itself a flag.
- **Verdict**: CHALLENGE

Two concrete issues the planner must address before dispatching Phase 2:

1. **`ofOplaxMonoidal` consumes a full `[F.OplaxMonoidal]` instance, not two bare maps.** The A.1.c paragraph reads "build a `pullbackObjTensorToTensor` comparison map ... then `Functor.CoreMonoidal.ofOplaxMonoidal`." But `ofOplaxMonoidal` requires an existing `OplaxMonoidal` *instance* (η, δ, plus naturality + associativity/unitality coherence) and then merely repackages it under `IsIso η`/`∀ IsIso δ`. Since `leftAdjointOplaxMonoidal` does **not** exist (verified), that OplaxMonoidal instance on `pullback` is **not free** — it must be built by hand (as the mate of `pushforward`'s `rightAdjointLaxMonoidal`, or from the concrete presheaf-pullback description). The strategy's prose silently elides this — it is the cost the analogist's "Correction to the directive's premise" calls out.

2. **The cheaper structurally-simpler route the directive asked for: `IsInvertible.pullback` does NOT need the packaged strong-monoidal functor at all.** To prove `IsInvertible (f^*M)` from a witness `M⊗N≅𝒪`, you need only: `f^*M ⊗ f^*N ≅ f^*(M⊗N)` (the tensor comparison iso *at the single pair (M,N)*) ∘ `f^*(M⊗N) ≅ f^*𝒪` (functoriality, free) ∘ `f^*𝒪 ≅ 𝒪` (Phase 1). A *pointwise* comparison iso plus its naturality suffices; the full `CoreMonoidal`/`OplaxMonoidal`-instance packaging (with all coherence axioms) is overkill for this consumer. Descoping Phase 2 to the pointwise comparison iso both sidesteps issue (1) and shrinks the build. The planner should either justify why the packaged monoidal-functor instance is wanted downstream (e.g. reuse by `OnProduct`) or descope to the pointwise iso.

### Route: A.2.c — representability + Quot fork (held)

- **Verdict**: SOUND — six `⟨sorry⟩`-scaffolded typeclasses with the engine held behind A.1.c is a reasonable staging; the A.2.c-entry bridge `IsInvertible ⟹ locally-free-rank-1` (easy direction) is correctly placed on-path, and the observation that the reverse `IsLocallyTrivial ⟹ IsInvertible` (dual-gluing) is never needed under the `IsInvertible` carrier is correct and consistent with the SubT pivot.

### Route: A.2.c-engine — FlatBaseChange affine close (bump-defer)

- **Goal-alignment**: PASS — flat base change i=0 (Stacks 02KH) is a genuine engine root.
- **Mathematical soundness**: PASS — the `algebraize [φ.hom]` fix (honest `Algebra`/`IsScalarTower`) is the right mechanism; the analogist verified it runs at the sorry in-pin, and the project already owns `powers_restrictScalars` + `gammaPushforwardIsoAt`. The in-tree port is self-contained (only `algebraize` + naturality-in-open remain).
- **Effort honesty**: under-counted — the row is internally inconsistent (see Format/effort note): `~3400–5500 LOC · ~5/it` against `Iters left ~30–60` implies ~57–90 LOC/it, not 5; at the realized ~5/it the engine is ~680–1100 iters, not 30–60.
- **Verdict**: SOUND (on the bump-defer decision specifically). Deferring a project-wide Mathlib bump from `b80f227` past 2026-05-31 mid-flight is the right call: the in-tree port is a bounded one-file change (`algebraize` is verified; naturality-in-open is the only genuine new work), whereas a bump risks breaking the large pinned axiom-clean substrate. The bump collapses the def to ~3 lines but that saving does not justify the blast radius now. **One note, not a challenge:** the bump is likely inevitable (the project will eventually want #37189 and adjacent upstream Picard/cohomology material) — a *scheduled* bump window (e.g. after the substrate frontier stabilizes) is healthier than indefinite deferral, but since the in-tree port fully discharges the immediate obligation the goal is not blocked.

### Route: Albanese UP — Route 2 preferred / Route 1 RR-free fallback

- **Verdict**: SOUND — this is the correct way to carry an unverified dependency: a *named, in-tree, already-substrated* RR-free fallback (Weil/rigidity, Milne 3.2/3.10, the `Thm32RationalMapExtension`/`CodimOneExtension`/`AbelianVarietyRigidity` cone) means `isAlbaneseFor` is reachable under the permanent Route C pause regardless of the autoduality verification. The deferred autoduality RR-freeness check is appropriately scheduled "when A.2.c nears" and is not a goal-blocking gap because the fallback exists. Not an infrastructure-deferral.

### Route: Route C — Riemann–Roch — PAUSED (USER)

- **Verdict**: SOUND — user-directed pause; the strategy honestly records the pause cost (the ~3400+ LOC engine and the autoduality risk exist to avoid RR).

### Route: Genus-0 arm

- **Verdict**: SOUND — both arms named; direct `Spec k` route paused per USER.

## Format compliance

- **Size**: 158 lines / ~11 KB — within budget.
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in order.
- **Per-iter narrative detected**: yes — the file repeatedly references specific iterations and an analogist slug: e.g. `"confirmed mathlib-analogist ts240"` (line 54), `"Its proof recipe pivoted iter-240: the iter-239 sectionwise-`extendScalars` recipe is DEAD"` (Open strategic questions), `"Mathlib BUMP past 2026-05-31 would collapse the def"`. The format rules explicitly forbid `iter-NNN` / "the iter-XYZ pivot" references — per-iter history belongs in `iter/iter-NNN/plan.md`.
- **Accumulation detected**: no — DONE phases are compressed to one line; dead routes are pointer-only ("recorded in the iter sidecars, not here").
- **Table discipline**: PASS (structure) — six columns, LOC cell carries both figures. But the figures are internally inconsistent on two rows (effort honesty, not table structure): A.2.c-engine `~3400–5500 · ~5/it` vs `Iters left ~30–60` is arithmetically impossible (3400÷5 ≈ 680 ≠ 30–60); A.1.c is "ACTIVE" with `~0/it` realized velocity against `Iters left ~5–9`.
- **Format verdict**: DRIFTED — strip the `iter-239`/`iter-240`/`ts240` per-iter references in-place this iter (move the "recipe pivoted this iter" narrative to `iter/iter-240/plan.md`), and reconcile the two inconsistent LOC/velocity/iters cells.

## Alternative routes (suggested)

### Alternative: pointwise tensor-comparison iso (descope Phase 2)

- **What it looks like**: instead of building a full `OplaxMonoidal (pullback φ)` instance and packaging via `CoreMonoidal.ofOplaxMonoidal`, build only the single comparison iso `f^*M ⊗ f^*N ≅ f^*(M⊗N)` at the witness pair, prove it iso by the same finality chart-chase, and feed it (with Phase 1's unit iso and free functoriality) directly into `IsInvertible.pullback`.
- **Why it might be cheaper or sounder**: it avoids the under-counted hand-built `OplaxMonoidal` instance (η + δ + naturality + 3 coherence axioms) that `ofOplaxMonoidal` requires, since `leftAdjointOplaxMonoidal` is absent. `IsInvertible.pullback` is the only consumer named on the critical path and needs nothing more than the pointwise iso.
- **What the current strategy may have rejected**: unclear — the strategy may intend the packaged monoidal functor for reuse by `OnProduct`; if so it should say so, because otherwise the packaging is pure overhead.
- **Severity of the omission**: major — it materially changes Phase 2's scope and removes a hidden cost.

## Sunk-cost flags

- `"FLAT-restricted IsInvertible.pullback (the RPF maps π_T/base-changes are all flat) suffices — fall back to flat-restriction then"` (Open strategic questions) — Why this is suspect: strong-monoidality of `f^*` is **flatness-independent** (flatness governs exactness of `f^*`, not the tensor-comparison being iso), so a flat restriction does *not* simplify the Phase-2 obligation. The genuine alternative that *would* avoid the monoidality gap is the local-triviality route (invertible ⟹ locally `𝒪` ⟹ pulls back to locally `𝒪`), but that requires the reverse bridge locally-free-rank-1 ⟹ `IsInvertible`, i.e. it *reintroduces the dual/tensor-inverse manufacture the carrier pivot was built to delete*. Recommendation: drop the flat-restriction "reversing signal" (it is not a real cheaper fallback), and instead state the honest reason the monoidality route is primary — it is the path that avoids resurrecting the deleted dual-gluing.

## Prerequisite verification

- `SheafOfModules.pullbackObjUnitToUnit`: VERIFIED (`Mathlib.Algebra.Category.ModuleCat.Sheaf.PullbackFree`)
- `SheafOfModules.instIsIsoPullbackObjUnitToUnitOfFinal`: VERIFIED (same module)
- `Functor.CoreMonoidal.ofOplaxMonoidal`: VERIFIED (via `ofOplaxMonoidal_μIso`, `Mathlib.CategoryTheory.Monoidal.Functor`)
- `Adjunction.leftAdjointOplaxMonoidal`: MISSING (only `Adjunction.rightAdjointLaxMonoidal` ships — opposite direction; the pullback's oplax structure is therefore NOT free)
- `isIso_fromTildeΓ_pushforward`: MISSING in pin (#37189, post-2026-05-31 — consistent with the bump-defer; the in-tree port is the correct response)

## Must-fix-this-iter

- Route A.1.c: CHALLENGE — `CoreMonoidal.ofOplaxMonoidal` needs a hand-built `OplaxMonoidal (pullback φ)` instance (no `leftAdjointOplaxMonoidal`); the strategy elides this cost. Either budget it explicitly OR descope Phase 2 to the pointwise tensor-comparison iso that `IsInvertible.pullback` actually consumes. Resolve in STRATEGY.md or rebut in `iter/iter-240/plan.md`.
- Alternative "pointwise comparison iso": major omission — the structurally simpler route the directive asked about exists and removes a hidden Phase-2 cost.
- Sunk-cost: the flat-restriction fallback is mislabeled (flatness does not ease monoidality; the real alternative reintroduces the deleted dual). Reframe or drop.
- Format: DRIFTED — remove `iter-239`/`iter-240`/`ts240` per-iter references (move to the iter sidecar) and reconcile the A.2.c-engine `~5/it` vs `30–60 iters` and A.1.c `~0/it` ACTIVE cells.

## Overall verdict

The high-level spine — A.1.c.SubT (DONE) → A.1.c → A.2.c with the engine running in parallel — is sound, the carrier pivot is the right foundational choice, the Albanese fallback is correctly named-and-in-tree, and the FlatBaseChange bump-defer is the right risk call (the in-tree `algebraize` port is verified and self-contained). The strategy does **not** defer any goal-required construction without a project-side plan, so there are no infrastructure-deferral findings. The one substantive CHALLENGE is on Route Z Phase 2: invoking `CoreMonoidal.ofOplaxMonoidal` requires a hand-built `OplaxMonoidal` instance (the oplax comparison maps are not free — `leftAdjointOplaxMonoidal` is absent), a cost the prose elides; and `IsInvertible.pullback` in fact needs only a *pointwise* tensor-comparison iso, so the full monoidal-functor packaging is likely over-built. The named flat-restriction fallback is illusory (flatness does not simplify monoidality). Format has DRIFTED on per-iter narrative (`iter-NNN`/`ts240` references) and two arithmetically inconsistent LOC/velocity/iters cells — fix in-place this iter.
