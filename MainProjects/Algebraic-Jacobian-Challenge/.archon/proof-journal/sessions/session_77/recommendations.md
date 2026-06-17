# Recommendations for the next plan-agent iteration (iter-078)

## Sorry budget orientation

Current active syntactic sorry count: **17**. The +1 net for iter-077 is **structurally healthy** — it represents the C0 scaffold landing (+3 from refactor) minus active prover closures (−2). Plan-agent should expect that the next 1–2 iterations of Phase C prep continue this pattern (small net positive while Mathlib gaps are scaffolded; offset by closing already-staged sorries elsewhere).

For iter-078, aim for **net change ≤ 0** (i.e. close at least as many sorries as any new scaffold introduces).

---

## Priority 1: closest-to-completion (assign first)

### A. `cotangentExactSeqAlpha.d_app` (Differentials.lean L260)

- **Why prioritise**: 1 internal sorry remaining (3 of 4 fields closed in iter-077). The closure technique for d / d_mul / d_map is documented and reusable.
- **Blocker**: Adjunction-coherence `φ_g' ≫ f.c = adj_f.unit ≫ pushforward.map φ_fg'` is no longer `rfl` in current Mathlib. Type-checking requires the pullback-composition functor equality `pullback f . obj (pullback g . obj S.presheaf) = pullback (f≫g) . obj S.presheaf`.
- **Recommended route (in order)**:
  1. Mathlib search for `lan_comp`, `lanCompIso`, `Functor.compLeftAdjoint`, `Adjunction.leftAdjointUniq`.
  2. If absent, construct via uniqueness of left adjoints: `Adjunction.leftAdjointUniq pullbackPushforwardAdjunction _`.
  3. As a fallback, use the η-bridge dual ζ: build `ζ : pullback g S.presheaf ⟶ pushforward f . obj (pullback (f≫g) S.presheaf)` via `adj_fg.homEquiv.symm` of an appropriate composition, then pointwise `(f.c.app U).hom (φ_g'.app U a) = (φ_fg'.app (f⁻¹U)) ((ζ.app U) a)`.
- **Heartbeat budget**: `set_option maxHeartbeats 16000000 in` (the elaboration of the d_target struct alone overflows the default 200k budget).
- **Mathlib leverage verified iter-077**: `Adjunction.homEquiv_naturality_right`, `Adjunction.homAddEquiv_zero`, `Equiv.apply_symm_apply`, `SheafOfModules.hom_ext`, `PresheafOfModules.DifferentialsConstruction.isUniversal'.postcomp_injective`, `PresheafOfModules.DifferentialsConstruction.derivation'.d_app`, `PresheafOfModules.Derivation.congr_d`.

### B. `g_R.map_smul'` (BasicOpenCech.lean L1119)

- **Why prioritise**: f_R.map_smul' closed in iter-077; g-side is the immediate analogue with one structural twist.
- **Blocker**: `↑scK₀.X₃ = ↑(K₀.X ((up ℕ).next n))` does NOT reduce to `↑(∏ᶜ Z₃)` by `rfl` because `(up ℕ).next n` is opaque (Classical.choose over Rel). `h_mod_X₃` therefore uses `rw [h_eq]; exact e₃.toAddEquiv.module R`, making the smul carry an `Eq.mpr`-transport.
- **Recommended recipe** (mirrors iter-077 f_R but threads casts):
  ```lean
  have h_diff_pi_smul_g : ∀ (r : R) (y : ∀ i, Z₂ i),
      letI := h_mod_pi₂
      letI := h_mod_pi₃
      e₃ (h_eq ▸ (⇑(ConcreteCategory.hom scK₀.g) (e₂.symm (r • y)))) =
        r • e₃ (h_eq ▸ (⇑(ConcreteCategory.hom scK₀.g) (e₂.symm y))) := sorry
  ```
  Then in `g_R.map_smul'`, `change` the goal through `h_eq` so `r • (scK₀.g x)` becomes `Eq.mpr h_eq.symm (r • (h_eq ▸ scK₀.g x))`, apply `e₃.injective`, and rewrite via `h_diff_pi_smul_g`.
- **Caveat**: this **trades** L1119 (`g_R.map_smul'`) for one new `h_diff_pi_smul_g` sorry. **Zero net reduction** unless the g-side analogue can be proven within the same iteration.
- **Decision**: only pursue if plan-agent commits to closing `h_diff_pi_smul_g` in the same iter (the structural mathematics is the same as `h_diff_pi_smul_f`; the obstacle is the analogous 5-layer functor stack unfold — see Priority 3).

---

## Priority 2: structural scaffold continuation

### C. `Modules/Monoidal.lean` — tensorObj first (L55)

- **Why**: unblocks Phase C step C1 (LineBundle refinement to invertible-object form).
- **Plan**: assign one prover lane to `tensorObj` only.
- **Recipe**:
  1. Build presheaf-side via `PresheafOfModules.monoidalCategory` (Mathlib).
  2. Sheafify the result via the sheafification functor on `SheafOfModules`.
  3. Verify sheafification compatibility with the `X.ringCatSheaf` index.
- **Caveat**: if the sheafification of a tensor of sheaves of modules is not yet structured in Mathlib in a usable form, this may need its own decomposition (sub-scaffold). Don't combine with the struct/category lanes — leave `instMonoidalCategoryStruct` and `instMonoidalCategory` as `sorry` until tensorObj is solid.

### D. `cotangentExactSeq_structure` (Differentials.lean L387)

- **Why**: deferred; awaiting `cotangentExactSeqAlpha.d_app` closure (Priority 1A).
- **Recipe (after 1A lands)**:
  1. `apply ((Scheme.Modules.pullbackPushforwardAdjunction f).homEquiv _ _).injective`
  2. `rw [Adjunction.homAddEquiv_zero, Adjunction.homEquiv_naturality_right]`
  3. `unfold cotangentExactSeqAlpha; simp only [Equiv.apply_symm_apply]`
  4. `apply SheafOfModules.hom_ext; simp only [SheafOfModules.comp_val, SheafOfModules.pushforward_map_val]`
  5. Re-bind `set φ_g'/φ_fg'/φ_2'/adj_f` and apply `isUniversal'.postcomp_injective`
  6. `ext U b`, then build `hcoh + hcoh_app + hd_app` for the φ_2' derivation
  7. Chain `hα_fac` then `unfold cotangentExactSeqBeta` then `hβ_fac` to collapse via the universal property of both alpha and beta to `(derivation' φ_2').d ((f.c.app U).hom b) = 0`, closed by `hd_app`.
- **Do NOT assign before Priority 1A.**

---

## Priority 3: substantive content (next-next iter)

### E. `h_diff_pi_smul_f` (BasicOpenCech.lean L1079)

- **Status**: documented S1-S8 recipe in-place at L1009-1067 but iter-075/076 attempts hit blockers at the `Pi.smul_apply / Finset.sum_apply / Finset.smul_sum` fire step.
- **Blocker (iter-076 retro)**: the 5-layer functor stack unfold does NOT expose alternating-sum at the head; `Finset.sum_congr rfl fun k _ => ?_` cannot bridge to a per-summand `_ j = _ j` goal that doesn't have ∑ at the head.
- **Recommendation**: re-establish the **cochain-factor identification chain** first (likely requires a curated `simp only` set that exposes ∑ at the head); then apply S1-S8 per-summand R-linearity via `algebraMap_naturality`.
- **Risk**: this is non-trivial. Allocate a full prover lane on it; do not bundle with other work.

---

## Targets to DO NOT assign (blocked / dead-ends)

### Multi-iteration confirmed blockers

- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` **L495** — substep (a) on `s` (extra-degeneracy on slice cover). Confirmed since iter-061+.
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` **L819** — `h_π_split` (kernel-π) refinement transport. `alternatingCofaceMapComplex.map_f` / `FormalCoproduct.cechFunctor.map_app` simp gap.
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` **L847** — substep (a) on `s₀`. Confirmed since iter-061+.
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` **L1148** — `h_loc_exact`. Naïve `LocalizedModule.map_exact` is circular with the outer goal. Needs explicit `IsLocalizedModule.Away f.1` on product `∏ᶜ Z_i`.

### Gated on Phase C

- `AlgebraicJacobian/Jacobian.lean` **L179** — `nonempty_jacobianWitness`. Albanese existence + genus-0 rigidity. Phase-C-C3 deferred existence content.
- `AlgebraicJacobian/Picard/Functor.lean` **L190** — `PicardFunctor.representable`. Gated on Phase C C0-C3 (Modules.Monoidal → LineBundle refinement → PicardFunctor → representable).

### Long-standing deferred (no active blocker but no iter-077 work)

- `AlgebraicJacobian/Differentials.lean` **L122** `relativeDifferentialsPresheaf_isSheaf` — one-line Mathlib closure confirmed absent; needs basic-open helper construction.
- `AlgebraicJacobian/Differentials.lean` **L671** `smooth_iff_locally_free_omega`.
- `AlgebraicJacobian/Differentials.lean` **L688** `cotangent_at_section`.
- `AlgebraicJacobian/Differentials.lean` **L830** `serre_duality_genus`.

---

## Reusable proof patterns discovered iter-077

| Pattern | Where useful | Key insight |
|---|---|---|
| **`letI` + `exact` for transported instances** | Any AddEquiv/LinearEquiv module-instance transport | `have` does NOT register for typeclass synthesis; `convert` is propositional. Use `letI` (registers) + `exact` (literal). |
| **`change` + `e_i.injective` transport** | smul-naturality via AddEquiv transport, when both source/target are literal | Lifts `(f)(r • x) = r • (f x)` through `e_i.symm (r • e_i ·)` form for closing via auxiliary hypothesis. Does NOT lift when transport involves `Eq.mpr` cast. |
| **`show ... from map_add _ _ _` / `from map_mul _ _ _`** | Any CommRingCat.Hom rewrite | Bypasses `CommRingCat.Hom.hom` syntactic-vs-pretty-print mismatch. Equivalent recipe for `RingCat`. |
| **Scheme composition projects through `toLRSHom`** | Any `(f≫g).c` identity at the Scheme level | `(f≫g).c = g.c ≫ pushforward(g).map f.c` is `rfl` — do NOT invoke `LocallyRingedSpace.comp_c` for Scheme morphisms. |
| **`CochainComplex.next` pre-rewrite (iter-076)** | Any instance/coercion transport across `K.X (next n)` | `(ComplexShape.up α).next i = i + 1` via the explicit Mathlib `CochainComplex.next` BEFORE `dsimp`. |
| **`erw` for d_map field of pushforward derivations** | `cotangentExactSeqAlpha`-style derivation transfers | Elaboration-lenient rewrite; the strict `rw` fails on the pushforward goal shape. |
| **Avoid `ι` as binder name when `MonObj` is open** | Any file in this project | Mathlib's scoped notation `ι` = `GrpObj.inv` breaks the parser. Use `α`, `φ`, `j`, `i`. |

---

## Mathlib infrastructure gaps surfaced iter-077

The following gaps should be flagged for either:
- explicit upstreaming (file a Mathlib PR), or
- accepted scaffolding inside the project.

| Gap | Surfaced in | Mitigation |
|---|---|---|
| Pullback-composition iso `pullback f ∘ pullback g ≅ pullback (f≫g)` as natural iso on TopCat.Presheaf | `cotangentExactSeqAlpha.d_app` | Build via `Adjunction.leftAdjointUniq`. Likely worth its own iter. |
| `IsLocalizedModule.Away f.1` instance on `LocalizedModule (powers f) (∏ᶜ Z_i) ≅ ∏ᶜ LocalizedModule (powers f) Z_i` for finite indexing | `h_loc_exact` (L1148) | Non-trivial; likely needs an analogy subagent to find precedent. |
| Sheafified tensor on `SheafOfModules X.ringCatSheaf` | `Modules/Monoidal.tensorObj` | Use Mathlib's sheafification adjunction; verify compatibility with `ringCatSheaf`. |

Consider invoking the **`analogy` subagent** at iter-078 plan-time on the pullback-composition iso (Priority 1A); the `Adjunction.leftAdjointUniq` route is a Mathlib-precedent question that benefits from a focused analysis.

---

## Recommended lane assignment for iter-078

| Lane | File | Target | Budget |
|---|---|---|---|
| Lane 1 | `Differentials.lean` | `cotangentExactSeqAlpha.d_app` (L260) — build pullback-composition iso, close d_app field | −1 |
| Lane 2 | `Cohomology/BasicOpenCech.lean` | `g_R.map_smul'` (L1119) — state `h_diff_pi_smul_g` with Eq.mpr casts AND close it | −1 (only if g-side aux can be closed) |
| Lane 3 | `Modules/Monoidal.lean` | `tensorObj` (L55) — sheafify presheaf tensor | −1 |
| Sub | analogy subagent | precedent search for `pullback f ∘ pullback g ≅ pullback (f≫g)` natural iso | n/a |

**Realistic iter-078 target**: net **−2 sorries** (15 active). If g-side can't be closed in-iteration, accept net −1 (16 active) and roll the g-side aux to iter-079.

**Hard constraints to carry forward**:
- No new project-local helper lemmas (user policy 2026-05-11).
- No `lean_run_code` pre-validation (user policy).
- No new axioms.
- Per-edit `lean_diagnostic_messages` verification.
