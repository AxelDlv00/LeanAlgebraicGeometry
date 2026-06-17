# Mathlib Analogist Report

## Mode
api-alignment

## Slug
ts219dual

## Iteration
219

## Question

How do we get the tensor-inverse object `Linv` for a locally-trivial `L : X.Modules`
(`exists_tensorObj_inverse`)? (1) Does Mathlib have an internal-hom/dual for
`PresheafOfModules`/`SheafOfModules` landing back in modules? (2) Is there a
line-bundle-specific inverse shortcut (how does `Module.Invertible`/`CommRing.Pic` get the
fixed-ring inverse, does its shape port sheaf-locally)? (3) Does Mathlib have object-level
descent/gluing for `SheafOfModules` or sheaves valued in a category? (4) Verdict + bounded
recipe + cost.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| 1. internal-hom/dual for Presheaf/SheafOfModules | NEEDS_MATHLIB_GAP_FILL | informational (gap upstream) |
| 2. line-bundle-specific inverse (port `Module.Dual` shape) | NEEDS_MATHLIB_GAP_FILL | informational |
| 3. object-level descent for `SheafOfModules` | NEEDS_MATHLIB_GAP_FILL | informational |

No ALIGN_WITH_MATHLIB verdict — there is no shipped parallel API to refactor; the gap is a
genuinely missing Mathlib construction.

## Informational

### Decision 1 — internal hom / dual: ABSENT for varying ring, present only for fixed ring

- **Fixed-ring idiom EXISTS**: `instance : MonoidalClosed (ModuleCat.{u} R)`
  (`Mathlib/Algebra/Category/ModuleCat/Monoidal/Closed.lean:39`), with
  `ihom M N = (M ⟶ N)` as an `R`-module and `ihom M 𝟙_ = Module.Dual R M = M →ₗ[R] R`.
- **Varying-ring (the project's case): ABSENT at every level.** No
  `MonoidalClosed (PresheafOfModules R)`, no `MonoidalClosed (SheafOfModules R)`, no
  internal-hom/dual file in `…/ModuleCat/Presheaf/` or `…/ModuleCat/Sheaf/` (those dirs
  have `Monoidal.lean` = the tensor, but no `Closed`/`InternalHom`/`Dual`). Re-confirmed
  the iter-218 negative finding.
- **KEY: this is NOT a "presheaf-then-sheafify" mirror of `tensorObj`.** `tensorObj`
  sheafifies cleanly because the presheaf tensor is COVARIANT in restriction. The dual is
  CONTRAVARIANT (`U ↦ Hom_{R(U)}(M(U),R(U))` is not a covariant presheaf); the right object
  is the slice/end formula `ℋom(M,N)(U) = (M|_U ⟶ N|_U)`, and constructing that IS the
  hard part. There is no presheaf-level dual to sheafify, so the iter-217 H1 precedent
  ("de-sheafify an existing sheaf-level decl") does NOT transfer.

### Decision 2 — line-bundle inverse: Mathlib's fixed-ring inverse = the linear dual; no shortcut

- `Module.Invertible R M : Prop := Function.Bijective (contractLeft R M)`
  (`Mathlib/RingTheory/PicardGroup.lean:78`). The inverse OBJECT is
  **`Module.Dual R M = M →ₗ[R] R`**; the contraction is
  `Module.Invertible.linearEquiv : Module.Dual R M ⊗[R] M ≃ₗ[R] R` (`:84`); the dual is
  itself invertible (`instance : Module.Invertible R (Dual R M)`, `:169`). This is the
  same internal hom as Decision 1 specialised to the unit. `CommRing.Pic` reads its
  `CommGroup` off `Skeleton (Module.Invertible R)`, with this dual as the group inverse —
  consistent with memory `commring-pic-is-skeleton-route`.
- **Shape does NOT port cheaply.** Sheaf-locally the inverse is just `𝒪_{U_i}` (dual of
  trivial is trivial), but ASSEMBLING a global `Linv` from the local pieces along
  `g_{ij}⁻ᵀ` is exactly object descent (Decision 3). The only descent-free alternative is a
  global dual formula = the internal hom (Decision 1). Decision 2 therefore collapses into
  1 or 3; it is not an independent cheaper route. The purely-existential goal (`∃ Linv`)
  does not help — at least one object must still be constructed.

### Decision 3 — object descent: abstract framework EXISTS (new), but no module instance

- **NEW (2025, Riou–Merten) effective-descent framework**, directly the route-(II)
  primitive: `CategoryTheory.Pseudofunctor.DescentData F f` = category of objects over a
  cover with cocycle data (`Mathlib/CategoryTheory/Sites/Descent/DescentData.lean:57`);
  `Pseudofunctor.IsStack F J` = effective descent typeclass
  (`…/Sites/Descent/IsStack.lean:49`); `isEquivalence_toDescentData` (`IsStack.lean:70`)
  yields a global object from descent data. (Files: `Sites/Descent/{DescentData,
  DescentDataPrime, DescentDataAsCoalgebra, IsPrestack, IsStack}.lean`.)
- **No module connection**: `grep IsStack` over Mathlib finds it ONLY inside
  `Sites/Descent/*` — NO `IsStack` instance for `SheafOfModules`/`QuasiCoherent`/
  `Scheme.Modules`, and no pseudofunctor `LocallyDiscrete (Opens X)ᵒᵖ ⥤ᵖ Cat` for the
  module-restriction. The only module descent file,
  `Mathlib/Algebra/Category/ModuleCat/Descent.lean`, is FIXED-ring faithfully-flat
  comonadic descent (extension of scalars) with effectivity still a `TODO` — not Zariski
  object gluing on `Opens X`. Connecting `SheafOfModules` to the framework (build the
  restriction pseudofunctor + prove `IsStack` for the Zariski topology) is a large
  multi-file build.

### Verdict + cost (directive part 4)

**All three are NEEDS_MATHLIB_GAP_FILL and all are the SAME missing object.** This is a
genuinely LARGE multi-iter swath, NOT a bounded iter-217-style `mathlib-build`:

- The iter-217 H1 (pushforward adjunction) was bounded because the *sheaf-level* decl
  already existed and was de-sheafified. Here the internal hom is absent at presheaf,
  sheaf, AND general-categorical level — no parallel API to mirror — and it is
  contravariant, so it is not even a "sheafify the presheaf tensor" job.
- Realistic build path if funded — **Decision 1 (sheaf internal-hom of modules)**, rough
  recipe (mirroring the *fixed-ring* `Monoidal/Closed.lean`, NOT mirroring `tensorObj`):
  1. presheaf internal hom `ℋom(M,N)(U) := ModuleCat.of R(U) (M|_U ⟶ N|_U)` via the
     restriction `M|_U` (open-immersion `restrict` exists in-project) + a slice/end
     construction — the genuinely-new, unbounded step; leans on `PresheafOfModules.Hom`
     (`…/ModuleCat/Presheaf.lean`), `ModuleCat.restrictScalars`, the project `M.restrict`;
  2. evaluation `M ⊗ ℋom(M,𝒪) → 𝒪` (counit of the absent adjunction) — new;
  3. sheaf condition for `ℋom(M,N)` when `N` is a sheaf — new;
  4. `dual` of locally-trivial is locally-trivial + `eval` is a local iso ⇒ global iso —
     these DOWNSTREAM steps ARE available now (`tensorObj_restrict_iso` CLOSED,
     `tensorObj_unit_iso`, `restrictIsoUnitOfLE`, mirror `tensorObj_isLocallyTrivial`).
  Estimate: steps 1–3 are several hundred LOC across multiple iters; comparable to or
  larger than the abandoned d.2 stalk-⊗ block. **Not** a one-to-few-iter build.
- Decision 3 (connect to `Pseudofunctor.IsStack`) is the most principled/reusable route if
  a heavy infrastructure block is funded, but is the largest of the three.

**Bottom line for the planner**: do not schedule the dual as a bounded objective. Either
(a) commit to a dedicated multi-iter infrastructure block (Decision 1 is the smaller of the
constructive routes; Decision 3 the most principled), or (b) escalate to USER for a
strategic re-route that does not need the abstract tensor-inverse object (e.g. the
divisor-class `Pic⁰` route noted in project memory). The iter-218 INCOMPLETE gate (do NOT
push a `dual`-shaped helper-sorry) stands.

## Persistent file
- `analogies/ts219dual.md` — design-rationale captured for future iters.

Overall verdict: NEEDS_MATHLIB_GAP_FILL on all three faces — the inverse object requires a
large multi-iter build (sheaf internal-hom of modules, or connecting `SheafOfModules` to
the new `Pseudofunctor.IsStack` descent framework), not a bounded iter-217-style mirror;
recommend a funded infra block or USER strategic re-route rather than a bounded objective.
