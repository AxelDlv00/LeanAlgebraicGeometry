# Refactor directive — iter-035 — tighten `affineCoverSystem.Cov` (correctness fix)

## File (write-domain)
`AlgebraicJacobian/Cohomology/AffineSerreVanishing.lean` ONLY.

## Why (do not skip — this is a correctness fix)
The iter-034 lean-auditor found that `affineCoverSystem.Cov` is currently the set of ALL finite basic-open
families, WITHOUT the covering condition `⨆ᵢ D(gᵢ) = D(f)`. That makes `HasVanishingHigherCech (affineCoverSystem R) F`
demand Čech vanishing over NON-covering families, which is FALSE for quasi-coherent sheaves (counterexample:
on `Spec k[x,y]`, the non-covering family `{D(x),D(y)}` has `Ȟ¹(O)≠0`). The downstream qcoh seed
`affine_cech_vanishing_qcoh` is therefore unprovable until `Cov` carries the covering condition. Fix the LEAN
(the blueprint prose is already correct). `affine_surj_of_vanishing` is NOT a protected signature — re-signing
it is permitted and required.

## Exact edits

### Edit 1 — re-sign `affine_surj_of_vanishing` (currently ~line 228) so `hvanish` is quantified ONLY over covering families
Change the `hvanish` hypothesis from
```lean
    (hvanish : ∀ (n : ℕ) (g : Fin n → R) (q : ℕ), 0 < q →
      IsZero (cechCohomology (fun i : ULift.{u} (Fin n) => PrimeSpectrum.basicOpen (g i.down))
        ((Scheme.Modules.toPresheafOfModules (Spec R)).obj S.X₁) q))
```
to (add a `(f' : R)` and a covering-witness premise, in ULift `⨆` form):
```lean
    (hvanish : ∀ (n : ℕ) (g : Fin n → R) (f' : R),
      (PrimeSpectrum.basicOpen f' : (Spec R).Opens)
        = ⨆ i : ULift.{u} (Fin n), PrimeSpectrum.basicOpen (g i.down) →
      ∀ (q : ℕ), 0 < q →
        IsZero (cechCohomology (fun i : ULift.{u} (Fin n) => PrimeSpectrum.basicOpen (g i.down))
          ((Scheme.Modules.toPresheafOfModules (Spec R)).obj S.X₁) q))
```
Leave the rest of the signature (the `S`, `hS`, `f`, and conclusion) UNCHANGED.

### Edit 2 — fix the single call site inside that proof (currently line 317)
The proof already has in scope:  `hV₀ : V₀ = PrimeSpectrum.basicOpen f`,  `hU : U = fun i => PrimeSpectrum.basicOpen (g i.down)`,
and  `hUsup : ⨆ i, U i = V₀`.  So a covering witness `PrimeSpectrum.basicOpen f = ⨆ i, PrimeSpectrum.basicOpen (g i.down)`
is obtainable. Change line 317 from
```lean
  have hH1 : IsZero ((sectionCechComplex U FX).homology 1) := hvanish n g 1 one_pos
```
to
```lean
  have hcovf : (PrimeSpectrum.basicOpen f : (Spec R).Opens)
      = ⨆ i : ULift.{u} (Fin n), PrimeSpectrum.basicOpen (g i.down) := by
    rw [← hV₀, ← hUsup]
  have hH1 : IsZero ((sectionCechComplex U FX).homology 1) := hvanish n g f hcovf 1 one_pos
```
(If `rw [← hV₀, ← hUsup]` leaves a residual `⨆ i, U i` vs `⨆ i, D(g i.down)` mismatch, close it with `rw [hU]`
or `simp only [hU]` — `U i` is DEFINITIONALLY `PrimeSpectrum.basicOpen (g i.down)`. Adjust as the goal requires.)

### Edit 3 — tighten `affineCoverSystem.Cov` (currently ~line 363) and thread the witness through the three field proofs
Change the `Cov` field from
```lean
  Cov := { c : CovDatum (Spec R) | ∃ (n : ℕ) (g : Fin n → R),
    c = ⟨ULift.{u} (Fin n), fun i => PrimeSpectrum.basicOpen (g i.down)⟩ }
```
to
```lean
  Cov := { c : CovDatum (Spec R) | ∃ (n : ℕ) (g : Fin n → R) (f : R),
    c = ⟨ULift.{u} (Fin n), fun i => PrimeSpectrum.basicOpen (g i.down)⟩ ∧
    (PrimeSpectrum.basicOpen f : (Spec R).Opens)
      = ⨆ i : ULift.{u} (Fin n), PrimeSpectrum.basicOpen (g i.down) }
```
Then update the three field proofs' `rintro` patterns to destructure the new 5-component membership
`⟨n, g, f, rfl, hcov⟩` (was `⟨n, g, rfl⟩`):

- `faces_mem`:  `rintro c ⟨n, g, rfl⟩ p σ`  →  `rintro c ⟨n, g, f, rfl, hcov⟩ p σ`  (body unchanged; `hcov`, `f` unused).
- `injective_acyclic`:  `rintro I hI c ⟨n, g, rfl⟩ q hq`  →  `rintro I hI c ⟨n, g, f, rfl, hcov⟩ q hq`  (body unchanged).
- `surj_of_vanishing`: change
  ```lean
  surj_of_vanishing := by
    rintro S hSE hvanish V ⟨f, rfl⟩
    refine affine_surj_of_vanishing S hSE (fun n g q hq => ?_) f
    exact hvanish ⟨ULift.{u} (Fin n), fun i => PrimeSpectrum.basicOpen (g i.down)⟩ ⟨n, g, rfl⟩ q hq
  ```
  to
  ```lean
  surj_of_vanishing := by
    rintro S hSE hvanish V ⟨f, rfl⟩
    refine affine_surj_of_vanishing S hSE (fun n g f' hcov q hq => ?_) f
    exact hvanish ⟨ULift.{u} (Fin n), fun i => PrimeSpectrum.basicOpen (g i.down)⟩
      ⟨n, g, f', rfl, hcov⟩ q hq
  ```
  (Here the field's `hvanish` is `∀ c ∈ Cov, ∀ q, 0<q → IsZero …`; feeding it the membership witness
  `⟨n, g, f', rfl, hcov⟩` against the new `Cov` discharges the new covering premise of `affine_surj_of_vanishing`.)

## Verification (REQUIRED)
- Run `lake env lean AlgebraicJacobian/Cohomology/AffineSerreVanishing.lean` and confirm EXIT 0, diagnostics empty.
- Confirm there is NO `sorry` introduced. These are mechanical signature/witness edits with the exact
  replacement code given above — apply them verbatim and adjust only the minor `rw`/`simp only [hU]` plumbing
  in Edit 2 if the goal state requires. Do NOT leave a `sorry`; if any edit genuinely will not compile after
  reasonable plumbing, STOP and report the exact goal state rather than inserting `sorry`.
- Report `#print axioms AlgebraicGeometry.affineCoverSystem` and `…affine_surj_of_vanishing`
  (expect `{propext, Classical.choice, Quot.sound}`).

## Out of scope
Do NOT touch any other declaration, the blueprint, or any other file. Do NOT change the `B` field or the
`injective_acyclic`/`faces_mem` proof BODIES (only their `rintro` patterns).
