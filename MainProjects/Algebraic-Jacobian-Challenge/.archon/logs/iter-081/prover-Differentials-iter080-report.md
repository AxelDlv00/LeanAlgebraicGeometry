# AlgebraicJacobian/Differentials.lean — iter-080

**Lane 2 goal:** Close `cotangentExactSeq_structure` (L460) via Route A
(per-section extensionality), introducing `SheafOfModules.exact_iff_stalkwise`
as the second permitted gap-fill (sorry body authorised).  Net target: 5 → 5
(1-for-1 sorry shift inside `_structure` body to gap-fill body).

**Result:** PARTIAL — Route A structurally advances the `h_zero` proof but
hits an unresolved pattern-matching obstacle inside the `apply
postcomp_injective + ext U b + simp` chain when the descent is over an
inline `d_target` structure.  Per the iter-080 plan's *conditional clause*
("if Route A fails and `_structure` cannot close, do NOT introduce
`exact_iff_stalkwise` as a free-floating sorry — that would be a regression"),
the body is left as a single absorbed `sorry`.  File compiles cleanly
with **5 sorries** (no regression; hard cap of 5 holds).

## Concrete changes

Only the body of `cotangentExactSeq_structure` was modified; all preserved
declarations from iter-079 (`SheafOfModules.epi_of_epi_presheaf` gap-fill at
L437–443, the `set_option maxHeartbeats 16000000 in` annotations on
`cotangentExactSeqAlpha` and `cotangentExactSeqBeta`) are untouched.  The
disabled iter-076 chain (block at L489+) is preserved verbatim in the
original file as a comment.

The body was rewritten to document the iter-080 partial advance and the
precise iter-081 unblock recipe.  Specifically:

```lean
-- Iter-080 (Route A, partial advance + documentation of the residual blocker).
-- ...
-- Per the iter-080 conditional clause ("if Route A fails and `_structure`
-- cannot close, do NOT introduce `exact_iff_stalkwise` as a free-floating
-- sorry — that would be a regression"), this body is left as a single
-- absorbed `sorry` (no regression: file remains at 5 sorries).
sorry
```

The `_structure`-body sorry is the same absorbed conjunction
(`h_zero ∧ h_exact ∧ h_epi`) that iter-079 left in place.  No new sorries
were introduced.

## Attempt log

### `cotangentExactSeq_structure` (L460) — `h_zero` (composition vanishes)

#### Route A — per-section extensionality via `SheafOfModules.hom_ext` + `show`

- **Approach:**
  ```lean
  apply ((Scheme.Modules.pullbackPushforwardAdjunction f).homEquiv _ _).injective
  rw [Adjunction.homAddEquiv_zero, Adjunction.homEquiv_naturality_right]
  unfold cotangentExactSeqAlpha
  simp only [Equiv.apply_symm_apply]
  apply SheafOfModules.hom_ext
  show ((isUniversal' φ_g').desc _)
    ≫ ((PresheafOfModules.pushforward _).map (cotangentExactSeqBeta f g).val) = 0
  apply (isUniversal' φ_g').postcomp_injective
  ext U b
  simp only [postcomp_d_apply, comp_app, pushforward_map_app_apply,
             zero_app, hom_zero, zero_apply]
  ```
- **Result:** STRUCTURAL ADVANCE — Route A's `apply SheafOfModules.hom_ext`
  followed by an explicit `show` successfully replaces the failing iter-076
  `simp only [SheafOfModules.comp_val, SheafOfModules.pushforward_map_val]`
  step.  After `apply postcomp_injective + ext U b`, the goal reduces to
  a ModuleCat-level equation over the universal derivation `(derivation' φ_g').d b`.
- **Key observation:** the explicit `show` form
  `((isUniversal' φ_g').desc _) ≫ ((PresheafOfModules.pushforward _).map β.val) = 0`
  bypasses the elaborator's eager reduction of the SheafOfModules-level
  composition `( ... ≫ ...).val` to its raw `{ app := _, naturality := _ }`
  form.  This is the iter-078-compatible analogue of the iter-076 chain's
  failing simp step.

#### Residual blocker: inline-`d_target` pattern matching

After `ext U b` + the simp chain, the LHS is:
```
(ModuleCat.Hom.hom ((desc d_target).app U ≫ ((pushforward _).map β.val).app U))
   ((derivation' φ_g').d b)
```
where `d_target` is the inline `{ d := fun {U} => AddMonoidHom.mk' ..., d_mul := ⋯,
d_map := ⋯, d_app := ⋯ }` structure built inside `cotangentExactSeqAlpha`'s body.
We want to apply
```
hα_fac : ∀ d_t b, ((isUniversal' φ_g').desc d_t).app U .hom ((derivation' φ_g').d b)
  = d_t.d b
```
to unfold the inner term to `d_target.d b`, then `dsimp` through the
`AddMonoidHom.mk'` wrapper to expose `(derivation' φ_fg').d ((f.c.app U).hom b)`,
then unfold `cotangentExactSeqBeta` and use the symmetric `hβ_fac` to reduce
further to `(derivation' φ_2').d ((f.c.app U).hom b)`, which vanishes by
`Derivation'.d_app` after the adjunction-coherence `f.c = adj_f.unit ≫
pushforward.map φ_2'` (the canonical `hcoh_app` identity).

#### Tactics tried (all fail)

| Tactic | Failure mode |
|---|---|
| `simp only [ModuleCat.hom_comp, LinearMap.comp_apply]` after the main simp | "made no progress" (lemmas detected as unused) |
| `rw [ModuleCat.hom_comp]` directly | "Did not find an occurrence of the pattern `ModuleCat.Hom.hom (?f ≫ ?g)`" |
| `change ... = 0` (with explicit `.hom.comp ... .hom`) | succeeds, splits LHS |
| Then `rw [LinearMap.comp_apply]` | succeeds, distributes the application |
| Then `rw [hα_fac _ b]` | "Did not find an occurrence of the pattern `(ModuleCat.Hom.hom (((isUniversal' φ_g').desc ?m).app U)) ((derivation' φ_g').d b)`" |
| `erw [hα_fac _ b]` (after the same setup) | (deterministic) timeout at `whnf`, 200000 heartbeats |
| `simp only [hα_fac]` | "made no progress" |
| `rw [show ... = ... from hα_fac _ b]` | "Did not find an occurrence of the pattern" (same as plain `rw`) |
| `simp` (after `apply postcomp_injective`, no `ext`) | "made no progress" beyond the `(f ≫ g).base → f.base ≫ g.base` cosmetic |
| `simp [Universal.fac]` (after `apply postcomp_injective`, no `ext`) | reports `Universal.fac` as unused; goal unchanged |
| `simp` after `ext U b` + the standard simp set | makes partial progress but does not close; `ModuleCat.hom_comp` and `LinearMap.zero_apply` flagged as unused |
| `cat_disch` from the top of the body | "tactic 'aesop' failed, failed to prove the goal after exhaustive search" |
| `exact?` from the top of the body | "could not close the goal" |

#### Diagnosis

The fundamental issue is **metavariable-elaboration mismatch** when matching
`hα_fac _ b`'s pattern against the inline `d_target` term.  The pattern is
`(ModuleCat.Hom.hom (((isUniversal' φ_g').desc ?d_t).app U)) ((derivation' φ_g').d b)`
where `?d_t` is the metavariable to unify against the inline structure.
Lean's unifier appears unable to unify `?d_t` against the let-bound inline
Derivation' structure that emerged from `unfold cotangentExactSeqAlpha`;
the `erw` timeout at `whnf` supports this — the unifier is trying to compute
the type-class instance for the inline structure against the abstract
metavariable's class, which loops or balloons.

The `change`-based split, which uses Lean's transparency configuration
rather than the simp/rw matcher, succeeds because it directly equates two
defeq terms without unifying.  But the subsequent `rw [hα_fac _ b]` falls
back to the unifier, which then fails.

### Iter-081 unblock recipes

Three independent routes are open:

#### (a) Bind `d_target` via `set` BEFORE `apply postcomp_injective`

The pattern-matching failure is over an *inline* structure.  If we bind it
to a named handle via `set d_target := { d := fun {U} ↦ ... } with hd_target`
before invoking the universal property, the inner expression becomes
`(ModuleCat.Hom.hom (((isUniversal' φ_g').desc d_target).app U)) ((derivation' φ_g').d b)`
with `d_target` a named local hypothesis.  The pattern of `hα_fac d_target b`
would then unify trivially.

Challenge: the inline structure is buried inside `cotangentExactSeqAlpha`'s
body after `unfold`.  The `set` needs to be placed *after* the unfold + simp
but the elaborator needs to recognise the structure to bind to it.  May
require `with hd_target` and manual unfolding of `cotangentExactSeqAlpha` to
expose the structure explicitly.

#### (b) Refactor `cotangentExactSeqAlpha` to name `d_target`

`cotangentExactSeqAlpha` is a protected declaration.  Refactoring its body
to expose `d_target` as a top-level `noncomputable def` (or as a named `let`
that survives the unfold) requires user authorisation.  This is the
cleanest fix but cannot be done by the prover this iteration.

#### (c) Introduce `Derivation.postcomp_comp` and skip `ext U b`

The lemma
```
Derivation.postcomp_comp : d.postcomp (f ≫ g) = (d.postcomp f).postcomp g
```
is missing from Mathlib (verified via `grep` in
`Mathlib/Algebra/Category/ModuleCat/Differentials/Presheaf.lean`).  Adding
it as a one-line gap-fill (proof: `Derivation.ext fun U b ↦ by simp
[postcomp_d_apply, comp_app, hom_comp, LinearMap.comp_apply]`) would let us
collapse
```
(derivation' φ_g').postcomp (desc d_target ≫ (pushforward _).map β.val)
  = ((derivation' φ_g').postcomp (desc d_target)).postcomp ((pushforward _).map β.val)
  = d_target.postcomp ((pushforward _).map β.val)   -- by Universal.fac
```
directly, sidestepping `ext U b` entirely.  The remaining obligation
`d_target.postcomp ((pushforward _).map β.val) = 0` can then be handled by
Derivation extensionality with a much shorter chain, since `d_target.d` is
the *outer* identifier we can `rw` against.

This route adds one Mathlib-shape helper (`postcomp_comp`), within the
"two project-local helpers" budget the iter-080 plan permits for this lane.
But it requires further plan-agent authorisation since the iter-080 plan
specifically named `exact_iff_stalkwise` as the second helper.

### `h_exact` and `h_epi` — not attempted standalone

Per the iter-080 conditional clause, since `h_zero` did not close, the
`exact_iff_stalkwise` gap-fill was NOT introduced (introducing it without
closing `_structure` would push the file to 6 sorries, a regression).
Similarly, the `h_epi` chain was not built out: the `epi_of_epi_presheaf`
gap-fill from iter-079 remains in place at L437–443 but is not yet wired
into `_structure`.

Both branches can be attempted in iter-081 once one of the (a)/(b)/(c)
unblock recipes above lands `h_zero`.

## Sorries

| Line | Decl | Status |
|---|---|---|
| 113 | `relativeDifferentialsPresheaf_isSheaf` | unchanged (out of scope iter-080) |
| 460 | `cotangentExactSeq_structure` | unchanged absorbed `sorry`; lane target documented inline |
| 764 | `smooth_iff_locally_free_omega` | unchanged (out of scope iter-080) |
| 780 | `cotangent_at_section` | unchanged (out of scope iter-080) |
| 924 | `serre_duality_genus` | unchanged (out of scope iter-080) |

**File total: 5 sorries** (was 5; no regression).

## Mathlib leverage confirmed iter-080

- `SheafOfModules.hom_ext : f.val = g.val → f = g` (Mathlib, `Algebra/Category/ModuleCat/Sheaf.lean` L54) — used to drop SheafOfModules → PresheafOfModules.
- `AlgebraicGeometry.Scheme.Modules.hom_ext` (Mathlib, `AlgebraicGeometry/Modules/Sheaf.lean` L121) — per-section variant; tried but Route A uses the unbroken `SheafOfModules.hom_ext`.
- `PresheafOfModules.DifferentialsConstruction.isUniversal'.postcomp_injective` — reduces a morphism equality to a Derivation equality.
- `PresheafOfModules.Derivation.Universal.fac` (auto `@[simp]`) — `d.postcomp (desc d_t) = d_t`; fires on `desc`-typed inputs.
- `PresheafOfModules.Derivation.postcomp_d_apply` (auto `@[simps! d_apply]`) — `(d.postcomp f).d b = (f.app _).hom (d.d b)`.
- `PresheafOfModules.comp_app`, `PresheafOfModules.zero_app`, `PresheafOfModules.pushforward_map_app_apply` — natural-transformation distribution simps.
- `ModuleCat.hom_comp`, `ModuleCat.hom_zero`, `LinearMap.comp_apply`, `LinearMap.zero_apply` — standard ModuleCat reductions (FAIL TO FIRE in iter-078 elaboration shape on this position; see attempt log).

## Blueprint marker

- `lem:cotangent_exact_structure` (`AlgebraicGeometry.Scheme.cotangentExactSeq_structure`):
  remains unproved this iteration.  Marker `\leanok` should remain
  **withheld** on the proof block until iter-081 closes it.  The statement
  block already has `\leanok`.
- `lem:sheafOfModules_exact_iff_stalkwise`: NOT introduced this iteration.
  The blueprint declaration is in place but the Lean side does not yet
  exist; iter-081's path forward determines whether this helper is needed.
- `lem:sheafOfModules_epi_of_epi_presheaf` (`SheafOfModules.epi_of_epi_presheaf`):
  unchanged from iter-079; `\leanok` already correctly set.

## Suggested iter-081 lane structure

Lane 2.1 (preferred, shortest path): attempt unblock (c) — introduce
`Derivation.postcomp_comp` helper, then close `h_zero` via the
`d_target.postcomp X = 0` route + `Universal.fac`; introduce
`exact_iff_stalkwise` for `h_exact`; chain `epi_of_epi_presheaf` for `h_epi`.

Lane 2.2 (fallback): attempt unblock (a) — bind `d_target` via `set`; if
this works at all, the iter-076 chain proceeds in full.

Lane 2.3 (escalation): if neither (a) nor (c) works, route a refactor-
subagent directive for (b) — refactor `cotangentExactSeqAlpha`'s body to
expose `d_target` as a `noncomputable def`.
