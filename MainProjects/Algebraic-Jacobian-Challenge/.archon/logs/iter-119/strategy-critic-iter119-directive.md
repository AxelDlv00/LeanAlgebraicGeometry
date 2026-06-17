# Strategy Critic Directive

## Slug
iter119

## Project goal

The project formalizes Christian Merten's Jacobian challenge from
`references/challenge.lean`. The final deliverable is the nine
protected declarations listed under `archon-protected.yaml`:

- `AlgebraicGeometry.genus` (Genus.lean)
- `AlgebraicGeometry.Jacobian`, `Jacobian.instGrpObj`,
  `Jacobian.smoothOfRelativeDimension_genus`,
  `Jacobian.instIsProper`,
  `Jacobian.instGeometricallyIrreducible` (Jacobian.lean)
- `Jacobian.ofCurve`, `Jacobian.comp_ofCurve`,
  `Jacobian.exists_unique_ofCurve_comp` (AbelJacobi.lean)

All nine signatures are frozen by the mathematician; agents must
not rename, retype, or reorder arguments.

## Strategy under review

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

All nine signatures are frozen by the mathematician; agents are read-only
on them.

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
against. The blueprint chapter `Jacobian.tex` documents all three
classical routes and the Mathlib infrastructure each requires; closure
is a project-external Mathlib-build-out, not a within-loop autonomous
task.

## What ships unconditionally

Every `.lean` file below compiles end-to-end with no `sorryAx` in its
axiom chain once Phase C closes:

- `Rigidity.lean` — Mumford rigidity for pointed proper smooth morphisms.
- `Genus.lean` — `genus C := Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)`.
- `Cohomology/SheafCompose.lean` / `StructureSheafAb.lean` /
  `StructureSheafModuleK.lean` / `MayerVietorisCore.lean` /
  `MayerVietorisCover.lean` — the Čech / Mayer–Vietoris infrastructure
  actually consumed by `Genus.lean`.
- `Differentials.lean` — relative Kähler differential *presheaf*
  `relativeDifferentialsPresheaf` + the section-level identification
  with the algebra-side Kähler module + the **forward direction** of
  the smoothness-implies-locally-free-Ω criterion on affine charts.
  (See § "Soundness rules" for why the iff form was demoted to a
  forward implication.)

The protected `genus` and `Rigidity` are unconditional.

## What ships against the single witness

The protected `Jacobian`-arc declarations (`Jacobian.lean` + `AbelJacobi.lean`)
all `lean_verify` to `sorryAx` rooted at `Jacobian.lean:179`. This is the
intended state: the project delivers the framework around the Albanese
variety (group-object structure, smoothness of relative dimension `g`,
properness, geometric irreducibility, the Abel–Jacobi map, and the
universal property) conditional on the witness existence.

## Forward plan

The strategy is finished. The remaining work is execution against the
inventory below.

### Phase C — Close the forward implication on `Differentials.lean`

After the iter-118 refactor lands (signature corrected from iff to
forward implication; blueprint chapter updated), the only inline
sorries remaining are:

- `Differentials.lean:74` `smooth_locally_free_omega` (presheaf form,
  forward implication only).
- `Jacobian.lean:179` `nonempty_jacobianWitness` (the single explicit
  foundational hypothesis; intended end-state).

Close `Differentials.lean:74`:

- **Strategy.** Given `SmoothOfRelativeDimension n f` and a point
  `x ∈ X`, produce an affine chart `U ⊆ X` containing `x` (with image
  inside an affine open `V ⊆ S`) such that the induced algebra map
  `A := Γ(S, V) → B := Γ(X, U)` satisfies
  `IsStandardSmoothOfRelativeDimension n A B`. The chart exists by
  the `mk_iff` of `SmoothOfRelativeDimension`. On that chart, derive:
  - `Module.Free B Ω[B⁄A]` via `IsStandardSmoothOfRelativeDimension.isStandardSmooth`
    followed by the instance `IsStandardSmooth.free_kaehlerDifferential`.
  - `Module.rank B Ω[B⁄A] = n` via `IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`.
  - Bridge to the project's `(relativeDifferentialsPresheaf f).presheaf.obj (.op U)`
    via the project-local `relativeDifferentialsPresheaf_obj_kaehler`
    (definitional, body `rfl`).

  **Closing-lemma slate** (all `[verified]` Mathlib b80f227):
  - `AlgebraicGeometry.smoothOfRelativeDimension_iff` (auto-generated by
    `@[mk_iff]`; `Mathlib.AlgebraicGeometry.Morphisms.Smooth`).
  - `RingHom.IsStandardSmoothOfRelativeDimension.toAlgebra` (bridge from
    the ring-hom-typed hypothesis produced by `mk_iff` to the
    `Algebra.*` Kähler API; `Mathlib.RingTheory.RingHom.StandardSmooth`).
  - `Algebra.IsStandardSmoothOfRelativeDimension.isStandardSmooth`
    (`Mathlib.RingTheory.Smooth.StandardSmooth`).
  - `Algebra.IsStandardSmooth.free_kaehlerDifferential` (instance;
    `Mathlib.RingTheory.Smooth.StandardSmoothCotangent`).
  - `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`
    (same file).
  - `AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf_obj_kaehler`
    (project-local).

  Estimated cost: 1–3 prover iters / ~100–300 LOC.

After Phase C completes, the project is in its end-state with exactly
the one named hypothesis `nonempty_jacobianWitness`.

## Soundness rules

The project's signatures are mathematically correct (verified by
`lean-auditor-iter117`). One **correctness correction** is applied in
iter-118 and folded into the strategy here:

- The iter-117 refactor of `Differentials.lean:74` left the signature
  in iff form (`SmoothOfRelativeDimension n f ↔ ∀ x, ∃ U, Ω(U) free of
  rank n`). The iff is **mathematically false** in general: the
  converse direction needs deformation-theoretic input
  (`Subsingleton (Algebra.H1Cotangent A B)` on each affine chart),
  which is not implied by `LocallyOfFinitePresentation f` + local
  freeness of Ω. Counterexample: `Spec k → Spec k[t]` via `t ↦ 0` is
  locally of finite presentation, has `Ω = 0` (locally free of rank 0
  everywhere), and is **not** smooth (closed immersion of a non-open
  point; not flat). The iter-118 refactor demotes the iff to a forward
  implication (`SmoothOfRelativeDimension n f → ∀ x, ∃ U, ...`); the
  converse is documented as a Mathlib gap. This is **not** a
  weakening of a true theorem — it is the correct version of the
  theorem.

`nonempty_jacobianWitness` is the project's one named existence
hypothesis. Its statement is true; its proof is project-external. No
other inline `sorry` survives the trim.

## Mathlib gaps left for whoever picks up the project

Two Mathlib infrastructure builds would unlock the remaining deferred
content:

1. **Hilbert / Quot schemes + FGA representability** (Route A; full
   coverage for all genera), OR
   **symmetric powers of schemes + finite-group scheme quotients +
   Stein factorisation** (Route B; full coverage for all genera).
   Either of these independently unlocks `nonempty_jacobianWitness`
   for any genus.

   **The rigidity `Hom(ℙ¹_k, A) = A(k)` plus the genus-0 identification
   `C ≅ ℙ¹_k`** (Route C) handles only the genus-0 sub-case (and
   requires `C(k) ≠ ∅`, otherwise `C` is a Brauer–Severi variety
   rather than `ℙ¹_k`); it is **complementary** to A and B, not
   interchangeable. See `blueprint/src/chapters/Jacobian.tex` §
   "Existence of an Albanese variety" for the per-route sub-step
   list with Mathlib gap-map.

   **Upstream Mathlib status**: as of `b80f227` no in-flight
   upstream PR addresses the Hilbert/Quot or symmetric-powers
   pieces; the gap is currently *unwatched* rather than
   tracked-but-unmerged. Future Mathlib bumps may surface
   contributions worth re-checking.

2. **The converse direction of `smooth_locally_free_omega`**.
   Mathlib's chain
   `Algebra.IsStandardSmooth.of_basis_kaehlerDifferential`
   (`Mathlib.RingTheory.Smooth.StandardSmoothOfFree`) requires
   `[FinitePresentation R S]` + `Subsingleton (Algebra.H1Cotangent R S)`
   + a basis of `Ω[S⁄R]` whose range lies in `Set.range (D R S)`.
   None of these three follows from local freeness + finite
   presentation alone; they together encode the formal-smoothness /
   deformation-theoretic content of smoothness. The converse direction
   is therefore disclosed in the blueprint chapter `Differentials.tex`
   as out-of-autonomous-loop scope and is not part of the project's
   active sorry inventory.

None of these are on the autonomous loop's task list; they are
disclosed here as the Mathlib build-outs that would re-enable each
piece of currently-deferred content.
```

## References index

```
| File | Description |
| ---- | ----------- |
| `challenge.lean` | Original AI challenge file by Christian Merten — the formal statement of the missing definitions and theorems for the Jacobian of an algebraic curve. The Lean skeleton in `AlgebraicJacobian/` is a decomposition of this file; signatures here are authoritative. |
```

## Blueprint summary

| Chapter | Topic |
|---|---|
| `Cohomology_SheafCompose.tex` | `HasSheafCompose` instance for `forget` from CommRing to AddCommGrp |
| `Cohomology_StructureSheafAb.tex` | The AddCommGrp-valued structure sheaf and HasExt / HasSheafify instances |
| `Cohomology_StructureSheafModuleK.tex` | `ModuleCat k`-valued structure sheaf, `HModule`, `HModule'`, Čech cohomology, `IsAffineHModuleVanishing` / `IsCechAcyclicCover` carrier classes |
| `Cohomology_MayerVietoris.tex` | Mayer–Vietoris LES on `HModule`, finrank specialisation, scaffolding classes `HasCechToHModuleIso` / `HasAffineCechAcyclicCover` |
| `Differentials.tex` | Relative cotangent presheaf, section-level Kähler identification, **forward direction** of smoothness ⇒ Ω locally free (Phase C target; iter-119 prover lane) |
| `Genus.tex` | `genus C := finrank_k (Scheme.HModule k (toModuleKSheaf C) 1)` |
| `Jacobian.tex` | `IsAlbanese` predicate, `JacobianWitness` 7-field bundle, `nonempty_jacobianWitness` (single foundational hypothesis), four `Jacobian.*` projections |
| `Rigidity.tex` | Mumford rigidity `GrpObj.eq_of_eqOnOpen` for pointed proper smooth morphisms |
| `AbelJacobi.tex` | `Jacobian.{ofCurve, comp_ofCurve, exists_unique_ofCurve_comp}` projections from `jacobianWitness` |

The blueprint also contains `Modules_Monoidal.tex`, `Picard_*.tex` on
disk but those chapters are NOT in `blueprint/src/content.tex`'s active
include list (orphan files from iter-117 trim, not part of the project's
formal target). Do not audit them.

## Prior critique status

You were dispatched in iter-118 (slug `iter118`) and returned:

- **Phase C (forward implication on Differentials)** — SOUND. You
  recommended adding `RingHom.IsStandardSmoothOfRelativeDimension.toAlgebra`
  to the closing-lemma slate. **Addressed**: this is now in the slate.
- **iff → forward demotion** — SOUND. Counterexample valid; demotion
  is a correction.
- **End-state with one `sorry`** — CHALLENGE proposing to convert
  `nonempty_jacobianWitness` to an `axiom`. The plan agent's rebuttal
  (per the hard rule `.archon/prompts/plan.md` L43 "NEVER propose
  adding new axioms") is recorded in `iter/iter-118/plan.md`. **Live
  if you still disagree; otherwise treat as resolved by rebuttal.**
- **Route C scope ambiguity** — CHALLENGE on whether genus-0 +
  rigidity (Route C) is full coverage. **Addressed**: STRATEGY.md now
  describes Route C as "complementary, not interchangeable" with the
  `C(k) ≠ ∅` caveat. Treat as resolved.
- **Upstream Mathlib status disclosure** — CHALLENGE on whether the
  Hilbert/Quot and symmetric-powers gaps are tracked or unwatched.
  **Addressed**: STRATEGY.md states "currently unwatched" as of
  `b80f227`. Treat as resolved.

Please re-verify the Phase C closing slate against the current
`b80f227` snapshot (the planner ran lean_run_code spot checks but
your fresh-eyes confirmation matters) and re-render your end-state
verdict given the post-iter-118 strategy.
