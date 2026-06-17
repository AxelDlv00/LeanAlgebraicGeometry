# Lean ↔ Blueprint Check Report

## Slug
chartalgebra-iter148

## Iteration
148

## Files audited
- Lean: `AlgebraicJacobian/Cotangent/ChartAlgebra.lean`
- Blueprint: `blueprint/src/chapters/RigidityKbar.tex` §
  "Chart-algebra piece (ii) first-class decomposition"
  (lines 1828–2159)

## Per-declaration

### `\lean{AlgebraicGeometry.GrpObj.algebra_isPushout_of_affine_product}` (chapter: `\lem:chart_algebra_isPushout_of_affine_product`, blueprint L1835–1882)
- **Lean target exists**: yes, at `ChartAlgebra.lean:84–88`.
- **Signature matches**: yes. The Lean reads
  `(k B₁ B₂ : Type*) [CommRing k] [CommRing B₁] [CommRing B₂] [Algebra k B₁] [Algebra k B₂] : Algebra.IsPushout k B₁ B₂ (TensorProduct k B₁ B₂)`,
  which is exactly the chart-level
  `Algebra.IsPushout k B₁ B₂ B` square the blueprint pins (with
  `B = B₁ ⊗_k B₂`).
- **Proof follows sketch**: yes. The blueprint sketches a three-step
  chain (`pullbackSpecIso` → `isPullback_SpecMap_of_isPushout` →
  `CommRingCat.isPushout_iff_isPushout`) but explicitly authorises
  the single-`inferInstance` Lean closure in its iter-146/iter-147
  `% NOTE` blocks (L1844–1859), pointing at the upstream
  `TensorProduct.isPushout` instance plus the locally re-enabled
  `Algebra.TensorProduct.rightAlgebra`. The Lean does exactly that.
- **notes**: the `attribute [local instance]
  Algebra.TensorProduct.rightAlgebra` declaration on L74 of the
  Lean file makes the instance lookup go through; this matches the
  blueprint's NOTE-block explanation.

### `\lean{AlgebraicGeometry.KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero}` (chapter: `\lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero`, blueprint L2061–2102)
- **Lean target exists**: yes, at `ChartAlgebra.lean:123–168`.
- **Signature matches**: yes. The Lean reads
  `{k : Type u} [Field k] {B : Type u} [CommRing B] [Algebra k B] [Algebra.FiniteType k B] {b : B} (hDb : KaehlerDifferential.D k B b = 0) : b ∈ (algebraMap k B).range`.
  The blueprint pins "`k` a field, `B` a commutative `k`-algebra of
  finite type (or, more generally, finitely generated and
  standard-smooth-of-relative-dimension `n`)", so the Lean is at the
  lower-bound generality the blueprint authorises. The (BR.1) note
  inside the Lean docstring (L142–144) explicitly flags that the
  `[Algebra.IsStandardSmoothOfRelativeDimension k B]` strengthening
  is what the (p2) char-0 bridge would actually need — consistent
  with the blueprint's optional widening.
- **Proof follows sketch**: yes — at the structured-sorry level. The
  blueprint authorises two routes: (p2) char-0 via
  `Differential.ContainConstants` and (p1) char-p via the Cartier
  chain plus chart-of-proper-curve descent. The iter-148 Lean
  docstring formalises the (p2) attempt's blocker list as
  (BR.1)–(BR.5):
    - (BR.1) `Algebra.IsStandardSmooth k B` chart hypothesis missing.
    - (BR.2) Basis selection via
      `Algebra.IsStandardSmooth.free_kaehlerDifferential`.
    - (BR.3) Coefficient-derivation extraction `∂_i : B → B` (no
      Mathlib lemma; ~30–50 LOC).
    - (BR.4) `Differential B` instance per `∂_i`.
    - (BR.5) `Differential.ContainConstants` instance in `CharZero`.
  These five sub-gaps map 1-to-1 onto the blueprint's (p2)
  paragraph (L2076): "fix a basis `{dx_1, …, dx_n}`… project `D` to
  each basis-coefficient `∂_i`… use each `∂_i` as a
  `Differential B` instance… in characteristic 0 the
  `ContainConstants` property holds for each `∂_i`". The Lean's
  reverse-direction helper `_hRev` (L132–136) realises the
  blueprint's reverse-direction `Derivation.map_algebraMap` line.
- **notes**: structured sorry at L168 is preserved as expected by the
  directive; the docstring honestly acknowledges that any actual
  (p2) closure requires signature inflation to
  `[CharZero k] + [Algebra.IsStandardSmoothOfRelativeDimension k B]`.

### `\lean{AlgebraicGeometry.GrpObj.df_zero_factors_through_constant_on_chart}` (chapter: `\lem:chart_algebra_df_zero_factors_through_constant_on_chart`, blueprint L1884–1958)
- **Lean target exists**: yes, at `ChartAlgebra.lean:196–210`.
- **Signature matches**: **no** (major). The blueprint's named
  theorem (L1889–1898) takes `(k, C, A, f : C → A, df = 0)` plus
  affine charts `W = Spec B ⊆ A.left` and `V = Spec R ⊆ C.left ⊆
  f^{-1}(W)`, producing the chart-restriction `f^♯ : B → R`, and
  concludes "for every `b ∈ B`, `f^♯(b) ∈ range(algebraMap k R)`".
  The Lean signature instead reads
  ```
  {k} [Field k] {C : Scheme.{u}}
  [C.Over (Spec (.of k))] [IsProper] [Smooth] [IsReduced]
  [GeometricallyIrreducible] {B} [CommRing B] [Algebra k B]
  [Algebra.FiniteType k B] {b : B}
  (hDb : KaehlerDifferential.D k B b = 0) :
    b ∈ (algebraMap k B).range
  ```
  i.e.\ it never names `A`, `f`, `f^♯`, `R`, `W`, `V` or
  `df = 0`. The Lean conclusion form is the KDM helper's literal
  conclusion, not the scheme-side chart conclusion the blueprint
  asks for. The four typeclasses on `C` (`IsProper`, `Smooth`,
  `IsReduced`, `GeometricallyIrreducible`) are **entirely unused
  by the proof body** (the body is one line:
  `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero hDb`).
- **Proof follows sketch**: no. The blueprint's proof block
  (L1903–1957) is a five-step recipe:
  (1) chart-level translation of `df = 0` to system `dB f^♯(b_i) = 0`;
  (2) extend to all `b ∈ B` via the standard-smooth basis expansion;
  (3) 2-chart Čech / Mayer–Vietoris promotion to global section
  vanishing on `C`, consuming
  `\lem:chart_algebra_isPushout_of_affine_product` and
  `\thm:Scheme_AffineCoverMVSquare_HModule_prime_sequence_exact`;
  (4) ring-side kernel extraction via KDM;
  (5) integrally-closed-constants closure via
  `\lem:constants_integral_over_base_field`.
  The Lean body collapses this to a one-line wrapper over Step 4
  (KDM), discarding Steps 1–3 and Step 5. The chart-of-proper-curve
  typeclasses on `C` are decorative.
- **notes**: the Lean docstring (L172–195) explicitly admits the
  signature gap — "the chart-side identification
  `B ≃ₐ[k] Γ(V, O_C)` deferred to the consumer site via the
  `Scheme.Over.ext_of_diff_zero` refinement plan; iter-148+. The
  body delegates to the algebra-level KDM helper". The blueprint
  side, however, carries no `% NOTE:` block authorising this
  structural collapse: the prose still describes a per-chart
  helper consuming `(C, A, f, f^♯)`, not "KDM under decorative
  C-typeclasses". This is a bidirectional gap (Lean is a strictly
  weaker stand-in; blueprint does not document the disposition).

### `\lean{AlgebraicGeometry.constants_integral_over_base_field}` (chapter: `\lem:constants_integral_over_base_field`, blueprint L1960–2033)
- **Lean target exists**: yes, at `ChartAlgebra.lean:249–371`.
- **Signature matches**: yes. The Lean signature is
  ```
  {k : Type u} [Field k] {X : Scheme.{u}} [X.Over (Spec (.of k))]
  [IsProper (X ↘ Spec (.of k))] [Smooth (X ↘ Spec (.of k))]
  [IsReduced X] [GeometricallyIrreducible (X ↘ Spec (.of k))] :
    RingHom.range ((X ↘ Spec (CommRingCat.of k)).appTop.hom) = ⊤
  ```
  The blueprint pins "X smooth proper geometrically irreducible
  over a field k" with conclusion
  "`Γ(X, O_X) = range(algebraMap k Γ(X, O_X))`", and the iter-146
  `% NOTE` (L1964–1973) explicitly authorises the explicit
  `[IsReduced X]` typeclass as a Mathlib gap-workaround pending a
  `Smooth ⇒ IsReduced` upstream. The Lean conclusion
  `RingHom.range … = ⊤` is `appTop.hom`-form of the same statement,
  and the iter-147 `% NOTE` (L1983–1998) documents that the Lean
  signature commits to `appTop.hom` surjectivity. Signature
  matches.
- **Proof follows sketch**: **partial** (blueprint adequacy gap on
  the iter-148 reduction). The Lean body (L255–371):
    - (1) builds `IrreducibleSpace X` via
      `GeometricallyIrreducible.irreducibleSpace_of_subsingleton`,
      then `IsIntegral X` via
      `isIntegral_of_irreducibleSpace_of_isReduced`. **Matches**
      the blueprint's step (b)/substep (1) verbatim.
    - (2.a) `_hΓfield : IsField Γ(X, ⊤)` via
      `isField_of_universallyClosed`. **Matches** step (c) first
      half.
    - (2.b) `_hAppTopFinite` via
      `finite_appTop_of_universallyClosed`. **Matches** step (c)
      second half.
    - (3) `rw [RingHom.range_eq_top]` reducing the goal to
      surjectivity of `appTop.hom`. **Matches** step (a).
    - **Path commitment divergence**: the Lean (L272–307) abandons
      the blueprint's 7-step chain (a)–(g) (which routes through
      `\bar k` base change + the flat-base-change-of-`Γ`-for-proper
      Mathlib gap at step (e)) in favour of an alternative
      "path (b)" — namely:
        - (b.1) `Smooth (X ↘ Spec k) ⇒ Algebra.IsSeparable k Γ(X, ⊤)`
          via two named sub-gaps (S3.sep.1) `Smooth ⇒
          Algebra.IsGeometricallyReduced` and (S3.sep.2)
          `geom-reduced finite field ext ⇒ separable`.
        - (b.2) `GeometricallyIrreducible (X ↘ Spec k) ⇒
          IsPurelyInseparable k Γ(X, ⊤)` via (S3.pi.1) flat base
          change of `Γ` (= blueprint step (e)) and (S3.pi.2)
          "finite-dim alg with unique min prime ⇒ purely
          inseparable".
        - dispatch via Mathlib's
          `IsPurelyInseparable.surjective_algebraMap_of_isSeparable`
          (L370–371).
      The blueprint **does not preview path (b)**. Its proof block
      (L2006–2033) documents only path (a) (the 7-step chain
      through `\bar k`). The Lean honestly notes this divergence in
      its in-source comment block (L278–306), pinning the (b.1)/(b.2)
      sub-gaps and the
      `IsPurelyInseparable.surjective_algebraMap_of_isSeparable`
      closer, but the blueprint's proof block carries no `% NOTE`
      acknowledging the iter-148 commitment to path (b).
      Mathematically, both paths land at the same conclusion;
      path (b) eliminates step (e) (the blueprint's "single
      substantive Mathlib gap") in exchange for the two new
      structural sub-gaps (S3.sep.1)/(S3.sep.2) and (S3.pi.1)/(S3.pi.2).
- **notes**: the substep (3) Lean closure
  (L307–371) sets up an honest algebraic skeleton —
  `algebraMap k Γ = α.hom` definitional equality, reduction to
  `algebraMap` surjectivity, then dispatch through
  `IsPurelyInseparable.surjective_algebraMap_of_isSeparable` —
  with the consolidated sorry at L364–367 concentrating the two
  named sub-gap pairs. The structural reduction is clean and the
  sorry is in the right place; the missing piece is blueprint
  documentation of path (b) and the four new (S3.\*) sub-gaps.

### `\lean{AlgebraicGeometry.Scheme.Over.ext_of_diff_zero}` (chapter: `\lem:Scheme_Over_ext_of_diff_zero`, blueprint L2104–2159)
- **Lean target exists**: yes, at `ChartAlgebra.lean:402–412`.
- **Signature matches**: **no** (major, but blueprint-authorised
  via NOTE block). The blueprint's named theorem (L2133–2138) takes
    - `f, g : C → A` between a smooth proper geom-irred curve `C`
      of genus 0 and a smooth proper geom-irred group scheme `A`,
    - `df = dg` as morphisms of `O_C`-modules,
    - agreement of `f` and `g` on a non-empty open `U ⊆ C`,
  and concludes `f = g`. The Lean signature instead is
  ```
  {k} [Field k] {C A : Over (Spec (.of k))}
  [IsSeparated A.hom] [IsReduced C.left] [GeometricallyIrreducible C.hom]
  (f g : C ⟶ A) (U : C.left.Opens)
  (hU : (U : Set C.left).Nonempty)
  (hUf : (U.ι ≫ f.left = U.ι ≫ g.left)) : f = g
  ```
  i.e.\ it drops the `df = dg` hypothesis entirely, drops the
  `genus 0`, `IsProper`, `Smooth`, and `GrpObj A` decorations,
  and is a literal-rename wrapper of
  `AlgebraicGeometry.Scheme.Over.ext_of_eqOnOpen` in
  `AlgebraicJacobian/Rigidity.lean` — taking the agreement-on-`U`
  hypothesis directly rather than deriving it from `df = dg`.
- **Proof follows sketch**: **no**. The blueprint's proof
  (L2143–2158) is a three-step recipe:
  (1) reduce `df = dg` to a single morphism `h = μ ∘ ⟨f, ι ∘ g⟩`
      with `dh = 0`;
  (2) apply the per-chart helper
      `\lem:chart_algebra_df_zero_factors_through_constant_on_chart`
      chart-by-chart to factor `h` through `Spec k`;
  (3) identify the constant value via the agreement on `U` and
      conclude `f = g` via `\thm:GrpObj_eq_of_eqOnOpen`.
  The Lean body skips Steps 1 and 2 (the chart-algebra `(β)`
  chain) and reduces to Step 3 (the iter-125
  `ext_of_eqOnOpen` packaging).
- **notes**: the blueprint side **explicitly authorises** this
  thin-renaming disposition in its iter-146 and iter-147 `% NOTE`
  blocks (L2109–2132): "the iter-146 Lean closure is a thin
  renaming of the iter-125 `Scheme.Over.ext_of_eqOnOpen` packaging
  — it consumes `eqOnOpen U` directly rather than deriving it
  from `df = dg` via the chart-algebra (β) chain… Iter-147+
  refines the Lean signature to *also* carry `df = dg`, and
  rewrites the body to derive `eqOnOpen` from it via Steps 1–2 of
  the recipe (which depends on the deferred (β-core) sub-piece)".
  This is a known-and-documented signature simplification, not
  a hidden gap.

## Red flags

### Placeholder / suspect bodies

No bodies are `:= sorry`, `:= True`, `:= rfl` on non-trivial
claims, or suspect `Classical.choice _` patterns. The two
structured sorries (`mem_range_algebraMap_of_D_eq_zero` at L168
and the substep-(3) inner sorry at L364–367 inside
`constants_integral_over_base_field`) are both at proof-internal
positions the blueprint authorises as substantive open
sub-claims.

### Excuse-comments

None of the docstrings or in-source comments excuse "wrong-for-now"
content. The docstrings are explicit about the planner-disposition
choices (KDM body deferred; constants substep (3) consolidated
sorry; `ext_of_diff_zero` as a thin renaming) and cross-reference
the blueprint NOTE blocks. Distinguish this from
"placeholder until we figure out X" — the comments here pin
named blueprint sub-gaps (BR.1)–(BR.5), (S3.sep.1)/(S3.sep.2),
(S3.pi.1)/(S3.pi.2) and authorise themselves against the
blueprint's deferred-closure plan.

### Axioms / Classical.choice on non-trivial claims

None. `lean_verify` was not invoked against the project (this is
a read-only checker), but a textual scan finds no `axiom`
declarations and no `Classical.choice _` invocations in the
file.

## Unreferenced declarations (informational)

Every declaration in the Lean file has a corresponding
`\lean{...}` block in the blueprint chapter:

| Lean decl | Blueprint label |
|---|---|
| `GrpObj.algebra_isPushout_of_affine_product` | `lem:chart_algebra_isPushout_of_affine_product` |
| `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero` | `lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero` |
| `GrpObj.df_zero_factors_through_constant_on_chart` | `lem:chart_algebra_df_zero_factors_through_constant_on_chart` |
| `constants_integral_over_base_field` | `lem:constants_integral_over_base_field` |
| `Scheme.Over.ext_of_diff_zero` | `lem:Scheme_Over_ext_of_diff_zero` |

Coverage 5/5; no unreferenced substantive declarations to flag.
The `attribute [local instance]
Algebra.TensorProduct.rightAlgebra` (L74) and the
`_hRev` / `_hΓfield` / `_hAppTopFinite` `have`-bindings are
proof-internal, not top-level declarations.

## Blueprint adequacy for this file

- **Coverage**: 5/5 Lean declarations have a corresponding
  `\lean{...}` block in the chapter. Unreferenced declarations:
  0 helpers, 0 substantive.
- **Proof-sketch depth**: **partially under-specified**.
    - `lem:chart_algebra_isPushout_of_affine_product` — adequate
      (three-step chain plus single-`inferInstance` NOTE).
    - `lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero`
      — adequate (the (p2) char-0 paragraph names every Mathlib
      hook the Lean's (BR.1)–(BR.5) inventory points at; the (p1)
      char-p chain (p1.a)–(p1.f) is laid out at LOC-estimable
      granularity).
    - `lem:chart_algebra_df_zero_factors_through_constant_on_chart`
      — adequate as a five-step recipe; **but** the Lean signature
      collapses the recipe and the blueprint does not authorise
      that collapse (see "Recommended chapter-side actions"
      below).
    - `lem:constants_integral_over_base_field` — adequate for the
      iter-147 path (a) 7-step chain (a)–(g), but **silent on the
      iter-148 path (b)** the Lean now commits to. The four
      sub-gaps the Lean names — (S3.sep.1) `Smooth ⇒
      IsGeometricallyReduced`, (S3.sep.2) `geom-reduced finite ext
      ⇒ separable`, (S3.pi.1) flat base change of `Γ`, (S3.pi.2)
      "finite-dim alg with unique min prime ⇒ purely
      inseparable" — appear only in the Lean docstring. The
      blueprint proof block needs a `% NOTE:` (or a parallel
      "path (b) alternative" paragraph) acknowledging the
      iter-148 commitment and pinning the four new sub-gaps.
    - `lem:Scheme_Over_ext_of_diff_zero` — adequate at the three-
      step level, and the iter-146/iter-147 `% NOTE` blocks
      properly document the thin-renaming disposition. (The
      df = dg-substantive refinement to iter-147+ is correctly
      identified as gated on β-core closure.)
- **Hint precision**: **precise** for four of five blocks
  (`\lean{...}` hints name fully-qualified Lean declarations
  matching what is in the file). For
  `lem:chart_algebra_df_zero_factors_through_constant_on_chart`
  the `\lean{...}` hint names the right declaration, but the
  prose envisions a signature with `(C, A, f : C → A, f^♯ : B →
  R)` arguments that the Lean does not carry — the hint pins
  the named target, but the prose-vs-Lean signature relationship
  is not captured.
- **Generality**: matches need. The blueprint hands the project
  finite-type-`k`-algebra generality for KDM and chart-of-proper-
  curve typeclass generality for the consumers, which is what
  the Lean carries.
- **Recommended chapter-side actions**:
    1. **Add a `% NOTE:` block to
       `\lem:chart_algebra_df_zero_factors_through_constant_on_chart`**
       acknowledging that the iter-148 Lean signature drops
       `(A, f, f^♯, W, V, R)` and is a thin wrapper over KDM under
       decorative chart-of-proper-curve typeclasses on `C` (the
       (β-core) chain Steps 1, 2, 3, 5 are deferred to a later
       signature-inflation refinement). Pin the iter-148+
       disposition explicitly, mirroring the iter-146/iter-147
       NOTE blocks on `\lem:Scheme_Over_ext_of_diff_zero`. Without
       this NOTE, the chapter prose actively misrepresents the
       Lean commitment.
    2. **Add a "path (b) alternative" `% NOTE:` block to
       `\lem:constants_integral_over_base_field`'s proof block**
       documenting the iter-148 prover lane's commitment to the
       `IsPurelyInseparable.surjective_algebraMap_of_isSeparable`
       closure route. Pin the four sub-gaps
       (S3.sep.1)/(S3.sep.2)/(S3.pi.1)/(S3.pi.2) by name so
       iter-149+ prover lanes can target them without
       re-deriving the algebraic skeleton. The existing path (a)
       7-step chain (a)–(g) can remain as the alternative,
       informational route; the NOTE just needs to flag which
       path the Lean has actually chosen.

## Severity summary

- **must-fix-this-iter**:
    1. `df_zero_factors_through_constant_on_chart` signature
       mismatch (Lean is a structurally-different stand-in for
       the blueprint's named theorem — KDM under decorative
       C-typeclasses rather than the per-chart `f^♯`-helper the
       prose describes). The blueprint chapter does **not**
       authorise this collapse with a NOTE; either the Lean
       signature must be inflated to take `(A, f, f^♯)` and the
       chart-Mayer–Vietoris machinery substantively, or the
       blueprint's prose / NOTE block must be amended to
       document the thin-wrapper disposition. **Pick one**;
       leaving them out-of-sync is the must-fix item.
- **major**:
    1. `Scheme.Over.ext_of_diff_zero` signature mismatch — Lean
       drops `df = dg`, genus-0, smooth-proper-group-scheme
       structure in favour of a literal rename of
       `ext_of_eqOnOpen`. This is `major` rather than
       `must-fix-this-iter` only because the blueprint NOTE
       blocks (L2109–2132) explicitly authorise the
       thin-renaming disposition pending β-core closure.
       Iter-147+ refinement to a substantive df = dg-carrying
       signature is on the planner's roadmap.
    2. Blueprint adequacy: the proof block of
       `lem:constants_integral_over_base_field` is silent on
       the iter-148 path (b) route the Lean commits to. Add
       a NOTE-block as recommended above.
- **minor**:
    1. The chart-of-proper-curve typeclasses
       (`[IsProper] [Smooth] [IsReduced] [GeometricallyIrreducible]`)
       on `df_zero_factors_through_constant_on_chart` are
       carried in the Lean signature but consumed by no body
       step — they are decorative under the current Lean
       commitment. Either drop them (matches the body's actual
       commitment to KDM) or use them substantively (which
       would require the signature inflation flagged at
       must-fix item (1)).

**Overall verdict**: the iter-148 prover lane delivers honest
structural reductions in two of five blocks
(`mem_range_algebraMap_of_D_eq_zero` docstring refresh,
`constants_integral_over_base_field` substep-(3) consolidation)
and the blueprint is internally adequate for those reductions
modulo the path-(b) NOTE-block recommendation; however, the
`df_zero_factors_through_constant_on_chart` signature deviation
is a must-fix-this-iter mismatch the blueprint does not currently
authorise, and `Scheme.Over.ext_of_diff_zero` remains a
planner-authorised thin renaming whose substantive
df = dg-carrying refinement is gated on β-core closure.
