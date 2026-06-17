# Mode: api-alignment

## Slug
ts224dual

## Iteration
224

## One-line question
Is the project hand-rolling the internal-hom **evaluation morphism** `internalHomEval :
M ⊗_R M^∨ ⟶ 𝟙_` on `PresheafOfModules R` in a shape that forces a `whnf` of the monoidal
unit `𝟙_` during naturality — and does Mathlib provide either (a) a ready evaluation/counit
to reuse, or (b) a `Hom`-builder / unit-targeting idiom whose naturality is dischargeable
**without** `kabstract`-over-`𝟙_`? Decide align-vs-deviate and give a concrete bounded recipe.

## Context — why you are being called (escalation, not a routine sanity check)
This is the **pre-committed STUCK escalation** for a funded multi-iter build. A single
naturality field has now resisted closure across iters 221→223. The obstacle was
re-characterized authoritatively this iter (≈12 `lake env lean` bisection compiles): it is a
**goal-wide `whnf` toxicity**, not a one-lemma instantiation. We need a Mathlib-idiom verdict
on the *shape* of the construction before any further prover dispatch. Treat this as a
"design-shape suspected" reactive trigger.

## Project artifact(s) — read these
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`:
  - `internalHomEval` (≈L1449–1500) — the morphism `M ⊗_R M^∨ ⟶ 𝟙_` with `app X :=
    internalHomEvalApp M X`; **naturality field is a typed `sorry`** (the target).
  - `internalHomEvalApp` (per-object eval, axiom-clean) + helpers `evalLin`,
    `evalLin_add/_smul`, `internalHomEvalApp_tmul`, `restr_map_homMk`, `dual_map_app_terminal`,
    private `hom_app_heq`.
  - `dual` (≈L1359) := `InternalHom.internalHom M (𝟙_)`; `InternalHom.internalHom` (≈L1306)
    — the project's hand-built presheaf internal hom (slice/end construction), assembled
    iter-219→220.
  - `restr U M := pushforward₀ (Over.forget U)`; uses `PresheafOfModules.pushforward`.
- `task_results/AlgebraicJacobian_Picard_TensorObjSubstrate.lean.md` (iter-223 prover handoff)
  — the authoritative bomb diagnosis + the six-step reduction + the candidate directions.
- `analogies/ts219dual.md` — the PRIOR api-alignment consult (iter-219) on the inverse OBJECT.
  **Do NOT repeat that analysis.** That round answered "Mathlib has no `MonoidalClosed
  (PresheafOfModules R)` / no varying-ring internal hom — build it by hand." THIS round is
  narrower and downstream: the object is already built by hand; the question is the
  **evaluation morphism's proof-shape** and whether a better Mathlib-aligned shape avoids the
  whnf bomb. If your findings revise the ts219dual object-level verdict, say so explicitly.
- `analogies/ocofp-sheaf-internalhom.md` — earlier sheaf internal-hom notes (context).

## The obstacle, precisely (from the iter-223 authoritative bisection)
The naturality goal, after `intro X Y f; refine ModuleCat.MonoidalCategory.tensor_ext (fun s φ
=> ?_)`, is:
```
((tensorObj M (dual M)).map f ≫ (restrictScalars _).map (internalHomEvalApp M Y)).hom (s ⊗ₜ φ)
  = (internalHomEvalApp M X ≫ (𝟙_).map f).hom (s ⊗ₜ φ)
```
**Every** goal-rewriting tactic (`rw`/`erw`/`simp`/`change`) bombs with `(deterministic)
timeout at whnf, 200000 heartbeats` on its FIRST rewrite — confirmed by separate full compiles
of: `erw [ModuleCat.hom_comp, …, LinearMap.comp_apply]`; `rw
[PresheafOfModules.Monoidal.tensorUnit_map]`; `rw [show (𝟙_ …) = PresheafOfModules.unit …
from rfl]`; `simp only [tensorUnit_map]`; and all of the above under `attribute [local
irreducible] internalHomEvalApp dual`. Root cause: the goal's codomain is the
`PresheafOfModules` monoidal unit `𝟙_`, and the goal is saturated with `dual M = internalHom M
𝟙_`; `kabstract` runs `isDefEq` on these subterms, forcing a `whnf` of
`PresheafOfModules.Monoidal.tensorUnit` machinery whose normal form is enormous (~exponential,
NOT budget-bound — so `maxHeartbeats` is FORBIDDEN and would only mask a fragile decl).
`local irreducible` on project defs cannot shield it because the toxic `whnf` is in Mathlib's
`𝟙_` machinery.

The underlying mathematics is COMPLETE and verified in pieces (six-step reduction in the
handoff). The only gap is a `whnf`-free Lean technique / a better construction shape.

## Specific questions (answer each)

1. **Reuse an existing evaluation/counit.** Does Mathlib expose, for `PresheafOfModules R`
   (or a category the project can transport along), a ready **evaluation natural
   transformation** `M ⊗ ihom(M, 1) ⟶ 1` (or `M ⊗ M^∨ ⟶ 1`) we should be reusing instead of
   hand-assembling `internalHomEval`? Check: `MonoidalClosed.ev` / `ihom.ev` /
   `MonoidalClosed.uncurry (𝟙 _)`; whether any `MonoidalClosed`/`Closed` instance exists or is
   transportable to `PresheafOfModules R`; the `ModuleCat R` fixed-ring `MonoidalClosed`
   (`Mathlib/Algebra/Category/ModuleCat/Monoidal/Closed.lean`) and whether its `ev` shape ports
   objectwise. If a reusable counit exists, naturality is free — that dominates everything below.

2. **Unit-targeting idiom (the prover's own lead).** The prover noted: build the morphism into
   `PresheafOfModules.unit` and compose with a `tensorUnit ≅ unit` iso so the toxic `𝟙_` never
   appears in the proof goal. Is targeting `PresheafOfModules.unit` (the explicit unit) rather
   than the monoidal `𝟙_` the **Mathlib-aligned** shape here? Does Mathlib provide the iso
   `𝟙_ (PresheafOfModules R) ≅ PresheafOfModules.unit R` (or is it `rfl`/defeq in a way that
   does NOT help, since the bomb is in `tensorUnit`'s `.map`)? Is there precedent (anywhere in
   Mathlib) for proving a morphism INTO a monoidal unit by factoring through an explicit
   concrete object to dodge unit-`whnf`?

3. **`Hom`-builder with pre-reduced naturality.** Is there a `PresheafOfModules.Hom`
   constructor / `ext`-style lemma whose naturality obligation is stated in **already-reduced**
   per-section form (so `kabstract` over the unit is never invoked)? Candidates to check:
   `PresheafOfModules.homMk`, any `Hom.mk'`/builder taking an `app`-family + a pointwise
   `naturality_apply`-shaped hypothesis; `PresheafOfModules.Hom.ext` + a section-wise route.
   Compare to how Mathlib itself builds maps INTO `tensorUnit`/`𝟙_` for `PresheafOfModules`
   or the analogous `SheafOfModules`.

4. **Reducible-transparency rewriting precedent.** Is there Mathlib precedent for defeating a
   `kabstract`/`isDefEq`→`whnf` blowup over a monoidal unit by forcing reducible transparency —
   `rw (config := { transparency := .reducible })`, `conv`-localized rewriting,
   `Lean.MVarId.rewrite` at `.reducible`, or `with_reducible`? Cite any Mathlib proof that uses
   this specifically to avoid a unit/`tensorObj` `whnf` bomb. (Tactical, but if there's a
   blessed idiom it may be the cheapest fix.)

5. **Verdict + bounded recipe + cost.** ALIGN-WITH-MATHLIB (reuse a counit / re-shape the
   construction) vs DEVIATE (keep the hand-rolled morphism, apply a `whnf`-free tactic). Give:
   the concrete bounded recipe (named Mathlib decls, verified to exist — use loogle/leansearch
   and report what you actually confirmed vs conjectured), the rough LOC/iter cost, and — if
   the honest answer is that NO whnf-free close exists at the current object shape — say so
   plainly, because the held fallback is to **revert `internalHomEval` to ABSENT** (project
   sorry 81→80) and not carry a stubbed morphism.

## Out of scope
- Re-litigating the object-level "build the dual by hand" decision (ts219dual settled it) unless
  your evidence overturns it.
- The inverse-OBJECT `exists_tensorObj_inverse` sorry (sub-step 5) — not this round.
- The assoc re-route / whiskering deletion; the `Sheaf.val`→`ObjectProperty.obj` deprecation.
- Any RR-route / strategy-fork question (governed by a standing USER pause).

## Deliverable
Write `analogies/ts224dual.md` (persistent rationale) + the `task_results/` report. Lead with the
align-vs-deviate verdict and the single most promising concrete recipe, so the planner can either
fold it into an iter-225 prover directive or trigger the revert-to-absent fallback.
