# Blueprint Writer Directive

## Slug
jacobian-iter121

## Target chapter
blueprint/src/chapters/Jacobian.tex

## Strategy context

Iter-121's strategic pivot (per `USER_HINTS.md` and the rewritten
`STRATEGY.md`) brings all previously-deferred Mathlib gaps into the
active roadmap. The witness existence theorem
`nonempty_jacobianWitness` (`Jacobian.lean:179`) — the project's
single foundational sorry — is now decomposed as:

```
theorem nonempty_jacobianWitness ... := by
  by_cases h : AlgebraicGeometry.genus (k := k) C.left = 0
  · exact ⟨genusZeroWitness C h⟩      -- closed by milestone M2
  · exact ⟨positiveGenusWitness C (Nat.pos_of_ne_zero h)⟩  -- closed by M3
```

The genus-0 arm `genusZeroWitness` is milestone M2. The
strategy-critic-iter121 report identified two mathematical
corrections to the first-draft M2:

1. The protected `nonempty_jacobianWitness` does **not** assume
   `C` has a `k`-rational point. The first-draft M2 step C.1
   "`C ≅ ℙ¹_k`" is mathematically FALSE for Brauer–Severi conics
   over `ℚ`. The corrected M2 handles the
   no-`k`-rational-point case by base change to the algebraic
   closure `k̄`.
2. The rigidity sub-step C.2 (`Hom(ℙ¹_k, A) = A(k)`) is currently
   a one-sentence reduction in the chapter; the
   blueprint-reviewer-iter121 flags this as "complete: partial"
   on `Jacobian.tex`, requiring a writer pass before any M2.a
   prover dispatch.

This writer dispatch addresses Issue 2 (Issue 1 is already absorbed
into STRATEGY.md and noted in the chapter's existing prose; this
writer adds detail to the C.2 sub-step).

## Required content

You revise the **existing** sub-section "Genus-0 sub-case (absorbed
into the same witness)" of the section "Existence of an Albanese
variety" in `Jacobian.tex`. Specifically:

### Required item: Expand C.2 — rigidity for `ℙ¹_k → A` (or `ℙ¹_{k̄} → A_{k̄}` after base change)

The current C.2 prose at the chapter's section reads (one sentence):
*"The classical proof uses the rigidity lemma: any morphism from a
proper geometrically connected variety with a `k`-rational point to
a separated `k`-scheme that contracts a fibre to a point is
constant; for `ℙ¹_k → A` this fibre is all of `ℙ¹_k` over the
identity of A."*

**Replace with a concrete proof skeleton** of the form below.
Frame the discussion either over the original field `k` (when
`C(k) ≠ ∅`, so the identification `C ≅ ℙ¹_k` is valid; this is the
case the protected signature does **not** require but is the easier
sub-case) or over the algebraic closure `k̄` (when `C(k) = ∅`; the
identification `C_{k̄} ≅ ℙ¹_{k̄}` is then valid, and the result
descends via Galois descent of constancy). State the result over
`k̄` (the harder case) since iterating the same argument over `k`
is then immediate.

Provide:

1. **Statement** of the rigidity-for-`ℙ¹_{k̄}` lemma:
   - Let `A` be a smooth proper geometrically irreducible group
     scheme over `k̄`, with identity element `η_A ∈ A(k̄)`.
   - Let `f : ℙ¹_{k̄} → A` be a morphism of `k̄`-schemes such that
     `f(p) = η_A` for some `p ∈ ℙ¹_{k̄}(k̄)`.
   - Then `f = const_{η_A}`, the constant morphism at the identity.

2. **Reduction to the project's rigidity lemma `GrpObj.eq_of_eqOnOpen`**:
   - The project's `AlgebraicGeometry.GrpObj.eq_of_eqOnOpen`
     (`Rigidity.lean`) says: two morphisms `g₁, g₂ : X ⟶ Y` of
     group-objects whose restrictions to a non-empty open `U ⊆ X`
     are equal-as-scheme-morphisms agree everywhere.
   - To apply it: take `g₁ := f` (the candidate non-constant
     morphism) and `g₂ := const_{η_A}` (the constant morphism at
     the identity). We need to produce a non-empty open `U ⊆ ℙ¹_{k̄}`
     such that `U.ι ≫ f = U.ι ≫ const_{η_A}` as scheme morphisms.

3. **Constructing the open `U`**:
   - **Idea**: identify the locus where `f` is "vertical" with
     respect to `A`'s group structure. Concretely, consider the
     fibre `f⁻¹(η_A) ⊆ ℙ¹_{k̄}`. By the rigidity property of
     proper geometrically integral morphisms to separated
     `k̄`-schemes (`ext_of_isDominant_of_isSeparated'` from
     Mathlib, used in the project's `eq_of_eqOnOpen` body), if
     this fibre contains a non-empty open `U` of `ℙ¹_{k̄}`, then
     `f` agrees with the constant morphism on `U`.
   - **Why the fibre contains a non-empty open**: The fibre
     `f⁻¹(η_A)` is closed in `ℙ¹_{k̄}` (a fibre of a morphism of
     schemes is the pullback along the inclusion of `η_A`'s
     residue point; closed since the inclusion `η_A : Spec k̄ → A`
     is closed because `A → Spec k̄` is separated and the identity
     section is a section of a separated morphism, hence closed).
   - Now use the **proper-image dimension argument**: `f` is a
     morphism from a 1-dimensional proper geometrically integral
     scheme to a `g`-dimensional (where `g = dim A`) proper smooth
     `k̄`-scheme. If `g ≥ 1`, the image `f(ℙ¹_{k̄})` is a proper
     irreducible closed subset of `A` of dimension ≤ 1. But `A`
     is an abelian variety, and proper rational curves on abelian
     varieties are constant (a classical fact: `ℙ¹` does not admit
     a non-constant morphism to any abelian variety; see
     Mumford's "Abelian Varieties," Chapter II §4 Proposition).
   - This means `f` is a constant morphism, so its image is a
     single point. The condition `f(p) = η_A` then forces the
     point to be `η_A`. Thus `f = const_{η_A}` everywhere; in
     particular, the open `U` can be taken to be all of `ℙ¹_{k̄}`.

4. **Why proper rational curves on abelian varieties are constant**
   (the key classical input):
   - The dual abelian variety `A^∨` parameterizes line bundles of
     degree 0 on `A`. Pulling back via `f : ℙ¹_{k̄} → A` gives a
     morphism `f^* : A^∨ → Pic^0(ℙ¹_{k̄})`. But `Pic^0(ℙ¹_{k̄}) = 0`
     (the Picard group of `ℙ¹` consists of degree-arbitrary line
     bundles, but the degree-0 component is trivial because every
     degree-0 line bundle on `ℙ¹` is `O_{ℙ¹}`). So `f^* = 0`, which
     by autoduality of abelian varieties means `f = const`.
   - This is Mumford-rigidity content one level up; the simpler
     proof uses the projection to `A^∨`. Alternative: use the
     fact that `H¹(ℙ¹, O) = 0` and the cotangent-pullback
     argument: `f^* T_A^∨ = f^* Ω_A` is a quotient of
     `Ω_{ℙ¹_{k̄}}`, which has no global sections, so `f^* Ω_A = 0`
     globally; this forces `f` to be a constant since `A` is
     smooth.

5. **Mathlib gap statement**: explicitly note that the
   "`ℙ¹_{k̄} → abelian variety` is constant" lemma is **not** in
   Mathlib `b80f227`. This is the key Mathlib contribution
   candidate of M2.a:
   - Candidate name: `AlgebraicGeometry.AbelianVariety.constant_of_ℙ¹_map`
     (project-internal first; merge to Mathlib later).
   - Statement: For `A` a smooth proper geom-irred group scheme of
     positive relative dimension over an algebraically closed field
     `k̄`, every morphism `f : ℙ¹_{k̄} → A` with `f(p) = η_A` for some
     `p ∈ ℙ¹_{k̄}(k̄)` is the constant morphism at `η_A`.
   - Note: when `dim A = 0` (i.e. `A = Spec k̄`), the conclusion is
     vacuous (there's only one morphism to `Spec k̄`).

6. **Galois descent for the `k`-side conclusion**:
   - Given the `k̄`-side rigidity, the `k`-side conclusion (for
     `C(k) ≠ ∅` so `C ≅ ℙ¹_k`) follows by Galois descent of
     morphism equality: two morphisms of `k`-schemes are equal
     iff their base changes to `k̄` are equal (`AlgebraicGeometry.Hom.ext_of_baseChange`
     or equivalent; the project may need to supply this as part of
     M2.c).

### Mathematical content discipline

Write the proof skeleton as **mathematical content**, not Lean tactic
syntax. Use the language of fibres, dimension arguments, autoduality
of abelian varieties, etc. Do NOT write `refine ⟨...⟩` or
`haveI : ...` style — that's the prover's output. Your job is to
give the mathematician the proof flow at the right level of detail
for a prover to formalize over multiple iters.

## Out of scope

- **Do NOT touch `Differentials.tex`.** That chapter is the subject
  of a separate writer dispatch (slug `differentials-iter121`).
- **Do NOT modify C.1 or C.3.** C.1 is gated on Riemann–Roch (M2.d,
  out of immediate scope); C.3 is the trivial witness construction
  and is already adequately sketched. Only C.2 needs expansion.
- **Do NOT expand Route A or Route B.** Those are M3 routes,
  deferred. The current per-sub-step Mathlib-gap inventory is
  adequate for the multi-month roadmap.
- **Do NOT touch the existing `\lean{...}` hints** in any block;
  they correctly point at protected declarations or planned
  project declarations.
- **Do NOT touch `\leanok` markers**; `sync_leanok` handles those.

## References

- `references/challenge.lean` — protected signatures.
- The project's existing `Rigidity.lean` file (read-only, blueprint
  context): the `GrpObj.eq_of_eqOnOpen` lemma is the load-bearing
  rigidity tool. See `blueprint/src/chapters/Rigidity.tex` for its
  blueprint description.
- Mumford, "Abelian Varieties," Chapter II §4 (proper rational
  curves on abelian varieties are constant).
- Hartshorne, "Algebraic Geometry," II.6 + II.7 (Picard groups of
  `ℙ¹`).

## Expected outcome

After this writer pass, the C.2 sub-step has a multi-paragraph proof
skeleton: statement of the rigidity lemma over `k̄`, reduction to
the project's `GrpObj.eq_of_eqOnOpen`, construction of the relevant
open `U`, the key classical input ("proper rational curves on
abelian varieties are constant"), explicit Mathlib gap statement,
and a note on Galois descent for the `k`-side conclusion. A prover
starting on M2.a can begin formalisation against this skeleton; the
blueprint-reviewer will re-audit and confirm `complete: true` on
`Jacobian.tex § C.2` in a subsequent iter.
