# AlgebraicJacobian/RiemannRoch/OCofP.lean

## Session summary

iter-197 Lane A — substrate-build for `functionField_const_of_complete_curve_of_orderZero` (prover-mode: mathlib-build, helper budget = 3). HARD BAR met + PUSH-BEYOND (ii) substrate landed.

- Added 3 axiom-clean substrate helpers (full helper budget used):
  - `Scheme.lineBundleAtClosedPoint.localLift_of_log_ordFrac_eq_zero` (lines ~1356–1396)
  - `Scheme.lineBundleAtClosedPoint.algebraMap_bijective_of_finite_isDomain_isAlgClosed` (lines ~1398–1414)
  - `Scheme.lineBundleAtClosedPoint.functionField_localUnit_of_orderZero_at_primeDivisor` (lines ~1416–1442)
- Modified body of `functionField_const_of_complete_curve_of_orderZero` (line ~1492) to extract `stalkLift : ∀ Q, ∃ a, IsUnit a ∧ algebraMap _ K(C) a = f` via the per-stalk substrate helper, before the (still-typed) sorry.
- Sorry count unchanged: 3 → 3 (substrate added in parallel; the parent sorry on global Hartogs + Γ=k̄ gluing remains).
- Build GREEN; no new axioms; only kernel axioms `{propext, Classical.choice, Quot.sound}` on the new declarations.

## `localLift_of_log_ordFrac_eq_zero` (~line 1369)

- **Approach:** Pure ring-theoretic local DVR step. Bridge `WithZero.log y = 0` to `y = 1` (using `WithZero.log_le_log` antisymmetrically) then invoke Mathlib's `Ring.mker_ordFrac_eq_isUnitSubmonoid` (the DVR-specific identification of `MonoidHom.mker (ordFrac R)` with the image of `IsUnit.submonoid R` in `K`).
- **Result:** RESOLVED — axiom-clean. Verified via `lean_verify`: `{propext, Classical.choice, Quot.sound}`.
- **Statement:** for `[CommRing R] [IsDomain R] [IsDiscreteValuationRing R]` and `[Field K] [Algebra R K] [IsFractionRing R K]`, `x ≠ 0` plus `WithZero.log (Ring.ordFrac R x) = 0` implies `∃ r : R, IsUnit r ∧ algebraMap R K r = x`.

## `algebraMap_bijective_of_finite_isDomain_isAlgClosed` (~line 1409)

- **Approach:** Direct re-export of Mathlib's `IsAlgClosed.algebraMap_bijective_of_isIntegral` against the finite-implies-integral instance `Algebra.IsIntegral.of_finite`. Bundled as project-local lemma to isolate sub-helper (ii) ingredient (the Hartshorne I.3.4 algebraic kernel "no finite extensions of an alg-closed field").
- **Result:** RESOLVED — axiom-clean.
- **Statement:** for `[Field k] [IsAlgClosed k]` and `[CommRing R] [IsDomain R] [Algebra k R] [Module.Finite k R]`, `algebraMap k R` is bijective.

## `functionField_localUnit_of_orderZero_at_primeDivisor` (~line 1431)

- **Approach:** Scheme-level wrapper. Unfold `Scheme.RationalMap.order Q f = WithZero.log (Ring.ordFrac (stalk Q.point) f)` and invoke `localLift_of_log_ordFrac_eq_zero` against the DVR stalk supplied by `[Scheme.IsRegularInCodimensionOne X]`. The bridge instances `instIsFractionRingCarrierStalkCommRingCatPresheafFunctionField` and `Scheme.IsRegularInCodimensionOne.instIsDiscreteValuationRingStalk` make typeclass synthesis fire end-to-end.
- **Result:** RESOLVED — axiom-clean.
- **Statement:** for an `IsIntegral X`, `IsLocallyNoetherian X`, `Scheme.IsRegularInCodimensionOne X` scheme and prime divisor `Q`, `f ≠ 0` plus `Scheme.RationalMap.order Q f = 0` implies `∃ a : X.presheaf.stalk Q.point, IsUnit a ∧ algebraMap _ X.functionField a = f`.

## `functionField_const_of_complete_curve_of_orderZero` (line ~1492)

- **Approach:** Body now extracts the per-prime-divisor stalk lift `stalkLift : ∀ Q, ∃ a, IsUnit a ∧ algebraMap (stalk Q) K(C) a = f` via the new helper `functionField_localUnit_of_orderZero_at_primeDivisor`. This brings the goal into the form "given per-stalk regularity at every codim-1 point, conclude `f = algebraMap kbar K(C) c` for some `c`". The remaining sorry is the GLOBAL Hartogs gluing step + Γ=k̄ step (both Mathlib gaps).
- **Result:** PARTIAL — body has substantive structural advance; sorry remains on the algebraic-Hartogs gluing step.
- **Why the parent stays open this iter:** the gluing step `Γ(X, 𝒪_X) = ⋂_{Q codim 1} 𝒪_{X, Q}` (Stacks 0BCK, the heart of algebraic Hartogs) is not in Mathlib. Independently, the Γ=k̄ step needs `Module.Finite kbar Γ(C, 𝒪_C)` (Hartshorne III.5.2 cohomology substrate, also Mathlib gap).

## Summary

- **Declarations added:** 3 new axiom-clean private helpers (`localLift_of_log_ordFrac_eq_zero`, `algebraMap_bijective_of_finite_isDomain_isAlgClosed`, `functionField_localUnit_of_orderZero_at_primeDivisor`).
- **Sorry count before → after:** 3 → 3 (file-level; substrate added in parallel without closing the parent sorry).
- **Helpers used vs. budget:** 3 / 3.
- **Axiom signatures:** all three new helpers verified `{propext, Classical.choice, Quot.sound}` only. Parent helper `functionField_const_of_complete_curve_of_orderZero` axiom set `{propext, sorryAx, Classical.choice, Quot.sound}` (unchanged shape — `sorryAx` from the remaining typed sorry).

## Why I stopped

`Real progress`: 3 axiom-clean substrate declarations landed (named above), with `functionField_const_of_complete_curve_of_orderZero` body advanced to extract per-stalk witnesses before the remaining sorry. HARD BAR met (sub-helper (i) "algebraic Hartogs at codim-1" — local DVR + per-stalk lift substrate, axiom-clean). PUSH-BEYOND partially met (sub-helper (ii) "Γ=k̄" algebraic kernel landed; the cohomology substrate `Module.Finite kbar Γ(C, 𝒪_C)` remains a Mathlib gap).

`Blocked — alternatives exhausted (for full parent closure)`:

- **What was tried for full closure:** Mathlib search via `lean_leansearch` for direct algebraic-Hartogs, normal-scheme global sections, `IsNormalScheme` intersection-of-localizations. No direct result; the algebraic-Hartogs gluing (Stacks 0BCK, normal Noetherian: `Γ(X, 𝒪_X) = ⋂_Q 𝒪_{X,Q}`) is a project-bespoke gap.
- **What blocks the parent close:** the global "per-stalk lifts ⟹ global section of 𝒪_X" step. Even on integral schemes with all the regularity hypotheses, Mathlib (snapshot `b80f227`) does not ship the bridge `Γ(X, 𝒪_X) = ⋂_Q algebraMap (stalk Q) K(X).range`. The Γ=k̄ direction additionally needs `Module.Finite kbar Γ(C, 𝒪_C)` (Hartshorne III.5.2; not shipped).
- **Exact type statement of the next needed ingredient (substrate gap for iter-198+):**
  ```
  -- (i) Hartogs gluing:
  -- Given X integral, locally Noetherian, IsRegularInCodimensionOne, and
  -- f : X.functionField with `∀ Q : X.PrimeDivisor, ∃ a : X.presheaf.stalk Q.point,
  --   algebraMap (stalk Q) X.functionField a = f`, produce
  -- `∃ s : ↥(X.presheaf.obj (op ⊤)),
  --   (X.germToFunctionField (⊤ : X.Opens)).hom (germ s) = f`.

  -- (ii) Finite-dimensionality bridge:
  -- On `C : Over (Spec (.of kbar))` with `[IsProper C.hom]`,
  -- `[GeometricallyIrreducible C.hom]`, `[IsIntegral C.left]`,
  -- produce `Module.Finite kbar ↥(C.left.presheaf.obj (op ⊤))`.
  -- Once both land, `functionField_const_of_complete_curve_of_orderZero`
  -- closes via:
  --   stalkLift (already in scope)
  --   → hartogsGlue stalkLift   -- (i)
  --   → algebraMap_bijective_of_finite_isDomain_isAlgClosed  -- (ii)
  ```
- **Iter-198+ milestone (per PROGRESS.md):** parent sorry closes after both sub-helpers (i) gluing + (ii) `Module.Finite kbar Γ` land. Helper budget for iter-197 (= 3) fully consumed.

`Approaches written but not attempted`: None — both sub-helpers (i) and (ii) were attempted via search; for (i) the full algebraic-Hartogs gluing requires substrate that is genuinely absent from Mathlib (verified by Stacks 0BCK / Mathlib search); for (ii) the abstract algebra kernel is landed and the remaining cohomology substrate is gated outside this file.

`Infrastructure already exists`: Mathlib's `Ring.mker_ordFrac_eq_isUnitSubmonoid` and `IsAlgClosed.algebraMap_bijective_of_isIntegral` were the key existing pieces leveraged by the new helpers.
