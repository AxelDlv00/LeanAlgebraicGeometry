# Blueprint Writer Report

## Slug
fbc-routeswap

## Status
COMPLETE

## Target chapters
- `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` (PRIMARY)
- `blueprint/src/chapters/Cohomology_RegroupHelper.tex` (SECONDARY, §3)

## Changes Made

### §1 — Mate tower dissolved, replaced by one section-level identity
- **Renamed subsection** `The section-level mate computation, decomposed` →
  `The section-level base-change identity`; rewrote the intro prose to describe the
  direct-on-sections route (the base-change map is the `R'`-base change of the algebraic
  unit; post-composing with the regrouping iso gives the canonical comparison) instead of
  the "decomposed mate" route.
- **Dropped** three blocks (statement + proof each), per directive:
  - `lem:base_change_mate_unit_value`
  - `lem:base_change_mate_fstar_reindex`
  - `lem:base_change_mate_gstar_transpose`
  Also removed the iter-008 NOTE comment block that flagged them for `% LEAN SIGNATURE`
  authoring.
- **Replaced** `lem:base_change_mate_generator_trace_eq` with a new single lemma
  **`lem:base_change_mate_section_identity`**
  (`\lean{AlgebraicGeometry.base_change_mate_section_identity}`):
  - States `Γ(θ)`, conjugated through the domain/codomain reads, is the `R'`-base change
    of the algebraic unit `η_M : M → (A⊗_R R')⊗_A M`, `m ↦ (1⊗1)⊗m` (i.e.
    `LinearMap.lTensor R' η_M` followed by the `R'`-action), sending the generator
    `r' ⊗ m ↦ (1 ⊗ r') ⊗ m`; equivalently it equals `regroup⁻¹` (an iso, no flatness).
  - Carries a rigorous `% LEAN SIGNATURE` block pinning the consumable propositional
    equality `(domain_read).inv ≫ Γ(pushforwardBaseChangeMap …) ≫ (codomain_read).hom
    = (base_change_mate_regroupEquiv ψ φ M).inv` (same well-typed conclusion the IsIso
    wrapper consumes), typed against the carriers that `domain_read`/`codomain_read`
    produce.
  - Full informal proof: the direct-on-sections naturality computation reducing `Γ(θ)`
    to `lTensor R' η_M` and identifying it with `regroup⁻¹`.
  - Verbatim `% SOURCE QUOTE:` of Stacks `lemma-affine-base-change` proof ("boils down to
    the equality … as `R'`-modules") + a secondary verbatim `% SOURCE QUOTE (cohomological
    form):` of **Tag 02KH part (2)** (the H⁰/direct-image specialisation this affine
    identity underlies). Both copied from `references/stacks-coherent.tex`.
- **Kept** `lem:base_change_mate_domain_read`, `lem:base_change_mate_codomain_read` (the
  typed carrier reads) unchanged.
- **Repointed** `lem:base_change_mate_generator_trace` (the IsIso wrapper the goal
  consumes): its `\uses{}` and proof prose now reference
  `lem:base_change_mate_section_identity` instead of the dropped `…_generator_trace_eq`.
  Kept the block — it is the IsIso corollary the parent assembly consumes (mirrors the
  Lean `rw [section_identity]; infer_instance`).
- **Updated** `lem:pushforward_base_change_mate_cancelBaseChange` NOTE comments to drop the
  stale "trace decomposition" narrative and name the section identity + the native-`R'`
  regrouping iso. Its `\uses{}` was already free of dropped labels (it depends on
  `…_generator_trace`, which now routes to the section identity + regroupEquiv); left the
  Lean-faithful edge through the IsIso wrapper.

### §2 — `lem:base_change_mate_regroupEquiv` construction rewritten (kills `map_smul'`)
- Statement (the iso) unchanged.
- `\uses{}` changed from `{cancelBaseChange_mathlib, base_change_regroup_linearEquiv}` to
  `{base_change_regroup_linearEquiv, isPushout_cancelBaseChange_mathlib}`.
- Construction/proof prose rewritten: the underlying equivalence is now the **natively
  `R'`-linear** `Algebra.IsPushout.cancelBaseChange` (via `base_change_regroup_linearEquiv`),
  so there is **no** hand `map_smul'`, no `TensorProduct.induction_on`, no `r'·0` branch.
  The only residual is the `Module A (A⊗_R R')` diamond against
  `(extendScalars includeLeftRingHom).obj M`, resolved at the object level by an
  identity-on-carrier `≃ₗ[R']` bridge `eT` with `map_smul' := fun _ _ => rfl`, modelled on
  the project's element-free `gammaPushforwardIso` coherence maps. Cites
  `TensorProduct.isPushout'` for the free `Algebra.IsPushout R R' A (A⊗_R R')` instance.

### Mathlib dependency anchor authored
- **Added** `lem:isPushout_cancelBaseChange_mathlib`
  (`\lean{Algebra.IsPushout.cancelBaseChange}`, `\mathlibok`) in
  `Cohomology_FlatBaseChange.tex`, next to the existing `cancelBaseChange_mathlib` anchor.
  States the pushout-form cancellation `B ⊗_A M ≃ₗ[S] S ⊗_R M` (natively `S`-linear, no
  `map_smul'`), and the `S=R'`, `B=A⊗_R R'` instantiation with the free `isPushout'`
  instance. Referenced cross-chapter by `base_change_regroup_linearEquiv` (RegroupHelper).

### §3 — `Cohomology_RegroupHelper.tex`
- `base_change_regroup_linearEquiv` statement (the `(A⊗_R R')⊗_A M ≃ₗ[R'] R'⊗_R M` equiv)
  and its `\leanok`/`\mathlibok` markers unchanged.
- `\uses{}` (statement + proof) changed `cancelBaseChange_mathlib` →
  `isPushout_cancelBaseChange_mathlib`.
- Construction prose rewritten: the core is now `Algebra.IsPushout.cancelBaseChange R R' A
  (A⊗_R R') M` (instance from `TensorProduct.isPushout'`), natively `≃ₗ[R']`; explicitly
  contrasts with the dead `comm ≪≫ AlgebraTensorModule.cancelBaseChange ≪≫ comm` core
  (`≃ₗ[A]` B-slot) that forced the hand `R'`-linearity and the zero branches.

## Cross-references introduced
- `lem:base_change_mate_section_identity` `\uses{def:pushforward_base_change_map,
  lem:base_change_mate_domain_read, lem:base_change_mate_codomain_read,
  lem:base_change_mate_regroupEquiv}` — all exist in this chapter.
- `lem:base_change_mate_generator_trace` now `\uses{lem:base_change_mate_regroupEquiv,
  lem:base_change_mate_section_identity}`.
- `lem:base_change_mate_regroupEquiv` now `\uses{lem:base_change_regroup_linearEquiv,
  lem:isPushout_cancelBaseChange_mathlib}`.
- `lem:base_change_regroup_linearEquiv` (RegroupHelper) now
  `\uses{lem:isPushout_cancelBaseChange_mathlib}` — cross-chapter ref to the new anchor in
  FlatBaseChange (resolves via leandag; confirmed 0 unknown_uses).

## Verification
- `leandag build --json`: **unknown_uses = 0, isolated = 0** (baseline was 0 unknown_uses).
- No `\uses{}` anywhere references a dropped label (grep-confirmed empty for
  `base_change_mate_unit_value`, `…_fstar_reindex`, `…_gstar_transpose`,
  `…_generator_trace_eq`).
- LaTeX env balance: FlatBaseChange 29/29 lemma, 26/26 proof; RegroupHelper 1/1, 1/1.
- `\leanok` markers untouched (sync_leanok owns them); only `\mathlibok` added, on the one
  genuine Mathlib anchor `Algebra.IsPushout.cancelBaseChange`.
- `lem:cancelBaseChange_mathlib` retained (still consumed by
  `lem:pushforward_base_change_mate_cancelBaseChange`); not orphaned.

## References consulted
- `references/stacks-coherent.tex` — verbatim `% SOURCE QUOTE:` for
  `lem:base_change_mate_section_identity`: the `lemma-affine-base-change` proof "boils down
  to the equality `(R' ⊗_R A) ⊗_A M = R' ⊗_R M` as `R'`-modules" (L932–937), and the
  Tag 02KH part (2) cohomological-form quote (L967–968).
- `references/stacks-coherent.md` — tag→label map confirming 02KH =
  `lemma-flat-base-change-cohomology`, part (2) is the H⁰/affine specialisation.
- `analogies/fbc-base-change-square-transparent-module.md` — the construction recipe for
  §2/§3 (the `Algebra.IsPushout.cancelBaseChange` core swap, `TensorProduct.isPushout'`
  free instance, and the object-level diamond resolution via a `rfl`-`map_smul'` bridge).
- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` (read-only, for grounding the
  `% LEAN SIGNATURE` against the real types of `base_change_mate_domain_read`,
  `…_codomain_read`, `…_regroupEquiv`, and the conjugate equality the IsIso wrapper
  consumes).

## Notes for Plan Agent
- **Lean rewiring implied (not done by me — I only edit blueprint):** the blueprint now
  names a NEW decl `AlgebraicGeometry.base_change_mate_section_identity` replacing the
  `sorry`-bodied `base_change_mate_generator_trace_eq`. The Lean side
  (`FlatBaseChange.lean`) will need the scaffolder/prover to (a) create
  `base_change_mate_section_identity` with the pinned signature, (b) repoint
  `base_change_mate_generator_trace`'s `rw` from `…_generator_trace_eq` to the new decl,
  and (c) remove the now-orphaned `base_change_mate_generator_trace_eq` + the three former
  sub-lemma decls if they were ever stubbed. The blueprint and the Lean `\lean{}` hints are
  now consistent with that target.
- **Citation nuance on "02KH part 2":** the directive named Stacks 02KH part (2) as the
  source to quote. Part (2) is the *cohomological* (H^i, flat) base-change form; the precise
  on-disk statement for THIS affine, flatness-free section identity (`g^*f_*F = f'_*(g')^*F`
  for affine `f`) is the sibling `lemma-affine-base-change` and its "boils down to the
  equality" step. I made the primary verbatim quote that affine statement (consistent with
  the kept `domain_read`/`codomain_read` blocks) and included the 02KH(2) quote as a
  labelled secondary "cohomological form" — both verbatim from the local file. Flagging so
  the reviewer is aware the primary citation key is `lemma-affine-base-change`, with 02KH(2)
  as the generalisation, rather than 02KH(2) standing alone over an affine no-flatness lemma.
- **`map_smul'` zero-branch wall is now purely a Lean concern** that the prose route avoids
  by construction; the analogist's note that the same-file `LinearEquiv.toModuleIso` one-liner
  only typechecks with the helper in a *separate compiled module* is already reflected by the
  existing split of `RegroupHelper.lean` into its own unit (chapter intro comment preserved).

## Strategy-modifying findings
None. The rewrite executes the strategy decision already made (commit to direct-on-sections
Stacks 02KH part 2 / `lemma-affine-base-change`); it surfaced no new strategy-level issue.
