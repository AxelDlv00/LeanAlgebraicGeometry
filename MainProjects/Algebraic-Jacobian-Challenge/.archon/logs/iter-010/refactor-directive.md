<!-- Archived from REFACTOR_DIRECTIVE.md at 2026-05-07T08:46:04Z -->
<!-- This is the directive the plan agent wrote for the refactor agent in this iteration. -->

# Refactor Directive — iter-010

## Summary

Append a single new declaration `AlgebraicGeometry.Scheme.HModule_zero_linearEquiv` to `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean`, body `:= sorry`, with the exact signature in §3.1 below and the doc comment in §3.2. **No other file is touched.** The iter-010 prover round will close the new sorry with the probe-confirmed one-line body `Abelian.Ext.linearEquiv₀` (§4).

## 1. Why this is needed

Iter-009 landed `AlgebraicGeometry.Scheme.HModule` (`Cohomology/StructureSheafModuleK.lean` L185–L190): the parallel `Sheaf.H` for `ModuleCat k`-valued sheaves on a Grothendieck site. The cohomology groups `HModule k F n` are now well-defined for every `n : ℕ`, with `Module k (HModule k F n)` and `AddCommGroup (HModule k F n)` automatically synthesised through the `noncomputable abbrev`'s reducibility plus `CategoryTheory.Abelian.Ext.instModule`.

The next algebraic preliminary toward Phase A step 6 (Serre finiteness) is the identification of the degree-zero piece `HModule k F 0` with a Hom group: this is the bridge from sheaf cohomology to representable Hom-functors, and on a connected proper `k`-curve eventually rewrites `H⁰(C, O_C)` as `Γ(C, O_C)` viewed as a `k`-module. Iter-010 plan-agent `lean_run_code` probe confirms a single one-liner closure exists via Mathlib's existing `CategoryTheory.Abelian.Ext.linearEquiv₀` (file `Mathlib/Algebra/Homology/DerivedCategory/Ext/Linear.lean`):

```lean
noncomputable example
    (k : Type) [Field k]
    {C : Type} [Category.{0, 0} C] {J : GrothendieckTopology C}
    [HasSheafify J (ModuleCat.{0} k)] [HasExt (Sheaf J (ModuleCat.{0} k))]
    (F : Sheaf J (ModuleCat.{0} k)) :
    HModule k F 0 ≃ₗ[k] ((constantSheaf J (ModuleCat.{0} k)).obj (ModuleCat.of k k) ⟶ F) :=
  Abelian.Ext.linearEquiv₀
-- Returned: {success: true, diagnostics: []}
```

**Why an `H⁰` bridge and not `HModule_forget`.** The `recommendations.md` from session 15 proposed an alternative polish lemma `HModule_forget` matching `forget₂ (ModuleCat k) AddCommGrpCat`-image of `HModule k F n` against `Sheaf.H ((sheafCompose _ (forget₂ …)).obj F) n`. Iter-010 plan-agent re-read of Mathlib `CategoryTheory/Sites/SheafCohomology/Basic.lean` reveals `Sheaf.H F n := Ext ((constantSheaf J _).obj (AddCommGrpCat.of (ULift ℤ))) F n` — the unit is `ULift ℤ`, whereas `HModule` uses `ModuleCat.of k k`. The two unit objects are unrelated under `forget₂` (the former forgets to `AddCommGrpCat.of k`, not `AddCommGrpCat.of (ULift ℤ)`). The two cohomology theories are related by a change-of-coefficient comparison map, but it is generically not an isomorphism — so `HModule_forget` as proposed is not a `rfl`/single-application closure. The `H⁰` bridge IS a one-liner via `linearEquiv₀` and IS the algebraic fact downstream Phase A step 6 work actually needs.

## 2. Compatibility with `archon-protected.yaml`

The protected file is unchanged. No protected declaration is renamed, re-typed, reordered, moved, or removed. The new declaration `AlgebraicGeometry.Scheme.HModule_zero_linearEquiv` is in the unprotected `Cohomology/StructureSheafModuleK.lean` and is not in `archon-protected.yaml`.

## 3. Concrete instructions

### 3.1 New declaration (verbatim)

Append the following to `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean`, immediately after the existing `HModule` declaration (currently L185–L190) and before `end AlgebraicGeometry.Scheme` (currently L192). The new declaration must reuse the existing `namespace AlgebraicGeometry.Scheme` and the existing `open CategoryTheory Limits TopologicalSpace AlgebraicGeometry`; do not introduce a fresh namespace or `open`.

```lean
/-- Phase A step 6 algebraic bridge (iter-010 scaffold): the $k$-linear
identification of `HModule k F 0` with the Hom group from the constant
sheaf at `ModuleCat.of k k`. Mathlib provides
`CategoryTheory.Abelian.Ext.linearEquiv₀ : Ext X Y 0 ≃ₗ[R] (X ⟶ Y)` in any
`Linear R`-enriched abelian category; specialised to the `Linear k`
enrichment of `Sheaf J (ModuleCat.{u} k)` (auto-inferable from
`HasSheafify J (ModuleCat.{u} k)`), this collapses `HModule k F 0` to a
`k`-linear Hom group. The closure body is `Abelian.Ext.linearEquiv₀`;
probe-confirmed one-liner (iter-010 plan-agent). Used downstream to
identify `H⁰(C, toModuleKSheaf C)` with `Γ(C, O_C)` viewed as a
`k`-module on a connected proper `k`-curve. -/
noncomputable def HModule_zero_linearEquiv
    (k : Type u) [Field k]
    {C : Type v} [Category.{u, v} C] {J : GrothendieckTopology C}
    [HasSheafify J (ModuleCat.{u} k)] [HasExt (Sheaf J (ModuleCat.{u} k))]
    (F : Sheaf J (ModuleCat.{u} k)) :
    HModule k F 0 ≃ₗ[k]
      ((constantSheaf J (ModuleCat.{u} k)).obj (ModuleCat.of k k) ⟶ F) :=
  sorry
```

The signature mirrors the iter-009 `HModule` signature exactly modulo (i) `def` instead of `abbrev` (the polish lemma needs no instance-transparency), (ii) the dropped `n : ℕ` argument (specialised to `n = 0`), and (iii) the `≃ₗ[k]` codomain.

### 3.2 Refactor agent's checklist

- **Append-only edit.** Insert at the end of the file's current `namespace AlgebraicGeometry.Scheme`. Do not move or rename any existing declaration. Do not change any other file.
- **Sorry count.** Project sorry count must increase from 10 to 11; the new sorry is on the body of `HModule_zero_linearEquiv` (the line containing `sorry` after `:=`). All other sorries are unchanged (9 protected + 1 deferred `representable`).
- **Diagnostic check.** After the edit, `lean_diagnostic_messages` on the file must return exactly one warning (`declaration uses sorry`) at the new declaration's opener line, no errors. All prior declarations still compile.
- **`archon-protected.yaml` left alone.** No path / name change. No protected declaration moved.

### 3.3 Sanity-check probe (refactor agent runs)

After scaffolding, the refactor agent should run a `lean_run_code` probe of the prover's intended one-liner closure body, to confirm it remains drop-in:

```lean
import AlgebraicJacobian.Cohomology.StructureSheafModuleK

open CategoryTheory AlgebraicGeometry Scheme

-- Sanity probe: the iter-010 prover round's intended closure body
noncomputable example
    (k : Type) [Field k]
    {C : Type} [Category.{0, 0} C] {J : GrothendieckTopology C}
    [HasSheafify J (ModuleCat.{0} k)] [HasExt (Sheaf J (ModuleCat.{0} k))]
    (F : Sheaf J (ModuleCat.{0} k)) :
    HModule k F 0 ≃ₗ[k] ((constantSheaf J (ModuleCat.{0} k)).obj (ModuleCat.of k k) ⟶ F) :=
  Abelian.Ext.linearEquiv₀
```

Expected: `{success: true, diagnostics: []}`. If the probe fails (e.g. universe issues, name shadowing in the in-namespace context), document the failure and the suggested adjustment in `task_results/refactor.md` so the iter-010 prover round can adapt.

## 4. Probe-confirmed closure body (for the iter-010 prover round)

```lean
Abelian.Ext.linearEquiv₀
```

The optional cosmetic prefix-drop on `CategoryTheory.` is authorised — the file's existing `open CategoryTheory` directive at L38 makes `Abelian.Ext.linearEquiv₀` resolve unambiguously.

## 5. Forbidden shortcuts (re-emphasised; full list in `task_pending.md`)

- Do not change `noncomputable def` to `def` or `abbrev` here. (`def` is correct — no instance-transparency needed.)
- Do not introduce vacuous closures (`PUnit`, `Empty`, etc.). They satisfy the type but are not the natural identification and break downstream `Module.Finite k` transport.
- Do not introduce new `axiom` declarations.
- Do not scaffold a polish-shape `HModule_forget` (`forget₂ HModule ↔ Sheaf.H ((sheafCompose _ (forget₂)).obj F)`) — the proposed comparison is not a one-liner; supersedes the over-optimistic session-15 `recommendations.md` proposal.
- Do not assign or modify any of the 9 protected sorries in `Genus.lean`, `Jacobian.lean`, `AbelJacobi.lean`. Do not modify `PicardFunctor.representable`.

## 6. Anticipated post-refactor / post-prover state

- **Post-refactor:** sorry count 10 → 11. `lean_diagnostic_messages` on `Cohomology/StructureSheafModuleK.lean` returns exactly one `declaration uses sorry` warning at the new declaration's opener line; all other declarations compile.
- **Post-prover (iter-010):** sorry count 11 → 10 (back to baseline: 9 protected + 1 deferred `representable`). `lean_verify` on `AlgebraicGeometry.Scheme.HModule_zero_linearEquiv` returns only standard kernel axioms (`propext`, `Classical.choice`, `Quot.sound`).
- **Blueprint:** chapter `Cohomology_StructureSheafModuleK.tex` already carries the new section "The H⁰ algebraic bridge" with the `def:Scheme_HModule_zero_linearEquiv` block (added by the iter-010 plan-agent this pass). The `\leanok` markers on the statement and proof blocks are awaited from the iter-010 review session, after the prover round closes the sorry.
- **Track 1 (Phase A step 5/6 → step 6 algebraic preliminaries) infrastructure complete after iter-010.** The next track-defining work is iter-011+ Path-2 Čech / Serre finiteness scaffolding (multi-iteration).
