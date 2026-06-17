# AlgebraicJacobian/Differentials.lean

## smooth_locally_free_omega (line 91, body L99–L109)

### Attempt 1 — Phase C algebra-Kähler closure (iter-120)
- **Approach**: Followed the verified 6-step Mathlib chain from
  `PROGRESS.md` and `Differentials.tex § thm:smooth_locally_free_omega`:
  1. Introduce `x : X`; destructure the witness from the class field
     `SmoothOfRelativeDimension.exists_isStandardSmoothOfRelativeDimension`
     (the `@[mk_iff]` generated `smoothOfRelativeDimension_iff` is
     equivalent — but the field accessor is one step shorter and
     keeps the binder order the existential uses verbatim).
  2. `refine ⟨U, V, e, hxV, hU, hV, ?_, ?_⟩` opens two subgoals: the
     `Module.Free` conjunct and the `Module.rank … = n` conjunct.
  3. Inside each subgoal `<;> ·`:
     - `algebraize [CommRingCat.Hom.hom (Scheme.Hom.appLE f U V e)]`
       installs `Algebra Γ(S, U) Γ(X, V)` and
       `Algebra.IsStandardSmoothOfRelativeDimension n Γ(S, U) Γ(X, V)`
       via the `@[algebraize RingHom.IsStandardSmoothOfRelativeDimension.toAlgebra]`
       attribute. The same `letI` shape is what's in the goal, so
       the algebra instance produced by `algebraize` matches the one
       in the conclusion definitionally — no bridging or transport
       step is needed.
     - `haveI : Algebra.IsStandardSmooth … := Algebra.IsStandardSmoothOfRelativeDimension.isStandardSmooth n`
       supplies the typeclass for Step 3.
     - `haveI : Nonempty V := ⟨⟨x, hxV⟩⟩` discharges the side
       condition of `Scheme.component_nontrivial`, which then fires
       as an instance to give `Nontrivial Γ(X, V)`.
     - `first | exact … free_kaehlerDifferential | exact … rank_kaehlerDifferential n`
       picks the relevant closing lemma in each branch.
- **Result**: **RESOLVED**. Body is 11 LOC, file compiles with zero
  warnings (no `sorry`, no errors). Axiom check on
  `AlgebraicGeometry.Scheme.smooth_locally_free_omega`:
  `propext, Classical.choice, Quot.sound` — the three standard Lean
  axioms, no custom or non-constructive additions.
- **Key insight**: The iter-120 signature refactor to algebra-Kähler
  form eliminated the iter-119 bridge gap entirely. The `letI` in the
  existential binder is the same algebra structure `algebraize`
  produces from the appLE ring hom, so the typeclasses synthesised in
  the proof body unify with those in the conclusion without
  reconciliation.

### Why the closure is structural (not coincidental)
- The `mk_iff`-generated lemma and the class-field accessor give the
  same data; using the field is one fewer rewrite step.
- The shared-tactic shape `<;> ·` works because **both** conjuncts
  require the exact same prelude (algebraize, isStandardSmooth,
  nonempty, nontrivial), and only the final closing lemma differs.
  This is reflected in the blueprint (Steps 1–4.5 are shared, Steps
  3 and 4 are the two endpoints).

### Mathlib lemmas used
- **Used (closed the proof)**:
  - `AlgebraicGeometry.SmoothOfRelativeDimension.exists_isStandardSmoothOfRelativeDimension`
    (class field accessor; equivalent to `smoothOfRelativeDimension_iff`).
  - `algebraize` tactic with `@[algebraize RingHom.IsStandardSmoothOfRelativeDimension.toAlgebra]`
    on `RingHom.IsStandardSmoothOfRelativeDimension`.
  - `Algebra.IsStandardSmoothOfRelativeDimension.isStandardSmooth`
    (`Mathlib.RingTheory.Smooth.StandardSmooth`).
  - `Algebra.IsStandardSmooth.free_kaehlerDifferential`
    (instance; `Mathlib.RingTheory.Smooth.StandardSmoothCotangent:301`).
  - `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`
    (`Mathlib.RingTheory.Smooth.StandardSmoothCotangent:313`).
  - `AlgebraicGeometry.Scheme.component_nontrivial` (instance fires
    automatically once `Nonempty V` is supplied).

## Outcome summary

- **Status**: **RESOLVED** (COMPLETE).
- **Sorry count delta on file**: 1 → 0.
- **No new axioms** introduced; `lean_verify` shows only the three
  standard Lean axioms (`propext`, `Classical.choice`, `Quot.sound`).
- **No protected signatures touched**: `smooth_locally_free_omega`
  is non-protected; the signature was the iter-120 plan-phase refactor
  to algebra-Kähler form (already landed before this prover lane).
- **File compiles cleanly**: `lean_diagnostic_messages` returns an
  empty diagnostic list; `lake env lean AlgebraicJacobian/Differentials.lean`
  produces no output.
- **Blueprint marker assessment**: The `\leanok` markers on the
  statement block (`Differentials.tex:48`) and the proof block
  (`Differentials.tex:62`) are correct as written. The `sync_leanok`
  phase between prover and review will confirm.

## Watch-criterion mapping (per progress-critic-iter120)
- iter-120 prover lane returns COMPLETE → criterion (1) fires:
  CONVERGING ratified; advance stage `prover` → `polish`. The
  Differentials.lean route is closed; only the foundational sorry at
  `Jacobian.lean:179` `nonempty_jacobianWitness` remains (intended
  end-state, off-limits).

## Next steps (handoff to plan / polish phase)
- Project sorry count after this iter: **1** (`Jacobian.lean:179`,
  intended end-state).
- Polish-stage backlog carried forward from session_118 / session_119:
  dead `IsAffineHModuleHomFinite` chain in `StructureSheafModuleK.lean`;
  scaffolding-class decision on `MayerVietorisCover.lean`; redundant
  typeclass args on `Rigidity.lean` (per `PROGRESS.md` watch criterion 1).
- Blueprint Section 3 `sec:bridge-out-of-scope` (the
  `Ω[B/A] ≃ Ω[B/A_colim]` bridge documented but not formalised) and
  Section 4 `sec:converse-out-of-scope` (the false converse with
  counterexample) remain as informational appendices; no Lean work
  required.
