# Session 26 (iter-026) — review summary

## Metadata
- **Session / iter**: session_26 = iter-026.
- **Sorry count**: 2 → 2 (no regression). Both intentional/frozen: superseded relative-form
  `CechAcyclic.lean:110` (`affine`, blueprint-authorized `% NOTE`) + frozen P5b
  `CechHigherDirectImage.lean:679`. The new file `AbsoluteCohomology.lean` has **0 sorries**.
- **Lanes planned 1, ran 1** — `AbsoluteCohomology.lean` (new-file scaffold lane).
- **+10 axiom-clean declarations** (all `{propext, Classical.choice, Quot.sound}`); **0 new sorries**;
  **all 6 PROGRESS objectives landed** in one shot.
- **Build**: `lake env lean AlgebraicJacobian/Cohomology/AbsoluteCohomology.lean` → EXIT 0, file
  diagnostic-clean; every named target `lean_verify`-clean.
  - **CAVEAT (must-fix, see recommendations)**: the file compiles *standalone* but is **NOT imported**
    into `AlgebraicJacobian.lean`, so it is currently orphaned from the umbrella build target.

## The headline: Form-B absolute cohomology scaffold built end-to-end, first lane
The entire `H^p(U, F) := Ext^p_{X.Modules}(jShriekOU U, F)` scaffold (the iter-025 D1 decision)
landed in a single prover lane, no blockers, exactly as the planner's analogist scoped it as a
low-risk reuse lane. The 10 decls:

1. `hasExtModules` (local instance) — `HasExt.{u+1, u, u+1} X.Modules := HasExt.standard _`.
2. `jShriekOU` — the corepresenting object `sheafify(free(yoneda U))` (`def:jshriek_ou`). The `j_!`
   *functor* is absent from Mathlib; only the *object* is needed and it is cheap.
3. `sheafificationHomAddEquiv` — sheafification-adjunction hom-bijection upgraded to `≃+`.
4. `jShriekOU_homEquiv` — corepresentability `(jShriekOU U ⟶ F) ≃+ F(U)` (`lem:jshriek_corepr`).
5. `absoluteCohomology` — `AddCommGrpCat.of (Ext (jShriekOU U) F p)` (`def:absolute_cohomology`).
6. `absoluteCohomologyZeroAddEquiv` — `H⁰(U,F) ≅ Γ(U,F)` additive.
7. `absoluteCohomology_eq_zero_of_injective` — positive-degree injective vanishing.
8–10. `absoluteCohomology_covariant_exact₁/₂/₃` — the three covariant `H^p(U,-)` LES wrappers.

Form B's strategic payoff is confirmed in the Lean: `absoluteCohomology_eq_zero_of_injective` is the
one-liner `Ext.eq_zero_of_injective e` because the injective `I` is the **second** Ext argument — so
the Form-A "restriction-preserves-injectives" obligation is eliminated, not deferred.

## Per-target attempts (detail in milestones.jsonl)
- **`hasExtModules`**: bare `HasExt.standard _` FAILS — `HasExt` is a `Prop` with *three* universe
  params `HasExt.{w,v,u_obj}`; `w` auto-binds to a fresh rigid universe that won't unify with `u+1`.
  Fix: pin the triple `HasExt.{u + 1, u, u + 1}`. Made a `local instance` to dodge the
  `HasSmallLocalizedHom` TC-search timeout (Prop ⇒ no diamond).
- **`sheafificationHomAddEquiv`** (4 attempts): the `map_add'` additivity. `simp only [...]` no-progress;
  `rw [Functor.map_add]` "pattern not found"; `erw [Functor.map_add]; rw [Preadditive.comp_add]`
  "pattern `?f ≫ (?g+?g')` not found"; **`erw [Functor.map_add, Preadditive.comp_add]; rfl`** closes it.
  Defeq-carrier mismatch on the `Preadditive` instance — the recurring project obstacle.
- **`absoluteCohomology`**: `AddCommGrp.of` → "Unknown identifier"; Mathlib's category is
  **`AddCommGrpCat`** (the memory/recipe name was off).
- **`absoluteCohomologyZeroAddEquiv`**: additivity of `Ext.homEquiv₀` via `AddEquiv.mk'` +
  `simp only [Ext.homEquiv₀_symm_apply, Ext.mk₀_add, Ext.mk₀_homEquiv₀_apply]`. (lvb minor: Mathlib
  ships `Ext.addEquiv₀` which would replace the manual `mk'` — future golf.)
- **`absoluteCohomology_covariant_exact₁/₂/₃`**: two restatement gotchas — (a) the `Ext.comp` degree
  proof must be `add_zero n` not `by omega` (omega can't solve `n+0=?c` with `c` a metavariable);
  (b) the `∃ x, x.comp … = …` binder needs an explicit type annotation or field notation `x.comp`
  can't resolve.

## Audits (this iter)
- **lean-auditor** (`task_results/lean-auditor-iter026.md`): 1 must-fix — `AbsoluteCohomology.lean`
  not imported in the build root (orphaned). 2 majors — both **stale comments in `CechBridge.lean`**
  (strategy block L77–119 names the wrong combinator; "gated on Lane-1" L272–283 now false). 2 minors
  (local-instance scoping not warned; `erw` fragility). **0 excuse-comments.** The 10 new decls
  themselves: clean, faithful wrappers, no weakening. `FreePresheafComplex.lean` fully axiom-clean.
- **lean-vs-blueprint-checker** (`task_results/lean-vs-blueprint-checker-abscohom.md`): the 3 pinned
  decls correct, all 5 Ext `\mathlibok` anchors valid in Mathlib, axiom-clean, 0 red flags. 1 major —
  5 substantive project decls lack `\lean{}` blueprint blocks (the H⁰≅Γ, injective-vanishing, and the
  three covariant wrappers; described in `def:absolute_cohomology` prose but unpinned). 1 minor —
  `absoluteCohomologyZeroAddEquiv` could use `Ext.addEquiv₀`.

## Coverage / markers
- `archon dag-query unmatched`: **6** `lean_aux` nodes, all in `AbsoluteCohomology.lean`
  (`sheafificationHomAddEquiv`, `absoluteCohomologyZeroAddEquiv`,
  `absoluteCohomology_eq_zero_of_injective`, `absoluteCohomology_covariant_exact₁/₂/₃`). Listed in
  recommendations for the planner to blueprint (review does not author prose).
- `sync_leanok` iter=026: **added 4, removed 0** — the 3 named abscohom blocks + 1, all sound. This
  is healthier than iter-025's `removed 6` but the iter-025 anomaly is **not fully resolved**:
  `lem:ses_cech_h1` and `lem:injective_cech_acyclic` (both axiom-clean, both in `CechBridge.lean`)
  still lack `\leanok`. See Known Blockers / recommendations.
- **blueprint-doctor**: clean — no orphan chapters, no broken `\ref`/`\uses`, no new `axiom`.

## Blueprint markers updated (manual)
- None. The 5 Ext `\mathlibok` anchors were authored proactively by the plan-phase blueprint-writer;
  all are valid (lvb-confirmed). The 3 named decls' `\lean{}` pins match the prover's final names
  (no renames). No `% NOTE:` needed (no translation gaps); no stale `\notready` present.

## Notes (LOW)
- `absoluteCohomologyZeroAddEquiv` reconstructs additivity manually; `Ext.addEquiv₀` is the
  off-the-shelf `≃+`. Optional future simplification, not a correctness issue.

## Recommendations for next session
See `recommendations.md`. Headline: (1) **add the import to `AlgebraicJacobian.lean`** (a prover/
planner action — review cannot edit `.lean`); (2) bundle the 6 unmatched helpers into blueprint
`\lean{}` lists; (3) the next frontier is **01EO `cech_to_cohomology_on_basis`** consuming these
wrappers + `injective_cech_acyclic` + `ses_cech_h1` — effort-break it first.
