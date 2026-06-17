# Mathlib Analogist Directive

## Slug
p1-hedge-iter138

## Design question

For the `C(k) ≠ ∅` branch of M2.b genus-0 witness specifically, is there
a viable ℙ¹-specific rigidity argument — cheaper than the general over-k
shared cotangent-vanishing pile (pieces (i)+(ii)+(iii)) — that uses a
**weak ℙ¹ identification** of `C` with `ℙ¹_k` via elementary projective-
embedding + low-order-pole-existence (NOT full Serre duality), and that
collapses the dependence on scheme-level absolute Frobenius (piece (iii),
~800–1500 LOC) to ring-side `k[t]` / `k[1/t]` instances?

If viable, what is the LOC envelope vs the bundled (i.b)+(i.c)+(ii)+(iii)
~1850–3600 LOC pile? Mathlib `b80f227` is the snapshot to audit against
— is the "weak ℙ¹ identification" supported by available infrastructure?

## Project artifact(s) under question

- `AlgebraicJacobian/Jacobian.lean:197` — `genusZeroWitness C h`
  scaffold (iter-127 landed) consumes `rigidity_over_kbar` (M2.a body)
  on the `C(k) ≠ ∅` branch; vacuity on the `C(k) = ∅` branch.

- `AlgebraicJacobian/RigidityKbar.lean:75` —
  `AlgebraicGeometry.rigidity_over_kbar` named declaration; iter-126
  scaffold with `sorry` body. Body closure gated on M2.body-pile pieces
  (i)+(ii)+(iii).

- `blueprint/src/chapters/RigidityKbar.tex` — full chapter for the pile;
  pieces (i)+(ii)+(iii) decomposed in §sec:RigidityKbar_shared_pile.
  Piece (i.b) `lem:GrpObj_omega_basechange_proj` is the iter-137 PARTIAL
  prover target; piece (iii) is the scheme-level absolute Frobenius
  PHANTOM at 800–1500 LOC over 4–7 iter (the dominant cost of piece (iii)).

- The C(k) = ∅ branch is handled by vacuity (the `isAlbaneseFor` field
  of `JacobianWitness C` quantifies `∀ P : 𝟙_ _ ⟶ C, IsAlbanese …`
  which is vacuously satisfied when `𝟙_ _ ⟶ C` is the empty type).
  This is sound and does NOT need ℙ¹ identification.

The hedge claim is that for the `C(k) ≠ ∅` branch only, the **weak**
ℙ¹ identification (curve isomorphic to projective line over `k`, via
the marked point + a divisor of degree 1) lets us deduce universal-
property factorisations directly through `ℙ¹_k`'s affine cover
`Spec k[t] ∪ Spec k[1/t]`, with the cotangent-trivial input replaced
by ring-side `Differential` instances on `k[t]` (which Mathlib DOES
have).

Strategic question already noted iter-133 (`STRATEGY.md` line 535–537):
"smooth proper geom-irr genus-0 with a rational point ⇒ C ≅ ℙ¹_k via
elementary projective-embedding + low-order-pole-existence". Iter-138
is the scheduled deadline for the analogist verdict (per iter-133
schedule advance from iter-140+ to iter-135–138).

## Mathlib snapshot to audit

- Mathlib snapshot `b80f227` (the project's pinned snapshot).
- Pieces of Mathlib that may bear on the hedge:
  - `AlgebraicGeometry.Proj` / `AlgebraicGeometry.ProjectiveSpectrum` / `Mathlib.AlgebraicGeometry.ProjectiveSpectrum.Scheme`
  - `AlgebraicGeometry.AffineCover` machinery for ℙ¹
  - Riemann–Roch / Brill–Noether availability for genus-0 (the audit
    should determine WITHOUT requiring full Serre duality whether
    Mathlib supports the weak identification)
  - `MvPolynomial` / `Polynomial` for the affine-chart ring shapes
  - `Differential.ContainConstants A B` on `Polynomial k`-type instances

## Specific questions to answer

1. **Weak ℙ¹ identification existence in Mathlib `b80f227`**: is there
   a Mathlib chain (without Serre duality) that takes a smooth proper
   geometrically irreducible genus-0 `k`-scheme `C` with a `k`-point `P`
   and produces an iso `C ≅ ℙ¹_k`? If yes, name the chain. If no, what
   is the LOC cost of building the weak identification in-tree (an
   estimated upper bound is acceptable)?

2. **Cotangent-trivial input on `ℙ¹_k` charts**: given the weak
   identification, does the cotangent-trivial input ("`Spec k[t] → A`
   factors through `Spec k`") that the rigidity argument needs reduce
   to a `Differential.ContainConstants k[t] A`-style instance + chart
   restriction? Or does it still need scheme-level Frobenius?

3. **LOC envelope comparison**: under the hedge, what is the total
   LOC for `genusZeroWitness`'s `C(k) ≠ ∅` branch? Compare to the
   bundled (i.b)+(i.c)+(ii)+(iii) ~1850–3600 LOC pile. Quantify the
   savings (if any).

4. **Verdict**: PROCEED-with-hedge (the hedge is materially cheaper)
   / DEFER (savings not material or hedge has its own hidden cost) /
   NOT-VIABLE (Mathlib doesn't support the weak identification, build
   cost ≥ pile cost). Cite specific Mathlib name evidence for each.

5. **Sequencing recommendation**: if PROCEED-with-hedge, when should
   the hedge be built? Before piece (i.b) closes? After piece (i.b) /
   (i.c) but before piece (ii)? After (i)+(ii), so piece (iii) is
   replaced rather than built? Pin the recommended sequencing.

## Persistent file (write target)

`analogies/p1-hedge-genus-zero-witness.md` — the canonical persistent
file for this design question (no prior file; this is the iter-138
inaugural consult on the hedge).

## References

- `references/challenge.lean` — Christian Merten's original challenge
  (the protected declarations the rigidity argument feeds).
- `analogies/mulright-globalises-cotangent.md` — iter-133 mathlib-
  analogist on piece (i.b).
- `analogies/kaehler-tensorequiv-presheafpullback.md` — iter-137
  mathlib-analogist on piece (i.b) Step 2.
- `analogies/serre-duality.md` — iter-110 mathlib-analogist on Serre
  duality 3000–8000 LOC envelope (the cost the hedge is meant to
  avoid in the genus-0 identification arm if the hedge succeeded
  there; but note piece (iv) Serre duality is currently DEFERRED per
  iter-127 over-k commitment, so the comparison is M2.a-body
  cotangent-vanishing-pile vs ℙ¹-specific-hedge).

## Out of scope

- Do NOT re-litigate the over-k vs over-`k̄` decision (that's strategy-
  critic's territory).
- Do NOT propose new strategic routes outside the C(k) ≠ ∅ branch of
  M2.b.
- Do NOT propose changes to the protected `nonempty_jacobianWitness`
  signature.
- M3 (positive-genus witness, Pic scheme / Sym + Stein) is off-scope
  even though some Mathlib machinery overlaps.
