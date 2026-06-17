# AlgebraicJacobian/Differentials.lean

## Session summary (iter-122)

**Starting state**: 4 sorries (L109 algebra-instance letI, L112 `appLE_isLocalization`
body, L142 module-instance letI, L145 bridge body).

**Ending state**: 1 sorry (the main `appLE_isLocalization` body, L282) — down from 4.

**Net change**: **−3 sorries**, +6 fully proved declarations (helpers + factorisation +
bridge body + Step 0 unit-transport lemma + M1.c/M1.d).

File compiles cleanly (only the documented `sorry` warning at L282).

## Resolved sorries

### L109 — `Algebra Γ(S, U) A_colim` letI (RESOLVED, via `archon-lean4:lean4-sorry-filler-deep`)
Replaced by a `noncomputable def appLE_colimAlgebra` built from the new helper
`appLE_colimRingHom`. The instance is now provided by a top-level reducible def,
not an inline `sorry`-ed `letI`.

### L142 — `Module Γ(X, V)` letI on the presheaf section (RESOLVED)
Replaced by `inferInstanceAs (Module Γ(X, V) (((relativeDifferentialsPresheaf f).obj (.op V)) : Type _))` —
the PresheafOfModules structure provides the module instance.

### L145 — bridge body M1.e (RESOLVED, modulo M1.b)
The body of `relativeDifferentialsPresheaf_equiv_kaehler_appLE` is fully closed via
`(kaehler_quotient_localization_iso M).symm` — leveraging the `IsScalarTower` from
`IsScalarTower.of_algebraMap_eq'` plus the new `appLE_colimRingHom_comp_φV`
factorisation. The proof goes through *as soon as* `appLE_isLocalization` is closed.

### L164 — `isUnit_appLE_unitSubmonoid_in_colim` Step 0 lemma (RESOLVED, this session)
**Strategy**: For `g ∈ M` (so `(appLE f).hom g` is a unit in `Γ(X, V)`):
1. From `Scheme.basicOpen_of_isUnit` + `Scheme.basicOpen_appLE`, derive
   `V ≤ f ⁻¹ᵁ (S.basicOpen g)`.
2. Build the cocone leg `cleg : Γ(S, S.basicOpen g) ⟶ A_colim` (unit of the
   pullback/pushforward adjunction at `op (S.basicOpen g)` composed with the
   restriction along `(homOfLE hVle).op`).
3. Prove `hcompat : appLE_colimRingHom f e = rstr ≫ cleg` where `rstr` is the
   restriction `Γ(S, U) → Γ(S, S.basicOpen g)`. This is a naturality + functoriality
   argument: factor `homOfLE e = homOfLE hVle ≫ homOfLE hpreLe` (with
   `hpreLe : f ⁻¹ᵁ S.basicOpen g ≤ f ⁻¹ᵁ U`), use `Functor.map_comp` to split
   `Pf.map (homOfLE e).op` into a composition, then apply naturality of the
   adjunction unit at `homOfLE (S.basicOpen_le g).op`.
4. By `IsAffineOpen.isLocalization_basicOpen hU g`, `Γ(S, S.basicOpen g)` is
   `IsLocalization.Away g`, so `algebraMap g` is a unit there
   (`IsLocalization.Away.algebraMap_isUnit`).
5. Push through `cleg` (ring homs preserve units) to conclude `g` is a unit
   in `A_colim`.

**Total LOC**: ~70 lines.

## Helper lemmas (added by deep prover, fully proved)

- `appLE_colimRingHom` (def, L97) — canonical map `Γ(S, U) → A_colim`.
- `appLE_colimAlgebra` (reducible def, L106) — the algebra structure from
  `(appLE_colimRingHom f e).hom.toAlgebra`.
- `appLE_colimRingHom_comp_φV` (theorem, L116) — factorisation
  `appLE_colimRingHom ≫ φV = appLE`, the cocone-leg triangle.
- `kaehler_localization_subsingleton` (theorem) — M1.c, the subsingleton
  conclusion via `Algebra.FormallyUnramified.of_isLocalization`.
- `kaehler_quotient_localization_iso` (def) — M1.d, tower-cancellation
  `Ω[B/A] ≃ₗ[B] Ω[B/L]` (the most extractable Mathlib-contribution candidate;
  candidate name `KaehlerDifferential.equivOfFormallyUnramified`).

## Remaining sorry

### L282 — `appLE_isLocalization` body (the main M1.b)
The full four-step `IsLocalization.of_le` construction:
- Step 0 (`isUnit_appLE_unitSubmonoid_in_colim`): **DONE** ✓
- Step 1: `A_M → A_colim` via `IsLocalization.lift` (using Step 0). **TODO**
- Step 2: `A_colim → A_M` via the colimit universal property + basic-open
  refinements (each `Γ(S, W) → A_M` for `f V ⊆ W ⊆ U` factors through some
  `Γ(S, D(g)) = (Γ(S, U))_g` via quasi-compactness of `f V`). **TODO**
- Step 3: Composites are identities (`IsLocalization.ringHom_ext` +
  `IsColimit.hom_ext` on the colimit cocone). **TODO**
- Step 4: `IsLocalization.isLocalization_of_algEquiv` from the resulting
  `Localization M ≃ₐ[Γ(S, U)] A_colim`. **TODO**

**Estimated remaining LOC**: 100-250 (originally estimated 200-400 for the
whole M1.b, of which Step 0 alone took ~70 LOC — so the remaining four steps
are estimated at 100-250 LOC).

**Next-session next step**: build the `Localization M → A_colim` map first
(Step 1, easiest; uses the just-closed Step 0). Then tackle Step 2 (hardest).

## Sorry trajectory

| Stage | sorries in file |
|---|---|
| Before iter-122 prover lane | 4 |
| After deep-prover subagent | 2 (L164 Step 0 + L282 M1.b body) |
| After this session | **1** (L282 M1.b body) |

**Project total**: 5 → 2 (Differentials.lean: 1, Jacobian.lean: 1 unchanged).

## Mathlib API discovered/confirmed

- `Scheme.basicOpen_appLE` (in `Mathlib.AlgebraicGeometry.Scheme`):
  `X.basicOpen ((f.appLE V U e).hom s) = U ⊓ f ⁻¹ᵁ (Y.basicOpen s)`.
- `Scheme.basicOpen_of_isUnit`: `IsUnit f → X.basicOpen f = U`.
- `Scheme.basicOpen_le`: `X.basicOpen f ≤ U`.
- `IsAffineOpen.isLocalization_basicOpen`: produces `IsLocalization.Away f` for
  the basic-open-section algebra.
- `Scheme.algebra_section_section_basicOpen` (instance): the canonical `Algebra`
  structure on the basic-open section ring, which makes the above predicate
  type-check.
- `IsLocalization.Away.algebraMap_isUnit`: the element is a unit under the
  algebra map.

## Technical lessons (this session)

1. **`rw [Functor.map_comp]` fails on `((TopCat.Presheaf.pullback _ _).obj _).map (f ≫ g)`**
   despite the pattern being literally present. Likely due to category-instance
   metadata mismatch under the `Lan`-defined functor. Workaround: pre-prove
   `hmc : self.map (f ≫ g) = self.map f ≫ self.map g` as a `have` via
   `Functor.map_comp _ _ _`, then use `erw [hmc]` (`erw` succeeds where `rw`
   fails for these unification edge-cases).
2. **`rw [Category.assoc]` similarly fails** under category instance metadata
   noise. Workaround: use `exact Category.assoc _ _ _` directly when the goal
   is exactly the associativity equation.
3. **`show`/`change` on `algebraMap` doesn't work** even when the algebra
   instance is `appLE_colimAlgebra := φ.hom.toAlgebra` (which should make
   `algebraMap = φ.hom` definitionally). Workaround: route the conclusion
   through `IsUnit ((appLE_colimRingHom f e).hom g)` first via a `have h_factor`,
   then `exact` the result — Lean's elaboration of `IsUnit` and the algebra
   instance aligns when the term is `exact`-ed rather than `change`-d.
4. **`adj.unit.naturality` produces an equation involving the identity functor**
   `((𝟭 _).obj _)`; use `simpa using` to clean it up.

## Status

**PARTIAL** — meeting and exceeding the iter-122 plan's "PARTIAL is acceptable"
target. The most surprising achievement is closing the M1.e bridge body (L145)
modulo M1.b, which the plan agent had labelled "secondary, lower priority"; this
was made possible by the Step 0 closure giving the bridge a `localization`
hypothesis to use.

The remaining sorry is the M1.b core (Steps 1-4), which requires presheaf-level
cofinality machinery and is estimated at 100-250 LOC. Ready for an iter-123
prover lane.

## Blueprint marker recommendations (for review agent)

- `lem:appLE_isLocalization` (L153 in `Differentials.tex`) — still has 1 sorry,
  do NOT mark `\leanok` on the proof; the **statement** is formalized (the
  theorem signature is in place), so `\leanok` on the statement is correct.
- `def:appLE_unitSubmonoid` (not in blueprint yet? — has a fully-proved def
  but the blueprint lemma title is `lem:appLE_isLocalization`). The
  `appLE_unitSubmonoid` def is the M itself, which the blueprint introduces in
  M1.a paragraph at L130-135 (no separate lemma label). No marker change.
- `lem:kaehler_localization_subsingleton` (L188) — **fully proved**, mark `\leanok`
  on both statement and proof.
- `lem:kaehler_quotient_localization_iso` (L199) — **fully proved**, mark `\leanok`
  on both statement and proof.
- `thm:relativeDifferentialsPresheaf_equiv_kaehler_appLE` (L113) — fully proved
  *modulo* `appLE_isLocalization` (which is invoked as a hypothesis), so the
  proof is technically not yet `\leanok`-able (depends on a sorry). Statement
  is `\leanok`-able. Project policy: `sync_leanok` will detect the transitive
  sorry and leave `\leanok` off the proof — this is correct.

## Files changed

- `AlgebraicJacobian/Differentials.lean` (only file modified).
