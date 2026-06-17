# Lean ↔ Blueprint Check Report

## Slug
weildivisor-iter174

## Iteration
174

## Files audited
- Lean: `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` (324 LOC, 4 `sorry`)
- Blueprint: `blueprint/src/chapters/RiemannRoch_WeilDivisor.tex` (635 LOC, 9 `\lean{...}` pins)

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.PrimeDivisor}` (chapter: `def:prime_divisor`)
- **Lean target exists**: yes — `structure Scheme.PrimeDivisor` at L92–97.
- **Signature matches**: yes — `point : X` + `coheight : Order.coheight point = 1`, matching the chapter's "iter-173 pin" (L165–189 in chapter) verbatim.
- **Proof follows sketch**: N/A (structure declaration).
- **notes**: Chapter explicitly authorises this encoding choice and explains why no separate integrality field is needed (irreducibility of the closure handles it). Excellent prose-to-Lean correspondence.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor}` (chapter: `def:codim1_cycles`)
- **Lean target exists**: yes — `def Scheme.WeilDivisor X := X.PrimeDivisor →₀ ℤ` at L105.
- **Signature matches**: yes — chapter prose pins the formal-sum data type `X.PrimeDivisor →₀ ℤ` and explicitly notes that `[IsIntegral X]` is NOT required at this layer (L242–251 of chapter), matching the Lean signature exactly.
- **Proof follows sketch**: N/A (definition).
- **notes**: `noncomputable AddCommGroup` and `Inhabited` instances inherited via `inferInstanceAs`. Faithful.

### `\lean{AlgebraicGeometry.Scheme.RationalMap.order}` (chapter: `def:order_at_point`)
- **Lean target exists**: yes — `noncomputable def order` at L140–142.
- **Signature matches**: partial — chapter prose pins `f \in K(X)^{\times}` (nonzero); Lean accepts arbitrary `f : X.functionField` (no `f ≠ 0` hypothesis), so `order Y 0` is junk-defined. Lean threads `[IsIntegral X]` matching the chapter's order/principal layer; chapter mentions additionally `[IsLocallyNoetherian X]` and the regular-in-codim-1 predicate but Lean does NOT thread these in the signature (per chapter's L131–136 deliberate "noetherian-and-DVR content lives inside the proof body" choice — acceptable).
- **Proof follows sketch**: N/A (body is `sorry`, out-of-scope per directive's known-issues).
- **notes**: This is the next-iter target. Blueprint adequacy concern flagged below — chapter does NOT explicitly pin (i) the Mathlib API path (`IsDiscreteValuationRing.addVal`), (ii) how the DVR valuation extends to the fraction field, or (iii) the junk-on-`f=0` convention. The Lean docstring at L137–139 sketches all three but the chapter does not.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.ofClosedPoint}` (chapter: `def:divisor_closed_point`)
- **Lean target exists**: yes — `noncomputable def ofClosedPoint` at L178–180.
- **Signature matches**: yes — `(P : C) (_hP : IsClosed ({P} : Set C)) : C.WeilDivisor`, exactly matching chapter L330–333.
- **Proof follows sketch**: definition body uses a dependent `if h : Order.coheight P = 1 then Finsupp.single ⟨P, h⟩ 1 else 0`. The on-branch matches the chapter's `[P] := 1·P` (mass-one prime-divisor) prose; the off-branch is a **junk regime** (returns `0 ∈ Div(C)`).
- **notes**: **Mismatch — chapter's "Lean signature scope" at L330–340 does NOT document the junk-branch convention.** The chapter prose says "the well-definedness goes through a separate argument that, on a one-dimensional integral scheme, `IsClosed {P}` implies `Order.coheight P = 1`. The prover-agent threads the appropriate curve-level typeclasses inside the proof body, not in the signature". That describes the iter-173 plan of typeclass-threaded promotion; the iter-174 Lean took a different (but mathematically equivalent in the intended regime) route: junk-define on the off-branch. The iter-174 Lean docstring (L167–176) cross-references chapter L330–340 as if the chapter already documented this — but it does not. See Red flags / Blueprint adequacy below.

### Bridge lemmas — `\lean{}`-unreferenced (informational)

These two equational helpers were added in iter-174 to expose the on/off-branch behaviour of `ofClosedPoint` without leaking its definitional content:

- `ofClosedPoint_eq_single` (L186–189): `ofClosedPoint P hP = Finsupp.single ⟨P, h⟩ 1` in the codim-1 regime.
- `ofClosedPoint_eq_zero` (L195–198): `ofClosedPoint P hP = 0` in the off-branch.

Neither is referenced by the chapter. As equational helpers attached to a junk-defined construction this is acceptable, but the chapter SHOULD mention their existence (or at least their purpose) in the "Lean signature scope" paragraph so a downstream consumer knows the API surface.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.degree}` (chapter: `def:divisor_degree`)
- **Lean target exists**: yes — `noncomputable def degree` at L217–218.
- **Signature matches**: yes — `(D : X.WeilDivisor) : ℤ` via `D.sum (fun _ n => n)`, matching chapter prose `\deg(D) := \sum n_i` and explicitly chapter L371–387 ("Lean signature scope") which pins the implementation choice.
- **Proof follows sketch**: N/A (definition).
- **notes**: Chapter authorises the curve-hypothesis-free signature with a careful prose paragraph (L371–387) that flags the residue-field caveat. Excellent prose-to-Lean correspondence.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.degree_hom}` (chapter: `thm:divisor_degree_hom`)
- **Lean target exists**: yes — `noncomputable def degree_hom : X.WeilDivisor →+ ℤ` at L232–233.
- **Signature matches**: yes — bundled as `AddMonoidHom`, matching chapter prose ("group homomorphism `\deg : Div(C) → ℤ`").
- **Proof follows sketch**: yes — implementation `Finsupp.liftAddHom (fun _ ↦ AddMonoidHom.id ℤ)` is the standard finsupp packaging that gives the additive-from-coefficient-sum proof immediately. Chapter's `\begin{proof}` sketch ("reduce to corresponding identities for finite sums of integers") is faithfully realised.
- **notes**: `degree_hom_apply` (L235–238) is a `@[simp]` equation `degree_hom D = degree D`, helper for downstream rewriting. Not chapter-referenced (acceptable).

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.principal}` (chapter: `def:principal_divisor`)
- **Lean target exists**: yes — `noncomputable def principal [IsIntegral X] (f : X.functionField) (_hf : f ≠ 0) : X.WeilDivisor` at L258–260.
- **Signature matches**: yes — `[IsIntegral X]` + `f ≠ 0` matches chapter's "`X` satisfies `(*)`" + "`f \in K(X)^{\times}`" prose. Unlike `order`, the `f ≠ 0` hypothesis IS threaded here, which is the intended asymmetry (the order function junks `f = 0`; `principal` consumes a `≠ 0` witness).
- **Proof follows sketch**: N/A (body is `sorry`, out-of-scope per directive — gated on DVR extraction).
- **notes**: Chapter prose adequately previews the body (Hartshorne 6.1 finite-support side condition + materialise the `Finsupp`).

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.principal_hom}` (chapter: `thm:principal_hom`)
- **Lean target exists**: yes — `noncomputable def principal_hom : (X.functionField)ˣ →* Multiplicative X.WeilDivisor` at L273–275.
- **Signature matches**: yes — `MonoidHom` from `(K(X))ˣ` to `Multiplicative` of the additive group `X.WeilDivisor`, matching the prose "homomorphism of the multiplicative group `K^*` to the additive group `Div X`".
- **Proof follows sketch**: N/A (body is `sorry`, out-of-scope per directive).
- **notes**: Chapter `\begin{proof}` at L484–495 gives an adequate per-component DVR-axiom sketch.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.principal_degree_zero}` (chapter: `thm:principal_deg_zero`)
- **Lean target exists**: yes — `theorem principal_degree_zero` at L294–299.
- **Signature matches**: yes — `[Field kbar] [IsAlgClosed kbar] (C : Over (Spec (.of kbar))) [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom] [IsIntegral C.left]`, matching the chapter's standing curve-layer typeclass set at L113–128 verbatim.
- **Proof follows sketch**: N/A (body is `sorry`, out-of-scope per directive).
- **notes**: Chapter `\begin{proof}` at L527–554 gives Hartshorne's full II.6.10 sketch (constant case + non-constant case via finite `\varphi : C \to \mathbb P^1` and pullback multiplicativity). Two auxiliary sub-lemmas are explicitly flagged as deferred follow-up `RR.1` work. This is one of the strongest blueprint-to-Lean correspondences in the chapter.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.LinearEquivalence}` (chapter: `def:linear_equivalence`)
- **Lean target exists**: yes — `def LinearEquivalence [IsIntegral X] (D D' : X.WeilDivisor) : Prop` at L318–319.
- **Signature matches**: yes — `∃ (f : X.functionField) (hf : f ≠ 0), D - D' = principal f hf` matches the prose `D - D' = \div(f)`.
- **Proof follows sketch**: N/A (definition; equivalence-relation properties are chapter-prose only, no Lean lemmas claimed yet).
- **notes**: Note that the chapter prose claims `~` is an equivalence relation (reflexivity/symmetry/transitivity via `thm:principal_hom`) and that `\deg : Cl(C) → ℤ` descends. The Lean file does NOT yet have `Equivalence`-instance lemmas, nor the `Cl(C)` quotient, nor the descended degree map. None of those are pinned by `\lean{...}` though, so this is informational, not a must-fix gap.

## Red flags

### Placeholder / suspect bodies

- `RationalMap.order` at L140–142: body is `:= sorry`. Blueprint claims a substantive definition (DVR valuation read-off + fraction-field extension).
- `WeilDivisor.principal` at L258–260: body is `:= sorry`. Blueprint claims a substantive definition (Hartshorne 6.1 + Finsupp materialisation).
- `WeilDivisor.principal_hom` at L273–275: body is `:= sorry`. Blueprint claims a substantive `MonoidHom` (DVR-axiom assembly).
- `WeilDivisor.principal_degree_zero` at L294–299: body is `:= sorry`. Blueprint claims a substantive proof (Hartshorne 6.10 via finite `\varphi : C \to \mathbb P^1`).

**All four are listed as out-of-scope in the iter-174 directive's known-issues block (gated on the DVR-extraction sub-build). Therefore they do NOT count as fresh must-fix-this-iter findings**, but the chapter's `\leanok` markers on the four blocks (chapter L258, L302/L391, L456, L499) are currently overstated — the `sync_leanok` phase should resolve this deterministically since the bodies are `sorry`.

### Excuse-comments

None. The Lean file's docstrings and the "Status (iter-172 file-skeleton)" header (L26–32) are workflow documentation tied to a specific gated lane, not excuse-comments masking a known-wrong definition.

### Axioms / `Classical.choice` on non-trivial claims

None introduced. `lean_verify` on `ofClosedPoint`, `ofClosedPoint_eq_single`, and `ofClosedPoint_eq_zero` returns the standard kernel axiom set only (`propext`, `Classical.choice`, `Quot.sound`).

## Unreferenced declarations (informational)

- `Scheme.WeilDivisor.ofClosedPoint_eq_single` (L186–189) — bridge lemma exposing the on-branch behaviour of `ofClosedPoint`. Iter-174 addition.
- `Scheme.WeilDivisor.ofClosedPoint_eq_zero` (L195–198) — bridge lemma exposing the off-branch (junk) behaviour of `ofClosedPoint`. Iter-174 addition.
- `Scheme.WeilDivisor.degree_hom_apply` (L235–238) — `@[simp]`-tagged equation `degree_hom D = degree D`.
- `instance` at L109–110 (`AddCommGroup X.WeilDivisor`) and L112–113 (`Inhabited X.WeilDivisor`).

All five are reasonable helpers / typeclass instances; flagging the two `ofClosedPoint_eq_*` lemmas for the blueprint-writer because they document the junk-branch convention and the chapter's "Lean signature scope" paragraph should mention them.

## Blueprint adequacy for this file

- **Coverage**: 9 / 9 `\lean{...}`-pinned blocks have a corresponding Lean declaration (plus `PrimeDivisor` as the underlying structure, also pinned via `def:prime_divisor`). Three substantive helpers in the Lean (`ofClosedPoint_eq_single`, `ofClosedPoint_eq_zero`, `degree_hom_apply`) are unreferenced — acceptable as helpers, but the first two should be mentioned in the `ofClosedPoint` "Lean signature scope" paragraph.
- **Proof-sketch depth**:
  - For `degree_hom`, `principal_hom`, `principal_degree_zero`: **adequate**. Chapter prose previews the bodies in enough detail for a prover.
  - For `ofClosedPoint`: **under-specified** for the iter-174 convention actually adopted. Chapter L330–340 describes a "typeclass-threaded promotion in proof body" plan; iter-174 Lean took the junk-define-via-dependent-`if` route. The Lean docstring at L167–176 cross-references chapter L330–340 as if the chapter already documented this convention — it does not.
  - For `RationalMap.order`: **under-specified** for the next-iter body. Chapter prose has the mathematical definition (DVR valuation, fraction-field extension) but does NOT pin the specific Mathlib API (`IsDiscreteValuationRing.addVal`, fraction-field extension mechanism), nor address the junk-on-`f = 0` convention. The Lean docstring at L137–139 sketches the Mathlib API path that the chapter does not. Since the iter-174 directive flags `RationalMap.order` as the next-iter target, this gap is actionable now.
- **Hint precision**: **precise** for all 9 (each `\lean{...}` correctly names a declaration in the Lean file with the right namespace).
- **Generality**: **matches need**. The per-layer typeclass discipline (L79–136 of chapter) deliberately pins different typeclass sets for the base / order / curve layers, and the Lean signatures correctly track these layers.
- **Recommended chapter-side actions** (for a blueprint-writing subagent to land):
  1. **(major)** Amend the `def:divisor_closed_point` "Lean signature scope" paragraph (chapter L330–340) to document the iter-174 junk-branch convention: explicitly state that `ofClosedPoint` is junk-defined as `0` outside the `Order.coheight P = 1` regime, and reference the two equation lemmas `ofClosedPoint_eq_single` / `ofClosedPoint_eq_zero` as the consumer API for the well-definedness claim.
  2. **(major / actionable now)** Amend the `def:order_at_point` block to add a "Lean signature scope" paragraph that (i) pins `IsDiscreteValuationRing.addVal` (or the chosen Mathlib API) for the DVR valuation, (ii) describes the fraction-field extension mechanism, and (iii) documents the junk-on-`f = 0` convention (the Lean signature does NOT thread `f ≠ 0`; the prose pins `f \in K(X)^{\times}`).
  3. **(minor)** Once `ofClosedPoint` is amended, also add `\lean{}` blocks for the two bridge equation lemmas (or at least mention them in the prose) so a downstream consumer can find them.
  4. **(minor)** Optional: add `\lean{}` references for the `LinearEquivalence`-is-an-equivalence-relation lemmas and the descended `\deg : Cl(C) → ℤ` (currently claimed in chapter prose but not yet present in Lean — these are not regressions, just pinning future work).

## Severity summary

- **must-fix-this-iter**: none. The 4 `sorry` bodies are explicitly out-of-scope per directive; no axioms, no excuse-comments, no weakened-wrong definitions. `ofClosedPoint` is kernel-clean.
- **major**:
  - Chapter L330–340 ("Lean signature scope" for `ofClosedPoint`) does not document the iter-174 junk-branch convention actually adopted by the Lean. Lean docstring (L167–176) cross-references this paragraph as if it did. Blueprint-writer action required.
  - Chapter `def:order_at_point` block is under-specified for the upcoming next-iter body: no Mathlib-API pinning (`addVal`, fraction-field extension), no junk-on-`f = 0` convention statement, no "Lean signature scope" paragraph. Since iter-174 directive flags this as the next-iter target, this is actionable now.
- **minor**:
  - `ofClosedPoint_eq_single` / `ofClosedPoint_eq_zero` bridge lemmas are unreferenced in the chapter.
  - Chapter prose claims `LinearEquivalence` is an equivalence relation and that `\deg` descends to `Cl(C)`, but no Lean lemmas / quotient construction yet exist. Not regressions, just future-pinning gaps.

**Overall verdict**: Lean iter-174 lane (closing `ofClosedPoint` kernel-clean + two bridge lemmas) is faithful to the chapter's mathematical content, but the chapter's "Lean signature scope" paragraph for `ofClosedPoint` and the entire `def:order_at_point` block both need blueprint-writer expansion before the next-iter body work on `RationalMap.order` can proceed cleanly; flagging two **major** chapter-side actions, no must-fix-this-iter Lean findings.
