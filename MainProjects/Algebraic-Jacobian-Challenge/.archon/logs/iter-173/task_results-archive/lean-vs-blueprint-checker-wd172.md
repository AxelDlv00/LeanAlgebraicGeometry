# Lean ↔ Blueprint Check Report

## Slug
wd172

## Iteration
172

## Files audited
- Lean: `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` (284 LOC)
- Blueprint: `blueprint/src/chapters/RiemannRoch_WeilDivisor.tex` (464 LOC)

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor}` (chapter: `def:codim1_cycles`)
- **Lean target exists**: yes (line 98).
- **Signature matches**: **no** — partial. The blueprint defines $\Div(X)$ as the free abelian group on **prime divisors** (closed integral codim-1 subschemes). The Lean defines `Scheme.WeilDivisor X := X.PrimeDivisor →₀ ℤ`, which is the free abelian group on the *helper structure* `Scheme.PrimeDivisor`. That helper has only one substantive field (`point : X`) plus a placeholder `isCodim1AndIntegral : True := trivial` (line 90). With the placeholder, `Scheme.PrimeDivisor X` is in bijection with the underlying carrier of `X` (every point trivially satisfies `True`), so `Scheme.WeilDivisor X ≃ (X.carrier →₀ ℤ)` — i.e. "free abelian group on ALL points of X", not on prime divisors. This is structurally the wrong object: it admits Weil-divisor symbols for generic points, non-codim-1 points, non-integral closures, etc.
- **Proof follows sketch**: N/A (definitional).
- **notes**: This is the directive's first scrutiny target. The Lean file's docstring (lines 73–76) and the type's docstring openly flag the field as a placeholder; that disclosure does not repair the definition. As `Scheme.WeilDivisor` is the substrate for every other pin in this file, the weakness propagates.

### `\lean{AlgebraicGeometry.Scheme.RationalMap.order}` (chapter: `def:order_at_point`)
- **Lean target exists**: yes (line 133).
- **Signature matches**: yes (in shape). `noncomputable def order {X : Scheme.{u}} [IsIntegral X] (Y : X.PrimeDivisor) (f : X.functionField) : ℤ`. `[IsIntegral X]` is required (function field needs an integral scheme); `X.functionField` is the right Mathlib alias; result `ℤ` matches the blueprint's $\ord_Y(f) \in \mathbb Z$. The directive's third scrutiny target is met.
- **Proof follows sketch**: **no** — body is `:= sorry`. Blueprint pins a substantive construction ("$\mathcal O_{X,\eta}$ is a DVR, $\ord_Y(f) := v_Y(f)$").
- **notes**: Carries the `Y : X.PrimeDivisor` parameter, so it inherits the `PrimeDivisor` weakness above — calling `order` on a non-codim-1 "prime divisor" should not type-check semantically. Hartshorne's hypothesis ($(*)$ — regular in codim 1) is NOT expressed in the typeclass context: only `IsIntegral X` is asked. The DVR-providing regularity hypothesis the chapter relies on (`RegularInCodimension 1`, `IsNormal`, or the like) is absent.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.ofClosedPoint}` (chapter: `def:divisor_closed_point`)
- **Lean target exists**: yes (line 163).
- **Signature matches**: partial. `{C : Scheme.{u}} (P : C) (_hP : IsClosed ({P} : Set C)) : C.WeilDivisor`. Blueprint pins "Let $C$ be a smooth proper curve over a field $k$" — none of "smooth", "proper", "curve", "geometrically irreducible", or "1-dimensional integral" are in the Lean signature. The Lean is just "any scheme, any point that is closed-as-a-singleton". Without a curve hypothesis there is no canonical promotion from a closed point to a codim-1 prime divisor.
- **Proof follows sketch**: **no** — body is `:= sorry`.
- **notes**: The `_hP` underscore-prefixed param is unused (sorry body); intent is clear but the signature is too loose.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.degree}` (chapter: `def:divisor_degree`)
- **Lean target exists**: yes (line 184).
- **Signature matches**: partial. `noncomputable def degree (D : X.WeilDivisor) : ℤ := D.sum (fun _ n => n)`. Body matches the blueprint's $\Sigma_i n_i$. But signature is over an arbitrary scheme `X` (variable declared at line 141) with no curve/algebraically-closed-base hypothesis. Blueprint pins "smooth proper curve over an algebraically closed field $\bar k$" — the geometric content of the chapter's `def:divisor_degree` is that residue fields are all $\bar k$ so each prime contributes 1; over a general base one would need the residue-field-degree weight. The Lean's broader signature is mathematically defensible (it's a free-group sum) but does NOT match the pin's hypothesis set.
- **Proof follows sketch**: yes (definitional; matches "$\Sigma n_i$").
- **notes**: This is one of the three sorry-free declarations in the file. Definition is faithful in formula; pin-hypothesis mismatch is minor.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.degree_hom}` (chapter: `thm:divisor_degree_hom`)
- **Lean target exists**: yes (line 197).
- **Signature matches**: yes. `X.WeilDivisor →+ ℤ` is the bundled additive-monoid-hom form of the degree map.
- **Proof follows sketch**: **no** — body is `:= sorry`. Sketch ("`Finsupp.sum_add_index` + `Finsupp.sum_zero_index`") is in the docstring but not in the body.
- **notes**: Surprising that this is `:= sorry` given `degree` is defined and the bundling is routine `AddMonoidHom.mk`/`Finsupp.sumAddHom` — would close inline in ~3 lines.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.principal}` (chapter: `def:principal_divisor`)
- **Lean target exists**: yes (line 218).
- **Signature matches**: yes. `[IsIntegral X] (f : X.functionField) (_hf : f ≠ 0) : X.WeilDivisor`. Matches blueprint's `K(X)^× → Div(X)`.
- **Proof follows sketch**: **no** — body is `:= sorry`. Blueprint pins a substantive `Finsupp`-construction using Hartshorne 6.1's finite-support side condition.
- **notes**: Same caveat as `order`: only `IsIntegral X` is in context; the DVR-providing `(*)` hypothesis (codim-1 regularity) is not expressed.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.principal_hom}` (chapter: `thm:principal_hom`)
- **Lean target exists**: yes (line 233).
- **Signature matches**: yes. `(X.functionField)ˣ →* Multiplicative X.WeilDivisor` is the standard Mathlib pattern for bundling the additive-codomain hom as a multiplicative monoid hom on units.
- **Proof follows sketch**: **no** — body is `:= sorry`.
- **notes**: Same `(*)`/`IsIntegral` caveat.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.principal_degree_zero}` (chapter: `thm:principal_deg_zero`)
- **Lean target exists**: yes (line 254).
- **Signature matches**: yes. `(C : Over (Spec (.of kbar))) [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom] [IsIntegral C.left]` matches the blueprint's "smooth proper geom-irred curve over $\bar k$" exactly. Uses the project-wide `Over (Spec ...)` idiom consistent with the AbelianVarietyRigidity stack.
- **Proof follows sketch**: **no** — body is `:= sorry`. Blueprint's `\begin{proof}` outlines Hartshorne 6.10 (constant case + $k(f) \subset K(C)$ giving finite $\varphi : C \to \mathbb P^1$ + $\div(f) = \varphi^*([0]-[\infty])$ + degree-multiplicativity).
- **notes**: Signature is the cleanest of the seven sorries; iter-173+ has full proof outline to draw from.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.LinearEquivalence}` (chapter: `def:linear_equivalence`)
- **Lean target exists**: yes (line 278).
- **Signature matches**: yes. `def LinearEquivalence [IsIntegral X] (D D' : X.WeilDivisor) : Prop := ∃ (f : X.functionField) (hf : f ≠ 0), D - D' = principal f hf` is a direct encoding of the blueprint's "$D \sim D'$ iff $D - D' = \div(f)$". `Prop`-form is the standard Mathlib idiom for a binary relation.
- **Proof follows sketch**: N/A (definitional). The blueprint claim that $\sim$ is an equivalence relation is NOT formalised — only the binary relation `LinearEquivalence` itself is.
- **notes**: This is the directive's second scrutiny target. The `Prop` form does match the chapter. However the body refers to `principal f hf`, whose body is `:= sorry` — so the right-hand side of the equation `D - D' = principal f hf` is propositionally `D - D' = sorry`. Thus *any* attempt to prove or disprove a `LinearEquivalence D D'` instance is currently uninhabited content — the definition is well-typed but semantically vacuous until `principal` is filled. Whether this counts as a separate red flag or as a downstream consequence of the `principal` sorry is a judgement call; I have not double-counted it below.

## Red flags

### Placeholder / suspect bodies

- `Scheme.PrimeDivisor.isCodim1AndIntegral : True := trivial` at line 90 — **weakened-wrong definition**. The helper structure's only "constraint" field is `True`, satisfied by every term. This collapses prime divisors to arbitrary points and makes `Scheme.WeilDivisor` structurally different from the blueprint's "free abelian group on prime divisors". The docstring at lines 87–90 admits the placeholder explicitly — under the rubric, an admitted-wrong stand-in is still a stand-in.
- `Scheme.RationalMap.order` at line 133–135 — body `:= sorry` on substantive declaration.
- `Scheme.WeilDivisor.ofClosedPoint` at line 163–165 — body `:= sorry`.
- `Scheme.WeilDivisor.degree_hom` at line 197–198 — body `:= sorry` (and would be a small bundling proof, given `degree` exists sorry-free).
- `Scheme.WeilDivisor.principal` at line 218–220 — body `:= sorry`.
- `Scheme.WeilDivisor.principal_hom` at line 233–235 — body `:= sorry`.
- `Scheme.WeilDivisor.principal_degree_zero` at line 254–259 — body `:= sorry`.

### Excuse-comments

- `WeilDivisor.lean:26–32` — file-level "iter-172 file-skeleton: each declaration carries the intended signature ... with a `sorry` body. The bodies are iter-173+ work" docstring. This is an explicit project-managed file-skeleton convention; per the rubric ("Excuse-comments are red flags, not workflow") it still surfaces as a finding, while acknowledging the iter-172 directive scoped this file as exactly such a landing.
- `WeilDivisor.lean:73–76, 87–90` — docstring text and field comment promising `iter-173+ will refine [the placeholder] to the genuine Order.coheight x = 1 ∧ IsIntegral (X.closedSubschemeOfPoint x)`. Promissory note attached to a wrong-as-written definition.
- `WeilDivisor.lean:130–132, 160–162, 195–196, 215–217, 230–232` — each substantive declaration carries a docstring line "iter-173+: the body ..." prescribing the deferred construction. Again, project-managed scaffolding; same rubric-honest concern.

### Axioms / `Classical.choice` on non-trivial claims

- None. No `axiom` declarations were introduced in this file.

## Unreferenced declarations (informational)

- `Scheme.PrimeDivisor` (line 84) — the helper structure underlying every other pin. **Not** `\lean{...}`-referenced from the blueprint. Should be — see Blueprint adequacy below.
- `AddCommGroup` instance for `WeilDivisor` (line 102) — helper, OK unreferenced.
- `Inhabited` instance for `WeilDivisor` (line 105) — helper, OK unreferenced.

## Blueprint adequacy for this file

- **Coverage**: 9/9 substantive declarations have a corresponding `\lean{...}` block (very good). One additional helper — `Scheme.PrimeDivisor` — is unreferenced and (given it carries the file's only real definitional choice) should be pinned.
- **Proof-sketch depth**: **adequate** for the theorems (`thm:divisor_degree_hom` is one-line "free abelian group, sum of multiplicities"; `thm:principal_hom` is one-paragraph DVR identities; `thm:principal_deg_zero` reproduces Hartshorne 6.10 with the standard finite-morphism + pullback chain). **Silent** on how the chapter's "prime divisor on $X$ is a closed integral subscheme $Y \subset X$ of codimension one" should be encoded in Lean: no Mathlib predicate is named, no candidate structure is proposed.
- **Hint precision**: **loose**. The chapter does not pin any Mathlib name for "regular in codimension one" (`(*)`), "codim-1 prime", "discrete valuation $v_Y$", "closed integral subscheme of codimension one", "function field" (yes, modulo the obvious `Scheme.functionField`), or "smooth curve". Six of seven sorries hide behind that looseness — a prover with only the prose to consult would not know whether to use `Order.coheight`, `Order.height`, `topologicalKrullDim`, `IsClosed ∧ IsIrreducible ∧ ...`, an `IdealSheafData`-based predicate, or a `Subscheme`-based predicate.
- **Generality**: **too narrow on hypotheses**, **too broad on definitional spec**. The pin for `def:divisor_degree` is "curve over $\bar k$" but the Lean defines `degree` for any scheme — the chapter never says whether the broader signature is acceptable. The pin for `def:divisor_closed_point` requires a smooth curve but the Lean signature is "any scheme + any IsClosed singleton" — again the chapter is silent on how strict the signature should be. Conversely the prose of `def:codim1_cycles` describes prime divisors abstractly without pinning whether the Lean encoding should be a `Set X`, a `structure`, a generic point, or a closed subscheme — leaving the file to choose the placeholder-`True` structure with no chapter-side guidance.
- **Recommended chapter-side actions** (to be carried out by a blueprint-writing subagent in iter-173+):
  1. Add a new block `def:prime_divisor` (or expand `def:codim1_cycles`) with an explicit `\lean{AlgebraicGeometry.Scheme.PrimeDivisor}` pin and a precise specification of the codim-1-and-integrality witness in Mathlib vocabulary (candidates: `Order.coheight x = 1`, `IsIntegral (closedSubschemeAt x)`, or a closed-irreducible subscheme of codim 1 with a generic-point projection). Without this pin, iter-173+ cannot refine the placeholder field deterministically.
  2. Pin the standing hypothesis $(*)$ to a Mathlib predicate (e.g. `IsNoetherian X ∧ IsIntegral X ∧ IsSeparated X ∧ RegularInCodimension 1 X` or whichever combination is available) and reference it as a `variable [...]` block the prover should thread through `order`, `principal`, `principal_hom`. The current chapter says `(*)` in prose but the Lean file uses only `[IsIntegral X]`.
  3. Decide and state whether `def:divisor_degree` / `ofClosedPoint` are meant to be defined *only* under the smooth-proper-curve-over-$\bar k$ hypothesis (matching the prose) or whether broader signatures are acceptable. The Lean today is more general than the chapter; either tighten the Lean or loosen the prose.

## Severity summary

- **must-fix-this-iter** (7 items):
  1. `Scheme.PrimeDivisor.isCodim1AndIntegral : True := trivial` (line 90) — weakened-wrong definition; `Scheme.WeilDivisor` is consequently not "free abelian group on prime divisors" but "free abelian group on all points of X".
  2. `Scheme.RationalMap.order` body `:= sorry` (line 135) — placeholder on substantive definition.
  3. `Scheme.WeilDivisor.ofClosedPoint` body `:= sorry` (line 165) — placeholder.
  4. `Scheme.WeilDivisor.degree_hom` body `:= sorry` (line 198) — placeholder.
  5. `Scheme.WeilDivisor.principal` body `:= sorry` (line 220) — placeholder.
  6. `Scheme.WeilDivisor.principal_hom` body `:= sorry` (line 235) — placeholder.
  7. `Scheme.WeilDivisor.principal_degree_zero` body `:= sorry` (line 259) — placeholder on the chapter's only theorem block.

  Plus the consequent **blueprint adequacy failure**: chapter is under-specified for prime-divisor encoding and for $(*)$ — a prover working from prose alone could not have known to write `Scheme.PrimeDivisor` with the right witness field.

- **major** (4 items):
  - `Scheme.WeilDivisor.ofClosedPoint` signature is missing the curve hypothesis (smooth/proper/1-dim/integral) the blueprint pins.
  - `Scheme.RationalMap.order`, `principal`, `principal_hom` typeclass contexts use `[IsIntegral X]` only, not the chapter's $(*)$ regularity-in-codim-1.
  - `Scheme.WeilDivisor.degree` signature is broader than the blueprint pin's hypothesis (chapter says curve over $\bar k$; Lean says any scheme).
  - Blueprint has no `\lean{...}` reference to the substantive helper structure `Scheme.PrimeDivisor`.

- **minor** (1 item):
  - `LinearEquivalence` is defined as a binary `Prop` but the equivalence-relation claim of the blueprint (reflexivity/symmetry/transitivity) is not exposed as separate `Equivalence` instance / lemmas. This is iter-173+ work and not blocking.

**Overall verdict**: The file is an iter-172 Lane C file-skeleton landing exactly as the directive describes — 9 pins wired with intended signatures and 6 honest `sorry` bodies — but under the rubric (and per the directive's explicit scrutiny of the `PrimeDivisor` placeholder, the `LinearEquivalence` Prop, and the `order` signature) the placeholder `True` field plus the six substantive-claim sorries are must-fix-this-iter findings, and the chapter is materially under-specified on how prime divisors and Hartshorne's $(*)$ should be encoded — blueprint expansion is required before iter-173+ can finish refinement deterministically.
