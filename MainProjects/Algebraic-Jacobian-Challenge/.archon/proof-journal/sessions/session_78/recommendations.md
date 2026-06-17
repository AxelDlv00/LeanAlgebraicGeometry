# Recommendations for the next plan-agent iteration (iter-079)

## Snapshot

- Net iter-078 delta: **−2 sorries** (17 → 15). All three target files compile cleanly.
- Two structural wins: `cotangentExactSeqAlpha.d_app` closed via ζ-bridge (mirror of iter-077's β); `Modules/Monoidal.tensorObj` closed via `letI + show ... from inferInstance` shadow on the sheafification monoidal-struct instance.
- One open structural failure: `h_diff_pi_smul_f` still sorry'd, with a now-confirmed two-obstacle map for the next attempt.

## Prioritised targets for iter-079

### Tier-1 (highest expected value; single Mathlib-gap-fill closes two sorries at once)

**`Modules/Monoidal.lean` — fill `instMonoidalCategoryStruct` and `instMonoidalCategory` via the `LocalizedMonoidal` route.**

Iter-078 task report has the full architectural diagnosis. The mechanical recipe:

1. Write the single instance gap-fill:
   ```lean
   instance :
     ((MorphismProperty.isomorphisms (SheafOfModules X.ringCatSheaf)).inverseImage
       (_root_.PresheafOfModules.sheafification (𝟙 X.ringCatSheaf.obj))).IsMonoidal := …
   ```
   The proof body uses `MorphismProperty.IsMonoidal.mk'` + colimit-preservation by left adjoints (`sheafification` is a left adjoint per `PresheafOfModules.sheafification.IsLeftAdjoint` at `Sheafification.lean:156`). Estimated 5–10 lines.

2. `instMonoidalCategoryStruct := inferInstance` (or single-line definitional rewrite) via `LocalizedMonoidal (L := sheafification _) (W := (isomorphisms _).inverseImage L) (Iso.refl _)`.

3. `instMonoidalCategory := inferInstanceAs (MonoidalCategory (LocalizedMonoidal …))`.

Mathlib precedents:
- `CategoryTheory.Sheaf.monoidalCategory` (`Sites/Monoidal.lean:165`) — exact pattern for fixed-value monoidal categories; our adaptation just substitutes `sheafification` for `presheafToSheaf` and the inverseImage MorphismProperty for the topology's `J.W`.
- `Adjunction.isLocalization` (`Localization/Adjunction.lean`) — gives `L.IsLocalization` from `L ⊣ F` with `F.Full + F.Faithful` (both at `Sheafification.lean:168, 171`).

**Expected outcome**: 2 sorries closed in one targeted lane; 1 helper instance added (qualifies as the "one semantic gap-fill" allowed by the user policy 2026-05-11). **Budget: 3 → 0 (net −2 from this file alone, project total 15 → 13).**

### Tier-2 (high effort, high payoff — needs careful S2–S8 chain)

**`BasicOpenCech.lean` — resume `h_diff_pi_smul_f` at L1110 from the iter-078 `funext j; sorry` state.**

Iter-078 task report documents the two specific obstacles:

- **Obstacle 1**: `Pi.smul_apply` does not fire because the RHS smul is `h_mod_pi₂`-mediated (`RingHom.toModule (presheaf.map …).hom`), not literal `Pi.instSMul`. **Workaround**: `change` to a concrete per-component formula via `h_mod_pi₂`'s builder before invoking `Pi.smul_apply`.
- **Obstacle 2**: `K₀.d ↔ objD` opacity — `K₀.d (prev n) n` is built via `CochainComplex.of` + `(up ℕ).Rel (prev n) n` case-split. **Workaround**: explicit `CochainComplex.of_d_eq_succ` rewrite for the `up ℕ` shape.

**Alternative approach** (flagged in task report S2–S8 alternative): construct `f_R` directly as `LinearMap.mk` using a `restrictScalars`-transported underlying differential. This trades the per-summand chase for building the R-side cochain differential — itself iter-080+ work.

**Constraints to keep**:
- Preserve `set_option maxHeartbeats 800000 in` above `basicOpenCover_isCechAcyclicCover_toModuleKSheaf` (iter-078 added).
- Resume from L1110's `intro r y; funext j; sorry` (iter-078 prefix).
- No new project-local helpers (user policy).

**Realistic expectation**: 0 or 1 closures depending on whether the prover can crack the `change` workaround. **Hard cap: 6 (no regression).**

### Tier-3 (preparation work)

- **`Differentials.lean` — `cotangentExactSeq_structure` at L458**: now that both α and β are closed, the structure-level exactness assembly becomes the next bottleneck. Iter-077/078 disabled chain `/- ITER-076 disabled chain -/` documents the prior in-flight chain (220 LOC with `hα_fac`, `hβ_fac`, `hd_app`, `SheafOfModules.hom_ext`, `isUniversal'.postcomp_injective`, `Derivation.congr_d`, `postcomp_d_apply`). Reopening this requires also closing `SheafOfModules.epi_of_epi_presheaf` and `SheafOfModules.exact_iff_stalkwise` — Mathlib gaps confirmed since iter-074/075. **Recommendation**: defer at least one more iteration until the Mathlib gap-fills are written.

## Off-limits / known blockers (do not assign)

- `Jacobian.lean` `nonempty_jacobianWitness` (L179) — Phase C step C3, iter-085+ at earliest.
- `Picard/Functor.lean` `representable` (L190) — gated on Phase C C0–C3.
- BasicOpenCech L502 (extra-degeneracy on `s`) / L854 (extra-degeneracy on `s₀`) / L826 (`h_π_split` refinement transport) — confirmed multi-iter blockers.
- BasicOpenCech L1150 (`g_R.map_smul'`) — downstream of Lane 2; gated on `h_diff_pi_smul_f` landing + an explicit `Eq.mpr h_eq.symm`-cast variant of `h_diff_pi_smul_g` (iter-077 retrospective).
- BasicOpenCech L1179 (`h_loc_exact`) — needs `IsLocalizedModule.Away f.1` infrastructure not in Mathlib; iter-079+.
- Differentials L122 (`relativeDifferentialsPresheaf_isSheaf`), L742 (`smooth_iff_locally_free_omega`), L759 (`cotangent_at_section`), L901 (`serre_duality_genus`) — all upstream/downstream of Phase B consolidation that is not on the iter-079 critical path.

## Reusable proof patterns discovered or reinforced this iteration

1. **ζ-bridge / η-bridge dual** *(NEW iter-078)*: for composed-adjunction-coherence proofs of the form `bridge ≫ map₁ = map₂ ≫ functorial_map`, the recipe is `apply adj.homEquiv.injective; rw [Adjunction.homEquiv_naturality_right (×2)]; ...; collapse both sides to (f≫g).c via Equiv.apply_symm_apply + the rfl-level Scheme composition identity`. **Two iterations of evidence** (iter-077 β, iter-078 α). Heartbeat budget: `set_option maxHeartbeats 16000000 in`.
2. **`change` over `show` for goal-rewriting** *(NEW iter-078; reinforces iter-077 lint-fix)*: `show` triggers `linter.style.show` AND can leave goal head in a form `rw` does not match; `change` is both lint-clean and `rw`-friendly. Use `change ... = ...` for any goal-rewriting that needs to feed a subsequent rewrite or `dsimp`.
3. **`_root_.PresheafOfModules` disambiguation** *(NEW iter-078)*: when both `_root_.PresheafOfModules` (Mathlib) and `AlgebraicGeometry.Scheme.PresheafOfModules X` are in scope, always use the `_root_` prefix for the Mathlib spelling.
4. **`show ... from inferInstance` for instance-discovery on definitionally-equal forms** *(NEW iter-078)*: when a Mathlib instance is registered on form A and the canonical project-side type is definitionally A but syntactically B, write `letI : C B := show C A from inferInstance` to bind the instance locally on B.
5. **Heartbeat lift via `set_option maxHeartbeats N in` above the theorem** *(reinforced iter-078)*: tactic-block heartbeat sensitivity at the theorem head can be addressed by a lift on the surrounding theorem, not just the inner tactic block. The lift propagates to pre-`intro` whnf normalization.

## Process notes for plan-agent

- The three-lane parallel dispatch worked cleanly with no cross-lane interference (independent files).
- Plan-agent's PROGRESS.md correctly framed the ζ-bridge route (1) as primary for Lane 1; the prover confirmed it works and route (2) was not needed.
- Plan-agent's S1–S8 recipe for Lane 2 correctly diagnoses the per-component goal shape post-`funext`, but does not yet account for the `h_mod_pi₂`-vs-`Pi.instSMul` mismatch obstruction; consider folding this into the next iter's recipe.
- Plan-agent's Lane 3 outline correctly identifies `LocalizedMonoidal` as a candidate; iter-078 confirms it IS the canonical route. Next-iter's PROGRESS should commit to that route explicitly rather than leaving the choice open.
