# Strategy-critic directive (iter-120)

Read STRATEGY.md verbatim. Verify the strategy is sound, addresses the
single new finding from iter-119, and converges to the declared
end-state.

## Inputs

- `.archon/STRATEGY.md` (verbatim below)
- `references/summary.md` (verbatim below)
- Blueprint summary: chapter titles + one-line topic, all 9 active chapters
- Project goal (from `references/challenge.lean`)

You MUST NOT read iter sidecars, task_results, task_pending.md,
task_done.md, PROGRESS.md, or per-iter narrative.

---

## STRATEGY.md (verbatim)

```
# Strategy

## Project goal

Formalize the nine protected declarations of Christian Merten's Jacobian
challenge (`references/challenge.lean`):

| File | Declaration |
|---|---|
| `Genus.lean` | `AlgebraicGeometry.genus` |
| `Jacobian.lean` | `AlgebraicGeometry.Jacobian`, `Jacobian.instGrpObj`, `Jacobian.smoothOfRelativeDimension_genus`, `Jacobian.instIsProper`, `Jacobian.instGeometricallyIrreducible` |
| `AbelJacobi.lean` | `Jacobian.ofCurve`, `Jacobian.comp_ofCurve`, `Jacobian.exists_unique_ofCurve_comp` |

All nine signatures are frozen by the mathematician; agents are read-only on them.

## End-state

The project ships with **exactly one inline `sorry`**: the existence
hypothesis `nonempty_jacobianWitness` at `Jacobian.lean:179`. Every other
declaration is closed; no axioms; the umbrella `AlgebraicJacobian.lean`
compiles clean.

`nonempty_jacobianWitness` packages the existence of an Albanese variety
of a smooth proper geometrically irreducible curve `C` over a field `k`.
It is a true theorem; the proof requires Mathlib infrastructure that is
not in `b80f227`:
- Hilbert / Quot schemes (for the FGA route via `Pic^0_{C/k}`),
- Symmetric powers of schemes and finite-group scheme quotients (for
  the `Sym^g(C) → Pic^g` Stein-factorisation route),
- `Hom(ℙ¹_k, A) = A(k)` rigidity for morphisms to abelian varieties
  (for the genus-0 sub-case absorbed into the same witness).

This is the single explicit foundational hypothesis the project ships
against.

## What ships unconditionally

Every `.lean` file below compiles end-to-end with no `sorryAx` in its
axiom chain once Phase C closes:
- Rigidity.lean / Genus.lean / Cohomology/SheafCompose.lean /
  StructureSheafAb.lean / StructureSheafModuleK.lean /
  MayerVietorisCore.lean / MayerVietorisCover.lean / Differentials.lean

## Forward plan

### Phase C — Close the forward implication on `Differentials.lean`

Close `Differentials.lean:74` `smooth_locally_free_omega`:

- **Strategy**: Given `SmoothOfRelativeDimension n f` and a point
  `x ∈ X`, produce an affine chart `U ⊆ X` containing `x` (with image
  inside an affine open `V ⊆ S`) such that the induced algebra map
  `A := Γ(S, V) → B := Γ(X, U)` satisfies
  `IsStandardSmoothOfRelativeDimension n A B`. On that chart, derive:
  - `Module.Free B Ω[B⁄A]`
  - `Module.rank B Ω[B⁄A] = n`
  - Bridge to `(relativeDifferentialsPresheaf f).presheaf.obj (.op U)`
    via `relativeDifferentialsPresheaf_obj_kaehler` (rfl).

  Estimated cost: 1–3 prover iters / ~100–300 LOC.
```

(STRATEGY.md continues with "Soundness rules" + "Mathlib gaps" sections.)

---

## References summary (verbatim)

```
# References

| File | Description |
| ---- | ----------- |
| `challenge.lean` | Original AI challenge file by Christian Merten — the formal statement of the missing definitions and theorems for the Jacobian of an algebraic curve. The Lean skeleton in `AlgebraicJacobian/` is a decomposition of this file; signatures here are authoritative. |
```

---

## Blueprint chapter index (one-line topic per chapter)

- `Cohomology_SheafCompose.tex` — sheaf composition / forgetful instance.
- `Cohomology_StructureSheafAb.tex` — `toAbSheaf`, ab-group structure sheaf.
- `Cohomology_StructureSheafModuleK.tex` — module-over-k structure sheaf
  + HModule / cohomology / Čech complex.
- `Cohomology_MayerVietoris.tex` — Mayer-Vietoris LES.
- `Differentials.tex` — relative cotangent presheaf
  `relativeDifferentialsPresheaf`; forward smoothness criterion.
- `Genus.tex` — `genus C := finrank k (HModule k (toModuleKSheaf C) 1)`.
- `Jacobian.tex` — Albanese-construction blueprint;
  `nonempty_jacobianWitness` hypothesis with 3-route decomposition.
- `Rigidity.lean` — Mumford rigidity for pointed proper smooth morphisms.
- `AbelJacobi.tex` — Abel-Jacobi morphism + universal-property API
  consuming the `JacobianWitness` bundle.

---

## Specific question for the iter-120 strategy-critic

The iter-119 prover lane on `smooth_locally_free_omega` returned
PARTIAL with a specific finding: the blueprint Step-5 claim that
`M_U = (relativeDifferentialsPresheaf f).presheaf.obj (.op V)` is
*"definitionally equal"* to `Ω[B/A]` is wrong. In fact
`relativeDifferentialsPresheaf_obj_kaehler` identifies `M_U` with the
Kähler module of a map whose **source** is the colimit ring
`A' := ((TopCat.Presheaf.pullback CommRingCat f.base).obj S.presheaf).obj (.op V₀)`
= `colim_{f V₀ ⊆ W ⊆ S} S.presheaf.obj W` — strictly larger than
`Γ(S, U₀)` in general.

The iter-119 prover proposed a helper lemma `relativeDifferentialsPresheaf_iso_kaehler_appLE`
returning a `Γ(X, V)`-linear iso between the two Kähler modules under
`IsAffineOpen U / IsAffineOpen V / V ≤ f⁻¹ U`.

Strategy-level question 1: **Is the helper lemma even mathematically
true under the affine hypotheses?** Sub-questions:
- The map `A → A' → B = Γ(X, V)` has image differentials
  `dA' ⊃ dA` in `Ω[B/A]`. For the iso to hold, `dA' ⊂ image(dA)` in
  `Ω[B/A]` (so the surjection `Ω[B/A] → Ω[B/A'] = Ω[B/A]/dA'` has
  trivial kernel).
- Equivalently: is `Ω[A'/A] = 0`? In the affine case `A = Γ(S, U)` and
  `A' = colim of restrictions` — is this colimit always a localization
  of `A` (in which case `Ω[A'/A] = 0`)?
- Or is there a different framing that makes the iso obviously true?

Strategy-level question 2: **Should the project refactor
`relativeDifferentialsPresheaf` to use the SHEAFIFIED inverse image
instead of the presheaf-level `TopCat.Presheaf.pullback`?** The
sheafified version DOES collapse to `Γ(S, U)` on affine charts inside
affines (standard "sheafification = adic on a basis" argument), at the
cost of:
- Refactoring the definition of `relativeDifferentialsPresheaf`.
- Re-proving `relativeDifferentialsPresheaf_obj_kaehler` (which would
  no longer be `rfl`).
- Verifying that the resulting `Ω` is still the right object for
  downstream consumers — which, since `smooth_locally_free_omega` is
  not consumed by any other declaration in the live project, is a
  cheap question.

Strategy-level question 3: **Alternative: restate
`smooth_locally_free_omega` to use the appLE algebra Kähler module
directly**, eliminating the bridge entirely. The statement would
mention `Ω[Γ(X,V) ⁄ Γ(S,U)]` and the standard-smoothness chart
data; the project-local `relativeDifferentialsPresheaf_obj_kaehler`
becomes unused for this theorem. Cost: signature refactor of
`smooth_locally_free_omega` (NOT protected; iter-118 refactor was
similar). Benefit: removes the colimit-source issue at the statement
level, replacing it with a direct `Module.Free B Ω[B/A]` conclusion.

## What you should deliver

A SOUND/CHALLENGE/REJECT verdict on the current strategy, with explicit
attention to:

1. The bridge-helper soundness question (Q1 above) — your assessment of
   whether the proposed helper lemma is mathematically true.
2. The three structural options (helper / sheafify-refactor /
   statement-refactor) — your recommendation if Q1's answer is "true,
   but provable only via deep cofinality" vs "true and easy" vs "false
   as stated".
3. The strategy's broader soundness: does the rest of the path to the
   end-state still hold up?

If you recommend ALIGN/REFACTOR, name the specific change to STRATEGY.md.
