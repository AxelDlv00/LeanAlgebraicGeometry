# Mathlib Analogist Report

## Mode
api-alignment

## Slug
rigidity-affineconst

## Iteration
159

## Question
Does Mathlib have an idiom for the **relative** statement "a proper morphism with
geometrically-connected fibres into an affine target is constant along fibres", expressed as a
**scheme-morphism equality**, usable to close the agreement equation (bridge 2) of
`rigidity_eqOn_dense_open` (`AlgebraicJacobian/AbelianVarietyRigidity.lean:181`)?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| 1. Relative Stein / proper pushforward `f_* O = O` framing | NEEDS_MATHLIB_GAP_FILL | informational (do not pursue) |
| 2. Global-sections + per-slice field route ("route B", cohomology-free) | PROCEED | informational (recommended path) |
| 3. `[IsAlgClosed kbar]` missing from rigidity chain | ALIGN_WITH_MATHLIB | major |

## Headline answer to the directive's key question

**Bridge 2 is NEITHER a 1-iter idiomatic call NOR the hopeless cohomology gap it was feared to
be.** It is a **~2–3 iter, cohomology-FREE assembly** via the global-sections / per-closed-point
route. The relative "Stein / `f_*O = O`" idiom the directive asked about is **genuinely absent**
from Mathlib (no `SteinFactorization`, no proper pushforward connectedness, no `H⁰` proper base
change) and would be a multi-iter gap-fill — so **do not frame bridge 2 that way**. The
global-sections adjunction + per-slice field argument **does** suffice without `f_*` cohomology,
using only facts Mathlib already has, plus one small bespoke globalization step.

## Major

- **Decision 3 — add `[IsAlgClosed kbar]` to the rigidity chain.** `rigidity_eqOn_dense_open`
  (L111), `rigidity_core` (L243), `rigidity_lemma` (L324) carry only `[Field kbar]`. The
  cohomology-free route needs `κ(closed point) = k̄` (so `Γ(slice)`, a finite extension of `k̄`, is
  `k̄`). The downstream consumers `morphism_P1_to_grpScheme_const` (L357) and
  `rigidity_genus0_curve_to_grpScheme` (L406) **already** assume `[IsAlgClosed kbar]`; the variable
  is literally named `kbar`. **Not** adding it forces the harder generic-fibre route, which needs a
  "geometrically connected + geometrically reduced ⟹ `Γ = K`" upgrade over a non-alg-closed base
  (separable-and-connected ⟹ trivial-finite-extension) that Mathlib does not package. This is a
  low-cost, in-proposal signature change (the bodies are still `sorry`), hence "major", not
  must-fix-shipped.

## Informational

### Decision 1 — the relative Stein / `f_* O = O` framing is a Mathlib gap (avoid it)
Searched `Stein factorization`, `proper pushforward structure sheaf`, proper base change for `H⁰`:
absent. Only the bare functor `Scheme.Modules.pushforward` / `SheafOfModules.pushforward` exist —
no `f_*O = O` connectedness theorem, no `Γ(X ×_S T) = Γ(X) ⊗ Γ(T)`. Building this is the
multi-iter coherent-cohomology route the project committed to **avoid** (route (c) was chosen
precisely to dodge cohomology). The prover should not attempt to express bridge 2 as `p₂,*O = O`.

### Decision 2 — route B: the cohomology-free assembly (recommended). Concrete idiom stack:
1. **Per-closed-slice constancy into the affine `U₀`** — `AlgebraicGeometry.ext_of_isAffine`
   (a map into an affine is determined by `appTop`) + `isField_of_universallyClosed` +
   `finite_appTop_of_universallyClosed` (`Mathlib.AlgebraicGeometry.Morphisms.Proper`) + alg-closed
   triviality of finite extensions. For a **closed** `y ∈ V`, `κ(y)=k̄`, slice `X_y` proper
   integral, `Γ(X_y)=k̄`, so `f|X_y` and `(retract ≫ f)|X_y` have equal `appTop : Γ(U₀)→k̄` (same
   kernel = the point; a `k̄`-algebra map to `k̄` is pinned by its kernel) ⟹ equal as morphisms.
2. **Globalize to `U`** — `ext_of_isDominant` / `ext_of_isDominant_of_isSeparated'`
   (`Mathlib.AlgebraicGeometry.Morphisms.Separated`, `IsReduced` source + `IsSeparated` target,
   already used by `rigidity_core`) fed a **dense-range** probe. Closed points are dense:
   `closure_closedPoints`, `LocallyOfFiniteType.jacobsonSpace`, `JacobsonSpace`
   (`Mathlib.Topology.JacobsonSpace`, `...Morphisms.FiniteType`). Per-point probe:
   `Scheme.fromSpecResidueField x` (`range = {x}`). `IsDominant = topologically DenseRange`
   (`dominant_eq_topologically`).
3. **The single genuinely-missing connective**: a packaged "morphisms agreeing on a **dense set of
   closed points** ⟹ equal" hom-ext. Mathlib has only the **single-dominant-morphism**
   `ext_of_isDominant`; turning per-closed-point agreement into one dominant probe needs a
   `Set`-indexed coproduct `∐_{x ∈ closedPoints U} Spec κ(x) → U` + a `DenseRange` proof, **or** a
   small custom Jacobson hom-ext lemma. Buildable from the pieces above; **not** cohomology. This
   is the residual ~1–2 iter prover task after Decision 3 is applied.

### Note on the directive's other open `sorry` (`hfib`, L154)
Out of scope here (a pullback-fibre-topology fact, not the affine-constancy bridge), but the same
`Scheme.fromSpecResidueField` / residue-field API is the relevant Mathlib shelf.

## Persistent file
- `analogies/rigidity-affineconst.md` — full decision blocks + the route-B assembly recipe and
  citations, for future iters.

Overall verdict: bridge 2 is a cohomology-FREE ~2–3 iter assembly (`ext_of_isAffine` per-slice +
`ext_of_isDominant` globalize over dense closed points), **not** the relative `f_*O=O` idiom (a
genuine multi-iter Mathlib gap to avoid); first concrete step is adding `[IsAlgClosed kbar]` to the
three chain lemmas.
</content>
