# Recommendations for the next plan-agent iteration (iter-015)

## Headline

**Iter-014 closed the Path-2 Mayer-Vietoris prerequisite scaffold sub-step**: the iter-014 refactor pass inserted a single `:= sorry` declaration in `Cohomology/StructureSheafModuleK.lean` (`AlgebraicGeometry.Scheme.HModule'` at L232–L238); the iter-014 prover round (this session) closed it with the probe-confirmed term-mode one-liner

```lean
Abelian.Ext ((presheafToSheaf _ _).obj
  ((yoneda ⋙ (Functor.whiskeringRight _ _ _).obj (ModuleCat.free k)).obj X)) F n
```

on first edit, kernel-only axioms (`propext`, `Classical.choice`, `Quot.sound`), no warnings, no errors. Sorry count `10 → 9` (back to baseline: 8 protected + 1 deferred `representable`). The `ModuleCat k`-flavored cohomology-of-an-open carrier is now a project-level definition. This extends the 100% first-edit closure streak to **eight** consecutive prover rounds (sessions 12, 13, 14, 15, 20, 21, 22, 24).

## Targets to prioritise (iter-015)

### Track 1 (recommended primary): `ModuleCat k`-flavored Mayer-Vietoris LES

The iter-014 sub-step delivered the *carrier* (`HModule'` — the `ModuleCat k` analogue of Mathlib's `Sheaf.H'`); iter-015 should deliver the **Mayer-Vietoris long exact sequence** in `HModule'`. Direct mirror of Mathlib's `Sheaf.mayerVietoris` (file `Mathlib/CategoryTheory/Sites/SheafCohomology/MayerVietoris.lean`) for `AddCommGrpCat`-valued sheaves, substituting `HModule'` for `Sheaf.H'`.

**Mathematical content (briefing for the iter-015 plan agent):**

For an abelian sheaf `F : Sheaf J (ModuleCat.{u} k)` and a Mayer-Vietoris square `S : MayerVietorisSquare J` with vertices `S.X₁` (the intersection), `S.X₂`, `S.X₃` (the two opens), `S.X₄` (the union), the LES takes the shape

```
… → HModule' F n S.X₄ → HModule' F n S.X₂ ⊕ HModule' F n S.X₃ → HModule' F n S.X₁
                       → HModule' F (n+1) S.X₄ → …
```

The standard reference is Cartan-Leray / Tohoku §3 (Mathlib reference: `CategoryTheory/Sites/SheafCohomology/MayerVietoris.lean`).

**Probe-driven first action for iter-015 plan agent:**

1. Re-confirm `MayerVietorisSquare` is still present in current Mathlib `b80f227+` (high confidence).
2. Probe what existing Mayer-Vietoris machinery is available — specifically: is there a `Sheaf.mayerVietoris` lemma for `AddCommGrpCat`-valued sheaves that we can mirror? An abstracted form for any `Linear k`-enriched abelian sheaf category? A `LongExactSequence`-typed declaration?
3. If yes, the iter-015 scaffold is one declaration (signature: a `LongExactSequence` of the form above). The mirror should mostly be name substitutions — `Sheaf.H'` → `HModule'`, `AddCommGrp.free` → `ModuleCat.free k`.
4. If the existing Mathlib `Sheaf.mayerVietoris` is general-enough (typeclass-parametrised over the value category), the iter-015 declaration may even be a one-line specialisation.

**Anticipated shape**: 1–2 declarations (LES statement + perhaps a connecting-morphism naturality lemma). Likely first-edit closure rate 70–95% on probe-confirmed bodies — comparable to iter-009/iter-014, which were single-Mathlib-application wrappers.

### Track 2 (supplementary, can be combined with Track 1): `HModule'_zero_linearEquiv`

Pattern-matching iter-010 (`HModule_zero_linearEquiv`): the degree-0 case of `HModule' F 0 X` should reduce to a `k`-linear Hom group. Specifically, `HModule' F 0 X ≃ₗ[k] (presheafToSheaf _ _ ).obj (yoneda-of-X) ⟶ F` via `Abelian.Ext.linearEquiv₀` (the same lemma that closed iter-010). Probe-confirmed at signature-shape level by analogy. Single-line body. Easy companion to bundle with Track 1 if desired.

### Track 3 (parallel low-coupling): polish backlog

- **No polish candidates currently known.** The polish backlog has been empty since iter-011; iter-014 did not introduce new candidates either (the `HModule'` declaration is scaffold, not polish — not `@[simp]`-tagged because it is a non-rfl carrier). The session-15 `HModule_forget` proposal remains **DROPPED** (consistent with iter-010 / iter-011 / iter-012 / iter-013 / iter-014 plan-agent rulings).

### Closest-to-completion remaining protected sorries (analysis only — DO NOT assign yet)

After iter-014, the gating-distance ranking is unchanged from session 22:

1. `AlgebraicGeometry.Jacobian.smoothOfRelativeDimension_genus` (`Jacobian.lean` L97) — gated on `Jacobian C` being defined (Phase C step 4 / FGA representability) AND on Serre finiteness for the dimension. Two layers of gating; the Serre-finiteness layer is itself gated behind the iter-014 → iter-015 → iter-016+ Path-2 chain.
2. `AlgebraicGeometry.Jacobian` (`Jacobian.lean` L77) — gated on Phase C step 4 (FGA representability of `PicardFunctor`); also requires the user `noncomputable`-authorisation surface (analogous to the `genus` authorisation already consumed for iter-011).
3. `AlgebraicGeometry.Jacobian.instGrpObj`, `instIsProper`, `instGeometricallyIrreducible` (`Jacobian.lean` L88, L104, L114) — all structurally gated on `Jacobian C` itself.
4. `AlgebraicGeometry.Jacobian.ofCurve`, `comp_ofCurve`, `exists_unique_ofCurve_comp` (`AbelJacobi.lean` L35, L41, L53) — all gated on `Jacobian C` itself plus the universal property.

**None of these are ready for iter-015 prover assignment.** Track 1 (Mayer-Vietoris LES) is itself a 3+-iteration scaffold from current state — keep them on the "do not assign" list.

## Targets to NOT assign (do not retry)

- **The 8 remaining protected sorries** (`Jacobian.lean` × 5 at L77/L88/L97/L104/L114, `AbelJacobi.lean` × 3 at L35/L41/L53). All blocked behind:
  - Path-2 Phase A step 6 / Serre finiteness (multi-iteration upstream — Track 1 + Mayer-Vietoris LES + comparison theorem + finiteness step + dimension-vanishing step);
  - Phase C step 4 / FGA representability (multi-iteration);
  - Phase E geometric inputs (multi-iteration);
  - For the three `def`-flavoured ones (`Jacobian`, `ofCurve`), additionally a **`noncomputable` user-decision** analogous to the `genus` authorisation consumed for iter-011. Do not pre-empt the user's authorisation.
- **`PicardFunctor.representable`** (`Picard/Functor.lean` L190) — closing on the global-sections-approximate `LineBundle` is a forbidden shortcut. Honest closure requires `LineBundle` refinement (gated on `MonoidalCategory X.Modules`, still absent in current Mathlib `b80f227`) plus the FGA argument. Multi-iteration; do not assign.
- **Direct `LineBundle` refinement** — gated on `MonoidalCategory X.Modules`. Multi-iteration; do not assign as a primary objective.
- **Vacuous closures** (`Discrete PUnit`, `PUnit`, `Empty`, the unit sheaf, `Sheaf.{u+1}` of `PUnit`, etc.) — destroy downstream chains. Rejected on sight.
- **`genus C := 0` or any constant** — false in genus ≥ 1. Honest closure in place (iter-011); do not regress.
- **New `axiom` declarations** — forbidden by plan-agent rules.
- **Closing `HModule'` with vacuous types** (already closed honestly this session; the dead-end shortcuts `PUnit`, `ULift PUnit`, `ModuleCat.of k PUnit`, constant `Type u`, etc. are forbidden and now recorded in iter-014 specific dead-ends list).
- **Closing `HModule'` with `def` instead of `noncomputable abbrev`** — would block instance synthesis of `Module k` and `AddCommGroup` (cf. iter-009 / iter-015 `HModule` design rationale). The `noncomputable abbrev` form is in place and must be preserved by iter-015+.
- **Scaffolding a new file `AlgebraicJacobian/Cohomology/MayerVietoris.lean` instead of extending `Cohomology/StructureSheafModuleK.lean`** — the file is still under ~250 LOC including comments; no need to split. Iter-016+ may reconsider if the surface grows beyond ~10 declarations.
- **`HModule_forget` polish lemma** — DROPPED iter-010/iter-011/iter-012/iter-013/iter-014; do not retry.

## Reusable proof patterns (added or reinforced this session)

- **The `presheafToSheaf` + `yoneda ⋙ whiskeringRight ModuleCat.free k`** spelling for "free-`k`-module sheafified presheaf at `X`" (added this session). Use this as the first argument of `Abelian.Ext` when defining the cohomology-of-an-open in `ModuleCat k` flavor — direct mirror of Mathlib's `AddCommGrp.free`-flavored `Sheaf.H'` machinery.
- **Adding `[HasWeakSheafify J (Type u)]` alongside `[HasSheafify J (ModuleCat.{u} k)]`** for `presheafToSheaf` typeclass elaboration (added this session). When the codomain is a non-`Type u` value category like `ModuleCat.{u} k`, the underlying `Type u` weak-sheafification step also needs to be in scope.
- **Probe-confirmed term-mode one-liners adopted verbatim have ~100% first-edit reliability** — now eight consecutive rounds (sessions 12, 13, 14, 15, 20, 21, 22, 24). The protocol generalises: scaffold rounds (iter-006/012/014), polish rounds (iter-007/008), and protected-sorry rounds (iter-011) all close on probe-confirmed bodies.
- **`noncomputable abbrev` for instance-transparent wrappers around `Ext` is the right shape** (re-confirmed this session for `HModule'`; matches iter-009 `HModule`). Use `def` only for value-style consumed declarations (iter-010 `HModule_zero_linearEquiv`, iter-011 `genus`, iter-012 `cechCochain_OC` / `cechCohomology_OC`).
- **Use `Abelian.Ext` (qualified) for stylistic consistency** when `open CategoryTheory` is active — iter-009 / iter-010 / iter-014 all use the qualified form. Either form is mathematically equivalent; the directive explicitly allows either, but consistency aids readability.

## Anticipated iter-015 shape

| Aspect | Iter-014 (this session) | Iter-015 (anticipated) |
|---|---|---|
| Track | Path-2 Mayer-Vietoris prerequisite (`HModule'` carrier) | Track 1 / Path-2 — `ModuleCat k`-flavored Mayer-Vietoris LES on a `MayerVietorisSquare` |
| Stage | plan → refactor → prover → review (this) | plan → refactor → prover → review |
| Scope | 1 scaffold declaration (`HModule'`), 1 prover round, 100% first-edit | likely 1–2 declarations: the LES statement (mirror of `Sheaf.mayerVietoris`) + perhaps the connecting-morphism naturality lemma. Optional: bundle `HModule'_zero_linearEquiv` (iter-010 mirror) |
| First-edit closure expectation | 100% (probe-confirmed term-mode one-liner) | mixed — 70–95% on probe-confirmed bodies. The LES statement may need a `LongExactSequence` typeclass-shape match; if Mathlib's `Sheaf.mayerVietoris` is general-enough, the iter-015 declaration may even be a one-line specialisation. |
| Sorry count delta | 10 → 9 (closes the iter-014 refactor scaffold) | likely +1 or +2 transient (refactor inserts new scaffolds; prover closes them) — net zero for the round |
| Protected sorries | unchanged at 8 | unchanged at 8 (Track 1 is upstream scaffolding, not a protected target) |
| Deferred `representable` | unchanged | unchanged |

## Self-validation note

`task_pending.md` should be updated by the iter-015 plan agent to reflect:
- The Path-2 Mayer-Vietoris prerequisite scaffold sub-step (`HModule'`) is **CLOSED** (iter-014 prover-round consumed it).
- The next "current Mathlib gap section" becomes the `ModuleCat k`-flavored Mayer-Vietoris LES.
- The Čech-vs-derived-functor comparison is now an iter-016+ target (deferred one iteration as Mayer-Vietoris LES is the more direct prerequisite to Serre finiteness).
- The `noncomputable` user-decisions for `Jacobian` and `ofCurve` remain **OPEN** (parallel surfaces; will be needed when their honest closures are scaffolded — multi-iteration away).

The 100% first-edit closure streak (eight consecutive rounds — sessions 12, 13, 14, 15, 20, 21, 22, 24) is a reliable signal that the plan-agent live-probe protocol scales across both scaffold and protected closures. The iter-015 plan agent should continue to apply it, and should pass the iter-014 closure pattern (qualified `Abelian.Ext` spelling for stylistic consistency) forward to the iter-015 prover-round directive when the body is again a single `Abelian.*`-call wrapper.

## Iteration label drift

The blueprint chapter `Cohomology_StructureSheafModuleK.tex` carries a section/definition label `(iter-013)` for what is canonically Archon iter-014. This is plan-agent / informal-prose drift from earlier iterations and is **not** the review agent's surface to rewrite. The canonical iteration number `014` is used in this journal, in `PROJECT_STATUS.md`, and in this `recommendations.md` per the prompt's mandate. The plan agent for iter-015 may optionally reconcile the blueprint's iteration labelling at its own discretion — review agent does not enforce.
