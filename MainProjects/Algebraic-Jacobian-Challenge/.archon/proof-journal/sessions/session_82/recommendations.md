# Recommendations for the next plan-agent iteration (iter-083)

## Net iter-082 summary

- Sorry count: 14 → 14 (no regression; no closure).
- Two lanes ran (BasicOpenCech, Differentials). Modules/Monoidal off-limits.
- No new helpers landed (both planned helpers — `exact_iff_stalkwise`,
  `cotangentExactSeqBeta_hη` — deferred).
- Two structural advances on top of iter-081:
  - **Lane 1**: S5 prelude executed — `j`-projection pushed past `piIsoPi Z₂` via
    `rw [show … from rfl]` re-fold + `piIsoPi_hom_ker_subtype_apply`. The `h_diff_pi_smul_f`
    sorry now lives at L1240 (was L1196) with the goal in `(Pi.π Z₂ j).hom (...)` form.
  - **Lane 2**: Route (c) chain for `h_zero` reinstated in **active code** (~70 LOC at
    L488–559). The remaining `h_exact ∧ h_epi` is now a structurally narrower absorbed
    sorry at L576.
- Lane 2 conditional clause respected again (no 5 → 6 regression via free-floating
  `exact_iff_stalkwise`).

The plan agent should now commit to a **single chosen path** on each lane for iter-083
rather than the iter-076 → 082 pattern of attempting multiple routes serially without
closure.

---

## Headline targets (highest leverage)

### 1. **Lane priority — `BasicOpenCech.h_diff_pi_smul_f` Phase B closure (S6–S8 via path (a))**

Iter-082 confirmed that the iter-081 plan's S6 path-(a) cannot proceed via direct
`LinearMap.comp_apply`: the Mathlib lemma's `∘ₛₗ` signature does not unify with the
goal's homogeneous `∘ₗ` shape despite definitional equality. The DEAD-END warnings
are now inline in the source at L1180–1196.

**Recommended iter-083 path — Path (a) "named-comp abbreviation"**:

Refactor the iter-081 S2+S3+S4 `simp` chain to introduce a `let M` abbreviation
**BEFORE** the simp collapses the comp into a syntactic `∘ₗ`. Concretely:

1. After the iter-081 `dsimp only [scK₀, K₀, cechCochain, cechComplexFunctor, toModuleKSheaf, toModuleKPresheaf_obj]`
   step (at L1146–1148), insert:
   ```lean
   set M : ↑(∏ᶜ Z₁) →ₗ[k] ↑(∏ᶜ Z₂) := eqToHom _ ∘ₗ Σ_hom with hM
   ```
   (or use `let` if `set` doesn't have the right syntactic effect — needs trial).
2. Modify the subsequent full `simp [..., dif_pos hRel]` set to NOT unfold `M`
   (don't include `M` in the simp set — it stays as a named LinearMap).
3. After the S5 prelude (iter-082 advance, preserved byte-for-byte), the goal is:
   ```
   (Pi.π Z₂ j).hom (M ((piIsoPi Z₁).inv (r • y)))
     = r • (Pi.π Z₂ j).hom (M ((piIsoPi Z₁).inv y))
   ```
4. Per-summand R-linearity: prove `M.map_smul` from the per-summand decomposition:
   ```lean
   have hM_smul : ∀ (r : R) (y : ↑(∏ᶜ Z₁)),
       (Pi.π Z₂ j).hom (M (perI₁ … r y)) = r • (Pi.π Z₂ j).hom (M y) := by
     ...
   ```
   (the R-action on the source is via `perI₁`; the R-action on the target's
   j-component is via `perI₂ j`). Internal decomposition still follows the
   iter-081 plan recipe S7: `RingHom.map_mul` + `← presheaf.map_comp` per summand.

**Alternative iter-083 path — Path (b) "per-summand without splitting comp"**:

Don't split the comp. Use `Pi.lift_apply` + `Finset.sum_apply` to evaluate the
inner alternating sum **inside** the `eqToHom_hom ∘ₗ` wrapper, then identify
the wrapper's action on each summand individually:
```
(eqToHom_hom ∘ₗ Σ_hom) z = eqToHom_hom (Σ_hom z)   -- avoided; needs `comp_apply`
                                                    -- (BLOCKED — see iter-082)

(eqToHom_hom ∘ₗ Σ_hom) z applied at j               -- the actual goal shape
  = (Pi.π Z₂ j).hom (eqToHom_hom (Σ_hom z))
  = eqToHom_app's action at j (eqToHom_app + LinearMap.eqToHom_apply)
  = `Σ_hom z j` after eqToHom collapses on the j-component
```

This sidesteps the comp split entirely by going through `LinearMap.eqToHom_apply` or
`eqToHom_app` to commute the cast past the `(Pi.π Z₂ j).hom`. Trial in iter-083.

**Hard constraints (preserve from iter-080/081/082)**:
- `letI perI_n`/`letI h_mod_pi_n` block at L920–949 (byte-for-byte).
- `set_option maxHeartbeats 800000 in` at L418.
- `intro r y; funext j` at L1093–1094.
- Iter-081 S2+S3+S4 chain at L1102–1153 (preserved iter-082).
- **Iter-082 S5 prelude at L1161–1170** (the `rw [show … from rfl]` re-fold +
  `piIsoPi_hom_ker_subtype_apply` push).
- No new project-local helper lemmas (user policy 2026-05-11).
- No new axioms.
- No `lean_run_code` pre-validation.

**Sorry budget**: 6 → 5 (target close `h_diff_pi_smul_f`); hard cap 6.

**Dead-end warnings (DO NOT re-attempt — iter-082 confirmed)**:
- `simp only [LinearMap.comp_apply]` against homogeneous `∘ₗ` (∘ₛₗ-vs-∘ₗ unification fails).
- `simp only [LinearMap.coe_comp, Function.comp_apply]` (no explicit coercion to fire on).
- `change` to unfolded comp form (eqToHom's implicit type proof not displayable).
- `{cone := …, isLimit := …}` brace syntax in `show … from rfl` (use `⟨_,_⟩`).

---

### 2. **Lane priority — `Differentials.cotangentExactSeq_structure` h_epi via refactor approach (Option A)**

Iter-082 reinstated the iter-081 verified Route (c) chain for `h_zero` in active
code, so the `case h_zero` branch is closed. The remaining `h_exact ∧ h_epi`
conjunction lives in `case h_rest` as a single absorbed `sorry` at L576.

Iter-082's attempts at `h_epi` via Mitigation Route 2 (Route 2: identify the
descent with `CommRingCat.KaehlerDifferential.map` then apply
`KaehlerDifferential.map_surjective`) all failed at the same bundled-vs-unbundled
typeclass-coercion barrier diagnosed in iter-081. The path was clearly identified
but the inline execution requires structural refactoring that doesn't fit in a
single prover lane.

**Recommended iter-083 path — Option A "refactor approach"** (refactor-subagent eligible):

1. **Plan agent invokes the `refactor` subagent** to extract the η-coherence
   currently inline inside `cotangentExactSeqBeta`'s body as a top-level helper:
   ```lean
   lemma cotangentExactSeqBeta_hη {X Y S : Scheme} (f : X ⟶ Y) (g : Y ⟶ S) :
       ∃ (η : (TopCat.Presheaf.pullback CommRingCat (f ≫ g).base).obj S.presheaf ⟶
              (TopCat.Presheaf.pullback CommRingCat f.base).obj Y.presheaf),
         η ≫ φ_2'-of-f = φ_fg'-of-fg := by
     ...
   ```
   Re-prove `cotangentExactSeqBeta` to use this helper. This removes the ~30-line
   `hη` re-derivation that the iter-082 `h_epi` attempt needed to do inline.

2. **Plan agent introduces `_root_.SheafOfModules.exact_iff_stalkwise` as a permitted helper with `sorry` body**:
   ```lean
   lemma _root_.SheafOfModules.exact_iff_stalkwise
       {C : Type*} [Category C] {J : CategoryTheory.GrothendieckTopology C}
       [HasForget C] {R : CategoryTheory.Sheaf J RingCat}
       (S : CategoryTheory.ShortComplex (SheafOfModules R)) :
       S.Exact ↔ ∀ x, (S.map (TopCat.Presheaf.stalkFunctor _ x ⋙ …)).Exact := by sorry
   ```
   (Signature decided by the prover; plan agent's `\lean{…}` macro should already
   point at this name from iter-081/082 prep work.)

3. **Prover closes `h_epi` via Mitigation Route 2 with `hη` available externally**:
   - `apply SheafOfModules.epi_of_epi_presheaf; rw [PresheafOfModules.epi_iff_surjective]; intro U`.
   - `algebraize [(φ_fg'.app U).hom, (φ_2'.app U).hom, (η.app U).hom]` (tactic from
     Mathlib.RingTheory.Algebraize). This sets up the Algebra + IsScalarTower instances
     properly, sidestepping the iter-082 `letI` re-elaboration breakage.
   - `convert _root_.KaehlerDifferential.map_surjective using 1` — identify the
     descent with `KaehlerDifferential.map` via the now-external `hη`. The unbundled
     vs. bundled gap is bridged by `algebraize` setting up the right instances.

4. **Prover closes `h_exact` via the new `exact_iff_stalkwise` helper**:
   - `apply (SheafOfModules.exact_iff_stalkwise _).mpr; intro x`.
   - Stalkwise reduces to `_root_.KaehlerDifferential.exact_mapBaseChange_map` (Mathlib).

**Sorry budget**: starts at 5; target 5 net (1-for-1 shift: `_structure` body sorry →
`exact_iff_stalkwise` body sorry). Stretch 5 → 4 if `exact_iff_stalkwise` body closes
via the stalk-functor chain in the same iteration.

**Hard constraints (preserve)**:
- Three project-local helpers permitted (after iter-083 refactor): `epi_of_epi_presheaf`
  (iter-079, closed), `Derivation.postcomp_comp` (iter-081, closed), `cotangentExactSeqBeta_hη`
  (iter-083 refactor, closed), `exact_iff_stalkwise` (iter-083 sorry body authorised).
  Total ≤ 4 helpers.
- Preserve `Derivation.postcomp_comp` byte-for-byte at L455–465.
- Preserve the iter-082 active `h_zero` Route (c) chain at L488–559 byte-for-byte.
- No new axioms. No `lean_run_code` pre-validation.

**Conditional clause (preserve)**: if Mitigation Route 2 STILL fails (i.e., even with
external `hη` and `algebraize`, the `convert KaehlerDifferential.map_surjective` mismatches),
do NOT introduce `exact_iff_stalkwise` as a free-floating sorry. Either close `_structure`
together with introducing the gap-fill, OR keep iter-082 state (the structurally narrower
`h_rest` sorry) and document.

**Alternative iter-083 path — Option C "stalkwise-only"** (if Option A blocks):

Drop the `KaehlerDifferential.map` identification entirely. Build only
`SheafOfModules.exact_iff_stalkwise` and use it to close BOTH `h_exact` AND
`h_epi`:
- `h_exact`: direct application.
- `h_epi`: stalkwise reduction to ring-level surjectivity (which follows from
  `KaehlerDifferential.map_surjective` at the **unbundled** ring level — no
  bundled/unbundled identification needed at the sheaf level).

This avoids the bundled-vs-unbundled typeclass barrier entirely, at the cost of
building stalkwise infrastructure (the helper body).

---

### 3. **Lane priority — `Modules/Monoidal.instIsMonoidal_W`: KEEP DEFERRED**

Mathlib gap (`PresheafOfModules.stalk_tensorObj` for varying-ring R₀) unchanged. Do
NOT assign this lane in iter-083. Phase C step C1 (LineBundle refactor) can proceed
independently; the sorry does not block downstream consumers.

**Long-term**: upstream Mathlib PR remains the structural fix.

---

## Reusable proof patterns surfaced this session

1. **`rw [show ... = ... from rfl]` re-fold for limit/iso transport** (iter-082, NEW).
   When `simp` exposes a `limit.isoLimitCone ⟨productCone, productConeIsLimit⟩` shape
   but downstream lemmas expect the API form `ModuleCat.piIsoPi …`, re-fold via
   `rw [show … = ModuleCat.piIsoPi … from rfl, …]`. **Use anonymous-constructor `⟨_,_⟩`,
   NOT brace `{cone := …, isLimit := …}` syntax** — the brace form conflicts with
   `show`-expression scoping.

2. **`piIsoPi_hom_ker_subtype_apply` to push j-projection past iso** (iter-082, reaffirmed).
   `(piIsoPi Z).hom x i = (Pi.π Z i) x`. After the re-fold pattern (#1 above), this lemma
   fires cleanly via direct `rw`. Useful in any cech-cohomology setup where you need to
   commute a product-iso past a component projection.

3. **Anti-pattern: `LinearMap.comp_apply` does NOT rewrite homogeneous `∘ₗ`**
   (iter-082, NEW). Mathlib's lemma is stated with the semilinear `∘ₛₗ` pattern. HOU fails
   to bridge to `∘ₗ` despite definitional equality. Workaround: name the comp via
   `let M : … →ₗ[k] … := …` BEFORE the simp that would expose it as a syntactic `∘ₗ`.

4. **Anti-pattern: `set_option maxHeartbeats N in` above a docstring** (iter-082, NEW).
   The annotation must sit BETWEEN the docstring and the `lemma` keyword. Misplacement
   triggers `unexpected token 'set_option'; expected 'lemma'`.

5. **`simp only [postcomp_d_apply] at hpt; exact hpt` (NOT `simpa`)** (iter-081,
   reaffirmed iter-082 in the inline `hβ_fac` proof). `simpa [postcomp_d_apply] using hpt`
   over-fires `Universal.fac`, collapsing `hpt` to `True`. The explicit `simp only` + `exact`
   form preserves the needed hypothesis shape.

---

## Blocked / off-limits (preserve)

- `Modules/Monoidal.instIsMonoidal_W` — Mathlib gap; iter-083+ defer.
- `Jacobian.nonempty_jacobianWitness` — Phase C step C3, iter-086+ earliest.
- `Picard/Functor.PicardFunctor.representable` — gated on Phase C C0–C3.
- BasicOpenCech L502, L826, L854 — confirmed dead-end substeps.
- BasicOpenCech L1285 `g_R.map_smul'`, L1314 `h_loc_exact` — downstream / needs
  `IsLocalizedModule.Away f.1` infra; iter-083+.
- Differentials L122 `relativeDifferentialsPresheaf_isSheaf`, L860 `smooth_iff_locally_free_omega`,
  L877 `cotangent_at_section`, L1019 `serre_duality_genus` — long-standing transients.

---

## Process note for the plan agent

The iter-076 → iter-082 trajectory on `Differentials.cotangentExactSeq_structure` is now
six iterations of attempting `h_epi` via various direct/inline routes (Route 1: iter-077;
Route A inline `d_target` matcher: iter-080; Route (c) + Route 2 inline: iter-081; Route 2
inline with refactored `letI`: iter-082). All inline approaches hit the same
bundled-vs-unbundled typeclass-coercion barrier. **Iter-083 should commit to the structural
refactor (Option A: extract `cotangentExactSeqBeta_hη` via the refactor subagent) before
the prover lane runs** — this is the only path that reliably sidesteps the typeclass
synthesis gap. The prover can then focus on the closing tactical work.

---

## Realistic iter-083 target

**Net −1 to −2 sorries** (12–13 active). Best-case path:
- **Lane 1**: Phase B closure via path (a) named-comp abbreviation. 6 → 5 in BasicOpenCech.
- **Lane 2**: Refactor-then-close via Option A. 5 → 5 net (1-for-1 shift via
  `exact_iff_stalkwise` helper), stretch 5 → 4 if helper body lands in the same iteration.

If only Lane 1 lands, **−1**. If both lanes land plus the stretch on Differentials, **−2**.
If iter-083 follows the same multi-route pattern as iter-076–082 on Lane 2, expect
**0** (no closure but minor structural advance — unacceptable; commit to one path).
