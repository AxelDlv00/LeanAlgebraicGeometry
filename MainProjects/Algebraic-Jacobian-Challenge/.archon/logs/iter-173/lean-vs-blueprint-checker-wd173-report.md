# Lean ↔ Blueprint Check Report

## Slug
wd173

## Iteration
173

## Files audited
- Lean: `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`
- Blueprint: `blueprint/src/chapters/RiemannRoch_WeilDivisor.tex`

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.PrimeDivisor}` (chapter: `def:prime_divisor`)
- **Lean target exists**: yes (L93–L98).
- **Signature matches**: yes. Structure carries two fields, in the chapter's stipulated
  order: `point : X` then `coheight : Order.coheight point = 1`. Matches the
  "Lean encoding (iter-173 pin)" paragraph verbatim, including the explicit
  recipe "drop `isCodim1AndIntegral : True := trivial`, add the named field
  `coheight`, retain the `point` field for downstream defeq".
- **Proof follows sketch**: N/A (structure declaration; no proof body).
- **notes**: The iter-173 prover edit closes the iter-172 lean-auditor
  must-fix-this-iter on the `True` placeholder. The literal `1` in
  `Order.coheight point = 1` elaborates against `Order.coheight : α → ℕ∞`
  consistently with the chapter's `\texttt{Order.coheight\ point\ =\ 1}`
  presentation. No new typeclasses introduced; the predicate is total on
  `X.carrier` via the standard scheme specialisation preorder.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor}` (chapter: `def:codim1_cycles`)
- **Lean target exists**: yes (L106).
- **Signature matches**: yes. `Scheme.WeilDivisor X := X.PrimeDivisor →₀ ℤ`
  matches the chapter's `\Div(X) = \bigoplus_{Y} \mathbb Z \cdot Y` and the
  "Lean signature scope" pin (`X.PrimeDivisor →₀ ℤ`, no `[IsIntegral X]` on
  the base declaration).
- **Proof follows sketch**: N/A (data definition).
- **notes**: `noncomputable instance ... : AddCommGroup` + `instance ... : Inhabited`
  inferred from `→₀`. Untouched this iter.

### `\lean{AlgebraicGeometry.Scheme.RationalMap.order}` (chapter: `def:order_at_point`)
- **Lean target exists**: yes (L141–L143).
- **Signature matches**: yes. `{X : Scheme.{u}} [IsIntegral X] (Y : X.PrimeDivisor)
  (f : X.functionField) : ℤ` matches the chapter's prose and the iter-173
  blueprint pin (Standing-hypothesis §, "Order/principal layer"). The standalone
  `[IsIntegral X]` is the documented minimum; deeper hypotheses (DVR / local
  noetherianness) are threaded inside the proof body per the chapter's
  per-layer typeclass discipline.
- **Proof follows sketch**: N/A — body is `sorry` and NOT ATTEMPTED iter-173
  (explicitly gated). See "Red flags" below.
- **notes**: untouched this iter.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.ofClosedPoint}` (chapter: `def:divisor_closed_point`)
- **Lean target exists**: yes (L171–L173).
- **Signature matches**: yes. `{C : Scheme.{u}} (P : C) (_hP : IsClosed ({P} : Set C))
  : C.WeilDivisor` matches the chapter's "Lean signature scope" paragraph
  verbatim (chapter L330–L340).
- **Proof follows sketch**: N/A — body is `sorry`, NOT ATTEMPTED iter-173.
- **notes**: untouched this iter.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.degree}` (chapter: `def:divisor_degree`)
- **Lean target exists**: yes (L192–L193).
- **Signature matches**: yes. `(D : X.WeilDivisor) : ℤ := (D : ...).sum (fun _ n => n)`
  matches the chapter's "Lean signature scope" verbatim (literal sum of
  coefficients via `Finsupp.sum D (fun _ n => n)`, no curve typeclasses on the
  base declaration).
- **Proof follows sketch**: yes (definition body matches prose).
- **notes**: untouched this iter.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.degree_hom}` (chapter: `thm:divisor_degree_hom`)
- **Lean target exists**: yes (L207–L208).
- **Signature matches**: yes. `: X.WeilDivisor →+ ℤ` matches the chapter's
  `\deg \colon \Div(C) \to \mathbb Z` group-homomorphism statement.
- **Proof follows sketch**: yes. Chapter sketch: "Immediate from the definition:
  $\Div(C)$ is the free abelian group on closed points and $\deg$ is the unique
  group homomorphism sending each generator $[P]$ to $1 \in \mathbb Z$." The
  Lean proof `Finsupp.liftAddHom (fun _ ↦ AddMonoidHom.id ℤ)` is exactly this:
  `liftAddHom` is the universal-property packaging that lifts a family of
  AddMonoidHoms (here `id` on each generator) into the single AddMonoidHom on
  the free abelian group.
- **notes**: Closed iter-173, axiom-clean (kernel-only: `propext, Classical.choice,
  Quot.sound`). One-line proof, cleanest possible Mathlib appeal.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.principal}` (chapter: `def:principal_divisor`)
- **Lean target exists**: yes (L233–L235).
- **Signature matches**: yes. `[IsIntegral X] (f : X.functionField) (_hf : f ≠ 0)
  : X.WeilDivisor` matches the chapter's "principal divisor of $f$" with the
  pinned typeclass discipline.
- **Proof follows sketch**: N/A — body is `sorry`, NOT ATTEMPTED iter-173.
- **notes**: untouched this iter.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.principal_hom}` (chapter: `thm:principal_hom`)
- **Lean target exists**: yes (L248–L250).
- **Signature matches**: yes. `[IsIntegral X] : (X.functionField)ˣ →* Multiplicative
  X.WeilDivisor` matches the chapter's "$K(X)^{\times} \to \Div(X)$ group
  homomorphism" with the standard multiplicative-to-additive encoding.
- **Proof follows sketch**: N/A — body is `sorry`, NOT ATTEMPTED iter-173.
- **notes**: untouched this iter.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.principal_degree_zero}` (chapter: `thm:principal_deg_zero`)
- **Lean target exists**: yes (L269–L274).
- **Signature matches**: yes. The full typeclass stack
  `{kbar} [Field kbar] [IsAlgClosed kbar] (C : Over (Spec (.of kbar)))
  [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible
  C.hom] [IsIntegral C.left] (f : C.left.functionField) (hf : f ≠ 0) :
  degree (principal f hf) = 0` is **verbatim** the "Curve layer" quote block
  in the chapter (L114–L127).
- **Proof follows sketch**: N/A — body is `sorry`, NOT ATTEMPTED iter-173.
- **notes**: untouched this iter.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.LinearEquivalence}` (chapter: `def:linear_equivalence`)
- **Lean target exists**: yes (L293–L294).
- **Signature matches**: yes. `[IsIntegral X] (D D' : X.WeilDivisor) : Prop :=
  ∃ (f : X.functionField) (hf : f ≠ 0), D - D' = principal f hf` matches the
  chapter's `D - D' = \div(f) \in \Div(X)` verbatim, modulo the explicit
  `hf : f ≠ 0` witness threaded through the `principal` API.
- **Proof follows sketch**: yes (definition matches).
- **notes**: untouched this iter.

## Red flags

### Placeholder / suspect bodies

The following remaining sorries are placeholders on declarations whose blueprint
prose claims substantive content. **All five are explicitly NOT ATTEMPTED this
iter per the prover directive, gated on downstream sub-builds** (closed-point
↔ prime-divisor bridge, DVR extraction, RR.2–RR.4 chain). The iter-172
must-fix-this-iter (the `True` placeholder on `Scheme.PrimeDivisor`) is now
CLOSED.

- `Scheme.RationalMap.order` at L141: `sorry`. Blueprint claims the DVR
  valuation `v_Y(f) ∈ ℤ` of a nonzero rational function. **Known/gated** —
  needs DVR extraction from the codim-1 regularity hypothesis (chapter's
  "Order/principal layer" pin), itself project-side work pending.
- `Scheme.WeilDivisor.ofClosedPoint` at L171: `sorry`. Blueprint claims the
  Weil divisor `1 · P ∈ Div(C)` via the curve-specific closed-point ↔
  prime-divisor bijection. **Known/gated** — needs the bijection bridge.
- `Scheme.WeilDivisor.principal` at L233: `sorry`. Blueprint claims the
  formal sum `Σ_Y ord_Y(f) · Y`. **Known/gated** on `order` (above).
- `Scheme.WeilDivisor.principal_hom` at L248: `sorry`. Blueprint claims
  `div(fg) = div(f) + div(g)`, etc. **Known/gated** on `principal`.
- `Scheme.WeilDivisor.principal_degree_zero` at L269: `sorry`. Blueprint
  proves Hartshorne Cor. II.6.10 via the finite morphism `C → ℙ¹` and degree
  multiplicativity. **Known/gated** — proof depends on two RR.1 sub-lemmas
  the chapter explicitly defers ("Sub-build note" at chapter L542–L552).

The chapter's prose, the file's docstring (L26–L33), the chapter's "Out of
scope" section (L598–L633), and the prover task report all consistently
identify these five as in-progress skeleton bodies, with explicit dependency
ordering. The file is openly a `RR.1` file-skeleton; severity is not
must-fix-this-iter under the gate the chapter advertises, but they remain
real placeholder bodies that future iters must close.

### Excuse-comments
None. The doc-comments on each `sorry`-bodied declaration name the
follow-up-iter discharge route ("iter-173+: the body extracts …") in the
voice of a forward plan, not an excuse for wrong code.

### Axioms / Classical.choice on non-trivial claims
None. `#print axioms` on both iter-173 prover edits (`Scheme.PrimeDivisor`,
`Scheme.WeilDivisor.degree_hom`) is kernel-only `[propext, Classical.choice,
Quot.sound]`, per the prover report.

## Unreferenced declarations (informational)

The Lean file contains three declarations that are not `\lean{...}`-referenced
from the chapter. All three are helpers; none are flagged.

- `AddCommGroup X.WeilDivisor` instance (L110–L111). Boilerplate forwarder
  through `Finsupp.AddCommGroup`. Helper-only.
- `Inhabited X.WeilDivisor` instance (L113–L114). Boilerplate. Helper-only.
- `Scheme.WeilDivisor.degree_hom_apply` (L210–L213). New `@[simp]` lemma:
  `degree_hom D = degree D`, proved by `Finsupp.liftAddHom_apply`. This is
  a downstream-callability bridge (sim-normalises the bundled `AddMonoidHom`
  to the unbundled `degree` form). Acceptable as helper-only — see "Blueprint
  adequacy" below for the recommendation.

## Blueprint adequacy for this file

- **Coverage**: 9/9 substantive Lean declarations have a `\lean{...}` block.
  Unreferenced: 2 instance forwarders + 1 simp helper, all genuinely helpers.
- **Proof-sketch depth**: adequate. `thm:divisor_degree_hom`, `thm:principal_hom`,
  `thm:principal_deg_zero` each carry a proof sketch with named sub-steps;
  the iter-173 closure of `degree_hom` matches the "Immediate from the
  definition … unique homomorphism sending each generator $[P]$ to $1$"
  prose exactly via the `liftAddHom` universal-property packaging. The
  `thm:principal_deg_zero` proof block explicitly flags its two RR.1
  sub-lemmas as deferred — that's appropriate sub-build hygiene, not
  under-specification.
- **Hint precision**: precise. The chapter's iter-173 "Standing hypothesis
  $(*)$ in the Lean encoding" paragraph (L79–L136) is *exemplary* — it pins
  the layered typeclass discipline (Basic / Order-Principal / Curve layers)
  to the exact Mathlib predicates the Lean code uses, and the
  `def:prime_divisor` block names `Order.coheight point = 1` as the precise
  predicate the structure field carries. No prover ambiguity remains.
- **Generality**: matches need. `Scheme.WeilDivisor` is stated at the
  arbitrary-`Scheme` level with the appropriate typeclass-deferred discipline
  the chapter documents; `degree` likewise. The "Curve layer" pin matches
  the project's existing curve-API typeclass stack
  (`AlgebraicJacobian.Genus`, `AlgebraicJacobian.AbelianVarietyRigidity`).
- **Recommended chapter-side actions** (all minor):
  - **(Optional)** Consider a short blueprint note acknowledging the new
    helper `Scheme.WeilDivisor.degree_hom_apply` as a downstream-callability
    bridge (e.g. one sentence appended to the `thm:divisor_degree_hom`
    Lean-encoding scope), so future readers searching for "why does the
    file have an extra `@[simp]` lemma" find the explanation. Not a `\lean{...}`
    pin — the simp lemma is a defeq bridge that does not warrant a chapter
    block — just a one-line mention. **Severity: minor.**
  - No other chapter-side actions: the `wd-spec-refine` writer's iter-173
    work has fully closed the prior under-specification gap on
    `def:prime_divisor` (the field-name + predicate are now pinned), and
    the "Standing hypothesis" §-§ already addresses the iter-173
    blueprint-reviewer's flag (ii) on hypothesis sets.

## Directive question answers

1. **Does the refactored `Scheme.PrimeDivisor` match the chapter's
   `def:prime_divisor` block?** Yes, exactly. Field order: `point` (the data
   field, retained for downstream defeq) then `coheight` (predicate field,
   `Order.coheight point = 1`). This is precisely the recipe in chapter
   L182–L189 (iter-173 pin paragraph: "refined to `coheight : Order.coheight
   point = 1` (named field, type `Prop`) in the iter-173 prover step,
   retaining the same `point` field for downstream defeq").
2. **Is the chapter's hypothesis specification on `ofClosedPoint` adequate?**
   Yes. Chapter L330–L340 ("Lean signature scope") pins the signature
   `(C : Scheme.{u}) (P : C) (IsClosed ({P} : Set C))` verbatim, matching
   L171 of the Lean file. The iter-173 blueprint-reviewer's flag (ii) on
   hypothesis sets is closed for this declaration.
3. **Does `degree_hom_apply` need a chapter pin?** No — it is acceptable as
   a downstream-helper-only declaration. It is a `@[simp]` bridge lemma
   (`degree_hom D = degree D`) proved by direct `Finsupp.liftAddHom_apply`
   appeal; it carries no substantive mathematical content beyond the defeq
   identification. A brief mention in the `thm:divisor_degree_hom` Lean-scope
   paragraph would be a polish improvement (see "Recommended chapter-side
   actions") but is not required.
4. **Is the umbrella `AlgebraicJacobian.lean` import correct?** Yes.
   `AlgebraicJacobian.lean:18` carries `import AlgebraicJacobian.RiemannRoch.WeilDivisor`,
   which is the standard import path. The umbrella does not need a `\lean{...}`
   reference of its own — it is the project root import-graph file, not a
   substantive Lean target.

## Severity summary

- **must-fix-this-iter**: none. The iter-172 must-fix-this-iter (`True`
  placeholder on `Scheme.PrimeDivisor`) is closed by the iter-173 refactor.
- **major**: none. The remaining 5 sorries are explicitly gated/skeleton
  per the file's documented sub-build status and the chapter's "Out of
  scope" sequencing; they are tracked as known iter-174+ work, not new
  findings.
- **minor**: 1 optional polish — add a one-line note to the
  `thm:divisor_degree_hom` Lean-encoding-scope paragraph mentioning the
  new `degree_hom_apply` `@[simp]` bridge for downstream callability.

**Overall verdict**: The iter-173 prover edits (`Scheme.PrimeDivisor` refactor
and `Scheme.WeilDivisor.degree_hom` + `degree_hom_apply` closure) faithfully
implement the corresponding blueprint blocks, the prior must-fix-this-iter
unsoundness is resolved, and no new red flags are introduced.
