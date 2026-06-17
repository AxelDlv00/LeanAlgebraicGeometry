# Strategy Critic Report

## Slug
ts215

## Iteration
215

## Routes audited

### Route: A.1.c.SubT — ⊗-group law via monoidal `SheafOfModules` (route (e))

- **Goal-alignment**: PASS — a group structure on `Pic` of a scheme is genuinely required: the RelPic
  functor `T ↦ Pic(C×T)/Pic(T)` must be group-valued, which needs `Pic(C×_k T)` to be a group for
  arbitrary `T`. The abstract substrate is justified by the goal.
- **Mathematical soundness**: PASS — the reduction is real and well-grounded. `Sheaf.monoidalCategory`
  and `LocalizedMonoidal` exist in Mathlib and are gated *exactly* on `[J.W.IsMonoidal]`; once that one
  instance lands, associator/unitors/pentagon/triangle come for free. The "flatness-free" claim is
  correct: whiskering preserves *isos* by functoriality of `tensorLeft/Right` (flatness would only be
  needed to preserve injections, which `W` = local-iso does not require).
- **Sunk-cost reasoning detected**: no — route (e) is not justified by "we already built c/d"; it is
  justified on merits (it outsources all coherence to Mathlib, leaving one instance). That is a genuine
  improvement over the (correctly-killed) hand-assembled associator.
- **Infrastructure-deferral detected**: yes — the load-bearing `(J.W).IsMonoidal` at the module level
  rests on d.2 (stalk of a relative module tensor over a *varying* local ring `O_{X,x}`), which is
  Mathlib-absent. This is the *same* hardest prerequisite shared by all four realizations
  (flat-exactness, c, d, e). Route (e) reframes the coherence away but leaves d.2 untouched. The
  strategy itself labels d.2 "the make-or-break feasibility unknown" and yet no feasibility spike is
  scheduled — four realizations in, the actual blocker has never been directly probed.
- **Phantom prerequisites**: `Sites/Point/IsMonoidalW` — no Mathlib decl by that literal name exists.
  The real fixed-base template is `CategoryTheory.GrothendieckTopology.W.monoidal` (in
  `Sites/Monoidal.lean`), and it **requires `[MonoidalClosed A]`**, which route (e) explicitly
  disclaims. So the module-level instance cannot reuse Mathlib's `W.monoidal`; it must be hand-built,
  and d.2 is the irreducible content. The strategy is aware of the "no MonoidalClosed" gap but its
  template citation is mis-named.
- **Effort honesty**: under-counted / internally inconsistent — the row reads `~250–400 · 0/it` with
  `Iters left ~3–6`. A realized velocity of `0/it` with a positive remaining-LOC and a finite
  iters-left is arithmetically a non-completion; either the velocity is not actually 0 (d.1-core landed
  is non-zero) or the 3–6 estimate is aspirational. Pick one.
- **Verdict**: CHALLENGE — proceed, but run a d.2 feasibility spike *this iter* with an explicit
  go/no-go criterion before sinking more route-(e) plumbing, and weigh the locally-trivial-first
  alternative below (which may sidestep d.2 entirely).

### Route: A.1.c — RelPic functor
- **Verdict**: SOUND — held with honestly-flagged dishonest placeholders (`PicSharp := const PUnit`,
  `functorial := 0`) marked RE-ENGAGE. No hidden goal-weakening.

### Route: A.2.c — representability + Quot fork

- **Goal-alignment**: PASS in principle — representability is the PRIMARY GOAL per the USER directive.
- **Mathematical soundness**: PASS — both discharge options (RR-free Quot engine; cheap Sym^n/AJ curve
  route) are textbook (Nitsure §5 / Kleiman §4–5).
- **Infrastructure-deferral detected**: yes — the primary goal currently has **no active discharge
  lane**: the RR-free engine is HOLD (`~0/it`), and the cheap route is USER-paused (Route C). Forwarding
  the substrate cannot substitute for progress on representability. This is deferral-by-inaction on the
  stated primary objective. The strategy *does* surface the fork in Open questions (good), but a row
  that is the primary goal and is HELD on one side and USER-paused on the other is a decision-gate that
  must be forced, not held indefinitely.
- **Effort honesty**: the 3400–5500 LOC engine vs 600–1000 LOC RR route is a ~5× multiplier paid solely
  to honor the RR pause; this is stated plainly (good), but its weight argues for forcing the USER
  decision sooner rather than building substrate around a frozen core.
- **Parallelism under-exploited**: yes — the engine (A.2.c) is gated behind A.1.c.SubT→A.1.c, but
  representability (Quot existence) is *mathematically independent* of the group law; in FGA the group
  structure is layered on after existence. The engine's real gate is the USER RR decision, not the
  substrate. Coupling it to the substrate serializes two independent tracks.
- **Verdict**: CHALLENGE — the primary goal must have *some* live lane or an explicit forced USER
  decision; "forward the substrate while the goal's only two paths are both frozen" is defensible only
  as a short holding pattern, not a multi-iter posture.

### Route: Albanese UP — Route 2
- **Verdict**: SOUND (with live risk) — autoduality `J^∨≅J` RR-freeness is honestly flagged UNVERIFIED
  and "classically RR-dependent"; if it needs RR it collides with the paused Route C and jeopardizes the
  whole Albanese path. Appropriately treated as top risk, deletion gate held. Keep it unverified-pending,
  not assumed.

### Route: Route C — Riemann–Roch (USER-paused)
- **Verdict**: SOUND — this is a USER decision, not a strategy defect. The strategy correctly records
  the pause cost (the entire engine + autoduality risk exist to avoid RR).

### Route: Genus-0 arm
- **Verdict**: SOUND — (a) transits A.2.c, (b) `J := Spec k` via Mumford rigidity is USER-paused. Both
  appropriately gated.

## Format compliance

- **Size**: 100 lines / ~7 KB — within budget.
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic
  questions`, `## Mathlib gaps & new material`, in order.
- **Per-iter narrative detected**: yes — "d.1-core landed iter-214" (line 21) and "the linear stalk-map
  packaging) landed iter-214" (line 70). Iteration references belong in iter sidecars, not STRATEGY.md.
- **Accumulation detected**: minor — the inline "Dead realizations (do NOT revisit): bundled fixed-base
  monoidal, flat-exactness, `tensorObj_restrict_iso`, the bespoke hand-assembled associator" and the
  repeated dead-end notes in `## Mathlib gaps` carry rejected-route history. Defensible as guardrails but
  this is where iter sidecars should hold the detail.
- **Table discipline**: PASS structurally (correct columns, two-figure LOC cells), but nearly every row
  carries `· 0/it` realized velocity while asserting finite "Iters left" — an internal inconsistency
  flagged under effort honesty above.
- **Format verdict**: DRIFTED

## Infrastructure-deferral findings

### Deferred: d.2 — stalk of a relative module tensor over a varying local ring (`(M⊗_{O_X}N)_x ≅ M_x⊗_{O_{X,x}}N_x`)
- **Required by goal**: yes — it is the sole load-bearing field of `(J.W).IsMonoidal`, which is the only
  open obligation of the active group-law lane.
- **Current plan for building it**: stalkwise / enough-points technique; ~150–250 LOC; no Mathlib
  shortcut (the one existing `W.monoidal` instance needs `MonoidalClosed`, which is disclaimed).
- **Timeline**: vague — folded into "A.1.c.SubT ~3–6 iters" with no d.2-specific spike or go/no-go.
- **Verdict**: CHALLENGE — this is the identical hardest prerequisite of all four substrate
  realizations. Demand a focused feasibility spike this iter (can stalk-⊗ be proven for `SheafOfModules`
  at all?) before committing more iters to route-(e) plumbing.

### Deferred: A.2.c representability (RR-free Quot engine OR RR curve route)
- **Required by goal**: yes — it is the PRIMARY GOAL per the USER directive.
- **Current plan for building it**: engine HOLD pending substrate; cheap route USER-paused. No active
  lane.
- **Timeline**: absent — both options are frozen.
- **Verdict**: CHALLENGE — not a REJECT (the goal *is* provable: lifting the RR pause yields the
  600–1000 LOC route), but the planner must force the USER RR decision rather than treat "forward the
  substrate" as the answer to a frozen primary goal.

## Alternative routes (suggested)

### Alternative: locally-trivial-first group law (build the group on invertible sheaves directly, mirror `CommRing.Pic`)
- **What it looks like**: instead of constructing the monoidal structure on *all* of `SheafOfModules`
  (which forces the general d.2 gap) and then restricting to the locally-trivial subgroupoid afterward,
  build the group law *directly* on locally-trivial (invertible) `O_X`-modules. On a trivializing cover
  each `L ≅ O_X`, so `L⊗M` is locally `O_X⊗O_X = O_X` — already locally free of rank 1, already a sheaf
  in the good direction — and associativity reduces, on the cover, to associativity of ring
  multiplication in `O_X`. Define `Pic X` as iso-classes with this `⊗`, proving the group axioms
  directly (a single associativity natural iso, unit `O_X`, inverse = dual), exactly as Mathlib's
  `CommRing.Pic` does at the ring level *without* any monoidal category, `Skeleton`, or
  `MorphismProperty.IsMonoidal`.
- **Why it might be cheaper or sounder**: it exploits local triviality from the start, so it may **never
  need the general stalk-⊗-over-a-varying-ring commutation (d.2)** — the make-or-break gap of route (e).
  The full monoidal coherence (pentagon/triangle/unitor) is quotiented away on iso-classes and is never
  needed for a *group*. `Module.Invertible` and the `CommRing.Pic` blueprint already exist in Mathlib as
  a direct precedent for "group on iso-classes of invertibles, no monoidal category."
- **What the current strategy may have rejected**: the strategy notes "restrict to the locally-trivial
  subgroupoid for `Units(Skeleton)`" as an *open* question — i.e. it builds the hard general object
  first and restricts last. Inverting that order is the suggestion; the strategy gives no reason the
  general monoidal structure must precede the group.
- **Severity of the omission**: major — this is the "materially simpler path not considered" the
  directive's Q1 asks for, and it directly targets the project's single make-or-break unknown.

## Prerequisite verification

- `CategoryTheory.LocalizedMonoidal`: VERIFIED (`Localization/Monoidal/Basic.lean`).
- `CategoryTheory.MorphismProperty.IsMonoidal`: VERIFIED (`Localization/Monoidal/Basic.lean`).
- `PresheafOfModules.Monoidal.tensorObj` / `.tensorHom` (fixed-base presheaf monoidal): VERIFIED
  (`Presheaf/Monoidal.lean`).
- `CategoryTheory.Sheaf.monoidalCategory` (sheaf monoidal, gated on `[J.W.IsMonoidal]`): VERIFIED
  (`Sites/Monoidal.lean`).
- `CategoryTheory.GrothendieckTopology.W.monoidal` (the only `J.W.IsMonoidal` instance): VERIFIED but
  requires `[MonoidalClosed A]` — does NOT apply to the route-(e) "no MonoidalClosed" plan.
- `Sites/Point/IsMonoidalW`: MISSING (no such literal decl; real template is `W.monoidal` above).
- `CommRing.Pic` + `Module.Invertible` (direct ring-level Picard precedent): VERIFIED
  (`RingTheory/PicardGroup.lean`).
- Scheme-level `Pic`/invertible-sheaf group: MISSING in Mathlib (must be project-built — confirms the
  substrate is genuinely needed; the question is only *which* substrate).

## Must-fix-this-iter

- Route A.1.c.SubT: infrastructure-deferral CHALLENGE — d.2 (stalk-⊗ over a varying ring) is the shared
  make-or-break of all four realizations and has never had a direct feasibility spike. Run a scoped d.2
  spike this iter with an explicit go/no-go before more route-(e) plumbing.
- Route A.2.c: infrastructure-deferral CHALLENGE — the PRIMARY GOAL has no active discharge lane (engine
  HELD, cheap route USER-paused). Force the USER RR decision; do not treat "forward the substrate" as the
  answer to a frozen goal.
- Alternative (locally-trivial-first group law): major omission — evaluate building the group directly on
  invertible sheaves (mirroring `CommRing.Pic`), which may sidestep d.2 entirely, before committing more
  iters to the all-`SheafOfModules` monoidal substrate.
- Phantom prerequisite `Sites/Point/IsMonoidalW`: correct the citation to `GrothendieckTopology.W.monoidal`
  and note it needs `MonoidalClosed` (hence inapplicable), so the module instance is fully bespoke.
- Format: DRIFTED — remove the two "iter-214" per-iter references; reconcile the systemic `0/it`
  velocity against the finite "Iters left" estimates (a `0/it` row that claims completion in 3–6 iters is
  internally inconsistent).

## Overall verdict

The long-arc plan is structurally sound and, refreshingly, honestly self-reported: the protected-decl
target, the bottom-up ordering, and the route-(e) reduction to a single `(J.W).IsMonoidal` instance are
all real and backed by verified Mathlib infrastructure — this is not a hallucinated route. But two
deferrals must be named. **The strategy defers d.2 (stalk-⊗ commutation over a varying ring), which is
required for the goal** — it is the sole load-bearing content of the active group-law lane, it is the
identical hardest prerequisite that survived all four substrate realizations, and four realizations in it
has still never been directly probed; the repeated re-realization is a symptom that the project keeps
re-framing the coherence layer while the actual blocker sits untouched. **The strategy also defers A.2.c
representability, which is required for the goal and is in fact the stated PRIMARY GOAL** — both of its
discharge options are frozen (engine HELD, cheap route USER-paused), so the primary objective currently
has no live lane and "forward the Picard substrate" is being asked to stand in for progress it cannot
make. Neither deferral makes the goal *unprovable* (lifting the RR pause unblocks A.2.c; d.2 may yet be
feasible), so the verdict is CHALLENGE, not REJECT. The single highest-leverage move: before more
route-(e) plumbing, spike d.2 directly, and seriously evaluate the locally-trivial-first group law
(mirroring the existing `CommRing.Pic`), which exploits local triviality so that tensor stays locally
free and associativity reduces to ring multiplication on a trivializing cover — plausibly avoiding the
make-or-break d.2 gap that the all-`SheafOfModules` monoidal substrate forces.
