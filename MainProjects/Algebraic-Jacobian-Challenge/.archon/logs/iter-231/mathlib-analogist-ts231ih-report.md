# Mathlib Analogist Report

## Mode
api-alignment

## Slug
ts231ih

## Iteration
231

## Question
For an open immersion `j : U ↪ X`, does Mathlib already have (or have a directly reusable
shadow of) the natural iso `j_*(ℋom_{𝒪_U}(L, 𝒪_U)) ≅ ℋom_{𝒪_X}(j_*L, 𝒪_X)` of
presheaves-of-modules? Is the project building a parallel API it should align to? And is
the planner's "both sides are literally equal on `V ⊆ U`" claim plausible, or an
underestimate of a real coherence obstruction?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| A. Mathlib internal hom / `MonoidalClosed` for `PresheafOfModules` to align to | NEEDS_MATHLIB_GAP_FILL | informational |
| B. Mathlib `f_*`/`f^*`-commutes-with-internal-hom lemma (`dual_restrict_iso` itself) | NEEDS_MATHLIB_GAP_FILL | informational |
| C. Planner's "literally equal on `V ⊆ U`" feasibility claim | UNDERESTIMATE (claim is wrong) | high |

## Informational

**Decision A — no module-valued internal hom upstream.** `loogle MonoidalClosed
(PresheafOfModules _)` → 0 hits. Searches return only the hom-*type* `PresheafOfModules.Hom`,
the unit `PresheafOfModules.unit`, and `unitHomEquiv` (all in
`Mathlib.Algebra.Category.ModuleCat.Presheaf`) — never an internal-hom *object* or a
`Closed`/`MonoidalClosed` instance. The nearest shape, `CategoryTheory.Sites.SheafHom`
(`presheafHom`/`sheafHom`, `Mathlib.CategoryTheory.Sites.SheafHom`), is **Type-valued**
and its `## TODO` still asks to make it a bifunctor — no module refinement, no
pullback-compat. The project's `InternalHom.internalHom`
(`TensorObjSubstrate.lean:1353`) is the correct module-valued refinement of that idiom and
is genuine gap-fill, **not** an avoidable parallel API. There is nothing upstream to
align to, so there is no fragmentation cost to charge.

**Decision B — no compat lemma, but real scaffolding to build on.** No
`pushforward`/`pullback`-commutes-with-internal-hom lemma exists (there is no internal hom
to state it about). A from-scratch build is NOT from zero — Mathlib supplies:
- `PresheafOfModules.pushforward` with full pseudofunctor coherence (`pushforwardId`,
  `pushforwardComp`, `pushforward_assoc`, `pushforwardCompToPresheaf`,
  `pushforward_obj_obj = restrictScalars (φ.app X) ∘ pushforward₀Obj …`),
  `Mathlib.Algebra.Category.ModuleCat.Presheaf.Pushforward`.
- `SheafOfModules.PullbackConstruction.adjunction` — sheaf-level `f^* ⊣ f_*`,
  `Mathlib.Algebra.Category.ModuleCat.Sheaf.PullbackContinuous`.
- `ModuleCat.restrictScalars_isEquivalence_of_ringEquiv`
  (`Mathlib.Algebra.Category.ModuleCat.ChangeOfRings`) — the decisive single-ring shadow:
  for an open immersion `β = j.appIso` is a sectionwise ring ISO, so `restrictScalars β`
  is an EQUIVALENCE (invertible value-cat transport), which is the project's
  `restrictScalarsEquivalenceOfRingEquiv`.
- `TopologicalSpace.Opens.overEquivalence U : Over U ≌ Opens ↥U`
  (`Mathlib.Topology.Sheaves.Over`) — the per-open slice reindexing (its `## TODO` =
  "continuity ⇒ sheaf-equivalence", the iter-229 finding).

**Decision C — the planner's "literally equal" claim is an underestimate (high).**
The iter-230 binding probe (`lean_goal`/`change`, live) already established that the
residual `(pushforward β).obj (dual M) ≅ dual ((pushforward β).obj M)` is a genuine
**iso, not `rfl`**, for two irreducible reasons: (1) the LHS value at `V` is computed over
`Over_U (jV)` and the RHS over `Over_X V` — equivalent, not equal; (2) the LHS module is
over `𝒪_U(jV)`, the RHS over `𝒪_X(V)` — ring-iso, not equal, and the per-`V` action
`internalHomObjModule` is exactly what a value-category-FIXED equivalence
(`overSliceSheafEquiv`) cannot transport. This is the standard
`f^* ℋom(A,B) ≅ ℋom(f^*A, f^*B)` for an open immersion (iso/flat base change) — a real
natural iso, NOT near-definitional. Thinness of `Opens` does **not** trivialise it here
(unlike the Type-valued sheaf root) because the slice presheaves carry the `𝒪(V)`-module
structure subsingleton-elimination can't reach. The ~150–300 LOC estimate stands.

*Mitigating lever (it is the favorable case):* the dual's target is `𝟙_ = 𝒪`, and
`𝒪_X`/`𝒪_U` agree on opens `≤ U`, so the codomain mismatch collapses; and because `β` is a
ring iso, `restrictScalars β` is an equivalence — so the iso *exists cleanly* and is
iso-base-change, not a hard descent. It still must be assembled (per-`V` slice equiv +
ring-iso `restrictScalars` + naturality in `V`); it is not free.

## Persistent file
- `analogies/ts231ih.md` — design-rationale and citations captured for future iters.

Overall verdict: Mathlib has neither a `PresheafOfModules` internal hom nor a
pushforward-commutes-with-internal-hom lemma (genuine gap-fill, not a parallel API to
align to), and the planner's "literally equal on `V ⊆ U`" claim is wrong — the residual is
a real (if favorable, iso-base-change) natural iso whose honest cost is the 150–300 LOC
slice-comparison build, confirming the iter-230 escalation to the USER's divisor/`Pic⁰` fork.
