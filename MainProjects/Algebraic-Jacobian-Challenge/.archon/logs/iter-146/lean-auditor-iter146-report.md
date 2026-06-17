# Lean Audit Report

## Slug
iter146

## Iteration
146

## Scope
- files audited: 1 (per directive — narrow scope to the file iter-146 prover lane touched)
- files skipped (per directive): 0
- target: `AlgebraicJacobian/Cotangent/ChartAlgebra.lean`

The directive explicitly restricted scope to the one file the iter-146 prover lane touched; I did not expand audit to the rest of the project this iteration.

## Per-file checklist

### AlgebraicJacobian/Cotangent/ChartAlgebra.lean
- **outdated comments**: 1 flagged
- **suspect definitions**: 3 flagged
- **dead-end proofs**: 1 flagged
- **bad practices**: 4 flagged
- **excuse-comments**: 2 flagged
- **notes**:
  - L97 `theorem df_zero_factors_through_constant_on_chart : True := sorry` — declaration name + 5-line docstring promise a substantive chart-Kähler statement, but the type is the trivial proposition `True`. The body is `sorry`. The docstring closes with `TODO iter-146: real signature; placeholder is : True.` — explicit excuse-comment admitting the code is wrong. (Must-fix; see flagged-issues block.)
  - L107 `theorem KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero : True := sorry` — same `: True := sorry` placeholder pattern, with the same trailing `TODO iter-146: real signature; placeholder is : True.` excuse-comment. Additionally this declaration is being placed in a `KaehlerDifferential.*` namespace from inside `namespace AlgebraicGeometry`, so its fully-qualified name is `AlgebraicGeometry.KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero` — a parallel namespace to Mathlib's root-level `KaehlerDifferential`, which will confuse anyone resolving the name later. (Must-fix; see flagged-issues block.)
  - L208–218 `theorem ext_of_diff_zero` — the declaration name advertises `df = dg ⇒ f = g` (the chart-algebra Kähler-difference rigidity), but the signature instead takes `(U, hU, hUf : U.ι ≫ f.left = U.ι ≫ g.left)` — i.e. an `eqOnOpen` hypothesis. The body is `:= AlgebraicGeometry.Scheme.Over.ext_of_eqOnOpen f g U hU hUf`, a plain reference to the iter-125 declaration in `AlgebraicJacobian/Rigidity.lean:91`. The docstring openly admits the rename (`iter-147+ will refine the signature to *also* take a chart-algebra df = dg hypothesis and *derive* eqOnOpen from it`). This is a misleading rename: the named concept is structurally different from the body. (Must-fix; see flagged-issues block.)
  - L144 `theorem constants_integral_over_base_field` — substantive `by`-block proof whose final tactic is `sorry` (substep (3) deferred). The two `have _hΓfield := …` (L159) and `have _hAppTopFinite := …` (L164) bindings are underscore-prefixed and unused: they are not consumed by the open goal (which is `sorry`-closed), so they sit as decorative load. The `haveI`s at L153 and L156 may propagate as instances but are also unused by the final `sorry`. Honest in-progress proof, but the surrounding hypothesis cargo is dead-load until substep (3) actually consumes it.
  - L37–57 module docstring `## Status (iter-146 prover lane)` — bakes per-iter status (`CLOSED iter-146`, `iter-147+ continuation`) into the file's literate-style docstring. Will rot quickly; the same information lives in `STRATEGY.md` / blueprint and shouldn't be duplicated in source-of-truth comments.
  - L11–25 leading comment block — two paragraphs of iter-145 / iter-146 NOTE housekeeping (history of which Mathlib imports were tried, which `local instance` was re-enabled and why). The substantive justification ("Mathlib's `Algebra.TensorProduct` ships only the LEFT algebra instance; we re-enable the right-algebra `local instance` from `Mathlib.RingTheory.IsTensorProduct`") is repeated again at L70–73 directly above the `attribute [local instance]` line. The L11–25 block is duplicate scaffolding and contains stale-on-arrival "iter-145 NOTE" / "iter-146 NOTE" framing.
  - L64 `open … Limits …` — I find no `Limits.*`-qualified identifier used in the body (the `Algebra.IsPushout` square is in the `Algebra.*` namespace, not `CategoryTheory.Limits.*`). `TopologicalSpace` is used (`C.left.Opens`), `CategoryTheory` is used. `Limits` looks unused — minor.
  - L74 `attribute [local instance] Algebra.TensorProduct.rightAlgebra` — file-scope reactivation of a Mathlib `local instance`. The justification is documented (Mathlib only ships left-algebra by default), and it is needed for `algebra_isPushout_of_affine_product`'s `inferInstance`. Acceptable in principle, but a file-scope re-enablement of a deliberately-`local` Mathlib instance widens the surface for instance-resolution surprises (any `import` of this file picks up the rightAlgebra instance for free). Worth a `% NOTE` flag for the planner; not by itself wrong.
  - L107 namespace structure — placing `theorem KaehlerDifferential.foo` inside `namespace AlgebraicGeometry` (rather than at root, beside Mathlib's `KaehlerDifferential`) creates a project-shadow `KaehlerDifferential` under `AlgebraicGeometry`. If the intent is to upstream eventually, this declaration would need to be moved; the current placement signals confusion about whose namespace this lemma belongs in. (Counted under "bad practices".)
  - L144 declaration name `constants_integral_over_base_field` — the conclusion is `RingHom.range (…appTop.hom) = ⊤`, i.e. *surjectivity* of the structure-morphism's `appTop` (equivalently `Γ(X, O_X) ≃ k`). "Integral" in algebra means "satisfies a monic polynomial", which is strictly *weaker* than "equal to `k`". The name understates the conclusion and risks misreading by anyone scanning the file. The blueprint reference itself (`\lem:constants_integral_over_base_field`) inherits the same misnomer. Minor naming drift, but worth fixing while the declaration is still pre-closure.
  - L150 / L165 — explicit `Spec (CommRingCat.of k)` spelled out in the body where the signature uses `Spec (.of k)` (L146, L147, L149). The two forms are definitionally equal, but the inconsistency inside one declaration is a minor smell.
  - Mixing-of-placeholders-with-substantive-declarations: `: True := sorry` placeholders (L97, L107) sit between (a) the actually-closed `algebra_isPushout_of_affine_product` (L84–88) and (b) the partial `constants_integral_over_base_field` (L144–177) with a real signature. A future reader scanning the file with no iter-history can mistake the `: True` stubs for typo'd declarations rather than commitments to future content. The directive flagged this mixing as a concern; concur — these belong in a separate `_stubs.lean` (or removed) until they have real signatures.
  - L7 `import Mathlib.RingTheory.Kaehler.Basic` — imported but the file does not reference any `KaehlerDifferential.*` identifier beyond declaring a `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero : True := sorry`. The import is brought in for the placeholder's future content, not for any current use; once the placeholder is replaced by a real lemma the import will be needed, but right now it is a forward-looking dead import. Minor.

## Must-fix-this-iter

- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean:97` — `theorem df_zero_factors_through_constant_on_chart : True := sorry` with TODO excuse-comment `TODO iter-146: real signature; placeholder is : True.`. Why must-fix: matches both **Suspect bodies on substantive claims** (`: True := sorry`) *and* **Excuse-comments** in the descriptor's verbatim must-fix list. The declaration name + 5-line docstring promise a chart-Kähler statement; the body says nothing.

- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean:107` — `theorem KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero : True := sorry` with the same TODO excuse-comment. Why must-fix: identical `: True := sorry` + excuse-comment pattern, *plus* the declaration places a `KaehlerDifferential.*` name under `AlgebraicGeometry`, creating a parallel namespace to Mathlib's. Triple hit: excuse-comment, suspect body, parallel-API symptom.

- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean:208` — `theorem ext_of_diff_zero` whose signature has no `df = dg` hypothesis and whose body is `:= AlgebraicGeometry.Scheme.Over.ext_of_eqOnOpen f g U hU hUf` (the iter-125 declaration in `AlgebraicJacobian/Rigidity.lean:91`). Why must-fix: matches **Weakened-wrong definitions** in the descriptor's verbatim must-fix list — the named concept (`ext_of_diff_zero` = Kähler-difference rigidity) is structurally different from the body (a plain `eqOnOpen` rename). The docstring openly admits this is "iter-146 sorry-free closure under the planner's chart-algebra envelope" — i.e. a renamed alias that fakes closure on the iter-146 scoreboard. The author wrote the diagnosis themselves; the audit just elevates severity.

## Major

- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean:177` — substantive `sorry` inside `constants_integral_over_base_field` (the geometric-irreducibility base-change substep). The signature is real, the work toward substeps (1)–(2) is honest, but the proof is unfinished and the two `have _h…` bindings on L159 / L165 sit as unused decoration around the sorry. Not must-fix (the signature isn't faked and the proof is genuinely in-progress), but worth tracking as the largest open hole in the file.

- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean:144` — declaration name `constants_integral_over_base_field` mismatched with the conclusion `RingHom.range (…appTop.hom) = ⊤` (= "global sections are exactly `k`", not "integral over `k`"). The blueprint anchor inherits the same misnomer. Worth renaming (e.g. `appTop_surjective_of_smooth_proper_geomIrreducible` or `globalSections_eq_baseField_of_…`) while the lemma is still pre-closure.

- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean:11–25` — leading iter-145 / iter-146 NOTE block duplicates the substantive justification that already appears at L70–73 directly above the `attribute [local instance]` line. The iter-history framing ("iter-145 NOTE", "iter-146 NOTE") inside a source file is documentation rot waiting to happen.

- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean:37–57` — `## Status (iter-146 prover lane)` block in the module docstring records per-iter closure state (`CLOSED iter-146`, `iter-147+ continuation`). This belongs in `STRATEGY.md` / `PROGRESS.md`, not in the file's literate-style docstring.

## Minor

- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean:64` — `open CategoryTheory Limits TopologicalSpace`; I find no `Limits.*`-qualified identifier in the body. Trim `Limits` unless required for instance resolution.

- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean:7` — `import Mathlib.RingTheory.Kaehler.Basic` is forward-looking for the `: True := sorry` placeholder at L107. Once the placeholder has a real signature the import will be earned; right now it is dead.

- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean:74` — file-scope re-enablement of `attribute [local instance] Algebra.TensorProduct.rightAlgebra`. Acceptable given the justification (Mathlib ships only the left-algebra instance), but file-scope reactivation of a deliberately-`local` Mathlib instance widens the instance-search surface for every downstream file; if a narrower-scope option (e.g. `local instance` inside the single section needing it) suffices, prefer that.

- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean:150 / 165` — body spells `Spec (CommRingCat.of k)` where the signature uses `Spec (.of k)`. Definitionally equal; stylistic inconsistency.

- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean:159 / 165` — `have _hΓfield := …` / `have _hAppTopFinite := …` introduce intentionally-unused bindings whose only purpose is to demonstrate that the L120s docstring's "substeps (1)–(2) closed" claim is borne out. Cosmetic; fine as a progress marker, but they will need to be either consumed by substep (3) or promoted to `haveI` (so they at least feed instance search) when the proof finishes.

- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean:107` — namespace placement: `theorem KaehlerDifferential.foo` declared inside `namespace AlgebraicGeometry` resolves to `AlgebraicGeometry.KaehlerDifferential.foo`. If the lemma is intended for upstreaming, it should sit at root (next to Mathlib's `KaehlerDifferential`); if it is project-internal, it should not borrow the Mathlib namespace name at all. (Listed minor here because the L107 declaration is already counted under must-fix as a `: True := sorry` placeholder; namespace placement is a secondary symptom.)

## Excuse-comments (always called out separately)

Two verbatim excuse-comments, both severity **critical** because the attached declarations are scaffolds in the chart-algebra pivot that downstream iter work (β-core / KDM) explicitly depends on per the file's own status block:

- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean:96` — `TODO iter-146: real signature; placeholder is : True.` (attached to `df_zero_factors_through_constant_on_chart`, the chart-Kähler β-core stub). Severity: critical.
- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean:106` — `TODO iter-146: real signature; placeholder is : True.` (attached to `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`, the KDM-ring-side stub). Severity: critical.

Both are now stale by their own framing (they were "iter-146" TODOs and the iter-146 prover lane is the one being reviewed) — the placeholders did not get real signatures this iter. Either the planner schedules signature refinement for iter-147 (and the comment is updated to reflect that), or the placeholders are deleted from the file until a real signature is ready.

## Severity summary

- **must-fix-this-iter**: 3 — L97 (`: True := sorry` β-core stub), L107 (`: True := sorry` KDM stub, also parallel-namespace), L208 (`ext_of_diff_zero` named-concept-vs-body mismatch / weakened-wrong rename).
- **major**: 4 — substantive L177 sorry; L144 naming ("integral" understates "equal to"); L11–25 iter-history duplicate scaffolding; L37–57 status-block-in-docstring rot.
- **minor**: 6 — `open Limits` likely unused; `Kaehler.Basic` forward-looking dead import; file-scope `local instance` widens surface; `Spec (.of k)` vs `Spec (CommRingCat.of k)` style drift inside one declaration; underscore-prefixed `_h…` bindings as dead-load around the sorry; `KaehlerDifferential.*` namespace placement (secondary, since the parent declaration is already must-fix).
- **excuse-comments**: 2 — L96, L106 (both critical, both counted again under must-fix-this-iter above; called out separately because they document the file admitting two of its three sorries are wrong-shape, not honest-in-progress).

Overall verdict: the file consists of one cleanly-closed declaration (`algebra_isPushout_of_affine_product`, axioms `propext` + `Quot.sound`), one honestly in-progress real-signature proof with a deferred substep (`constants_integral_over_base_field`), and three structural problems — two `: True := sorry` excuse-stubs (β-core, KDM) and one misnamed alias (`ext_of_diff_zero` = `ext_of_eqOnOpen`) — that should not survive into iter-147 in their current form.
