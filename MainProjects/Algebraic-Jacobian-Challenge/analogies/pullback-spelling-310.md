# Analogy: the two pullback "spellings" on `X.Modules` — parallel API or one alias?

## Mode
api-alignment

## Slug
pullback-spelling

## Iteration
310

## Question
Is `Scheme.Modules.pullback f` a needless parallel to `SheafOfModules.pullback (toRingCatSheafHom f)`?
What is the Mathlib-idiomatic way to make the two interchangeable at the NatTrans/whisker level
WITHOUT a global isDefEq blowup, and how does Mathlib prove `leftAdjointUniq`/`conjugateEquiv`
comparison cocycles over adjoint functors written two ways without the monolithic functor isDefEq?

## Project artifact(s)
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:2572` — `sheafificationCompPullback_comp` (D3′ S1 cocycle).
- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:752` — `pullbackSpecTildeNatIso` (FBC move-(2) cocycle).

## CRITICAL CORRECTION TO THE DIRECTIVE'S PREMISE
`Scheme.Modules.pullback` is **NOT project-local**. It is **Mathlib**:
`Mathlib/AlgebraicGeometry/Modules/Sheaf.lean:167` —
```
noncomputable def pullback (f : X ⟶ Y) : Y.Modules ⥤ X.Modules :=
  SheafOfModules.pullback f.toRingCatSheafHom
```
So the two "spellings" are **the same Mathlib declaration and its one-step δ-unfolding** — not a
parallel API. `Scheme.Modules.pullback f` ≡ `SheafOfModules.pullback f.toRingCatSheafHom` by a single
`delta`. The "parallelism" is illusory; it is a non-reducible `def` boundary, not two definitions.

Supporting Mathlib facts (all `[verified]` this run):
- `Scheme.Modules` = `SheafOfModules X.ringCatSheaf` (Sheaf.lean:37, plain `def`).
- `Scheme.Hom.toRingCatSheafHom` = Mathlib, `Mathlib/AlgebraicGeometry/Modules/Presheaf.lean:42`.
- `SheafOfModules.pullback φ` = `(pushforward φ).leftAdjoint`
  (`Mathlib/Algebra/Category/ModuleCat/Sheaf/PullbackContinuous.lean:53`). **This `leftAdjoint` is
  the real cost** — an opaque, `Lan`-built left adjoint. isDefEq over it (in either spelling) is what
  detonates, not the `Scheme.Modules.pullback` δ-step (that is trivial).

## Decisions identified

### Decision 1: Is `Scheme.Modules.pullback` a parallel API to align away?
- **Mathlib idiom**: Mathlib *itself* created `Scheme.Modules.pullback` as the higher-level alias
  over `SheafOfModules.pullback ∘ toRingCatSheafHom`, and re-exported the **entire cocycle API** on
  top of it so downstream users never touch the `SheafOfModules` spelling: `pullbackComp`
  (Sheaf.lean:219), `pullbackId` (199), `pullbackCongr` (235), `pullbackPushforwardAdjunction` (172),
  `conjugateEquiv_pullbackComp_inv` (238), `conjugateEquiv_pullbackId_hom` (203), and the full
  `pseudofunctor` (300) with `pseudofunctor_associativity/left_unitality/right_unitality` (246/263/277).
- **Project's path**: uses `Scheme.Modules.pullback` almost everywhere (correct); the mixing only
  happens at sheafification junctions where low-level `SheafOfModules.pullback (toRingCatSheafHom f)`
  leaks in via `sheafificationCompPullback`/`pullbackObjUnitToUnit`.
- **Gap**: identical (it IS the Mathlib idiom).
- **Verdict**: **PROCEED**. Keep `Scheme.Modules.pullback` as the canonical spelling; fold the
  low-level spelling UP to it, never the reverse.

### Decision 2: syntactic bridge that avoids the isDefEq blowup
- **Mathlib idiom (primary)**: `set_option backward.isDefEq.respectTransparency false in` on the
  lemma. Mathlib applies this knob to **every** pullback-cocycle lemma touching these `leftAdjoint`
  functors — Sheaf.lean:131,244,261,275,289; PullbackContinuous.lean:75; and 6 more pullback-adjacent
  Mathlib files. It is a standard knob (6196 uses across Mathlib). It tells the back-compat isDefEq
  path not to re-run the expensive transparency-respecting unfold loop on these opaque adjoints.
- **Mathlib idiom (pinning)**: `let e₁ := …; let e₂ := …; change e₁.inv ≫ … = _` (Sheaf.lean:251-255,
  267-270, 281-284). The `let`/`change` makes Lean treat each iso atomically, so `rw`/`simp` never
  trigger a functor-level unfold.
- **Project-local fold lemma (normal-form-first, optional booster)**:
  `@[simp] lemma SheafOfModules.pullback_toRingCatSheafHom (f) :
      SheafOfModules.pullback f.toRingCatSheafHom = Scheme.Modules.pullback f := rfl`
  Oriented low→high, simp folds every leaked low-level spelling to the canonical one by **syntactic
  match** (no isDefEq), making any later `congr_app` reflexive on the functor slot.
- **Gap**: divergent-with-cost — the walled lemmas omit the knob.
- **Verdict**: **ALIGN_WITH_MATHLIB**. Add `backward.isDefEq.respectTransparency false` + `let/change`
  pinning to the two walled lemmas.

### Decision 3: how Mathlib proves the `leftAdjointUniq`/`conjugateEquiv` comparison cocycle
- **Mathlib idiom**: it NEVER does NatTrans `congr_app` over the monolithic pullback. It **transports
  the cocycle to the right-adjoint (pushforward) side** via `conjugateEquiv`, where pushforward is a
  concrete `where`-defined functor (`PushforwardContinuous.lean:44`) with cheap/`rfl` cocycles, then
  pulls the result back. The transport ladder (all `[verified]`):
  - `CategoryTheory.conjugateEquiv` (Mates.lean:272), `conjugateEquiv_comp` (Mates.lean:338),
    `mateEquiv_vcomp` (Mates.lean:167), `conjugateEquiv_whiskerLeft` (Mates.lean:525),
    `conjugateIsoEquiv` (Mates.lean:413) — the foundational mate calculus.
  - `Adjunction.conjugateEquiv_leftAdjointCompIso_inv` (CompositionIso.lean:82)
    → re-exported `SheafOfModules.conjugateEquiv_pullbackComp_inv` (PullbackContinuous.lean:176)
    → `Scheme.Modules.conjugateEquiv_pullbackComp_inv` (Sheaf.lean:238).
  - `Adjunction.conjugateEquiv_leftAdjointIdIso_hom` (CompositionIso.lean:48) → `…pullbackId_hom`.
  - `Adjunction.leftAdjointCompIso_assoc` (CompositionIso.lean:168)
    → `SheafOfModules.pullback_assoc` (PullbackContinuous.lean:192)
    → `Scheme.Modules.pseudofunctor_associativity` (Sheaf.lean:246).
  - `Adjunction.leftAdjointCompIso_id_comp/_comp_id` (CompositionIso.lean:102/…)
    → `SheafOfModules.pullback_id_comp/_comp_id` (PullbackContinuous.lean:203/208).
  The proof shape (Sheaf.lean:246-259): `set_option … false in` → `let eᵢ := …` → `change eᵢ … = _`
  → `have : … = congr_arg Iso.hom (SheafOfModules.pullback_assoc …)` → `simp [this]`. The actual
  cocycle is discharged by the underlying `SheafOfModules.pullback_*` lemma; the `let/change` keeps
  the functor spelling pinned so the surrounding `simp` is syntactic.
- **Verdict**: **PROCEED** on the math; **ALIGN** on technique — both lanes should adopt this shape.

## Recommendation
There is no parallel API to refactor — `Scheme.Modules.pullback` IS the Mathlib idiom. The wall is a
missing back-compat isDefEq knob plus eager-unfold from un-pinned spellings. Three portable moves,
usable by BOTH the D3′ (`sheafificationCompPullback_comp`, TOS:2572) and FBC move-(2)
(`pullbackSpecTildeNatIso` cocycle, FBC:752) lanes:

1. Add `set_option backward.isDefEq.respectTransparency false in` to each walled lemma (the D3′ lemma
   currently has only `maxHeartbeats 3200000`; FBC knows the knob but didn't apply it to the cocycle).
2. Pin every comparison iso as a `let eᵢ := …` and `change` the goal to the let-form before any
   `rw`/`erw`/`congr_app`, so the `leftAdjoint`/sheafification functors are never unfolded.
3. Discharge the cocycle on the RIGHT-adjoint side and transport: D3′ is already calling
   `Scheme.Modules.conjugateEquiv_pullbackComp_inv` (TOS:2618) — it only needs (1)+(2) to reach it
   under budget. FBC should state move-(2) as a pushforward/`restrictScalars`-side identity
   (`pushforwardSpecTildeNatIso`, FBC:721 — concretely counit-built) and transport via
   `conjugateIsoEquiv` naturality (`conjugateEquiv_comp`, Mates.lean:338) rather than re-deriving the
   `conjugateIsoEquiv` mate by hand.

Optionally add the `pullback_toRingCatSheafHom := rfl` fold simp-lemma to normalize leaked spellings
up front; this turns the residual functor-slot isDefEq into reflexivity.
