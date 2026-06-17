# Blueprint-writer directive — GF L5/L4 crux decomposition (slug: gf-decomp)

## Chapter to edit
`blueprint/src/chapters/Picard_FlatteningStratification.tex` (ONLY this file).

## Strategy context
GF-alg proves the algebraic core of generic freeness (Nitsure §4). Two open residues — the L5
non-torsion generic-rank dévissage (`lem:gf_polynomial_core`) and the L4 denominator-clearing
(`lem:gf_noether_clear_denominators`) — are monolithic Mathlib-absent constructions. The progress-
critic returned CHURNING (GF at the STUCK boundary); the named corrective is to DECOMPOSE both into
named, CONCRETELY-TYPED sub-lemmas so an iter-008 prover can formalize provable pieces. A
mathlib-analogist (api-alignment) has already resolved the Lean encoding — its findings are
authoritative for this directive and are reproduced inline below. The persistent rationale is at
`analogies/gf-generic-rank-ses.md` (read it; it has the verified Mathlib atoms and the recommended
signatures).

## CRITICAL structural finding (load-bearing — this is the real cause of the iter-006 stall)
The analogist found that the iter-006 "strong induction generalizing N" skeleton is NECESSARY but
INSUFFICIENT. The torsion reindex inverts an element `g ∈ A`, so the reindexed module `T_g` is finite
over `MvPolynomial (Fin m') (Localization.Away g)` — base ring `A_g`, NOT `A`. The IH of
`exists_free_localizationAway_polynomial` as currently written fixes `A`, so `IH m' _ T_g` does NOT
typecheck (wrong base ring). **The induction must ALSO generalize the base noetherian domain `A`.**
This must be recorded in the blueprint so the iter-008 prover restructures L5 accordingly. `A` is
already an explicit argument, so this is a reversion-into-the-motive change, not a public-signature
change. (A_g remains a noetherian domain: `IsLocalization`/`Localization.Away` of a noetherian domain.)

## TASK 1 — Add two new sub-lemma blocks before `lem:gf_polynomial_core` (statement at L444–469;
proof L471–495). Use these EXACT analogist-recommended signatures as the Lean pins.

### Sub-lemma `lem:gf_generic_rank_ses` — the generic-rank short exact sequence (NO `g`-inversion).
`\lean{AlgebraicGeometry.GenericFreeness.gf_generic_rank_ses}`. Statement: for `A` a noetherian
domain, `d : ℕ`, `N` finite over `P_d := MvPolynomial (Fin d) A` (with the `A`-module +
`IsScalarTower A P_d N` structure), there exist `m : ℕ` and a `P_d`-linear
`φ : (Fin m → P_d) →ₗ[P_d] N` with `φ` injective and `N ⧸ LinearMap.range φ` torsion
(`Module.IsTorsion P_d (N ⧸ range φ)`).
- Informal proof: `m := Module.finrank (FractionRing P_d) (LocalizedModule (nonZeroDivisors P_d) N)`
  (the generic rank — `ℕ`-valued, idiomatic). Take `v : Fin m → N` lifting a `FractionRing P_d`-basis
  of `LocalizedModule (nonZeroDivisors P_d) N` (basis from `Module.finBasis`; lift via
  `IsLocalizedModule.surj` clearing the unit denominators; `LinearIndependent.restrict_scalars`
  descends independence to `P_d`, making `φ := Fintype.linearCombination P_d v` injective).
  `T := N ⧸ range φ` is torsion because `v`'s images form a basis of the localization, so
  `φ ⊗ FractionRing P_d` is surjective and `T ⊗ FractionRing P_d = 0`. Emphasize in prose: the SES
  lives over `P_d` directly — no inversion of any `g ∈ A` is needed at this step (Nitsure's `g`
  belongs entirely to the reindex).
- `\uses{}`: the finite-rank/localization machinery is Mathlib (no project labels), so `\uses{}` may
  be empty or reference only Mathlib anchors if you add any. Do NOT invent project labels.
- SOURCE: this is the SES `0 → A_g[b]^{⊕m} → B_g → T → 0` of the Nitsure §4 quote already in the
  chapter (the L5 SOURCE QUOTE PROOF, nitsure tex L1760–1772). Reuse that citation pointer; you may
  read `references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex` to re-confirm the verbatim text.

### Sub-lemma `lem:gf_torsion_reindex` — re-present a finite torsion `P_d`-module over fewer variables.
`\lean{AlgebraicGeometry.GenericFreeness.gf_torsion_reindex}`. Use the analogist's existential
signature (it mirrors the L4 existential template): for `A` noetherian domain, `0 < d`, `T` finite
over `P_d` with `Module.IsTorsion P_d T`, there exist `g : A`, `g ≠ 0`, `m' < d`, and the
`MvPolynomial (Fin m') (Localization.Away g)`-module + `Localization.Away g`-module +
`IsScalarTower` structure on `LocalizedModule (Submonoid.powers g) T`, such that that localized
module is `Module.Finite` over `MvPolynomial (Fin m') (Localization.Away g)`. (Copy the exact binder
list from `analogies/gf-generic-rank-ses.md` § "Recommended sub-lemma signatures".)
- Informal proof: `Submodule.annihilator_top_inter_nonZeroDivisors` gives `0 ≠ F ∈ Ann_{P_d}(T)`.
  Nagata change of variables makes `F` monic in `X_d` up to a leading coefficient `g ∈ A`; after
  inverting `g`, `A_g[X_1..X_d]/(F)` is module-finite (division algorithm) over
  `A_g[X_1..X_{d-1}] = MvPolynomial (Fin (d-1)) A_g`, and `T_g` (finite over `P_d/(F)`) is finite over
  it by `Module.Finite.trans`. Take `m' = d - 1` — NO `ringKrullDim` theory needed.
- SHARED ENGINE NOTE: record (as a `% NOTE:`) that this single-variable Nagata elimination +
  denominator-clearing is the SAME engine the L4 `lem:gf_noether_clear_denominators` needs — it
  should be built once and reused. (See TASK 3.)
- SOURCE: same Nitsure §4 quote (the "dimension of support … strictly less than n … by induction"
  clause). Reuse the pointer.

## TASK 2 — Rewrite the proof of `lem:gf_polynomial_core` (L5) as a thin assembly over the two new
sub-lemmas, and add the base-domain-generalization structural note.
- Keep the statement block unchanged (signature + SOURCE QUOTE PROOF are correct).
- Rewrite the proof body to: induct on `d` (strong induction) GENERALIZING BOTH `A` AND `N`; `d=0`
  leaf = `lem:gf_finite_module`; `d≥1` torsion sub-case (`N_K=0`) = `lem:gf_torsion_base`; non-torsion
  step: apply `lem:gf_generic_rank_ses` to get `0 → P_d^{⊕m} → N → T → 0` with `T` torsion, then
  `lem:gf_torsion_reindex` to get `g ≠ 0`, `m' < d`, `T_g` finite over `MvPolynomial (Fin m') A_g`;
  apply the IH AT BASE `A_g` (this is why `A` must be generalized) to get `h ≠ 0` in `A_g` with
  `(T_g)_h` free over `(A_g)_h`; descend the witness back to `A` via the localization-tower transport
  of `lem:gf_splice_shortExact_free_transport` (L3b) — `(A_g)_h ≅ A_{g·a}` for `h = a/g^k`; the free
  end `P_d^{⊕m}` localizes free over any `A_{f'}` (it is `Module.Free A (MvPolynomial …)` —
  `MvPolynomial.instFree` — note it is NOT module-finite over `A`, but free is all `lem:gf_splice_shortExact`
  needs); finally `lem:gf_splice_shortExact` (L3) splices to give `N_f` free, `f := g·h`-descended.
- Add a `% LEAN PROOF STRUCTURE (iter-007):` comment block stating the induction must generalize the
  base domain `A` (revert `A` + its `CommRing/IsDomain/IsNoetherianRing` instances into the motive
  alongside `N` and its `d`-dependent instances), because the reindex changes the base ring to `A_g`
  and `IH m' _ (Localization.Away g) T_g` must typecheck at base `A_g`. Cite `analogies/gf-generic-rank-ses.md`.
- Update the proof `\uses{}` to add `lem:gf_generic_rank_ses, lem:gf_torsion_reindex` (keep
  `lem:gf_finite_module, lem:gf_splice_shortExact, lem:gf_torsion_base, lem:gf_splice_shortExact_free_transport`).

## TASK 3 — Decompose `lem:gf_noether_clear_denominators` (L4, statement L354–420; proof L422–442)
into named sub-lemmas with concrete types.
- Add `lem:gf_clear_one_denominator`: a single integral-dependence equation over `K[b_1..b_n]` clears
  to hold over `A_g[b_1..b_n]` after inverting one common denominator `g` of its (finitely many)
  coefficients. Give it a concrete existential Lean signature consistent with the L4 conclusion shape.
- Add a `% NOTE:` that the full L4 is then a `Finset`-fold of `gf_clear_one_denominator` over the
  finite generating set to a single common `g`, followed by the AlgHom assembly already described in
  the L4 proof.
- Rewrite the L4 proof to invoke `gf_clear_one_denominator` + the Finset-fold, keeping the existing
  Noether-normalisation-over-K Step 1 and the final AlgHom construction.
- Cross-reference the SHARED ENGINE: add a `% NOTE:` that `gf_clear_one_denominator`'s denominator-
  clearing is the same primitive `gf_torsion_reindex` uses; if a prover builds a general
  "clear finitely many denominators into one `Localization.Away g`" helper, both consume it.
- Keep the existing Nitsure §4 SOURCE/SOURCE QUOTE PROOF blocks verbatim.

## References
You MAY read `references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex` (§4, ~L1711–1772) to
re-confirm verbatim quotes for the new sub-lemma SOURCE anchors. Do not fabricate citations.

## Out of scope
- Do NOT touch the 9 already-closed declarations, `genericFlatnessAlgebraic`, or `genericFlatness`.
- Do NOT add `\leanok` anywhere (deterministic sync owns it).
- Do NOT edit any `.lean` file or any other chapter.
- The new sub-lemma `\lean{}` names are NEW Lean declarations not yet in the tree — expected.

## Report
List every block added/rewritten (label + `\lean{}` name + the concrete signature). Confirm the
`\uses{}` graph is consistent (L5 assembly → gf_generic_rank_ses + gf_torsion_reindex + finite/torsion
leaves + L3 splice; L4 → gf_clear_one_denominator). Run `leandag build --json` and report
`unknown_uses`/`isolated`/`conflicts`. Flag any strategy-modifying finding (the base-domain
generalization IS one — call it out explicitly so the plan agent records it).
