# Blueprint Reviewer Directive

## Slug
iter121

## Strategy snapshot

The project formalizes Christian Merten's Jacobian challenge: nine
protected declarations defining the Jacobian of a smooth proper
geometrically irreducible curve over a field and its universal Abel–
Jacobi mapping property.

**Iter-121 strategic pivot (per user directive).** Prior iters operated
under a "ship with one inline `sorry`" framing in which Mathlib gaps
were documented but deferred (the bridge between the algebra-Kähler
form and the presheaf form; the witness existence `nonempty_jacobianWitness`;
etc.). Iter-121 drops this framing. The project's autonomous loop now
operates as a Mathlib contributor, filling each missing piece in-tree
at Mathlib-merge quality. The end-state is **zero inline `sorry`** in
the project.

This puts the following items on the active roadmap:

- **M1 (this iter's prover target).** Bridge: presheaf-section module
  of `relativeDifferentialsPresheaf f` at an affine `V ⊆ X` is
  canonically `B`-linearly isomorphic to the appLE-algebra Kähler
  module `Ω[B ⁄ A]` where `A := Γ(S, U)`, `B := Γ(X, V)`. New
  declaration `relativeDifferentialsPresheaf_iso_kaehler_appLE` to be
  introduced in `Differentials.lean`. Blueprint-side support: a new
  section `\sec{Bridge: presheaf form ↔ algebra-Kähler form on an
  affine chart (milestone M1)}` was added to
  `blueprint/src/chapters/Differentials.tex` this iter, replacing the
  prior `sec:bridge-out-of-scope` remark with proper in-scope theorems
  + auxiliary lemmas (`appLE_isLocalization`,
  `kaehler_localization_subsingleton`,
  `kaehler_quotient_localization_iso`). Please audit the new section
  for completeness/correctness/proof-detail-depth.

- **M2 (future iters).** Genus-0 witness via rigidity (Route C). The
  blueprint chapter `Jacobian.tex` covers Route C in its "Existence of
  an Albanese variety" section. Please audit whether the Route C
  sub-steps (C.1: `C ≅ ℙ¹_k`; C.2: rigidity `Hom(ℙ¹_k, A) = A(k)`;
  C.3: trivial witness for `Spec k`) are adequately detailed for a
  prover to start on M2.a (rigidity) without further blueprint
  expansion.

- **M3 (future iters).** General-genus witness via Picard scheme
  (Route A) or symmetric powers + Stein factorisation (Route B). The
  blueprint chapter `Jacobian.tex` already documents both routes with
  sub-step-level Mathlib-gap inventory; please confirm the level of
  detail is adequate for the iter that eventually picks a route.

## Routes

- **M1 (bridge)** — added this iter to `Differentials.tex`. Concrete
  scope (200–450 LOC, 4–7 iters). Audit whether the new sections
  carry the proof detail provers need.
- **M2 (genus-0)** — covered in `Jacobian.tex § Genus-0 sub-case
  (Route C)`. Audit whether sub-steps M2.a (rigidity), M2.b (trivial
  witness), M2.c (`C ≅ ℙ¹_k`) are written to the level a prover can
  start on M2.a now, with M2.c flagged as gated on Riemann-Roch.
- **M3 (general)** — covered in `Jacobian.tex § Route A`, `§ Route B`.
  Audit whether each sub-step (A.1–A.4, B.1–B.3) has the level of
  detail a future prover lane would need.

## References
- `references/challenge.lean` — the original AI challenge file by
  Christian Merten; authoritative signatures for the nine protected
  declarations. Used as the source of truth by all `Jacobian.tex`
  blueprint blocks and the `AbelJacobi.tex` `\lean{...}` hints.

## Focus areas

- **`Differentials.tex`** (NEW SECTION introduced this iter). The
  primary focus. Verify:
  - The new theorem `thm:relativeDifferentialsPresheaf_iso_kaehler_appLE`
    statement matches the intended Lean signature (a `B`-linear iso
    between the presheaf section module and `Ω[B/A]` on an affine chart).
  - The three auxiliary lemmas `lem:appLE_isLocalization`,
    `lem:kaehler_localization_subsingleton`,
    `lem:kaehler_quotient_localization_iso` are correctly stated and
    their proofs adequately detailed for a prover.
  - The `\uses{...}` cross-references inside the new section are
    sound.
  - The Mathlib names cited (`IsAffineOpen.basicOpen_isLocalization`,
    `KaehlerDifferential.isLocalizedModule_map`,
    `KaehlerDifferential.subsingleton_of_isLocalization`) are real
    Mathlib `b80f227` names; flag any that aren't.

- **`Jacobian.tex § "Existence of an Albanese variety"`**.
  Audit whether the per-route Mathlib-gap inventory is adequate for
  M2.a (rigidity) as the next concrete prover lane.

## Known issues

- The iter-118 demotion of `smooth_locally_free_omega` from iff to
  forward-only is the correct math (the iff is false in general); the
  blueprint correctly discloses the counterexample in
  `Differentials.tex § sec:converse-out-of-scope`. Don't re-flag.

- The `Cohomology_StructureSheafModuleK.tex` and
  `Cohomology_MayerVietoris.tex` chapters carry historical iter-NN
  scaffolding remarks. Don't re-flag — the lean-auditor confirmed
  these are intentional.

- The `Picard_LineBundle.tex`, `Picard_Functor.tex`,
  `Picard_FunctorAb.tex`, and `Modules_Monoidal.tex` chapters are
  leaf documents that are not on any active prover route; their
  audit is "nice to have" but does NOT gate the iter.
