# Analogy: instance-agnostic idiom to cancel `μ.hom ≫ μ.inv` across a `LocalizedMonoidal`↔`X.Modules` comp boundary

## Mode
api-alignment

## Slug
snap-localized-comp-cancel

## Iteration
013

## Question
Canonical instance-agnostic Mathlib idiom to cancel an iso pair `e.hom ≫ e.inv` (`Iso.hom_inv_id_assoc`)
when the two factors straddle a `CategoryStruct.comp` **instance boundary** — one comp from
`Localization.Monoidal` (`LocalizedMonoidal L W ε`), the adjacent comp from the project's `X.Modules`
synonym — the two comps being **defeq but not syntactic**, so `Category.assoc` makes no progress and the
adjacent `μ.hom ≫ μ.inv` is never exposed. Is the right move a `show`/`change` instance-pin, a dedicated
`Localization.Monoidal` cancel lemma, or a reformulation avoiding the boundary?

## Project artifact(s)
- `Picard/SectionGradedRing.lean:1908` `tensorObjAssoc_eq_localizedAssociator_hK_rhs` (sorry ~1960).
- `Picard/SectionGradedRing.lean:1885` `_hK_lhs` (sorry ~1903).
- `:1462` `tensorObjLocalizedIso`, `:1847` `assocCommonForm`, `:1800` `sheafification_whiskerLeft_unit_eq_mu'`.

## Root cause (verified empirically on the iter-013 cold LSP)
`modulesLocalizedMonoidal X` (`:1450`) is `noncomputable abbrev = LocalizedMonoidal sheafification (Wsheaf X) ε`.
In Mathlib (`Mathlib/CategoryTheory/Localization/Monoidal/Basic.lean:86`) `LocalizedMonoidal L W ε := D`
(type synonym for the localization target `D`) and `instance : Category (LocalizedMonoidal …) :=
inferInstanceAs (Category D)` (`:94`). Here `D` = `SheafOfModules`-codomain of sheafification, which is
**defeq-but-not-syntactic** to `X.Modules` (the latter carries its own `instCategory`). So the localized comp
is `@CategoryStruct.comp (LocalizedMonoidal …) (inferInstanceAs …)` while the `X.Modules` comp is
`@CategoryStruct.comp X.Modules instCategory` — distinct instance *terms*, defeq only.

The keystone `sheafification_whiskerLeft_unit_eq_mu'` (RHS `μ.inv ≫ (P◁η^#) ≫ μ.hom`, all **localized**
comps) is `erw`'d INTO a term whose surrounding comp is `X.Modules` (from `tensorObjAssoc` + `sheafification.map`
+ the `μ.inv` carried by `tensorObjLocalizedIso`). That single splice creates the boundary. Two stacked
mismatches at the adjacent pair: (i) comp-instance; (ii) μ second-arg object `B.tensorObj C` vs
`sheafification.obj(B♭⊗C♭)` (the canonical keystone's `'`-pinning produced the latter, not the former).

Verified DEAD on the real isolated goal (cold build): `rw [Category.assoc]` ("pattern `(?f≫?g)≫?h` not found"
— the `conv` error prints `@CategoryStruct.comp X.Modules instCategory … ((localized-comp) …) (…)`, proving the
two instances differ), `simp only [Category.assoc]` (no progress), `dsimp only []` (no progress),
`conv_lhs => rw [Category.assoc]` (no progress), targeted `show …inv ≫ _ = _` (shape-fails),
`rw [show (obj (B.tensorObj C)) = obj (sheafification.obj …) from rfl]` (motive-not-type-correct).
HAZARD CONFIRMED: an **unshielded** second `erw [Category.assoc]` whnf-unfolds the leading `μ.inv` into
`Functor.curry.mapIso (Localization.fac …)` (the isDefEq blow-up the directive feared from `simp [Monoidal.μ]`).

## Decisions identified

### Decision: which cancel idiom — `show`/`change` pin vs dedicated lemma vs `erw`-up-to-defeq
- **Mathlib idiom**: Mathlib NEVER creates this boundary. In `Basic.lean` every coherence (`pentagon`,
  `triangle`, `associator_naturality`, `:329/412/286`) is proven **entirely inside** `LocalizedMonoidal`,
  whose `Category` is `inferInstanceAs (Category D)` (`:94`), so every `≫` is one instance and μ-pairs cancel
  with plain `simp`/`Iso.inv_hom_id_assoc` (e.g. `pentagon` `:361`, `:367`). There is **no** Mathlib lemma that
  cancels `μ.hom ≫ μ.inv` across a synonym↔base comp boundary, because Mathlib has no such boundary.
- **Project's path**: mixes `X.Modules` and `modulesLocalizedMonoidal` comps in one equation
  (`tensorObjLocalizedIso`/`assocCommonForm`/the keystone splice). Divergent-with-cost: the boundary must be
  crossed by hand, and this exact cost recurs at the 5 gated coherences.
- **Validated tactical idiom (the answer)** — `erw` (NOT `show`/`change`, NOT a new lemma):
  ```lean
  erw [Category.assoc]                        -- cross boundary ONCE: pull leading μ.inv out (clean)
  refine congrArg (fun t => _ ≫ t) ?_         -- peel the common leading μ.inv (SHIELD, mandatory)
  erw [Category.assoc, Iso.hom_inv_id_assoc]  -- reassoc across boundary + cancel μ.hom ≫ μ.inv
  ```
  Closes the cancel with zero errors on the real `hK_rhs` goal, leaving EXACTLY the directive's residual
  `(A♭◁η^#) ≫ (c_A⊗c_{B⊗C}) ≫ A◁(μ_{B,C}.inv ≫ (c_B⊗c_C)) = (A♭◁μ_{B,C}.inv) ≫ (c_A⊗(c_B⊗c_C))`
  (then `μ_natural_right` + counit triangle `L'η ≫ c = 𝟙`).
  Why it works: `erw` matches `(?f≫?g)≫?h` / `Iso.hom_inv_id_assoc` **up to reducible defeq**, so it
  (a) unifies the two comp instances and (b) absorbs the μ object-arg defeq — both in one shot. The
  `congrArg` peel (the proof's own idiom, already used at `:1919-1920`) removes the leading `μ.inv` from
  scope so the second `erw [Category.assoc]` cannot whnf-unfold it.
- **Gap**: divergent-with-cost.
- **Verdict**: PROCEED (tactical) — the `erw`+peel recipe is the validated unblock. The prover's leading
  candidate (`show`/`change` both μ's to one literal localized-comp form) is REFUTED: a full-goal `show` is
  impractical and a targeted `show` shape-fails; `change` forces a giant term and risks the same μ whnf.
  No dedicated `Localization.Monoidal` cancel lemma is needed.

### Decision (strategic, flagged not forced): keep the bridge in ONE category (option c)
- The boundary is self-inflicted; Mathlib-aligned design keeps the whole associator bridge inside
  `modulesLocalizedMonoidal X` (one comp instance throughout), matching how Mathlib proves its coherences.
  That would let plain `simp [Category.assoc, Iso.hom_inv_id_assoc]` close all 5 gated coherences with no
  `erw`. But it is a refactor of `tensorObjLocalizedIso`/`assocCommonForm`/`tensorObjAssoc` typing.
- **Verdict**: DIVERGE_INTENTIONALLY for now (the `erw` recipe is cheaper this iter); revisit if the `erw`
  cost compounds painfully across the 5 coherences.

## Recommendation
Adopt the `erw [Category.assoc]; refine congrArg (fun t => _ ≫ t) ?_; erw [Category.assoc,
Iso.hom_inv_id_assoc]` cancel as the blueprint route for `lem:tensorObjAssoc_hK_rhs` and the iter-014 prover
recipe. The three load-bearing facts the blueprint prose must encode: **`erw` (up-to-defeq) is what crosses
the defeq comp-instance boundary** (every `rw`/`simp`/`change`/`dsimp` variant is verified-dead); **the
`congrArg` leading-`μ.inv` peel is mandatory** to avoid the μ→`Localization.fac` whnf explosion; **`erw`
also reconciles the μ object-arg defeq** so no object-alignment rewrite is needed. For `hK_lhs`, apply the
same cancel after `associator_naturality` + `associator_hom_app` expose its μ-pairs. Longer term, consider
collapsing the synonym boundary (keep the bridge inside `modulesLocalizedMonoidal X`) to match Mathlib and
retire the `erw` gymnastics across the 5 coherences.
