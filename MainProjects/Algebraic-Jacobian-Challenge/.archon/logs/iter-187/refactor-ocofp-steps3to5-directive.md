# Refactor Directive

## Slug
ocofp-steps3to5

## Problem

`AlgebraicJacobian/RiemannRoch/OCofP.lean` has 7 pre-existing typed
`sorry`s blocked on the `lineBundleAtClosedPoint` body (L397). The
iter-186 plan-phase refactor (`ocofp-carrierset-submodule-recipe`)
landed Steps 1+2 of the 5-step recipe from
`analogies/ocofp-carrierset-submodule-api.md`:

- **Step 1** (LANDED iter-186): `IsRegularInCodimensionOne` upgraded to
  `IsDiscreteValuationRing` with `[IsIntegral X]` precondition; bridge
  `instKrullDimLEStalk`. Enables `Ring.ordFrac_add` /
  `Ring.ordFrac_ge_one_of_ne_zero` invocations.
- **Step 2** (LANDED iter-186): `carrierSubmodule` skeleton (a
  `Submodule kbar K(C)` cut out by per-prime-divisor `order ≥ 0`
  conditions); 3 closure sorries closed by iter-186 prover Lane A.

Steps 3+4+5 are DEFERRED to iter-187 (refactor re-dispatch). This
refactor lands them.

iter-187 progress-critic verdict for Lane A `OCofP.lean`: **CHURNING**
(sorry count flat 7/7/7/7 across iter-183 to iter-186 despite 3 helpers
added). Primary corrective: "Refactor — the carrierPresheaf functor +
presheaf_isSheaf construction (Steps 3–5) must dispatch in iter-187 and
close at least some of the 7 pre-existing sorries."

## Mathematical Justification

The construction of `lineBundleAtClosedPoint P hP : Scheme.HModule kbar
C.left` (the line bundle `O_C([P])` of a closed point of a smooth proper
curve over `k̄`) is the Hartshorne II.7 *direct subsheaf-of-`K_C`
construction*. The chain is:

1. **For each open `U ⊆ C`**, define
   `carrierSet P hP U : Set C.left.functionField` (Step iter-183) = the
   set of `f ∈ K(C)` satisfying `order Q f ≥ 0` for all prime divisors
   `Q ∈ U` other than `P` (if `P ∈ U`), and additionally
   `order P f ≥ -1` (the single-pole-at-`P` condition).

2. **Submodule upgrade** (Step 2, iter-186): show that for each `U`,
   `carrierSet P hP U` is a `Submodule kbar K(C)` — the
   `carrierSubmodule P hP U`. The three closure proofs (zero, add, smul)
   were closed iter-186 axiom-clean using `WithZero.log_zero` /
   `Ring.ordFrac_add` / `Ring.ordFrac_ge_one_of_ne_zero`.

3. **Step 3 — `carrierPresheaf` functor**: for `V ⊆ U`, every
   `f ∈ carrierSet P hP U` satisfies the order conditions on `V` (since
   `carrierSet P hP U ⊆ carrierSet P hP V` by the existing
   `carrierSet_mono` antitone witness at L181-192). Hence
   `Submodule.inclusion (carrierSet_mono P hP _)` gives a restriction
   `carrierSubmodule P hP U →ₗ[kbar] carrierSubmodule P hP V`. Bundle
   this as a `(TopologicalSpace.Opens C.left.toTopCat)ᵒᵖ ⥤
   ModuleCat.{u} kbar` functor `carrierPresheaf P hP`, where
   `carrierPresheaf P hP U := ModuleCat.of kbar ↥(carrierSubmodule P hP
   U.unop)` and `(carrierPresheaf P hP).map f := ModuleCat.ofHom <|
   Submodule.inclusion ...`. The functor laws (`map_id`, `map_comp`)
   are `by ext ⟨x, _⟩; rfl`.

4. **Step 4 — `carrierPresheaf_isSheaf`**: the presheaf is a sheaf in
   the appropriate `GrothendieckTopology` — for Hartshorne's direct
   construction, the locality + gluing conditions reduce (via the
   project's `toModuleKSheaf` template at
   `Cohomology/StructureSheafModuleK/SheafProperty.lean:32-44`) to the
   forgetful-to-Type sheaf condition on the underlying `Set`-valued
   functor (each `Submodule` is a subset of the underlying `K(C)`-set,
   and the sheaf property in `ModuleCat kbar` follows from the sheaf
   property of the constant `K(C)`-sheaf via
   `isSheaf_iff_isSheaf_forget`).

5. **Step 5 — `lineBundleAtClosedPoint` body**: with `carrierPresheaf`
   and `carrierPresheaf_isSheaf` in hand, define
   `lineBundleAtClosedPoint P hP := { val := (carrierPresheaf P hP, ...
   sheafification witness), property := ... }` (the exact Lean encoding
   matches the `Scheme.HModule kbar C.left` carrier; check the project's
   `toModuleKSheaf` for the shape). This **closes the L397 pre-existing
   `sorry`** — net **−1** to the pre-existing sorry count.

The downstream pre-existing sorries that cascade-close once Step 5
lands:
- L418 `toFunctionField` body — directly gated on `lineBundleAtClosedPoint`'s
  body shape.
- L480 `globalSections_iff_mp` body — uses the explicit `carrierSubmodule`
  membership.
- L526 `globalSections_iff_mpr` body — uses the reverse direction.

If at least one of these 3 cascades is straightforward post-refactor, the
prover round following this refactor closes additional pre-existing
sorries. The HARD BAR per iter-187 progress-critic: at least 1
pre-existing sorry must close iter-187. Step 5 alone meets this.

## Changes Requested

- **File**: `AlgebraicJacobian/RiemannRoch/OCofP.lean`
  - Add new declarations between the existing `carrierSubmodule` block
    (around L228) and the existing `lineBundleAtClosedPoint` block
    (around L397):
    - `lineBundleAtClosedPoint.carrierPresheaf` (functor; ~30 LOC).
    - `lineBundleAtClosedPoint.carrierPresheaf_isSheaf`
      (Prop; ~30 LOC).
  - Replace the body of `lineBundleAtClosedPoint` at L397 (was a typed
    `sorry`) with the `carrierPresheaf` + `carrierPresheaf_isSheaf`
    bundle into `Scheme.HModule kbar C.left`.
  - Note: the existing 4 typed sorries downstream of `lineBundleAtClosedPoint`
    body (`toFunctionField`, `globalSections_iff_mp`,
    `globalSections_iff_mpr`, `h1_vanishing_genusZero` — and
    `dim_eq_two_of_genusZero` / `exists_nonconstant_genusZero` derived
    further) should NOT be touched by this refactor. They remain typed
    sorries; the prover round that follows attempts them.

- **File**: `AlgebraicJacobian/Cohomology/StructureSheafModuleK/SheafProperty.lean`
  - Read this file to extract the project's `isSheaf_iff_isSheaf_forget`
    pattern used by `toModuleKPresheaf_isSheaf` (around L32-44 per the
    analogy). Mirror this pattern for `carrierPresheaf_isSheaf`. No
    changes to this file.

## Affected Files

- `AlgebraicJacobian/RiemannRoch/OCofP.lean` (primary; expected
  ~70-80 LOC addition + body replacement).
- No other files expected to break — Step 3 + 4 introduce private
  helpers; Step 5 replaces a body that is currently `sorry`.
- If `archon-protected.yaml` lists any OCofP declaration as protected:
  check. (Reading at refactor-time: the file is short; verify.) None
  should be — `lineBundleAtClosedPoint` is project-bespoke.

## Expected Outcome

After this refactor:

- **`carrierPresheaf`** (new): typed sorry-free declaration (the body is
  `ext`-based; uses `Submodule.inclusion` + `carrierSet_mono`). Should
  be axiom-clean.
- **`carrierPresheaf_isSheaf`** (new): one new typed sorry expected on
  the sheaf property body — the `isSheaf_iff_isSheaf_forget` chase
  reduces to a Set-level sheaf check that may need one named typed
  sorry if Mathlib doesn't ship the exact intermediate piece. Accept
  up to 1 named typed sorry inside this declaration's body if the
  closure isn't immediate.
- **`lineBundleAtClosedPoint` body L397**: NOW USES the new
  `carrierPresheaf_isSheaf` bundle. **−1 pre-existing sorry**.
- **Downstream pre-existing sorries**: `toFunctionField` L418,
  `globalSections_iff_{mp,mpr}` L480/L526 should typecheck (their
  bodies may still be typed sorries — that's the prover's iter-187
  followup job, not the refactor's).
- **`lake build AlgebraicJacobian`**: GREEN.
- **Net sorry delta from refactor**: at minimum −1 (Step 5 closing
  L397). Possibly up to −1 net (Step 5 lands; +1 narrow named typed
  sorry inside `carrierPresheaf_isSheaf` if the closure isn't immediate
  → 0 net or +1 net acceptable IF the iter-187 prover round closes the
  narrow typed sorry post-refactor).

The refactor agent's job is to LAND THE STRUCTURE. Closure of any
remaining typed sorries is the iter-187 prover round's job, dispatched
to OCofP.lean as a follow-up.

## Mathlib substrate citations

- `CategoryTheory.Functor` + `Functor.map_id` / `map_comp` —
  `Mathlib.CategoryTheory.Functor.Basic`.
- `ModuleCat.of` / `ModuleCat.ofHom` — `Mathlib.Algebra.Category.ModuleCat.Basic`.
- `Submodule.inclusion` (linear map from a smaller submodule to a larger
  one) — `Mathlib.LinearAlgebra.Submodule.Basic`.
- `TopologicalSpace.Opens.{op,unop}` for the opens-op-cat — Mathlib.
- `isSheaf_iff_isSheaf_forget` — `Mathlib.CategoryTheory.Sites.SheafOfTypes`
  (or the relevant `Mathlib.CategoryTheory.Sites.Whiskering` flavour).
- Project template: `AlgebraicJacobian/Cohomology/StructureSheafModuleK/SheafProperty.lean:32-44`
  (`toModuleKPresheaf_isSheaf` → `toModuleKSheaf`).

The recipe is documented in `analogies/ocofp-carrierset-submodule-api.md`
sections "Decision 3" + "Decision 4". Read it for the precise idiom
shape.

## Constraints

- No new project axioms.
- No `\leanok` markers (sync_leanok manages this).
- Preserve the existing 2 new instance helpers from iter-186
  (`instNonemptyTopOpen`, `instAlgebraKbarFunctionField`).
- Preserve the 3 closure sorries closed by iter-186 prover
  (`zero_mem'`, `add_mem'`, `smul_mem'`).
- Read `archon-protected.yaml` and verify no protected signature is
  affected.
