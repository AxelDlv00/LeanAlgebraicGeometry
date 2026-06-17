# Strategy Critic Report

## Slug
sc252

## Iteration
252

## Routes audited

### Route: Spine — `J := Pic⁰_{C/k}` (RR-free, uniform over the pointing)

- **Goal-alignment**: PASS — `challenge.lean.ref` demands a single `Jacobian C : Over (Spec k)`
  with `GrpObj`, smoothness of rel. dim. `genus C`, properness, geom-irreducibility, for ALL smooth
  proper geom-irreducible curves (`[Field k]` only). `Pic⁰` is the correct uniform object; for genus 0
  it degenerates to `Spec k`, so no case split is forced. The `isAlbaneseFor`/UP is correctly the only
  pointing-quantified piece.
- **Mathematical soundness**: PASS — `Pic⁰` as the Jacobian is the standard FGA construction
  (Kleiman §5, `rmk:Jac` L3990; Milne III §6). Uniform-over-`k` with no `C(k)≠∅` is the honest reading
  of the goal.
- **Sunk-cost reasoning detected**: no.
- **Effort honesty**: reasonable at the spine level; the cost is concentrated in A.2.c (see below).
- **Verdict**: SOUND. Given the permanent RR pause, there is no cheaper RR-free route to a *representable*
  `Pic⁰` for all curves: the symmetric-product / theta-divisor / birational-group-law constructions all
  consume Riemann–Roch (Milne §III.3–4), so the FGA Quot engine is the genuinely-forced alternative, not
  a preference. The route choice is correct; the cost is real (see A.2.c).

### Route: A.1.c.sub — comparison iso `f^*(M⊗N)≅f^*M⊗f^*N` on loc-triv line bundles

- **Goal-alignment**: PASS — feeds `IsInvertible.pullback` (Stacks lemma-pullback-invertible), the
  substrate prerequisite for the group law's pullback compatibility consumed by RPF.
- **Mathematical soundness**: PASS — δ (`pullbackTensorMap`) is built; the claim "`f^*` is strong monoidal
  ⇒ δ iso on all objects, proven only on loc-triv pairs" is mathematically true (Stacks 01CX). The
  chart-chase upgrade has real Mathlib backing: `AlgebraicGeometry.Scheme.Modules.Hom.isIso_iff_isIso_app`
  (iso ⟺ iso on every open), `CategoryTheory.Sheaf.isLocallyBijective_iff_isIso`, and
  `TopCat.Presheaf.app_isIso_of_stalkFunctor_map_iso` (stalk-wise iso ⇒ app iso) all VERIFIED present.
- **Sunk-cost reasoning detected**: no — the open question explicitly names the reversing signal ("D3'
  materially harder than its proven unit analog → decompose; do NOT revive the general Lan build"),
  which is the opposite of sunk cost.
- **Phantom prerequisites**: none confirmed phantom. `final_of_representablyFlat` (cited as the basis for
  the unconditional `pullbackUnitIso`) could not be located by name via loogle, but `pullbackUnitIso`
  is reported built+axiom-clean, so the name is not load-bearing — flagging only for cleanup.
- **Effort honesty**: reasonable but lumpy — the LOC cell carries prose ("D2' milestone landed (lumpy)")
  rather than a numeric `/it` velocity (minor table-discipline gap).
- **Verdict**: SOUND — with one fresh-eyes note (below): the strategy should record *why* the generic
  Mathlib sheaf-monoidal machinery cannot shortcut the by-hand build.

### Route: A.1.c.fun — RelPic functor on `IsLocallyTrivial`

- **Goal-alignment**: PASS — RPF intrinsically classifies loc-triv line bundles; the `IsLocallyTrivial`
  carrier is the genuine consumer carrier.
- **Mathematical soundness**: PASS.
- **Phantom prerequisites**: none — the cited transport template is REAL and VERIFIED in
  `Mathlib.RingTheory.PicardGroup`: `CommRing.Pic.functor` (`CommSemiRingCat ⥤ CommGrpCat`),
  `CommRing.Pic.mapAlgebra`, `CommRing.Pic.mapRingHom`, with `mapRingHom_id` / `mapRingHom_mapRingHom`
  functoriality lemmas. "Modeled field-for-field" is a legitimate, existing template.
- **Verdict**: SOUND.

### Route: A.2.c — representability + Quot/Cartier engine (RR-free)

- **Goal-alignment**: PASS in intent — representability is non-negotiable: the goal returns an actual
  `Scheme` with `GrpObj`/`IsProper`/`SmoothOfRelativeDimension`, so `Pic⁰` must be represented.
- **Mathematical soundness**: PASS in principle (Nitsure §5 + Kleiman §4 is the canonical engine).
- **Infrastructure-deferral detected**: YES — two goal-required constructions have UNRESOLVED cost and
  NO concrete build plan/timeline (detailed in the Infrastructure-deferral section):
  `IsInvertible ⟹ locally-free-rank-1` (Quot embedding) and `Rⁱf_*` (i≥1). Both are on the critical path
  by the goal's own demand for a representable scheme.
- **Effort honesty**: UNDER-COUNTED / internally inconsistent. The row reads `~3400–5500 LOC · ~5/it`
  with `Iters left: ~30–60`. At the stated 5 LOC/it that is 680–1100 iters; even at the project's own
  blended average (`~4300–7500 LOC / ~95–180 iters` ⇒ ~40–50 LOC/it) the engine alone is ~75–110 iters,
  not 30–60. The "30–60" cell is arithmetically unsupported by either figure in its own row.
- **Parallelism under-exploited**: YES — see dedicated finding. The engine is the longest pole yet is
  "HELD" with a single ~5/it side-lane.
- **Verdict**: CHALLENGE — the planner must (a) reconcile the iters/LOC/velocity figures, (b) name a
  concrete build plan + iter estimate for the two deferred constructions (or schedule the
  mathlib-analogist pass *now*, not "at A.2.c entry ~12–16 iters out"), and (c) justify holding the
  longest pole behind the much-smaller substrate work.

### Route: A.4 — Albanese UP (Route 1 RR-free primary; Route 2 autoduality contingent)

- **Goal-alignment**: PASS — produces `exists_unique_ofCurve_comp` (the UP / `isAlbaneseFor`).
- **Mathematical soundness**: PASS — Route 1 (Weil's φ via divisor-sum + Milne 3.2/3.10 rigidity) is the
  correct RR-free primary. The reference index corroborates the load-bearing claim: Milne Prop 3.10
  ("Mor(ℙ¹,A) constant") is reached "via bare rigidity, NO Serre duality" (`abelian-varieties.md`, §I.3
  map). Well-definedness/descent to `Pic⁰` is genuinely RR-free if it goes through the pencil argument
  (linear equivalence `D~D'` ⇒ a morphism `ℙ¹→A` summing over the pencil, constant by 3.10) rather than
  through RR fiber-dimension counts — this is the right circle and matches the in-tree
  `Thm32RationalMapExtension`/`CodimOneExtension`/`AbelianVarietyRigidity` files.
- **Sunk-cost reasoning detected**: no — Route 2 is honestly labeled contingent and RR-freeness-unverified;
  Route 1 is primary on merit (RR pause), not on prior investment.
- **Verdict**: SOUND — with a note: explicitly pin the well-definedness argument to the
  Mor(ℙ¹,A)-constant/pencil route (not RR) in the blueprint, since Milne's Prop 6.1 is *stated* downstream
  of the RR-laden §III.4 construction; the strategy extracts only the rigidity-extension half, which is
  legitimate but should be made explicit so a later prover doesn't reach for §III.4.

### Route: Route C — Riemann–Roch (USER-paused, permanent)

- **Goal-alignment**: N/A (frozen by external USER constraint).
- **Verdict**: SOUND as a constraint — this is an external USER pause, not a project-side
  infrastructure-deferral, so it does not trigger the deferral rule. Correctly handled. Note only that the
  entire ~3400–5500 LOC engine + the Route-2 contingency exist *solely* to honor it; the strategy states
  this plainly, which is the honest posture.

### Route: Genus-0 arm

- **Verdict**: SOUND — the uniform `Pic⁰` route subsumes genus 0 (where `Pic⁰=Spec k`), so no case split
  is forced on the goal; arm (b) `J:=Spec k` is a paused optimization, not a goal weakening.

## Format compliance

- **Size**: ~134 lines / ~7.6 KB — within budget (~250 lines / ~12 KB).
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic
  questions`, `## Mathlib gaps & new material`, in order.
- **Per-iter narrative detected**: YES — material violations. Verbatim: "D2' **CLOSED axiom-clean
  (iter-250)** — first canonical critical-path elimination"; "the iter-250 idiom KB (propositional
  `:= rfl` strip + `erw` keyed-defeq) is in hand"; "**D2' (unit pair) is CLOSED axiom-clean (iter-250).**";
  plus a hard source-line reference "`addCommGroup` (RelPicFunctor.lean:269)". Per-iter history and
  file:line pins belong in `iter/iter-NNN/plan.md`, not STRATEGY.md.
- **Accumulation detected**: no (paused routes are retained intentionally and reversibly, not bloat).
- **Table discipline**: FAIL (minor) — the LOC cell must be `remaining · realized/it`, but A.1.c.sub
  carries prose ("D2' milestone landed (lumpy)") in the velocity slot, and the `Iters left` column carries
  prose ("D1' frontier (easy); D3'+D4' ~5–10") instead of a single figure in two rows.
- **Format verdict**: DRIFTED — the per-iter narrative is a material (CHALLENGE-level) violation that
  should be scrubbed in-place this iter; the table-cell prose is a minor cleanup.

## Infrastructure-deferral findings

### Deferred: `IsInvertible ⟹ locally-free-rank-1` (Quot embedding, A.2.c)

- **Required by goal**: yes — it is on the A.2.c representability critical path (Stacks
  lemma-invertible-is-locally-free-rank-1), and representability is demanded by the goal's
  `Jacobian C : Over (Spec k)` scheme.
- **Current plan for building it**: none concrete — "cost UNRESOLVED … whether this is the same
  Mathlib-scale spreading-out or a cheaper coherence statement is UNDECIDED … decide at A.2.c entry with a
  mathlib-analogist pass."
- **Timeline**: vague — "decide at A.2.c entry" (~12–16 iters out), budgeted "possibly Mathlib-scale".
- **Verdict**: CHALLENGE — the strategy openly names it (not hidden), but a goal-required construction
  with unresolved cost and a deferred decision point is the project's deepest unquantified risk. Run the
  mathlib-analogist scoping pass NOW rather than 12–16 iters out, so the engine's true cost is known
  before more substrate iters are sunk.

### Deferred: `Rⁱf_*` (i≥1) higher direct images

- **Required by goal**: yes — it is the "deepest root" of the engine, and also underpins `genus C`
  (= dim H¹(O_C)) and the tangent-space dimension `dim Pic⁰ = h¹(O_C) = g` (A.3), both goal-required.
- **Current plan for building it**: undecided fork — "Mathlib PR vs project Čech build (~800–1200) vs
  typed-sorry pin … Decide when the engine de-gates."
- **Timeline**: absent — explicitly deferred to an undated "when the engine de-gates".
- **Verdict**: CHALLENGE — a single sub-construction that "could dominate the engine cost" with three
  live options and no decision is a load-bearing gap. The fork should be decided (at least to a default)
  before the engine de-gates, since it sets the whole engine's feasibility.

## Alternative routes (suggested)

### Alternative: lift the comparison iso from Mathlib's `Sites.Monoidal` sheafification machinery

- **What it looks like**: Mathlib ships `CategoryTheory.Sheaf.instMonoidalFunctorOppositePresheafToSheaf`
  (sheafification `presheafToSheaf` is monoidal when `J.W.IsMonoidal` + `HasWeakSheafify`),
  `CategoryTheory.Sheaf.monoidalCategory`, and `sheafToPresheafMonoidal`. A fresh mathematician would ask
  whether `f^*(M⊗N)≅f^*M⊗f^*N` can be assembled from "presheaf-level pullback is monoidal" ∘ "sheafification
  is monoidal", obtaining the iso generically instead of via the D1'–D4' chart-chase.
- **Why it might be cheaper or sounder**: if applicable it would replace the bespoke chart-chase with
  off-the-shelf monoidal-functor composition.
- **What the current strategy may have rejected**: the recorded structural block — scheme module sheaves
  are valued over a `RingCat`-valued structure sheaf (`Sheaf K RingCat`), whereas
  `Sheaf.monoidalCategory`/`instMonoidalFunctor…` require a FIXED `MonoidalCategory A`. The module-sheaf
  tensor is not the cartesian/fixed-`A` tensor those lemmas equip, so the generic path likely does not
  type-check. This appears to be the correct reason the by-hand route was chosen.
- **Severity of the omission**: minor — the by-hand route is probably forced, but STRATEGY.md does not
  state *why* the generic `Sites.Monoidal` machinery is inapplicable. One sentence ("RingCat-valued
  structure sheaf ⇒ no fixed-`A` monoidal instance, so `Sites.Monoidal` doesn't apply") would close the
  fresh-reader gap and pre-empt a future prover wasting time reaching for it.

## Prerequisite verification

- `CommRing.Pic.functor` : VERIFIED (`Mathlib.RingTheory.PicardGroup`, `CommSemiRingCat ⥤ CommGrpCat`).
- `CommRing.Pic.mapAlgebra` : VERIFIED (same module).
- `CommRing.Pic.mapRingHom` (+ `_id`, `_mapRingHom`) : VERIFIED.
- `AlgebraicGeometry.Scheme.Modules.pullback` / `pullbackPushforwardAdjunction` / `instIsLeftAdjointPullback`
  : VERIFIED (`Mathlib.AlgebraicGeometry.Modules.Sheaf`) — `f^*` is an unconditional left adjoint.
- `AlgebraicGeometry.Scheme.Modules.Hom.isIso_iff_isIso_app` : VERIFIED — backs the D4' chart-chase upgrade.
- `CategoryTheory.Sheaf.isLocallyBijective_iff_isIso`, `TopCat.Presheaf.app_isIso_of_stalkFunctor_map_iso`
  : VERIFIED — additional chart/stalk-wise iso backing.
- `CategoryTheory.Sheaf.instMonoidalFunctorOppositePresheafToSheaf`, `Sheaf.monoidalCategory`,
  `sheafToPresheafMonoidal` : VERIFIED present (relevant to the suggested alternative above).
- `final_of_representablyFlat` : MISSING by that name (loogle: no results). Not load-bearing
  (`pullbackUnitIso` already built); flag for name cleanup only.

## Parallelism under-exploitation

- **Independent obligations being serialized**: the A.2.c-engine cohomology foundations — the
  `Cohomology_{FlatBaseChange, HigherDirectImage, MayerVietoris, SheafCompose, StructureSheafAb,
  StructureSheafModuleK}` chapters, plus Relative Proj / CM-regularity / flattening / Quot. The strategy
  itself DECIDES that "Engine foundations run in PARALLEL with the substrate … do NOT depend on the group
  law", yet the phase table marks A.2.c-engine "HELD" with only `Cohomology_FlatBaseChange` active at
  `~5/it`. The engine is simultaneously (i) the longest pole (~95–180-iter total is dominated by it) and
  (ii) acknowledged independent of the substrate. Throttling the longest, independent pole to a single
  trickle lane while concentrating iters on the much-shorter A.1.c substrate is a throughput inversion: it
  implicitly costs the project the engine's wall-clock that could be running in parallel now. Recommend
  spinning up additional parallel prover lanes on the engine's independent cohomology pieces immediately.

## Must-fix-this-iter

- Route A.2.c: CHALLENGE — reconcile the `~3400–5500 LOC · ~5/it` vs `Iters left ~30–60` inconsistency;
  produce a concrete build plan + iter estimate for the two deferred constructions.
- Infrastructure-deferral `IsInvertible ⟹ loc-free-rank-1`: CHALLENGE — goal-required, no concrete plan;
  run the mathlib-analogist scoping pass now, not at A.2.c entry.
- Infrastructure-deferral `Rⁱf_*` (i≥1): CHALLENGE — goal-required engine root; decide the
  PR/Čech/typed-sorry fork to a default rather than deferring to "when the engine de-gates".
- Parallelism: CHALLENGE — the longest, self-declared-independent pole (the engine) is throttled behind
  the substrate; open more parallel engine lanes or record an explicit rebuttal.
- Format: DRIFTED → scrub per-iter narrative ("iter-250", "first canonical critical-path elimination",
  "RelPicFunctor.lean:269") into `iter/iter-NNN/plan.md`; fix the two prose-in-table cells.
- Route A.1.c.sub: minor — add one sentence on why `CategoryTheory.Sites.Monoidal` cannot shortcut the
  by-hand comparison iso (RingCat-valued structure sheaf ⇒ no fixed-`A` monoidal instance).

## Overall verdict

The spine (`J := Pic⁰_{C/k}`, RR-free) is SOUND and goal-aligned: it is the genuinely-forced object given
the permanent USER Riemann–Roch pause, not a preference, and there is no cheaper RR-free route to a
representable Picard scheme for all curves. The active substrate lanes (A.1.c.sub, A.1.c.fun) are sound and
rest on VERIFIED Mathlib infrastructure (`CommRing.Pic.functor`/`mapAlgebra`/`mapRingHom`,
`Scheme.Modules.pullback` adjunction, `Hom.isIso_iff_isIso_app`); no phantom prerequisite was found on the
critical path. The Albanese plan (Route 1 RR-free primary via Milne 3.2/3.10 rigidity; Route 2 autoduality
correctly contingent) is sound, with the reference index confirming the "Mor(ℙ¹,A) constant via bare
rigidity, no Serre duality" claim. The serious findings are concentrated in A.2.c: **the strategy defers
`IsInvertible ⟹ locally-free-rank-1` and `Rⁱf_*` (i≥1), both of which are required for the stated goal**
(a representable scheme), with unresolved cost and no concrete build plan or timeline — these are the
project's deepest unquantified risks and must get a concrete plan or a now-scheduled scoping pass rather
than a deferred decision point. Compounding this, the engine — the longest pole and self-declared
independent of the substrate — is throttled to a single side-lane, an exploitable parallelism inversion.
Finally, STRATEGY.md has DRIFTED on format (per-iter "iter-250" narrative and a file:line pin embedded
inline) and should be scrubbed in place. None of these rise to REJECT: the route choices are correct and
the math is sound; the issues are honest-estimate, deferral-of-required-infra, throughput, and format
hygiene, all addressable this iter.
