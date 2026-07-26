Task complete. Here is the report.

## What changed

**`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/DivRepAffKit.lean`** — the retype itself. `U` went from `∀ i j, CertifiedDivisorFamily C (ChartRing i j) pi g` to `∀ i j, DivFamZar C (ChartRing i j) pi g` in four declarations:
- `divRepPullAt` (:98) — body is now `DivFamZar.mapAlgHom omega (U i j)`.
- `divRepPullAt_id` (:108) — statement now `= U i j`; proof `DivFamZar.mapAlgHom_id _` unchanged.
- `divRepPullAt_comp` (:119) — proof `(DivFamZar.mapAlgHom_comp omega phi (U i j)).symm`, i.e. `(DivFam.mk (U i j)).toZar` → `U i j`, otherwise verbatim.
- `DivRepChartFamily.IsCompatible` (:135) and `DivRepChartFamily.pullAt_eq_of_eq_common` (:150) — binder retyped, bodies verbatim.
- `DivRepAffinePullback` (:175) and everything under it never mentioned `U`; untouched.

**`.../Picard/DivRepAffChartOverlap.lean`** — one binder in `divRepPullAt_mapAlgHom_eq_of_chartFactor` (the F5 overlap agreement). Proof unchanged, including the 800000-heartbeat defeq.

**`.../Picard/DivRepAffPullbackReduce.lean`** — one binder in `isCompatible_of_isDivRepClassify_divRepPullAt`. Proof unchanged.

**`.../Picard/DivRepAffKitZar.lean` — deleted** (see finding below).

Nothing had to be weakened, no `sorry`, no new declarations, `AlgebraicJacobian.lean` untouched.

## Build

Full `lake build AlgebraicJacobian` under the mkdir lock, final line exactly:

```
Build completed successfully (9085 jobs).
```

Same 9085 as baseline — which is itself evidence for the finding below: removing a whole 174-line module changed the job count by zero, because that module was never a job. All three surviving files also return empty `lean_diagnostic_messages` (no errors, no warnings).

## Commit

`1e4ac5b52092e0a8aa5e03ae25076b1163230c0b` — "picard: the F5 chart family is a Zariski-local class, not a global certificate". `show --stat` touches exactly the four files above. Another lane has since landed `553321044` on top; my commit is confirmed an ancestor of HEAD and intact.

## Finding: the roadmap's "cheap edit nobody has made" had in fact been made — into an unrooted module

`AlgebraicJacobian/Picard/DivRepAffKitZar.lean` existed at HEAD (174 lines, added 2026-07-25 by commit `1c093de44`, session `0002-horizon-ajcr-w4-rep-free`, whose message claims exactly this weakening). It contained a complete Zar-level restatement of the F5 kit: `divRepPullAtZar`, `divRepPullAtZar_id`, `divRepPullAtZar_comp`, `divRepPullAtZar_toZar`, `DivRepChartFamilyZar.IsCompatible`, `DivRepChartFamilyZar.eq_of_isCompatible`, plus a local instance. `divRepPullAtZar` was byte-for-byte the definition my task briefed.

**It was never imported from `AlgebraicJacobian.lean`.** That commit touched one file and did not add an import line. Lake's `lean_lib AlgebraicJacobian` builds the root module and its transitive imports only, so this module has never been elaborated or kernel-checked by the configured build since the day it landed. Its `lean_status: lean_ok` in `hgraph/nodes/` is therefore unearned. This is a repeatable failure mode worth a guard: a new `Picard/*.lean` with no importer looks green and is invisible.

So the roadmap leaf `...ddr.divrep.u2` was wrong in both directions: the edit had been made, and it had not been landed.

**Before/after, declaration by declaration** (nothing vanished silently):

| HEAD `DivRepAffKitZar.lean` | after |
|---|---|
| `divRepPullAtZar` | **is** `divRepPullAt` (`DivRepAffKit.lean:98`) — identical type and body |
| `divRepPullAtZar_id` | **is** `divRepPullAt_id` (:108) — identical statement `= U i j`, identical proof |
| `divRepPullAtZar_comp` | **is** `divRepPullAt_comp` (:119) — identical |
| `DivRepChartFamilyZar.IsCompatible` | **is** `DivRepChartFamily.IsCompatible` (:135) — identical |
| `DivRepChartFamilyZar.eq_of_isCompatible` | **is** `DivRepChartFamily.pullAt_eq_of_eq_common` (:150) — same proposition, same proof term `hU i j i' j' omega omega' (homega.trans homega'.symm)`. Only difference: `U` is an explicit binder here, implicit there. Explicit is not weaker (`hU` still determines `U`; a caller may pass `_`). |
| `divRepPullAtZar_toZar` | **genuinely subsumed, deliberately dropped.** It asserted, by `rfl`, that the class-level map on `fun i j => (DivFam.mk (U i j)).toZar` agrees with the certified-input map on `U`. With one map instead of two its statement is literally `X = X`. Its content — that a certified family is admissible input via `(DivFam.mk G).toZar` — is now a typing fact at the call site, not a theorem. |

I chose merge-and-delete over keep-and-root because after the retype the two files are the same file: rooting `DivRepAffKitZar.lean` would have put a second, name-mangled copy of the whole kit into the build, which is the "parallel track" the weakening exists to eliminate, and would have left `divRepPullAt` still demanding the blocked global certificate. Six `hgraph/nodes/*.md` now point at a vanished source (`5f705162a2ed`, `7a6c30596b20`, `268ffa74b020`, `4a64fcd253f6`, `d11807bbaeda`, `e4e292a97d3d`); `horizon graph sync` reports and clears stale nodes, and I left it for the run boundary rather than mixing that churn into this commit.

No consumer anywhere needed the certified representative rather than its class — the "STOP and report" case did not arise.

## Bonus: what can now produce `U : ∀ i j, DivFamZar C (ChartRing i j) pi g`

`ThetaGeneratorSeed.divFamZar_of_forall_prime_away_certified` (`DivSchemeCertZarPointwise.lean:181`) **can** be instantiated at `R := ChartRing i j`, `n := g`. Its output type is `DivFamZar C R pi n`, exactly the new `U i j`. Checking each side condition:

- `[IsNoetherianRing R]` (its section variable at :126) — **discharged**, landed instance `isNoetherianRing_divCarveChartRing` (`DivSchemeFamilyUniv.lean:62`).
- `[IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom]` — `omit`ted at :131, so not required; DivRepAffKit's section supplies them anyway.
- `[IsFinite pi]`, `[Field k]`, `[Algebra k R]` — all present in DivRepAffKit's section.
- The ring matches on the nose: `seedChartRing` (`DivSchemeRedesignCarvePin.lean:57`) is `DivCarveChartRing k (windowS_choice π hπ g • fiberWeilDivisor π) (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j`, which is `ChartRing i j` with `b₂ := b2.map (windowShiftEquiv hpi g).symm`.

Two hypotheses remain, and neither is the chart-confinement no-go:

1. **`hD : D.IsGenerator`.** The seed exists — `seedUniv` (`DivSchemeSeedUnivGen.lean:283`) is a `ThetaGeneratorSeed` over precisely this ring at `a := windowM_choice π hπ g`, `K := divUniversalSeedK`. The landed generator theorem is `isGenerator_seedUniv'` (`DivSchemeRedesignSeedUniv.lean:205`), gated on two inputs: `hrdn : SeedUnivRDN C hπ g r₁ r₂ b₁ b₂ i j hO hχ` and an `hfib` fibre-nonvanishing clause. `SeedUnivRDN` (:130) is, verbatim: *"at every point `z`, the seed colength `seedUnivColength z` avoids the module-stalk prime of `z` — i.e. `read sec z` generates the base ideal `J z` at the stalk `𝒪_z` (the achiever cuts exactly `d_p`, so `z` is not an extra zero). The honest remaining geometric wall (I-0302 §residual 2b/2c: the achiever fibre-generation + landed chart flat via the `κ(p)→𝒪_z` transport)."*

2. **The pointwise certificate `h`**, verbatim from :182:
   ```
   ∀ p : PrimeSpectrum R, ∃ r, r ∉ p.asIdeal ∧
     ∃ G : CertifiedDivisorFamily C (Localization.Away r) pi n,
       Scheme.LocalEquations.DivEq G.eqns
         ((D.localEquations hD).pullback (relCurveMap C R (Localization.Away r)) …)
   ```
   or, in the cheaper spelling of `isLocallyCertified_of_forall_prime_exists_certified_adaptation` (:162), `∃ A : DivisorAdaptation C (Localization.Away r) pi (…pullback…), A.IsCertified n` — whose docstring records that *"the adaptation itself is free (`exists_divisorAdaptation`), so the only genuine obligation is the certificate over the shrunken base — where the support tube makes per-piece isolation available."*

The point of the retype: both remaining obligations are **per-prime, after shrinking the base**. Neither asks for a degree-`g` certificate valid over the whole of `ChartRing i j`, which is what the chart-confinement no-go forbids and what the old signature demanded.
