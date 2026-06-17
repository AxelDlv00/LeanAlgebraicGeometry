# Cohomology/FlatBaseChange.lean  (NEW FILE — engine parallel lane, iter-232)

Blueprint: `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` (Stacks 02KH, `i = 0`).
File created from scratch: imports + `namespace AlgebraicGeometry` + the 3 chapter decls.

## ⚠ ACTION NEEDED BY PLANNER (cross-file wiring — outside my write domain)
The new module is NOT yet imported by the aggregator. Add
`import AlgebraicJacobian.Cohomology.FlatBaseChange`
to `AlgebraicJacobian.lean` (alongside the other `Cohomology.*` imports) so the
package build + blueprint `\lean{}` resolution pick it up. I am only permitted to
write my assigned `.lean`, so I did not edit `AlgebraicJacobian.lean`.
(`lake build AlgebraicJacobian.Cohomology.FlatBaseChange` succeeds standalone:
8317 jobs, only the 2 expected sorry warnings.)

## pushforwardBaseChangeMap  (def — `def:pushforward_base_change_map`)
### Attempt 1 — RESOLVED (axiom-clean, no sorry)
- **Approach:** adjoint mate of the unit. The map
  `g^*(f_* F) ⟶ f'_*(g'^* F)` is `((pullbackPushforwardAdjunction g).homEquiv _ _).symm`
  applied to the composite
  `(pushforward f).map (unit_{g'} F) ≫ (pushforwardComp g' f).hom ≫ (pushforwardCongr comm).hom ≫ (pushforwardComp f' g).inv`.
- **Key API (Mathlib `AlgebraicGeometry/Modules/Sheaf.lean`):**
  `Scheme.Modules.pushforward` / `pullback` / `pullbackPushforwardAdjunction` /
  `pushforwardComp` / `pushforwardCongr`. Hypothesis `comm : g' ≫ f = f' ≫ g`
  (= `IsPullback.w`).
- **Verified:** `lean_verify` → axioms `{propext, Classical.choice, Quot.sound}` only.
- **Gotcha:** `pullback` is ambiguous with `Limits.pullback` under `open Limits`;
  qualify as `Scheme.Modules.pullback` in the type signature.

## affineBaseChange_pushforward_iso  (`lem:affine_base_change_pushforward`)
### Attempt 1 — PARTIAL (genuine reduction + typed sorry)
- **Approach:** `rw [Scheme.Modules.Hom.isIso_iff_isIso_app]; intro U` reduces to
  `IsIso (Hom.app (pushforwardBaseChangeMap …) U)` for each `U : S'.Opens`
  (verified live via `lean_multi_attempt`). This is a correct iff-reduction.
- **Result:** PARTIAL — remaining section-level goal needs the affine dictionary
  (see below). `sorry` at the stuck point, with the affine-local strategy + the
  exact closing lemma named in-comment.
- **Blocker (specific, named):** Mathlib lacks (1) "iso local on an affine cover"
  for `SheafOfModules` maps, and (2) the translation of
  `Scheme.Modules.pushforward`/`pullback` of `tilde` modules on `Spec` into
  `ModuleCat.restrictScalars` / base change. The *algebraic heart* IS present:
  `TensorProduct.AlgebraTensorModule.cancelBaseChange`
  (`(R'⊗[R]A)⊗[A]M ≃ R'⊗[R]M`). Full write-up: `informal/affineBaseChange_pushforward_iso.md`.

## flatBaseChange_pushforward_isIso  (`thm:flat_base_change_pushforward`)
### Attempt 1 — DEFERRED (documented sorry, per directive)
- Directive explicitly permits leaving the deep Čech+flatness theorem as `sorry`.
- Body carries the full Stacks-02KH reduction strategy as a comment (reduce to
  affine target `A→B` flat; Čech complex; term-wise base change via the affine
  lemma; exactness of `-⊗_A B` commutes with `H⁰`). Needs Čech-cohomology /
  affine-cover infrastructure for `SheafOfModules` (not in Mathlib).

## Search / tooling log
- Informal agent UNAVAILABLE: only `MOONSHOT_API_KEY` set (base `api.kimi.com/coding/`),
  returns HTTP 401 against the script's `api.moonshot.cn` endpoint. No DEEPSEEK/
  OPENROUTER/OPENAI/GEMINI key. Documented; proceeded without it.
- Confirmed via source grep: NO base-change / Beck-Chevalley / `mateEquiv` and NO
  stalk-iso criterion in `Mathlib/Algebra/Category/ModuleCat/Sheaf/`; NO
  pullback/pushforward in `Modules/Tilde.lean`.

## Summary
- **Sorry count: 0 → 2** (new file; the def is sorry-free and axiom-clean).
- **Closed (sorry-free):** `pushforwardBaseChangeMap` (the primary frontier-ready
  target — fully constructed, axiom-clean).
- **Open:** `affineBaseChange_pushforward_iso` (PARTIAL — real reduction landed,
  sorry at section-iso pending the affine dictionary);
  `flatBaseChange_pushforward_isIso` (deferred per directive, strategy documented).
- **Adjacent sorries attempted beyond assignment:** none exist in-file beyond these
  two; the file is new.

## Why I stopped
**Real progress:** created the file and fully built + verified the canonical
base-change map `pushforwardBaseChangeMap` (axiom-clean, 0 sorry) — the primary
frontier-ready deliverable. **Partial progress** on `affineBaseChange_pushforward_iso`:
landed the genuine `isIso_iff_isIso_app` reduction (live-verified) leaving a typed
`sorry` at the section-iso step. The two remaining sorries are blocked on a specific,
named **Mathlib gap** — the affine Spec/`tilde` dictionary for
`pushforward`/`pullback` + "iso local on an affine cover" for `SheafOfModules` —
NOT on difficulty I could push through this session. The mathematical heart
(`cancelBaseChange`) is identified and exists; wiring it requires the missing
~several-hundred-LOC dictionary (out of scope for an in-file ≤100-LOC helper).
Informal agent could not be consulted (sole key 401s). Gap written to
`informal/affineBaseChange_pushforward_iso.md` for a `mathlib-build` follow-up lane.
