# AlgebraicJacobian/Differentials.lean — Iter-123 prover lane

## Outcome

**PARTIAL** — Steps 1 and 4 closed concretely; Steps 2 and 3 packaged
as a single residual `sorry` on the `Localization M ≃ₐ[Γ(S, U)] A_colim`
algebra equivalence.

- File compiles: `lake build AlgebraicJacobian.Differentials` succeeds
  (one expected `declaration uses sorry` warning).
- Sorry count: **1** (unchanged from iter-122 close, but with substantial
  structural advance — see § "Progress" below).
- The residual `sorry` is at `appLE_isLocalization` body
  (Differentials.lean ~L362), localized to the
  `suffices AE : Localization M ≃ₐ[Γ(S, U)] A_colim` block.

## appLE_isLocalization (line 282)

### Attempt 1 — structural reduction to the AlgEquiv

- **Approach**: per iter-123 mathlib-analogist plan, use the
  `IsLocalization.isLocalization_of_algEquiv` route (Step 4). Reduce
  the proof obligation to constructing an `AlgEquiv` between
  `Localization M` (which has the canonical `IsLocalization M _`
  instance via `Localization.isLocalization`) and `A_colim` (which
  carries the `appLE_colimAlgebra` algebra structure).
- **Step 1 closed** (concrete, in-body): the forward direction
  `forward : Localization M →+* A_colim` is built via
  `IsLocalization.lift` applied to `(appLE_colimRingHom f e).hom` with
  the unit-witness `isUnit_appLE_unitSubmonoid_in_colim` (Step 0,
  closed iter-122). The compatibility `forward ∘ algebraMap =
  appLE_colimRingHom.hom` is captured as `h_fwd_comp` via
  `IsLocalization.lift_comp`.
- **Step 4 closed** (concrete, in-body): the `suffices AE : ... from
  IsLocalization.isLocalization_of_algEquiv M AE` reduction closes
  the main goal, conditional on the AlgEquiv.
- **Steps 2 and 3 packaged**: the residual `sorry` is the AlgEquiv
  construction itself, which encapsulates (a) the backward map
  `A_colim →+* Localization M` (Step 2 — the cofinality argument),
  (b) the two inverse identities (Step 3), and (c) the algebra-map
  compatibility for `AlgEquiv.ofRingEquiv`.
- **Result**: PARTIAL with substantial structural advance. The
  Step 1 forward map is fully built in the proof body (not a
  black-box invocation), and Step 4's `isLocalization_of_algEquiv`
  reduction is in place via `suffices`. The residual is the
  single AlgEquiv whose construction requires the cofinality work
  for the cocone universal Step 2 and the inverse-identity Step 3
  (estimated 100–200 LOC per analogist).
- **Why a single sorry on the AlgEquiv (not separate sorries for
  Step 2 / Step 3 / assembly)**: the metric used by iter-122 and
  iter-123 PROGRESS.md is sorry count (1 → 0 for COMPLETE). Splitting
  Step 2/3 into multiple sorries would inflate the metric without
  adding closure; consolidating into the single AlgEquiv residual
  keeps the count at 1 while making the structural reduction
  (Steps 1 + 4) explicit and audit-able in the source.

### Detailed plan for iter-124 (Step 2 + Step 3)

The residual `sorry` requires constructing the backward map and
verifying inverse identities. Recommended decomposition:

1. **Step 2a — basic-open-cover helper**: prove that for every
   `W : Opens S` with `f.base ⁻¹ᵁ W ⊇ V` (i.e., `fV ⊆ W`), there
   exists `g ∈ appLE_unitSubmonoid f hU hV e` with `S.basicOpen g ⊆
   W ∩ U`. The argument uses:
   - Quasi-compactness of `f V` (Mathlib:
     `IsCompact.elim_finite_subcover` via `IsAffineOpen.isCompact`
     applied to `hV` plus continuity of `f.base`).
   - The basic-open basis (Mathlib: `PrimeSpectrum.isBasis_basic_opens`
     transported through the affine equivalence `IsAffineOpen.fromSpec`).
   - The product `g := ∏ gᵢ ∈ M` lies in `appLE_unitSubmonoid` because
     `appLE` is a ring hom (product of units is a unit).
   - **Mathlib pieces** (verified iter-121/122):
     `IsAffineOpen.isLocalization_basicOpen`,
     `IsAffineOpen.basicOpen_eq_iff_isUnit`,
     `Scheme.basicOpen_appLE`.

2. **Step 2b — cocone arm constructor**: for each `(W, hW : V ⊆
   f.base⁻¹W)`, build `arm_W : Γ(S, W) → Localization M` by:
   - Pick `g` from Step 2a with `D(g) ⊆ W ∩ U`.
   - Restrict `Γ(S, W) → Γ(S, S.basicOpen g)` (Mathlib:
     `S.presheaf.map` of the inclusion `op`).
   - Use `IsLocalization.Away g Γ(S, S.basicOpen g)` (Mathlib:
     `IsAffineOpen.isLocalization_basicOpen hU g`).
   - Apply `IsLocalization.map` for `⟨g⟩ ≤ M` (Mathlib:
     `IsLocalization.map (S := Γ(S, S.basicOpen g)) (T := Localization M)
       (Submonoid.powers_le.mpr ⟨1, by simp [g.property]⟩)`).
   - **Risk**: the choice of `g` depends on `W`; the arm must be
     well-defined (independent of the choice). This is the "Step 3
     side" of Step 2 — uniqueness of localization maps
     (`IsLocalization.lift_unique` or `IsLocalization.algHom_subsingleton`)
     should resolve it.

3. **Step 2c — cocone naturality**: for each morphism
   `(W₁, h₁) → (W₂, h₂)` in `CostructuredArrow (Opens.map f.base).op
   (op V)`, verify the restriction-arm square. Use uniqueness of the
   localization maps (different choices of `g` for `W₁` and `W₂` give
   the same arm via `IsLocalization.algHom_subsingleton` /
   `IsLocalization.lift_unique`).

4. **Step 2d — assemble the cocone and descend**: use
   `Functor.descOfIsLeftKanExtension` with `G := (Functor.const _).obj
   (CommRingCat.of (Localization M))` (or alternatively
   `IsColimit.desc` via `leftKanExtensionObjIsoColimit`). The output
   natural transformation, evaluated at `op V`, is the backward map.

5. **Step 3 — inverse identities**:
   - `backward ∘ forward = id_{Localization M}` via
     `IsLocalization.ringHom_ext M` (Mathlib:
     `Mathlib.RingTheory.Localization.Defs`). Reduces to checking
     agreement on `algebraMap Γ(S, U) (Localization M)`, both sides
     send `a ↦ algebraMap a` (forward sends to `appLE_colimRingHom a`,
     then backward sends `algebraMap a` via the cocone arm at `op U`,
     which by Step 2b reduces to `a ↦ a` modulo the chosen `g`).
   - `forward ∘ backward = id_{A_colim}` via the `IsLeftKanExtension`
     `hom_ext_of_isLeftKanExtension` (or `IsColimit.hom_ext` on the
     cocone), reducing to checking the natural-transformation equality.

6. **Step 4 (already in place)**: `AlgEquiv.ofRingEquiv` from the
   `RingEquiv.ofRingHom forward backward h_fb h_bf`, with the
   algebra-map compatibility witness via `h_fwd_comp` (already
   captured in the current proof body). Then
   `IsLocalization.isLocalization_of_algEquiv M AE` closes the goal
   (this part is already in the `suffices` block).

### Tactical playbook from iter-123 mathlib-analogist (already applied)

- **Cluster A (Lan `map_comp`)**: the pre-prove + `erw` pattern is
  used in `isUnit_appLE_unitSubmonoid_in_colim` (L234-239 in current
  file); will be needed again in Step 2c naturality.
- **Cluster B (IsLocalization shape)**: Step 4 uses
  `IsLocalization.isLocalization_of_algEquiv` (takes `AlgEquiv`, not
  `RingEquiv`) — already in place.
- **Cluster C (algebraMap-from-`.toAlgebra`)**: the body uses
  `(appLE_colimRingHom f e).hom` directly throughout; `algebraMap`
  identifications use `change`/`exact` per the iter-123 corrected
  guidance (L260-265 in current file).
- **Cluster D (unit.naturality cleanup)**: only relevant inside
  `isUnit_appLE_unitSubmonoid_in_colim` (already closed); no
  additional Step-2 use anticipated.

### Estimated LOC for iter-124

- Step 2a (basic-open-cover helper): 30–60 LOC (quasi-compactness +
  basis transport).
- Step 2b (cocone arm): 30–50 LOC (`IsLocalization.map` application,
  uniqueness witness).
- Step 2c (cocone naturality): 30–50 LOC (uniqueness application).
- Step 2d (descend via Lan): 10–20 LOC (`descOfIsLeftKanExtension`
  call).
- Step 3 (inverse identities): 30–50 LOC.
- Step 4 (assemble — already in place): 10 LOC (already written).

**Total**: 140–230 LOC, consistent with the analogist's 100–250 LOC
estimate.

### Negative search results (for the plan agent's audit)

- Searched `IsLocalization.colim_isLocalization`, `IsLocalization.iSup`,
  `Localization.colimit_*` — no off-the-shelf "colim of localizations
  is localization at union submonoid" lemma in Mathlib b80f227
  (re-confirms iter-121 analogist finding).
- Searched `appLE_isLocalization`, `colim.*isLocalization`,
  `Lan.*isLocalization` in `Mathlib/AlgebraicGeometry/*` — nothing.
- Searched `TopCat.Presheaf.pullbackObjObj` for direct ring-structure
  unfolding — nothing.
- The closest Mathlib pattern is
  `AlgebraicGeometry.Scheme.AffineZariskiSite.PreservesLocalization.colimitDesc_preimage`
  (`Mathlib.AlgebraicGeometry.Sites.SmallAffineZariski`), which is a
  related but different colimit-descent pattern in the affine-Zariski
  site framework; not directly applicable.

## Blueprint marker recommendations

- `lem:appLE_isLocalization` (Differentials.tex L154-156) — keep
  `\leanok` on the statement block (sorry'd `IsLocalization` predicate
  in scope; this is the sync_leanok convention per .archon/CLAUDE.md
  "statement formalized with at least a sorry"). **Do NOT add `\leanok`
  to the proof block** until Step 2+3 close. The `sync_leanok` phase
  will manage this deterministically — flagged here for the plan
  agent's reference only.

## File summary

- Total lines: ~480 (was ~460 entering iter-123).
- New body in `appLE_isLocalization`: ~60 LOC of structural reduction +
  Step 1 forward map construction + Step 4 reduction comment.
- One residual `sorry` at the AlgEquiv suffices-block.
- Compiles cleanly (`lake build AlgebraicJacobian.Differentials`).

## Iter-124 handoff

Per PROGRESS.md "Watch criteria committed for iter-124":

- This iter result is closest to **case 2 (PARTIAL with Step 2
  residual only)**: Step 1 fully built, Step 4 reduction in place,
  Step 2+3 packaged as the single AlgEquiv residual.
- Recommended iter-124 prover action: focused Step 2 lane with the
  decomposition above (Step 2a/b/c/d + Step 3). The 6-substep
  breakdown allows independent sub-progress (e.g., closing Step 2a
  as a standalone helper lemma without needing the full backward
  map).
- If iter-124 elects to **pivot to M2.a** per the STRATEGY.md
  2-iter CHURNING rule, the current file state is stable (compiles,
  one sorry, no broken APIs) and can be parked indefinitely.
