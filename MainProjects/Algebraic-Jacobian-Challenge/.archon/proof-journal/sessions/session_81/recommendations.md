# Recommendations for the next plan-agent iteration (iter-082)

## Net iter-081 summary

- Sorry count: 14 → 14 (no regression; no closure).
- Two lanes ran (BasicOpenCech, Differentials). Modules/Monoidal off-limits.
- One substantive helper landed fully closed: `_root_.PresheafOfModules.Derivation.postcomp_comp` at `Differentials.lean` L455–465.
- Two structural advances on top of iter-080:
  - **Lane 1**: S2+S3+S4 of the BasicOpenCech recipe executed inline; the explicit alternating-sum form is now exposed at the L1196 sorry. Iter-080 plan's `CochainComplex.of_d_eq_succ` proposal is debunked (lemma does not exist); the correct trick is `dif_pos hRel` inside a full `simp` invocation (not `simp only`).
  - **Lane 2**: Route (c) chain for `h_zero` was implemented and verified compiling. Reverted only because `h_epi` blocker (forget₂-image module instance synthesis) could not close in tandem; the verified chain is preserved as a comment block at L507–525.
- Lane 2 conditional clause respected (no 5 → 6 regression via free-floating `exact_iff_stalkwise`).

The plan agent should prioritize **Lane 1 Phase B (S5–S8)** and **Lane 2 reinstatement + `h_epi` Mitigation Route 2** for iter-082, as both have low-LOC paths to closure on top of the iter-081 structural advances.

---

## Headline targets (highest leverage)

### 1. **Lane priority — `BasicOpenCech.h_diff_pi_smul_f` Phase B closure (S5–S8)**

Iter-081 expanded the L1176 sorry's body with the S2+S3+S4 chain that produces the explicit alternating-sum form at the (now L1196) sorry. The remaining per-summand R-linearity decomposition is mechanical (~30 LOC inline). Preserve byte-for-byte:

- `set_option maxHeartbeats 800000 in` at L418 (iter-078).
- `letI perI_n` + `letI h_mod_pi_n := Pi.module _ _ _` block at L920–949 (iter-080, named-per-i refactor).
- `intro r y; funext j` at L1093–1094.
- The iter-081 inline `rcases n; …; dsimp only [...]; simp [..., dif_pos hRel]` chain at L1176–1195 (the S2+S3+S4 expansion).

**Phase B recipe (concrete)**:

1. **S5 (distribute `e₂` and the alternating sum through `Pi.lift`)**: surface per-`(i, j')` summands at the j-component.
   - Need `Pi.π Z₁ k (e₁.symm z) = z k` (from `piIsoPi_inv_kernel_ι`) to reduce the inner argument on the LHS where `z := e₁.symm (r • y)`.
   - Use `eqToHom_app` (or `LinearMap.eqToHom_apply`) to commute the eqToHom cast through the sum.
   - For the post-`Pi.smul_apply` form on LHS, evaluate `(r • y) (j' ∘ δ_i.toOrderHom) = perI₁ … .smul r (y (j' ∘ δ_i.toOrderHom))` (i.e., `r • y (...)`).
2. **S6 (distribute `r •` across RHS)**: `rw [Finset.smul_sum]`. Then `simp only [smul_smul]` if `(-1)^i • (r • _) → (-1)^i • r • _` needs alignment, but more likely `Finset.sum_congr rfl` per-summand handles it.
3. **S7 (per-summand R-linearity at fixed `i, j'`)**: `apply Finset.sum_congr rfl; intro i _; apply Finset.sum_congr rfl; intro j' _`. Per summand:
   - LHS: `(toModuleKPresheaf C).map (φ_{i, j'}).op .hom (z_LHS (j' ∘ δ_i.toOrderHom))` where `z_LHS = e₁.symm (r • y) ↦ Pi.π Z₁ (j' ∘ δ_i.toOrderHom) (e₁.symm (r • y))`.
   - For `z_LHS (j' ∘ δ_i.toOrderHom)`, use `perI₁ (j' ∘ δ_i.toOrderHom)` to evaluate `r • y (...)` and then `(presheaf.map (V_{j' ∘ δ_i} ≤ U).op).hom r * y (j' ∘ δ_i.toOrderHom)` via the underlying `RingHom.toModule` smul definition.
   - Apply `RingHom.map_mul` (the `.hom` of `presheaf.map (V_{j'} ≤ V_{j'∘δ_i}).op` is a ring-hom) to distribute the multiplication.
   - Apply `← C.left.presheaf.map_comp` to collapse the two restrictions `(V_{j' ∘ δ_i} ≤ U).op ≫ (V_{j'} ≤ V_{j' ∘ δ_i}).op` into `(V_{j'} ≤ U).op`.
4. **S8**: per-summand identity closes by `rfl` or `ring`.

**Partial-credit fallback**: if S5–S7 succeeds but S8 stalls, use `apply Finset.sum_congr rfl; intro k _; apply (...); ring_nf; sorry` to preserve at most the S8 residual; this is a 1-for-1 sorry (not a regression — still 6 in file). Document precisely what the per-summand residual is in the body so iter-083 has a clean handoff.

**Hard constraints (preserve from iter-080/081)**:
- `letI perI_n`/`letI h_mod_pi_n` block at L920–949 (byte-for-byte).
- `set_option maxHeartbeats 800000 in` at L418.
- `funext j` at L1094.
- The iter-081 S2+S3+S4 chain at L1176–1195 (replaces the iter-080 rationale block).
- No new project-local helper lemmas (user policy 2026-05-11). The S5–S8 chain must run inline.
- No new axioms.
- No `lean_run_code` pre-validation. `lean_diagnostic_messages` + `lean_multi_attempt` for position-bound previews are allowed.

**Sorry budget**: 6 → 5 (target close `h_diff_pi_smul_f`); hard cap 6.

**Dead-end warnings (DO NOT re-attempt)**:
- `simp only` cannot replace full `simp` for the S2–S4 chain (iter-081 confirmed).
- `CochainComplex.of_d_eq_succ` does NOT exist in Mathlib (iter-080 plan recipe's error).
- All Pre-iter-080 anonymous `Pi.module` builder variants — they re-introduce the iter-076/078/079 `Pi.smul_apply` blocker.

---

### 2. **Lane priority — `Differentials.cotangentExactSeq_structure` reinstatement + `h_epi` Mitigation Route 2**

Iter-081 verified Route (c) works for `h_zero`. The blocker is `h_epi`'s forget₂-image module instance synthesis (forget₂-image `Module ((R ⋙ forget₂ CommRingCat RingCat).obj U)` instance is not bridged by Lean's typeclass resolution to the raw-ring `Module (R.obj U)` instance expected by `Submodule.mem_top` / `span_range_derivation`).

**Recommended iter-082 recipe**:

1. **Reinstate `_root_.SheafOfModules.exact_iff_stalkwise` as a permitted helper with `sorry` body** above `cotangentExactSeq_structure` (alongside the iter-079 `epi_of_epi_presheaf` and the iter-081 `Derivation.postcomp_comp`). The plan agent's iter-081 `\lean{...}` macro entry in `Differentials.tex` (Lemma `lem:sheafOfModules_exact_iff_stalkwise`) already points at this name. Signature template:
   ```lean
   lemma _root_.SheafOfModules.exact_iff_stalkwise
       {C : Type*} [Category C] {J : CategoryTheory.GrothendieckTopology C}
       [HasForget C] {R : CategoryTheory.Sheaf J RingCat}
       (S : CategoryTheory.ShortComplex (SheafOfModules R)) :
       S.Exact ↔ ∀ x, (S.map (TopCat.Presheaf.stalkFunctor _ x ⋙ …)).Exact := by sorry
   ```
   (Use the existing `SheafOfModules.epi_of_epi_presheaf` shape as template; the precise type of `stalkFunctor` is decided by the prover.)

2. **Reinstate the Route (c) chain for `h_zero`** (preserved as comment at L507–525 of `cotangentExactSeq_structure`):
   ```
   refine ⟨?_, ?_, ?_⟩
   · -- h_zero (verified iter-081):
     apply ((Scheme.Modules.pullbackPushforwardAdjunction f).homEquiv _ _).injective
     rw [Adjunction.homAddEquiv_zero, Adjunction.homEquiv_naturality_right]
     unfold cotangentExactSeqAlpha
     simp only [Equiv.apply_symm_apply]
     apply SheafOfModules.hom_ext
     change (PresheafOfModules.DifferentialsConstruction.isUniversal' _).desc _ ≫
         (PresheafOfModules.pushforward f.toRingCatSheafHom.hom).map
           (cotangentExactSeqBeta f g).val = 0
     apply (PresheafOfModules.DifferentialsConstruction.isUniversal' _).postcomp_injective
     rw [PresheafOfModules.Derivation.postcomp_comp]
     simp only [PresheafOfModules.Derivation.Universal.fac]
     apply PresheafOfModules.Derivation.ext
     ext U b
     -- ...set φ_g'/φ_fg'/φ_2'/adj_f, hcoh, hd_app, hβ_fac...
     simp only [PresheafOfModules.Derivation.postcomp_d_apply]
     dsimp only [AddMonoidHom.mk', AddMonoidHom.coe_mk, ZeroHom.coe_mk]
     unfold cotangentExactSeqBeta
     change (((isUniversal' φ_fg').desc _).app
         (op ((Opens.map f.base).obj U.unop))).hom
           ((derivation' φ_fg').d ((f.c.app U).hom b)) = _
     rw [hβ_fac _ ((f.c.app U).hom b)]
     rw [hd_app]
     rfl
   ```

3. **Close `h_exact`** via the reinstated gap-fill: `exact SheafOfModules.exact_iff_stalkwise _` applied with `KaehlerDifferential.exact_mapBaseChange_map` pointwise.

4. **Close `h_epi` via Mitigation Route 2 (structural identification)**:
   - Extract the η-coherence square `hη : η.app U ≫ φ_2'.app U = φ_fg'.app U` from `cotangentExactSeqBeta`'s body, OR recompute inline.
   - Show `(d1.app U.unop).desc = CommRingCat.KaehlerDifferential.map hη` via `KaehlerDifferential.ext` + `CommRingCat.KaehlerDifferential.map_d`.
   - Apply `KaehlerDifferential.map_surjective_of_surjective` with `surjective_id` on the ring-level side.

   This sidesteps the forget₂-image typeclass synthesis gap because `CommRingCat.KaehlerDifferential.map` carries its surjectivity lemma at the right type.

**Hard constraints (preserve)**:
- Three project-local helpers permitted: `epi_of_epi_presheaf` (iter-079, closed), `Derivation.postcomp_comp` (iter-081, closed), `exact_iff_stalkwise` (iter-082, sorry body authorised). NO additional helpers.
- Preserve `Derivation.postcomp_comp` byte-for-byte at L455–465.
- No new axioms. No `lean_run_code` pre-validation.

**Sorry budget**: starts at 5; target 5 net (1-for-1 shift: `_structure` body sorry → `exact_iff_stalkwise` body sorry). Stretch 5 → 4 if `exact_iff_stalkwise` body closes via the stalk-functor chain.

**Conditional clause (preserve)**: if Route (c) reinstatement fails or `h_epi` Mitigation Route 2 fails, do NOT introduce `exact_iff_stalkwise` as a free-floating sorry. Either close `_structure` together with introducing the gap-fill, OR keep iter-081 state and document.

---

### 3. **Lane priority — `Modules/Monoidal.instIsMonoidal_W`: KEEP DEFERRED**

Mathlib gap (`PresheafOfModules.stalk_tensorObj` for varying-ring R₀) unchanged. Do NOT assign this lane in iter-082. Phase C step C1 (LineBundle refactor) can proceed independently; the sorry does not block downstream consumers.

**Long-term**: upstream Mathlib PR remains the structural fix.

---

## Reusable proof patterns surfaced this session

1. **`dif_pos hRel` inside a full `simp` to flush `CochainComplex.of_d`** (iter-081, NEW). The full simp engine performs the elaboration that selects the `then` branch of the internal `dite`. `simp only` cannot do this. Useful whenever a goal has `CochainComplex.of_d (prev n) n` and you need to surface the `succ`-shape differential.

2. **`_root_.PresheafOfModules` disambiguation under `Scheme` namespace** (iter-081, NEW). Always `_root_.PresheafOfModules.Derivation`, `_root_.PresheafOfModules.comp_app`, etc. when declaring Mathlib-shape lemmas inside `AlgebraicGeometry.Scheme`.

3. **`ext + simp only [postcomp_d_apply, comp_app] + rfl` for Derivation composition** (iter-081, NEW). The minimal proof shape for `d.postcomp (f ≫ g) = (d.postcomp f).postcomp g`. The `rfl` is essential: `simp only [ModuleCat.hom_comp]` does not fire on the residual `(f.app X ≫ g.app X).hom (...)` LHS shape, but `rfl` recovers via `LinearMap.comp` defeq.

4. **Anti-pattern: `Submodule.mem_top y` cannot bridge forget₂-image module instances** (iter-081, NEW). When `M : ModuleCat ((R ⋙ forget₂ CommRingCat RingCat).obj U)` and you need `Module (R.obj U) M`-shaped lemmas, prefer structurally identifying the descent with a Mathlib `KaehlerDifferential.map`-shaped morphism rather than fighting the typeclass synthesizer with `change` or `letI`.

---

## Blocked / off-limits (preserve)

- `Modules/Monoidal.instIsMonoidal_W` — Mathlib gap; iter-082+ defer.
- `Jacobian.nonempty_jacobianWitness` — Phase C step C3, iter-086+ earliest.
- `Picard/Functor.PicardFunctor.representable` — gated on Phase C C0–C3.
- BasicOpenCech L502, L826, L854 — confirmed dead-end substeps.
- BasicOpenCech L1241 `g_R.map_smul'`, L1270 `h_loc_exact` — downstream / needs `IsLocalizedModule.Away f.1` infra; iter-082+.
- Differentials L122 `relativeDifferentialsPresheaf_isSheaf`, L810 `smooth_iff_locally_free_omega`, L827 `cotangent_at_section`, L969 `serre_duality_genus` — long-standing transients.

---

## Realistic iter-082 target

**Net −1 to −2 sorries** (12–13 active). Best-case path:
- **Lane 1**: Phase B closure (S5–S8). 6 → 5 in BasicOpenCech.
- **Lane 2**: full reinstatement (Route (c) `h_zero` + `exact_iff_stalkwise` gap-fill `h_exact` + Mitigation Route 2 `h_epi`). 5 → 5 net (1-for-1 shift), stretch 5 → 4.

If only Lane 1 lands, **−1**. If both lanes land plus the stretch on Differentials, **−2**.
