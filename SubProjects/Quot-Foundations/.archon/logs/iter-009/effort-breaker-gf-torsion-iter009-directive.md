# Effort Breaker Directive

## Slug
gf-torsion-iter009

## Target
`lem:gf_torsion_reindex` (in `blueprint/src/chapters/Picard_FlatteningStratification.tex`,
`\lean{AlgebraicGeometry.GenericFreeness.gf_torsion_reindex}`). It is a frontier node
(`archon dag-query node --node lem:gf_torsion_reindex` reports effort 1232, deps 0, used-by 1) currently
carrying a `sorry`: the single-variable Nagata elimination + division-algorithm content is Mathlib-absent
and was created monolithically in iter-008. Break it so the prover formalizes small pieces.

## Granularity
one level (the proof has clean main steps; see Proof structure). If any resulting step is still large —
in particular the division-algorithm "single-variable elimination engine" — break THAT one finer in your
same pass (it is the load-bearing, reusable piece and deserves the most atomic treatment).

## Proof structure
The existing `\begin{proof}` of `lem:gf_torsion_reindex` decomposes into these mathematical seams; cut
along them. `P_d := A[X_1,…,X_d]`, `A_g := Localization.Away g`, `T_g := LocalizedModule (powers g) T`:

1. **Annihilator extraction.** `T` a finite torsion module over the noetherian domain `P_d` ⟹ there is a
   non-zero-divisor `0 ≠ F ∈ Ann_{P_d}(T)`, hence `T` is a finite module over `P_d/(F)`. (The prover
   verified `Submodule.annihilator_top_inter_nonZeroDivisors` is present in Mathlib for this step —
   record it as an `\mathlibok` dependency anchor if you state it as a named hypothesis, else cite it.)
2. **Nagata change of variables.** A linear/triangular change of variables on `X_1,…,X_d` makes (the
   image of) `F` monic in the last variable `X_d` up to a non-zero leading coefficient `g ∈ A`.
3. **Single-variable elimination engine (THE SHARED, REUSABLE PIECE).** After inverting `g`, the image of
   `F` in `A_g[X_1,…,X_d]` is a unit times a polynomial monic in `X_d`; by the division algorithm the
   quotient `A_g[X_1,…,X_d]/(F)` is module-finite over the subring `A_g[X_1,…,X_{d-1}]`. State this as a
   STANDALONE lemma over an arbitrary base ring (not tied to the torsion module `T`): "for a polynomial
   `F` over a commutative ring monic in the last variable, `R[X_1,…,X_d]/(F)` is finite over
   `R[X_1,…,X_{d-1}]`." Give it its own `\label` + `\lean{}` (suggested name
   `AlgebraicGeometry.GenericFreeness.mvPolynomial_quotient_finite_of_monic_lastVar` — note it for the
   plan agent). This is the engine that the L4 step `lem:gf_clear_one_denominator`/
   `lem:gf_noether_clear_denominators` ALSO consumes (see the `% NOTE (shared engine)` already in the
   chapter) — so its statement must be general enough to reuse. Break it finer if the division-algorithm
   monic-quotient-finiteness argument is itself still a large goal (e.g. an inner lemma:
   `R[X]/(monic f)` is free of rank `deg f` over `R`, then transport across the
   `MvPolynomial (Fin d) ≃ (MvPolynomial (Fin (d-1)))[X]` iso).
4. **Transitivity assembly.** `T_g` finite over `A_g[X_1,…,X_d]/(F)` (localise step 1) + step 3 + module-
   finiteness transitivity ⟹ `T_g` finite over `A_g[X_1,…,X_{d-1}]`, with `m' := d-1 < d`. Rewrite
   `lem:gf_torsion_reindex`'s proof as the short combination of steps 1–4, keeping its statement and
   `\lean{}` unchanged, with `\uses{}` naming the new sub-lemmas.

For EACH new sub-lemma provide a `% LEAN SIGNATURE` block (the project convention — the prover formalizes
the pinned type) consistent with the existing `gf_torsion_reindex` signature conventions
(`(A : Type*) [CommRing A] [IsDomain A] [IsNoetherianRing A]`, `MvPolynomial (Fin d) A`,
`Localization.Away g`, `LocalizedModule (Submonoid.powers g) T`). The shared engine (step 3) should be
stated over a general `(R : Type*) [CommRing R]` base so it is not torsion-specific.

## Strategy context
This supports GF-alg (the Nitsure §4 generic-flatness algebraic core). `lem:gf_torsion_reindex` is the
"support-dimension drop / reindex onto fewer variables" inductive step of the polynomial-ring core
(`lem:gf_polynomial_core`, L5). The single-variable elimination engine (step 3) is shared with the L4
Noether-clear-denominators step — building it once unblocks both. No Krull-dimension theory is used; the
variable count drops by exactly one per elimination.

## References
- `references/nitsure-hilbert-quot.md` → source TeX at
  `references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex`, §4 "Lemma on Generic Flatness",
  inductive step (the `% SOURCE QUOTE PROOF` at L1766–L1768 is already transcribed in the
  `gf_torsion_reindex` block — preserve and re-cite it; read the surrounding lines L1711–1772 for the
  full induction so each sub-lemma carries the correct verbatim fragment).
