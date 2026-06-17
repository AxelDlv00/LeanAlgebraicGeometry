# Recommendations for the next plan-agent iteration (iter-054)

## Status overview

- **Iter-053 closed cleanly** (seventh zero-corrective single-Edit iteration in a row, iter-047 → iter-053). Both new declarations (`HasAffineCechAcyclicCover` L1279, `instIsAffineHModuleVanishing_of_hasAffineCechAcyclicCover` L1303) compile, are `sorry`-free, and carry kernel-only axioms `[propext, Classical.choice, Quot.sound]`.
- The scaffolding ladder for `IsAffineHModuleVanishing` is now **fully closed**: iter-040 (consumer of `IsAffineHModuleVanishing`) → iter-052 (rewrite-bridge consumer landing `Subsingleton (HModule' k F i U)` from a basic-open cover with `⨆𝒰 = U`) → iter-053 (carrier class `HasAffineCechAcyclicCover` + producer instance chaining iter-052). Iter-054+ work shifts from *scaffolding* to *substantive instantiation*: instantiating `HasAffineCechAcyclicCover (toModuleKSheaf C)` for an affine variety / curve.
- Sorry trajectory: still **9** (5 protected `Jacobian.lean` + 3 protected `AbelJacobi.lean` + 1 deferred `Picard/Functor.lean`). Unchanged since iter-051. All Phase A iterations have been pure scaffolding (no protected sorry closure).
- Phase A iterations-remaining: held at **~4** per the iter-053 prompt header.

## Highest-priority track for iter-054 (PRIMARY recommendation)

**Track 2A.3 — substantive Čech-vs-derived comparison theorem (Phase A step 6 / step 4.6.3).** The data argument: a `LinearEquiv`
```
∀ n, Scheme.cechCohomology C F 𝒰 n ≃ₗ[k] Scheme.HModule' k F n (⨆ i, 𝒰 i)
```
under appropriate hypotheses — most likely `[IsCechAcyclicCover F 𝒰]` plus a covering condition, possibly also a sieve cofinality input. Once landed as a theorem, an instance for `HasCechToHModuleIso` wraps it via `⟨⟨the_iso⟩⟩`. Together with iter-054+ basic-open Koszul acyclicity producers (Step 4.6.4) and an existence-of-cover construction wrapping both into `HasAffineCechAcyclicCover (toModuleKSheaf C)`, this completes the iter-053 producer chain end-to-end.

- **Estimate**: ~3-4-iteration cohort (per iter-052 / iter-053 trajectory). Mathlib substrate: `cechComplexFunctor` exists (`Mathlib/CategoryTheory/Sites/SheafCohomology/Cech.lean`) but no comparison-to-derived theorem. Project-local construction is most likely.
- **Approach**: build the comparison via the iter-047 parameterised Čech infrastructure + iter-019's pushout-Module-Cat-Free-Sheaf bridge + LES. Decompose into:
  - **iter-054**: Čech sheaf-resolution at degree `≥ 1` (computational; alternating face complex is exact under acyclicity). Likely 1-2 iterations.
  - **iter-055**: Chain via `Ext` functoriality to derived-functor cohomology to land the comparison `LinearEquiv`. Likely 1-2 iterations.
  - **iter-056**: Wrap as `HasCechToHModuleIso` instance via `⟨⟨the_iso⟩⟩` + provide `IsCechAcyclicCover` instance for affine basic-open covers + bundle into `HasAffineCechAcyclicCover (toModuleKSheaf C)` instance.

## Alternative warm-up tracks (kept as fallback)

These remain valid but are lower priority than Track 2A.3:

- **Track 2A.4 — basic-open cover acyclicity producer instances (Step 4.6.4)** for affine basic-open covers. Koszul-type alternating-sum exactness on localisations. Plausibly multi-iteration (~2-3 iterations, ~100-200 LOC). **Can proceed in parallel with Track 2A.3 since the two are independent inputs to the eventual `HasAffineCechAcyclicCover (toModuleKSheaf C)` instance.**
- **Track 2B — finrank corollary of iter-046 producer**: explicit identity `Module.finrank k (HModule k (toModuleKSheaf C) 0) = Module.finrank k Γ(C, 𝒪_C)`. Plausibly single-iteration ~30-50 LOC. Off-critical-path.
- **Track 2C — sharper Mayer–Vietoris LES consumer** for the curve case. Plausibly single-iteration ~30-50 LOC. Off-critical-path.
- **Track 2D — Mathlib upstream PRs** for the five new `CategoryTheory.*` declarations from iter-046. Off-Archon side track.

## Reusable proof patterns confirmed iter-053

These are now well-established and should be reused at iter-054+ producer call sites:

- **Existence-bundling carrier-predicate pattern** *(iter-053, generalises iter-040 / iter-043 / iter-048 / iter-050)*: package three intertwined obligations (per-affine cover + acyclicity + comparison-iso) behind a single carrier `Prop`-class with one `∀-∃` field. Reusable for any future producer that needs to bundle multiple instance-arguments into a single carrier.
- **`obtain ⟨..⟩ + haveI + exact <consumer>` three-step instance body** *(iter-053, new this iteration)*: extract data from existential, install conjuncts as local class instances, fire chained consumer. The `haveI` lines are *mandatory* — their absence breaks instance synthesis on the chained consumer.
- **Named-argument `(F := F)` for field-extractor disambiguation** *(iter-053, generalises iter-049/050/051/052)*: required when a class field's `{F}` cannot be inferred from any subsequent argument. Plan-agent should default to fully-named arguments at chained call sites.
- **Verbatim probe-confirmed body, single combined Edit pattern** *(iter-035 → iter-053)*: 16 of 19 iterations zero-corrective. **Seventh zero-corrective Edit in a row** (iter-047 → iter-053). Plan-agent should continue probing each new declaration body via `lean_run_code` before authoring the Edit.

## Plan-agent process discipline (continuing)

- **Pre-mark `\leanok` discipline**: iter-051 → iter-053 streak now holds at **3 iterations in a row** (after iter-050 broke a 5-iteration streak). Continue authoring `\subsection{...}` blocks in `Cohomology_MayerVietoris.tex` with pre-marks **before** the prover Edit, then validate review-side. Resolves cleanly.
- **`blueprint/lean_decls` clear-as-you-go**: 14 iterations in a row (iter-040 → iter-053). Continue.
- **LOC band**: iter-053 came in at +53 (3 over the `+30-50` band). Within tolerance. For iter-054+ substantive comparison theorem work, plan should keep the widened **`+50-150` band** given the heavier content (Čech sheaf resolution, alternating-sum exactness, `Ext` functoriality chaining).

## Known dead-ends (do not retry — see `PROJECT_STATUS.md` Known Blockers section)

In addition to the existing dead-ends, iter-053 adds these:

- **Promoting the `HasAffineCechAcyclicCover` field `exists_cover` from `∃` to a class-valued or non-`Prop`-valued field** — would force `Type`-valued data on a `Prop`-valued class, breaking the carrier-predicate pattern and `Classical.choice`-friendly extraction.
- **Removing the `(F := F)` named-argument disambiguation in the iter-053 producer body** — positional inference from `(hU : IsAffineOpen U)` alone fails since `F` does not appear in `IsAffineOpen U`.
- **Removing the two `haveI` lines from the iter-053 producer body** — typeclass synthesis on iter-052's `subsingleton_HModule'_of_hasCechToHModuleIso` consumer fails without them.
- **Promoting iter-053's producer from `instance` to `theorem`** — would break the iter-040 → iter-053 chain; downstream consumers expect `IsAffineHModuleVanishing` to synthesize automatically from `[HasAffineCechAcyclicCover F]`.
- **Folding iter-053's existence carrier into iter-040's `IsAffineHModuleVanishing` directly** — would conflate the carrier (input data, iter-054+ obligation) with its consequence (output `Subsingleton`-flavoured statement, iter-040), erasing the producer-pattern abstraction layer.

## What the plan agent should NOT assign at iter-054

- The 5 `Jacobian.lean` protected sorries (Phase C step 4 / FGA representability + `noncomputable` user decision).
- The 3 `AbelJacobi.lean` protected sorries (structurally downstream of `Jacobian C` + `noncomputable` decision).
- The deferred `Picard/Functor.lean` `representable` sorry (would silently assert representability of the wrong functor).
- All closed scaffold sites (iter-016 → iter-053 in `MayerVietoris.lean` + iter-006/009-012/014-015/026/038-048 in `StructureSheafModuleK.lean`).
- Promoting any iter-049 → iter-053 `theorem` consumer to `instance` — typeclass synthesis cannot supply explicit `h` / `hn` / `n` arguments at call sites (six known dead-ends).
