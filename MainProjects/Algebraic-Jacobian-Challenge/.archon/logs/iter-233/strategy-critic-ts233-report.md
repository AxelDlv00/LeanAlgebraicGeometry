# Strategy Critic Report

## Slug
ts233

## Iteration
233

## Routes audited

### Route: A.1.c.SubT — group law via the tensor-invertibility carrier

- **Goal-alignment**: PASS — a `CommGroup` on iso-classes of invertible 𝒪_X-modules under ⊗ is exactly `Pic X`; the carrier choice (`IsInvertible` vs `IsLocallyTrivial`) is internal bookkeeping that produces the same standard Picard group (they coincide on a locally ringed space, Stacks 0B8M).
- **Mathematical soundness**: PARTIAL — the carrier pivot itself is sound and is a *strict reduction* of remaining work (see below). But the proposed associator fix (restrict to flat) imports a hidden dependency that is either circular or contradicts the deferral. See CHALLENGE.
- **Sunk-cost reasoning detected**: no — the pivot actively *abandons* the 14-iter dual/internal-hom investment rather than justifying continued work by it. This is the opposite of sunk cost; commend it.
- **Infrastructure-deferral detected**: yes — `IsInvertible ⟹ Flat` (equivalently `IsInvertible ⟹` locally-free, one direction of the "deferred bridge" Stacks 0B8M) is required *now* by `mul_assoc` under the stated associator fix, yet is labeled "deferred, built only when a downstream consumer specifically needs local triviality." `mul_assoc` is a group axiom on the critical path and is that consumer. See Infrastructure-deferral findings.
- **Phantom prerequisites**: none — `tensorObj_restrict_iso`, unitors, braiding claimed axiom-clean; not re-verified here but not phantom.
- **Effort honesty**: reasonable — ~150–250 LOC / ~3–5 iters is plausible for a `CommGroup`-by-hand once the associator is sound. The `~0/it` realized velocity is honest about the stall, but means this sole-ungated lane has been landing nothing; the pivot must actually move it.
- **Verdict**: CHALLENGE

**On the pivot being a genuine reduction (affirm):** Old hardest prerequisite = construct an inverse *object* (`Scheme.Modules.dual` + `dual_restrict_iso` + `exists_tensorObj_inverse`). New hardest prerequisite = the associator `tensorObj_assoc_iso`. These are different constructions, and the associator was *already* required by the old route (`mul_assoc` is carrier-independent). So the new route's remaining work is a strict subset of the old route's — the inverse-object manufacture is genuinely deleted, not renamed. This is NOT an infrastructure-deferral rename; it passes the "same-hardest-prerequisite" test. The inverse-as-membership-witness is sound: well-definedness (`N` unique up to iso) needs only unitor+associator+braiding among invertible modules, and `Classical.choice` supplies the function. No hidden hard problem in the inverse.

### Route: A.1.c — RelPic functor (held, placeholder bodies)

- **Verdict**: SOUND — correctly flagged "RE-ENGAGE: replace dishonest `PicSharp := const PUnit` + `functorial := 0`." Note (not a strategy defect): those placeholder bodies are *currently dishonest stubs* in the tree; the planner must not let them masquerade as progress, and any `\leanok`/representability claim resting on them is vacuous until re-engaged.

### Route: A.2.c — representability + Quot engine (held), and engine de-gating for parallelism

- **Goal-alignment**: PASS — representability of Pic is required for both `J := Pic⁰` and the Albanese UP.
- **Mathematical soundness**: PASS.
- **Parallelism under-exploited**: no — de-gating the cohomology engine (`Cohomology_FlatBaseChange` 02KH, `R^i f_*`) to run parallel with the group law is *correct* parallelism: the Pic group law and `R^i f_*`/flat-base-change are genuinely independent (neither consumes the other), and both feed A.2.c later. This is the right call and addresses throughput.
- **Effort honesty**: reasonable but sobering — ~3400–5500 LOC, all Mathlib-absent, deepest root `R^i f_*` (i≥1). Internally consistent (~90–110 LOC/iter over 30–60 iters).
- **Verdict**: SOUND — with the caveat under "cost asymmetry": de-gating commits significant *parallel* prover resources to the more-expensive RR-free arm while RR is paused. That bet is USER-mandated (ROUTE C PAUSE), so it is not the loop's to override; the strategy is honest that the arms are "closer than ~5× cheaper once the RR chain is numbered."

### Route: Albanese UP — Route 2 (autoduality)

- **Goal-alignment**: PARTIAL — `isAlbaneseFor` (quantified over the pointing) IS required by the Goal's protected decls. The *only* planned route to it (Route 2) rests on autoduality `J^∨≅J` being RR-free, which the strategy itself calls "classically RR-dependent" and "UNVERIFIED."
- **Mathematical soundness**: PARTIAL — if autoduality needs RR, Route 2 collides with the paused Route C and the goal-required Albanese UP is blocked with no fallback named.
- **Infrastructure-deferral detected**: yes (soft) — a goal-required theorem rests on an unverified RR-freeness assumption with no fallback route.
- **Verdict**: CHALLENGE — second-verify autoduality RR-freeness (EGK 2.1 / Poincaré bundle; the theta-divisor proof rests on RR) and the `k̄→k` Galois-descent composition *before* any Route-2 investment, and name a fallback if it is not RR-free.

### Route: Route C — Riemann–Roch (PAUSED, USER)

- **Verdict**: SOUND — pause is a USER directive; not the loop's call. Correctly retained as FYI/option-(c) import.

### Route: Genus-0 arm (paused, USER)

- **Verdict**: SOUND — USER-paused.

## Format compliance

- **Size**: ~130 content lines / well under 12 KB — within budget (dense in cells, but acceptable).
- **Headings**: PASS — `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, correct order. (Leading `# Strategy` title + intro paragraph before `## Goal` is the only structural extra — minor.)
- **Per-iter narrative detected**: yes (mild) — `"Why this dissolves the 14-iter stall"` and `"that manufacture ... is the stuck work"` are project-history references that belong in an iter sidecar, not STRATEGY.md. Re-phrase to a timeless statement ("the dual-object manufacture is the costly step the carrier pivot removes").
- **Accumulation detected**: no — paused routes (RR, genus-0) and the reversibly-retained Route-1 cone are live-but-gated, not completed phases occupying space.
- **Table discipline**: PASS — six columns present, LOC cells carry both figures (`~150–250 · ~0/it`). Status cells are full sentences (verbose) but tolerable.
- **Appendix sections**: the scattered "Dead ends:" / "Dead-end (do NOT re-attempt):" lists in `## Routes` and `## Mathlib gaps` are lessons-learned-flavored guardrails. Keep them terse; they risk growing into a forbidden "Considered alternatives" appendix.
- **Format verdict**: DRIFTED

## Infrastructure-deferral findings

### Deferred: `IsInvertible ⟹ Flat` (equivalently `IsInvertible ⟹` locally-free; the `IsInvertible ⟹ IsLocallyTrivial` direction of Stacks 0B8M)

- **Required by goal**: yes — it is required *now* by `mul_assoc` (a group axiom, fully on the critical path) under the strategy's own associator fix: "restrict the associator to invertible modules, which are locally free ⟹ flat, so the clean flat-whiskering lemmas (`W_whisker*_of_flat`) apply." That chain consumes `invertible ⟹ locally-free/flat`.
- **Current plan for building it**: none with a timeline — the strategy explicitly defers it: "`IsInvertible ⟺ IsLocallyTrivial` (Stacks 0B8M) is a deferred bridge, built only when a downstream consumer specifically needs local triviality." But `mul_assoc` is that consumer.
- **Timeline**: absent (deferred).
- **Verdict**: CHALLENGE — there is a contradiction or a circularity. Either (a) the bridge direction is on the critical path now and must be un-deferred and built (check it does not itself route through the associator); or (b) the escape "tensoring by an invertible object is an equivalence ⟹ exact ⟹ flat" is circular here, because showing `N ⊗ -` inverts `M ⊗ -` *needs the associator and unitor* — the very thing flatness was meant to unblock. **Recommended resolution:** drop the flatness restriction and prove the associator *unconditionally*. Tensor-product associativity for sheaves of modules is flatness-free in general (it holds for ALL modules — associativity never needs flatness); the flatness-free whiskering `sorry` is an artifact of the project's hand-construction, not a mathematical necessity. The clean fix is to obtain the associator from the monoidal framework (see Alternative below) or to discharge the true flatness-free whiskering lemma, rather than make a group axiom depend on a deferred (and plausibly circular) flatness bridge.

## Alternative routes (suggested)

### Alternative: derive associator + braiding + unitors from Mathlib's monoidal framework instead of hand-whiskering

- **What it looks like**: Mathlib already provides `PresheafOfModules.monoidalCategory` (a full `MonoidalCategory` on presheaves of modules over a *varying* ring `R : Cᵒᵖ ⥤ CommRingCat` — associator and unitors included), and a general `CategoryTheory.Sheaf.monoidalCategory` / `CategoryTheory.Sheaf.symmetricCategory` plus `CategoryTheory.Sheaf.instMonoidalFunctorOppositePresheafToSheaf` ("`presheafToSheaf` is monoidal") gated on the typeclass `J.W.IsMonoidal` (the sheafification weak-equivalence class is compatible with ⊗) and `HasWeakSheafify`. The route: establish the monoidal structure on `SheafOfModules`/`Scheme.Modules` once by transporting `PresheafOfModules.monoidalCategory` across sheafification via `J.W.IsMonoidal` — yielding `tensorObj_assoc_iso`, braiding, and unitors *unconditionally and for all modules*, retiring the entire whiskering/flatness apparatus the strategy calls "vestigial."
- **Why it might be cheaper or sounder**: it removes the flatness restriction (and with it the circular `IsInvertible ⟹ Flat` dependency above) and the bespoke `W_whisker*_of_W`/`_of_flat` lemmas in one move, and aligns the project's `tensorObj` with Mathlib's so future Pic-functor and representability work inherits Mathlib API. The hard work collapses to proving one typeclass: `J.W.IsMonoidal` for the relevant (open-cover / scheme) topology — which `CategoryTheory.Sites.Monoidal` already supports via `GrothendieckTopology.W.monoidal` under `MonoidalClosed` + enriched-hom hypotheses.
- **What the current strategy may have rejected**: `SheafOfModules` (modules over a *sheaf of rings*) is not literally `Sheaf J A` for a fixed monoidal `A`, so `CategoryTheory.Sheaf.monoidalCategory` does not apply off the shelf, and I did not find a ready `MonoidalCategory (SheafOfModules R)` / `Scheme.Modules` instance — so a transport step is genuinely needed. The strategy's hand-build is therefore not pure reinvention. But it should be *anchored on* `PresheafOfModules.monoidalCategory` + `J.W.IsMonoidal`, not on flatness-restricted whiskering.
- **Severity of the omission**: major — the strategy mentions none of `PresheafOfModules.monoidalCategory`, `CategoryTheory.Sheaf.monoidalCategory`, or `J.W.IsMonoidal`, yet they are precisely the abstractions the whiskering apparatus is re-deriving by hand, and they sidestep the flatness/circularity CHALLENGE.

### Alternative: curve-specific Abel–Jacobi / Sym^n representability

- **What it looks like**: for a smooth proper curve, `Pic^d` is represented by `Sym^d(C)` for `d ≫ 0` (Kleiman §5), far cheaper than the general FGA Quot engine.
- **Why it might be cheaper or sounder**: ~600–1000 LOC vs ~3400–5500.
- **What the current strategy may have rejected**: correctly — it needs Riemann–Roch (fiber dimensions), which is under the USER ROUTE C PAUSE. The strategy already names this. Not a missed opportunity, only a blocked one.
- **Severity of the omission**: minor.

## Sunk-cost flags

(none — the carrier pivot is the inverse of sunk cost; it abandons the 14-iter dual investment. Commend it.)

## Prerequisite verification

- `PresheafOfModules.monoidalCategory`: VERIFIED (Mathlib.Algebra.Category.ModuleCat.Presheaf.Monoidal) — full monoidal, varying ring.
- `CategoryTheory.Sheaf.monoidalCategory` / `CategoryTheory.Sheaf.symmetricCategory`: VERIFIED (Mathlib.CategoryTheory.Sites.Monoidal), gated on `J.W.IsMonoidal` + `HasWeakSheafify`.
- `CategoryTheory.GrothendieckTopology.W.monoidal` (instance providing `J.W.IsMonoidal`): VERIFIED (under `MonoidalClosed` + enriched-hom hypotheses).
- `AlgebraicGeometry.Scheme.Modules`: VERIFIED (Mathlib.AlgebraicGeometry.Modules.Sheaf).
- `MonoidalCategory (SheafOfModules R)` / `Scheme.Modules`: MISSING — no ready instance found; a transport across sheafification is genuinely required (justifies a hand-build, but anchored on the above, not on flatness).
- `Module.Invertible` / `CommRing.Pic` non-reusability for varying 𝒪_X: VERIFIED — `Module.Invertible R M` is over a fixed `CommSemiring R`; the strategy's claim that it does not apply to the global Pic of a scheme is fair.

## Must-fix-this-iter

- Route A.1.c.SubT: infrastructure-deferral CHALLENGE — the associator fix needs `IsInvertible ⟹ Flat` (a direction of the "deferred" Stacks-0B8M bridge) for the group axiom `mul_assoc` *now*; this is either circular (flatness ⟸ ⊗-equivalence ⟸ associator ⟸ flatness) or contradicts the deferral. Planner must either build the flatness/locally-free direction this iter (verifying non-circularity) OR drop the flatness restriction and prove the unconditional associator.
- Route A.1.c.SubT: CHALLENGE — adopt the unconditional associator route. Anchor `tensorObj_assoc_iso` (+ braiding, unitors) on Mathlib's `PresheafOfModules.monoidalCategory` transported via `J.W.IsMonoidal`, retiring the flatness-free whiskering `sorry` rather than dodging it with a flat restriction. Record an explicit rebuttal in plan.md if the transport is judged costlier than the by-hand flat route.
- Route Albanese UP (Route 2): CHALLENGE — autoduality `J^∨≅J` RR-freeness is UNVERIFIED and the route is the only planned path to the goal-required `isAlbaneseFor`. Second-verify RR-freeness (and the `k̄→k` descent composition) before Route-2 investment; name a fallback if it reintroduces paused RR.
- Format: DRIFTED — remove the per-iter-narrative phrases ("14-iter stall", "the stuck work"); keep the scattered "Dead ends" guardrails terse so they do not accrete into a forbidden appendix.

## Overall verdict

The headline carrier pivot — carrying `Pic X` on `IsInvertible M := ∃N, M⊗N≅𝒪` with the inverse as the membership witness — is **sound and genuinely dissolves the stall**: it is a strict reduction of remaining work (the dual / internal-hom inverse-object manufacture is deleted, not renamed), it is the opposite of sunk-cost reasoning, and the inverse-as-witness construction has no hidden hard problem. The engine de-gating is correct parallelism: the Pic group law and `R^i f_*`/flat-base-change are independent and both feed A.2.c, so running them in parallel is the right throughput call. However, **the strategy defers `IsInvertible ⟹ Flat`/locally-free (a direction of the Stacks-0B8M bridge), which is required for the group axiom `mul_assoc` under the stated associator fix** — making that "deferred bridge" actually on the critical path now, with a circularity risk. The clean resolution is to prove the associator *unconditionally* (tensor associativity is flatness-free), ideally by anchoring on Mathlib's existing `PresheafOfModules.monoidalCategory` + `J.W.IsMonoidal` sheafification-is-monoidal machinery — which the strategy does not mention at all and which sidesteps both the flatness restriction and the circularity. Separately, the goal-required Albanese UP rests entirely on an UNVERIFIED RR-free autoduality with no fallback. Address the associator/flatness CHALLENGE and the autoduality verification this iter (in STRATEGY.md or via explicit rebuttal in plan.md), and tighten two mild format drifts.
