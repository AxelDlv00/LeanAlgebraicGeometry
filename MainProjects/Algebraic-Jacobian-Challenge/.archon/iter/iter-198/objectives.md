# Iter-198 — Per-lane prover objectives (Route A bottom-up)

Standing user directive: every lane carries explicit reference citations
(Kleiman / Nitsure / Milne / Mumford / Hartshorne / Stacks / Matsumura).
Default prover mode: `mathlib-build`.

---

## Lane WD-A4a — `RiemannRoch/WeilDivisor.lean` (Priority 1, A.4.a)

### Target

L249 `rationalMap_order_finite_support` — close the non-zero
branch (case 2) of the `by_cases hf : f = 0` decomposition.
The `f = 0` branch is already closed axiom-clean.

### Scope restriction (USER 2026-05-28 standing directive)

**ROUTE C PAUSE FENCE**: do NOT touch L538
`principal_degree_zero` non-constant branch or L1108
`degree_positivePart_principal_eq_finrank`. These are RR.1 /
Route C and remain frozen in iter-197 state.

### Reference anchors

- **Stacks 02RV** (codim-1 finite-support of order): for a
  Noetherian integral scheme `X` regular in codimension 1 and a
  nonzero rational function `f ∈ K(X)`, the height-1 primes `Y`
  at which `ord_Y(f) ≠ 0` are precisely the height-1 primes
  contained in the support `V(f₀) ∪ V(f∞)` — a finite set by
  Noetherian decomposition.
- **Hartshorne II.6.1** (same statement in Hartshorne language;
  p. 130 of GTM 52).
- **Stacks 02P0** (rational function principal divisor finite
  support — related substrate).
- Mathlib (b80f227): `Ring.ordFrac`, `Ideal.Finite.minimalPrimes`,
  `UniqueFactorizationMonoid.factors`.

### Recipe (informal)

1. Write `f = a / b` with `a, b ∈ Γ(X, 𝒪_X)` nonzero (using the
   integral scheme + fraction field identification).
2. The height-1 primes `Y` at which `ord_Y(f) ≠ 0` are contained
   in the height-1 minimal primes of `V(a) ∪ V(b)`.
3. By the Noetherian assumption, `V(a)` and `V(b)` each have
   finitely many irreducible components — equivalently, finitely
   many height-1 minimal primes.
4. The support is therefore a subset of a finite union of finite
   sets, hence finite.

### Mathlib gradient

If Mathlib lacks a direct `Ideal.Finite.minimalPrimes` for the
local-ring presentation needed here, the lane fills it
axiom-clean project-side via the
`IsRegularInCodimensionOne X` substrate already in scope on the
declaration (line 228 binder).

### HARD BAR

Close L249 non-zero branch axiom-clean. Cascade:
`rationalMap_order_finite_support` becomes fully axiom-clean — a
load-bearing A.4.a substrate primitive.

### PUSH-BEYOND

If the closure completes with budget remaining, scan for any
A.4.a-tagged helpers in §1 or §2 of the file that can be sharpened
or extracted as named lemmas. Do NOT extend into §3+ (RR.1-specific).

### Blueprint

`chapters/RiemannRoch_WeilDivisor.tex` §1–§2 (the general
substrate sections; not §6 positive-part which is RR.1).

---

## Lane AB — `Albanese/AuslanderBuchsbaum.lean` (Priority 1, A.4.b)

### Target

L1131 `auslander_buchsbaum_formula_succ_pd` — the n=k+1 inductive
step of the Auslander–Buchsbaum formula (`depth M + pdim M = depth R`
for a finitely-generated module `M` over a Noetherian local ring
`R`).

### Reference anchors

- **Matsumura, Commutative Ring Theory, §19** (Theorem 19.1, p. 153
  in CUP CSAM 8): the Auslander–Buchsbaum formula, full statement
  and inductive proof.
- **Stacks 090V** (Auslander–Buchsbaum formula via depth-drops on
  a minimal free resolution).
- **Bruns–Herzog, Cohen–Macaulay Rings, Chapter 1** (depth + pdim
  alternative inductive proof).
- The iter-195 docstring at L1039+ documents a 4-piece slice
  ordering: depth-drops-by-one → minimal-resolution carving → snake
  lemma application → "what is exact" assembly.

### Recipe (informal)

Per Matsumura §19 inductive case:

1. Assume `pdim M = k + 1`. Then a minimal free resolution of `M`
   starts `0 → K → F₀ → M → 0` with `F₀` free of rank `μ(M)` and
   `pdim K = k`.
2. By the inductive hypothesis `depth K + k = depth R`, so
   `depth K = depth R - k`.
3. The depth long exact sequence on `0 → K → F₀ → M → 0` gives
   `depth K ≥ min(depth F₀, depth M + 1) = min(depth R, depth M + 1)`.
4. Since `depth M < depth R` (else `pdim M = 0`),
   `depth M + 1 ≤ depth R`, so `depth K = depth M + 1`.
5. Therefore `depth M = depth K - 1 = depth R - k - 1 = depth R - (k+1)`.

### Mathlib gradient

Required Mathlib ingredients (verify existence first via
`lean_leansearch`):
- `Module.depth_pi_const_eq_depth_of_nonempty` (iter-194 used).
- `Module.depth_succ_of_isSMulRegular` or equivalent depth-drops-by-
  one lemma.
- `Module.minimalFreeResolution.first` (or build axiom-clean from
  minimal generators of `M`).

If a required Mathlib lemma is missing, the lane builds it project-
side under `mathlib-build` mode, axiom-clean.

### HARD BAR

Close L1131 axiom-clean. Cascade: `auslanderBuchsbaum` (the main
theorem) becomes fully axiom-clean. A.4.b complete.

### PUSH-BEYOND

If closure leaves budget, scan for downstream consumers that can be
elevated from `letI/haveI` patterns to direct uses.

### Blueprint

`chapters/Albanese_AuslanderBuchsbaum.tex` (the dedicated chapter;
§5 covers the inductive step).

---

## Lane RPF — RE-ENGAGED VIA SAME-ITER FASTPATH

Iter-198 plan-phase: HARD GATE initially DEFER on
`Picard_RelPicFunctor.tex`; blueprint-writer `rpf-mustfix` patched
the chapter (added the missing `\lean{...}` pin, confirmed
Mathlib étale-topology API names, refreshed the 10-iter-stale
gate annotation); scoped blueprint-reviewer `rpf-fastpath`
returned **HARD GATE CLEAR**. Lane RPF re-engaged in iter-198
objectives as Objective #3.

### Target

The 6 sorries in RelPicFunctor.lean (L235, L287, L328, L373, L433,
L482) — the relative Picard functor builder + ét-sheafification.
A.1.a (RelativeSpec) is now functionally complete, unblocking this
lane.

### Reference anchors

- **Kleiman, "The Picard scheme" §2-§3** (arXiv:math/0504020 /
  `references/kleiman-picard-src/kleiman-picard.tex`): the relative
  Picard functor `Pic_{X/S}(T) := Pic(X ×_S T) / Pic(T)` and its
  étale sheafification `Pic^♯_{X/S} := (Pic_{X/S})^{ét}`.
- **Nitsure, "Construction of Hilbert and Quot Schemes" §5**
  (arXiv:math/0504590): companion construction.
- **FGA Explained, Ch. 9 (book p. 237 / §9.2)**: alternative
  exposition of relative Pic.
- Mathlib (b80f227): `CommRing.Pic` (existing); no scheme-level
  relative Pic functor.

### Recipe (informal)

Iter-198 prover scope: close the lowest-level functor builder
sorries first (L287, L328, L373 — definitions). L235 `exact sorry`
on `representable` body is gated on `LineBundle.OnProduct` typed
sorry per the in-file comment — that gate is the iter-199+ next
step.

Specifically:
1. L287 (next-level functor `presheaf` builder): unfold via
   `LineBundle.pullback` + `LineBundle.OnProduct` adjunction.
2. L328 (`presheaf_map` action): functoriality of pullback.
3. L373 (functoriality coherence): `LineBundle.pullback_comp`.
4. L433, L482 (étale-site sheafification + universal property):
   gated on a sheafification existence theorem in Mathlib —
   `CategoryTheory.GrothendieckTopology.Sheafify` for the étale
   topology over `Over S`.

### Mathlib gradient

Identify each Mathlib gap precisely; for any missing piece, build
it axiom-clean in the project under `mathlib-build` mode.

### HARD BAR

Close ≥2 of the 6 sorries axiom-clean (priority L287, L328 — these
are the load-bearing primitives). Document the L235 gate
explicitly.

### PUSH-BEYOND

Close all 4 functor-builder sorries (L287, L328, L373, L433); leave
the étale sheafification (L482) and `representable` body (L235) for
iter-199+ after `LineBundle.OnProduct` lands.

### Blueprint

`chapters/Picard_RelPicFunctor.tex`.

---

## Lane COE — `Albanese/CodimOneExtension.lean` (Priority 2, A.4.c.0)

### Target

L526 `isRegularLocalRing_stalk_of_smooth` — Stage 6 of the body
(closing the Stacks 00OE / 02JK gap). Iter-194 prior plan target:
`mathlib-build` mode close Stage 6.

### Reference anchors

- **Stacks 00OE** (smooth-algebra dimension formula): for a smooth
  ring map `R → S` of finite presentation, `dim S_q = dim R_p +
  trdeg(κ(p) → κ(q))` for `q ∈ Spec S` with image `p ∈ Spec R`.
  At a closed point in a smooth fiber of relative dimension 1 over
  a field, this gives `dim S_q = 1`.
- **Stacks 02JK** (cotangent ↔ Kähler over a field): the cotangent
  complex at a closed point of a smooth field-extension is the
  Kähler differential module.
- **Milne, Abelian Varieties, Thm 3.1** (Albanese course-notes p.
  15; `references/abelian-varieties.pdf`): codim-≥2 indeterminacy
  extension on a smooth scheme.
- **Milne Lemma 3.3** (p. 17): indeterminacy locus of a map to a
  group variety is codim ≥ 1.
- Mathlib (b80f227): `Algebra.IsStandardSmoothOfRelativeDimension`
  (existing); `Algebra.IsRegular.smooth_stalk` (verify).

### Recipe (informal)

Per Stacks 00OE + 02JK:
1. From the smooth hypothesis on `f : X → S` at the point, extract
   a presentation `Spec(R[x₁,...,xₙ]/(f₁,...,fc))` with `(∂fᵢ/∂xⱼ)`
   of rank `c` in the residue field at the point.
2. The stalk `𝒪_{X,x}` at the closed point is a localization of
   this finitely-presented `R`-algebra.
3. By the standard-smooth-of-relative-dimension structure, the
   stalk is a regular local ring of dimension `n - c + dim 𝒪_{S,s}`.
4. In the codim-1 context (`X` smooth over a field), this gives
   `IsRegularLocalRing 𝒪_{X,x}` with `dim 𝒪_{X,x} = codim x`.

### Mathlib gradient

Verify Mathlib has `Algebra.IsRegular.smooth_stalk` or build it
project-side from `Algebra.IsStandardSmoothOfRelativeDimension`.

### HARD BAR

Close L526 axiom-clean. Cascade: L723 + L798 downstream consumers
collapse, full `isRegularLocalRing_stalk_of_smooth` body lands.

### PUSH-BEYOND

If Stage 6 closes, attempt to lift L723 + L798 closures
opportunistically (they share substrate). DO NOT chase the
Albanese-side downstream (`Albanese_Thm32RationalMapExtension.lean`)
this iter — that lane is dispatched separately.

### Blueprint

`chapters/Albanese_CodimOneExtension.tex` (Stage 6 detailed in
§"Smoothness yields a DVR at every codim-1 point", L176+).

---

## Lane T32 — `Albanese/Thm32RationalMapExtension.lean` (Priority 3 stretch)

### Target

L155 `isReduced_of_smooth_over_field` — file-private named helper
(post-iter-196 demotion refactor). Stacks 034V / 02G4 substrate
gap: a smooth scheme over a field is reduced.

NOT in scope: L294 branch 2 (gated on COE Stacks 00TT, which
itself is gated on Lane COE Stage 6 closure this iter).

### Reference anchors

- **Stacks 034V** (smooth over a reduced base is reduced).
- **Stacks 02G4** (geometrically reduced ⟺ reduced over algebraic
  closure for smooth maps over a field).
- **Milne Thm 3.2** (Albanese course-notes p. 18): rational maps
  into AV extend (the parent theorem `Thm 3.2` whose L155 is the
  helper).
- Mathlib (b80f227): `AlgebraicGeometry.IsReduced` (existing);
  `Algebra.IsSmooth.isReduced` (verify).

### Recipe (informal)

The lemma asserts: for `f : A → S` smooth and `[Field k]` on `S`'s
base (here `S = Spec k`), `IsReduced A.left`.

1. Smooth ⟹ formally smooth ⟹ formally étale on residue fields.
2. Over a field `k`, smoothness ⟹ geometrically smooth ⟹
   geometrically regular ⟹ geometrically reduced (Stacks 02G4).
3. Geometrically reduced over the base ⟹ reduced (Stacks 034V
   special case).

### Mathlib gradient

If `Algebra.IsSmooth.isReduced` is missing, build it project-side.

### HARD BAR

Close L155 axiom-clean. Cascade: `av_isIntegral_of_smooth_geomIrred`
recovers full axiom-cleanliness.

### PUSH-BEYOND

If L155 closes early, dispatch a `lean_verify` on
`av_isIntegral_of_smooth_geomIrred` to confirm the cascade. DO NOT
touch L294 (gated on Lane COE outcome this iter).

### Blueprint

`chapters/Albanese_Thm32RationalMapExtension.tex`.

---

## Carrier-soundness probe — iter-198 abort verdict

NOT a prover lane (no `sorry` to close). The iter-198 review phase
will run `lean_verify` on `[HasPicScheme C]` typeclass consumers
(per lean-auditor iter-196 M1 finding). If silent sorryAx propagates
through the typeclass synthesis, the probe is REVERTED and the
iter-196 refactor is rolled back. If the smoke check passes,
the broader cross-file blast (~450-700 LOC, ~5-8 iters) is greenlit
for iter-199+.

The plan agent commits the verdict to iter-198 review phase. No
prover dispatch is needed here.
