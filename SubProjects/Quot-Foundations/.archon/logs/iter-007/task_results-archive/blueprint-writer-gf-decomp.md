# Blueprint Writer Report

## Slug
gf-decomp

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_FlatteningStratification.tex

## Changes Made

### TASK 1 — two new L5 sub-lemma blocks (inserted before `lem:gf_polynomial_core`)

- **Added lemma** `lem:gf_generic_rank_ses` — `\lean{AlgebraicGeometry.GenericFreeness.gf_generic_rank_ses}`
  - Statement: for `A` a noetherian domain, `d ≥ 0`, `N` finite over `P_d := MvPolynomial (Fin d) A`
    (with `[Module A N]` + `[IsScalarTower A P_d N]`), there exist `m : ℕ` and an injective
    `P_d`-linear `φ : (Fin m → P_d) →ₗ[P_d] N` with torsion cokernel
    `Module.IsTorsion P_d (N ⧸ LinearMap.range φ)` — i.e. the SES `0 → P_d^{⊕m} → N → T → 0`, `T` torsion.
  - LEAN SIGNATURE comment pins the analogist witness: `m = Module.finrank (FractionRing P_d) (LocalizedModule (nonZeroDivisors P_d) N)`, `φ = Fintype.linearCombination P_d v` on denominator-cleared basis lifts.
  - Proof sketch added (Y): generic rank via finrank of the localisation; lift a `Frac(P_d)`-basis, clear denominators, `LinearIndependent.restrict_scalars` → `φ` injective; cokernel torsion because `φ ⊗ Frac(P_d)` is an iso. Prose emphasises **no `g`-inversion at this step** — `g` belongs to the reindex.
  - `\uses{}`: empty (Mathlib atoms only, per directive); incoming edge from L5.
  - SOURCE: Nitsure §4, nitsure-hilbert-quot.tex L1760–L1765 (verbatim SES quote).

- **Added lemma** `lem:gf_torsion_reindex` — `\lean{AlgebraicGeometry.GenericFreeness.gf_torsion_reindex}`
  - Statement (existential, mirrors L4 template, copied from analogist § "Recommended sub-lemma signatures"):
    for `A` noetherian domain, `0 < d`, `T` finite over `P_d` with `Module.IsTorsion P_d T`, there exist
    `g : A`, `g ≠ 0`, `m' < d`, and the `MvPolynomial (Fin m') (Localization.Away g)`-module +
    `Localization.Away g`-module + `IsScalarTower` structure on `LocalizedModule (Submonoid.powers g) T`,
    such that that localised module is `Module.Finite` over `MvPolynomial (Fin m') (Localization.Away g)`.
    Full binder list pinned in the LEAN SIGNATURE comment.
  - Proof sketch added (Y): `Submodule.annihilator_top_inter_nonZeroDivisors` gives `0 ≠ F ∈ Ann(T)`;
    Nagata change of vars makes `F` monic in `X_d` up to leading coeff `g ∈ A`; invert `g`; division
    algorithm + `Module.Finite.trans` give `T_g` finite over `A_g[X_1..X_{d-1}]`, `m' = d-1`. No Krull dim.
  - `% NOTE (shared engine)`: records this single-variable Nagata elimination + denominator-clearing is the
    SAME engine L4 (`lem:gf_noether_clear_denominators`, via `lem:gf_clear_one_denominator`) needs — build once.
  - SOURCE: Nitsure §4, L1766–L1768 (verbatim support-dimension-drop quote).

### TASK 2 — rewrote the proof of `lem:gf_polynomial_core` (L5) as a thin assembly

- **Revised** `lem:gf_polynomial_core` proof — now a 5-step assembly: (1) `gf_generic_rank_ses` → SES;
  (2) `gf_torsion_reindex` → `g ≠ 0`, `m' < d`, `T_g` finite over `MvPolynomial (Fin m') A_g`;
  (3) IH **at base `A_g`**; (4) descend witness `A_g → A` via `gf_splice_shortExact_free_transport`
  (`(A_g)_h ≅ A_{ga}`, `f := ga`); (5) `gf_splice_shortExact` splices, using that `P_d^{⊕m}` is free (not
  module-finite) over `A`/`A_f`. `d=0` leaf = `gf_finite_module`; `N_K=0` sub-case = `gf_torsion_base`.
- Added `% LEAN PROOF STRUCTURE (iter-007):` comment block: the `Nat.strong_induction_on d` must
  **revert `A` (and its `CommRing/IsDomain/IsNoetherianRing` instances) into the motive alongside `N`**,
  because the reindex changes the base ring to `A_g` and `IH … at base A_g` must typecheck. Notes that `A`
  is already an explicit argument, so this is a reversion (not a public-signature change), and cites
  `analogies/gf-generic-rank-ses.md`.
- Statement block: `\lean{}`, SOURCE, SOURCE QUOTE PROOF, math statement all unchanged.

### TASK 3 — decomposed `lem:gf_noether_clear_denominators` (L4)

- **Added lemma** `lem:gf_clear_one_denominator` (inserted before L4) —
  `\lean{AlgebraicGeometry.GenericFreeness.gf_clear_one_denominator}`
  - Statement: for `A` noetherian domain, `K = Frac(A)`, `p ∈ K[X_1..X_n]`, there exists `g ≠ 0` in `A`
    with `p` in the image of the coefficient-extension `A_g[X_1..X_n] → K[X_1..X_n]` (all coeffs in `A_g`).
  - LEAN SIGNATURE comment:
    `(A) [CommRing A] [IsDomain A] (n : ℕ) (p : MvPolynomial (Fin n) (FractionRing A)) : ∃ (g : A) (_ : g ≠ 0), p ∈ Set.range (MvPolynomial.map (algebraMap (Localization.Away g) (FractionRing A)))`.
  - Proof sketch added (Y): finitely many coeffs `a_j/s_j`; take `g = ∏ s_j ≠ 0`; each coeff lands in `A_g`.
  - `% NOTE (shared engine)`: cross-references that this denominator-clearing is the same primitive
    `gf_torsion_reindex` uses; a general "clear finitely many denominators into one `Localization.Away g`"
    helper would serve both.
  - SOURCE: Nitsure §4, L1755–L1759 (verbatim "common denominator" quote).
- **Revised** `lem:gf_noether_clear_denominators` proof — now Step 1 (Noether normalisation over `K`,
  unchanged) + Step 2 (Finset-fold of `gf_clear_one_denominator` over the finite generating set to one
  common `g`) + Step 3 (AlgHom assembly, unchanged). Added a `% NOTE (iter-007 decomposition):` explaining
  the fold. Statement block, SOURCE/SOURCE QUOTE PROOF kept verbatim.

### Dependency-edge fixes (leandag)

- **Fixed dependencies** `lem:gf_polynomial_core` — added `lem:gf_generic_rank_ses`,
  `lem:gf_torsion_reindex`, `lem:gf_splice_shortExact_free_transport` to the **statement** `\uses{}`
  (and to the proof `\uses{}`).
- **Fixed dependencies** `lem:gf_noether_clear_denominators` — added `lem:gf_clear_one_denominator` to the
  **statement** `\uses{}` (and to the proof `\uses{}`).
  - Reason: leandag builds edges only from the **statement** block's `\uses{}`; proof-block `\uses{}`
    alone left the three new lemmas isolated (impact 0). Adding the labels to the statement `\uses{}`
    changes neither the math statement, the signature, nor the SOURCE quotes; it only records the real
    dependency edges, as the descriptor requires. This is the only deviation from the directive's literal
    "update the *proof* `\uses{}`" wording, made to satisfy "confirm the `\uses{}` graph is consistent."

## leandag verification

`leandag build --json` (final):
- `isolated: 0`, `unknown_uses: []`, `conflicts: []`, `edges: 119`, `blueprint_nodes: 79`.
- New edges present: `gf_clear_one_denominator → gf_noether_clear_denominators`,
  `gf_generic_rank_ses → gf_polynomial_core`, `gf_torsion_reindex → gf_polynomial_core`.
- `unmatched_lean` lists the three new `\lean{}` names
  (`gf_clear_one_denominator`, `gf_generic_rank_ses`, `gf_torsion_reindex`) — **expected**: they are new
  Lean declarations not yet in the tree (the directive anticipated this).
- LaTeX environments balanced (lemma 16/16, proof 15/15, enumerate 1/1, theorem 2/2).

## Cross-references introduced
- `\uses{lem:gf_generic_rank_ses}`, `\uses{lem:gf_torsion_reindex}`,
  `\uses{lem:gf_splice_shortExact_free_transport}` in `lem:gf_polynomial_core` — all three targets exist in
  this chapter.
- `\uses{lem:gf_clear_one_denominator}` in `lem:gf_noether_clear_denominators` — target exists in this chapter.
- Comment-level `\cref{lem:gf_torsion_reindex}` in the L5a statement prose — target exists.

## References consulted
- `references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex` — verbatim SOURCE QUOTE PROOF blocks:
  L1755–L1759 (common denominator → `gf_clear_one_denominator`), L1760–L1765 (generic-rank SES →
  `gf_generic_rank_ses`), L1766–L1768 (support-dimension drop → `gf_torsion_reindex`). Re-confirmed
  character-by-character.
- `analogies/gf-generic-rank-ses.md` — authoritative Lean encoding: generic rank as
  `Module.finrank (FractionRing P_d) (LocalizedModule …)`, `φ = Fintype.linearCombination`, the exact
  `gf_torsion_reindex` binder list, and the base-domain-generalization structural fix.

## Macros needed (if any)
- None. All notation (`\mathrm`, `\operatorname`, `\oplus`, `\cref`, `\xrightarrow`, `enumerate`) is
  standard or already in use in the chapter.

## Reference-retriever dispatches (if any)
- None (the required Nitsure source was already on disk).

## Notes for Plan Agent
- leandag records dependency edges from **statement** `\uses{}` only, not proof `\uses{}`. Future
  directives that say "update the *proof* `\uses{}`" will leave new nodes isolated unless the same labels
  are also added to the statement block. I added them to both.
- The three new `\lean{}` targets (`gf_clear_one_denominator`, `gf_generic_rank_ses`,
  `gf_torsion_reindex`) are new declarations for the iter-008 prover / lean-scaffolder to create with the
  pinned signatures in the LEAN SIGNATURE comments.

## Strategy-modifying findings
- **The L5 induction must generalize the base noetherian domain `A`, not only `N` and `d`.** This is the
  load-bearing cause of the iter-006 GF stall (confirmed by the api-alignment analogist in
  `analogies/gf-generic-rank-ses.md`): the torsion reindex inverts `g ∈ A`, so the reindexed module `T_g`
  is finite over `MvPolynomial (Fin m') (Localization.Away g)` — base ring `A_g`, not `A` — and the
  inductive hypothesis must be applied at base `A_g`. The fix is to prove the core by
  `Nat.strong_induction_on d` with `A` (and its `CommRing/IsDomain/IsNoetherianRing` instances) reverted
  into the motive alongside `N`. Because `A` is already an explicit argument of the pinned signature
  `exists_free_localizationAway_polynomial`, this is a **reversion-into-the-motive change, not a public
  signature change** — the pinned `\lean{}` is unaffected. This is now recorded in the L5 proof's
  `% LEAN PROOF STRUCTURE (iter-007)` comment. The plan agent should record this in STRATEGY.md so the
  iter-008 prover restructures L5 accordingly.
