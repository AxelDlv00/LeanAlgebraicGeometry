# Recommendations for the next plan-agent iteration (iter-081)

## Net iter-080 summary

- Sorry count: 14 → 14 (no regression; no closure).
- All three lanes respected hard caps; none hit the closure target.
- Two structural unblocks landed (Lane 1's named-per-i refactor, Lane 2's Route A structural advance), both setting up iter-081 for higher-leverage closure attempts.
- One Mathlib gap precisely characterized (Lane 3: `PresheafOfModules.stalk_tensorObj` for varying-ring R₀).

The plan agent should prioritize **Lane 1 closure** and **Lane 2 route (a) + (c)** for iter-081, as both have low-LOC paths to closure on top of the iter-080 structural unblocks. Lane 3 should be deferred (Mathlib upstream concern; downstream consumers do not depend on it).

---

## Headline targets (highest leverage)

### 1. **Lane priority — `BasicOpenCech.h_diff_pi_smul_f` S2–S8 closure**

The iter-080 named-per-i refactor + `Pi.smul_apply` firing is locked in (preserve byte-for-byte: L920–949). The remaining S2–S8 chain is unblocked but multi-step. Recommended iter-081 sub-recipe:

**Phase A (target ~20 LOC, single iteration)**: land S2 + S3 + S4.

- **S2** — verified working: `dsimp only [scK₀, K₀, cechCochain, cechComplexFunctor, toModuleKSheaf, toModuleKPresheaf_obj]`.
- **S3** — `K₀.d (prev n) n = objD X (prev n)` via `CochainComplex.of_d_eq_succ` after `(up ℕ).Rel (prev n) n` case-split. This is the hardest pain point because of implicit-argument instantiation. Suggestion: introduce an intermediate `have hd : (up ℕ).Rel (prev n) n := by rfl` *before* invoking `of_d_eq_succ`.
- **S4** — `objD X m = ∑ k : Fin (m+2), (-1)^k • X.δ k` via `AlternatingCofaceMapComplex.objD`.

**Phase B (target ~30 LOC, single iteration)**: land S5–S8.

- **S5** — `simp only [Pi.smul_apply]` distributes the smul into the alternating-sum LHS (post-S4 shape).
- **S6** — `rw [Finset.smul_sum]` on RHS.
- **S7** — `apply Finset.sum_congr rfl; intro k _` per-summand. Per `k`, the j-component of `X.δ k` is `Pi.π Z₁ (j ∘ δ_k.toOrderHom) ≫ (P.map (φ_k j).op)` via `evalOp_obj_map` + `Pi.lift`. Per-component R-linearity follows from `RingHom.map_mul` + `← presheaf.map_comp` on the V_j ≤ V_{j∘δ_k} ≤ U chain.
- **S8** — `rfl` or `ring`.

If Phase A succeeds but Phase B stalls, leave the per-summand `Finset.sum_congr` block as a `?_` placeholder and document the per-summand goal in the body — this gives iter-082 a clean handoff.

**Hard constraints (preserve from iter-080)**:
- `letI perI₁/₂/₃` + `letI h_mod_pi₁/₂/₃` block at L920–949 (byte-for-byte).
- `set_option maxHeartbeats 800000 in` at L418.
- `funext j` at L1094.
- No new project-local helpers (user policy 2026-05-11).
- No new axioms.

### 2. **Lane priority — `Differentials.cotangentExactSeq_structure.h_zero` via route (a) or (c)**

Iter-080's Route A reaches `ext U b` cleanly; the only blocker is the inline-`d_target` pattern mismatch in `rw [hα_fac _ b]`. Three low-LOC unblock recipes are documented in the iter-080 body comment block. Recommended priority:

**Route (a) — `set d_target` BEFORE the universal-property invocation** (preferred, no Mathlib gap, no refactor authorisation):

```lean
-- Inside h_zero, BEFORE `unfold cotangentExactSeqAlpha`:
set d_target := { d := fun {U} ↦ AddMonoidHom.mk' …, d_mul := …, d_map := …, d_app := … } with hd_target
-- Then unfold + simp pipeline; `hα_fac d_target b` now pattern-matches because d_target is a named handle.
```

The challenge is binding the inline structure before the elaborator surfaces it via `unfold`. Suggested approach: write the `d_target := …` literal at the *top* of the body, then `change cotangentExactSeqAlpha f g ≫ … = 0 from (by show … = … using d_target)` to align.

**Route (c) — Add Mathlib-shape helper `Derivation.postcomp_comp` and skip `ext U b`** (fallback, adds one helper):

```lean
-- New Mathlib-shape helper (one-line proof via Derivation.ext + standard simp set):
lemma _root_.PresheafOfModules.Derivation.postcomp_comp
    {R : …} {M N P : PresheafOfModules R} (d : Derivation R M)
    (f : M ⟶ N) (g : N ⟶ P) :
    d.postcomp (f ≫ g) = (d.postcomp f).postcomp g := by
  apply Derivation.ext
  intro U b
  simp [postcomp_d_apply, comp_app, hom_comp, LinearMap.comp_apply]
```

With this helper, the chain collapses to `d_target.postcomp ((pushforward _).map β.val) = 0`, sidestepping `ext U b` entirely. The remaining obligation is shorter because `d_target.d` is the outer identifier.

**Route (b) — Refactor `cotangentExactSeqAlpha` to expose `d_target` as a named `noncomputable def`** (escalation): dispatch via refactor subagent. Only if (a) and (c) both fail.

**Once `h_zero` closes**:
- Introduce `SheafOfModules.exact_iff_stalkwise` as the second permitted gap-fill (sorry body authorised per iter-080 plan; signature flexible).
- Chain `SheafOfModules.epi_of_epi_presheaf` (iter-079, in place at L437–443) + `PresheafOfModules.epi_iff_surjective` + `KaehlerDifferential.map_surjective` for `h_epi`.

**Target**: `_structure` body sorry eliminated; `exact_iff_stalkwise` sorry body introduced. **Net file change: 5 → 5** (1-for-1 shift), with stretch goal **5 → 4** if `exact_iff_stalkwise` closes via the stalk-functor chain.

**Hard constraints**:
- Preserve `SheafOfModules.epi_of_epi_presheaf` declaration byte-for-byte (L437–443).
- Conditional clause from iter-080: if `h_zero` does not close, do NOT introduce `exact_iff_stalkwise` as a free-floating sorry.
- Two permitted gap-fills total (`epi_of_epi_presheaf` already landed; `exact_iff_stalkwise` is the second). No additional helpers without explicit plan-agent authorisation.

### 3. **Lane priority — `Modules/Monoidal.instIsMonoidal_W`: DEFER**

Iter-080 confirmed the genuine Mathlib gap: `(M ⊗_psh N).stalk x ≅ M.stalk x ⊗_{R₀.stalk x} N.stalk x` for varying-ring `PresheafOfModules R₀` is absent. Closing this sorry without either (i) a Mathlib upstream PR, or (ii) a user-authorised project-local axiom is not tractable in iter-081.

**Recommendation**: do NOT assign this lane to a prover in iter-081. Phase C step C1 (LineBundle refactor to invertible-O_X-modules) can proceed independently — `MonoidalCategory X.Modules` is fully synthesisable downstream because `instMonoidalCategory` is closed (the sorry is inside the auxiliary instance `instIsMonoidal_W`, not exposed at the top-level).

**Long-term**: consider an upstream Mathlib PR adding `PresheafOfModules.stalk_tensorObj` for varying-ring R₀. This would unblock not only this project but any future formalization needing `MonoidalCategory.Sheaf` for ringed-space-style categories.

---

## Reusable proof patterns surfaced this session

1. **`letI`-bound named per-i `Pi.module` expansion** — when `simp [Pi.smul_apply]` fails against a `Pi.module`-built smul, expand the anonymous per-i constructor into a named `letI perI : ∀ i, Module R (β i) := …` followed by `letI h : Module R (∀ i, β i) := Pi.module _ _ _`. Both `letI`. Byte-for-byte equivalent; only typeclass visibility changes.

2. **Anti-pattern: inline anonymous structures in declaration bodies** — surfacing them via `unfold` produces inline let-bound terms that the unifier cannot match against metavariables (e.g. `Universal.fac`'s `?d_t`). Either bind to a named handle via `set` BEFORE `unfold`, refactor to expose as a `noncomputable def`, or add a composition-style Mathlib-shape helper that sidesteps the matcher.

3. **`lean_multi_attempt` for tactic-attempt previews** (reconfirmed from iter-079) — allowed and recommended for verifying tactic candidates at a position without saving to file. Particularly effective for verifying dsimp/rw chains in long proofs.

---

## Blocked / off-limits this iteration (preserve)

- `AlgebraicJacobian/Jacobian.lean` `nonempty_jacobianWitness` — Phase C step C3, iter-085+ at the earliest.
- `AlgebraicJacobian/Picard/Functor.lean` `PicardFunctor.representable` — gated on Phase C C0–C3 scaffolding.
- `BasicOpenCech.lean` L502, L826, L854 — confirmed dead-end substeps (extra-degeneracy on slice covers + `h_π_split` analogue).
- `BasicOpenCech.lean` L1185 `g_R.map_smul'` — downstream of Lane 1 closure; deferred.
- `BasicOpenCech.lean` L1214 `h_loc_exact` — needs `IsLocalizedModule.Away f.1` infrastructure (not in Mathlib); iter-081+.
- `Differentials.lean` L122 `relativeDifferentialsPresheaf_isSheaf`, L771 `smooth_iff_locally_free_omega`, L788 `cotangent_at_section`, L930 `serre_duality_genus` — long-standing transients pending upstream Phase B infrastructure.
- `Modules/Monoidal.lean` `instIsMonoidal_W` — Mathlib gap, defer.

---

## Realistic iter-081 target

**Net −1 to −2 sorries** (12–13 active). Best-case path:
- Lane 1 closure (S2–S8 complete): 6 → 5 in BasicOpenCech.
- Lane 2 route (a) or (c) success: 5 → 5 net in Differentials (1-for-1 shift `_structure` → `exact_iff_stalkwise`), with **stretch** 5 → 4 if the stalkwise helper closes.

If only one lane lands, **−1** total. If both lanes land plus the stretch on Differentials, **−2** total.
