# Strategy Critic Report

## Slug
ts214

## Iteration
214

## Routes audited

### Route: A.1.c.SubT — ⊗-group law via tensorObj / associator (route (d))

- **Goal-alignment**: PASS — the abelian-group law on Pic is a genuine prerequisite for `J := Pic⁰_{C/k}`; building it on ⊗-iso-classes mirrors `CommRing.Pic` (verified to exist: `CommRing.Pic`, `instCommGroupPic`, `Mathlib.RingTheory.PicardGroup`).
- **Mathematical soundness**: PASS — the route-(d) stalkwise argument is correct: a `J.W`-map is a stalkwise iso, and `id ⊗ g_x` is then an iso (no flatness, no local triviality). The earlier flat-exactness realization was rightly killed as false. The math of the residual `isLocallyInjective_whiskerLeft_of_W` is true.
- **Sunk-cost reasoning detected**: no — the pivot from (c)→(d) is a *genuine* improvement (replaces a false flatness claim with a sound stalkwise one), not a rename of the same hard problem.
- **Infrastructure-deferral detected**: no (the strategy commits to *build* the residual with a concrete ~2–5 iter / ~200–400 LOC estimate, not defer it).
- **Phantom prerequisites**: none false, but the strategy mis-describes the residual's substrate — see below.
- **Effort honesty**: over-counted (likely) — the ~200–400 LOC "stalk-infra port" appears avoidable; the real obligation is a single Mathlib structure field. See Alternative.
- **Parallelism under-exploited**: no.
- **Verdict**: CHALLENGE — the math is sound but the route is at the **wrong altitude**: it hand-rolls monoidal coherence and a stalk theory that Mathlib's monoidal-localization API already provides. Restructure before spending the multi-iter stalk build.

**Why CHALLENGE (verified against Mathlib).** The strategy describes "the associator as the 3-step absorb→associate→absorb composite, now ASSEMBLED, resting on one residual," plus a ~200–400 LOC port of "two Mathlib-absent `PresheafOfModules` stalk lemmas." Three Mathlib facts make most of this redundant:

1. `PresheafOfModules.monoidalCategory` (`Mathlib.Algebra.Category.ModuleCat.Presheaf.Monoidal`) — `PresheafOfModules` over a (varying) sheaf of rings is **already a `MonoidalCategory`**. The presheaf-level associator/unitors/pentagon/triangle are free.
2. `CategoryTheory.Localization.Monoidal.instMonoidalCategoryLocalizedMonoidal` (`Mathlib.CategoryTheory.Localization.Monoidal.Basic`) — given a monoidal `C`, a localizer `W` with `[W.IsMonoidal]`, and `[L.IsLocalization W]`, the localized category is monoidal **for free** (all coherence isos derived). `presheafToSheaf` is exactly such a localization (`GrothendieckTopology.instIsLocalizationFunctorOppositeSheafPresheafToSheafW`), and sheafification is monoidal (`Sheaf.instMonoidalFunctorOppositePresheafToSheaf`).
3. The residual `isLocallyInjective_whiskerLeft_of_W` **is literally the `whiskerLeft` field of `CategoryTheory.MorphismProperty.IsMonoidal`** — cf. `MorphismProperty.IsMonoidal.whiskerLeft` / `MorphismProperty.whiskerLeft_mem` (`...Localization.Monoidal.Basic`): `[W.IsMonoidal] (X) (g) (W g) → W (X ◁ g)`.

So the entire monoidal structure on the sheafified modules — hence the associator the strategy hand-assembled — should drop out of `instMonoidalCategoryLocalizedMonoidal` once the single Prop `W.IsMonoidal` (two whisker fields) is supplied for the `PresheafOfModules` sheafification localizer. The "absorb→associate→absorb" hand-assembly is re-deriving what the abstract API gives.

Moreover, the residual itself is mis-framed as needing **stalks**. Mathlib's `PresheafOfModules` sheafification theory is built on a **cover-based** local-bijectivity vocabulary, not stalks: `PresheafOfModules.sheafification`, `Presheaf.IsLocallyInjective`, `Presheaf.IsLocallySurjective`, and the typeclass `J.WEqualsLocallyBijective` (all in `Mathlib.Algebra.Category.ModuleCat.Presheaf.Sheafify(ication)`). The strategy's "d.1 stalk-char of J.W on `Opens X`" is essentially `WEqualsLocallyBijective`, **which already exists**. Proving `whiskerLeft` preserves `IsLocallyInjective` in the cover-based framework may sidestep the entire ~200–400 LOC stalk-infrastructure port. The strategy's own Open-questions line cites "Mathlib-blessed `Sites.Point.IsMonoidalW` … enough points" — i.e. it has anchored on a points/stalks proof when the blessed `Sites.Monoidal`/`Localization.Monoidal` path needs neither points nor stalks (it needs `[J.W.IsMonoidal]` + `[HasWeakSheafify]`).

What the project genuinely must still supply (real, not phantom): for **SheafOfModules** specifically (modules over a *varying* sheaf of rings, which is why Mathlib has not packaged the monoidal instance — `Sheaf.monoidalCategory` only covers a *fixed* monoidal `A`), the `L.IsLocalization W` for the module-presheaf sheafification and the `W.IsMonoidal` instance. That is legitimately new infra — but it is **one localizer + one two-field Prop**, then instantiate the abstract monoidal-localization, not a bespoke associator plus a stalk theory.

### Route: A.1.c — RelPic functor

- **Verdict**: SOUND — held with placeholder bodies; the dishonest `PicSharp := const PUnit` / `functorial := 0` is explicitly flagged as a RE-ENGAGE risk rather than silently relied on. Honest.

### Route: A.2.c — representability + Quot fork

- **Verdict**: SOUND — the ⟨sorry⟩-typeclass scaffold is an honest placeholder, and the discharge fork (RR-free Quot engine vs cheap RR curve route) is explicitly named with both costs. The ~3400–5500 LOC engine is huge but honestly estimated and decomposed.

### Route: Albanese UP — Route 2 (autoduality + Galois descent)

- **Mathematical soundness**: PARTIAL — rests on autoduality `J^∨≅J`, which the strategy itself flags as "classically RR-dependent" and "UNVERIFIED," gated behind a reversible deletion gate.
- **Verdict**: SOUND (as carried) — the risk is surfaced, the route is gated far behind A.2.c, and the deletion gate on the Route-1 cone stays closed until autoduality RR-freeness is re-verified. Acceptable sequencing; keep the verification live (see Open questions).

### Route: Route C — Riemann–Roch (PAUSED, USER)

- **Verdict**: SOUND — a USER-imposed constraint, not a planner choice. The strategy honestly prices the pause ("the ~3400+ LOC engine and the autoduality risk exist solely to avoid RR"). The planner cannot unilaterally lift it; the cost is correctly attributed.

### Route: Genus-0 arm

- **Verdict**: SOUND — (a) AV-wrap transits A.2.c; (b) direct `Spec k` via Mumford rigidity is USER-paused. Honestly held.

## Format compliance

- **Size**: 101 lines / 7.3 KB — within budget (~250 lines / ~12 KB).
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in order.
- **Per-iter narrative detected**: no — no `iter-NNN` / "last iter" references. Phrases like "won over (c)" and "now ASSEMBLED" are status, borderline but acceptable.
- **Accumulation detected**: no — dead realizations are compressed to a single "Three realizations DEAD" line, not accumulated prose.
- **Table discipline**: PASS (minor gap) — a couple of LOC cells carry a status token instead of a velocity figure (e.g. `~250–450 · assoc assembled`); the many `~0/it` rows are legitimately HELD/gated, not stagnant-while-claimed-active.
- **Format verdict**: COMPLIANT

## Alternative routes (suggested)

### Alternative: Instantiate Mathlib's monoidal-localization instead of hand-rolling the associator + stalk port

- **What it looks like**: Take `C := PresheafOfModules R` (already `MonoidalCategory` in Mathlib), `W :=` the module-presheaf sheafification localizer, `L :=` `PresheafOfModules.sheafification`. Prove the single Prop `W.IsMonoidal` (its two fields `whiskerLeft`/`whiskerRight` — the project's residual) using Mathlib's cover-based `Presheaf.IsLocallyInjective`/`IsLocallySurjective` API (NOT stalks). Establish `L.IsLocalization W`. Then `instMonoidalCategoryLocalizedMonoidal` hands you the entire monoidal category on `SheafOfModules` — associator, unitors, pentagon, triangle — for free, and Pic = `Units` of ⊗-iso-classes follows as in `CommRing.Pic`.
- **Why it might be cheaper or sounder**: it deletes the hand-assembled "absorb→associate→absorb" associator and very likely deletes the ~200–400 LOC stalk-infra port (`WEqualsLocallyBijective` already exists; whisker-preservation is checkable on covers). Coherence (pentagon/triangle) comes verified from Mathlib rather than re-proved.
- **What the current strategy may have rejected**: the strategy's Open-questions reference to `Sites.Point.IsMonoidalW` + "enough points" suggests it equated the `Sites.Monoidal` route with a points/stalks requirement. `Sheaf.monoidalCategory` / `instMonoidalCategoryLocalizedMonoidal` require neither points nor stalks — only `[W.IsMonoidal]` + `[HasWeakSheafify]`/`[IsLocalization]`. The rejection appears to rest on that misreading.
- **Severity of the omission**: major — it targets the one currently-active critical-path sub-phase and could collapse a multi-iter build into a single localizer + two-field Prop.

## Prerequisite verification

- `CommRing.Pic`: VERIFIED (`Mathlib.RingTheory.PicardGroup`).
- `PresheafOfModules.monoidalCategory` / `.monoidalCategoryStruct`: VERIFIED (`...ModuleCat.Presheaf.Monoidal`).
- `CategoryTheory.Sheaf.monoidalCategory` (needs `[J.W.IsMonoidal]` + `[HasWeakSheafify]`, **no points**): VERIFIED (`...Sites.Monoidal`).
- `CategoryTheory.MorphismProperty.IsMonoidal` + `.whiskerLeft` / `whiskerLeft_mem`: VERIFIED — equals the project's residual (`...Localization.Monoidal.Basic`).
- `instMonoidalCategoryLocalizedMonoidal`, `GrothendieckTopology.instIsLocalization…PresheafToSheafW`, `Sheaf.instMonoidalFunctorOppositePresheafToSheaf`: VERIFIED.
- `PresheafOfModules.sheafification`, `Presheaf.IsLocallyInjective`, `Presheaf.IsLocallySurjective`, `GrothendieckTopology.WEqualsLocallyBijective`: VERIFIED — the cover-based vocabulary that makes the stalk port likely unnecessary.
- `SheafOfModules.monoidalCategory`: MISSING — genuinely absent (varying-ring case), correctly identified by the strategy as new project material. This is the one real gap; build it via the abstract API above, not by hand.

## Must-fix-this-iter

- Route A.1.c.SubT: CHALLENGE — before committing the multi-iter ~200–400 LOC stalk-infra build, run the cheapest disconfirming signal: attempt to instantiate `instMonoidalCategoryLocalizedMonoidal` with `C := PresheafOfModules R` and the module sheafification localizer, and attempt `whiskerLeft`-preserves-`IsLocallyInjective` via the cover-based `Presheaf.IsLocallyInjective` API. If only `W.IsMonoidal` + `L.IsLocalization W` remain, the hand-rolled associator and the stalk port are dead weight. Either pivot to that route or record an explicit rebuttal in `iter/iter-214/plan.md` naming why `instMonoidalCategoryLocalizedMonoidal` / the cover-based whisker proof do not apply to the SheafOfModules (varying-ring) case.

## Overall verdict

The overall arc (A.1.c.SubT → A.1.c → A.2.c under the option-(c) RR pause) is **SOUND**: no forced case-split, no hallucinated route, no silent assumption; the route-(d) pivot is a real correctness improvement over the false flat-exactness realization, and the carried risks (RR-pause cost, autoduality RR-freeness, R^i f_* fork) are honestly surfaced rather than hidden — keep all three live but none is newly broken. The strategy does **not** defer any goal-required construction (the one structural latent note: `IsInvertible ⇒ IsLocallyTrivial` is held "off critical path"; since the goal needs Pic to classify line bundles, keep this on the radar, though on a scheme the equivalence is standard and the carrier is used consistently). The single actionable problem is altitude, not soundness: route A.1.c.SubT hand-rolls a monoidal associator and a ~200–400 LOC stalk theory that Mathlib's monoidal-localization stack (`PresheafOfModules.monoidalCategory` + `MorphismProperty.IsMonoidal` + `instMonoidalCategoryLocalizedMonoidal`, with the cover-based `IsLocallyInjective`/`WEqualsLocallyBijective` API) very likely supplies for free once a single two-field `W.IsMonoidal` is proven — the project's "residual" is exactly that field. Spend the cheapest signal to confirm this before funding the stalk build; do not pivot the substrate a fifth time, but do reuse the Mathlib API rather than re-derive it.
