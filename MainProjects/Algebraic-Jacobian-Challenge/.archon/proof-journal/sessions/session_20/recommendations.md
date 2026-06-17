# Recommendations for the next plan-agent iteration (iter-026)

## Highest priority: fix the iteration-counter desync (now two steps off)

The dispatcher counter has advanced to **025** while the PROGRESS.md narrative still labels the stage `iteration 023` (now describing the work that *just landed* this session). Session 33 was a verify-only round caused by a one-step lag; session 34 closed the iter-023 deliverables but two more dispatcher ticks have accrued. The next plan-agent invocation must:

1. **First action**: rewrite the PROGRESS.md `## Current Stage` line to match whatever `meta.json` reports for the next iteration (likely `iteration 026`). Do not let the narrative label drift another step.
2. **Migrate the iter-023 closures** (`HModule'_toBiprod_apply`, `HModule'_fromBiprod_biprodIsoProd_inv_apply`, `HModule'_biprodAddEquiv_symm_biprodIsoProd_hom_toBiprod_apply`, `HModule'_mk₀_f_comp_biprodAddEquiv_symm_biprodIsoProd_hom`, `HModule'_sequenceIso`) from `task_pending.md` to `task_done.md`.
3. **Issue a fresh objective** (see "Primary recommendation" below).

## Primary recommendation: file split (sixth-time-of-asking; now URGENT)

**Before** issuing any new declaration objective for iter-026, the plan agent should invoke the `refactor` subagent to split `Cohomology/MayerVietoris.lean` from `Cohomology/StructureSheafModuleK.lean`. The file is now **774 LOC** — `~374 LOC over the ~400 LOC threshold` for splitting. The iter-026+ exactness theorem (`HModule'_sequence_exact`) plus the two `simp` companions (`δ_toBiprod`, `fromBiprod_δ`, Mathlib L140--149) will add another ~30--50 LOC; iter-027+ Čech-vs-derived-functor comparison and acyclic-cover machinery will add 100--200 LOC more. Without a split, the file will exceed 1000 LOC by iter-027.

Suggested move (refactor agent directive sketch):

- Move iter-016 + iter-017 + iter-018 + iter-019 + iter-020 + iter-021 + iter-022 + iter-023 declarations (~445 LOC of the current 774, lines 232--737 modulo the iter-014 / iter-015 carrier definitions which stay) to a new `AlgebraicJacobian/Cohomology/MayerVietoris.lean`.
- Leaves `StructureSheafModuleK.lean` at ~330 LOC (the `kToSection` / `algebraSection` / `toModuleKSheaf` / `HasSheafify` / `HModule` / `HModule'` / `HModule_zero_linearEquiv` / `HModule'_zero_linearEquiv` infrastructure plus iter-012 Čech scaffolding).
- Imports: the new file imports `StructureSheafModuleK.lean`; downstream files (`Picard/FunctorAb.lean`, etc.) get a single new import line if they consume any iter-016+ declaration (so far they do not — the iter-016+ MV-LES infrastructure is not consumed downstream yet).

Refactor agent must:
- Preserve all declaration names and signatures verbatim.
- Move blueprint chapter content to a new `Cohomology_MayerVietoris.tex` chapter (or keep the chapter unified — the plan agent decides).
- Preserve all iter-016 through iter-023 closures (no `sorry` introduced in moved declarations).

## Secondary recommendation: iter-026 declaration target

After the refactor, the iter-026 declaration target should be **one-shot** because the foundational LES infrastructure is now in place. Recommended:

### Target: `HModule'_sequence_exact` + `HModule'_δ_toBiprod` + `HModule'_fromBiprod_δ` (all in `Cohomology/MayerVietoris.lean`)

Three short declarations mirroring Mathlib `MayerVietoris.lean` L140--149:

1. **`HModule'_sequence_exact`** (lemma): `(HModule'_sequence k S F n₀ n₁ h).Exact` — closed via `exact_of_iso` against `HModule'_sequenceIso` plus Mathlib's `Ext.contravariantSequence_exact`. One-liner.

2. **`HModule'_δ_toBiprod`** (`@[simp]` lemma): `HModule'_δ k S F n₀ n₁ h ≫ HModule'_toBiprod k S F n₁ = 0` — closed via `(HModule'_sequence k S F n₀ n₁ h).zero 2`. One-liner consequence of `HModule'_sequence_exact`.

3. **`HModule'_fromBiprod_δ`** (`@[simp]` lemma): `HModule'_fromBiprod k S F n₀ ≫ HModule'_δ k S F n₀ n₁ h = 0` — closed via `(HModule'_sequence k S F n₀ n₁ h).zero 1`. One-liner consequence.

Plan agent should probe-confirm each body with `lean_run_code` against the post-refactor file before issuing the directive (matches the iter-018 through iter-023 cadence).

Estimated total addition: ~30 LOC. Probe priority: high (each is a one-liner; standard Mathlib pattern).

## Tertiary recommendation: blueprint chapter section (iter-026)

Plan agent should add a new section to `blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex` (or `Cohomology_MayerVietoris.tex` if the chapter splits with the file): "Mayer-Vietoris LES exactness theorem + simp companions (iter-026)" containing three labelled blocks:

- `lem:Scheme_HModule_prime_sequence_exact`
- `lem:Scheme_HModule_prime_delta_toBiprod` (or `Scheme_HModule_prime_δ_toBiprod`)
- `lem:Scheme_HModule_prime_fromBiprod_delta` (or `Scheme_HModule_prime_fromBiprod_δ`)

Each block uses `\uses{def:Scheme_HModule_prime_sequenceIso}` (this session's deliverable) and `\uses{lem:Scheme_HModule_prime_shortComplex_shortExact}` (iter-020).

## Targets that should NOT be assigned in iter-026

- **The 8 protected sorries** (`Jacobian.lean` × 5, `AbelJacobi.lean` × 3) remain blocked on Phase C representability (FGA representability) plus, for `smoothOfRelativeDimension_genus`, Phase A step 6 *proper* (Serre finiteness on a proper curve). The iter-023 deliverables advance the Path-2 chain by one substantial step but do not yet provide the dimension-vanishing or Module.Finite k results that `smoothOfRelativeDimension_genus` requires.
- **`PicardFunctor.representable`** (`Picard/Functor.lean` L190) — gated on `MonoidalCategory X.Modules` (still absent in current Mathlib). Multi-iteration deferral. Do not retry.
- **`LineBundle` direct refinement** — gated on `MonoidalCategory X.Modules`. Multi-iteration. Do not issue.
- **Iter-026+ Serre-finiteness scaffolding** — out of scope; iter-026 should focus on the LES exactness theorem + simp companions before specialising to a proper curve cover.

## Reusable proof patterns surfaced this session

### Pattern A: `biprodIsoProd`-side elementwise lemmas

When the codomain is a biproduct in `AddCommGrpCat` and the carrier is a `dsimp`-unfoldable `lemma`/`def`, close elementwise apply lemmas with:

```lean
apply (AddCommGrpCat.biprodIsoProd _ _).addCommGroupIsoToAddEquiv.injective
dsimp [carrier_def]
ext
· rw [Iso.addCommGroupIsoToAddEquiv_apply, Iso.addCommGroupIsoToAddEquiv_apply,
    ← AddCommGrpCat.biprodIsoProd_inv_comp_fst_apply, Iso.hom_inv_id_apply,
    ← ConcreteCategory.comp_apply, biprod.lift_fst, Iso.inv_hom_id_apply]
· rw [...]  -- snd-side mirror
```

(See Target 1 — `HModule'_toBiprod_apply`.)

### Pattern B: `Ext`-side bridge lemmas

When relating `Ext.biprodAddEquiv.symm` to a `(Ext.mk₀ ...).comp` form, use:

```lean
set_option backward.isDefEq.respectTransparency false in
attribute [local simp] <local_simp_lemmas> in
lemma foo ... := Ext.biprodAddEquiv.injective (by cat_disch)
```

(See Target 3.)

The `set_option` is load-bearing for `cat_disch`'s typeclass-search transparency; the `attribute` registers helper lemmas as local simp.

### Pattern C: `obtain` destructuring on biproduct surjectivity

To convert an opaque biproduct element into a concrete pair-form:

```lean
obtain ⟨⟨x₂, x₃⟩, rfl⟩ :=
  (AddCommGrpCat.biprodIsoProd _ _).addCommGroupIsoToAddEquiv.symm.surjective x
```

Subsequent rewrites can then use the explicit pair (`x₂`, `x₃`). (See Target 4.)

### Pattern D: `ComposableArrows.isoMk₅` constructor invocation

For an iso between two `ComposableArrows _ 5`, the term-mode body has the shape:

```lean
ComposableArrows.isoMk₅ <iso0> <iso1> <iso2> <iso3> <iso4> <iso5>
  <2-cell-square-0> <2-cell-square-1> <2-cell-square-2> <2-cell-square-3> <2-cell-square-4>
```

Each 2-cell square can typically be discharged by `by ext; apply <bridge_lemma>` (when both sides are non-trivial isos) or `by dsimp; rw [Category.comp_id, Category.id_comp]; rfl` (when both source and target iso fields are `Iso.refl`). (See Target 5.)

### Pattern E: docstring → `--` block conversion

When a declaration carries a `set_option ... in` or `attribute ... in` wrapper chain, the parser will reject a docstring (`/-- ... -/`) above the wrapper. Convert to `-- ...` line comments above the wrapper. (Well-precedented from iter-020 `HModule'_shortComplex_f_mono`; this session re-applied it to Targets 3, 4, 5.)

## Process drift note (third occurrence)

Session 33 was the first verify-only round; session 34 closed the iter-023 deliverables but the dispatcher counter has now advanced two steps ahead of the PROGRESS.md narrative. The plan-agent's "iteration NNN" labelling in PROGRESS.md must follow the dispatcher counter strictly — do not let the narrative drift from `iteration 023` (current label) to `iteration 026` (where the dispatcher will be on the next round) without an explicit rewrite of the `## Current Stage` line. This is the *third time* the iteration-counter desync has been flagged; recommend the iter-026 plan-agent invocation begin with a fixed-step PROGRESS.md re-sync routine.
