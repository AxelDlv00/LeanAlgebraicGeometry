# Iter 023 — Objectives (detail)

## Lane 1 — FBC `Cohomology/FlatBaseChange.lean` [fine-grained]

Build + prove the 5-lemma gstar chain (effort-breaker `fbc-gstar`), then close
`base_change_mate_gstar_transpose`. Decls do not exist yet — create from blueprint, bottom-up.

| # | new Lean decl | blueprint label | atoms (\uses) | difficulty |
|---|---|---|---|---|
| 1 | `base_change_mate_inner_unitReduce` | `lem:…_inner_unitReduce` | `_legs_unitExpand`, `_legs_gammaDistribute`, `gammaMap_pushforwardComp_inv_eq_id`, `gammaMap_pushforwardCongr_hom`, `pullback_fst_snd_specMap_tensor` | medium |
| 2 | `base_change_mate_inner_eCancel` | `lem:…_inner_eCancel` | `inner_unitReduce`, `gammaMap_pushforwardComp_hom_eq_id`, `pullback_isEquivalence_of_iso`, `base_change_mate_codomain_read` | **HARD** (ex-Seam-2 step-iii) |
| 3 | `base_change_mate_inner_value_eq` | `lem:…_inner_value_eq` | `inner_eCancel`, `base_change_mate_unit_value`, `pushforward_spec_tilde_iso`, `def:…_inner_value` | medium |
| 4 | `base_change_mate_gstar_generator_close` | `lem:…_gstar_generator_close` | `base_change_mate_regroupEquiv`, `def:…_inner_value` | easy (one-generator ext) |
| 5 | `base_change_mate_gstar_counit_transport` | `lem:…_gstar_counit_transport` | `pullback_spec_tilde_iso`, `gammaPushforwardNatIso`, `unit_conjugateEquiv` | easy — lifts verbatim from landed `huce` scaffold (~L1552–1589) |

Then `gstar_transpose` = counit factorization → Seam C → Seam A (`inner_value_eq`) → Seam B
(`generator_close`).

Order to maximize landed value: 5 (verbatim lift) → 4 (easy) → 1 → 3 → 2 (hard, last; partial OK) →
target combine. Do NOT route through dead `fstar_reindex`/`_legs`. Whole-goal `rfl`/`simp` + per-generator
brute force = confirmed dead ends.

## Lane 2 — GF-geo `Picard/FlatteningStratification.lean` [prove]

Close geometric `genericFlatness` @~2173 over the axiom-clean `genericFlatnessAlgebraic`. 4-step
finite-affine-cover assembly (body already obtains `U₀ = Spec A`, noetherian domain):
1. finite affine cover of quasi-compact `p⁻¹(U₀)`; each `B_j` finite-type over `A`.
2. `M_j := Γ(F,W_j)` finite over `B_j` (from `F.IsFiniteType`); tower `A→B_j→M_j`.
3. `genericFlatnessAlgebraic A B_j M_j → f_j ≠ 0`, `(M_j)_{f_j}` free over `A_{f_j}`; `V := D(∏ f_j)`.
4. freeness ⟹ flatness via flat-at-every-maximal (`Module.flat_of_isLocalized_maximal` /
   `Module.Flat.of_free` [expected]).

Deep lane; honest residual `sorry` with a precise missing-Mathlib comment if a sub-obligation resists
(quasi-coherence/finite-type → finite-module identification, or affine-cover existence are the likely
sticking points).

## Not dispatched (rationale)
- FBC dead-code refactor, FBC affine/FBC-B: sequenced after gstar (interleaving risks the gstar prove).
- QUOT-defs P2: independent openable lane, deferred to keep budget on the two converging frontiers.
- SNAP-S1: gated on the Serre-content reference read (STRATEGY Open questions).
- GF de-private (M1 remainder): cosmetic, owed in a GF-no-prover slot (GF has a prover this iter).
